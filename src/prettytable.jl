### A Pluto.jl notebook ###
# v0.17.2

# using Markdown
# using InteractiveUtils

# ╔═╡ 104611e0-e53f-11eb-1bb5-61dd3dd0acf2
using PrettyTables, HypertextLiteral, Chain, UUIDs

# ╔═╡ afebdbb9-42a5-4640-ae38-12a105a70e05
#=╠═╡ notebook_exclusive
md"""
PrettyTables does not provide yet a way to directly output a _showable_ HTML object so the function has to be customized to have nice printing on Pluto.

We will create a custom function that always prints directly an html output (with the :html backend) and that won't allow for the `standalone` kwargs to be set to true as that always provide a full html page with header, that needs to be rendered in an `iframe` inside the pluto frontend
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ b80ac7b8-11a4-45ef-8072-97a5ef0ab4e2
#=╠═╡ notebook_exclusive
pretty_table(String,rand(10,4);backend=:html) |> Text
  ╠═╡ notebook_exclusive =#

# ╔═╡ 5db046c0-48a2-478b-a8cd-a72c29c14444
#=╠═╡ notebook_exclusive
pretty_table(String,rand(10,4);backend=:html,standalone=false) |> Text
  ╠═╡ notebook_exclusive =#

# ╔═╡ 22386594-49c7-4c3b-948e-fd13d326d360
    css = """
    table, td, th {
        border-collapse: collapse;
        font-family: sans-serif;
    }

    td, th {
        border-bottom: 0;
        background: #fff !important;
        padding: 4px
    }

    tr.header {
        background: #fff !important;
        font-weight: bold;
    }

    tr.subheader {
        background: #fff !important;
        color: dimgray;
    }

    tr.headerLastRow {
        border-bottom: 2px solid black;
    }

    th.rowNumber, td.rowNumber {
        text-align: right;
    }
    """

# ╔═╡ b18e8c7f-467e-427c-8487-e021bd8c283a
#=╠═╡ notebook_exclusive
@chain css begin
	split(_,'}') # Separate different style groups
	map(x -> lstrip(x,'\n'),_) # Remove trailing newlines		
	filter(!isempty,_)
	map(x -> split(x,','),_) # Find the differents combined CSS selectors as they have to be prepended with the class together
	map(_) do style # Here we go to prepend the custom element
		map!(style,style) do selector
			"test " * strip(selector)
		end
		join(style,",\n")
	end
	map(x -> x * "\n}",_)
	join(_,"\n\n")
	Text
end
	
  ╠═╡ notebook_exclusive =#

# ╔═╡ e880d449-0e72-45ad-bea9-bbadcdcd523d
"""
`prettytable(data;kwargs...)`

This function is a wrapper around `pretty_table` from [PrettyTables.jl](https://github.com/ronisbr/PrettyTables.jl) specifically made for working in Pluto notebooks and thus only supporting the `HTML` backend

# Differences with PrettyTables.jl
## Unsupported Keyword Arguments

### `standalone`

The function does not support the `standalone` kwarg (or rather only supports `standlone=false` which is provided by default) as that directly generates a full HTML page (with html and body tags) and would then need to be rendered inside an iframe in Pluto

### `backend`

As mentioned before, the function does not allow to specify a backend different than `HTML` (which is used by default) as it is supposed to be used inside Pluto to show table in cell outputs.

## Additional Keyword Arguments

### `css`
The table allow to specify directly a string with they CSS Style to apply to this table.

If nothing is provided, the function will extract the `css` from the field with the same name in the `HTMLTableFormat` structure of `pretty_table`, optionally provided with the `tf` keyword argument.

### `append_css`
The css provided in this keyword argument is appended after the one specified in `css`

Defaults to `""`

### `caption`
Add an optional table caption if provided

Defaults to `nothing`

### `id`
To allow specifying different tables with different styles within the same pluto-notebook, each table should be provided with a unique identifier to limit the eventually provided CSS styling to the table in question.

This is done by wrapping the table into a div that has attributes id and data-uuid equivalent to the `id` keyword argument.

If `id` is not provided, it defaults to a random unique identifier (uuidv4)

This is then used to limit the css styling by prepending each entry in the `css` string with a custom selector expliting the data-uuid attribute value of the div

#### Note
The data-uuid custom attribute is used instead of id in the stylesheet because uuidv4 returns identifier that may start with numbers and thus can't be used as CSS selectors.
"""
function prettytable(data;backend=:html, tf::HTMLTableFormat=HTMLTableFormat(), standalone=false, id=uuid4(), css=tf.css, append_css="", caption = nothing ,kwargs...)
	@assert backend === :html "Only the :html backend is supported"
	@assert standalone === false "standalone = true is not supported"
	
	# First we create the string of the table output using the standard pretty_table
	tab_str = pretty_table(String,data;kwargs...,backend=:html,tf=tf,standalone=false)

	# Check if we need to add the caption
	if caption !== nothing
		tab_str = replace(tab_str,"<table>\n" => "<table>\n<caption>$caption</caption>\n")
	end
	# Put this tabular data in a custom div with a unique identifier (data-UUID is also used on top of id because CSS selectors can not start with a number)
	out = @htl """
	<div id=$id data-uuid=$id class="prettytable_container">
		$(HTML(tab_str))
	</div>
	"""
	# Append the additional css
	css *= append_css
	# println(css)
	# Deal with the custom CSS Style
	if !isempty(css)
		# Pre-pend the div[data-UUID=$id] to all css selectors so that this applies only to the current table
		css = prepend_selector(css,"div[data-uuid='$id']")
		out = @htl """
		$out
		<style>
		$css
		3
		</style>
		"""
	end
	return out
end

# ╔═╡ 73d1a71c-78a3-4533-9792-526e45c868ff
function prepend_selector(css,custom_selector)
	pre = @chain css begin
		split(_,'}') # Separate different style groups
		map(x -> lstrip(x,['\n','\t',' ']),_) # Remove trailing newlines
		filter(!isempty,_)
		map(x -> split(x,'{'),_)
	end
	out = ""
	for i ∈ eachindex(pre)
		out *= @chain pre[i][1] begin
			split(',') # Find the differents combined CSS selectors as they have to be prepended with the class together
			map(_) do selector # Here we go to prepend the custom element
				"$custom_selector $(strip(selector))"# Preprend the custom id to each selector
			# 	end
			end
			join(",\n")
			# map(x -> x * "\n}",_)
			# join(_,"\n\n") # Join back into a single string
		end
		out *= "{$(pre[i][2])\n}\n\n"
	end
	out
end

# ╔═╡ fec22aa8-ffee-4b6c-a46e-a82ed3f75a9d
#=╠═╡ notebook_exclusive
prepend_selector("""
	caption, magic {
		font-family: "asd", lol;
	}

	h1, h2 {
		color: red;
	}
""", "GESU")
  ╠═╡ notebook_exclusive =#

# ╔═╡ e11a10bd-8d8c-4e7f-ba3a-873a3e8d349f
export prettytable

# ╔═╡ 98765fad-7349-4791-a2c9-b60d6a33b1f3
#=╠═╡ notebook_exclusive
a = rand(10,4)
  ╠═╡ notebook_exclusive =#

# ╔═╡ 81d55931-6c5e-4211-86c7-d67681183cb7
#=╠═╡ notebook_exclusive
prettytable(a;caption = "GESU",append_css = """
	caption {
		font-family: "Times New Roman", Times, serif;
	}
""")
  ╠═╡ notebook_exclusive =#

# ╔═╡ ca56394b-b4a9-4c8f-a8cc-1592dc1b6bd5
#=╠═╡ notebook_exclusive
prettytable(a;tf=tf_html_minimalist,append_css="""
tr:nth-child(5) {
	font-weight: 800;
}
	table {
		font-family: "Times New Roman", Times, serif;
	}
	""")
  ╠═╡ notebook_exclusive =#

# ╔═╡ b9953787-fd44-432a-b2c1-5f9de7cfccbe
#=╠═╡ notebook_exclusive
prettytable(a;tf=tf_html_dark)
  ╠═╡ notebook_exclusive =#

# ╔═╡ 2e5c16de-957e-4f19-9a7e-2edc3ae2707c
#=╠═╡ notebook_exclusive
prettytable(a)
  ╠═╡ notebook_exclusive =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Chain = "8be319e6-bccf-4806-a6f7-6fae938471bc"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PrettyTables = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[compat]
Chain = "~0.4.7"
HypertextLiteral = "~0.8.0"
PrettyTables = "~1.1.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

[[Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[Chain]]
git-tree-sha1 = "cac464e71767e8a04ceee82a889ca56502795705"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.4.8"

[[CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[HypertextLiteral]]
git-tree-sha1 = "1e3ccdc7a6f7b577623028e0095479f4727d8ec1"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.8.0"

[[InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "0d1245a357cc61c8cd61934c07447aa569ff22e6"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.1.0"

[[Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
"""

# ╔═╡ Cell order:
# ╠═104611e0-e53f-11eb-1bb5-61dd3dd0acf2
# ╟─afebdbb9-42a5-4640-ae38-12a105a70e05
# ╠═b80ac7b8-11a4-45ef-8072-97a5ef0ab4e2
# ╠═5db046c0-48a2-478b-a8cd-a72c29c14444
# ╠═22386594-49c7-4c3b-948e-fd13d326d360
# ╠═b18e8c7f-467e-427c-8487-e021bd8c283a
# ╠═e880d449-0e72-45ad-bea9-bbadcdcd523d
# ╠═73d1a71c-78a3-4533-9792-526e45c868ff
# ╠═fec22aa8-ffee-4b6c-a46e-a82ed3f75a9d
# ╠═e11a10bd-8d8c-4e7f-ba3a-873a3e8d349f
# ╠═98765fad-7349-4791-a2c9-b60d6a33b1f3
# ╠═81d55931-6c5e-4211-86c7-d67681183cb7
# ╠═ca56394b-b4a9-4c8f-a8cc-1592dc1b6bd5
# ╠═b9953787-fd44-432a-b2c1-5f9de7cfccbe
# ╠═2e5c16de-957e-4f19-9a7e-2edc3ae2707c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
