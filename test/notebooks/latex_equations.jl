### A Pluto.jl notebook ###
# v0.19.29

using Markdown
using InteractiveUtils

# ╔═╡ 945ee770-e082-11eb-0c8b-25e53f4d718c
begin
	using HypertextLiteral
	using PlutoDevMacros
end

# ╔═╡ 57ec4f3e-ed4d-4c44-af8a-c1e32a3f4bd7
@frompackage "../.." begin
	using ^
end

# ╔═╡ b35233a0-6d2f-4eac-8cb0-e317eef4c835
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## TeX Equation environment
"""
  ╠═╡ =#

# ╔═╡ a78aa624-6504-4b3f-914a-833261b92f19
initialize_eqref() # This is important for making `eqref(label)` work!

# ╔═╡ b8782294-d6b9-43ac-b745-b2cbb6ed06b1
a = 1:10

# ╔═╡ 0bfb8ee9-14e2-44ee-b0d5-98790d47f7b8
texeq("3+2=5")

# ╔═╡ 958531c1-fa83-477c-be3d-927155800f1b
texeq"
	\sum_{i=$(a[1])}^{$(a[end])} i=$(sum(a)) \label{interactive}
"

# ╔═╡ 1482e175-cf32-42f3-b8fb-64f1f14c1501
md"""
The sum in $(eqref("interactive")) is interactive and its equation number reference automatically updates!
"""

# ╔═╡ 0df86e0e-6813-4f9f-9f36-7badf2f85597
md"""Multiple links to the same equation $(eqref("interactive")) also work! See also $(eqref("seven"))
"""

# ╔═╡ 0bd44757-90b8-452f-999f-6109239ac826
md"""
$(texeq("
3
+
2
"))
"""

# ╔═╡ de8473c1-dea1-4221-9562-30679ae58e34
md"""
$$3+2$$
"""

# ╔═╡ b9213424-f814-4bb8-a05f-33249f4f0a8f
md"""
$(texeq("
	(2 \\cdot 3) + (1 \\cdot 4) &= 6 + 4 \\label{test1} \\\\
	&= 10 \\label{test2} \\\\
	&= 10 \\\\
	&= 10 \\label{test3} \\\\
	&= 10 \\\\
	&= 10 \\label{test4} \\\\
	&= 10 \\\\
	&= 10 \\label{test5}"
,"align"))
"""

# ╔═╡ 9e69e30e-506a-4bd7-b213-0b5c0b31a10d
md"""Link to sub-parts of align environments are now fixed! $(eqref("test1")), $(eqref("test2")), $(eqref("test3")), $(eqref("test4")), $(eqref("test5"))
"""

# ╔═╡ ea09b6ec-8d39-4cd9-9c79-85c1fcce3828
texeq("
	\\begin{align*}
		(2 \\cdot 3) + (1 \\cdot 4) &= 6 + 4 \\
									&= 10
	\\end{align*}
	")

# ╔═╡ 900f494b-690d-43cf-b1b7-61c5d3e68a6d
"\n"

# ╔═╡ 7879d7e3-38ad-4a06-8057-ec30da534d76
texeq("y=2x^2")

# ╔═╡ 9446acfc-a310-4de6-8876-e30ede527e9c
md"""
$$Y = \overline {A} - m \phi (\overline {r} - \gamma \pi)$$
"""

# ╔═╡ 6d750d01-b851-4614-b448-1a6e00fa5754
md"""
$(texeq("
	\\pi =  \\pi^e + \\gamma (P - Y^P) + \\rho \\label{seven}"
))
"""

# ╔═╡ 1471265c-4934-45e3-a4b2-37da94ff7472
md"## Update eqref hyperlinks"

# ╔═╡ b6b08bf0-7282-40b9-ae87-b776a64c519f
md"""
KaTeX [supports](https://katex.org/docs/supported.html) automatic numbering of *equation* environments.
While it does not support equation reference and labelling, [this](https://github.com/KaTeX/KaTeX/issues/2003) hack on github shows how to achieve the label functionality.

Unfortunately, since automatic numbering in KaTeX uses CSS counters, it is not possible to access the value of the counter at a specific DOM element.
We then create a function that loops through all possible katex equation and counts them, putting the relevant number in the appropriate hyperlink innerText to create equation references that automatically update.

The code for the mutationobservers to trigger re-computation of the numbers are taken from the **TableOfContents** in **PlutoUI**
"""

# ╔═╡ d14197d8-cab1-4d92-b81c-d826ea8183f3
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## TeX equations
"""
  ╠═╡ =#

# ╔═╡ 943e5ef8-9187-4bfd-aefa-8f405b50e6aa
asdasd = 3

# ╔═╡ 2078d2c8-1f38-42fe-9945-b2235e267b38
texeq"
\frac{q \sqrt{2}}{15} + $(3 + 2 + (5 + 32)) - $asdasd
"

# ╔═╡ 2c82ab99-8e86-41c6-b938-3635d2d3ccde
md"""
The antenna pattern of a DRA antenna can at first approximation be expressed as:
$(texeq("3+2"))
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"

[compat]
HypertextLiteral = "~0.9.4"
PlutoDevMacros = "~0.6.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0-beta2"
manifest_format = "2.0"
project_hash = "4db4ce3ca4328971f4bd140c0e8c876b89cd6192"

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

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "2fb1e02f2b635d0845df5d7c167fec4dd739b00d"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.3"

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
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.0.1+1"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoDevMacros]]
deps = ["AbstractPlutoDingetjes", "DocStringExtensions", "HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Pkg", "Random", "TOML"]
git-tree-sha1 = "06fa4aa7a8f2239eec99cf54eeddd34f3d4359be"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.6.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
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
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╠═945ee770-e082-11eb-0c8b-25e53f4d718c
# ╠═57ec4f3e-ed4d-4c44-af8a-c1e32a3f4bd7
# ╟─b35233a0-6d2f-4eac-8cb0-e317eef4c835
# ╠═a78aa624-6504-4b3f-914a-833261b92f19
# ╠═b8782294-d6b9-43ac-b745-b2cbb6ed06b1
# ╠═0bfb8ee9-14e2-44ee-b0d5-98790d47f7b8
# ╠═958531c1-fa83-477c-be3d-927155800f1b
# ╠═1482e175-cf32-42f3-b8fb-64f1f14c1501
# ╠═0df86e0e-6813-4f9f-9f36-7badf2f85597
# ╠═0bd44757-90b8-452f-999f-6109239ac826
# ╠═de8473c1-dea1-4221-9562-30679ae58e34
# ╠═b9213424-f814-4bb8-a05f-33249f4f0a8f
# ╠═9e69e30e-506a-4bd7-b213-0b5c0b31a10d
# ╠═ea09b6ec-8d39-4cd9-9c79-85c1fcce3828
# ╠═900f494b-690d-43cf-b1b7-61c5d3e68a6d
# ╠═7879d7e3-38ad-4a06-8057-ec30da534d76
# ╠═9446acfc-a310-4de6-8876-e30ede527e9c
# ╠═6d750d01-b851-4614-b448-1a6e00fa5754
# ╟─1471265c-4934-45e3-a4b2-37da94ff7472
# ╟─b6b08bf0-7282-40b9-ae87-b776a64c519f
# ╟─d14197d8-cab1-4d92-b81c-d826ea8183f3
# ╠═2078d2c8-1f38-42fe-9945-b2235e267b38
# ╠═943e5ef8-9187-4bfd-aefa-8f405b50e6aa
# ╠═2c82ab99-8e86-41c6-b938-3635d2d3ccde
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
