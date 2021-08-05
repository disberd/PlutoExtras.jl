### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ fcbd82ae-c04d-4f87-bbb7-5f73bdbf8bd0
html"""
<h1>Disclaimer</h1>
The code in this notebook is made to be viewed with a fork of Pluto that provides functionality to make cells exclusive to the notebook (meaning that they are commented out in the .jl file).
<br>
This is a custom feature I use to clean up notebooks and only execute the relevant cells of a notebook when this is included from normal julia (I use notebooks as building blocks for packages)
<br>
<br>
This is heavily inspired by the cell disabling that exists in Pluto and the source code to save notebook exclusivity on the file is copied/adapted from <a href="https://github.com/fonsp/Pluto.jl/pull/1209">pull request #1209.</a>
The actual modifications to achieve this functionalities
are shown <a href="https://github.com/disberd/Pluto.jl/compare/master@%7B2021-08-05%7D...disberd:notebook-exclusive-cells@%7B2021-08-05%7D">here</a>
<br>
<br>
When opening this notebook without that functionality, all cells after the macro and functions definition are <i>notebook_exclusive</i> and are thus surrounded by block comments.
<br>
<br>
To try out the <i>exclusive</i> parts of the notebook, press this <button>button</button> toggle between commenting in or out the cells by removing (or adding) the leading and trailing block comments from the cells that are marked as <i>notebook_exclusive</i>.
<br>
You will then have to use <i>Ctrl-S</i> to execute all modified cells (where the block comments were removed)
<br>
<br>
<b>You still need to use the #main branch of Pluto as the @ingredients macro only works properly with the macro analysis functionality that is not present in v0.15.1</b>

<script>
/* Get the button */
const but = currentScript.closest('.raw-html-wrapper').querySelector('button')


const exclusive_pre =  "#=╠═╡ notebook_exclusive"
const exclusive_post = "  ╠═╡ notebook_exclusive =#"

/* Define the function to identify if a cell is wrapped in notebook_exclusive comments */
const is_notebook_exclusive = cell => {
	if (cell.hasAttribute('notebook_exclusive')) return true
	const cm = cell.querySelector('pluto-input .CodeMirror').CodeMirror
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
	
	const cm = cell.querySelector('pluto-input .CodeMirror').CodeMirror
	const arr = cm.getValue().split('\n')
	if (arr[0] === exclusive_pre) {
// 		The comments must be removed
// 		Remove the first line
		arr.shift()
// 		Remove the last line
		arr.pop()
// 		Rejoin the array and change the editor text
	} else {
// 		The comments must be inserted
		arr.unshift(exclusive_pre)
		arr.push(exclusive_post)
	}
	cm.setValue(arr.join('\n'))
})}

but.addEventListener('click',onClick)
	invalidation.then(() => but.removeEventListener('click',onClick))	
</script>
"""

# ╔═╡ b87d12be-a37b-4202-9426-3eef14d8253c
function ingredients(path::String)
	# this is from the Julia source code (evalfile in base/loading.jl)
	# but with the modification that it returns the module instead of the last object
	name = Symbol(basename(path))
	m = Module(name)
	Core.eval(m,
        Expr(:toplevel,
             :(eval(x) = $(Expr(:core, :eval))($name, x)),
             :(include(x) = $(Expr(:top, :include))($name, x)),
             :(include(mapexpr::Function, x) = $(Expr(:top, :include))(mapexpr, $name, x)),
             :(include($path))))
	m
end

# ╔═╡ ae599257-a0cd-425c-a0a7-311e52b931e5
# Function that generates the actual expression for expanding the included symbols in the macro caller space
function _ingredients(path::String,modname::Symbol,kwargstrs::String...)
	m = ingredients(path)
	kwargs = (Symbol(s) => true for s ∈ kwargstrs if s ∈ ("all","imported"))
	varnames = names(m;kwargs...)
	# Remove the symbols that start with a '#' (still to check what is the impact)
	filter!(x -> first(String(x)) !== '#',varnames)
	# Symbols to always exclude from imports
	exclude_names = (
			nameof(m),
			:PLUTO_MANIFEST_TOML_CONTENTS,
			:PLUTO_PROJECT_TOML_CONTENTS,
			:eval,
			:include,
			Symbol("@bind"),
		)
	# Create the block that will contain the various assignment expressions
	block = Expr(:block)
	for v ∈ setdiff(varnames,exclude_names)
		push!(block.args,:($v = $(m).$v))
	end
	# Assign the module to the intended name
	modname !== :nothing && push!(block.args,:($modname = $m))
	# Put the html element to modify Shift-Enter
	push!(block.args,:($(html_toggle_whitespace())))
	esc(block)
end

# ╔═╡ 23af305c-677b-4575-8591-582ce51e8587
html_toggle_whitespace() = html"""
<script>
	const cm = currentScript.closest('pluto-cell').querySelector('pluto-input .CodeMirror').CodeMirror
	if (cm.on_submit) {
// 		Function already exist, do nothing
	} else {
// 		We save the default on_submit on the codemirror
		cm.on_submit = cm.options.extraKeys['Shift-Enter']
		console.log('First run, attached original on_submit on the CodeMirror element')
	}
// 	Do the processing of the cell input, toggline a whitespace at the end of the cell to trigger symbols recomputation on the macro
	const toggle_whitespace = () => {
		const text = cm.getValue()
		const last = text.slice(-1)
		const new_val = last === " " ? text.slice(0,-1) : text + " "
		cm.setValue(new_val)
	}
	const new_event = () => {
		toggle_whitespace()
		cm.on_submit()
	}
	
	cm.setOption('extraKeys',{...cm.options.extraKeys, 'Shift-Enter': new_event})
	
	// invalidation.then(async () => await cm.setOption('extraKeys',{...cm.options.extraKeys, 'Shift-Enter': on_submit}))
</script>
"""

# ╔═╡ 30b27e5e-b73f-4ce3-bca9-3944251ea42c
# Return the string of the path to include and eventually the name of the variable where to assigne the loaded module
function _process_ingredients_ex(ex,caller_module::Module,modname::Symbol=:nothing)
	ex isa String && return (ex,modname)
	if ex isa Expr && ex.head === :(=)
		return _process_ingredients_ex(ex.args[2],caller_module,ex.args[1])
	else
		path = Core.eval(caller_module,ex)
	end
	path isa String && return (path,modname)
	path isa Expression && return _process_ingredients_ex(path,caller_module,modname)
	error("The input to the @ingredients macro can only be a string or an expression whose right-hand side evaluates to a string") 
end	

# ╔═╡ 872bd88e-dded-4789-85ef-145f16003351
"""
	@ingredients path nameskwargs...
	@ingredients modname=path namekwargs...

This macro is used to include external julia files inside a pluto notebook and is inspired by the discussion on [this Pluto issue](https://github.com/fonsp/Pluto.jl/issues/1101).

It requires Pluto > v0.15.1 (requires macro analysis functionality) and includes and external file, taking care of putting in the caller namespace all varnames that are tagged with `export varname` inside the included file.

The macro relies on the use of [`names`](@ref) to get the variable names to be exported, and support providing the names of the keyword arguments of `names` to be set to true as additional strings 

Finally, to allow to correctly reflect variations in defined and exported variables inside of the included file, a custom keboard shortcut for *Shift-Enter* is placed inside the cell that contains the `@ingredients` macro.
This simply toggles adding and removing a whitespace at the end of the cell input before executing the cell when pressing the keyboard shortcut *Shift-Enter*.

This has the effect of avoid using the cached version of the macro and always re-evaluating the symbols that are assigned in the cell.
"""
macro ingredients(ex,kwargstrs...)
	path,modname = _process_ingredients_ex(ex,__module__)
	_ingredients(path,modname,kwargstrs...)
end

# ╔═╡ 63e2bd00-63b8-43f9-b8d3-b5d336744f3a
export @ingredients, ingredients

# ╔═╡ 3182a751-8c03-43e5-acb9-df07bd7c86dd
#=╠═╡ notebook_exclusive
md"""
## HTML Highlighting in the cell
When dealing with cells mostly having html/javascript, it is more convenient to use the synthax highlighting from the *htmlmixed* mode of CodeMirror rather than the *julia* one.\
Until [issue #1152](https://github.com/fonsp/Pluto.jl/issues/1152) is not resolved, we can do some hack to get limited functionality.

The cell below this one executes a js script that enable toggling between *julia* and *htmlmixed* mode with *Ctrl-Shift-M*.

Try it out by clicking inside the input of the cell below and pressing the shortcut (only tested on Chrome on Windows).
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 23167ca1-58b3-4c54-8810-d41e437992cb
#=╠═╡ notebook_exclusive
html"""
Loaded the script to change CodeMirror mode to <i>htmlmixed</i>, press <i>Ctrl-Shift-M</i> while inside a cell to toggle between <i>julia</i> and <i>htmlmixed</i> modes

<!-- Load the htmlmixed necessary scripts -->
<script src="https://cdn.jsdelivr.net/npm/codemirror@5.60.0/mode/xml/xml.js"></script>

<script src="https://cdn.jsdelivr.net/npm/codemirror@5.60.0/mode/javascript/javascript.js"></script>

<script src="https://cdn.jsdelivr.net/npm/codemirror@5.60.0/mode/css/css.js"></script>
											   
<script src="https://cdn.jsdelivr.net/npm/codemirror@5.60.0/mode/htmlmixed/htmlmixed.js"></script>

<!-- Script to make the shortcut -->
<script>
	const toggle_htmlmixed = cell => {
		const cm = cell.querySelector('pluto-input .CodeMirror').CodeMirror
		const new_mode = cm.options.mode == "julia" ? "htmlmixed" : "julia"
		console.log(new_mode)
		cm.setOption("mode",new_mode)
	}

	const listenerFunc = e => {
		if (e.key == "M" && e.ctrlKey && e.shiftKey) {
			const cell = e.target.closest('pluto-cell')
			if (cell) {
				e.preventDefault()
				e.stopImmediatePropagation()
				toggle_htmlmixed(cell)
			}
		}
	}
	
	document.addEventListener("keydown",listenerFunc)

	invalidation.then(() => document.removeEventListener("keydown",listenerFunc))
</script>
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 1f291bd2-9ab1-4fd2-bf50-49253726058f
#=╠═╡ notebook_exclusive
md"""
## Example Use
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ cf0d13ea-7562-4b8c-b7e6-fb2f1de119a7
#=╠═╡ notebook_exclusive
md"""
The cells below assume to also have the test notebook `ingredients_include_test.jl` from PlutoUtils in the same folder, download it and put it in the same folder in case you didn't already
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ bd3b021f-db44-4aa1-97b2-04002f76aeff
#=╠═╡ notebook_exclusive
notebook_path = "./ingredients_include_test.jl"
  ╠═╡ notebook_exclusive =#

# ╔═╡ 0e3eb73f-091a-4683-8ccb-592b8ccb1bee
#=╠═╡ notebook_exclusive
md"""
Try changing the content of the included notebook by removing some exported variables and re-execute (**using Shift-Enter**) the cell below containing the @ingredients call to see that variables are correctly updated.

You can also try leaving some variable unexported and still export all that is defined in the notebook by using 
```julia
@ingredients notebook_path "all"
```

Finally, you can also assign the full imported module in a specific variable by doing
```julia
@ingredients varname = notebook_path
```
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ d2ac4955-d2a0-48b5-afcb-32baa59ade21
#=╠═╡ notebook_exclusive
@ingredients notebook_path 
  ╠═╡ notebook_exclusive =#

# ╔═╡ 4cec781b-c6d7-4fd7-bbe3-f7db0f973698
#=╠═╡ notebook_exclusive
a
  ╠═╡ notebook_exclusive =#

# ╔═╡ a7e7123f-0e7a-4771-9b9b-d0da97fefcef
#=╠═╡ notebook_exclusive
b
  ╠═╡ notebook_exclusive =#

# ╔═╡ 2c41234e-e1b8-4ad8-9134-85cd65a75a2d
#=╠═╡ notebook_exclusive
c
  ╠═╡ notebook_exclusive =#

# ╔═╡ ce2a2025-a6e0-44ab-8631-8d308be734a9
#=╠═╡ notebook_exclusive
d
  ╠═╡ notebook_exclusive =#

# ╔═╡ 584c8631-a2aa-425c-a6cd-99b7df1d857d
#=╠═╡ notebook_exclusive
TestStruct()
  ╠═╡ notebook_exclusive =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-beta2"
manifest_format = "2.0"

[deps]
"""

# ╔═╡ Cell order:
# ╟─fcbd82ae-c04d-4f87-bbb7-5f73bdbf8bd0
# ╠═b87d12be-a37b-4202-9426-3eef14d8253c
# ╠═ae599257-a0cd-425c-a0a7-311e52b931e5
# ╠═23af305c-677b-4575-8591-582ce51e8587
# ╠═30b27e5e-b73f-4ce3-bca9-3944251ea42c
# ╠═872bd88e-dded-4789-85ef-145f16003351
# ╠═63e2bd00-63b8-43f9-b8d3-b5d336744f3a
# ╟─3182a751-8c03-43e5-acb9-df07bd7c86dd
# ╟─23167ca1-58b3-4c54-8810-d41e437992cb
# ╟─1f291bd2-9ab1-4fd2-bf50-49253726058f
# ╟─cf0d13ea-7562-4b8c-b7e6-fb2f1de119a7
# ╠═bd3b021f-db44-4aa1-97b2-04002f76aeff
# ╟─0e3eb73f-091a-4683-8ccb-592b8ccb1bee
# ╠═d2ac4955-d2a0-48b5-afcb-32baa59ade21
# ╠═4cec781b-c6d7-4fd7-bbe3-f7db0f973698
# ╠═a7e7123f-0e7a-4771-9b9b-d0da97fefcef
# ╠═2c41234e-e1b8-4ad8-9134-85cd65a75a2d
# ╠═ce2a2025-a6e0-44ab-8631-8d308be734a9
# ╠═584c8631-a2aa-425c-a6cd-99b7df1d857d
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
