using HypertextLiteral
using PlutoUI
using ..PlutoCombineHTL.WithTypes

# Exports #
export ExtendedTableOfContents, show_output_when_hidden

# Script Parts #

#= Smooth Scroll
Since v0.7.51 PlutoUI directly supports the smooth scrolling library in the
TableOfContents, so we just take it from there.
=#

_smooth_scroll = PlutoScript(
    """
    // Load the library for consistent smooth scrolling
    const {default: scrollIntoView} = await import('$(PlutoUI.TableOfContentsNotebook.smooth_scoll_lib_url)')

    function scroll_to(h, config = {
    			behavior: 'smooth', 
    			block: 'start',
    		}) {
    	scrollIntoView(h, config).then(() => 
    			// sometimes it doesn't scroll to the right place
    			// solution: try a second time!
    			scrollIntoView(h, config)
    	   )
    	}
    """
)

## Script - Basic ##
_basics = PlutoScript(
    """
    	let cell = currentScript.closest('pluto-cell')
    	let pluto_actions = cell._internal_pluto_actions
    	let toc = document.querySelector('nav.plutoui-toc')

    	function getRow(el) {
    		const row = el?.closest('.toc-row')
    		return row
    	}
    		
    	function get_link_id(el) {
    		const row = getRow(el)
    		if (_.isNil(row)) { return null }
    		const a = row.querySelector('a')
    		return a.href.slice(-36) // extract the last 36 characters, corresponding to the cell id
    	}

    	function getHeadingLevel(row) {
    		const a = row.querySelector('a')
    		// We return the link class without the first H
    		return Number(a.classList[0].slice(1))
    	}

    	function generateChecker(selector) {
    		switch (typeof selector) {
    			case 'string':
    				const func = el => {
    					return el.matches(selector)
    				}
    				return func
    			case 'function':
    				return selector
    			default:
    				console.error(`The type (\${typeof selector}) of the provided argument is not valid`)
    		}
    	}

    	// Get next and previous sibling, adapted from:
    	// https://gomakethings.com/finding-the-next-and-previous-sibling-elements-that-match-a-selector-with-vanilla-js/
    	var getNextSibling = function (elem, selector) {

    		// Added to return undefined is called with undefined
    		if (_.isNil(elem)) {return undefined}

    		// Get the next sibling element
    		var sibling = elem.nextElementSibling;
    	
    		// If there's no selector, return the first sibling
    		if (!selector) return sibling;

    		const checker = generateChecker(selector)
    	
    		// If the sibling matches our selector, use it
    		// If not, jump to the next sibling and continue the loop
    		while (sibling) {
    			if (checker(sibling)) return sibling;
    			sibling = sibling.nextElementSibling
    		}
    	
    	};
    	var getPreviousSibling = function (elem, selector) {

    		// Added to return undefined is called with undefined
    		if (_.isNil(elem)) {return undefined}
    		
    		// Get the next sibling element
    		var sibling = elem.previousElementSibling;
    	
    		// If there's no selector, return the first sibling
    		if (!selector) return sibling;

    		const checker = generateChecker(selector)
    	
    		// If the sibling matches our selector, use it
    		// If not, jump to the next sibling and continue the loop
    		while (sibling) {
    			if (checker(sibling)) return sibling;
    			sibling = sibling.previousElementSibling;
    		}
    	
    	};


    	// Get the last toc entry descendant from the provided one
    	function getLastDescendant(el) {
    		const row = getRow(el)
    		if (_.isNil(row)) {return}
    		const children = row.directChildren
    		if (_.isEmpty(children)) {
    			return row
    		} else {
    			return getLastDescendant(_.last(children))
    		}
    	}

    	// Find all the cell ids contained within the target toc rows and all its descendants
    	function getBlockIds(el) {
    		const row = getRow(el)
    		if (_.isNil(row)) {return}
    		function getIndex(row) {
    			return editor_state.notebook.cell_order.indexOf(get_link_id(row))
    		}
    		const start = getIndex(row)

    		const lastChild = getLastDescendant(row)
    		const end = getIndex(getNextSibling(lastChild, '.toc-row'))

    		return editor_state.notebook.cell_order.slice(start, end < 0 ? Infinity : end)
    	}
    		
    	window.toc_utils = {
    		getNextSibling,
    		getPreviousSibling,
    		getLastDescendant,
    		getBlockIds,
    	}

    	// Functions to set and propagate hidden and collapsed states

    	function propagate_parent(div, parent=null) {
    		if (parent != null) {
    			div.allParents = _.union(div.allParents, [parent])	
    		}
    		if (_.isEmpty(div.directChildren)) {return}
    		for (const child of div.directChildren) {
    			propagate_parent(child, parent ?? div)
    		}
    	}

    	// Returns true if the current hidden/collapsed toc state is different from the one saved in the file within cell metadata
    	function stateDiffersFile(state) {
    		for (const [id, st] of _.entries(state)) {
    			if (has_cell_attribute(id, 'toc-hidden') != st.hidden) { return true }
    			if (has_cell_attribute(id, 'toc-collapsed') != st.collapsed) { return true }
    		}
    		return false
    	}

    	function set_state(div, state, value, init = false) {
    		div.classList.toggle(state, value)
    		if (!init) {
    			window.toc_state[get_link_id(div)][state] = value
    			toc.classList.toggle('file-state-differs', stateDiffersFile(window.toc_state))
    		}
    		if (_.isEmpty(div.directChildren)) {return}
    		for (const child of div.directChildren) {
    			propagate_state(child, state)
    		}
    	}
    	function propagate_state(div, state) {
    		let new_state = `parent-\${state}`
    		div.classList.toggle(new_state, false)
    		// Check the parents for the state
    		for (const parent of div.allParents) {
    			if (parent.classList.contains(state)) {
    				div.classList.toggle(new_state, true)
    				break
    			}
    		}
    		if (_.isEmpty(div.directChildren)) {return}
    		for (const child of div.directChildren) {
    			propagate_state(child, state)
    		}
    	}
    """
)

## Script - Floating UI ##
_floating_ui = PlutoScript(
    """
    	const floating_ui = await import('https://esm.sh/@floating-ui/dom')
    	// window.floating_ui = floating_ui
    """
)

## Script - Modify Cell Attributes ##
_modify_cell_attributes = PlutoScript(
    """
    	function has_cell_attribute(cell_id, attr) {
    		const md = editor_state.notebook.cell_inputs[cell_id].metadata
    		return _.includes(md["custom_attrs"], attr)
    	}
    	
    	function add_cell_attributes(cell_id, attrs) {
    		pluto_actions.update_notebook((notebook) => {
    			let md = notebook.cell_inputs[cell_id].metadata
    			md["custom_attrs"] = _.union(md["custom_attrs"], attrs)
    		})
    		let cell = document.getElementById(cell_id)
    		for (let attr of attrs) {
    			cell.toggleAttribute(attr, true)
    		}
    	}

    	function remove_cell_attributes(cell_id, attrs) {
    		pluto_actions.update_notebook((notebook) => {
    			let md = notebook.cell_inputs[cell_id].metadata
    			let after = _.difference(md["custom_attrs"], attrs)
    			if (_.isEmpty(after)) {
    				delete md["custom_attrs"]
    			} else {
    				md["custom_attrs"] = after
    			}
    		})
    		let cell = document.getElementById(cell_id)
    		for (let attr of attrs) {
    			cell.toggleAttribute(attr, false)
    		}
    	}

    	function toggle_cell_attribute(cell_id, attr, force='toggle') {
    		pluto_actions.update_notebook((notebook) => {
    			let md = notebook.cell_inputs[cell_id].metadata
    			let f = force == 'toggle' ? _.xor : force ? _.union : _.difference
    			let after = f(md["custom_attrs"], [attr])
    			if (_.isEmpty(after)) {
    				delete md["custom_attrs"]
    			} else {
    				md["custom_attrs"] = after
    			}
    		})
    		let cell = document.getElementById(cell_id)
    		force == 'toggle' ? cell.toggleAttribute(attr) : cell.toggleAttribute(attr, force)
    	}
    """
)

## Script - Modify Notebook Attributes ##
_modify_notebook_attributes = PlutoScript(
    """
    	function add_notebook_attributes(attrs) {
    		pluto_actions.update_notebook((notebook) => {
    			let md = notebook.metadata
    			md["custom_attrs"] = _.union(md["custom_attrs"], attrs)
    		})
    		let notebook = document.querySelector('pluto-notebook')
    		for (let attr of attrs) {
    			notebook.toggleAttribute(attr, true)
    		}
    	}

    	function remove_notebook_attributes(attrs) {
    		pluto_actions.update_notebook((notebook) => {
    			let md = notebook.metadata
    			let after = _.difference(md["custom_attrs"], attrs)
    			if (_.isEmpty(after)) {
    				delete md["custom_attrs"]
    			} else {
    				md["custom_attrs"] = after
    			}
    		})
    		let notebook = document.querySelector('pluto-notebook')
    		for (let attr of attrs) {
    			notebook.toggleAttribute(attr, false)
    		}
    	}

    	function toggle_notebook_attribute(attr, force='toggle') {
    		pluto_actions.update_notebook((notebook) => {
    			let md = notebook.metadata
    			let f = force == 'toggle' ? _.xor : force ? _.union : _.difference
    			let after = f(md["custom_attrs"], [attr])
    			if (_.isEmpty(after)) {
    				delete md["custom_attrs"]
    			} else {
    				md["custom_attrs"] = after
    			}
    		})
    		let notebook = document.querySelector('pluto-notebook')
    		force == 'toggle' ? notebook.toggleAttribute(attr) : notebook.toggleAttribute(attr, force)
    	}

    	if (force_hide_enabled) {
    	 	toggle_notebook_attribute('hide-enabled',true)
    	}
    """
)

## Script - Hide Cell Blocks ##
_hide_cell_blocks = PlutoScript(
    """
    	// For each from and to, we have to specify `pluto-cell[id]` in the part before the comm and just `[id]` in the part after the comma to ensure the specificity of the two comma-separated selectors is the same (the part after the comma has the addition of `~ pluto-cell`, so it has inherently +1 element specificity)
    	function hide_from_to_string(from_id, to_id) {
    		if (_.isEmpty(from_id) && _.isEmpty(to_id)) {return ''}
    		
    		const from_preselector = _.isEmpty(from_id) ? '' : `pluto-cell[id='\${from_id}'], pluto-notebook[hide-enabled] [id='\${from_id}'] ~ `
    		const to_style = _.isEmpty(to_id) ? '' : `pluto-notebook[hide-enabled] pluto-cell[id='\${to_id}'], pluto-notebook[hide-enabled] [id='\${to_id}'] ~ pluto-cell {
    		display: block;
    	}
    	 `
    		const style_string = 	`pluto-notebook[hide-enabled] \${from_preselector}pluto-cell {
    		display: none;
    	}
    	\${to_style}
     `
    		return style_string
    		//return html`<style>\${style_string}</style>`
    	}

    	function hide_from_to_list_string(vector) {
    		let out = ``
    		for (const lims of vector) {
    			const from = lims[0]
    			const to = lims[1]
    			
    			out = `\${out}\t\${hide_from_to_string(from,to)}`
    		}
    		out = `\${out}\tpluto-cell[always-show] {
      			display: block !important;
      		}
      `
    		return out
    	}
    	function hide_from_to_list(vector) {
    		const str = hide_from_to_list_string(vector)
    		return html`<style>\${str}</style>`
    	}
    	function hide_list_style(vector) {
    		let style = document.getElementById('hide-cells-style')
    		if (style == null) {
      			style = document.head.appendChild(html`<style id='hide-cells-style'></style>`)
    		}
    		style.innerHTML = hide_from_to_list_string(vector)
    	}
    """
)

## Script - Mutation Observer ##
_mutation_observer = PlutoScript(
    body = """
    	function toggle_state(name) {
    		return (e) => {
    			e.preventDefault()
    			e.stopPropagation()
    			let div = e.target.closest('div')
    			const new_val = !div.classList.contains(name)
    			set_state(div, name, new_val)
    		}
    	}

    	function update_hidden(e) {
    		let new_hide = []
    		if (hide_preamble) {
    			new_hide.push(['', get_link_id(toc.querySelector('div.toc-row'))])
    		}
    		let tracking_hidden = null
    		let divs = toc.querySelectorAll('div.toc-row')
    		for (const div of divs) {
    			if (tracking_hidden != null) {
    				const hidden = div.classList.contains('hidden') || div.classList.contains('parent-hidden')
    				if (!hidden) {
    					new_hide.push([tracking_hidden, get_link_id(div)])	
    					tracking_hidden = null
    				}
    			} else {
    				const hidden = div.classList.contains('hidden')
    				if (hidden) {
    					tracking_hidden = get_link_id(div)
    				}
    			}
    		}
    		if (tracking_hidden != null) {
    				new_hide.push([tracking_hidden, ""])	
    		}
    		hide_list_style(new_hide)
    	}

    	// Reposition the hide_container using the floating-ui library
    	function repositionTooltip(e) {
    		const { computePosition } = floating_ui
    		const ref = e.target
    		const tooltip = ref.querySelector('.toc-hide-container')
    		if (_.isNil(tooltip)) {
    			console.warn("Something went wrong, no tooltip found")
    			return
    		}
    		computePosition(ref, tooltip, {
    			placement: "left",
    			strategy: "fixed",
    		}).then(pos => {
    			tooltip.style.top = pos.y + "px"
    		})
    	}
    	
    	function process_row(div, history, old_state, new_state) {

    		// We add the separator
    		div.insertAdjacentElement('beforebegin', html`<div class='toc-row-separator'></div>`)
    		// If we are just processing the first element (so the last row) we also add a separator at the bottom
    		if (_.isEmpty(new_state) && _.every(history, _.isEmpty)) {
    			div.insertAdjacentElement('afterend', html`<div class='toc-row-separator'></div>`)
    		}

    		// We add the reposition event to the row
    		div.addEventListener('mouseenter', repositionTooltip)
    		
    		let id = get_link_id(div)
    		const a = div.querySelector('a')
    		let old_f = a.onclick;
    		a.onclick = (e) => {
    			e.preventDefault()
    			// We avoid triggering the click if coming out of a drag
    			if (toc.classList.contains('recent-drag')) { return }
    			old_f(e)
    		}			
    		const level = getHeadingLevel(div)
    		if (level > 1) {
    			history[level].unshift(div)
    		}
    		// We iterate through the history and assign the direct children if they exist, while clearing lower levels history
    		for (let i = 6; i > level; i--) {
    			if (_.isEmpty(history[i])) {continue}
    			if (div.directChildren != undefined) {throw('multiple level with children, unexpected!')}
    			div.directChildren = history[i]
    			history[i] = [] // empty array
    		}
    		const collapse_span = a.insertAdjacentElement('afterbegin', html`<span class='toc-icon toc-collapse'>`)
    		let hide_style = `--height: \${a.clientHeight}px`
    		const hide_container = div.insertAdjacentElement('afterbegin', html`<span class='toc-hide-container' style='\${hide_style}'>`)
    		const hide_span = hide_container.insertAdjacentElement('afterbegin', html`<span class='toc-icon toc-hide'>`)
    		hide_span.addEventListener('click', (e) => {
    			toggle_state('hidden')(e)
    			update_hidden(e)
    		})
    		if (div.directChildren == undefined) {
    			collapse_span.classList.toggle('no-children', true)
    		} else {
    			propagate_parent(div)
    			collapse_span.addEventListener('click', toggle_state('collapsed'))
    		}
    		let md = editor_state.notebook.cell_inputs[id].metadata
    		let collapsed = old_state[id]?.collapsed ??  _.includes(md['custom_attrs'], 'toc-collapsed')
    		let hidden = old_state[id]?.hidden ?? _.includes(md['custom_attrs'], 'toc-hidden')
    		set_state(div, 'collapsed', collapsed, true)
    		set_state(div, 'hidden', hidden, true)
    		new_state[id] = { collapsed, hidden }
    		
    	}

    	const observer = new MutationObserver(() => {
    		const rows = toc.querySelectorAll('section div.toc-row')
    		let old_state = window.toc_state ?? {}
    		let new_state = {}
    		let history = {
    			2: [],
    			3: [],
    			4: [],
    			5: [],
    			6: [],
    		}
    		for (const row of [...rows].reverse()) {
    			process_row(row, history, old_state, new_state)
    		}
    		window.toc_state = new_state
    		toc.classList.toggle('file-state-differs', stateDiffersFile(new_state))
    		update_hidden()
    	})

    	observer.observe(toc, {childList: true})
    """,
    invalidation = "observer.disconnect()"
)

## Script - Move Entries Handler ##
_move_entries_handler = PlutoScript(;
    body = """
    	const { default: interact } = await import('https://esm.sh/interactjs')

    	// We have to enable dynamicDrop to have dropzone recomputed on dragmove
    	interact.dynamicDrop(true)

    	function dragEnabler(e) {
    		if (!toc.classList.contains('drag_enabled') || e.key !== 'Shift') { return true }
    		switch (e.type) {
    			case "keydown":
    				toc.classList.add('allow_all_drop')
    				break;
    			case "keyup":
    				toc.classList.remove('allow_all_drop')
    				break;
    		}
    		updateActiveSeparator()
    	}

    	const window_events = {
    		keydown: dragEnabler,
    		keyup: dragEnabler,
    	}

    	addScriptEventListeners(window, window_events)

    	// Interact.js part

    	let activeDrop = undefined

    	function tagAdjacentSeparators(el, active) {
    		const next = getNextSibling(el, '.toc-row-separator')
    		const prev = getPreviousSibling(el, '.toc-row-separator')
    		if (active) {
      			next?.classList.add('noshow')
      			prev?.classList.add('noshow')
    		} else {
      			next?.classList.remove('noshow')
      			prev?.classList.remove('noshow')				
    		}
    	}

    	function getSeparator(startElement, below, allowAll, headingLevel = 8) {
    		let separator
    		if (below) {
    			const selector = '.toc-row:not(.parent-collapsed)'
    			const checkerFunc = allowAll ? generateChecker(selector) : (el) => {
    				if (!el.matches(selector)) { return false }
    				// Check for the right heading level
    				for (let i = headingLevel; i > 0; i--) {
    					const cl = "H" + i
    					if (el.classList.contains(cl)) { return true }
    				}
    				return false
    			}
    			const validRow = getNextSibling(startElement, checkerFunc)
    			// If the activeDrop is the last row or the the last non-collapsed one, the validRow will be `undefined`, so in that case we take the last separator
    			separator = getPreviousSibling(validRow, '.toc-row-separator') ?? _.last(toc.querySelectorAll('.toc-row-separator'))
    		} else {
    			separator = getPreviousSibling(startElement, '.toc-row-separator')
    		}
    		return separator
    	}

    	function getHigherParent(row, level) {
    		const currentLevel = getHeadingLevel(row)
    		if (currentLevel <= level) {return row}
    		for (const par of row.allParents) {
    			// Parents cycle from higher level to lower levels
    			if (getHeadingLevel(par) <= level) {return par}
    		}
    		return row
    	}
    		
    	let uncollapsed = []

    	function reCollapse(row) {
    		const parents = row?.allParents ?? []
    		const toRemove = _.difference(uncollapsed, [...parents, row])
    		for (const el of toRemove) {
    			// debugger
    			set_state(el, "collapsed", true)
    			_.remove(uncollapsed, x => x === el)
    		}
    	}


    	function updateDropZone(row) {
    		const prev = toc.querySelector('.toc-row.active_drop')
    		if (_.isNil(row) || prev === row) {return}
    		if (prev?.timeoutId) {
    			clearTimeout(prev.timeoutId)
    			prev.timeoutId = undefined
    		}
    		prev?.classList.remove('active_drop')
    		row.classList.add('active_drop')
    		reCollapse(row)
    		if (row.classList.contains('collapsed')) {
    			row.timeoutId = setTimeout(() => {
    				uncollapsed.push(row)
    				set_state(row, "collapsed", false)
    				updateActiveSeparator()
    			}, 500)
    		}
    		activeDrop = row
    	}

    	function updateActiveSeparator() {
    		const e = toc.lastDragEvent
    		if (_.isNil(e)) { return }
    		const elBelow = document.elementFromPoint(e.client.x, e.client.y)
    		if (!elBelow.matches('.plutoui-toc :scope')) {
    			// We are out of the ToC, recollapse and remove active separator
    			reCollapse(undefined)
    			toc.querySelector('.toc-row-separator.active')?.classList.remove('active')
    			return
    		}
    		const rowBelow = getRow(elBelow)
    		updateDropZone(rowBelow)
    		if (_.isNil(activeDrop)) {return}
    		const allowAll = toc.classList.contains('allow_all_drop')
    		const headingLevel = getHeadingLevel(toc.draggedElement)
    		const { y, height } = activeDrop.getBoundingClientRect()
    		let thresholdY = y + height/2
    		if (!allowAll) {
    			// We only allow putting the dragged element above/below rows with equal or higher heading level
    			const currentHeadingLevel = getHeadingLevel(activeDrop)
    			if (currentHeadingLevel > headingLevel) {
    				// We update the threshold based on the relevant parent
    				const par = getHigherParent(activeDrop, headingLevel)
    				const { y, height } = par.getBoundingClientRect()
    				thresholdY = y + height/2						
    			}
    		}
    		// Check if the current position of the mouse is below or above the middle of the active drop zone
    		const isBelow = e.client.y > thresholdY
    		const newSep = getSeparator(activeDrop, isBelow, allowAll, headingLevel)
    		const currentSep = toc.querySelector('.toc-row-separator.active') ?? newSep
    		if (currentSep !== newSep) {
    			currentSep.classList.remove('active')
    		}
    		newSep.classList.add('active')
    	}

    	const dragHandles = interact('.toc-row').draggable({
    		cursorChecker (action, interactable, element, interacting) {
    			// console.log({action, interactable, element, interacting})
    			return null
    		},
    		manualStart: true, // needed for consistent start after hold
    		listeners: {
    			start: function (e) {
    				toc.classList.add('drag_enabled')
    				const row = e.target
    				// console.log('start: ', e)
    				toc.lastDragEvent = e
    				row.classList.add('dragged')
    				toc.draggedElement = row
    				tagAdjacentSeparators(row, true)
    			},
    			move: function (e) {
    				toc.lastDragEvent = e
    				updateActiveSeparator()
    			},
    			// move: function (e) {console.log('move: ',e)},
    			end: function (e) {
    				activeDrop = undefined
    				e.preventDefault()
    				toc.lastDragEvent = e
    				// console.log('end: ', e)
    				const row = e.target
    				// Cleanup
    				row.classList.remove('dragged')
    				toc.classList.remove('drag_enabled')	
    				for (const el of toc.querySelectorAll('.active_drop')) {
    					el.classList.remove('active_drop')
    				}
    				reCollapse()				
    				tagAdjacentSeparators(row, false)				
    				toc.classList.remove('allow_all_drop')
    				// We temporary set the recentDrag flag
    				toc.classList.add('recent-drag')
    				setTimeout(() => {
    					toc.classList.remove('recent-drag')
    				}, 300)
    				// Check if there is an active dropzone
    				const dropZone = toc.querySelector('.toc-row-separator.active')
    				if (_.isNil(dropZone) || dropZone.classList.contains('noshow')) {return}
    				dropZone.classList.remove('active')
    				// We find the cell after the active separator and move the dragged row before that
    				const rowAfter = getNextSibling(dropZone)
    				const cellIdsToMove = getBlockIds(row)
    				// Find the index of the cell that will stay after our moved block
    				const end = editor_state.notebook.cell_order.indexOf(get_link_id(rowAfter))
    				// If we got -1, it means we have to put the cells at the end
    				pluto_actions.move_remote_cells(cellIdsToMove, end < 0 ? Infinity : end)
    				toc.draggedElement = undefined		
    			},
    		}
    	}).on('hold',function (e) {
    		if (document.body.classList.contains('disable_ui')) { console.log('UI disabled, no interaction!'); return }
    		e.preventDefault()
    		e.stopImmediatePropagation()
    		e.stopPropagation()
    		// console.log('this is hold', e)
    		var interaction = e.interaction

    	    if (!interaction.interacting()) {
    	      interaction.start(
    	        { name: 'drag' },
    	        e.interactable,
    	        e.currentTarget,
    	      )
    	    }
    	})
    """,
    invalidation = """
    dragHandles.unset()
    """
)

## Script - Header Manipulation ##
_header_manipulation = PlutoScript(;
    body = """
    	const header = toc.querySelector('header')
    	const header_container = header.insertAdjacentElement('afterbegin', html`<span class='toc-header-container'>`)
    	
    	
    	const notebook_hide_icon = header_container.insertAdjacentElement('beforeend', html`<span class='toc-header-icon toc-header-hide'>`)
    	
    	const save_file_icon = header_container.insertAdjacentElement('beforeend', html`<span class='toc-header-icon toc-header-save'>`)
    	save_file_icon.addEventListener('click', save_to_file)

    	header_container.insertAdjacentElement('beforeend', html`<span class='toc-header-filler'>`)
    	
    	header.addEventListener('click', e => {
    		if (e.target != header) {return}
    		scroll_to(cell, {block: 'center', behavior: 'smooth'})
    	})

    	header.addEventListener('mouseenter', (e) => {
    		floating_ui.computePosition(header, header_container, {
    			placement: "left",
    			strategy: "fixed",
    		}).then(pos => {
    			header_container.style.top = pos.y + "px"
    			// header_container.style.left = pos.x + "px"
    			// header_container.style.right = `calc(1rem + min(80vw, 300px))`
    		})
    	})

    	notebook_hide_icon.addEventListener('click', (e) => {
    			// We find the x coordinate of the pluto-notebook element, to avoid missing the cell when UI is disabled
    			const { x } = document.querySelector('pluto-notebook').getBoundingClientRect()
    			const ref = document.elementFromPoint(x+1,100).closest('pluto-cell')
    			const { y } = ref.getBoundingClientRect()
    			toggle_notebook_attribute('hide-enabled')
    			const dy = ref.getBoundingClientRect().y - y
    			window.scrollBy(0, dy)
    	})
    """
)

## Script - Save to File ##
_save_to_file = PlutoScript(
    """
    	function save_to_file() {
    		const state = window.toc_state
    		for (const [k,v] of Object.entries(state)) {
    			toggle_cell_attribute(k, 'toc-hidden', v.hidden)	
    			toggle_cell_attribute(k, 'toc-collapsed', v.collapsed)	
    		}
    		setTimeout(() => {
    			toc.classList.toggle('file-state-differs', stateDiffersFile(state))
    		}, 500)
    	}
    """
)

# Style #
## Style - Header ##
_header_style = @htl(
    """
    <style>	
    	.plutoui-toc header {
    		cursor: pointer;
    	}
    	span.toc-header-container {
    		position: fixed;
    		display: none;
    		--size: 25px;
    		height: calc(51px - 1rem);
    		flex-direction: row-reverse;
    		right: calc(1rem + min(80vh, 300px));
    	}
    	.toc-header-icon {
    		margin-right: 0.3rem;
    		align-self: stretch;
    		display: inline-block;
    		width: var(--size);
    		background-size: var(--size) var(--size);
    	    background-repeat: no-repeat;
    	    background-position: center;
    		filter: var(--image-filters);
    		cursor: pointer;
    	}
    	.toc-header-filler {
    		margin: .25rem;
    	}
    	header:hover span.toc-header-container,
    	span.toc-header-container:hover {
    		display: flex;
    	}
    	.toc-header-hide {
    		background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/eye-outline.svg);
    		opacity: 50%;
    		--size: 1em;
    	}
    	.toc-header-save {
    		background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/save-outline.svg);
    		opacity: 50%;
    	}
    	nav:not(.file-state-differs) .toc-header-save {
    		display: none;
    	}
    	pluto-notebook[hide-enabled] span.toc-header-hide {
    		background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/eye-off-outline.svg);
    	}
    </style>
    """
)

## Style - Toc Row ##
_toc_row_style = @htl(
    """
    <style>
    	span.toc-hide-container {
    		--width: min(80vw, 300px);
    		position: fixed;
    		display: flex;
    		right: calc(var(--width) + 1rem + 22px - 100px);
    		height: var(--height);
    		width: 100px;
    		z-index: -1;
    	}
    	span.toc-hide {
    		visibility: hidden;
    		opacity: 50%;
    		background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/eye-outline.svg);
    		cursor: pointer;
    	}
    	div.toc-row.hidden span.toc-hide {
    		background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/eye-off-outline.svg);
    	}
    	span.toc-hide-container:hover > .toc-hide,
    	div.toc-row:hover .toc-hide {
    		visibility: visible;
    	}
    	div.toc-row a {
    		display: flex;
    	}
    	span.toc-icon {
    		--size: 17px;
    		display: block;
    		align-self: stretch;
    		background-size: var(--size) var(--size);
    	    background-repeat: no-repeat;
    	    background-position: center;
    		width: var(--size);
    		filter: var(--image-filters);
    	}
    	span.toc-collapse {
    		background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down.svg);
    		margin-right: 3px;
    		min-width: var(--size);
    	}
    	.plutoui-toc section div.toc-row.collapsed span.toc-collapse {
    		background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-forward.svg);
    	}
    	.plutoui-toc section div.toc-row a span.toc-collapse.no-children {
    		background-image: none;
    	}
    	div.toc-row.parent-hidden {
    		text-decoration: underline dotted .5px;
    		text-underline-offset: 2px;
    	}
    	div.toc-row.hidden {
    		text-decoration: underline dashed 1px;
    		text-underline-offset: 2px;
    	}
    	.plutoui-toc div.parent-collapsed {
    		display: none;
    	}
    	pluto-notebook[hide-enabled] div.toc-row.hidden,
    	pluto-notebook[hide-enabled] div.toc-row.parent-hidden {
    		display: none;
    	}
    	.drag_enabled .toc-row.dragged {
    		border: 2px dashed grey;
    	}
    </style>
    """
)

## Style - Row Separator ##
_row_separator_style = @htl(
    """
    <style>
    	div.toc-row-separator {
    		height: 2px;
    		margin: 3px 0px;
    		background: #aaa;
    		display: none;
    	}
    	div.toc-row-separator.active {
    		display: block;
    	}
    	div.toc-row-separator.active.noshow {
    		display: none;
    	}
    </style>
    """
)

## Style - Always show output ##
_always_show_output_style = @htl """
<style>
	/* This style permits to have a cell whose output is still being shown when
	   the cell is hidden. This is useful for having hidden cells that still are
	   sending HTML as output (like ToC and BondTable) */
	
	pluto-notebook[hide-enabled] pluto-cell[always-show-output] {
		display: block !important;
	}
	pluto-notebook[hide-enabled] pluto-cell[always-show-output]:not(.code_differs) > pluto-input,
	pluto-notebook[hide-enabled] pluto-cell[always-show-output]:not(.code_differs) > pluto-shoulder,
	pluto-notebook[hide-enabled] pluto-cell[always-show-output]:not(.code_differs) > pluto-trafficlight,
	pluto-notebook[hide-enabled] pluto-cell[always-show-output]:not(.code_differs) > pluto-runarea,
	pluto-notebook[hide-enabled] pluto-cell[always-show-output]:not(.code_differs) > button {
		display: none;
	}
	pluto-notebook[hide-enabled] pluto-cell[always-show-output]:not(.code_differs) {
		margin-top: 0px;
	}
</style>
"""

# Main Function #
"""
	ExtendedTableOfContents(;hide_preamble = true, force_hide_enabled = hide_preamble, kwargs...)

# Keyword Arguments
- `hide_preamble` -> When true, all the cells from the beginning of the notebook till the first heading are hidden (when the notebook is in `hide-enabled` state)
- `force_hide_enabled` -> Set the notebook `hide-enabled` status to true when creating the ToC. This status is used to decide whether to show or not hidden cells via CSS.
- `kwargs` -> The remaining kwargs are simply passed to `TableOfContents` from PlutoUI which is used internally to generate the ToC.

# Description

Extends the `TableOfContents` from `PlutoUI` and adds the following functionality:

## Hiding Heading/Cells
Hiding headings and all connected cells from notebook view can be done via ExtendedTableOfContents
- All cells before the first heading are automatically hidden from the notebook
- All hidden cells/headings can be shown by pressing the _eye_ button that appears while hovering on the ToC title. 
  - When the hidden cells are being shown, the hidden headings in the ToC are underlined
- Hidden status of specific headings in the notebook can be toggled by pressing on the eye button that appears to the left each heading when hovering over them

## Collapsing Headings in ToC
ToC headings are grouped based on heading level, sub-headings at various levels can be collapsed by using the caret symbol that appears to the left of headings in the ToC upon hover.

## Save Hide/Collapsed status on notebook file
Preserving the status of collapsed/hidden heading is supported by writing to the notebook file using notebook and cell metadata, allowing to maintain the status even upon reload of Julia/Pluto
- When the current collapsed/hidden status of each heading is not reflected in the notebook file, a save icon/button appears on the left of the ToC title upon hover. Clicking the icon saves the current state in the notebook file.

## Changing Headings/Cells order
The `ExtendedTableOfContents` allow to re-order the cell groups identified by each heading within the notebook:
- Each cell group is identified by the cell containing the heading, plus all the cells below it and up to the next heading (excluded)
- Holding the mouse on a ToC heading triggers the ability to move headings around
  - The target heading is surrounded by a dashed border
  - While moving the mouse within the ToC, a visual separator appears to indicate the position where the dragged heading will be moved to, depending on the mouse position
  - Hovering on collapsed headings for at least 300ms opens them up to allow moving headings within collapsed parents
- By default, headings can only be moved below or above headings of equal or lower level (H1 < H2 < H3...)
  - Holding shift during the dragging process allows to put headings before/after any other heading regardless of the level


# Example usage

# State Manipulation

![State_Manipulation](https://user-images.githubusercontent.com/12846528/217245898-5166682d-b41d-4f1e-b71b-4d7f69c8f192.gif)

# Cell Reordering

![Cell_Reordering](https://user-images.githubusercontent.com/12846528/217245256-58e4d537-9547-42ec-b1d8-2994b6bcaf51.gif)
"""
ExtendedTableOfContents(; hide_preamble = true, force_hide_enabled = hide_preamble, kwargs...) = @htl(
    """
    $(TableOfContents(; kwargs...))
    $(
        make_script(
            [
                "const hide_preamble = $hide_preamble",
                "const force_hide_enabled = $force_hide_enabled",
                _smooth_scroll,
                _basics,
                _floating_ui,
                _modify_notebook_attributes,
                _modify_cell_attributes,
                _hide_cell_blocks,
                _save_to_file,
                _header_manipulation,
                "cell.toggleAttribute('always-show', true)",
                _mutation_observer,
                _move_entries_handler,
            ]
        )
    )
    $_header_style
    $_toc_row_style
    $_row_separator_style
    $_always_show_output_style
    """
)

# Other Functions #
## Show output when hidden ##
"""
	show_output_when_hidden(x)
Wraps the given input `x` inside a custom HTML code created with
`HypertextLiteral.@htl` that adds the `always-show-output` attribute to the
calling Pluto cell.

This makes sure that the cell output remains visible in the HTML even when the
cell is hidden using the [`ExtendedTableOfContents`](@ref) cell hiding feature.
This is mostly useful to allow having cells that generate output to be rendered
within the notebook as hidden cells.

The provided attribute will make sure (via CSS) that cell will look exactly like
a hidden cell except for its output element. When the output is floating (like
for [`BondTable`](@ref) or [`ExtendedTableOfContents`](@ref)), this will make
the cell hidden while the rendered output visible.

# Example usage
```julia
BondTable([bonds...]) |> show_output_when_hidden
```

The code above will allow putting the cell defining the `BondTable` within a
hidden part of the notebook while still rendering the floating BondTable.
Without this function, the `BondTable` generating cell would need to be located
inside a non-hidden part of the notebook.

# Note
When calling this function with an input object that is not of type `HTML` or
`HypertextLiteral.Result`, the function will wrap the object first using `@htl`
and `PlutoRunner.embed_display`. Since the `embed_display` function is only
available inside of Pluto,  
"""
show_output_when_hidden(x::Union{HTML, HypertextLiteral.Result}) = @htl(
    """
    $x
    <script>
    	const cell = currentScript.closest('pluto-cell')
    	cell.toggleAttribute('always-show-output', true)

    	invalidation.then(() => {
    		cell.toggleAttribute('always-show-output', false)
    	})
    </script>
    """
)
show_output_when_hidden(x) = isdefined(Main, :PlutoRunner) ?
    show_output_when_hidden(@htl("$(Main.PlutoRunner.embed_display(x))")) : error("You can't call
                             this function outside Pluto")
