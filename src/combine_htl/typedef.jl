abstract type DisplayLocation end
abstract type SingleDisplayLocation <: DisplayLocation end
struct InsidePluto <: SingleDisplayLocation end
struct OutsidePluto <: SingleDisplayLocation end
struct InsideAndOutsidePluto <: DisplayLocation end

abstract type AbstractHTML{D<:DisplayLocation} end
abstract type Node{D} <: AbstractHTML{D} end
abstract type NonScript{D} <: Node{D} end
abstract type Script{D} <: Node{D} end

const SingleNode = Node{<:SingleDisplayLocation}
const SingleScript = Script{<:SingleDisplayLocation}

## ScriptContent ##
"""
	$TYPEDEF
This struct is a simple wrapper for JS script content and is intended to provide
pretty printing of script contents and custom interpolation inside the
`<script>` tags of the `@htl` macro.

It is used as building block for creating and combining JS scripts to correctly
render inside and outside Pluto notebooks. 

# Field
$TYPEDFIELDS

## Note
The `addedEventListeners` field is usually automatically computed based on the
provided `content` value when using one of the 2 main constructors below:

# Main Constructors
	ScriptContent(s::AbstractString; kwargs...)
	ScriptContent(r::HypertextLiteral.Result; kwargs...)
One would usually call the constructor either with a `String` or
`HypertextLiteral.Result`. In this case, the provided content is parsed and
checked for calls to the `addScriptEventListeners` function, eventually setting the `addedEventListeners` field accordingly.
One can force the flag to a custom value either by directly calling the
(default) inner constructor with 2 positional arguments, or by passing
`addedEventListeners = value` kwarg to one of the two constructrs above.

For what concerns construction with `HypertextLiteral.Result` as input, the
provided `Result` needs to contain an opening and closing `<script>` tag. 
In the example below, the constructor will parse the `Result` and only extracts the content within the tags, so only the `code...` part below.
All content appearing before or after the <script> tag (including additional
script tags) will be ignored and a warning will be produced.
```julia
wrapper = ScriptContent(@htl(\"\"\"
something_before
<script>
code...
</script>
something_after
\"\"\"))
```
When interpolating `wrapper` above inside another `@htl` macro as `@htl
"<script>\$wrapper</script>"` it would be as equivalent to directly writing
`code...` inside the script. This is clearly only
beneficial if multiple `ScriptContent` variables are interpolated inside a
single <script> block.

On top of the interpolation, an object of type `ScriptContent` will show its
contents as a formatted javascript code markdown element when shown in Pluto. 

See also: [`PlutoScript`](@ref), [`NormalScript`](@ref), [`DualScript`](@ref)

# Examples

```julia
let
	asd = ScriptContent(@htl \"\"\"
	<script>
		let out = html`<div></div>`
		console.log('first script')
	</script>
	\"\"\")
	lol = ScriptContent(@htl \"\"\"
	<script>
		let a = Math.random()
		out.innerText = a
		console.log('second script')
		return out
	</script>
	\"\"\")
	@htl \"\"\"
	<script>
		\$([
			asd,
			lol
		])
	</script>
	\"\"\"
end
```
"""
struct ScriptContent
	"Content of the script part"
	content::String
	"Flag indicating if the script has custom listeners added via the  `addScriptEventListeners` function."
	addedEventListeners::Bool
end

## PlutoScript ##
"""
$TYPEDEF
# Fields
$TYPEDFIELDS

## Note
Eventual elements that have to be returned from the script (this is a feature of
Pluto) should not be directly _returned_ from the script content but should be
simply assigned to a JS variable whose name is set to the `returned_element`
field.
This is necessary to prevent exiting early from a chain of Scripts. For example, the following code which is a valid JS code inside a Pluto cell to create a custom div as output:
```julia
@htl \"\"\"
<script>
	return html`<div>MY DIV</div>`
</script>
\"\"\"
```
must be constructed when using `PlutoScript` as:
```julia
PlutoScript("let out = html`<div>MY DIV</div>`"; returned_element = "out")
```

# Additional Constructors
	PlutoScript(body; kwargs...)
	PlutoScript(body, invalidation; kwargs...)

For the body and invalidation fields, the constructor also accepts inputs of
type `String`, `HypertextLiteral.Result` and `IOBuffer`, translating them into
`ScriptContent` internally.

	PlutoScript(s::PlutoScript; kwargs...)
This constructor is used to copy the elements from another PlutoScript with the
option of overwriting the fields provided as `kwargs`

# Description

This struct is used to create and compose scripts together with the `@htl` macro
from HypertextLiteral. 

It is intended for use inside Pluto notebooks to ease composition of bigger
scripts via smaller parts.

When an PlutoScript is interpolated inside the `@htl` macro, the following code is generated:
```html
<script id=\$id>
\$body

invalidation.then(() => {
	\$invalidation
})
```
If the `id = missing` (default), a random string id is associated to the script.
If `id = nothing`, a script without id is created.

If the `invalidation` field is `missing`, the whole invalidation block is
skipped.

Multiple `PlutoScript` elements can be combined together using the
[`combine_script`](@ref) function also exported by this package, allowing to
generate bigger scripts by composing multiple building blocks.

When shown inside the output of Pluto cells, the PlutoScript object prints its
containing formatted code as a `Markdown.Code` element.

# Javascript Events Listeners

`PlutoScript` provides some simplified way of adding event listeners in javascript
that are automatically removed upon cell invalidation. Scripts created using
`PlutoScript` expose an internal javascript function 
```js
addScriptEventListeners(element, listeners)
```
which accepts any givent JS `element` to which listeners have to be attached,
and an object of with the following key-values:
```js
{ 
  eventName1: listenerFunction1, 
  eventName2: listenerFunction2,
  ... 
}
```
When generating the script to execute, `PlutoScript` automatically adds all the
provided listeners to the provided element, and also takes care of removing all
the listeners upon cell invalidation.

For example, the following julia code:
```julia
let
	script = PlutoScript(@htl(\"\"\"
<script>
	addScriptEventListeners(window, { 
		click: function (event) {
			console.log('click: ',event)
		}, 
		keydown: function (event) {
			console.log('keydown: ',event)
		},
	})
</script>
	\"\"\"))
	@htl"\$script"
end
```
is functionally equivalent of writing the following javascript code within the
script tag of the cell output
```js
function onClick(event) {
	console.log('click: ',event)
}
function onKeyDown(event) {
	console.log('keydown: ',event)
}
window.addEventListener('click', onClick)
window.addEventListener('keydown', onKeyDown)

invalidation.then(() => {
	window.removeEventListener('click', onClick)
	window.removeEventListener('keydown', onKeyDown)
})
```

See also: [`ScriptContent`](@ref), [`combine_scripts`](@ref)

# Examples:
The following code:
```julia
let
a = PlutoScript("console.log('asd')")
b = PlutoScript(@htl("<script>console.log('boh')</script>"), "console.log('lol')")
script = combine_scripts([a,b];id="test")
out = @htl("\$script")
end
```
is equivalent to writing directly
```julia
@htl \"\"\"
<script id='test'>
	console.log('asd')
	console.log('boh')
	
	invalidation.then(() => {
		console.log('lol')
	})
\"\"\"
</script>
```
"""
struct PlutoScript <: Script{InsidePluto}
	"The main body of the script"
    body::Union{Missing,ScriptContent}
	"The code to be executed inside the invalidation promise. Defaults to `missing`"
    invalidation::Union{Missing,ScriptContent}
	"The id to assign to the script. Defaults to `missing`"
    id::Union{Missing, String}
	"The name of the JS element that is returned by the script. Defaults to `missing`"
	returned_element::Union{Missing, String}
    function PlutoScript(b,i,id::Union{Missing, Nothing, String}, returned_element; kwargs...) 
        body = ScriptContent(b; kwargs...)
        invalidation = ScriptContent(i)
		@assert invalidation === missing || invalidation.addedEventListeners === false "You can't have added event listeners in the invalidation script"
        new(body,invalidation, something(id, missing), returned_element)
    end
end

## NormalScript
struct NormalScript <: Script{OutsidePluto}
	"The main body of the script"
	body::Union{Missing, ScriptContent}
	"A flag to indicate if the script should include basic JS libraries available from Pluto. Defaults to `true`"
	add_pluto_compat::Bool
	"The id to assign to the script. Defaults to `missing`"
	id::Union{Missing, String}
	"The name of the JS element that is returned by the script. Defaults to `missing`"
	returned_element::Union{Missing, String}
    function NormalScript(b, add_pluto_compat, id, returned_element; kwargs...) 
        body = ScriptContent(b; kwargs...)
        new(body, add_pluto_compat, something(id, missing), returned_element)
    end
end

## DualScript ##
@kwdef struct DualScript <: Script{InsideAndOutsidePluto}
	inside_pluto::PlutoScript = PlutoScript()
	outside_pluto::NormalScript = NormalScript()
	function DualScript(i, o; kwargs...)
		ip = PlutoScript(i; kwargs...)
		op = NormalScript(o; kwargs...)
		new(ip, op)
	end
end


## PrintToScript
struct PrintToScript{D<:DisplayLocation, T}
	el::T
	PrintToScript(el::T, ::D) where {T, D<:DisplayLocation} = new{D,T}(el)
end

## CombinedScripts ##
struct CombinedScripts <: Script{InsideAndOutsidePluto}
	scripts::Vector{<:PrintToScript}
	function CombinedScripts(v::Vector{<:PrintToScript}; returned_element = missing) 
		# We check for only one return expression and it being in the last script
		return_count = 0
		return_idx = something(findfirst(x -> x isa Script, v), 0)
		for (i, s) in enumerate(v)
			# If no return is present we skip this script
			hasreturn(s, InsidePluto()) || hasreturn(s, OutsidePluto()) || continue
			return_count += 1
			return_idx = i
		end
		@assert return_count < 2 "More than one return expression was found while constructing the CombinedScripts. This is not allowed."
		# If we don't have to set a custom returned_element we just create a new CombinedScripts
		returned_element === missing && return new(v)
		final_v = if return_idx === 0
			# We have to add a DualScript that just returns the element
			new_v = vcat(v, DualScript(""; returned_element) |> PrintToScript)
		else
			new_v = copy(v)
			dn = new_v[return_idx].el
			new_v[return_idx] = DualScript(dn; returned_element) |> PrintToScript
			new_v
		end
		new(final_v)
	end
end
struct ShowWithPrintHTML{D<:DisplayLocation, T} <: AbstractHTML{D}
	el::T
	ShowWithPrintHTML(el::T, ::D) where {T, D<:DisplayLocation} = new{D,T}(el)
end

# HTML Nodes #
# We use a custom IO to parse the HypertextLiteral.Result for removing newlines and checking if empty
@kwdef struct ParseResultIO <: IO
	parts::Vector = []
end
# Now we define custom print method to extract the Result parts. See
# https://github.com/JuliaPluto/HypertextLiteral.jl/blob/2bb465047afdfbb227171222049f315545c307fb/src/primitives.jl
for T in (Bypass, Render, Reprint)
	Base.print(io::ParseResultIO, x::T) = shouldskip(x) || push!(io.parts, x)
end

_isnewline(x) = x in ('\n', '\r') # This won't remove tabs and whitespace
strip_nl(s::AbstractString) = lstrip(_isnewline, rstrip(s))
_remove_leading(x) = x
_remove_leading(x::Bypass{<:AbstractString}) = Bypass(lstrip(_isnewline, x.content))
_remove_trailing(x) = x
_remove_trailing(x::Bypass{<:AbstractString}) = Bypass(rstrip(isspace, x.content))
# We define PlutoNode and NormalNode
for (T, P) in ((:PlutoNode, :InsidePluto), (:NormalNode, :OutsidePluto))
	block = quote
		struct $T <: NonScript{$P}
			content::Result
			empty::Bool
		end
		# Empty Constructor
		$T() = $T(@htl(""), true)
		# Constructor from Result
		function $T(r::Result)
			io = ParseResultIO()
			# We don't use show directly to avoid the EscapeProxy here
			r.content(io)
			node = if isempty(io.parts)
				$T(r, true)
			else
				# We try to eventually remove trailing and leading redundant spaces
				xs = io.parts
				xs[begin] = _remove_leading(xs[begin])
				xs[end] = _remove_trailing(xs[end])
				$T(Result(xs...), false)
			end
			return node
		end
		# Constructor from AbstractString
		function $T(s::AbstractString)
			str = strip_nl(s)
			out = if isempty(str)
				$T(@htl(""), true)
			else
				r = @htl("$(ShowWithPrintHTML(str))")
				$T(r, false)
			end 
		end
		# No-op constructor
		$T(t::$T) = t
		# Generic constructor
		$T(content) = $T(@htl("$content"))
	end
	# Create the function constructing from HypertextLiteral or HTML
	eval(block)
end

## DualNode
struct DualNode <: NonScript{InsideAndOutsidePluto}
	inside_pluto::PlutoNode
	outside_pluto::NormalNode
	DualNode(i::PlutoNode, o::NormalNode) = new(i, o)
end

## CombinedNodes
struct CombinedNodes <: NonScript{InsideAndOutsidePluto}
	nodes::Vector{<:ShowWithPrintHTML}
	function CombinedNodes(v::Vector) 
		swph_vec = map(v) do el
			make_node(el) |> ShowWithPrintHTML
		end
		filtered = filter(swph_vec) do el
			skip_both = shouldskip(el, InsidePluto()) && shouldskip(el, OutsidePluto())
			!skip_both
		end
		new(filtered)
	end
end

const Single = Union{SingleNode, SingleScript}
const Dual = Union{DualScript, DualNode}
const Combined = Union{CombinedScripts, CombinedNodes}

function Base.getproperty(c::Combined, s::Symbol)
	if s === :children
		children(c)
	else
		getfield(c,s)
	end
end
