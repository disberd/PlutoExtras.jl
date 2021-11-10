### A Pluto.jl notebook ###
# v0.17.1

using Markdown
using InteractiveUtils

# ╔═╡ 64a29f5e-3334-43bb-a23f-8bfda53af1a4
#=╠═╡ notebook_exclusive
using HypertextLiteral
  ╠═╡ notebook_exclusive =#

# ╔═╡ 21761862-acb6-4691-97f0-a756865ac1cc
md"""
### Collapse/Hide heading
"""

# ╔═╡ ea897dda-e0d2-43f4-8c79-f96ce3897ac9
md"""
The following two functions `collapse_heading` and `hide_heading` can be piped with markdown entries to add the `collapsed` and `hide-heading` attributes to the relevant pluto cell, that make the ToC entry of the cell collapsed or hidden.
"""

# ╔═╡ 9b27d817-1b57-4b43-948a-e0324082f520
"""
see also [`hide_heading`](@ref), [`toc_heading`](@ref)

	collapse_heading(x)

Take the input `x` and wraps it into an HTML element with HypertextLiteral's [`@htl`](@ref), attaching to it a JavaScript that sets the containing pluto-cell attribute `collapsed`, which is used by the custom PlutoUtils' [`ToC`](@ref) to collapse headings.

# Examples use
	md"# Heading" |> collapse_heading
"""
collapse_heading(x) = @htl """
$x
<script>
	currentScript.closest('pluto-cell').setAttribute('collapsed','')
</script>
"""

# ╔═╡ 77c1e5d1-305e-4a07-a565-d3fd75e31028
"""
see also [`collapse_heading`](@ref), [`toc_heading`](@ref)

	hide_heading(x)

Take the input `x` and wraps it into an HTML element with HypertextLiteral's [`@htl`](@ref), attaching to it a JavaScript that sets the containing pluto-cell attribute `hide-heading`, which is used by the custom PlutoUtils' [`ToC`](@ref) to hide all cells between the hidden heading and the next.

# Examples use
	md"# Heading" |> hide_heading
"""
hide_heading(x) = @htl """
$x
<script>
	currentScript.closest('pluto-cell').setAttribute('hide-heading','')
</script>
"""

# ╔═╡ edd55419-df8a-45a5-8342-950749ae8980
md"""
# Helper Functions
""" |> collapse_heading |> hide_heading

# ╔═╡ 5e2f2d6b-949e-4b91-af0a-0a6baf23d00e
"""
see also [`collapse_heading`](@ref), [`hide_heading`](@ref)

	toc_heading(text,level::Int;hide=true,collapse=false) 

Generate headings with optional html attributes (`collapsed` and `hide-heading`) attached to the containing cell to interface with the custom ToC defined in this notebook.

The fuction will also automatically close the input of the cell where it's executed, and will skip returning an output if included from outside the originating notebook.

All cells before the first Heading are hidden by default, as they usually contain initialization steps

# Arguments:

`text::String` : Text that will be included in the heading

`level::Int` : Level of the heading, from 1 to 6

# Keyword Arguments

`hide::Bool` : Set to true to have a heading appear hidden in the ToC (and all the cells between the hidden heading and next appear hidden in the notebook, if the ToC title is clicked while pressing alt), defaults to true

`collapse::Bool`: Set to true to have a heading (and all its children) appear collapsed in the ToC
"""
function toc_heading(text,level::Int;hide=true,collapse=false) 
	tag = "h$level"
	attribute_names = []
	hide && (push!(attribute_names,"hide-heading"))
	collapse && (push!(attribute_names,"collapse"))
	attributes = join(attribute_names," ")
	@htl """
	<script>
		const docu = document.document ?? document
		const cell = currentScript.parentElement.closest('pluto-cell')
		const h = docu.createElement($tag)
		h.innerText = $text
		cell.toggleAttribute('hide-heading',$hide)
		cell.toggleAttribute('collapsed',$collapse)
		if (cell.classList.contains('show_input'))	cell.querySelector('pluto-shoulder button').click()
		return h
		
	</script>
	"""
end

# ╔═╡ 3ea419e5-f70c-404f-813d-be8cfad99b79
toc_heading("Asd",2,hide=true,collapse=true)

# ╔═╡ 561c2bcf-d405-4e46-bd9d-c74500995a94
md"""
### TESTT
"""

# ╔═╡ d5eccf35-9aa6-48b4-9140-7ccb5d311820
toc_heading("Test1",1;hide=false,collapse=true)

# ╔═╡ d1784dd2-9a25-4add-90a8-121f1e2620e6
@htl """
<script>
const h = docu.createElement('h2')
h.innerText = 'Test2'
const cell = currentScript.parentElement.closest('pluto-cell')
cell.removeAttribute('collapsed')
return h
</script>
"""

# ╔═╡ 1228ed04-b62f-4703-9e5d-e1f5cb0bf640
md"""
### Test3
"""

# ╔═╡ 358d4034-20c6-4746-8c37-f91e79a369eb
md"""
## Test22
"""

# ╔═╡ fa4699bb-78b0-43e9-9889-536af90af45b
toc_heading("ToC Definition",1,hide=true)

# ╔═╡ 9429e332-6543-4a1a-94d6-9c3733712b5c
toc_heading("Julia Strcut",2;hide=true)

# ╔═╡ 25b4cb5d-504f-4922-9923-7668f83dcc2f
md"""
The documentation of the function has to be updated
"""

# ╔═╡ 08ea2095-cdf3-4f3c-8dd7-792245ac6e56
#=╠═╡ notebook_exclusive
toc_heading("JavaScript Code",2,hide=true)
  ╠═╡ notebook_exclusive =#

# ╔═╡ 2aa06b9e-34cf-43de-8559-88ff9707216d
#=╠═╡ notebook_exclusive
md"""
!!! note
	The curent implementations creates a lot of re-renders.
	Try improving it with better react-fu in the future
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 0b832124-aca0-4172-9121-8f41c3c34bc8
toc_heading("Main JS that includes the preact components",3,hide=true)

# ╔═╡ e2307fb5-f3f8-482f-abae-5509bf48fe2d
toc_heading("ToC Element Component Definition",3;hide=true)

# ╔═╡ 8b20a786-7020-4252-8e42-ffbd33fb19e4
ItemDef = """
const Item = ({text, hidden, hide, id, onClick, depth, collapsed, collapsed_parent, children}) => {
	if (collapsed_parent || (hidden && hide)) return null


let div_attrs = {
		onClick: (e) => onClick(e,id),
		collapsed: collapsed && (children.length > 0),
		class: [
			'toc-row',
			hidden ? "hidden" : ""
		].filter(Boolean).join(" ")
	}
let a_attrs = {
		href: `#\${id}`,
		class: `H\${depth}`,
	}

	return html`<div ...\${div_attrs}><a ...\${a_attrs}>\${text}</a></div>`
}
""";

# ╔═╡ 71a2347d-fb17-4c12-8298-9d07511ffb05
toc_heading("""
Main ToC Preact class
""",3,hide=true)

# ╔═╡ 028c5069-fc3d-48a0-84e1-476689539f2c
TocDef = toc -> """
const Toc = () => {

	// console.log('toc_id:',toc_id)

	const getHeaderState = () => {
		const depth = Math.max(1, Math.min(6, $(toc.depth))) // should be in range 1:6
		const range = Array.from({length: depth}, (x, i) => i+1) // [1, ..., depth]
		
		const selector = range.map(i => `pluto-notebook pluto-cell h\${i}`).join(",")
		const initialArray = [] 
		for (let item of docu.querySelectorAll(selector)) {
			const isdocs = item.closest('.pluto-docs-binding')
			if (isdocs !== null) {
				continue
			}
			const cell = item.closest('pluto-cell')
			initialArray.push({
				id: cell.id,
				title: item.innerText,
				hidden: cell.hasAttribute('hide-heading') ? true : false,
				collapsed: cell.hasAttribute('collapsed') ? true : false,
				collapsed_parent: false,
				depth: Number(item.tagName[1]),
				children: [],
			})
		}
		return collapseDependency(initialArray)
	}

	const collapseDependency = (initialArray) => 	{
		// Create an array that contains the current parent for each level
		const iterArray = new Array($(toc.depth))
		const parentIdx = () => {
			const idx = _.findLastIndex(iterArray,x => x != undefined)
			// return idx == -1 ? $(toc.depth) : idx
			return idx
		}
		let currentParentLevel = parentIdx()
		initialArray.forEach((element,n) => {
			// Populate children
			// console.log('iter: ',n,'currentParent =',currentParentLevel,'depth:',element.depth)
			while (element.depth <= (currentParentLevel + 1)) {
				// Close parents with dephts up to the same of the element 
				iterArray[currentParentLevel] = null
				// console.log('prevParent: ',currentParentLevel)
				currentParentLevel = parentIdx()
				// console.log('nextParent: ',currentParentLevel)
			}
			// push the current element as child of the parent
			if (currentParentLevel >= 0) {
				iterArray[currentParentLevel].children.push(n)
				// console.log('children:',iterArray[currentParentLevel])
			}
			iterArray[element.depth - 1] = element
			// Check if the parent is collapsed
			let collapsed_parent = false
			if (collapseAll == 0) {
			// console.log('standard-collapse')
			iterArray.forEach((x,nn) => {
				// Check each parent from the highest to the lower
				if (x == undefined || x === element || collapsed_parent) return
				collapsed_parent = collapsed_parent || x.collapsed
			})
		} else {
			collapsed_parent = element.depth == 1 ? false : collapseAll == 1
		}
			// console.log('forced-collaps:',collapsed_parent)
			element.collapsed_parent = collapsed_parent
			currentParentLevel = parentIdx()

		});
		// console.log(initialArray)
		return initialArray
	}

	node.getHeaderState = getHeaderState

	const [hide,set_hide] = useState(true)
	const [collapseAll,set_collapseAll] = useState(0)
	const [state, set_toc_state] = useState(getHeaderState())
	const [collapseToc, set_collapseToc] = useState(false)
	node.set_toc_state = set_toc_state

	const hideCells = () => {
		
		const cell_order = window.editor_state.notebook.cell_order

		if (!hide) {
			cell_order.forEach(id => {
				const cell = docu.getElementById(id)
				cell.removeAttribute('hidden')
			})
			return
		}

		// hide at default the cells before the first heading
		let hide_this = true
		let next_id = state[0].id
		let next_hindex = 0
		const hlength = state.length
		
		// Loop through all the cells and hide if the previous heading is flagged as hidden
		cell_order.forEach((id,n) => {

			if (id === next_id) {
				// console.log(n)
				hide_this = state[next_hindex].hidden
				next_hindex += 1
				next_id = next_hindex >= hlength ? '' : state[next_hindex].id
			}

			const cell = docu.getElementById(id)
			const cm = cell.querySelector('.cm-editor')?.CodeMirror ?? cell.querySelector('.CodeMirror')?.CodeMirror // Second version is for older pluto
			if (hide_this && id != toc_id && cm.getValue() !== "") {
				cell.setAttribute('hidden',"")
			} else {
				cell.removeAttribute('hidden')
			}
		})
		
	}

	node.hideCells = hideCells

	useEffect(() => {
		hideCells()
	}
	)

	useEffect(() => {
		recomputeWidth()
},[collapseToc])

	useEffect(() => {
		set_toc_state(getHeaderState())
	},[collapseAll]
	)

	const customClick = (e,id) => {
		const cell = docu.getElementById(id)
		e.preventDefault()
		if (e.altKey) {
			cell.toggleAttribute('hide-heading')
			set_toc_state(oldState => {
				return getHeaderState()
			}
			)
			return
		}
		if (e.ctrlKey) {
			cell.toggleAttribute('collapsed')
			set_toc_state(oldState => {
				return getHeaderState()
			}
			)
			set_collapseAll(0)
			return
		}
		const h = docu.getElementById(id)
		// console.log(h)
		h.scrollIntoView({
			behavior: 'smooth', 
			block: 'center'
		})
	}

	const headerClick = (e) => {
		//console.log(e)
		if (e.altKey) {
			e.preventDefault()
			set_hide(!hide)
			return
		}
		if (e.ctrlKey) {
			e.preventDefault()
			const newVal = collapseAll == 1 ? -1 : 1
			set_collapseAll(newVal)
			return
		}
		// e.preventDefault()
		
		const t = e.target
		if (t.classList.contains('full')) {
			t.closest('pluto-cell').scrollIntoView({
			behavior: 'smooth', 
			block: 'center'
			})
} else {
		set_collapseToc(!collapseToc)
}
	}

	const extractProps = item => ({
		hidden: item.hidden,
		text: item.title,
		id: item.id,
		key: item.id,
		onClick: customClick,
		hide: hide,
		depth: item.depth,
		collapsed: collapseAll === 0 ? item.collapsed : collapseAll == 1,
		collapsed_parent: item.collapsed_parent,
		children: item.children,
	})




	return  html`
	<mytag class='$(join(filter(x -> x isa String,(
		"plutoui-toc",
		toc.aside && "aside",
		toc.indent && "indent",
		))," "))\${collapseToc ? " collapse-toc" : ""}'>
	<header onClick=\${headerClick} class=\${hide ? "" : "show-hidden"}><span class="text"><span class="full">$(toc.title)</span><span class="collapsed">ToC</span></span><span class="filler"></span></header>
	<section>
		\${
		state.map(x => html`<\${Item} ...\${extractProps(x)}/>`)
		}
	</section>
	</mytag>`;
}
""";

# ╔═╡ 759e0c40-cea7-4c62-8123-179a97becc40
toc_js = toc -> """
const { html, render, Component, useEffect, useLayoutEffect, useState, useRef, useMemo, createContext, useContext, } = await import( "https://cdn.jsdelivr.net/npm/htm@3.0.4/preact/standalone.mjs")

// A new way to execute scripts was added in
// https://github.com/fonsp/Pluto.jl/commit/f9eae892c03fadd6c9c5455b93bbb998882db072, so if
// we have that commit the actual document is in document.document
const docu = document.document ?? document

const node = this ?? docu.createElement("div")

const notebook = docu.querySelector("pluto-notebook")

const cell = currentScript.parentElement.closest('pluto-cell')
const toc_id = cell.id

const recomputeWidth = () => {
	const mainElement = docu.querySelector('main')
	const maxWidth = docu.body.offsetWidth - mainElement.offsetWidth - mainElement.offsetLeft
	docu.documentElement.style.setProperty('--aside-toc-width', `calc(\${maxWidth}px - 5px - .8rem)`);
}


if(this == null){

	// PREACT APP STARTS HERE
	
$ItemDef

$(TocDef(toc))

	// PREACT APP ENDS HERE

render(html`<\${Toc}/>`, node);

// console.log('if')

}

const resizeObserver = new ResizeObserver(entries => recomputeWidth()
	)
resizeObserver.observe(cell)

const updateCallback = () => {
	const test = node.getHeaderState()
	node.set_toc_state(test)
}


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

// And finally, an observer for the docu.body classList, to make sure that the toc also works when if is loaded during notebook initialization
const bodyClassObserver = new MutationObserver(updateCallback)
bodyClassObserver.observe(docu.body, {attributeFilter: ["class"]})

invalidation.then(() => {
	notebookObserver.disconnect()
	bodyClassObserver.disconnect()
	resizeObserver.disconnect()
	observers.current.forEach((o) => o.disconnect())
})

return node
"""

# ╔═╡ 9784edff-a6ac-4308-a1af-71fedd1f2096
toc_heading("CSS",3,hide=true)

# ╔═╡ 844f74f6-d59a-4651-866b-fd1bd2dbfc3c
toc_style = """

.plutoui-toc div.hidden a {
	background-color: rgba(0, 0, 0, 0.1);
}


.plutoui-toc header {
	display: flex;
	font-size: 1.5em;
	margin-top: 0.67em;
	margin-bottom: 0.67em;
	margin-left: 0;
	margin-right: 0;
	font-weight: bold;
	border-bottom: 2px solid rgba(0, 0, 0, 0.15);
}
.plutoui-toc header.show-hidden span.text {
	color: rgba(0, 0, 0, 0.4);
	background-color: rgba(0,0,0,0.1)
}
.plutoui-toc header span.filler {
	flex: 1 1 0;
}

.plutoui-toc header span.text span.collapsed {
	display: none;
}

span.text {
cursor: pointer;
}

	// Hide the TOC in presentation mode
body.presentation .plutoui-toc.aside {
	display: none;
}

@media screen and (min-width: 1081px) {
	.plutoui-toc.aside {
		position:fixed; 
		right: .8rem;
		top: 5rem; 
		width: min(max(var(--aside-toc-width),15%),25%); 
		padding: 10px;
		border: 3px solid rgba(0, 0, 0, 0.15);
		border-radius: 10px;
		box-shadow: 0 0 11px 0px #00000010;
		/* That is, viewport minus top minus Live Docs */
		max-height: calc(100vh - 5rem - 56px);
		overflow: hidden;
		z-index: 10;
		background: white;
		display: flex;
		flex-direction: column;
	}
	.plutoui-toc.aside.collapse-toc header {
		margin: 0px 0px;
	}

	.plutoui-toc.aside.collapse-toc:not(:hover) {
		width: auto;
	}

	.plutoui-toc.aside.collapse-toc:not(:hover) span.text {
		width: auto;
	}

	.plutoui-toc.aside.collapse-toc:not(:hover) span.text span.collapsed {
		display: inline;
	}

	.plutoui-toc.aside.collapse-toc:not(:hover) span.text span.full {
		display: none;
	}

	.plutoui-toc.aside.collapse-toc section {
		display: none;
	}
	.plutoui-toc.aside.collapse-toc:hover section {
		display: block;
	}

}


.plutoui-toc section .toc-row {
	white-space: nowrap;
	overflow: hidden;
	text-overflow: ellipsis;
	padding-bottom: 2px;
}

.plutoui-toc section {
	overflow: auto;
}

.plutoui-toc section .toc-row a{
	text-overflow: ellipsis;
}

pluto-cell:not(.code_differs)[hidden] {
	display: none;
}

.plutoui-toc a {
	text-decoration: none;
	font-weight: bold;
	color: gray;
}

.plutoui-toc div[collapsed] a {
	text-decoration: underline;
}

.plutoui-toc div:hover a {
	color: black;
}

.plutoui-toc.indent a.H1 {
	margin-left: 0px;
}
.plutoui-toc.indent a.H2 {
	margin-left: 10px;
}
.plutoui-toc.indent a.H3 {
	margin-left: 20px;
}
.plutoui-toc.indent a.H4 {
	margin-left: 30px;
}
.plutoui-toc.indent a.H5 {
	margin-left: 40px;
}
.plutoui-toc.indent a.H6 {
	margin-left: 50px;
}
""";

# ╔═╡ 003a7fd4-da9c-4f72-861f-0778b98aa912
begin
	"""Generate Table of Contents using Markdown cells. Headers h1-h6 are used. 

	Custom re-implementation of the PlutoUI TableOfContents using preact. This was mostly done to experiment with preact and with creating preact components directly in the notebook.
	As my first ever attempt to use React or preact, this is still very alpha but I use it regularly and it mostly works

	Compared to the TableOfContents from PlutoUI, it provides some additional functionalities:
	- Hiding cells from notebook and TableOfContents
	- All cells before the first heading are automatically hidden from the notebook
	- Showing of hidden cells can be toggled by Alt-clicking on the side of the TableOfContents title
	- Hidden status of specific headings in the notebook can be toggled by Alt-clicking on the related entry in the ToC (When a heading is marked as hidden and the show of hidden cells is false, all the cells between the hidden heading and the next non-hidden heading are also hidden)
	- Collapsing headings in the Table of Contents, done by Ctrl+click on a heading
	- Shrinking of the TableOfContents when not hovered upon
	- This is toggled by doing a left click on the right of the TableOfContents title
	- Doing so will collapse the ToC to take as little space as possible on the notebook and only expand on hover

	# Keyword arguments:
	`title` header to this element, defaults to "Table of Contents"

	`indent` flag indicating whether to vertically align elements by hierarchy

	`depth` value to limit the header elements, should be in range 1 to 6 (default = 3)

	`aside` fix the element to right of page, defaults to true

	# Examples:

	```julia
	ToC()

	ToC(title="Experiments 🔬")

	ToC(title="📚 Table of Contents", indent=true, depth=4, aside=true)
	```
	"""
	Base.@kwdef struct ToC
		title::AbstractString="Table of Contents"
		indent::Bool=true
		depth::Integer=3
		aside::Bool=true
	end
	function Base.show(io::IO, mimetype::MIME"text/html", toc::ToC)
		show(io,mimetype,@htl """
			
<script id="asdf">
			$(HypertextLiteral.JavaScript(toc_js(toc)))
			</script>
			
			<style>
			$toc_style
			</style>
			""")
	end
end

# ╔═╡ 1ca8ba46-c816-488e-b728-061288a4d75f
export ToC, toc_heading, hide_heading, collapse_heading

# ╔═╡ 1a9e349a-8856-4c39-9bbf-f89001b2b8f2
#=╠═╡ notebook_exclusive
ToC(title="Table Of Contents")
  ╠═╡ notebook_exclusive =#

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
# ╠═64a29f5e-3334-43bb-a23f-8bfda53af1a4
# ╠═1ca8ba46-c816-488e-b728-061288a4d75f
# ╠═1a9e349a-8856-4c39-9bbf-f89001b2b8f2
# ╟─edd55419-df8a-45a5-8342-950749ae8980
# ╟─21761862-acb6-4691-97f0-a756865ac1cc
# ╟─ea897dda-e0d2-43f4-8c79-f96ce3897ac9
# ╠═9b27d817-1b57-4b43-948a-e0324082f520
# ╠═77c1e5d1-305e-4a07-a565-d3fd75e31028
# ╠═5e2f2d6b-949e-4b91-af0a-0a6baf23d00e
# ╟─3ea419e5-f70c-404f-813d-be8cfad99b79
# ╠═561c2bcf-d405-4e46-bd9d-c74500995a94
# ╟─d5eccf35-9aa6-48b4-9140-7ccb5d311820
# ╠═d1784dd2-9a25-4add-90a8-121f1e2620e6
# ╠═1228ed04-b62f-4703-9e5d-e1f5cb0bf640
# ╠═358d4034-20c6-4746-8c37-f91e79a369eb
# ╟─fa4699bb-78b0-43e9-9889-536af90af45b
# ╟─9429e332-6543-4a1a-94d6-9c3733712b5c
# ╠═25b4cb5d-504f-4922-9923-7668f83dcc2f
# ╠═003a7fd4-da9c-4f72-861f-0778b98aa912
# ╟─08ea2095-cdf3-4f3c-8dd7-792245ac6e56
# ╠═2aa06b9e-34cf-43de-8559-88ff9707216d
# ╟─0b832124-aca0-4172-9121-8f41c3c34bc8
# ╠═759e0c40-cea7-4c62-8123-179a97becc40
# ╟─e2307fb5-f3f8-482f-abae-5509bf48fe2d
# ╠═8b20a786-7020-4252-8e42-ffbd33fb19e4
# ╟─71a2347d-fb17-4c12-8298-9d07511ffb05
# ╠═028c5069-fc3d-48a0-84e1-476689539f2c
# ╟─9784edff-a6ac-4308-a1af-71fedd1f2096
# ╠═844f74f6-d59a-4651-866b-fd1bd2dbfc3c
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
