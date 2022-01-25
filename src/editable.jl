### A Pluto.jl notebook ###
# v0.17.7

# using Markdown
# using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ cfb4d354-e0b2-4a04-a559-4fb88df33954
using HypertextLiteral

# ╔═╡ 62ac26d0-fd65-4733-973d-017fc60c95ba
import AbstractPlutoDingetjes: AbstractPlutoDingetjes, Bonds

# ╔═╡ 57c51c71-fd8d-440d-8262-9cccd1617c08
#=╠═╡ notebook_exclusive
md"""
# Editable Object
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ d9762fc1-fa2c-4315-a360-cc1cd9d70055
#=╠═╡ notebook_exclusive
md"""
Create an element inspired by (and almost equivalent to) the Scrubbable from PlutoUI but with the possibility of changing the value by clicking on the number and editing the value
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 30f5eecc-f9bc-48e9-adb0-628e856bc085
#=╠═╡ notebook_exclusive
md"""
### Examples
"""
  ╠═╡ notebook_exclusive =#

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
	Bonds.initial_value(s::Editable) = s.default

	Bonds.possible_values(s::Editable) = Bonds.InfinitePossibilities()
	Bonds.possible_values(s::Editable{Bool}) = (true, false)

	Bonds.validate_value(s::Editable, from_browser::Number) = true
	Bonds.validate_value(s::Editable{Bool}, from_browser::Bool) = true
	
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
num |> typeof
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

# ╔═╡ 8f7d7dac-d5e6-43f4-88e6-21179c78c3ef
bool_val

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
AbstractPlutoDingetjes = "~1.1.4"
HypertextLiteral = "~0.9.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.1"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╠═cfb4d354-e0b2-4a04-a559-4fb88df33954
# ╠═62ac26d0-fd65-4733-973d-017fc60c95ba
# ╟─57c51c71-fd8d-440d-8262-9cccd1617c08
# ╟─d9762fc1-fa2c-4315-a360-cc1cd9d70055
# ╠═cbeff2f3-3ffe-4aaa-8d4c-43c44ee6d59f
# ╟─30f5eecc-f9bc-48e9-adb0-628e856bc085
# ╠═ecfdee44-3e6c-4e7e-a039-1f7d05a875f8
# ╠═d171e8f9-c939-4747-a748-5568ae4a4064
# ╟─9dfb5236-9475-4bf6-990a-19f8f5519003
# ╠═245fad1a-2f1e-4776-b048-6873e8c33f3b
# ╠═456a3579-3c33-496c-bbf2-6e6e0d0ff102
# ╠═8f7d7dac-d5e6-43f4-88e6-21179c78c3ef
# ╠═a1be6790-c932-11eb-0b3a-23cc77d240e9
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
