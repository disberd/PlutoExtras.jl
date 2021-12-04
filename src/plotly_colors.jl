### A Pluto.jl notebook ###
# v0.17.2

# using Markdown
# using InteractiveUtils

# ╔═╡ c52b5a80-54fb-11ec-1f90-9b2c880f2046
begin
	import Colors
	using DocStringExtensions
end

# ╔═╡ 73072f1e-84a5-46f3-a40e-45e46c946d76
#=╠═╡ notebook_exclusive
begin
	using PlotlyBase
	using PlutoUtils
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ adbca5a8-7238-4b93-a6fc-b7d97816aa10
#=╠═╡ notebook_exclusive
md"""
## distinguishable_colorscale
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 52667e42-917e-4ee4-9d57-d616e046eb84
"""
$TYPEDSIGNATURES
Given a vector of colors `colorvec` to be used as colorscale for plotly, returns the vector that can be fed as `colorscale` kwarg to PlotlyBase traces.
When called without an argument, defaults to the 4 julia logo colors.
"""
get_plotly_colorscale(colorvec::AbstractVector{<:Colors.Colorant} = collect(Colors.JULIA_LOGO_COLORS)) = [[n, c] for (n,c) ∈ zip(range(0,1,length(colorvec)), colorvec)]

# ╔═╡ e6b8da75-eef3-44c4-8bdf-14f0b5797429
"""
$TYPEDSIGNATURES
Generate a colorscale with distiguishable colors to be used withPlotlyBase,
The arguments and kwargs are the same (and forwarded to the internal call) of `Colors.distinguishable_colors`.
"""
function distinguishable_colorscale(N::Int, seed = Colors.RGB(1,0,0); kwargs...)
	colorvec = Colors.distinguishable_colors(N, seed; kwargs...)
	plotly_colorscale = get_plotly_colorscale(colorvec)
end

# ╔═╡ cd950083-45c4-4303-8b89-aec8c7cdfc27
#=╠═╡ notebook_exclusive
let
	N = 16
	pts = [(rand(), rand()) .* 10 for _ ∈ 1:100]
	colors = rand(1:N, length(pts))
	data = scatter(pts; mode = "markers", marker = attr(
		color = colors,
		colorscale = distinguishable_colorscale(N),
	))
	Plot(data)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ f5a70399-bfc1-4bfe-92f3-63c63988eebb
const color_order_64 = [
Colors.colorant"#4682b4"
Colors.colorant"#008080"
Colors.colorant"#ff8c00"
Colors.colorant"#ff0000"
Colors.colorant"#8b4513"
Colors.colorant"#a9a9a9"
Colors.colorant"#663399"
Colors.colorant"#ffd700"
Colors.colorant"#7cfc00"
Colors.colorant"#7f007f"
Colors.colorant"#4169e1"
Colors.colorant"#2f4f4f"
Colors.colorant"#ffb6c1"
Colors.colorant"#006400"
Colors.colorant"#ffe4c4"
Colors.colorant"#3cb371"
Colors.colorant"#c71585"
Colors.colorant"#483d8b"
Colors.colorant"#bc8f8f"
Colors.colorant"#bdb76b"
Colors.colorant"#cd853f"
Colors.colorant"#ffff54"
Colors.colorant"#556b2f"
Colors.colorant"#d2691e"
Colors.colorant"#dcdcdc"
Colors.colorant"#dc143c"
Colors.colorant"#9acd32"
Colors.colorant"#00008b"
Colors.colorant"#32cd32"
Colors.colorant"#daa520"
Colors.colorant"#0000cd"
Colors.colorant"#8fbc8f"
Colors.colorant"#b03060"
Colors.colorant"#66cdaa"
Colors.colorant"#9932cc"
Colors.colorant"#00ced1"
Colors.colorant"#808000"
Colors.colorant"#7f0000"
Colors.colorant"#191970"
Colors.colorant"#deb887"
Colors.colorant"#00ff00"
Colors.colorant"#00fa9a"
Colors.colorant"#708090"
Colors.colorant"#00ffff"
Colors.colorant"#00bfff"
Colors.colorant"#9370db"
Colors.colorant"#0000ff"
Colors.colorant"#a020f0"
Colors.colorant"#f08080"
Colors.colorant"#d8bfd8"
Colors.colorant"#ff6347"
Colors.colorant"#ff00ff"
Colors.colorant"#db7093"
Colors.colorant"#f0e68c"
Colors.colorant"#6495ed"
Colors.colorant"#dda0dd"
Colors.colorant"#90ee90"
Colors.colorant"#87ceeb"
Colors.colorant"#ff1493"
Colors.colorant"#ffa07a"
Colors.colorant"#afeeee"
Colors.colorant"#ee82ee"
Colors.colorant"#7fffd4"
Colors.colorant"#ff69b4"
]

# ╔═╡ c3ffe844-e373-4c3c-b871-0759d0173fdd
"""
$TYPEDSIGNATURES
Generate a colorscale with pre-defined distiguishable colors to be used with PlotlyBase, the maximum number of selectable colors with this function is `N = 64`.
"""
function predefined_colorscale(N::Int)
	@assert N <= 64 "A maximum of 64 colors are supported for the predefined colorscale"
	colorvec = color_order_64[1:N]
	plotly_colorscale = get_plotly_colorscale(colorvec)
end

# ╔═╡ 7a8a5a15-b08e-4d02-8839-72bd8b5626b0
export distinguishable_colorscale, get_plotly_colorscale, predefined_colorscale

# ╔═╡ fe1b5c1f-a0e2-4879-9bac-9d3743959a6c
#=╠═╡ notebook_exclusive
let
	N = 4
	pts = [(rand(), rand()) .* 10 for _ ∈ 1:100]
	colors = rand(1:N, length(pts))
	data = scatter(pts; mode = "markers", marker = attr(
		color = colors,
		colorscale = predefined_colorscale(N),
	))
	Plot(data)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Colors = "5ae59095-9a9b-59fe-a467-6f913c188581"
DocStringExtensions = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlutoUtils = "ed5d0301-4775-4676-b788-cf71e66ff8ed"

[compat]
Colors = "~0.12.8"
DocStringExtensions = "~0.8.6"
PlotlyBase = "~0.8.18"
PlutoUtils = "~0.5.4"
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

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

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

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

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

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "180d744848ba316a3d0fdf4dbd34b77c7242963a"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.18"

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
deps = ["Chain", "Glob", "HypertextLiteral", "OrderedCollections", "PlutoDevMacros", "PlutoUI", "PrettyTables", "Reexport", "Requires", "StaticArrays", "UUIDs"]
git-tree-sha1 = "129be2ff7fcd189a3b2d6e41d0fa9e8c0115ef42"
uuid = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
version = "0.5.4"

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

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

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
# ╠═c52b5a80-54fb-11ec-1f90-9b2c880f2046
# ╠═73072f1e-84a5-46f3-a40e-45e46c946d76
# ╠═7a8a5a15-b08e-4d02-8839-72bd8b5626b0
# ╟─adbca5a8-7238-4b93-a6fc-b7d97816aa10
# ╠═e6b8da75-eef3-44c4-8bdf-14f0b5797429
# ╠═52667e42-917e-4ee4-9d57-d616e046eb84
# ╠═cd950083-45c4-4303-8b89-aec8c7cdfc27
# ╠═f5a70399-bfc1-4bfe-92f3-63c63988eebb
# ╠═c3ffe844-e373-4c3c-b871-0759d0173fdd
# ╠═fe1b5c1f-a0e2-4879-9bac-9d3743959a6c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
