
# Helpers #
# This function just iterates and print the javascript of an iterable containing DualScript elements
function _iterate_scriptcontents(io::IO, iter, location::SingleDisplayLocation, kind::Symbol = :body)
	mime = MIME"text/javascript"()
	# We cycle through the DualScript iterable
	pluto = plutodefault(location)
	for pts in iter
		kwargs = if _eltype(pts) <: Script
			(;
				pluto,
				kind,
			)
		else
			# We only print when iterating the body for non Script elements
			kind === :body || continue
			(;pluto)
		end
		print_javascript(io, pts; kwargs...)
	end
	return nothing
end

function write_script(io::IO, contents::Vector{<:PrintToScript}, location::InsidePluto; returns = missing, kwargs...)
	# We cycle through the contents to write the body part
	_iterate_scriptcontents(io, contents, location, :body)
	# If there is no valid invalidation, we simply return
	if hasinvalidation(contents)
		# We add a separating newline
		println(io)
		# Start processing the invalidation
		println(io, "invalidation.then(() => {")
		_iterate_scriptcontents(io, contents, location, :invalidation)
		println(io, "})")
	end
	maybe_add_return(io, returns, location)
	return
end
function write_script(io::IO, contents::Vector{<:PrintToScript}, location::OutsidePluto; returns = missing, only_contents = false)
	# We wrap everything in an async call as we want to use await
	only_contents || println(io, "(async (currentScript) => {")
	# If the script should have the added Pluto compat packages we load them
	if add_pluto_compat(contents) && !only_contents
		println(io, """
	// Load the Pluto compat packages from the custom module
	const {DOM, Files, Generators, Promises, now, svg, html, require, _} = await import('$(LOCAL_MODULE_URL[])')
""")
	end
	# We cycle through the contents to write the body part
	_iterate_scriptcontents(io, contents, location, :body)
	# We print the returned element if provided
	maybe_add_return(io, returns, location)
	# We close the async function definition and call it with the currentScript
	only_contents || println(io, "})(document.currentScript)")
	return
end


## print_javascript ##
# ScriptContent
function print_javascript(io::IO, sc::ScriptContent; kwargs...)
	shouldskip(sc) && return
	println(io, sc.content) # Add the newline
end
# Script
function print_javascript(io::IO, s::Union{SingleScript, DualScript}; pluto =
plutodefault(s), kwargs...) 
	print_javascript(io, CombinedScripts(s); pluto, kwargs...)
end
# CombinedScripts
function print_javascript(io::IO, ms::CombinedScripts; pluto =
plutodefault(io), only_contents = false)
	location = displaylocation(pluto)
	shouldskip(ms, location) && return
	# We add the listeners handlers if any of the script requires it
	contents = children(ms) |> copy # We copy to avoid mutating in the next line
	if haslisteners(ms, location) && !only_contents
		pushfirst!(contents, _events_listeners_preamble)
		push!(contents, _events_listeners_postamble)
	end
	write_script(io, contents, location; 
	returns = returned_element(ms, location), only_contents)
end
# PrintToScript
# Default version that just forwards
function print_javascript(io::IO, pts::PrintToScript; pluto = plutodefault(pts), kwargs...) 
	l = displaylocation(pluto)
	# We skip if the loction of pts is explicitly not compatible with l
	shouldskip(pts, l) && return
	print_javascript(io, pts.el; pluto, kwargs...)
	return nothing
end
# Here we add methods for PrintToScript containing scripts. These will simply print the relevant ScriptContent
function print_javascript(io::IO, pts::PrintToScript{<:DisplayLocation, <:Script}; pluto = plutodefault(pts.el), kind = :body)
	l = displaylocation(pluto)
	el = pts.el
	s = el isa DualScript ? inner_node(el, l) : el
	# We return if the location we want to print is not supported by the script
	shouldskip(s, l) && return
	if kind === :invalidation && s isa NormalScript
		# We error if we are trying to print the invalidation field of a NormalScript
		error("You can't print invalidation for a NormalScript")
	end
	sc = getproperty(s, kind)
	shouldskip(sc, l) || print_javascript(io, sc)
	return nothing
end
# If the PrintToScript element is a function, we call it passing io and kwargs to it
function print_javascript(io::IO, pts::PrintToScript{<:DisplayLocation, <:Function}; pluto = is_inside_pluto(io), kwargs...)
	l = displaylocation(pluto)
	# We skip if the loction of pts is explicitly not compatible with l
	shouldskip(pts, l) && return
	f = pts.el
	f(io; pluto, kwargs...)
	return nothing
end
# For AbstractDicts, we use HypertextLiteral.print_script 
function print_javascript(io::IO, d::Union{AbstractDict, NamedTuple, Tuple, AbstractVector}; pluto = is_inside_pluto(io), kwargs...)
	if pluto
		pjs = published_to_js(d)
		show(io, MIME"text/javascript"(), pjs)
	else
		HypertextLiteral.print_script(io, d)
	end
	return nothing
end
# Catchall method reverting to show text/javascript
print_javascript(io::IO, x; kwargs...) = (@nospecialize; show(io, MIME"text/javascript"(), x))

## Maybe add return ##
maybe_add_return(::IO, ::Missing, ::SingleDisplayLocation) = nothing
maybe_add_return(io::IO, name::String, ::InsidePluto) = println(io, "return $name")
maybe_add_return(io::IO, name::String, ::OutsidePluto) = print(io, "
	/* code added by PlutoExtras to simulate script return */
	currentScript.insertAdjacentElement('beforebegin', $name)
")

# This function will simply write into IO the html code of the script, including the <script> tag
# This is applicable for CombinedScripts and DualScript
function print_html(io::IO, s::Script; pluto = plutodefault(s), only_contents = false)
	location = displaylocation(pluto)
	shouldskip(s, location) && return
	# We write the script tag
	id = script_id(s, location)
	println(io, "<script id='$id'>")
	# Print the content
	print_javascript(io, s; pluto, only_contents)
	# Print the closing tag
	println(io, "</script>")
	return
end
print_html(io::IO, s::AbstractString; kwargs...) = write(io, strip_nl(s))
function print_html(io::IO, n::NonScript{L}; pluto = plutodefault(n)) where L <: SingleDisplayLocation 
	_pluto = plutodefault(n)
	# If the location doesn't match the provided kwarg we do nothing
	xor(pluto, _pluto) && return
	println(io, n.content)
	return
end
print_html(io::IO, dn::DualNode; pluto = plutodefault(dn)) = print_html(io, inner_node(dn, displaylocation(pluto)); pluto)
function print_html(io::IO, cn::CombinedNodes; pluto = is_inside_pluto(io))
	for n in children(cn)
		print_html(io, n; pluto)
	end
end
function print_html(io::IO, swph::ShowWithPrintHTML; pluto = plutodefault(io, swph)) 
	l = displaylocation(pluto)
	# We skip if the loction of pts is explicitly not compatible with l
	shouldskip(swph, l) && return
	print_html(io, swph.el; pluto)
	return nothing
end
# If the ShowWithPrintHTML element is a function, we call it passing io and kwargs to it
function print_html(io::IO, swph::ShowWithPrintHTML{<:DisplayLocation, <:Function}; pluto = plutodefault(io, swph), kwargs...)
	l = displaylocation(pluto)
	# We skip if the loction of pts is explicitly not compatible with l
	shouldskip(swph, l) && return
	f = swph.el
	f(io; pluto, kwargs...)
	return nothing
end
# Catchall method reverting to show text/javascript
print_html(io::IO, x; kwargs...) = (@nospecialize; show(io, MIME"text/html"(), x))

## Formatted Code ##

# We simulate the Pluto iocontext even outside Pluto if want to force printing as in pluto
_pluto_default_iocontext() = try
	Main.PlutoRunner.default_iocontext 
catch
	function core_published_to_js(io, x)
		write(io, "/* Here you'd have your published object on Pluto */")
		return nothing
	end
	IOContext(devnull, 
		:color => false, 
		:limit => true, 
		:displaysize => (18, 88), 
		:is_pluto => true, 
		# :pluto_supported_integration_features => supported_integration_features,
		:pluto_published_to_js => (io, x) -> core_published_to_js(io, x),
	)
end

function to_string(element, ::M, args...; kwargs...) where M <: MIME
	f = if M === MIME"text/javascript"
		print_javascript
	elseif M === MIME"text/html"
		print_html
	else
		error("Unsupported mime $M provided as input")
	end
	to_string(element, f, args...; kwargs...)
end
function to_string(element, f::Function, io::IO = IOBuffer(); kwargs...)
	iocontext = get(kwargs, :iocontext) do 
		pluto = get(kwargs, :pluto, is_inside_pluto())
		pluto ? _pluto_default_iocontext() : IOContext(devnull)
	end
	f(IOContext(io, iocontext), element; kwargs...)
	code = String(take!(io))
	return code
end
function formatted_code(s::Union{Script, ScriptContent}, mime::MIME"text/javascript"; kwargs...)
	codestring = to_string(s, mime; kwargs...)
	Markdown.MD(Markdown.Code("js", codestring))
end
function formatted_code(n::Node, mime::MIME"text/html"; kwargs...)
	codestring = to_string(n, mime; kwargs...)
	Markdown.MD(Markdown.Code("html", codestring))
end
# Default MIMEs
default_mime(::ScriptContent) = MIME"text/javascript"()
default_mime(::Node) = MIME"text/html"()
formatted_code(s::Union{ScriptContent, Node}; kwargs...) = formatted_code(s, default_mime(s); kwargs...)
# Versions returning functions
formatted_code(mime::MIME; kwargs...) = x -> formatted_code(x, mime; kwargs...)
# This forces just the location using the DisplayLocation type
formatted_code(l::SingleDisplayLocation; kwargs...) = x -> formatted_code(x; pluto = plutodefault(l), kwargs...)
formatted_code(; kwargs...) = x -> formatted_code(x; kwargs...) # Default no argument version

formatted_contents(args...; kwargs...) = formatted_code(args...; kwargs..., only_contents = true)


HypertextLiteral.content(n::Node) = HypertextLiteral.Render(ShowWithPrintHTML(n, InsideAndOutsidePluto()))

#= Fix for Julia 1.10 
The `@generated` `print_script` from HypertextLiteral is broken in 1.10
See [issue 33](https://github.com/JuliaPluto/HypertextLiteral.jl/issues/33)
We have to also define a method for `print_script` to avoid precompilation errors
=#

HypertextLiteral.print_script(io::IO, val::ScriptContent) = show(io, MIME"text/javascript"(), val)
HypertextLiteral.print_script(io::IO, v::Vector{ScriptContent}) = for s in v
	HypertextLiteral.print_script(io, s)
end

HypertextLiteral.print_script(::IO, ::Script) = error("Interpolation of `Script` subtypes is not allowed within a script tag.
Use `make_node` to generate a `<script>` node directly in HTML")


# Show - text/javascript #
function Base.show(io::IO, ::MIME"text/javascript", s::Union{ScriptContent, Script})
	print_javascript(io, s)
end

Base.show(::IO, ::MIME"text/javascript", ::T) where T <: Union{ShowWithPrintHTML, NonScript} =
error("Objects of type `$T` are not supposed to be shown with mime 'text/javascript'")

# Show - text/html #
Base.show(io::IO, mime::MIME"text/html", sc::ScriptContent) = 
show(io, mime, formatted_code(sc))

Base.show(io::IO, ::MIME"text/html", s::Node) =
print_html(io, s; pluto = is_inside_pluto(io))

Base.show(io::IO, ::MIME"text/html", s::ShowWithPrintHTML) = 
print_html(io, s.el; pluto = plutodefault(io, s))