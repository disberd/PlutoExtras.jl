# Basics
plutodefault(::Union{InsidePluto, InsideAndOutsidePluto}) = true
plutodefault(::OutsidePluto) = false
plutodefault(::Type{D}) where D <: DisplayLocation = plutodefault(D())
plutodefault(@nospecialize(x::Union{AbstractHTML, PrintToScript})) = plutodefault(displaylocation(x))
# Methods that gets IO as first argument and a ShowWithPrintHTML as second.
# These are used to select the correct default for ShowWithPrintHTML
plutodefault(io::IO, @nospecialize(x::ShowWithPrintHTML{InsideAndOutsidePluto})) = is_inside_pluto(io)
plutodefault(::IO, @nospecialize(x::ShowWithPrintHTML)) = plutodefault(x)

displaylocation(@nospecialize(x)) = InsideAndOutsidePluto()
displaylocation(d::DisplayLocation) = d
displaylocation(pluto::Bool) = pluto ? InsidePluto() : OutsidePluto()
displaylocation(::AbstractHTML{D}) where D <: DisplayLocation = D()
displaylocation(::PrintToScript{D}) where D <: DisplayLocation = D()
function displaylocation(s::Symbol)
    if s in (:Pluto, :pluto, :inside, :Inside)
        InsidePluto()
    elseif s in (:Normal, :normal, :outside, :Outside)
        OutsidePluto()
    elseif s in (:both, :Both, :insideandoutside, :InsideAndOutside)
        InsideAndOutsidePluto()
    else
        error("The provided symbol can not identify a display location.
Please use one of the following:
- :Pluto, :pluto or :inside, :Inside to display inside Pluto
- :Normal, :normal or :outside, :Outside to display outside Pluto
- :both, :Both, :InsideAndOutside or :insideandoutside to display both inside and outside Pluto
    ")
    end
end

children(cs::CombinedScripts) = cs.scripts
children(cn::CombinedNodes) = cn.nodes

_eltype(pts::PrintToScript{<:DisplayLocation, T}) where T = T
_eltype(swph::ShowWithPrintHTML{<:DisplayLocation, T}) where T = T

# We create some common methods for the functions below
for F in (:haslisteners, :hasreturn, :returned_element, :script_id)
    quote
        $F(l::DisplayLocation; kwargs...) = x -> $F(x, l; kwargs...)
        $F(ds::DualScript, l::SingleDisplayLocation; kwargs...) = $F(inner_node(ds, l); kwargs...)
    end |> eval
end

# shouldskip
shouldskip(l::SingleDisplayLocation) = x -> shouldskip(x, l)
shouldskip(source_location::DisplayLocation, display_location::SingleDisplayLocation) = source_location isa InsideAndOutsidePluto ? false : source_location !== display_location
shouldskip(s::AbstractString, args...) = isempty(s)
shouldskip(::Missing, args...) = true
shouldskip(p::ScriptContent, args...) = shouldskip(p.content, args...)
shouldskip(::Any, args...) = (@nospecialize; return false)
shouldskip(n::AbstractHTML, l::SingleDisplayLocation) = (@nospecialize; shouldskip(displaylocation(n), l))

shouldskip(x::PlutoScript, ::InsidePluto) = shouldskip(x.body) && shouldskip(x.invalidation) && shouldskip(x.id) && !hasreturn(x)
shouldskip(x::NormalScript, ::OutsidePluto) = shouldskip(x.body) && shouldskip(x.id) && !hasreturn(x)
shouldskip(n::NonScript{L}, ::L) where L <: SingleDisplayLocation = n.empty
# Dual Script/Node
shouldskip(d::Dual, l::SingleDisplayLocation) = shouldskip(inner_node(d, l), l)
# Combined
shouldskip(c::Combined, l::SingleDisplayLocation) = all(shouldskip(l), children(c))
function shouldskip(wrapper::Union{ShowWithPrintHTML, PrintToScript}, l::SingleDisplayLocation)
    el = wrapper.el
    if el isa AbstractHTML
        shouldskip(el, l)
    else
        shouldskip(displaylocation(wrapper), l)
    end
end
# HypertextLiteral methods
shouldskip(x::Bypass, args...) = shouldskip(x.content)
shouldskip(x::Render, args...) = shouldskip(x.content)

# add_pluto_compat
add_pluto_compat(@nospecialize(::Any)) = false
add_pluto_compat(ns::NormalScript) =  ns.add_pluto_compat
add_pluto_compat(ds::DualScript) = add_pluto_compat(inner_node(ds, OutsidePluto()))
add_pluto_compat(v::Vector{<:PrintToScript}) = any(add_pluto_compat, v)
add_pluto_compat(cs::CombinedScripts) = add_pluto_compat(children(cs))
add_pluto_compat(pts::PrintToScript) = add_pluto_compat(pts.el)

# hasinvalidation
hasinvalidation(@nospecialize(::Any)) = false
hasinvalidation(s::PlutoScript) = !shouldskip(s.invalidation)
hasinvalidation(ds::DualScript) = hasinvalidation(inner_node(ds, InsidePluto()))
hasinvalidation(v::Vector{<:PrintToScript}) = any(hasinvalidation, v)
hasinvalidation(cs::CombinedScripts) = hasinvalidation(children(cs))
hasinvalidation(ps::PrintToScript) = hasinvalidation(ps.el)

# haslisteners
haslisteners(::Missing) = false
haslisteners(s::ScriptContent) = s.addedEventListeners
haslisteners(s::SingleScript, l::DisplayLocation = displaylocation(s)) = l == displaylocation(s) ? haslisteners(s.body) : false
haslisteners(cs::CombinedScripts, l::DisplayLocation) = any(haslisteners(l), children(cs))
haslisteners(::PrintToScript, args...) = (@nospecialize; false)
haslisteners(pts::PrintToScript{<:DisplayLocation, <:Script}, args...) = (@nospecialize; haslisteners(pts.el, args...))

# hasreturn
hasreturn(s::SingleScript, l::DisplayLocation = displaylocation(s)) = l == displaylocation(s) ? !ismissing(returned_element(s)) : false
hasreturn(cs::CombinedScripts, l::DisplayLocation) = any(hasreturn(l), children(cs))
hasreturn(::PrintToScript, args...) = (@nospecialize; return false)
hasreturn(pts::PrintToScript{<:DisplayLocation, <:Script}, args...) = (@nospecialize; hasreturn(pts.el, args...))
    
# returned_element
returned_element(s::SingleScript, l::DisplayLocation = displaylocation(s)) = l == displaylocation(s) ? s.returned_element : missing
# We check for duplicate returns in the constructor so we just get the return from the last script
function returned_element(cs::CombinedScripts, l::DisplayLocation)
    @inbounds for pts in children(cs)
        hasreturn(pts, l) && return returned_element(pts, l)
    end
    return missing
end
returned_element(pts::PrintToScript{<:DisplayLocation, <:Script}, args...) = (@nospecialize; returned_element(pts.el, args...))

function script_id(s::SingleScript, l = displaylocation(s); default::Union{String, Missing} = randstring(6)) 
    if l == displaylocation(s) 
        ismissing(s.id) ? default : s.id
    else
        missing 
    end
end
function script_id(cs::CombinedScripts, l::SingleDisplayLocation; default = randstring(6))
    for pts in children(cs)
        id = script_id(pts, l; default = missing)
        id isa String && return id
    end
    return default
end
script_id(::PrintToScript, args...; kwargs...) = (@nospecialize; return missing)
script_id(pts::PrintToScript{<:DisplayLocation, <:Script}, args...; kwargs...) = (@nospecialize; script_id(pts.el, args...; kwargs...))

inner_node(ds::Union{DualNode, DualScript}, ::InsidePluto) = ds.inside_pluto
inner_node(ds::Union{DualNode, DualScript}, ::OutsidePluto) = ds.outside_pluto

## Make Script ##
"""
$TYPEDSIGNATURES
GESU
"""
make_script(; type = :both, kwargs...) = make_script(displaylocation(type); kwargs...)
make_script(type::Symbol, args...; kwargs...) = make_script(displaylocation(type), args...; kwargs...)
# Basic location-based constructors
make_script(::InsideAndOutsidePluto; body = missing, invalidation = missing, inside = PlutoScript(body, invalidation), outside = NormalScript(body), kwargs...) = DualScript(inside, outside; kwargs...)
make_script(l::SingleDisplayLocation; kwargs...) = Script(l)(;kwargs...)
# Take a Script as Second argument
make_script(l::DisplayLocation, x::Union{SingleScript, DualScript}; kwargs...) = Script(l)(x; kwargs...)
# Other with no location
make_script(body; kwargs...) = make_script(;body, kwargs...)
make_script(i, o; kwargs...) = DualScript(i, o; kwargs...)
make_script(x::Script; kwargs...) = make_script(displaylocation(x), x; kwargs...)
make_script(x::CombinedScripts) = x
make_script(v::Vector; kwargs...) = CombinedScripts(v; kwargs...)
# From ShowWithPrintHTML
make_script(@nospecialize(s::ShowWithPrintHTML{<:DisplayLocation, <:Script})) = s.el
make_script(@nospecialize(s::ShowWithPrintHTML)) = error("make_script on `ShowWithPrintHTML{T}` types is only valid if `T <: Script`")
# From PrintToScript, this is just to have a no-op when calling make_script inside CombinedScripts
make_script(@nospecialize(s::PrintToScript)) = s

## Make Node ##
# only kwargs method
make_node(; type = :both, kwargs...) = make_node(displaylocation(type); kwargs...)
# Symbol + args method
make_node(type::Symbol, args...; kwargs...) = make_node(displaylocation(type), args...; kwargs...)
# Methods with location as first argument and kwargs...
make_node(::InsideAndOutsidePluto; inside = "", outside = "") = DualNode(inside, outside)
make_node(l::SingleDisplayLocation; content = "") = Node(l)(content)
# Methods with location as first argument and args
make_node(::InsideAndOutsidePluto, inside, outside=inside) = DualNode(inside, outside)
make_node(l::SingleDisplayLocation, content, args...) = Node(l)(content, args...)
# Defaults without location
make_node(n::Node) = n
make_node(i, o) = DualNode(i, o)
make_node(content) = DualNode(content, content)
make_node(v::Vector) = CombinedNodes(v)
make_node(pts::PrintToScript) = CombinedScripts([pts])

## Make HTML ##
make_html(x; kwargs...) = ShowWithPrintHTML(make_node(x); kwargs...)
make_html(@nospecialize(x::ShowWithPrintHTML); kwargs...) = ShowWithPrintHTML(x; kwargs...)
