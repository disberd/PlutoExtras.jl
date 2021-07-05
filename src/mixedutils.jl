### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 908555d1-c408-4650-badb-52f25ead116f
if isdefined(Main,:PlutoRunner)
	import Pkg
	Pkg.activate("../")
end

# ╔═╡ df85c8a0-cddf-11eb-36f5-2703c3db615d
begin
	using HypertextLiteral
	using HypertextLiteral: JavaScript
	using PrettyTables
	using Gumbo
	using Cascadia
	using Chain
end

# ╔═╡ 2d4284af-7074-4ca2-81fe-af7517815813
details(x, summary="Show more") = @htl("""
	<details>
		<summary>$(summary)</summary>
		$(x)
	</details>
	""")

# ╔═╡ 554371ac-e171-4e8d-9bce-992423e390f5
export details

# ╔═╡ e91780ec-ecaa-4017-b778-9e0ce61840d8
md"### PrettyTable"

# ╔═╡ ac456935-c964-4b7b-b51b-aaf99115f75f
"Function to print the nicely styled HTML table using pretty print and @htl"
function prettytable(tab;kwargs...)
	# Extract the root of the standalone table
	tabhtml = @chain tab begin
		pretty_table(String,_;kwargs...,backend=:html,standalone=true)
		parsehtml 
		_.root
	end
	# Get style
	style = @chain tabhtml begin
		eachmatch(sel"style",_)
		_[1]
		sprint(println,_)
	end
	# Get table body
	tbody = @chain tabhtml begin
		eachmatch(sel"table",_)
		_[1]
		sprint(println,_)
	end
	# Eval the join string in @htl
	eval(:(@htl $(join([style,tbody]))))
end

# ╔═╡ 79bc4418-4804-49de-8ed4-d7066a387154
prettytable([1 2;3 4])

# ╔═╡ da75e122-9a51-4a2c-9401-2d8263176996
export prettytable

# ╔═╡ f4a9dede-828f-4fe2-9469-43d332cfe99a
md"### Title Reference"

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
md"""
asfsdf asdf asdf as df asdf asfd asdf asdf asdf asdf asdf asdf asdf asdf asdre $(title_ref("[1]","https://html.com/attributes/a-title/",@htl("<b>This is a Title</b><br><i>Author 1, Author 2</i>"))) 
"""

# ╔═╡ 32097aab-ca67-4f5c-858e-79e32e287b29
md"""
f asdf asdf as df asdf asfd asdf asdf asdf asdf asdf asdf asdf asdf asdre $(title_ref("[1]","https://html.com/attributes/a-title/")) 
"""

# ╔═╡ 2d9a450f-0b1e-4178-a978-3068488ca4c5
export title_ref

# ╔═╡ Cell order:
# ╠═908555d1-c408-4650-badb-52f25ead116f
# ╠═df85c8a0-cddf-11eb-36f5-2703c3db615d
# ╠═554371ac-e171-4e8d-9bce-992423e390f5
# ╠═2d4284af-7074-4ca2-81fe-af7517815813
# ╠═e91780ec-ecaa-4017-b778-9e0ce61840d8
# ╠═79bc4418-4804-49de-8ed4-d7066a387154
# ╠═da75e122-9a51-4a2c-9401-2d8263176996
# ╠═ac456935-c964-4b7b-b51b-aaf99115f75f
# ╟─f4a9dede-828f-4fe2-9469-43d332cfe99a
# ╠═19f5749a-b535-4a03-9b79-5f98182b0e84
# ╠═32097aab-ca67-4f5c-858e-79e32e287b29
# ╠═2d9a450f-0b1e-4178-a978-3068488ca4c5
# ╠═e7033fe5-79f8-493f-84bc-0e6074f787e7
