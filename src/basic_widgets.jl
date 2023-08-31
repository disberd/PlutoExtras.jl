# Editable #
#=
Create an element inspired by (and almost equivalent to) the Scrubbable from
PlutoUI but with the possibility of changing the value by clicking on the number
and editing the value
=#

## Struct ##

Base.@kwdef struct Editable{T <: Number}
	default::T
	format::Union{AbstractString,Nothing}=nothing
	prefix::AbstractString=""
	suffix::AbstractString=""
end

### Real Version ###
"""
	Editable(x::Real; [prefix, suffix, format])
Create a Pluto widget similar to [`Scrubbable`](@ref) from PlutoUI but that can contain an arbitrary (Real) number provided as input.

The displayed HTML will create a span with a blue background which contains the number and is preceded by an optional text `prefix` and an optional text `suffix`. If `format` is specified, it will be used to format the shown number using the [d3-format](https://github.com/d3/d3-format#locale_format) specification.

The widget will trigger a bond update only upon pressing Enter or moving the focus out of the widget itself.

![79f77981-2c53-4ff0-bd13-8213519e0bca](https://github.com/disberd/PlutoExtras.jl/assets/12846528/cb0f19e3-7dcb-46d6-88b1-1bbe1592dd1c)

# Keyword Arguments
- `prefix::AbstractString`: A string that will be inserted in the displayed HTML before the number. Clicking on the suffix will select the full text defining the number
- `suffix::AbstractString`: A string that will be inserted in the displayed HTML after the number. Clicking on the suffix will select the full text defining the number
- `format::AbstractString`: A string specifing the format to use for displaying the number in HTML. Uses the [d3-format](https://github.com/d3/d3-format#locale_format) specification
"""
Editable(x::Real; kwargs...) = Editable(; default=x, kwargs...)

### Bool Version ###
"""
	Editable(x::Bool[, true_string="true", false_string="false")
Create a Pluto widget that contain a Boolean value.

The displayed HTML will create a span with a green background that displays the custom string `true_string` when true and the `false_string` when false. If not provided, the second argument `true_string` defaults to "true" and the third one the "false".

The widget will trigger a bond update when clicking on it.

![991b712a-d62d-4036-b096-fe0fc52c9b25](https://github.com/disberd/PlutoExtras.jl/assets/12846528/f12e3bc3-f78c-45b5-b5fd-06f2083fc5c4)
"""
Editable(x::Bool,truestr::AbstractString="true",falsestr::AbstractString="false"; kwargs...) = Editable(; default=x, kwargs...,prefix=truestr,suffix=falsestr)

### AbstractPlutoDingetjes methods ###
Base.get(s::Editable) = s.default
Bonds.initial_value(s::Editable) = s.default

Bonds.possible_values(s::Editable) = Bonds.InfinitePossibilities()
Bonds.possible_values(s::Editable{Bool}) = (true, false)

Bonds.validate_value(s::Editable, from_browser::Number) = true

### Show - Bool ###
# In case of Bool type, the prefix and suffix are used as strings to display for the 'true' and 'false' flags respectively
function Base.show(io::IO, m::MIME"text/html", s::Editable{Bool})
	show(io,m,@htl """
	
	<script>
		const d3format = await import("https://cdn.jsdelivr.net/npm/d3-format@2/+esm")

		const el = html`
		<span class="bool_Editable" style="
		cursor: pointer;
		touch-action: none;
		padding: 0em .2em;
		border-radius: .3em;
		font-weight: bold;">$(s.default)</span>
		`
		const formatter = x => x ? $((s.prefix)) : $((s.suffix))

		let localVal = $(s.default)
		el.innerText = formatter($(s.default))
		
		Object.defineProperty(el,"value",{
			get: () => Boolean(localVal),
			set: x => {
				localVal = Boolean(x)
				el.innerText = formatter(x)
			}
		})

		el.addEventListener('click',(e) => {
			el.value = el.value ? false : true 
			el.dispatchEvent(new CustomEvent("input"))
			})
		
		el.onselectstart = () => false
		
		return el

	</script>
	<style>
		@media (prefers-color-scheme: light) {
			span.bool_Editable {
				background: hsl(133, 47%, 73%);
			}
		}
		@media (prefers-color-scheme: dark) {
			span.bool_Editable {
				background: hsl(133, 47%, 40%);
			}
		}
	</style>
	""")
end

### Show - Generic ###
function Base.show(io::IO, m::MIME"text/html", s::Editable)
	format = if s.format === nothing
		# TODO: auto format
		if eltype(s.default) <: Integer
			""
		else
			".4~g"
		end
	else
		String(s.format)
	end

	show(io,m,@htl """

	<script>
		const d3format = await import("https://cdn.jsdelivr.net/npm/d3-format@2/+esm")

		const elp = html`
		<span class="number_Editable" style="
		touch-action: none;
		padding: 0em .2em;
		border-radius: .3em;
		font-weight: bold;">$(HypertextLiteral.JavaScript(s.prefix))<span contentEditable=true>$(s.default)</span>$(HypertextLiteral.JavaScript(s.suffix))</span>
		`

		const formatter = s => d3format.format($(format))(s)
		const el = elp.querySelector("span")

		let localVal = parseFloat($(s.default))
		el.innerText = formatter($(s.default))
		
		Object.defineProperty(elp,"value",{
			get: () => localVal,
			set: x => {
				localVal = parseFloat(x)
				el.innerText = formatter(x)
			}
		})

		const dispatchEvent = (e) => {
			if (el.innerText === "") {
				elp.value = $(s.default)   
			} else {
				/* 
				The replace is needed because d3-format outputs '-' as in U+2212 (math symbol) but fails to parse negative number correctly if they have that sign as negative sign. So we just replace it with the dash U+002D sign 
				*/
				elp.value =  el.innerText.replace('−', '-')
			}
			elp.dispatchEvent(new CustomEvent("input"))
		}

		// Function to blur the element when pressing enter instead of adding a newline
		const onEnter = (e) => {
			if (e.keyCode === 13) {
			e.preventDefault();
			el.blur()
			}
		}

		el.addEventListener('input',(e) => {
			console.log(e)
			e.preventDefault()
			e.stopImmediatePropagation()
		})

		function selectText(el){
			var sel, range;
			if (window.getSelection && document.createRange) { //Browser compatibility
			sel = window.getSelection();
			if(sel.toString() == ''){ //no text selection
				window.setTimeout(function(){
					range = document.createRange(); //range object
					range.selectNodeContents(el); //sets Range
					sel.removeAllRanges(); //remove all ranges from selection
					sel.addRange(range);//add Range to a Selection.
				},1);
			}
			}else if (document.selection) { //older ie
				sel = document.selection.createRange();
				if(sel.text == ''){ //no text selection
					range = document.body.createTextRange();//Creates TextRange object
					range.moveToElementText(el);//sets Range
					range.select(); //make selection.
				}
			}
		}

		
		el.addEventListener('focusout',dispatchEvent)
		el.addEventListener('keydown',onEnter)
		el.addEventListener('click',(e) => e.stopImmediatePropagation()) // modify text
		elp.addEventListener('click',(e) => selectText(el)) // Select all text

		return elp

	</script>
	<style>
		@media (prefers-color-scheme: light) {
			span.number_Editable {
				background: hsl(204, 95%, 84%);
			}
		}
		@media (prefers-color-scheme: dark) {
			span.number_Editable {
				background: hsl(204, 95%, 40%);
			}
		}
	</style>
	""")
end

# StringOnEnter #
#=
Create an element inspired by TextField from PlutoUI but with the possibility of
updating the bond value only when `Enter` is pressed ot the focus is moved away
from the field itself.
=#

## Struct ##

"""
	StringOnEnter(default::AbstractString)
Creates a Pluto widget that allows to provide a string as output when used with `@bind`.

Unlike the custom "TextField" from PlutoUI this only triggers a bond update upon pressing Enter or moving the focus out of the widget (similar to [`Editable`](@ref))

When rendered in HTML, the widget text will be shown with a dark yellow background.

![868c1c6e-8731-4465-959e-58cf551b9f61](https://github.com/disberd/PlutoExtras.jl/assets/12846528/782360f2-595a-4bbe-9769-5ddfaa144611)
"""
struct StringOnEnter
	default::String
end

## StringOnEnter - Show ##
	
Base.show(io::IO, mime::MIME"text/html", mt::StringOnEnter) = show(io, mime, @htl """
<span><span 
	class="text_StringOnEnter" style="
		padding: 0em .2em;
		border-radius: .3em;
		font-weight: bold;"
	contentEditable=true>$(mt.default)</span></span>

<script>
	const elp = currentScript.previousElementSibling
	const el = elp.querySelector('span')
	Object.defineProperty(elp,"value",{
				get: () => el.innerText,
				set: x => {
					el.innerText = x
				}
			})
	
	const dispatchEvent = (e) => {
					if (el.innerText === "") {
						elp.value = $(mt.default)   
					} else {
						elp.value =  el.innerText
					}
					elp.dispatchEvent(new CustomEvent("input"))
				}
	
	el.addEventListener('input',(e) => {
					console.log(e)
					e.preventDefault()
					e.stopImmediatePropagation()
				})
	
	const onEnter = (e) => {
					if (e.keyCode === 13) {
					e.preventDefault();
					el.blur()
					}
				}
	elp.addEventListener('focusout',dispatchEvent)
	elp.addEventListener('keydown',onEnter)
</script>

<style>
		@media (prefers-color-scheme: light) {
			span.text_StringOnEnter {
				background: hsl(48, 90%, 61%);
			}
		}
		@media (prefers-color-scheme: dark) {
			span.text_StringOnEnter {
				background: hsl(48, 57%, 37%);
			}
		}
</style>
""")

## AbstractPlutoDingetjes Methods ##
Base.get(t::StringOnEnter) = t.default
Bonds.initial_value(t::StringOnEnter) = t.default
Bonds.possible_values(t::StringOnEnter) = Bonds.InfinitePossibilities()

function Bonds.validate_value(t::StringOnEnter, val)
	val isa AbstractString
end