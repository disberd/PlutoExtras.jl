# PlutoUtils

This package provides some very opinionated functionalities to work with PlutoNotebooks

This is mostly meant for personal use I will try to see if something can be adapted and made generic if you file an issue.

The most relevant exported functionalities are detailed in the rest of the README

# IMPORTANT!
The code in this notebook is made to be viewed with my [personal fork](https://github.com/disberd/Pluto.jl) of Pluto that provides functionality to make cells exclusive to the notebook (meaning that they are commented out in the .jl file).\
This is a custom feature I use to clean up notebooks and only execute the relevant cells of a notebook when this is included from normal julia (I use notebooks as building blocks for packages)

This is heavily inspired by the cell disabling that exists in Pluto and the source code to save notebook exclusivity on the file is copied/adapted from Pluto pull request [#1209](https://github.com/fonsp/Pluto.jl/pull/1209).

When opening this notebook without that functionality, all cells after the macro and functions definition are *notebook_exclusive* and are thus surrounded by block comments, like so for a cell with `using BenchmarkTools` as the sole command:
```julia
#=╠═╡ notebook_exclusive
using BenchmarkTools
  ╠═╡ notebook_exclusive =#
```

To correctly see the notebook, you can either:
1. Temporarily add my Pluto fork in a temp env to view the notebook in a parallel Pluto instance by running in a new julia CLI:
```julia
]activate --temp
add https://github.com/disberd/Pluto.jl
```
and then run pluto normally

2. Paste the following html snippet in a Pluto cell and execute it to show a button that will automatically strip all the exclusive comments from cells to try the notebook out: 
```html
html"""
To try out the <i>exclusive</i> parts of the notebook, press this <button>button</button> toggle between commenting in or out the cells by removing (or adding) the leading and trailing block comments from the cells that are marked as <i>notebook_exclusive</i>.
<br>
You will then have to use <i>Ctrl-S</i> to execute all modified cells (where the block comments were removed)
<script>
/* Get the button */
const but = currentScript.closest('.raw-html-wrapper').querySelector('button')


const exclusive_pre =  "#=╠═╡ notebook_exclusive"
const exclusive_post = "  ╠═╡ notebook_exclusive =#"

/* Define the function to identify if a cell is wrapped in notebook_exclusive comments */
const is_notebook_exclusive = cell => {
	if (cell.hasAttribute('notebook_exclusive')) return true
	const cm = cell.querySelector('.cm-editor')?.CodeMirror ?? cell.querySelector('.CodeMirror')?.CodeMirror // Second version is for older pluto
	const arr = cm.getValue().split('\n')
	const pre = arr.shift()
	if (pre !== exclusive_pre)  return false/* return if the preamble is not found */
	const post = arr.pop()
	if (post !== exclusive_post)  return false/* return if the preamble is not found */
	cell.setAttribute('notebook_exclusive','')
	return true
}

// Check for each cell if it is exclusive, and if it is, toggle the related attribute and remove the comment blocks
const onClick = () => {
// 	Get all the cells in the notebook
	const cells = document.querySelectorAll('pluto-cell')
	cells.forEach(cell => {
	if (!is_notebook_exclusive(cell)) return false
	
	const cm = cell.querySelector('.cm-editor')?.CodeMirror ?? cell.querySelector('.CodeMirror')?.CodeMirror // Second version is for older pluto
	const arr = cm.getValue().split('\n')
	if (arr[0] === exclusive_pre) {
// 		The comments must be removed
// 		Remove the first line
		arr.shift()
// 		Remove the last line
		arr.pop()
	} else {
// 		The comments must be inserted
		arr.unshift(exclusive_pre)
		arr.push(exclusive_post)
	}
// 	Rejoin the array and change the editor text
	cm.setValue(arr.join('\n'))
})}

but.addEventListener('click',onClick)
	invalidation.then(() => but.removeEventListener('click',onClick))	
</script>
"""
```

## Plots using PlotlyBase
Overloading the show function for PlotlyBase.Plot items

This functionality is implemented in [the plolty_show.jl notebook](./src/plotly_show.jl) 

## Interactive TableOfContents
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

This functionality is implemented in the [ToC.jl](./src/ToC.jl) notebook 

### Example usage

![ToC_example](https://user-images.githubusercontent.com/12846528/128350961-c4ccbcea-ba75-48dc-bd92-7c6551cc68f9.gif)

## @plutoinclude macro

The former `@ingredients` macro has been renamed to `@plutoinclude` and moved to [PlutoDevMacros](https://github.com/disberd/PlutoDevMacros). 

`@plutoinclude` is now aimed at being used to develop packages from multiple notebooks. Notebooks should be `plutoincluded` serially in the same order you would include corresponding source files from the Package main source file.
The functionality of the original `@ingredients` macro is available with nice improvements (ability to have reactive load) as part of [PlutoHooks](https://github.com/JuliaPluto/PlutoHooks.jl), developed by the main Pluto devs. 
