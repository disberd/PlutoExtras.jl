"""
    EditableTable(df::DataFrame; kwargs...) -> EditableTable

An interactive, paginated table widget for Pluto notebooks backed by a `DataFrame`.
Rendered with [Tabulator.js](https://tabulator.info/) and designed to be used with
`@bind`; the bond value is always the current (mutated) `DataFrame`.

# Keyword Arguments
- `col_options`: Per-column [Tabulator column-definition](https://tabulator.info/docs/5.5/columns)
  overrides, keyed by `Symbol` column name.
  Example: `Dict(:score => Dict(:editor => "number", :width => 80))`.
- `default_row`: Cell values used when a new row is appended, keyed by `Symbol` column
  name. Columns not listed here fall back to type-based defaults:
  `missing` (nullable), `zero(T)` (numbers), `""` (strings), `false` (bools).
- `page_size`: Number of rows per page (default `50`).
- `height`: CSS height of the table container (default `"300px"`).
- `allow_add`: Show the *+ Add Row* footer button (default `true`).
- `allow_edit`: Enable in-cell editing (default `true`). Setting this to `false`
  overrides any `editor` key supplied via `col_options`.
- `allow_remove`: Show a per-row delete button (default `true`).

# Example
```julia
df = DataFrame(name=["Alice", "Bob"], score=[95, 87])

@bind tbl EditableTable(df;
    col_options = Dict(:score => Dict(:editor => "number")),
    default_row = Dict(:name => "New", :score => 0),
    height = "200px",
)
```
`tbl` is updated to the live `DataFrame` after every cell edit, row addition, or deletion.
"""
struct EditableTable
    data::DataFrame
    col_options::Dict{Symbol, Any}
    default_row::Dict{Symbol, Any}
    page_size::Int
    height::String
	allow_add::Bool
	allow_edit::Bool
	allow_remove::Bool
end

function EditableTable(
    df::DataFrame; 
    col_options::AbstractDict=Dict{Symbol, Any}(), 
    default_row::AbstractDict=Dict{Symbol, Any}(),
    page_size::Int=50, 
    height::String="300px",
	allow_add::Bool=true,
	allow_edit::Bool=true,
	allow_remove::Bool=true
)
    # Copy df so the widget owns its data independently of the caller's reference.
    EditableTable(copy(df), Dict{Symbol, Any}(col_options), Dict{Symbol, Any}(default_row), page_size, height, allow_add, allow_edit, allow_remove)
end

function Base.show(io::IO, m::MIME"text/html", et::EditableTable)
    # `with_js_link` creates a callable JS↔Julia bridge. Tabulator calls it as its
    # remote pagination handler, and Julia slices `et.data` on demand.
    fetch_chunk = with_js_link() do args
        raw_page = args["page"]
        raw_size = args["size"]
        
        page = isnothing(raw_page) ? 1 : round(Int, raw_page)
        size = isnothing(raw_size) ? et.page_size : round(Int, raw_size)
        
        offset = (page - 1) * size
        start_idx = offset + 1
        end_idx = min(offset + size, nrow(et.data))
        
        if start_idx > nrow(et.data)
            return Dict("data" => [], "last_page" => ceil(Int, max(1, nrow(et.data)) / size))
        end
        
        chunk = et.data[start_idx:end_idx, :]
        
        # `_pluto_idx` is a stable 1-based row identity key that survives pagination
        # and is used by Tabulator as its `index` field for targeted edits/deletes.
        chunk_dicts = map(enumerate(Tables.rowtable(chunk))) do (i, row)
            merge((_pluto_idx = start_idx + i - 1,), row)
        end

        return Dict(
            "data" => chunk_dicts,
            "last_page" => ceil(Int, max(1, nrow(et.data)) / size)
        )
    end

    cols = Dict{Symbol, Any}[]
    
	for name in names(et.data)
	    col_def = Dict{Symbol, Any}(
	        :title => name, 
	        :field => name, 
	        :editor => "input"
	    )
	    
	    # Apply user-specified column-level overrides (title, width, formatter, …).
	    if haskey(et.col_options, Symbol(name))
	        merge!(col_def, et.col_options[Symbol(name)])
	    end
	    
	    # `allow_edit=false` takes precedence over any per-column editor setting.
	    if !et.allow_edit
	        col_def[:editor] = false
	    end
	    
	    push!(cols, col_def)
	end

    json_cols = JSON3.write(cols)

    show(io, m, @htl("""
    <div class="pluto-editable-table" style="max-width: 100%;">
        <link href="https://unpkg.com/tabulator-tables@5.5.2/dist/css/tabulator_midnight.min.css" rel="stylesheet">
        <script src="https://unpkg.com/tabulator-tables@5.5.2/dist/js/tabulator.min.js"></script>
        
        <div class="tabulator-container"></div>
					 
        <script>
            const container = currentScript.parentElement;	 
            const tableDiv = container.querySelector(".tabulator-container");
            const fetch_from_julia = $(fetch_chunk);

 			tableDiv.addEventListener('input', function(event) {
				event.stopPropagation();
			});
					 
            const cols = JSON.parse($json_cols);

            if ($(et.allow_remove)) {
                cols.push({
                    formatter: "buttonCross", 
                    width: 40, 
                    hozAlign: "center", 
                    headerSort: false,
                    cellClick: (e, cell) => cell.getRow().delete()
                });
            }

			const footerElement = $(et.allow_add) 
					 ? "<button class='tabulator-page active pluto-add-row-btn'>+ Add Row</button>"
					 : null;
            
            const table = new Tabulator(tableDiv, {
                layout: "fitColumns",
                height: $(et.height),
                columns: cols,
                pagination: true,
				paginationMode: "remote",
                paginationSize: $(et.page_size),
                index: "_pluto_idx",
                ajaxURL: "http://dummy",
				footerElement: footerElement,                
				 ajaxRequestFunc: async function(url, config, params) {
                    try {
                        const p = params.page || 1;
                        const s = params.size || $(et.page_size);
                        
                        const response = await fetch_from_julia({page: p, size: s});
                        return response;
                    } catch (e) {
                        console.error("EditableTable Julia Fetch Error:", e);
                        return { data: [], last_page: 1 };
                    }
                }
            });

			table.on("tableBuilt", () => {
			    const addBtn = tableDiv.querySelector(".pluto-add-row-btn");
			    if (addBtn) {
			        addBtn.addEventListener("click", () => table.addRow({}, true));
			    }
			});
            tableDiv.tabulator = table;
            
            let debounceTimer;
            const dispatchEdit = (action, row_idx, col, val) => {
                clearTimeout(debounceTimer);
                debounceTimer = setTimeout(() => {
                    container.value = {
                        action: action,
                        row_idx: row_idx,
                        col: col,
                        value: val
                    };
                    container.dispatchEvent(new CustomEvent("input"));
                    if (action === "add" || action === "delete") {
                        setTimeout(() => table.setData(), 100);
                    }
                }, 150);
            };
            
            table.on("cellEdited", (cell) => {
                dispatchEdit("edit", cell.getRow().getIndex(), cell.getField(), cell.getValue());
            });
            
            table.on("rowAdded", (row) => {
                dispatchEdit("add", -1, "", null);
            });
            
            table.on("rowDeleted", (row) => {
                dispatchEdit("delete", row.getIndex(), "", null);
            });
            
            container.value = null;
        </script>
    </div>
    """))
end

Bonds.initial_value(et::EditableTable) = et.data

# Each JS event dispatched by the table carries an `action` string ("edit", "add",
# or "delete") plus the data needed to apply that change to `et.data` in-place.
# The mutated `DataFrame` is then returned as the new bond value.
function Bonds.transform_value(et::EditableTable, val)
    val === nothing && return et.data

    action = val["action"]::String
    
    if action == "edit"
        row_idx = val["row_idx"]::Int
        col = Symbol(val["col"]::String)
        new_val = val["value"]
        
        if 1 <= row_idx <= nrow(et.data)
            T = eltype(et.data[!, col])
            try
                et.data[row_idx, col] = T === Any ? new_val : convert(T, new_val)
            catch
                @warn "EditableTables: Failed to cast $new_val to $T"
            end
        end

    elseif action == "add"
        new_row = Vector{Any}(undef, ncol(et.data))
        for (i, col_name) in enumerate(names(et.data))
            sym = Symbol(col_name)
            T = eltype(et.data[!, col_name])
            
            val_to_insert = if haskey(et.default_row, sym)
                et.default_row[sym]
            elseif Missing <: T
                missing
            elseif T <: Number
                zero(nonmissingtype(T))
            elseif T <: AbstractString
                ""
            elseif T == Bool
                false
            else
                error("EditableTables: Cannot auto-generate default for column :$sym of type $T")
            end
            
            new_row[i] = val_to_insert
        end
        push!(et.data, new_row)

    elseif action == "delete"
        row_idx = val["row_idx"]::Int
        if 1 <= row_idx <= nrow(et.data)
            deleteat!(et.data, row_idx)
        end
    end
    
    return et.data
end