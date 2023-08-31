module LaTeXEqModule

using HypertextLiteral

export texeq, eqref, initialize_eqref, @texeq_str

const js = HypertextLiteral.JavaScript

# LaTeX equation using KaTeX #
## Initialization Function ##
#=
KaTeX [supports](https://katex.org/docs/supported.html) automatic numbering of
*equation* environments.  While it does not support equation reference and
labelling, [this](https://github.com/KaTeX/KaTeX/issues/2003) hack on github
shows how to achieve the label functionality.

Unfortunately, since automatic numbering in KaTeX uses CSS counters, it is not
possible to access the value of the counter at a specific DOM element.  We then
create a function that loops through all possible katex equation and counts
them, putting the relevant number in the appropriate hyperlink innerText to
create equation references that automatically update.

The code for the mutationobservers to trigger re-computation of the numbers are
taken from the **TableOfContents** in **PlutoUI**
=#
"""
`initialize_eqref()`

When run in a Pluto cell, this function generates the necessary javascript to correctly handle and display latex equations made with `texeq` and equation references made with `eqref`
"""
initialize_eqref() = @htl("""
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.css" integrity="sha384-GvrOXuhMATgEsSwCs4smul74iXGOixntILdUW9XmUC6+HX0sLNAK3q71HotJqlAn" crossorigin="anonymous">

<style>
a.eq_href {
	text-decoration: none;
}
</style>

<script src="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.js" integrity="sha384-cpW21h6RZv/phavutF+AuVYrr+dA8xD9zs6FwLpaCct6O9ctzYFfFr4dgmgccOTx" crossorigin="anonymous"></script>

<script id="katex-eqnum-script">


const a_vec = [] // This will hold the list of a tags with custom click, used for cleaning listeners up upon invalidation

const eqrefClick = (e) => {
	e.preventDefault() // This prevent normal scrolling to link
	const a = e.target
	const eq_id = a.getAttribute('eq_id')
	const eq = document.getElementById(eq_id)
	history.pushState({},'') // This is to allow going back to the previous position in the page after scroll with History Back
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
const katex_blocks = document.querySelectorAll('.katex-html') // This selects all the environments we created with texeq
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
		const a_vals = document.querySelectorAll(`[eq_id=\${id}]`)
		a_vals !== null && a_vals.forEach(a => {
			a_vec.push(a) // Add this to the vector
			a.innerText = `(\${i})`
			a.addEventListener('click',eqrefClick)
		})
	}
}
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
	a_vec.forEach(a => a.removeEventListener('click',eqrefClick))
})
</script>
""")

# Function #
## Eq Ref ##
"""
`eqref(label::String)`

Function that create an hyperlink pointing to a previously defined labelled
equation using `texeq()`
"""
eqref(label) = @htl("""
<a eq_id="$label" id="eqref_$label" href="#$label" class="eq_href">(?)</a>
""")

## String interpolation ##
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

## Main Function ##
"""
`texeq(code::String)`

Take an input string and renders it inside an equation environemnt (numbered) using KaTeX

Equations can be given labels by adding `"\\\\label{name}"` inside the `code` string and subsequently referenced in other cells using `eqref("name")`

# Note
To avoid the need of doubling backslashes, use the new [`@texeq_str`](@ref) macro if you are on Pluto ≥ v0.17
"""
function texeq(code,env="equation")
	code_escaped = code 			|>
	x -> replace(x,"\\\n" => "\\\\\n")	|>
	x -> replace(x,"\\" => "\\\\")	|>
	x -> replace(x,"\n" => " ")
	#println(code_escaped)
	@htl """
	<div>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.css" integrity="sha384-GvrOXuhMATgEsSwCs4smul74iXGOixntILdUW9XmUC6+HX0sLNAK3q71HotJqlAn" crossorigin="anonymous">
	<script src="https://cdn.jsdelivr.net/npm/katex@0.16.8/dist/katex.min.js" integrity="sha384-cpW21h6RZv/phavutF+AuVYrr+dA8xD9zs6FwLpaCct6O9ctzYFfFr4dgmgccOTx" crossorigin="anonymous"></script>
	
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

## Macro ##
"""
	@texeq_str -> katex_html_code
Use to generate an HTML output that when rendered in Pluto shows latex equation using KaTeX.

Relies on [`texeq`](@ref) but avoids the need of double escaping backslashes.

# Examples
```julia
texeq"
\\frac{q \\sqrt{2}}{15} + $(3 + 2 + (5 + 32))
"
```
"""
macro texeq_str(code)
	# The tring literal macro automatically translates single backslash into double backslash, so we just have to output that
	expr = :(texeq())
	push!(expr.args,esc(_str_interpolate(code)))
	expr
end

end