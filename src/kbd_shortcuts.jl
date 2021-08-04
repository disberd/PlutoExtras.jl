### A Pluto.jl notebook ###
# v0.15.0

using Markdown
using InteractiveUtils

# ╔═╡ 14c32152-633d-4867-b2a8-d0df2f40f967
using HypertextLiteral

# ╔═╡ 27ff3c56-2ec8-4ff9-9af1-28ffe8d8a546
md"""
### Add Hide Cell Shortcut
"""

# ╔═╡ 9a50693f-6d40-4be2-9386-538b06cbbe2b
"""
`hide_cell_shortcut()`

Creates an output script that allows hiding and un-hiding the last clicked pluto-cell with Ctrl+H, preventing default Ctrl+H behavior (Open history in chrome).

If the last click was outside of a pluto-cell, default behavior of Ctrl+H is preserved and no cell is hidden
"""
hide_cell_shortcut() = @htl """
Script to toggle cell visibility with Ctrl+H loaded.<br>When last mouse click was on a pluto-cell, default Ctrl+H behavior is prevented
<script>

let last_cell

const onClick = e => {
	last_cell = document.elementFromPoint(e.clientX,e.clientY).closest('pluto-cell')
}

document.addEventListener('click',onClick)

const func = e => {
	// Check if the target is a cell
	const t = e.target
	const this_cell = t.closest('pluto-cell')
	let cell = this_cell === null ? last_cell : this_cell
	if (cell === null) return
	const key = e.key
	
	if (key == "h" && e.ctrlKey) {
		e.preventDefault()
		const hide_but = cell.querySelector('.foldcode')
		hide_but.click()
		last_cell = cell
		return
	}
	
}

document.addEventListener('keydown',func)

invalidation.then(() => {
	document.removeEventListener('keydown',func)
	document.removeEventListener('click',onClick)
})
</script>
"""

# ╔═╡ 4249ecc2-d923-4dbf-8591-1325536a0705
export hide_cell_shortcut

# ╔═╡ 2b8cea1c-d93a-410f-99fa-5980dfab22cf
hide_cell_shortcut()

# ╔═╡ 7e11b076-8ae5-4dfd-9611-50bfac4de3fa
md"""
### Toggle *htmlmixed* mode
"""

# ╔═╡ a8dba449-e928-49f9-86cf-39bcf7d27eb9
"""
`toggle_htmlmixed_shortcut()`

Creates an output script that allows toggling the pluto-input CodeMirror mode between *htmlmixed* and *julia* by pressing `Ctrl-Shift-M` when inside a cell.

Default behavior of the shortcut as well as `immediatePropagation` are stopped when fired from inside a cell
"""
toggle_htmlmixed_shortcut() = html"""
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

# ╔═╡ 2a320d5b-f280-4939-b615-62e5f1496645
export toggle_htmlmixed_shortcut

# ╔═╡ 3bc02e95-880b-4809-b00c-87f22b85b3d4
toggle_htmlmixed_shortcut()

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
# ╠═14c32152-633d-4867-b2a8-d0df2f40f967
# ╟─27ff3c56-2ec8-4ff9-9af1-28ffe8d8a546
# ╠═9a50693f-6d40-4be2-9386-538b06cbbe2b
# ╠═4249ecc2-d923-4dbf-8591-1325536a0705
# ╟─2b8cea1c-d93a-410f-99fa-5980dfab22cf
# ╟─7e11b076-8ae5-4dfd-9611-50bfac4de3fa
# ╠═a8dba449-e928-49f9-86cf-39bcf7d27eb9
# ╠═2a320d5b-f280-4939-b615-62e5f1496645
# ╠═3bc02e95-880b-4809-b00c-87f22b85b3d4
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
