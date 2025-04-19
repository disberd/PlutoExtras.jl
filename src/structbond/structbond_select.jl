# Valid elements for StructBondSelect

valid_structbondselect_el(el::StructBond) = true
valid_structbondselect_el(el::TransformedWidget{<:StructBond}) = true

extract_description(el::StructBond) = el.description
extract_description(el::TransformedWidget{<:StructBond}) = el.x.description

"""
    StructBondSelect(els::Vector{<:StructBond})

A bond that displays a dropdown menu with the descriptions of the given StructBonds.
When the user selects one of the options, the corresponding StructBond is displayed.

See also: [`StructBond`](@ref)
"""
struct StructBondSelect
	els::Vector
    selectors::Vector{String}
    selector_text::String
    default_idx::Int
    description::String
end


function StructBondSelect(els::Vector, selectors::Vector{String}; default_idx = 1, description = "StructBondSelect", selector_text = "Selector")
    all(valid_structbondselect_el, els) || throw(ArgumentError("All elements in els must be either a StructBond or a TransformedWidget{StructBond} (obtained from a StructBond using `PlutoUI.Experimental.transformed_value`)"))
    StructBondSelect(els, selectors, selector_text, default_idx, description)
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
            $(Select(sb.selectors))
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

            const change_selection = (value, trigger_event = true) => {
                set_input_value(select, value)
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

            change_selection(get_input_value(select), false)

            Object.defineProperty(parent, "value", {
                get: () => {
                    const index = get_input_value(select)
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

            parent.addEventListener("input", (e) => {
                console.log("input event ", e)
            })


            select.addEventListener("input", (e) => {
                const value = get_input_value(select)
                e.stopPropagation()
                change_selection(value)
            })
        </script>
        <style>
            $(CSS_Sheets.structbondselect)
        </style>
    </structbond-select>
    """)
    show(io, mime, togglereactive_container(inner_bond; description = sb.description, title = "Use the selector to choose which StructBond to display and use."))
end

Bonds.initial_value(sbc::StructBondSelect) = Bonds.initial_value(sbc.els[sbc.default_idx])

function Bonds.validate_value(sbc::StructBondSelect, from_js)
	index, value = from_js |> first
	idx = parse(Int, index)
	idx <= length(sbc.els) && Bonds.validate_value(sbc.els[idx], value)
end

function Bonds.transform_value(sbc::StructBondSelect, from_js)
	index, value = from_js |> first
	idx = parse(Int, index)
	Bonds.transform_value(sbc.els[idx], value)
end