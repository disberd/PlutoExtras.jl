### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 945ee770-e082-11eb-0c8b-25e53f4d718c
using HypertextLiteral

# ╔═╡ b35233a0-6d2f-4eac-8cb0-e317eef4c835
md"""
## TeX Equation environment
"""

# ╔═╡ b8782294-d6b9-43ac-b745-b2cbb6ed06b1
a = 1:10

# ╔═╡ de8473c1-dea1-4221-9562-30679ae58e34
md"""
$$3+2$$
"""

# ╔═╡ 900f494b-690d-43cf-b1b7-61c5d3e68a6d
"\n"

# ╔═╡ 9446acfc-a310-4de6-8876-e30ede527e9c
md"""
$$Y = \overline {A} - m \phi (\overline {r} - \gamma \pi)$$
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

# ╔═╡ 6584afb8-b085-4c56-93cb-a5b57e16520c
"""
`PlutoUtils.initialize_eqref()`

When run in a Pluto cell, this function generates the necessary javascript to correctly handle and display latex equations made with `PlutoUtils.texeq` and equation references made with `PlutoUtils.eqref`
"""
initialize_eqref() = @htl """
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.css" integrity="sha384-Um5gpz1odJg5Z4HAmzPtgZKdTBHZdw8S29IecapCSB31ligYPhHQZMIlWLYQGVoc" crossorigin="anonymous">

<style>
a.eq_href {
	text-decoration: none;
}
</style>

		<script src="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.js" integrity="sha384-YNHdsYkH6gMx9y3mRkmcJ2mFUjTd0qNQQvY9VYZgQd7DcN7env35GzlmFaZ23JGp" crossorigin="anonymous"></script>

<script id="katex-eqnum-script">

const docu = document.document ?? document

const a_vec = [] // This will hold the list of a tags with custom click, used for cleaning listeners up upon invalidation

const eqrefClick = (e) => {
	e.preventDefault() // This prevent normal scrolling to link
	const a = e.target
	const eq_id = a.getAttribute('eq_id')
	window.location.hash = 'eqref-' + eq_id // This is to be able to use the back function to resume previous view, 'eqref-' is added in front to avoid the viewport actually going to the equation without having control of the scroll
	const eq = docu.getElementById(eq_id)
	eq.scrollIntoView({
		behavior: 'smooth',
		block: 'center',
	})
}

// We make a function to compute the vertical offset (from the top) of an object to the
// closest parent containing the katex-html class. This is used to find the equation number
// that is closest to the label
const findOffsetTop = obj => {
	let offset = 0
	let keepGoing = true
	while (keepGoing) {
		offset += obj.offsetTop
		// Check if the current offsetParent is the containing katex-html
		if (obj.offsetParent.classList.contains('katex-html')) {
			keepGoing = false
		} else {
			obj = obj.offsetParent
		}
	}
	return offset
}


// The katex equation numbers are wrapped in spans containing the class 'eqn-num'. WHen you
// assign a label, another class ('enclosing') is assigned to some parts of the rendered
// html containing the equation line. This means that equation containing labels will have
// both 'eqn-num' and 'enclosing'. The new approach is to go through all the katex math
// equations one by one and analyze how many numbered lines they contain by counting the
// 'eqn-num' instances. 
const updateCallback = () => {
a_vec.splice(0,a_vec.length) // Reset the array
const katex_blocks = docu.querySelectorAll('.katex-html') // This selects all the environments we created with texeq
let i = 0;
for (let blk of katex_blocks) {
	// Find the number of numbered equation in each sub-block
	let numeqs = blk.querySelectorAll('.eqn-num')
	let eqlen = numeqs.length
	if (eqlen == 0) {
		continue // There is nothing to do here since no equation is numbered
	}
	let labeleqs = blk.querySelectorAll('.enclosing')
	if (labeleqs.length == 0) {
		// There is no label, so we just have to increase the counter
		i += eqlen
		continue
	}
	// Find the offset from the katex-html parent of each equation number, the assumption
	// here is that the span containing the label tag has the same (or almost the same) offset as the related equation number
	let eqoffsets = Array.from(numeqs,findOffsetTop)


	for (let item of labeleqs) {
		const labelOffset = findOffsetTop(item)
		let prevDiff = -Infinity
		let currentOffset = eqoffsets.shift()
		let currentDiff = currentOffset - labelOffset
		i += 1
		while (eqoffsets.length > 0 && currentDiff < 0) { // if currentOffset >= 0, it means that the current equ-num is lower than the label (or at the same height)
			prevDiff = currentDiff
			currentOffset = eqoffsets.shift()
			currentDiff = currentOffset - labelOffset
			i += 1
		}
		// Now we have to check whether the previous number with offset < 0 or the first with offset > 0 is the closest to the label offset
		if (Math.abs(currentDiff) > Math.abs(prevDiff)) {
			// The previous entry was closer, so we reduce i by one and put back the last shifted element in the offset array
			i -= 1
			eqoffsets.unshift(currentOffset)
		}
		// We now update all the links that refer to this label
		const id = item.id
		const a_vals = docu.querySelectorAll(`[eq_id=\${id}]`)
		a_vals !== null && a_vals.forEach(a => {
			a_vec.push(a) // Add this to the vector
			a.innerText = `(\${i})`
			a.addEventListener('click',eqrefClick)
		})
	}
}
}

const notebook = docu.querySelector("pluto-notebook")

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
	a_vec.forEach(a => a.removeEventListener('click',eqrefClick))
})
</script>
"""

# ╔═╡ a78aa624-6504-4b3f-914a-833261b92f19
initialize_eqref()

# ╔═╡ d14197d8-cab1-4d92-b81c-d826ea8183f3
md"""
## TeX equations
"""

# ╔═╡ 2ad9500c-187b-4b69-8e7b-ef76af8fc39a
js(x) = HypertextLiteral.JavaScript(x)

# ╔═╡ f58427a7-f540-4667-93eb-57f1f53905f4
"""
`PlutoUtils.texeq(code::String)`

Take an input string and renders it inside an equation environemnt (numbered) using KaTeX

Equations can be given labels by adding `"\\\\label{name}"` inside the `code` string and subsequently referenced in other cells using `eqref("name")`

# Note
Unfortunately backward slashes have to be doubled when creating the TeX code to be put inside the equation
When Pluto will support interpretation of string literal macros, this could be made into a macro
"""
function texeq(code,env="equation")
	code_escaped = code 			|>
	x -> replace(x,"\\\n" => "\\\\\n")	|>
	x -> replace(x,"\\" => "\\\\")	|>
	x -> replace(x,"\n" => " ")
	println(code_escaped)
	@htl """
	<div>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.css" integrity="sha384-Um5gpz1odJg5Z4HAmzPtgZKdTBHZdw8S29IecapCSB31ligYPhHQZMIlWLYQGVoc" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/katex@0.13.11/dist/katex.min.js" integrity="sha384-YNHdsYkH6gMx9y3mRkmcJ2mFUjTd0qNQQvY9VYZgQd7DcN7env35GzlmFaZ23JGp" crossorigin="anonymous"></script>
	
	<script>
	katex.render('\\\\begin{$(js(env))} $(js(code_escaped)) \\\\end{$(js(env))}',currentScript.parentElement,{
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
	</div>
	"""
end

# ╔═╡ 0bfb8ee9-14e2-44ee-b0d5-98790d47f7b8
texeq("3+2=5")

# ╔═╡ 0bd44757-90b8-452f-999f-6109239ac826
md"""
$(texeq("
3
+
2
"))
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

# ╔═╡ ea09b6ec-8d39-4cd9-9c79-85c1fcce3828
texeq("
	\\begin{align*}
		(2 \\cdot 3) + (1 \\cdot 4) &= 6 + 4 \\
									&= 10
	\\end{align*}
	")

# ╔═╡ 958531c1-fa83-477c-be3d-927155800f1b
texeq("
	\\sum_{i=$(a[1])}^{$(a[end])} i=$(sum(a)) \\label{interactive}
	")

# ╔═╡ 7879d7e3-38ad-4a06-8057-ec30da534d76
texeq("y=2x^2")

# ╔═╡ 6d750d01-b851-4614-b448-1a6e00fa5754
md"""
$(texeq("
	\\pi =  \\pi^e + \\gamma (P - Y^P) + \\rho \\label{seven}"
))
"""

# ╔═╡ 943e5ef8-9187-4bfd-aefa-8f405b50e6aa
asdasd = 3

# ╔═╡ 2c82ab99-8e86-41c6-b938-3635d2d3ccde
md"""
The antenna pattern of a DRA antenna can at first approximation be expressed as:
$(texeq("3+2"))
"""

# ╔═╡ cddc93d2-1b24-4bda-8113-4a1ec781b2b6
"""
`PlutoUtils.eqref(label::String)`

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
md"""Multiple links to the same equation $(eqref("interactive")) also work! See also $(eqref("seven"))
"""

# ╔═╡ 9e69e30e-506a-4bd7-b213-0b5c0b31a10d
md"""Link to sub-parts of align environments are now fixed! $(eqref("test1")), $(eqref("test2")), $(eqref("test3")), $(eqref("test4")), $(eqref("test5"))
"""

# ╔═╡ 172c02b4-5ee1-42bb-ac6d-598eeb090463
# Function to create interpolation inside string literal
function _str_interpolate(s::String)
	str = Expr(:string)
	last_idx = 1
	inside_interp = false
	parens_found = 0
	inside_parens = false
	simple_interp = true
	@inbounds for (i,c) ∈ enumerate(s)
		if !inside_interp 
			if c !== '$'
				continue
			end
			# Add the previous part of the string to the expr
			push!(str.args,s[last_idx:i-1])
			last_idx = i+1
			inside_interp = true
			if s[i+1] === '('
				simple_interp = false
			else
				simple_interp = true
			end
		else
			if simple_interp
				if c ∈ (' ','.','\n','\t')
					# We found the end of the expression, translate this into an expr
					push!(str.args,Meta.parse(s[last_idx:i-1]))
					println(Meta.parse(s[last_idx:i-1]))
					last_idx = i
					inside_interp = false
				end
			else
				if c === '('
					parens_found += 1
					inside_parens = true
				elseif c === ')'
					parens_found -= 1
					if parens_found == 0
						inside_parens = false
						# We found the end of the expression, translate this into an expr
						push!(str.args,Meta.parse(s[last_idx:i]))
						last_idx = i+1
						inside_interp = false
					end
				end
			end
		end
	end
	if inside_interp
		push!(str.args,esc(Meta.parse(s[last_idx:end])))
	else
		push!(str.args,s[last_idx:end])
	end
	str
end

# ╔═╡ 375641e3-f0c0-4473-9ff6-022ed06f9646
macro texeq_str(code)
	# The tring literal macro automatically translates single backslash into double backslash, so we just have to output that
	expr = :(texeq())
	push!(expr.args,_str_interpolate(code))
	expr
end

# ╔═╡ cbf7a7b7-3dc9-488f-b891-26f1590dadc0
export texeq, eqref, initialize_eqref, @texeq_str

# ╔═╡ 2078d2c8-1f38-42fe-9945-b2235e267b38
texeq"
\frac{q \sqrt{2}}{15} + $(3 + 2 + (5 + 32)) - $asdasd
"

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.3"
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
# ╠═945ee770-e082-11eb-0c8b-25e53f4d718c
# ╟─b35233a0-6d2f-4eac-8cb0-e317eef4c835
# ╠═b8782294-d6b9-43ac-b745-b2cbb6ed06b1
# ╠═0bfb8ee9-14e2-44ee-b0d5-98790d47f7b8
# ╠═1482e175-cf32-42f3-b8fb-64f1f14c1501
# ╠═0df86e0e-6813-4f9f-9f36-7badf2f85597
# ╠═0bd44757-90b8-452f-999f-6109239ac826
# ╠═de8473c1-dea1-4221-9562-30679ae58e34
# ╠═b9213424-f814-4bb8-a05f-33249f4f0a8f
# ╠═9e69e30e-506a-4bd7-b213-0b5c0b31a10d
# ╠═ea09b6ec-8d39-4cd9-9c79-85c1fcce3828
# ╠═900f494b-690d-43cf-b1b7-61c5d3e68a6d
# ╠═7879d7e3-38ad-4a06-8057-ec30da534d76
# ╠═958531c1-fa83-477c-be3d-927155800f1b
# ╠═9446acfc-a310-4de6-8876-e30ede527e9c
# ╠═6d750d01-b851-4614-b448-1a6e00fa5754
# ╟─1471265c-4934-45e3-a4b2-37da94ff7472
# ╟─b6b08bf0-7282-40b9-ae87-b776a64c519f
# ╠═6584afb8-b085-4c56-93cb-a5b57e16520c
# ╠═a78aa624-6504-4b3f-914a-833261b92f19
# ╟─d14197d8-cab1-4d92-b81c-d826ea8183f3
# ╠═2ad9500c-187b-4b69-8e7b-ef76af8fc39a
# ╠═cbf7a7b7-3dc9-488f-b891-26f1590dadc0
# ╠═f58427a7-f540-4667-93eb-57f1f53905f4
# ╠═375641e3-f0c0-4473-9ff6-022ed06f9646
# ╠═2078d2c8-1f38-42fe-9945-b2235e267b38
# ╠═943e5ef8-9187-4bfd-aefa-8f405b50e6aa
# ╠═2c82ab99-8e86-41c6-b938-3635d2d3ccde
# ╠═cddc93d2-1b24-4bda-8113-4a1ec781b2b6
# ╠═172c02b4-5ee1-42bb-ac6d-598eeb090463
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
