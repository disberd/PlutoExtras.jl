### A Pluto.jl notebook ###
# v0.17.2

# using Markdown
# using InteractiveUtils

# ╔═╡ df85c8a0-cddf-11eb-36f5-2703c3db615d
begin
	using HypertextLiteral
	using UUIDs
end

# ╔═╡ 26602f13-f6b5-4514-9b1b-491f9626166f
#=╠═╡ notebook_exclusive
using PlutoUtils
  ╠═╡ notebook_exclusive =#

# ╔═╡ ee6b96f6-7f09-43a4-a674-fe65f62b1e10
#=╠═╡ notebook_exclusive
md"""
# Packages
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 983a0508-278f-4507-9524-1298c4d43ef6
#=╠═╡ notebook_exclusive
ToC()
  ╠═╡ notebook_exclusive =#

# ╔═╡ c0e3d755-0ce9-4332-a1eb-29e0515045ba
#=╠═╡ notebook_exclusive
md"""
# Functions
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ c35b32b3-815e-4399-925b-e67838c860f7
#=╠═╡ notebook_exclusive
md"""
## Details
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 2d4284af-7074-4ca2-81fe-af7517815813
details(x, summary="Show more") = @htl("""
	<details>
		<summary>$(summary)</summary>
		$(x)
	</details>
	""")

# ╔═╡ 554371ac-e171-4e8d-9bce-992423e390f5
export details, position_fixed

# ╔═╡ 5c8232fd-d381-4996-a295-a45241f3953e
#=╠═╡ notebook_exclusive
md"""
## position_fixed
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 86420ad1-4368-4048-948c-be2ae4ceff26
"""
	position_fixed(x;zindex = 500, kwargs...)
Puts the content of x in a separate div that is given the style of position: fixed.
This can be used to have some cell output fixed on the viewport (for example for a table of bonds/parameters) so that one has easy access to the various parameters.

All the values that are passed as kwargs are copied in the css style of the div as `name: value;`.
"""
function position_fixed(x;zindex = 350, kwargs...)
id = "fixed_div_$(rand(UInt))"

io = IOBuffer()
for (n,v) ∈ kwargs
	if v !== nothing
		println(io,"$n: $v;")
	end
end
style = String(take!(io))
@htl """
<div id=$id>
	$x
</div>
<style>
	#$id {
		position: fixed;
		$style
		z-index: $zindex;
	}
</style>
"""
end

# ╔═╡ f4a9dede-828f-4fe2-9469-43d332cfe99a
#=╠═╡ notebook_exclusive
md"## Title Reference"
  ╠═╡ notebook_exclusive =#

# ╔═╡ e7033fe5-79f8-493f-84bc-0e6074f787e7
function title_ref(text,link,title="")
default = @htl("""
<a href=$link class="tooltip">
	$text
</a>
		""")
if title == ""
		return default
else
return @htl("""
<span>
	$default
	<span class="tooltiptext">$title</span>
</span>
<style>

a.tooltip {
	display: inline-block;
	text-decoration: none;
	font-size: 110%;
}

a.tooltip + span {
	position: absolute;
	visibility:hidden;
	top: 1.2em;
	padding:2px 3px;
	width:250px;
	z-index: 50;
}
a.tooltip:hover + span{
visibility:visible; 
background:#ffffff; 
border:1px solid #cccccc; 
color:#6c6c6c;
}
</style>
""")
	end
end

# ╔═╡ 19f5749a-b535-4a03-9b79-5f98182b0e84
#=╠═╡ notebook_exclusive
md"""
asfsdf asdf asdf as df asdf asfd asdf asdf asdf asdf asdf asdf asdf asdf asdre $(title_ref("[1]","https://html.com/attributes/a-title/",@htl("<b>This is a Title</b><br><i>Author 1, Author 2</i>"))) 
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 32097aab-ca67-4f5c-858e-79e32e287b29
#=╠═╡ notebook_exclusive
md"""
f asdf asdf as df asdf asfd asdf asdf asdf asdf asdf asdf asdf asdf asdre $(title_ref("[1]","https://html.com/attributes/a-title/")) 
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 2d9a450f-0b1e-4178-a978-3068488ca4c5
export title_ref

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUtils = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[compat]
HypertextLiteral = "~0.9.3"
PlutoUtils = "~0.5.1"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-rc2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Chain]]
git-tree-sha1 = "cac464e71767e8a04ceee82a889ca56502795705"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.4.8"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Glob]]
git-tree-sha1 = "4df9f7e06108728ebf00a0a11edee4b29a482bb2"
uuid = "c27321d9-0574-5035-807b-f59d2c89b15c"
version = "1.3.0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

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

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoDevMacros]]
deps = ["MacroTools", "Requires"]
git-tree-sha1 = "f5cbbcaa26fe68fd63bc25f5a9e626b7f0e515b0"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.4.4"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[deps.PlutoUtils]]
deps = ["Chain", "Glob", "HypertextLiteral", "PlutoDevMacros", "PlutoUI", "PrettyTables", "Reexport", "Requires", "UUIDs"]
git-tree-sha1 = "684676b3edc1698e540669a766f74d2c23e0bc11"
uuid = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
version = "0.5.1"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─ee6b96f6-7f09-43a4-a674-fe65f62b1e10
# ╠═df85c8a0-cddf-11eb-36f5-2703c3db615d
# ╠═26602f13-f6b5-4514-9b1b-491f9626166f
# ╠═983a0508-278f-4507-9524-1298c4d43ef6
# ╟─c0e3d755-0ce9-4332-a1eb-29e0515045ba
# ╟─c35b32b3-815e-4399-925b-e67838c860f7
# ╠═554371ac-e171-4e8d-9bce-992423e390f5
# ╠═2d4284af-7074-4ca2-81fe-af7517815813
# ╟─5c8232fd-d381-4996-a295-a45241f3953e
# ╠═86420ad1-4368-4048-948c-be2ae4ceff26
# ╟─f4a9dede-828f-4fe2-9469-43d332cfe99a
# ╠═19f5749a-b535-4a03-9b79-5f98182b0e84
# ╠═32097aab-ca67-4f5c-858e-79e32e287b29
# ╠═2d9a450f-0b1e-4178-a978-3068488ca4c5
# ╠═e7033fe5-79f8-493f-84bc-0e6074f787e7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
