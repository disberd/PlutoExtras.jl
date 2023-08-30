### A Pluto.jl notebook ###
# v0.19.19

using Markdown
using InteractiveUtils

# ╔═╡ d925254a-935a-11ed-16a1-31e591bd76eb
using HypertextLiteral

# ╔═╡ 5f9f532f-0e55-48c8-b1eb-974eebff3da8
md"""
# RefData
"""

# ╔═╡ dc94e2d3-e1c0-4d57-bea3-78b3c1ecc714
Base.@kwdef struct RefData
	tag::String = ""
	title::String
	authors::String
	date::Int
	link::String
end

# ╔═╡ 610bd05c-e290-4946-a98f-b91170f7cef1
a = md"**DIOGESU** re"

# ╔═╡ 616ab525-e0b9-4cbc-a5d1-309df7a03f84
a.content

# ╔═╡ 25505430-db71-4270-8713-c240664f458e
md"""
## Show Methods
"""

# ╔═╡ 8abcd4cf-6396-420e-91a2-5eb16e754207
barrios = RefData(;
		tag = "[Barrios2020]",
		title = "Fading loss for Earth-to-space lasercom affected by scintillation and beam wander composite channel",
		authors = "Barrios R.",
		date = 2020,
		link = "https://doi.org/10.1117/1.OE.59.5.056103"
	)

# ╔═╡ 5d6bfbb5-2c40-4964-a65a-96591781c1a8
Base.show(io::IO, mime::MIME"text/html", r::RefData) = show(io, mime, @htl("
<span id=$(r.tag)>$(r.tag)</span>: 
<b>$(r.title)</b>, 
<i>$(r.authors)</i>, 
$(r.date);
<a href=$(r.link)>$(r.link)</a>
"))

# ╔═╡ 7886188b-c20a-4577-bc02-ca179aa661f4
"$barrios"

# ╔═╡ db00e747-628f-4350-836f-d855dbbbe630
Base.show(io::IO, r::RefData) = begin
write(io, isempty(r.tag) ? "" : "$(r.tag): ")
write(io, "$(r.title), ")
write(io, "$(r.authors), ")
write(io, "$(r.date), ") 
write(io, "$(r.link).") 
end

# ╔═╡ 66e2a004-c59a-43db-be71-f35d9c0d84f5
Base.show(io, mime::MIME"text/markdown", r::RefData) = begin
	tag = isempty(r.tag) ? "$(r.tag): " : ""
	show(io, mime, md"$(tag)**$(r.title)**, _$(r.authors)_, $(r.date), [$(r.link)]($(r.link))")
end

# ╔═╡ a243cc5d-2b67-4836-aa70-53b90a3b0a19
let r= barrios
	tag = "[gesu]: "
	a = md"$(tag)**$(r.title)**, _$(r.authors)_, $(r.date), [$(r.link)]($(r.link))"
	"$a"
end

# ╔═╡ b8d12c1b-2721-41ed-9426-7cb37df1b3d0
md"$barrios"

# ╔═╡ 99e438d0-6938-4c5d-b287-90efee18596e
"""
$barrios
"""
function tooltip_text(text,link,title="")
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

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.4"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.5"
manifest_format = "2.0"
project_hash = "312e4b9e605df01eeae246a2087d05a62416059a"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"
"""

# ╔═╡ Cell order:
# ╠═d925254a-935a-11ed-16a1-31e591bd76eb
# ╟─5f9f532f-0e55-48c8-b1eb-974eebff3da8
# ╠═dc94e2d3-e1c0-4d57-bea3-78b3c1ecc714
# ╠═610bd05c-e290-4946-a98f-b91170f7cef1
# ╠═616ab525-e0b9-4cbc-a5d1-309df7a03f84
# ╟─25505430-db71-4270-8713-c240664f458e
# ╠═8abcd4cf-6396-420e-91a2-5eb16e754207
# ╠═5d6bfbb5-2c40-4964-a65a-96591781c1a8
# ╠═7886188b-c20a-4577-bc02-ca179aa661f4
# ╠═db00e747-628f-4350-836f-d855dbbbe630
# ╠═66e2a004-c59a-43db-be71-f35d9c0d84f5
# ╠═a243cc5d-2b67-4836-aa70-53b90a3b0a19
# ╠═b8d12c1b-2721-41ed-9426-7cb37df1b3d0
# ╠═99e438d0-6938-4c5d-b287-90efee18596e
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
