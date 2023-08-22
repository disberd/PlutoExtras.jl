### A Pluto.jl notebook ###
# v0.19.27

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 46af7028-633e-432f-a9fc-fad15589bf2a
using HypertextLiteral

# ╔═╡ 3b1033d4-f1b3-4509-8592-75cb42d25034
import AbstractPlutoDingetjes: AbstractPlutoDingetjes, Bonds

# ╔═╡ 82bba4fc-3ad7-4f71-9d62-4100540c7d43
md"""
# String On Enter
"""

# ╔═╡ 1ceca066-3b1a-412e-9458-63cf3b295e0d
md"""
Create an element inspired by TextField from PlutoUI but with the possibility of updating the bond value only when `Enter` is pressed ot the focus is moved away from the field itself.
"""

# ╔═╡ b5d6af68-63c0-43dc-b63a-679fea381b8d
md"""
## Example
"""

# ╔═╡ cffff0cf-8f1b-414f-ae81-72b41ab1636a
begin
	
	struct StringOnEnter
		default::String
	end
		
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
						dispatchEvent(e)
						el.blur()
						}
					}
		elp.addEventListener('focusout',dispatchEvent)
		elp.addEventListener('keydown',onEnter)
	</script>
	
	<style>
			@media (prefers-color-scheme: light) {
				span.text_StringOnEnter {
					background: hsl(135, 57%, 60%);
				}
			}
			@media (prefers-color-scheme: dark) {
				span.text_StringOnEnter {
					background: hsl(135, 43%, 32%);
				}
			}
	</style>
	""")
	
	Base.get(t::StringOnEnter) = t.default
	initial_value(t::StringOnEnter) = t.default
	possible_values(t::StringOnEnter) = InfinitePossibilities()
	
	function validate_value(t::StringOnEnter, val)
		val isa AbstractString
	end
	
end

# ╔═╡ e6a75043-435d-4509-98dd-9c96fa6b5bbb
export StringOnEnter

# ╔═╡ 4c21d9e5-23e4-4001-be12-05959a464643
md"""
This is an example of `StringOnEnter`: $(@bind text StringOnEnter("ciao"))
"""

# ╔═╡ c441e589-3a31-4390-806c-c3a4546aa7b6
text

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
AbstractPlutoDingetjes = "~1.2.0"
HypertextLiteral = "~0.9.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "670e29e5e14c0b77861d15d4d002a9f5a469c07b"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "91bd53c39b9cbfb5ef4b015e8b582d344532bd0a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.2.0"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

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
version = "2.28.2+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

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
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╠═46af7028-633e-432f-a9fc-fad15589bf2a
# ╠═3b1033d4-f1b3-4509-8592-75cb42d25034
# ╟─82bba4fc-3ad7-4f71-9d62-4100540c7d43
# ╟─1ceca066-3b1a-412e-9458-63cf3b295e0d
# ╠═e6a75043-435d-4509-98dd-9c96fa6b5bbb
# ╟─b5d6af68-63c0-43dc-b63a-679fea381b8d
# ╠═4c21d9e5-23e4-4001-be12-05959a464643
# ╠═c441e589-3a31-4390-806c-c3a4546aa7b6
# ╠═cffff0cf-8f1b-414f-ae81-72b41ab1636a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
