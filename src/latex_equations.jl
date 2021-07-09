### A Pluto.jl notebook ###
# v0.15.0

using Markdown
using InteractiveUtils

# ╔═╡ 945ee770-e082-11eb-0c8b-25e53f4d718c
using HypertextLiteral

# ╔═╡ b35233a0-6d2f-4eac-8cb0-e317eef4c835
md"""
## TeX Equation environment
"""

# ╔═╡ b8782294-d6b9-43ac-b745-b2cbb6ed06b1
a = 2:15

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

# ╔═╡ 6584afb8-b085-4c56-93cb-a5b57e16520c
@htl """
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.css" integrity="sha384-Um5gpz1odJg5Z4HAmzPtgZKdTBHZdw8S29IecapCSB31ligYPhHQZMIlWLYQGVoc" crossorigin="anonymous">

<style>
a.eq_href {
	text-decoration: none;
}
</style>

		<script src="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.js" integrity="sha384-YNHdsYkH6gMx9y3mRkmcJ2mFUjTd0qNQQvY9VYZgQd7DcN7env35GzlmFaZ23JGp" crossorigin="anonymous"></script>

<script id="katex-eqnum-script">

const eqrefClick = (e) => {
	e.preventDefault() // This prevent normal scrolling to link
	const a = e.target
	const eq_id = a.getAttribute('eq_id')
	window.location.hash = 'eqref-' + eq_id // This is to be able to use the back function to resume previous view, 'eqref-' is added in front to avoid the viewport actually going to the equation without having control of the scroll
	const eq = document.getElementById(eq_id)
	eq.scrollIntoView({
		behavior: 'smooth',
		block: 'center',
	})
}
	
const updateCallback = () => {
const eqs = document.querySelectorAll('span.enclosing, span.eqn-num')
let i = 0;
eqs.forEach(item => {
	i += 1
	if (item.classList.contains('enclosing')) {
		const id = item.id
		const a_vals = document.querySelectorAll(`[eq_id=\${id}]`)
		a_vals !== null && a_vals.forEach(a => {
			a.innerText = `(\${i})`
			a.addEventListener('click',eqrefClick)
		})
	}
})
}

const notebook = document.querySelector("pluto-notebook")

// We have a mutationobserver for each cell:
const observers = {
	current: [],
}

const createCellObservers = () => {
	observers.current.forEach((o) => o.disconnect())
	observers.current = Array.from(notebook.querySelectorAll("pluto-cell")).map(el => {
		const o = new MutationObserver(updateCallback)
		o.observe(el, {attributeFilter: ["class"]})
		return o
	})
}
createCellObservers()

// And one for the notebook's child list, which updates our cell observers:
const notebookObserver = new MutationObserver(() => {
	updateCallback()
	createCellObservers()
})
notebookObserver.observe(notebook, {childList: true})

invalidation.then(() => {
	notebookObserver.disconnect()
	observers.current.forEach((o) => o.disconnect())
})
</script>
"""

# ╔═╡ d14197d8-cab1-4d92-b81c-d826ea8183f3
md"""
## TeX equations
"""

# ╔═╡ f58427a7-f540-4667-93eb-57f1f53905f4
"""
`texeq(code::String)`

Take an input string and renders it inside an equation environemnt (numbered) using KaTeX

Equations can be given labels by adding `"\\\\label{name}"` inside the `code` string and subsequently referenced in other cells using `eqref("name")`

# Note
Unfortunately backward slashes have to be doubled when creating the TeX code to be put inside the equation
When Pluto will support interpretation of string literal macros, this could be made into a macro
"""
function texeq(code)
	code_escaped = replace(code,"\\" => "\\\\")
	@htl """
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.css" integrity="sha384-Um5gpz1odJg5Z4HAmzPtgZKdTBHZdw8S29IecapCSB31ligYPhHQZMIlWLYQGVoc" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.js" integrity="sha384-YNHdsYkH6gMx9y3mRkmcJ2mFUjTd0qNQQvY9VYZgQd7DcN7env35GzlmFaZ23JGp" crossorigin="anonymous"></script>
	
	<script>
	katex.render('\\\\begin{equation} $(HypertextLiteral.JavaScript(code_escaped)) \\\\end{equation}',currentScript.parentElement,{
					displayMode: true,
					trust: context => [
						'\\\\htmlId', 
						'\\\\href'
					].includes(context.command),
					macros: {
					  "\\\\label": "\\\\htmlId{#1}{}"
					},
				})
	</script>
	"""
end

# ╔═╡ b9213424-f814-4bb8-a05f-33249f4f0a8f
texeq("3+2 = 5")

# ╔═╡ 958531c1-fa83-477c-be3d-927155800f1b
texeq("\\sum_{i=$(a[1])}^{$(a[end])} i=$(sum(a)) \\label{interactive}")

# ╔═╡ cddc93d2-1b24-4bda-8113-4a1ec781b2b6
"""
`eqref(label::String)`

Function that create an hyperlink pointing to a previously defined labelled equation using `texeq()`
"""
eqref(label) = @htl """
<a eq_id="$label" id="eqref_$label" href="#$label" class="eq_href">(?)</a>
"""

# ╔═╡ 1482e175-cf32-42f3-b8fb-64f1f14c1501
md"""
The sum in $(eqref("interactive")) is interactive!
"""

# ╔═╡ 0df86e0e-6813-4f9f-9f36-7badf2f85597
md"""Multiple links to the same equation $(eqref("interactive")) also work!"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.8.0"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-beta2"
manifest_format = "2.0"

[[deps.HypertextLiteral]]
git-tree-sha1 = "1e3ccdc7a6f7b577623028e0095479f4727d8ec1"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.8.0"
"""

# ╔═╡ Cell order:
# ╠═945ee770-e082-11eb-0c8b-25e53f4d718c
# ╟─b35233a0-6d2f-4eac-8cb0-e317eef4c835
# ╠═958531c1-fa83-477c-be3d-927155800f1b
# ╠═b9213424-f814-4bb8-a05f-33249f4f0a8f
# ╠═b8782294-d6b9-43ac-b745-b2cbb6ed06b1
# ╠═1482e175-cf32-42f3-b8fb-64f1f14c1501
# ╠═0df86e0e-6813-4f9f-9f36-7badf2f85597
# ╟─1471265c-4934-45e3-a4b2-37da94ff7472
# ╟─b6b08bf0-7282-40b9-ae87-b776a64c519f
# ╠═6584afb8-b085-4c56-93cb-a5b57e16520c
# ╟─d14197d8-cab1-4d92-b81c-d826ea8183f3
# ╠═f58427a7-f540-4667-93eb-57f1f53905f4
# ╠═cddc93d2-1b24-4bda-8113-4a1ec781b2b6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
