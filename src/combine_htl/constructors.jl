# Abstract Constructors #

Script(::InsidePluto) = PlutoScript
Script(::OutsidePluto) = NormalScript
Script(::InsideAndOutsidePluto) = DualScript

Node(::InsidePluto) = PlutoNode
Node(::OutsidePluto) = NormalNode
Node(::InsideAndOutsidePluto) = DualNode

# ScriptContent #

## AbstractString constructor ##
function ScriptContent(s::AbstractString; kwargs...)
	# We strip eventual leading newline or trailing `isspace`
	str = strip_nl(s)
	ael = get(kwargs, :addedEventListeners) do
		contains(str, "addScriptEventListeners(")
	end
	ScriptContent(str, ael)
end

## Result constructor ##
function ScriptContent(r::Result; iocontext = IOContext(devnull), kwargs...)
	temp = IOContext(IOBuffer(), iocontext)
	show(temp, r)
	str_content = strip(String(take!(temp.io)))
	isempty(str_content) && return ScriptContent()
	n_matches = 0
	first_idx = 0
	first_offset = 0
	last_idx = 0
	start_regexp = r"<script[^>]*>"
	end_regexp = r"</script>"
	for m in eachmatch(r"<script[^>]*>", str_content)
		n_matches += 1
		n_matches > 1 && break
		first_offset = m.offset
		first_idx = first_offset + length(m.match)
		m_end = match(end_regexp, str_content, first_idx)
		m_end === nothing && error("No closing </script> tag was found in the input")
		last_idx = m_end.offset - 1
	end
	if n_matches === 0
		@warn "No <script> tag was found. 
Remember that the `ScriptContent` constructor only extract the content between the first <script> tag it finds when using an input of type `HypertextLiteral.Result`" maxlog = 1
		return ScriptContent()
	elseif n_matches > 1
		@warn "More than one <script> tag was found. 
Only the contents of the first one have been extracted" maxlog = 1
	elseif first_offset > 1 || last_idx < length(str_content) - length("</script>")
		@warn "The provided input also contained contents outside of the <script> tag. 
This content has been discarded" maxlog = 1 
	end
	ScriptContent(str_content[first_idx:last_idx]; kwargs...)
end

## Other Constructors ##
ScriptContent(p::ScriptContent; kwargs...) = p
ScriptContent() = ScriptContent("", false)
ScriptContent(::Union{Missing, Nothing}; kwargs...) = missing

# PlutoScript #
PlutoScript(;body = missing, invalidation = missing, id = missing, returned_element = missing, kwargs...) = PlutoScript(body, invalidation, id, returned_element; kwargs...)
# Custom Constructors
PlutoScript(body; kwargs...) = PlutoScript(;body, kwargs...)
PlutoScript(body, invalidation; kwargs...) = PlutoScript(body; invalidation, kwargs...)
# Identity/Copy with modification
function PlutoScript(s::PlutoScript; kwargs...) 
    (;body, invalidation, id, returned_element) = s
    PlutoScript(;body, invalidation, id, returned_element, kwargs...)
end
# From other scripts
PlutoScript(n::NormalScript; kwargs...) = error("You can't construct a PlutoScript with a NormalScript as input")
PlutoScript(ds::DualScript; kwargs...) = PlutoScript(inner_node(ds, InsidePluto()); kwargs...)

# NormalScript #
NormalScript(;body = missing, add_pluto_compat = true, id = missing, returned_element = missing, kwargs...) = NormalScript(body, add_pluto_compat, id, returned_element; kwargs...)
# Custom constructor
NormalScript(body; kwargs...) = NormalScript(;body, kwargs...)
# Identity/Copy with modification
function NormalScript(s::NormalScript; kwargs...) 
    (;body, add_pluto_compat, id, returned_element) = s
    NormalScript(;body, add_pluto_compat, id, returned_element, kwargs...)
end
# From other scripts
NormalScript(ps::PlutoScript; kwargs...) = error("You can't construct a `NormalScript` from a `PlutoScript`")
NormalScript(ds::DualScript; kwargs...) = NormalScript(inner_node(ds, OutsidePluto()); kwargs...)

# DualScript #
# Constructor with single non-script body. It mirrors the body both in the Pluto and Normal
DualScript(body; kwargs...) = DualScript(body, body; kwargs...)
# From Other Scripts
DualScript(i::PlutoScript; kwargs...) = DualScript(i, NormalScript(); kwargs...)
DualScript(o::NormalScript; kwargs...) = DualScript(PlutoScript(), o; kwargs...)
DualScript(ds::DualScript; kwargs...) = DualScript(ds.inside_pluto, ds.outside_pluto; kwargs...)

# CombinedScripts #
function CombinedScripts(v::Vector; kwargs...)
	pts_vec = map(v) do el
		make_script(el) |> PrintToScript
	end
    filtered = filter(pts_vec) do el
		skip_both = shouldskip(el, InsidePluto()) && shouldskip(el, OutsidePluto())
		!skip_both
    end 
    CombinedScripts(filtered; kwargs...)
end
CombinedScripts(cs::CombinedScripts) = cs
CombinedScripts(el) = CombinedScripts([el])

# CombinedNodes #
CombinedNodes(cn::CombinedNodes) = cn
CombinedNodes(el) = CombinedNodes([el])

# ShowWithPrintHTML #
ShowWithPrintHTML(@nospecialize(t); display_type = displaylocation(t)) = ShowWithPrintHTML(t, displaylocation(display_type))
ShowWithPrintHTML(@nospecialize(t::ShowWithPrintHTML); display_type = displaylocation(t)) = ShowWithPrintHTML(t.el, displaylocation(display_type))
ShowWithPrintHTML(@nospecialize(t::PrintToScript); kwargs...) = error("You can't wrap object of type $(typeof(t)) with ShowWithPrintHTML")

# PrintToScript #
PrintToScript(@nospecialize(t); display_type = displaylocation(t)) = PrintToScript(t, displaylocation(display_type))
PrintToScript(@nospecialize(t::PrintToScript); display_type = displaylocation(t)) = PrintToScript(t.el, displaylocation(display_type))
PrintToScript(@nospecialize(t::AbstractHTML); kwargs...) = error("You can't wrap object of type $(typeof(t)) with PrintToScript")
PrintToScript(@nospecialize(t::Union{SingleScript, DualScript}); display_type = displaylocation(t)) = PrintToScript(t, displaylocation(display_type))
PrintToScript(x::Union{AbstractString, ScriptContent, Result}; kwargs...) = PrintToScript(DualScript(ScriptContent(x)); kwargs...)

# DualNode #
DualNode(i, o) = DualNode(PlutoNode(i), NormalNode(o))
DualNode(i::PlutoNode) = DualNode(i, NormalNode())
DualNode(o::NormalNode) = DualNode(PlutoNode(), o)
DualNode(dn::DualNode) = dn