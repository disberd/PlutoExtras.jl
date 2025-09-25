// Extended Table of Contents JavaScript functionality
// Designed to be included directly in a <script> tag
// This file contains all the JavaScript code for the ExtendedTableOfContents features, but is not per se a valid/executable as javascript directly
// This file assumes that some variables are already defined in the preamble of the <script> tag like `scrollIntoView`, these are directly added in the julia function in `extended_toc_simple.jl`

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

// Basic functionality
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
    return row.linkedHeadingId
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
            console.error(`The type (${typeof selector}) of the provided argument is not valid`)
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
    let new_state = `parent-${state}`
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

// Floating UI functionality
const floating_ui = await import('https://esm.sh/@floating-ui/dom')

// Cell attributes modification
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

// Notebook attributes modification
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

// Hide cell blocks functionality
// For each from and to, we have to specify `pluto-cell[id]` in the part before the comm and just `[id]` in the part after the comma to ensure the specificity of the two comma-separated selectors is the same (the part after the comma has the addition of `~ pluto-cell`, so it has inherently +1 element specificity)
function hide_from_to_string(from_id, to_id) {
    if (_.isEmpty(from_id) && _.isEmpty(to_id)) {return ''}
    
    const from_preselector = _.isEmpty(from_id) ? '' : `pluto-cell[id='${from_id}'], pluto-notebook[hide-enabled] [id='${from_id}'] ~ `
    const to_style = _.isEmpty(to_id) ? '' : `pluto-notebook[hide-enabled] pluto-cell[id='${to_id}'], pluto-notebook[hide-enabled] [id='${to_id}'] ~ pluto-cell {
    display: block;
}
     `
    const style_string = 	`pluto-notebook[hide-enabled] ${from_preselector}pluto-cell {
    display: none;
}
${to_style}
 `
    return style_string
}

function hide_from_to_list_string(vector) {
    let out = ``
    for (const lims of vector) {
        const from = lims[0]
        const to = lims[1]
        
        out = `${out}\t${hide_from_to_string(from,to)}`
    }
    out = `${out}\tpluto-cell[always-show] {
          display: block !important;
      }
  `
    return out
}
function hide_from_to_list(vector) {
    const str = hide_from_to_list_string(vector)
    return html`<style>${str}</style>`
}
function hide_list_style(vector) {
    let style = document.getElementById('hide-cells-style')
    if (style == null) {
          style = document.head.appendChild(html`<style id='hide-cells-style'></style>`)
    }
    style.innerHTML = hide_from_to_list_string(vector)
}

// Mutation observer functionality
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

    // We find all the mainHeadings and tocRows to find matching pairs

    // Try the original selector first
    const tocRows = Array.from(toc.querySelectorAll('section div.toc-row'))

    const mainHeadings = Array.from(document.querySelectorAll('main h1, main h2, main h3, main h4, main h5, main h6'))

    const headingIdx = tocRows.indexOf(div)

    const correspondingHeading = mainHeadings[headingIdx]

    div.linkedHeading = correspondingHeading
    div.linkedHeadingId = correspondingHeading.closest('pluto-cell').id

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
    let hide_style = `--height: ${a.clientHeight}px`
    const hide_container = div.insertAdjacentElement('afterbegin', html`<span class='toc-hide-container' style='${hide_style}'>`)
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
    console.log('=== ExtendedTableOfContents MutationObserver triggered ===')
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

// Move entries handler functionality
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

// Function to add all event listeners from an events object
function addWindowEventListeners(events) {
    for (const [eventType, handler] of Object.entries(events)) {
        window.addEventListener(eventType, handler)
    }
}

// Function to remove all event listeners from an events object
function removeWindowEventListeners(events) {
    for (const [eventType, handler] of Object.entries(events)) {
        window.removeEventListener(eventType, handler)
    }
}

// Add event listeners directly
addWindowEventListeners(window_events)

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

// Header manipulation functionality
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

// Save to file functionality
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

// Make functions available globally
window.scroll_to = scroll_to;
window.save_to_file = save_to_file;
window.floating_ui = floating_ui;

// Set cell attribute for always-show
cell.toggleAttribute('always-show', true)

invalidation.then(() => {
    observer.disconnect()
    dragHandles.unset()
    // Clean up event listeners
    removeWindowEventListeners(window_events)
})