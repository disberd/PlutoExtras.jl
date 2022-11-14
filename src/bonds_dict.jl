### A Pluto.jl notebook ###
# v0.19.14

using Markdown
using InteractiveUtils

# ╔═╡ 6efb9ff0-52e7-11ec-2a4d-b788e3955703
begin
	using OrderedCollections
	using HypertextLiteral
	using PlutoUI
	using PlutoDevMacros.Script
	using AbstractPlutoDingetjes
end

# ╔═╡ 8179a3c3-dda2-47c2-9efc-014cce2d0c75
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	using PlutoPlotly
end
  ╠═╡ =#

# ╔═╡ ecd45d5d-40c7-4ebe-b541-4bffa3b7abd5
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
# Packages
"""
  ╠═╡ =#

# ╔═╡ 7cdb1e47-b06b-4cff-ab7e-b9451d261487
TableOfContents()

# ╔═╡ 278449d8-b67d-4ca9-9910-e19836e42a93
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
# Exports
"""
  ╠═╡ =#

# ╔═╡ 48414943-3a16-4826-8098-19089ed00646
# ╠═╡ skip_as_script = true
#=╠═╡
# # html"""
# <style>
# 	.bondtable .bondtable_link {
# 		display: none;
# 	}
# 	.bondtable .bondtable_bond {
# 		text-align: center;
# 	}
# </style>
# """
  ╠═╡ =#

# ╔═╡ 44430200-a8c4-4055-ba41-b54ab1b0d945
md"""
# FlexiBind Module
"""

# ╔═╡ 79b4d547-6d63-459d-9955-7f170320b9e6
module FlexiBind
include("./flexibond.jl")
end

# ╔═╡ a5f583c2-ffd5-42bd-9b40-798ce2178d2f
import .FlexiBind: flexibind_expr

# ╔═╡ 0b14e883-7548-4f65-a789-3cde165cc240
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
# BondWrapper definition
"""
  ╠═╡ =#

# ╔═╡ 564f1605-72cf-460a-9b8a-00277b12be8b
struct BondWrapper
	description::String
	cell_id::String
	bond::Any # This is supposed to be a Bond, but I don't know how to have the type without importing Pluto
	defines::Symbol
end

# ╔═╡ 90b11594-8b04-41c6-9a53-b1de98f71de2
const BondTable = LittleDict{String, <:BondWrapper}

# ╔═╡ 7eea8ae9-8d6c-448c-841d-dc9639244fb5
Base.show(io::IO, m::MIME"text/html", b::BondWrapper) = show(io,m,b.bond)

# ╔═╡ b6602853-a52d-462f-81f2-b7330dc6033f
is_table_name(b::BondWrapper) = b.description === "__table_name__" ? true : false 

# ╔═╡ ab41cb62-44b9-4994-90ef-a9ed329c9394
md"""
## Script
"""

# ╔═╡ fd7a4077-4c39-4a5a-9e8f-de421ab06090
md"""
### Combined
"""

# ╔═╡ 722ec88a-5be7-47b3-9c4c-df0062049c05
md"""
### Basic
"""

# ╔═╡ c7585964-0f80-48bf-b2c5-66f3077422ab
_script_basic = HTLScriptPart(@htl """
<script>
	let out = html`<span class='script-output'></span>`
	let tb = currentScript.parentElement
	let tit = tb.querySelector('.title > .name-container')
	let hideTable = (e) => {
		tb.classList.toggle('hide')
	}
	let collapse_button = tb.querySelector('span.collapse')
	collapse_button.addEventListener('click', hideTable)
	let m = matchMedia("(max-width: 1000px)")
	let match_listener = () => 
		tb.classList.toggle("hide", m.matches)
	match_listener()
	m.addListener(match_listener)
</script>
""");

# ╔═╡ 73a3a65c-20dc-4855-800b-057c930e2e4b
@htl """
<span class='diosantore' style='font-weight: 900;'></span>
<style>
	span.diosantore:after {
		content: "LOL";
	}
</style>
"""

# ╔═╡ 36984080-2ef7-43fe-af3a-3d57902b5e25
md"""
### Drag Handler
"""

# ╔═╡ dbea9296-2d91-49ea-bf7d-67d965e9a56a
_drag_handler = HTLScriptPart(@htl """
<script>
// taken from https://www.w3schools.com/howto/howto_js_draggable.asp
function dragElement(elmnt) {
  var pos1 = 0, pos2 = 0, pos3 = 0, pos4 = 0;
  elmnt.onmousedown = dragMouseDown;

  function dragMouseDown(e) {
    e = e || window.event;
    e.preventDefault();
    // get the mouse cursor position at startup:
    pos3 = e.clientX;
    pos4 = e.clientY;
    document.onmouseup = closeDragElement;
    // call a function whenever the cursor moves:
    document.onmousemove = elementDrag;
  }

  function elementDrag(e) {
    e = e || window.event;
    e.preventDefault();
    // calculate the new cursor position:
    pos1 = pos3 - e.clientX;
    pos2 = pos4 - e.clientY;
    pos3 = e.clientX;
    pos4 = e.clientY;
    // set the element's new position:
    tb.style.top = out.top = (tb.offsetTop - pos2) + "px";
    tb.style.left = out.left = (tb.offsetLeft - pos1) + "px";
  }

  function closeDragElement() {
    // stop moving when mouse button is released:
    document.onmouseup = null;
    document.onmousemove = null;
  }
}
dragElement(tit)

tit.addEventListener('dblclick', (e) => {
	tb.style.top = out.top = ''
	tb.style.left = out.left = ''
})
</script>
""");

# ╔═╡ 33e72f37-4e78-4131-9df0-d4fbb04c8e8c
_script = (@htl """
<script id='main_table_script'>
	$([
		_script_basic,
		_drag_handler,
	])
	return out
</script>
""");

# ╔═╡ 4645b816-e4e0-426f-879e-ef5d9f7dc32d
md"""
## Style
"""

# ╔═╡ 8931cdeb-e397-42fb-a57f-c5b8c03c2bb9
md"""
### Table Container
"""

# ╔═╡ b5bcc803-e8f6-4bd6-ac6e-8d7c6ee38e68
_table_container_style = @htl """
<style>
	.table_container {
		--main-bg-color: #fafafa;
		position: fixed;
		width: 400px;
		top: 65px;
		left: 20px;
		background: var(--main-bg-color);
		resize: both;
		overflow: auto;
		z-index: 50;
		transition: transform 300ms cubic-bezier(0.18, 0.89, 0.45, 1.12);
		border: 3px solid rgba(0, 0, 0, 0.15);
		border-radius: 10px;
		box-shadow: 0 0 11px 0px #00000010;
	}
	.table_container.hide {
		resize: none;
		transform: translateX(calc(-100% + 35px));
		height: auto !important;
		left: 0px !important;
	}
	.table_container > .resize_handler {
		position: absolute;
		right: 0px;
		bottom: 0px;
		height: 10px;
		width: 10px;
		content: '';
	}
	@media (prefers-color-scheme: dark) {
		.table_container {
			--main-bg-color: #303030;
			--pluto-output-color: hsl(0, 0%, 90%);
			color: var(--pluto-output-color);
			--icon-filter: invert(1);
		}
	}
</style>
""";

# ╔═╡ 085a5a7b-e4e0-4dd0-af86-09c9d67c3e20
md"""
### Params Container
"""

# ╔═╡ d9cc094b-8453-4e74-9420-ec9c3be7f585
_params_container_style = @htl """
<style>
	.params_container {
		width: 100%;
		height: 100%;
		display: grid;
		grid-template-columns: 1fr minmax(50px, 100px) auto auto;
		grid-auto-rows: fit-content(40px);
		row-gap: 10px;
		justify-items: center;
		padding: 5px 5px 10px 0px;
		align-items: center;
	}
	.table_container.hide > .params_container > *:not(.title) {
		display: none;
	}
	.table_container.hide > .params_container {
		padding-bottom: 5px;
	}
	.params_container .title {
		grid-column: 1 / -1;
		font-weight: 800;
		justify-self: stretch;
		display: flex;
		position: sticky;
		top: 0px;
		background: var(--main-bg-color);
		z-index: 100;
	}
	.params_container .title  > .name-container {
		cursor: move;
		display: inline-block;
		flex: 1;
		text-align: center;
	}
	.params_header {
		display: contents;
	}
</style>
""";

# ╔═╡ b7b34f12-5930-4b6e-8a62-51b6b2b995ad
md"""
### Icons
"""

# ╔═╡ e9b706a0-276f-4f0e-8614-7cb4060457ea
_icons_style = @htl """
<style>
	.table_container .icon {
		filter: var(--icon-filter);
		display: inline-block;
		--size: 25px;
		margin: 0 0;		
		align-self: center;
	}
	.title > .icon.help {
		cursor: help;
		--size: 22px;
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/help.svg");
		margin-left: 3px;
	}
	.title > .icon.collapse {
		cursor: pointer;
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/arrow-back.svg");
	}
	.table_container.hide .icon.collapse {
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/options-outline.svg");
	}
	.table_container.hide .icon.collapse:hover {
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/arrow-forward.svg");
	}
</style>
""";

# ╔═╡ d4549cda-cd11-4c7d-9411-7ab0c56f9d2a
md"""
# Helpers scripts
"""

# ╔═╡ 70c17b71-57d8-4742-a07b-4c3ce9986fff
md"""
### attach to window
"""

# ╔═╡ dc2e6674-0de1-4a39-abaa-9d2aea3a2838
md"""
### popup style script
"""

# ╔═╡ b245f253-f7ec-452c-84ae-e7e6c05842a4
_popup_style_script = HTLScriptPart(@htl """
<script>
	let popup_style = document.querySelector('style.pluto-popup-style') ?? (() => {
		console.log('adding the popup style to the body')
 		let st = html`<style class='pluto-popup-style'><style>`
		document.body.appendChild(st)
		return st
	})()
</script>
""");

# ╔═╡ 2929793e-3f0e-4812-a0a6-1b12ddd92bae
_attach_to_window = @htl """
<script>
	let bondsdict = window.bondsdict
	if (window.bondsdict == undefined) {
		console.log('attaching html and htmlpreact to the window!')
		const { html: htmlpreact } = await import("https://cdn.jsdelivr.net/gh/fonsp/Pluto.jl/frontend/imports/Preact.js")
		$_popup_style_script
		let popup = document.querySelector('pluto-popup')
		let events = {
			popup: {
				mouseenter: (e) => {
					//console.log('on popup')
					popup_style.toggleAttribute('popup-hovered', true)
				},
				mouseleave: (e) => {
					//console.log('off popup')
					popup_style.toggleAttribute('popup-hovered', false)
				},
			},
			style: {
				'reset style': (e) => {
					//console.log('deleting style')
					popup_style.innerText = ``
				}
			}
		}
		bondsdict = {
			htmlpreact, 
			html,
			popup_style,
			events, 
		}
		window.bondsdict = bondsdict
	}	
	
	let { popup_style, events } = bondsdict
	let popup = document.querySelector('pluto-popup')
	for (const [key,val] of Object.entries(events.popup)) {
		popup.addEventListener(key, val)
	}
	for (const [key,val] of Object.entries(events.style)) {
		popup_style.addEventListener(key, val)
	}
	invalidation.then(() => {	
		for (const [key,val] of Object.entries(events.popup)) {
			popup.removeEventListener(key, val)
		}
		for (const [key,val] of Object.entries(events.style)) {
			popup_style.removeEventListener(key, val)
		}
	})
</script>
"""

# ╔═╡ 9dc75181-4ef3-4063-acbe-2f1e8319b8c3
md"""
### script preamble
"""

# ╔═╡ 66944c66-ead7-4d62-9d09-7083cb79f7c2
_script_preamble = HTLScriptPart(@htl """
<script>
	let { htmlpreact, events } = window.bondsdict
	let parent = currentScript.parentElement
	let row = currentScript.closest('.table-row')
	$_popup_style_script
	for (const [key,val] of Object.entries(events.style)) {
		popup_style.addEventListener(key, val)
	}
	let popup = document.querySelector('pluto-popup')
	for (const [key,val] of Object.entries(events.popup)) {
		popup.addEventListener(key, val)
	}
</script>
""")

# ╔═╡ 289a2e4f-6978-4549-8cf3-83ac2a6a1fee
md"""
### popup events
"""

# ╔═╡ 92b34600-a1d7-40b6-affa-722114310163
function _popup_events(bypass, popup_id::String=FlexiBind.randstr(6), style="pluto-popup {
			font-size: 14px;
}")
	HTLScriptPart(@htl """
<script>
	let mouse_over_parent = false
	let mouse_over_popup = false
	let open = () => {
		let popupbody = htmlpreact`$bypass`
		return new CustomEvent("open pluto popup", {
			detail: {
				type: "info",
	   			source_element: parent,
				body: popupbody
			}
		})
	}
	
	const exitListener = (isparent,t=300) => {
		return (e) => {
			if (isparent) mouse_over_parent = false
			setTimeout(() => {
				maybeClose(e)
			}, t)
		}
	}
	
	function maybeClose(e) {
		if (mouse_over_parent) {
			parent.addEventListener('mouseleave', exitListener(true), {once: true})
			return
		} 
		if (popup_style.hasAttribute('popup-hovered')) {
			popup.addEventListener('mouseleave', exitListener(false), {once: true})
			return
		}
		let el = popup.querySelector(`[popup_id=$popup_id`)
		if (el == null) return
		window.dispatchEvent(new CustomEvent("close pluto popup"))
		popup_style.dispatchEvent(new CustomEvent('reset style'))
	}

	parent.addEventListener('mouseenter', (e) => {
		mouse_over_parent = true
		popup_style.innerText = $style
		window.dispatchEvent(open())
		parent.addEventListener('mouseleave', exitListener(true), {once: true})
	})
</script>
""")
end

# ╔═╡ 4efe496a-6cc7-49c4-9da5-96cc24db648e
md"""
# Popup Contents
"""

# ╔═╡ df3a50e3-21c4-4082-af97-0fee3ad8018d
md"""
## Description
"""

# ╔═╡ 02391183-03d5-421a-9f92-126aeebebff4
md"""
### content
"""

# ╔═╡ 198fd46e-7c64-43f4-88fe-b5ab3374ff64
function _description_popup_content(def)
	unique_id = FlexiBind.randstr(6)
	bypass = HTLBypass(@htl """
<div class='table-popup description' popup_id='$unique_id'>
<div>The symbol for this parameter is</div>
<div><em>$def</em></div>
\${(() => {
	let { htmlpreact } = window.bondsdict
	let reactive = defaultElement.reactive
	let value = defaultElement.value
	return reactive != value ? htmlpreact`<div>The current input has a value of <b>\${reactive}</b>, while the bound values are:</div>` : htmlpreact`<div>The current bound values are:</div>`
})()}
<div>default: <b>\${defaultElement.value}</b></div>
<div>static: <b>\${staticElement.value}</b></div>
</div>
""")
	return bypass, unique_id
end

# ╔═╡ 4f3f4e06-697b-4ec3-870e-4ea6571a49a6
md"""
### script
"""

# ╔═╡ 47c5f812-3b4e-4cbf-b5b1-3b6a5934c40b
function _desc_script(b::BondWrapper)
	def = b.defines
	desc = b.description
	@htl """
<script>
	$([
		_script_preamble,
		_popup_events(_description_popup_content(def)...)
	])
	let defaultElement = row.querySelector('.flexiwrapper')
	let staticElement = row.querySelector('.staticbond')
</script>
	"""
end

# ╔═╡ ecf63517-bd05-498c-a5af-7acbac541e2e
md"""
## Sync
"""

# ╔═╡ 03cb82c0-d4b6-42c8-b3ff-bc85a9560014
md"""
### content
"""

# ╔═╡ 9d67b79a-6526-43c0-8265-826b8270d0d5
function _sync_popup_content() 
	unique_id = FlexiBind.randstr(6)
	bypass = HTLBypass(@htl """
<div class='table-popup sync' popup_id='$unique_id'>
The toggles below specify, for each bond, whether the bound value is kept in sync with the javascript input or not.
<br/>
<br/>
When the toggle is turned <b>off</b>, the current value is kept constant regardless of the javascript input for as long as the toggle is off.
	<br/>
	<br/>
When the toggle is turned <b>on</b>, the bond value is updated to the current value of the input and the automatic sync is resumed.
</div>
""")
	return bypass, unique_id
end

# ╔═╡ 35d91b10-3dff-4287-90aa-08cb1da205e5
md"""
### script
"""

# ╔═╡ 994fa807-b909-443c-a2c2-055c7c75f908
function _sync_popup_script()
	@htl """
<script>
	$([
		_script_preamble,
		_popup_events(_sync_popup_content()...)
	])
</script>
	"""
end

# ╔═╡ faa406f4-5fe6-488a-a2a3-d8d081d4bc71
md"""
## Upate
"""

# ╔═╡ 57e67483-5d2a-431c-9e45-4f9eb731e057
md"""
### content
"""

# ╔═╡ 8257d42c-b5d4-4e39-b432-5b7757c5fb4f
function _update_popup_content() 
	unique_id = FlexiBind.randstr(6)
	bypass = HTLBypass(@htl """
<div class='table-popup update' popup_id='$unique_id'>
Each of parameter in this table defines two bound variables:
	<ul>
	<li>
		One that follows the javascript input based on the <em>Sync</em> button, representing the <em>default</em> bond value.
	</li>
		<li>
			One that is kept constant and is only updated upon manual trigger from the user, representing the <em>static</em> bond value.
		</li>
		
	</ul>
The buttons below trigger a manual update of the static bond.
	<br/>
You can check the current default and static values for this parameter by hovering on the parameter name.
</div>
""")
	return bypass, unique_id
end

# ╔═╡ c1bb63e3-36c7-4f26-8227-1166408d818c
md"""
### script
"""

# ╔═╡ f4cd1732-7a02-4d36-b145-bae202eed90c
function _update_popup_script()
	style = """
	pluto-popup div {
		font-size: 14px;
	}
	"""
	@htl """
<script>
	$([
		_script_preamble,
		_popup_events(_update_popup_content()...,style)
	])
</script>
	"""
end

# ╔═╡ 992ce6fa-385a-4797-a6f3-ad3c3715f927
md"""
## Help
"""

# ╔═╡ f27fb377-57d6-47b9-9d78-2b484ce69edb
md"""
### content
"""

# ╔═╡ dc78334d-21fb-4b17-a946-f93f4f99f8cb
function _help_popup_content(desc, def) 
	unique_id = FlexiBind.randstr(6)
	bypass = HTLBypass(@htl """
<div class='table-popup help' popup_id='$unique_id'>
This table controls the bound variables associated to the <b>$desc</b> parameters, which are contained in the dictionary stored in the julia variable <em>$def</em>.
	<br/>
	<br/>
The table itself can be collapsed and expanded by pressing the arrow icon in the top right.
	<br/>
It can be moved by dragging with the mouse from the table name and it can be restored to its original position by double clicking on the table name.
	<br/>
	<br/>
	It can also be resized by dragging from the top-right corner of the table.
</div>
""")
	return bypass, unique_id
end

# ╔═╡ 531be33a-eef4-4a5a-b72f-2fcf64cfc4bf
md"""
### script
"""

# ╔═╡ 48045f65-88a4-4b9f-aaeb-fe24fe2e6925
function _help_popup_script(desc, def)
	style = """
	pluto-popup.visible {
		transform: scale(1) translateY(30px); 
		transition: none 1.5s;
	}
	pluto-popup div {
		font-size: 14px;
	}
	"""
	@htl """
<script>
	$([
		_script_preamble,
		_popup_events(_help_popup_content(desc, def)...,style)
	])
</script>
	"""
end

# ╔═╡ 685e1202-a553-4fcd-ae9d-152b92aede9f
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
# Show Methods
"""
  ╠═╡ =#

# ╔═╡ 1defc7ea-501c-40a2-b311-c2d171a09401
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## table_row
"""
  ╠═╡ =#

# ╔═╡ 44cc8f3b-d633-47d4-b39b-7ea299ffe281
function table_row(b::BondWrapper)
def = b.defines
desc = b.description
def_without_spaces = replace(string(def), ' ' => '_')
is_table_name(b) && return @htl ""
@htl """
<div class='table-row $def_without_spaces'>
	<span class='desc'>$(desc)$(_desc_script(b))</span>
	$(b.bond)
	<style>
		.table-row {
			display: contents;
		}
	</style>
</div>
"""
end

# ╔═╡ c74801ab-de4e-4748-aec8-339d56789506
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## Main Method
"""
  ╠═╡ =#

# ╔═╡ ce661fec-c1b5-4150-b863-c42e47defd0a
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## show_bondsdict
"""
  ╠═╡ =#

# ╔═╡ 72841851-4303-4b33-842b-d6812737023e
function show_bondsdict(d::BondTable; name = d["__table_name__"].bond.content, class = nothing, id = nothing)
table_name = d["__table_name__"]
def = table_name.defines
desc = table_name.bond.content
@htl """
$_attach_to_window
<div class='table_container'>
	$_script
	<div class='params_container'>
	<div class='title'>
		<span class='help icon'>$(_help_popup_script(desc, def))</span>
		<div class='name-container'><span class='name'>$desc</span></div>
		<span class='collapse icon'></span>
	</div>
	<div class='params_header'>
		<span>Name</span>
		<span>Bond</span>
		<span>Sync$(_sync_popup_script())</span>
		<span>Update$(_update_popup_script())</span>
	</div>
	$(map(table_row, values(d)))
</div>
<!-- <span class='resize_handler'><script>
	let parent = currentScript.parentElement
	console.log(parent)
	parent.addEventListener('click', (e) => {
		console.log('gesu')
	})
</script></span> -->
</div>
$([
	_table_container_style,
	_params_container_style,
	_icons_style,
])
<style>
	.params_container bond {
		display: contents;
	}
	.params_container .flexiwrapper > input:first-child {
		justify-self: stretch;
	}
	.params_header span {
		font-style: italic;
		font-size: 18px;
	}
	.title .name {
		font-size: 20px;
	}
</style>
"""

end

# ╔═╡ ad60610b-aebb-454a-9e33-bb8affb0d484
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## Clean Dictionary
"""
  ╠═╡ =#

# ╔═╡ 4ee12b02-a0bb-4216-a9cf-92bcb89e664f
# Remove entries that are associated with variables that don't exist anymore
function clean_dict!(d, mod)
	for (n,v) ∈ d
		isdefined(mod,v.defines) || delete!(d,n)
	end
end

# ╔═╡ f9dc72b6-d9d1-4777-94fe-942e9b1a2635
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## update\_show
"""
  ╠═╡ =#

# ╔═╡ 3f8250d6-ef3b-4634-ba99-91c6dd1cbd22
function update_show(d, key, selector) 
@htl """
$(d[key])
<script>
	// Search for the cell with the @showbonds for this dict if it exist
	const cell = document.querySelector($selector).closest('pluto-cell')
	let rerun = () => {}
	if (cell) {
		rerun = () => cell.querySelector(".runcell").click()
	} 
	rerun()
	invalidation.then(() => rerun())
</script>
"""
end

# ╔═╡ 832eed66-c4a9-4783-b9ef-a48b472a349b
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
# Macros definitions
"""
  ╠═╡ =#

# ╔═╡ ea30c6b9-d55a-4257-8344-347d5060c0c8
function splitdef(name::Expr)
	if name.head !== :ref || !(name.args[2] isa String)
		error("The provided expression must be in the form name[description] as first argument, where description must be a string")
	end
	dictname, desc = name.args
end

# ╔═╡ 957927ab-0c60-4557-b550-23b14546fa6a
classname(dictname::Symbol) = "$(dictname)"

# ╔═╡ 5a5bf586-8987-49b7-af82-1fc7ae7d8c33
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## @bondsdict
"""
  ╠═╡ =#

# ╔═╡ 420d8430-b5bd-485e-b164-a1fecebc4700
macro bondsdict(s::Symbol, name::String = "Parameters")
	_s = esc(s)
	# Find the cell_id of the macrocall where this bond is defined
	cell_id = split(__source__.file::Symbol |> String,"#==#") |> last |> String
	quote
		$_s = LittleDict("__table_name__" => BondWrapper("__table_name__", $cell_id, $(HTML(name)), $(Meta.quot(s))))
	end
end

# ╔═╡ 5e5b7c87-4f0b-4826-b25c-b71028c9ec90
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## @showbonds
"""
  ╠═╡ =#

# ╔═╡ 295d3811-a102-4c62-9ea1-7fd1b04a36f2
# ╠═╡ skip_as_script = true
#=╠═╡
@bondsdict params "Gesu Cristo"
  ╠═╡ =#

# ╔═╡ 0596419d-d9cc-47e1-9ef3-77b0a48b50a5
#=╠═╡
show_bondsdict(params)
  ╠═╡ =#

# ╔═╡ c0105f4e-632e-405a-b59d-25eaf17767ef
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## @addbond
"""
  ╠═╡ =#

# ╔═╡ d86e08a9-5efb-4c97-bd59-946b82f0f5fb
function _addbond_expr(calling_module, cell_id, name, bondvalue)
	dictname, desc = splitdef(name)
	_dictname = esc(dictname)
	remove_dots(x) = replace(x, '.' => "")
	symbolname = Symbol(:_,dictname,:_,desc |> remove_dots)
	_addbond_expr(calling_module, cell_id, name, symbolname, bondvalue)
end

# ╔═╡ ecf49c6a-fe57-41e0-9e6f-63c7e5176861
function _addbond_expr(calling_module, cell_id, name, symbolname::Symbol, bondvalue)
	dictname, desc = splitdef(name)
	_dictname = esc(dictname)
	# Find the cell_id of the macrocall where this bond is defined
	block = quote
		if haskey($_dictname, $desc) && $_dictname[$desc].cell_id !== $cell_id
			error("The provided key/description is already present in the dict and defined in another cell, please change the definition from that cell")
		end
		local wrapper = BondWrapper($desc, $cell_id, $(flexibind_expr(calling_module, symbolname, bondvalue)), $(Meta.quot(symbolname)))
		# Delete the stale bonds
		clean_dict!($_dictname, $(esc(calling_module)))
		$_dictname[$desc] = wrapper
	end
end

# ╔═╡ ac5e41e2-89c7-4045-9275-7cebe6b6dd92
macro addbond(name, args...)	
	cell_id = split(__source__.file::Symbol |> String,"#==#") |> last |> String
	_addbond_expr(__module__, cell_id, name, args...)
end

# ╔═╡ 3eab3e1c-d2f7-4141-ad57-d021f24c9db5
#=╠═╡
@addbond params["GESU"] Scrubbable(1:10);
  ╠═╡ =#

# ╔═╡ eb80cbe8-dbcc-4a45-90b3-d00b33552bae
#=╠═╡
@addbond params["Signore.RE"] Slider(1:10)
  ╠═╡ =#

# ╔═╡ 1fdca475-77d9-4f0f-9972-695eac5bc9da
#=╠═╡
@addbond params["MADONNA"] Slider(1:10);
  ╠═╡ =#

# ╔═╡ 19758fbf-425d-4836-8522-9618820651ce
#=╠═╡
@addbond params["Grazia Divina"] ciao Slider(1:10);
  ╠═╡ =#

# ╔═╡ 7bce22ad-2de0-4d34-a660-0a3c059d9857
#=╠═╡
ciao
  ╠═╡ =#

# ╔═╡ b1f64f22-da01-45c0-a2f8-48cb6673d473
# ╠═╡ skip_as_script = true
#=╠═╡
md"""
## @getbond
"""
  ╠═╡ =#

# ╔═╡ d53dbcb4-82f6-43c4-9859-eb233dbbf585
function _symbol_name(calling_module, name_expr, suffix="")
	dictname, desc = splitdef(name_expr)
	isdefined(calling_module, dictname) || return throw("The dictionary $dictname does not exist in the current module")
	d = getfield(calling_module, dictname)
	wrapper = get(d, desc) do
		throw("The dictionary $dictname has no parameter $desc")
	end
	sym = wrapper.defines
	return Symbol(sym, (isempty(string(suffix)) ? () : (:_, suffix))...)
end

# ╔═╡ 1c958b8a-ec45-41da-a200-5b5a712165cc
_getbond_expr(calling_module, name::Expr, suffix="") = _symbol_name(calling_module, name, suffix)

# ╔═╡ fa1b5db7-5d3b-4e9b-bd08-8e11c1e84305
function _getbond_expr(calling_module, names, suffix="")
	ex = Expr(:tuple)
	for nm ∈ names
		push!(ex.args, _symbol_name(calling_module, nm, suffix))
	end
	if length(names) == 1
		ex = ex.args[1]
	end
	ex
end

# ╔═╡ 2471400c-bc46-498d-b6d8-64adbd8a8b7a
macro getbond(names::Expr...)
	ex = try
		esc(_getbond_expr(__module__,names))
	catch e
		:(throw($(e)))
	end
end

# ╔═╡ 81d7fd40-255a-4116-a7fa-019a735374d6
macro getbond_static(names::Expr...)
	ex = try
		esc(_getbond_expr(__module__,names))
	catch e
		:(throw($e))
	end
end

# ╔═╡ 264e720b-db52-40cd-be6b-53004fa0ef10
macro getbond(kind::Union{String, Symbol}, names...)
	ex = _getbond_expr(__module__,names, kind)
	esc(ex)
end

# ╔═╡ f88ad8a5-8875-41b8-9680-8de93c27948d
begin
	# export BondWrapper, LittleDict
	export @bondsdict, @addbond, @getbond
end

# ╔═╡ 154b2bfb-2d0e-47f6-8623-1d1b66df6e8a
begin
	const var"@gb" = var"@getbond"
	const var"@gbs" = var"@getbond_static"
end;

# ╔═╡ 758f4fa3-1b01-4748-992e-6486cba4c905
#=╠═╡
@gb params["GESU"]
  ╠═╡ =#

# ╔═╡ e04df756-5202-46f3-a013-c2ba20b8005a
#=╠═╡
@gb params["GESU"] params["MADONNA"]
  ╠═╡ =#

# ╔═╡ f6d39c5e-4458-44ab-a8b2-ee74e921963d
#=╠═╡
@gbs(params["GESU"]),@gb(params["GESU"])
  ╠═╡ =#

# ╔═╡ 32cac62a-66cb-467d-90ee-3c5c3dd4e9a2
#=╠═╡
let
	n = @gb params["MADONNA"]
	plot(rand(10,n))
end
  ╠═╡ =#

# ╔═╡ 025a54a9-511e-4781-b640-c76f5c43ee79
#=╠═╡
@gb params["Grazia Divina"]
  ╠═╡ =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
OrderedCollections = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoPlotly = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractPlutoDingetjes = "~1.1.4"
HypertextLiteral = "~0.9.3"
OrderedCollections = "~1.4.1"
PlutoDevMacros = "~0.4.8"
PlutoPlotly = "~0.3.6"
PlutoUI = "~0.7.21"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.8.2"
manifest_format = "2.0"
project_hash = "a79e64fd914c88b792ba0fae7eaefb21fcdbd4fa"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "e7ff6cadf743c098e08fca25c91103ee4303c9bb"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.15.6"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "38f7a08f19d8810338d4f5085211c7dfa5d5bdd8"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.4"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "ColorVectorSpace", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "1fd869cc3875b57347f7027521f561cf46d1fcd8"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.19.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.ColorVectorSpace]]
deps = ["ColorTypes", "FixedPointNumbers", "LinearAlgebra", "SpecialFunctions", "Statistics", "TensorCore"]
git-tree-sha1 = "d08c20eef1f2cbc6e60fd3612ac4340b89fea322"
uuid = "c3611d14-8923-5661-9e6a-0046d554d3a4"
version = "0.9.9"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.Compat]]
deps = ["Dates", "LinearAlgebra", "UUIDs"]
git-tree-sha1 = "3ca828fe1b75fa84b021a7860bd039eaea84d2f2"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "4.3.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "0.5.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "c36550cb29cbe373e95b3f40486b9a4148f89ffd"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.2"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "49510dfcb407e572524ba94aeae2fced1f3feb0f"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.8"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "94d9c52ca447e23eac0c0f074effbcd38830deb5"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.18"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MIMEs]]
git-tree-sha1 = "65f28ad4b594aebe22157d6fac869786a255b7eb"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "0.1.4"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.0+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.2.1"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.20+0"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"
version = "0.8.1+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "cceb0257b662528ecdf0b4b4302eb00e767b38e7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.8.0"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "56baf69781fc5e61607c3e46227ab17f7040ffa2"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.19"

[[deps.PlutoDevMacros]]
deps = ["HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Random", "Requires"]
git-tree-sha1 = "b4b23b981704ac3e2c771a389c2899e69306c091"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.4.8"

[[deps.PlutoPlotly]]
deps = ["AbstractPlutoDingetjes", "Colors", "Dates", "HypertextLiteral", "InteractiveUtils", "LaTeXStrings", "Markdown", "PlotlyBase", "PlutoUI", "Reexport"]
git-tree-sha1 = "dec81dcd52748ffc59ce3582e709414ff78d947f"
uuid = "8e989ff0-3d88-8e9f-f020-2b208a939ff0"
version = "0.3.6"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "efc140104e6d0ae3e7e30d56c98c4a927154d684"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.48"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "47e5f437cc0e7ef2ce8406ce1e7e24d44915f88d"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.3.0"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SnoopPrecompile]]
git-tree-sha1 = "f604441450a3c0569830946e5b33b78c928e1a85"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.1"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "d75bda01f8c31ebb72df80a46c88b25d1c79c56d"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.7"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.1"

[[deps.TensorCore]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "1feb45f88d133a655e001435632f019a9a1bcdb6"
uuid = "62fd8b95-f654-4bbd-a8a5-9c27f68ccd50"
version = "0.1.1"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.12+3"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.1.1+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─ecd45d5d-40c7-4ebe-b541-4bffa3b7abd5
# ╠═6efb9ff0-52e7-11ec-2a4d-b788e3955703
# ╠═8179a3c3-dda2-47c2-9efc-014cce2d0c75
# ╠═7cdb1e47-b06b-4cff-ab7e-b9451d261487
# ╟─278449d8-b67d-4ca9-9910-e19836e42a93
# ╠═f88ad8a5-8875-41b8-9680-8de93c27948d
# ╠═48414943-3a16-4826-8098-19089ed00646
# ╠═90b11594-8b04-41c6-9a53-b1de98f71de2
# ╟─44430200-a8c4-4055-ba41-b54ab1b0d945
# ╠═79b4d547-6d63-459d-9955-7f170320b9e6
# ╠═a5f583c2-ffd5-42bd-9b40-798ce2178d2f
# ╟─0b14e883-7548-4f65-a789-3cde165cc240
# ╠═564f1605-72cf-460a-9b8a-00277b12be8b
# ╠═7eea8ae9-8d6c-448c-841d-dc9639244fb5
# ╠═b6602853-a52d-462f-81f2-b7330dc6033f
# ╟─ab41cb62-44b9-4994-90ef-a9ed329c9394
# ╠═fd7a4077-4c39-4a5a-9e8f-de421ab06090
# ╠═33e72f37-4e78-4131-9df0-d4fbb04c8e8c
# ╟─722ec88a-5be7-47b3-9c4c-df0062049c05
# ╠═c7585964-0f80-48bf-b2c5-66f3077422ab
# ╠═758f4fa3-1b01-4748-992e-6486cba4c905
# ╠═73a3a65c-20dc-4855-800b-057c930e2e4b
# ╟─36984080-2ef7-43fe-af3a-3d57902b5e25
# ╠═dbea9296-2d91-49ea-bf7d-67d965e9a56a
# ╠═4645b816-e4e0-426f-879e-ef5d9f7dc32d
# ╠═8931cdeb-e397-42fb-a57f-c5b8c03c2bb9
# ╠═b5bcc803-e8f6-4bd6-ac6e-8d7c6ee38e68
# ╠═085a5a7b-e4e0-4dd0-af86-09c9d67c3e20
# ╠═d9cc094b-8453-4e74-9420-ec9c3be7f585
# ╠═b7b34f12-5930-4b6e-8a62-51b6b2b995ad
# ╠═e9b706a0-276f-4f0e-8614-7cb4060457ea
# ╟─d4549cda-cd11-4c7d-9411-7ab0c56f9d2a
# ╟─70c17b71-57d8-4742-a07b-4c3ce9986fff
# ╠═2929793e-3f0e-4812-a0a6-1b12ddd92bae
# ╟─dc2e6674-0de1-4a39-abaa-9d2aea3a2838
# ╠═b245f253-f7ec-452c-84ae-e7e6c05842a4
# ╟─9dc75181-4ef3-4063-acbe-2f1e8319b8c3
# ╠═66944c66-ead7-4d62-9d09-7083cb79f7c2
# ╟─289a2e4f-6978-4549-8cf3-83ac2a6a1fee
# ╠═92b34600-a1d7-40b6-affa-722114310163
# ╟─4efe496a-6cc7-49c4-9da5-96cc24db648e
# ╟─df3a50e3-21c4-4082-af97-0fee3ad8018d
# ╟─02391183-03d5-421a-9f92-126aeebebff4
# ╠═198fd46e-7c64-43f4-88fe-b5ab3374ff64
# ╟─4f3f4e06-697b-4ec3-870e-4ea6571a49a6
# ╠═47c5f812-3b4e-4cbf-b5b1-3b6a5934c40b
# ╟─ecf63517-bd05-498c-a5af-7acbac541e2e
# ╟─03cb82c0-d4b6-42c8-b3ff-bc85a9560014
# ╠═9d67b79a-6526-43c0-8265-826b8270d0d5
# ╟─35d91b10-3dff-4287-90aa-08cb1da205e5
# ╠═994fa807-b909-443c-a2c2-055c7c75f908
# ╠═faa406f4-5fe6-488a-a2a3-d8d081d4bc71
# ╠═57e67483-5d2a-431c-9e45-4f9eb731e057
# ╠═8257d42c-b5d4-4e39-b432-5b7757c5fb4f
# ╠═c1bb63e3-36c7-4f26-8227-1166408d818c
# ╠═f4cd1732-7a02-4d36-b145-bae202eed90c
# ╟─992ce6fa-385a-4797-a6f3-ad3c3715f927
# ╠═f27fb377-57d6-47b9-9d78-2b484ce69edb
# ╠═dc78334d-21fb-4b17-a946-f93f4f99f8cb
# ╟─531be33a-eef4-4a5a-b72f-2fcf64cfc4bf
# ╠═48045f65-88a4-4b9f-aaeb-fe24fe2e6925
# ╟─685e1202-a553-4fcd-ae9d-152b92aede9f
# ╟─1defc7ea-501c-40a2-b311-c2d171a09401
# ╠═44cc8f3b-d633-47d4-b39b-7ea299ffe281
# ╟─c74801ab-de4e-4748-aec8-339d56789506
# ╟─ce661fec-c1b5-4150-b863-c42e47defd0a
# ╠═72841851-4303-4b33-842b-d6812737023e
# ╟─ad60610b-aebb-454a-9e33-bb8affb0d484
# ╠═4ee12b02-a0bb-4216-a9cf-92bcb89e664f
# ╟─f9dc72b6-d9d1-4777-94fe-942e9b1a2635
# ╠═3f8250d6-ef3b-4634-ba99-91c6dd1cbd22
# ╟─832eed66-c4a9-4783-b9ef-a48b472a349b
# ╠═ea30c6b9-d55a-4257-8344-347d5060c0c8
# ╠═957927ab-0c60-4557-b550-23b14546fa6a
# ╟─5a5bf586-8987-49b7-af82-1fc7ae7d8c33
# ╠═420d8430-b5bd-485e-b164-a1fecebc4700
# ╟─5e5b7c87-4f0b-4826-b25c-b71028c9ec90
# ╠═295d3811-a102-4c62-9ea1-7fd1b04a36f2
# ╠═3eab3e1c-d2f7-4141-ad57-d021f24c9db5
# ╠═eb80cbe8-dbcc-4a45-90b3-d00b33552bae
# ╠═1fdca475-77d9-4f0f-9972-695eac5bc9da
# ╠═19758fbf-425d-4836-8522-9618820651ce
# ╠═e04df756-5202-46f3-a013-c2ba20b8005a
# ╠═f6d39c5e-4458-44ab-a8b2-ee74e921963d
# ╠═7bce22ad-2de0-4d34-a660-0a3c059d9857
# ╠═32cac62a-66cb-467d-90ee-3c5c3dd4e9a2
# ╠═0596419d-d9cc-47e1-9ef3-77b0a48b50a5
# ╟─c0105f4e-632e-405a-b59d-25eaf17767ef
# ╠═d86e08a9-5efb-4c97-bd59-946b82f0f5fb
# ╠═ecf49c6a-fe57-41e0-9e6f-63c7e5176861
# ╠═ac5e41e2-89c7-4045-9275-7cebe6b6dd92
# ╠═b1f64f22-da01-45c0-a2f8-48cb6673d473
# ╠═d53dbcb4-82f6-43c4-9859-eb233dbbf585
# ╠═025a54a9-511e-4781-b640-c76f5c43ee79
# ╠═1c958b8a-ec45-41da-a200-5b5a712165cc
# ╠═fa1b5db7-5d3b-4e9b-bd08-8e11c1e84305
# ╠═2471400c-bc46-498d-b6d8-64adbd8a8b7a
# ╠═81d7fd40-255a-4116-a7fa-019a735374d6
# ╠═264e720b-db52-40cd-be6b-53004fa0ef10
# ╠═154b2bfb-2d0e-47f6-8623-1d1b66df6e8a
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
