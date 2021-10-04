### A Pluto.jl notebook ###
# v0.16.1

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ cfb4d354-e0b2-4a04-a559-4fb88df33954
begin
	using HypertextLiteral
	using HypertextLiteral: JavaScript
end

# ╔═╡ 57c51c71-fd8d-440d-8262-9cccd1617c08
md"""
# Editable Object
"""

# ╔═╡ d9762fc1-fa2c-4315-a360-cc1cd9d70055
md"""
Create an element inspired by (and almost equivalent to) the Scrubbable from PlutoUI but with the possibility of changing the value by clicking on the number and editing the value
"""

# ╔═╡ 30f5eecc-f9bc-48e9-adb0-628e856bc085
md"""
### Examples
"""

# ╔═╡ a1be6790-c932-11eb-0b3a-23cc77d240e9
begin
	Base.@kwdef struct Editable{T <: Number}
		default::T
		format::Union{AbstractString,Nothing}=nothing
		prefix::AbstractString=""
		suffix::AbstractString=""
	end
	Editable(x::Number; kwargs...) = Editable(; default=x, kwargs...)
	Editable(x::Bool,truestr::AbstractString="true",falsestr::AbstractString="false"; kwargs...) = Editable(; default=x, kwargs...,prefix=truestr,suffix=falsestr)
	
	Base.get(s::Editable) = s.default
	
	# In case of Bool type, the prefix and suffix are used as strings to display for the 'true' and 'false' flags respectively
	function Base.show(io::IO, m::MIME"text/html", s::Editable{Bool})
		show(io,m,@htl """
        
		<script>

			const d3format = await import("https://cdn.jsdelivr.net/npm/d3-format@2/+esm")

			const el = html`
			<span style="
			cursor: pointer;
			touch-action: none;
			background: hsl(133, 47%, 68%);
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

		</script>""")
	end
	
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
			<span style="
			touch-action: none;
			background: rgb(175, 222, 253);
			padding: 0em .2em;
			border-radius: .3em;
			font-weight: bold;">$(JavaScript(s.prefix))<span contentEditable=true>$(s.default)</span>$(JavaScript(s.suffix))</span>
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

			// Function to blur the element when pressing enter instead of adding a newline
			const onEnter = (e) => {
				if (e.keyCode === 13) {
				e.preventDefault();
				if (el.innerText === "") {
					elp.value = $(s.default)   
				} else {
					elp.value =  el.innerText
				}
				elp.dispatchEvent(new CustomEvent("input"))
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

			el.addEventListener('keydown',onEnter)
			el.addEventListener('click',(e) => e.stopImmediatePropagation()) // modify text
			elp.addEventListener('click',(e) => selectText(el)) // Select all text

			return elp

		</script>""")
	end
	
	
	
	Editable

end;

# ╔═╡ cbeff2f3-3ffe-4aaa-8d4c-43c44ee6d59f
export Editable

# ╔═╡ ecfdee44-3e6c-4e7e-a039-1f7d05a875f8
#=╠═╡ notebook_exclusive
md"""
This is a number: $(@bind num Editable(3))
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ d171e8f9-c939-4747-a748-5568ae4a4064
#=╠═╡ notebook_exclusive
num
  ╠═╡ notebook_exclusive =#

# ╔═╡ 9dfb5236-9475-4bf6-990a-19f8f5519003
#=╠═╡ notebook_exclusive
md"""
This has also a unit $(@bind unitnum Editable(3.0;suffix=" dB"))
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 245fad1a-2f1e-4776-b048-6873e8c33f3b
#=╠═╡ notebook_exclusive
unitnum
  ╠═╡ notebook_exclusive =#

# ╔═╡ 456a3579-3c33-496c-bbf2-6e6e0d0ff102
#=╠═╡ notebook_exclusive
bool_bond = @bind bool_val Editable(true)
  ╠═╡ notebook_exclusive =#

# ╔═╡ 3347054b-6d72-41f9-9ddf-39f8499ed5da
#=╠═╡ notebook_exclusive
bool_val
  ╠═╡ notebook_exclusive =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-rc1"
manifest_format = "2.0"

[[deps.HypertextLiteral]]
git-tree-sha1 = "72053798e1be56026b81d4e2682dbe58922e5ec9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.0"
"""

# ╔═╡ Cell order:
# ╠═cfb4d354-e0b2-4a04-a559-4fb88df33954
# ╟─57c51c71-fd8d-440d-8262-9cccd1617c08
# ╟─d9762fc1-fa2c-4315-a360-cc1cd9d70055
# ╠═cbeff2f3-3ffe-4aaa-8d4c-43c44ee6d59f
# ╟─30f5eecc-f9bc-48e9-adb0-628e856bc085
# ╟─ecfdee44-3e6c-4e7e-a039-1f7d05a875f8
# ╠═d171e8f9-c939-4747-a748-5568ae4a4064
# ╟─9dfb5236-9475-4bf6-990a-19f8f5519003
# ╠═245fad1a-2f1e-4776-b048-6873e8c33f3b
# ╠═456a3579-3c33-496c-bbf2-6e6e0d0ff102
# ╠═3347054b-6d72-41f9-9ddf-39f8499ed5da
# ╠═a1be6790-c932-11eb-0b3a-23cc77d240e9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
