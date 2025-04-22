# Valid elements for StructBondSelect

valid_structbondselect_el(::StructBond) = true
valid_structbondselect_el(::TransformedWidget{<:StructBond}) = true
valid_structbondselect_el(::Any) = false

extract_description(el::StructBond) = el.description
extract_description(el::TransformedWidget{<:StructBond}) = el.x.description

"""

A widget to select one subwidget out of an array of provided elements, which can be either `StructBond` or the resulting form `transformed_value(f, ::StructBond)`.

This will show a selection dropdown to choose the subwidget to display and use for generating the StructBondSelect output when coupled with `@bind`.

See the extended help below for a GIF example or the [docs page](https://disberd.github.io/PlutoExtras.jl/stable/structbond/#StructBondSelect) for a video one.

## Constructor

```julia
StructBondSelect(els::Vector[, selectors::Vector{String}]; description = "StructBondSelect", default_idx = 1, selector_text = "Selector")
```

### Arguments
- `els`: A vector of `StructBond` or `transformed_value(f, ::StructBond)` elements.
- `selectors`: A vector of strings to be used as the names to select upon. If not provided, the names will be taken from the `description` of the provided `StructBond` elements.

### Keyword Arguments
- `description`: A string to be used as the description of the widget, defaults to `"StructBondSelect"`.
- `default_idx`: The index of the element to be selected by default for display/output, defaults to `1`.
- `selector_text`: The text to be displayed next to the selector dropdown, defaults to `"Selector"`.

# Extended Help

See this image for a visual example:
![structbondselect-example](https://private-user-images.githubusercontent.com/12846528/435671705-91ff7e4a-2b4c-4688-8f2b-ea53a622dd04.gif?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDUyNDAzMTgsIm5iZiI6MTc0NTI0MDAxOCwicGF0aCI6Ii8xMjg0NjUyOC80MzU2NzE3MDUtOTFmZjdlNGEtMmI0Yy00Njg4LThmMmItZWE1M2E2MjJkZDA0LmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA0MjElMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNDIxVDEyNTMzOFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTYwMmI1ZTYyNGQ1NDMyZGNlZTE3NzljMjJlNWQyOTU5ODUyMDdiODkzYWQxNDRmNzEwZjYxZmEzNTgwZDUyYmEmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.L9eC42c4-Gz0tpjzGgF95LhOvcrGAEPOkJ71HhiICrs)

See also: [`StructBond`](@ref), [`@NTBond`](@ref)
"""
struct StructBondSelect
	els::Vector
    selectors::Vector{String}
    selector_text::String
    default_idx::Int
    description::String
    description_html
end


function StructBondSelect(els::Vector, selectors::Vector{String}; default_idx::Int = 1, description = "StructBondSelect", selector_text = "Selector", description_html = description)
    all(valid_structbondselect_el, els) || throw(ArgumentError("All elements in els must be either a StructBond or a TransformedWidget{StructBond} (obtained from a StructBond using `PlutoUI.Experimental.transformed_value`)"))
    default_idx > 0 && default_idx <= length(els) || throw(ArgumentError("default_idx must be a positive integer less than or equal to the number of `StructBond` elements provided as input."))
    StructBondSelect(els, selectors, selector_text, default_idx, description, description_html)
end

function StructBondSelect(els::Vector; kwargs...)
    all(valid_structbondselect_el, els) || throw(ArgumentError("All elements in els must be either a StructBond or a TransformedWidget{StructBond} (obtained from a StructBond using `PlutoUI.Experimental.transformed_value`)"))
    StructBondSelect(els, map(extract_description, els); kwargs...)
end

function StructBondSelect(ps::Vector{<:Pair{<:AbstractString, <:Any}}; kwargs...)
    StructBondSelect(last.(ps), first.(ps); kwargs...)
end

function Base.show(io::IO, mime::MIME"text/html", sb::StructBondSelect)
    inner_bond = @htl("""
    <structbond-select>
        <span class="selector">
            <span class="description">$(sb.selector_text)</span>
            $(Select(sb.selectors, default = sb.selectors[sb.default_idx]))
        </span>
        $([el for el in sb.els])
        <script>
            const parent = currentScript.parentElement
            const set_input_value = setBoundElementValueLikePluto
            const get_input_value = getBoundElementValueLikePluto
            
            // This is the element of the select dropdown
            const select = parent.querySelector("select")

            // This will hold the currently selected structbond element
            let selected

            const update = () => {
                parent.dispatchEvent(new CustomEvent("input"))
            }

            function get_select_value() {
                const value = get_input_value(select)
                return parseInt(value.substring(10))
            }

            const change_selection = (value, trigger_event = true) => {
                set_input_value(select, `puiselect-\${value}`)
                const bonds = parent.querySelectorAll("struct-bond")
                for (let i = 0; i < bonds.length; i++) {
                    if (i != value - 1) {
                        bonds[i].classList.toggle("hidden", true)
                    } else {
                        bonds[i].classList.toggle("hidden", false)
                        selected = bonds[i]
                    }
                }
                if (trigger_event) {
                    update()
                }
            }

            change_selection(get_select_value(), false)

            Object.defineProperty(parent, "value", {
                get: () => {
                    const index = get_select_value()
                    const value = get_input_value(selected)
                    return [index, value]
                },
                set: (newval) => {
                    change_selection(newval[0], false)
                    set_input_value(selected, newval[1])
                },
            })

            // We add a listener that extract the forward the input event in case the target of the event is the selected bond
            for (let bond of parent.querySelectorAll("struct-bond")) {
                bond.addEventListener("input", (e) => {
                    e.stopPropagation()
                    if (bond == selected) {
                        update()
                    }
                })
            }

            select.addEventListener("input", (e) => {
                e.stopPropagation()
                change_selection(get_select_value())
            })
        </script>
        <style>
            $(CSS_Sheets.structbondselect)
        </style>
    </structbond-select>
    """)
    show(io, mime, collapsible_togglereactive_container(inner_bond; description = sb.description, description_html = sb.description_html, title = "Use the selector to choose which StructBond to display and use.", classes = ["structbond-select"]))
end

Bonds.initial_value(sbc::StructBondSelect) = Bonds.initial_value(sbc.els[sbc.default_idx])

function Bonds.validate_value(sbc::StructBondSelect, from_js)
	idx, value = from_js |> first
	idx <= length(sbc.els) && Bonds.validate_value(sbc.els[idx], value)
end

function Bonds.transform_value(sbc::StructBondSelect, from_js)
	idx, value = from_js |> first
	Bonds.transform_value(sbc.els[idx], value)
end