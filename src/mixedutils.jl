### A Pluto.jl notebook ###
# v0.17.2

# using Markdown
# using InteractiveUtils

# ╔═╡ df85c8a0-cddf-11eb-36f5-2703c3db615d
using HypertextLiteral

# ╔═╡ c35b32b3-815e-4399-925b-e67838c860f7
#=╠═╡ notebook_exclusive
md"""
### Details
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
export details

# ╔═╡ f4a9dede-828f-4fe2-9469-43d332cfe99a
#=╠═╡ notebook_exclusive
md"### Title Reference"
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
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-rc2"
manifest_format = "2.0"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"
"""

# ╔═╡ Cell order:
# ╠═df85c8a0-cddf-11eb-36f5-2703c3db615d
# ╟─c35b32b3-815e-4399-925b-e67838c860f7
# ╠═554371ac-e171-4e8d-9bce-992423e390f5
# ╠═2d4284af-7074-4ca2-81fe-af7517815813
# ╟─f4a9dede-828f-4fe2-9469-43d332cfe99a
# ╠═19f5749a-b535-4a03-9b79-5f98182b0e84
# ╠═32097aab-ca67-4f5c-858e-79e32e287b29
# ╠═2d9a450f-0b1e-4178-a978-3068488ca4c5
# ╠═e7033fe5-79f8-493f-84bc-0e6074f787e7
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
