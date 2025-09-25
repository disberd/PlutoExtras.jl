### A Pluto.jl notebook ###
# v0.20.17

#> custom_attrs = ["enable_hidden", "hide-enabled"]

using Markdown
using InteractiveUtils

# ╔═╡ 464fc674-5ed7-11ed-0aff-939456ebc5a8
begin
	using HypertextLiteral
	using PlutoUI
	using PlutoDevMacros
end

# ╔═╡ e1d8a572-21ec-4db9-a640-f3521a16cb1f
@frompackage "../.." begin
	using ^.ExtendedToc: *
end

# ╔═╡ d05d4e8c-bf50-4343-b6b5-9b77caa646cd
ExtendedTableOfContents()

# ╔═╡ 48540378-5b63-4c20-986b-75c08ceb24b7
md"""
# Tests
"""

# ╔═╡ 7dce5ffb-48ad-4ef4-9e13-f7a34794170a
md"""
The weird looking 3 below is inside a hidden cell that has been tagged with `show_output_when_hidden`
"""

# ╔═╡ 091dbcb6-c5f6-469b-889a-e4b23197d2ad
md"""
## very very very very very very very very very long
"""

# ╔═╡ c9bcf4b9-6769-4d5a-bbc0-a14675e11523
md"""
### Short
"""

# ╔═╡ 4373ab10-d4e7-4e25-b7a8-da1fcf3dcb0c
# ╠═╡ custom_attrs = ["toc-hidden"]
md"""
## Hidden Heading
"""

# ╔═╡ 77e467b9-c86c-4f13-a259-c38dfd80a3aa
2 # This will be completely hidden

# ╔═╡ f6e74270-bd75-4367-a0b2-1e10e1336b6c
# ╠═╡ skip_as_script = true
#=╠═╡
3 |> show_output_when_hidden # This will keep showing
  ╠═╡ =#

# ╔═╡ 6ddee4cb-7d76-483e-aed5-bde46280cc5b
md"""
## Random JS Tests
"""

# ╔═╡ 239b3956-69d7-43dc-80b8-92f43b84aada
@htl """
<div class='parent'>
	<span class='child first'></span>
	<span class='child second'></span>
	<span class='child third'></span>
</div>
<style>
	div.parent {
		position: fixed;
		top: 30px;
		left: 30px;
		background: lightblue;
		display: flex;
		height: 30px;
	}
	span.child {
		align-self: stretch;
		width: 20px;
		display: inline-block;
		background: green;
		margin: 5px 0px;
	}
</style>
""";

# ╔═╡ c4490c71-5994-4849-914b-ec1a88ec7881
# ╠═╡ custom_attrs = ["toc-collapsed"]
md"""
# Fillers
"""

# ╔═╡ fd6772f5-085a-4ffa-bf55-dfeb8e93d32b
md"""
## More Fillers
"""

# ╔═╡ 863e6721-98f1-4311-8b9e-fa921030f7d7
md"""
## More Fillers
"""

# ╔═╡ 515b7fc0-1c03-4c82-819b-4bf70baf8f14
md"""
## More Fillers
"""

# ╔═╡ e4a29e2e-c2ec-463b-afb2-1681c849780b
md"""
## More Fillers
"""

# ╔═╡ eb559060-5da1-4a9e-af51-9007392885eb
md"""
## More Fillers
"""

# ╔═╡ 1aabb7b3-692f-4a27-bb34-672f8fdb0753
md"""
## More Fillers
"""

# ╔═╡ ac541f37-7af5-49c8-99f8-c5d6df1a6881
md"""
## More Fillers
"""

# ╔═╡ fdf482d1-f8fa-4628-9417-2816de367e94
md"""
## More Fillers
"""

# ╔═╡ 6de511d2-ad79-4f0e-95ff-ce7531f3f0c8
md"""
## More Fillers
"""

# ╔═╡ a8bcd2cc-ae01-4db7-822f-217c1f6bbc8f
md"""
## More Fillers
"""

# ╔═╡ 9ddc7a20-c1c9-4af3-98cc-3b803ca181b5
md"""
## More Fillers
"""

# ╔═╡ 6dd2c458-e02c-4850-a933-fe9fb9dcdf39
md"""
## More Fillers
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.4"
PlutoDevMacros = "~0.9.1"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.12.0-rc2"
manifest_format = "2.0"
project_hash = "dfc547520a0f28a7cf33ecc42c4ecaba11dd2b7e"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.CodeTracking]]
deps = ["InteractiveUtils", "UUIDs"]
git-tree-sha1 = "980f01d6d3283b3dbdfd7ed89405f96b7256ad57"
uuid = "da1fd8a2-8d9e-5ec2-8556-3022fb5608a2"
version = "2.0.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "67e11ee83a43eb71ddc950302c53bf33f0690dfe"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.12.1"
weakdeps = ["StyledStrings"]

    [deps.ColorTypes.extensions]
    StyledStringsExt = "StyledStrings"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.3.0+1"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.JuliaInterpreter]]
deps = ["CodeTracking", "InteractiveUtils", "Random", "UUIDs"]
git-tree-sha1 = "d8337622fe53c05d16f031df24daf0270e53bc64"
uuid = "aa1ae85d-cabe-5617-a682-6adf51b2e16a"
version = "0.10.5"

[[deps.JuliaSyntaxHighlighting]]
deps = ["StyledStrings"]
uuid = "ac6e5ff7-fb65-4e79-a425-ec3bc9c03011"
version = "1.12.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.11.1+1"

[[deps.LibGit2]]
deps = ["LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "OpenSSL_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.9.0+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "OpenSSL_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.3+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.12.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.MacroTools]]
git-tree-sha1 = "1e0228a030642014fe5cfe68c2c0a818f9e3f522"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.16"

[[deps.Markdown]]
deps = ["Base64", "JuliaSyntaxHighlighting", "StyledStrings"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2025.5.20"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.3.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.29+0"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "3.5.1+0"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "7d2f8f21da5db6a806faf7b9b292296da42b2810"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.3"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.12.0"

    [deps.Pkg.extensions]
    REPLExt = "REPL"

    [deps.Pkg.weakdeps]
    REPL = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.PlutoDevMacros]]
deps = ["JuliaInterpreter", "Logging", "MacroTools", "Pkg", "TOML"]
git-tree-sha1 = "1cb861c9295d79dc6e23170d4b33bce013f69643"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.9.1"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Downloads", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "8329a3a4f75e178c11c1ce2342778bcbbbfa7e3c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.71"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "07a921781cab75691315adc645096ed5e370cb77"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.3.3"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "0f27480397253da18fe2c12a4ba4eb9eb208bf3d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.5.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "372b90fe551c019541fafc6ff034199dc19c8436"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.12"

[[deps.URIs]]
git-tree-sha1 = "bef26fb046d031353ef97a82e3fdb6afe7f21b1a"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.6.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.3.1+2"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.13.1+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.64.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.5.0+2"
"""

# ╔═╡ Cell order:
# ╠═464fc674-5ed7-11ed-0aff-939456ebc5a8
# ╠═e1d8a572-21ec-4db9-a640-f3521a16cb1f
# ╠═d05d4e8c-bf50-4343-b6b5-9b77caa646cd
# ╠═48540378-5b63-4c20-986b-75c08ceb24b7
# ╟─7dce5ffb-48ad-4ef4-9e13-f7a34794170a
# ╠═091dbcb6-c5f6-469b-889a-e4b23197d2ad
# ╠═c9bcf4b9-6769-4d5a-bbc0-a14675e11523
# ╟─4373ab10-d4e7-4e25-b7a8-da1fcf3dcb0c
# ╠═77e467b9-c86c-4f13-a259-c38dfd80a3aa
# ╠═f6e74270-bd75-4367-a0b2-1e10e1336b6c
# ╟─6ddee4cb-7d76-483e-aed5-bde46280cc5b
# ╠═239b3956-69d7-43dc-80b8-92f43b84aada
# ╠═c4490c71-5994-4849-914b-ec1a88ec7881
# ╠═fd6772f5-085a-4ffa-bf55-dfeb8e93d32b
# ╠═863e6721-98f1-4311-8b9e-fa921030f7d7
# ╠═515b7fc0-1c03-4c82-819b-4bf70baf8f14
# ╠═e4a29e2e-c2ec-463b-afb2-1681c849780b
# ╠═eb559060-5da1-4a9e-af51-9007392885eb
# ╠═1aabb7b3-692f-4a27-bb34-672f8fdb0753
# ╠═ac541f37-7af5-49c8-99f8-c5d6df1a6881
# ╠═fdf482d1-f8fa-4628-9417-2816de367e94
# ╠═6de511d2-ad79-4f0e-95ff-ce7531f3f0c8
# ╠═a8bcd2cc-ae01-4db7-822f-217c1f6bbc8f
# ╠═9ddc7a20-c1c9-4af3-98cc-3b803ca181b5
# ╠═6dd2c458-e02c-4850-a933-fe9fb9dcdf39
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
