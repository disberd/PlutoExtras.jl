### A Pluto.jl notebook ###
# v0.19.22

#> custom_attrs = ["enable_hidden", "hide-enabled"]

using Markdown
using InteractiveUtils

# ╔═╡ 464fc674-5ed7-11ed-0aff-939456ebc5a8
begin
	using HypertextLiteral
	using PlutoUI
	using PlutoDevMacros.Script
end

# ╔═╡ 46520c1a-bbd8-46aa-95d9-bad3d220ee85
# ╠═╡ custom_attrs = ["gesu"]
md"""
# Scripts
"""

# ╔═╡ 5795b550-5799-4b62-bc25-bc36f3802a8d
md"""
## smoothScroll
The cell below is hidden by default as it has a minified script that is a bit long
"""

# ╔═╡ 052e26d7-8bed-46fe-8b5b-a879e76714cb
# The function here is taken from https://github.com/LieutenantPeacock/SmoothScroll due to some problems on chromium with the standard scrollIntoView. We put it directly here instead of loading it to make it work also offline.
_smoothScroll(enable) = !enable ? HTLScript("") : HTLScript(@htl("""
<script>
	!function(t){var e,n=t.requestAnimationFrame||t.webkitRequestAnimationFrame||t.mozRequestAnimationFrame||t.oRequestAnimationFrame||t.msRequestAnimationFrame||function(e){t.setTimeout(e,1e3/60)},o=[],r=document.getElementsByTagName("html")[0];function i(n){var o=n.getBoundingClientRect(),i=t.pageYOffset||r.scrollTop||e.scrollTop,l=t.pageXOffset||r.scrollLeft||e.scrollLeft,s=r.clientTop||e.clientTop||0,a=r.clientLeft||e.clientLeft||0;return{top:o.top+i-s,left:o.left+l-a}}function l(t){return/Element/.test({}.toString.call(t))}function s(t,e,n){var o;if("number"==typeof t)return t;switch(t){case"start":o=0;break;case"end":o=n+10;break;case"center":o=n/2;break;default:var r,i=t.split("+"),l=t.split("-");if(t.indexOf("+")>0)throw new Error("Position can only contain a + sign at the start");if(t.indexOf("-")>0)throw new Error("Position can only contain a - sign at the start");if(t.indexOf("+")>-1&&t.indexOf("-")>-1)throw new Error("Position cannot contain both + and - signs.");if(t.indexOf("%")>-1&&t.indexOf("%")!==t.length-1)throw new Error("Position can only contain a % symbol at the end.");o=i[1]?(r=i[1]).indexOf("%")>-1?e+n*(r=r.split("%")[0])/100:e+ +r:l[1]?(r=l[1]).indexOf("%")>-1?e-n*(r=r.split("%")[0])/100:e-+r:t.indexOf("%")>-1?n*(r=t.split("%")[0])/100:+t}return o}function a(t,e,n){t.addEventListener?t.addEventListener(e,n,!1):t.attachEvent&&t.attachEvent("on"+e,n)}function c(t,e,n){t.removeEventListener?t.removeEventListener(e,n,!1):t.detachEvent&&t.detachEvent("on"+e,n)}var u={duration:500,preventUserScroll:!0,scrollEvents:["scroll","mousedown","wheel","DOMMouseScroll","mousewheel","touchmove"],scrollKeys:[37,38,39,40,32],allowAnimationOverlap:!1,easing:"linear"};function f(){for(var t=0;t<arguments.length;t++)if(null!=arguments[t])return arguments[t]}function d(t,e,n,o){if("string"!=typeof t)throw new Error("Block and inline values must be strings");function r(t){return e-(n-o)*t}switch(t){case"start":return e;case"center":return r(.5);case"end":return r(1);default:if(t.indexOf("%")>-1&&t.split("%").length<3)return r(+t.split("%")[0]/100);throw new Error("Invalid block or inline string value")}}function h(e,n){if(t.getComputedStyle){var o=getComputedStyle(e,null);if(o.getPropertyValue)return o.getPropertyValue(n);if(o.getAttribute)return o.getAttribute(n);if(o[n])return o[n]}else if(e.currentStyle)return e.currentStyle[n]}function m(e){return e?{x:e.scrollLeft,y:e.scrollTop}:{x:void 0!==t.pageXOffset?t.pageXOffset:(document.documentElement||document.body.parentNode||document.body).scrollLeft,y:void 0!==t.pageYOffset?t.pageYOffset:(document.documentElement||document.body.parentNode||document.body).scrollTop}}function p(t,e,n){return t>e?e-(e-t)*n:(t-e)*n+e}function g(t){for(var e=o.length,n=e-1;n>=0;n--)if(t){var r=o[n];t(r)&&r.destroy(!0)}else o[n].destroy(!0);return!!e}t.smoothScroll=function v(w){if(e||(e=document.getElementsByTagName("body")[0]),w=w||{},this instanceof v)return{smoothScroll:function(e){e=e||{};for(var n=0;n<b.length;n++){var o=b[n];o in e||(e[o]=w[o])}t.smoothScroll(e)}};var y,E,x,M=f(w.yPos,u.yPos),O=+f(w.duration,u.duration),S=f(w.xPos,u.xPos),P=m(),T=P.x,L=P.y,A=Math.max(e.scrollHeight,e.offsetHeight,r.clientHeight,r.scrollHeight,r.offsetHeight),k=Math.max(r.clientWidth,e.scrollWidth,r.scrollWidth,e.offsetWidth,r.offsetWidth),I=A-t.innerHeight,H=k-t.innerWidth,N=f(w.complete,u.complete),W=f(w.scrollingElement,u.scrollingElement),B=f(w.toElement,u.toElement),q=f(w.firstAxis,u.firstAxis),C=f(w.preventUserScroll,u.preventUserScroll),F=f(w.easing,u.easing),R=f(w.block,u.block),K=f(w.inline,u.inline),U=t.innerHeight,X=t.innerWidth,Y=0,Q=f(w.scrollEvents,u.scrollEvents),D=f(w.scrollKeys,u.scrollKeys),V=f(w.paddingTop,u.paddingTop),z=f(w.paddingLeft,u.paddingLeft);if("string"==typeof F){var j=F;if(!(F=v.easing[F]))throw new Error("Easing function "+j+" does not exist.")}else if("function"!=typeof F)throw new Error("Easing must be the name of an easing function or an easing function");if(W){if(!l(W))throw new Error("Scrolling element must be a HTML element");W!=e&&W!=r?(A=W.scrollHeight,k=W.scrollWidth,I=A-W.clientHeight,H=k-W.clientWidth,T=W.scrollLeft,L=W.scrollTop,U=parseInt(h(W,"height"),10),X=parseInt(h(W,"width"),10),y=function(t,e){W.scrollTop=e,W.scrollLeft=t}):(W=void 0,y=t.scrollTo)}else y=t.scrollTo;if(M=null!=M?s(M,L,I):L,S=null!=S?s(S,T,H):T,isNaN(M))throw new Error("Invalid yPos");if(isNaN(S))throw new Error("Invalid xPos");if(isNaN(O))throw new Error("Invalid duration");if(O=Math.max(O,0),S=Math.max(S,0),M=Math.max(M,0),B){if(!l(B))throw new Error("Element to scroll to must be a HTML element");var G=i(B);if(W){var J=i(W);M=W.scrollTop+(G.top-J.top)-parseInt(h(W,"border-top-width"),10),S=W.scrollLeft+(G.left-J.left)-parseInt(h(W,"border-left-width"),10)}else M=G.top,S=G.left;null!=R&&(M=d(R,M,U,B.offsetHeight)),null!=K&&(S=d(K,S,X,B.offsetWidth))}if(null!=V&&(M+=V),null!=z&&(S+=z),M=Math.min(Math.round(M),A),(S=Math.min(Math.round(S),k))!==T||M!==L){if(S!==T&&M!==L||(q=null),null!=q&&(O/=2),!C){for(var Z=0;Z<Q.length;Z++){var \$=Q[Z];W?a(W,\$,_):(a(e,\$,_),a(r,\$,_))}a(W||document,"keydown",tt)}return x=function(t,e,r,i){r&&g(function(t){return t.scrollingElem==i});var l,s=!1,a=function(){s||(t(),n(a))},c=function(t){if(!s){s=!0;var n=function(t){for(var e=0;e<o.length;e++)if(o[e].destroy===t)return e}(c);null!=n&&o.splice(n,1),t&&e(!1,!0)}};return l={destroy:c,scrollingElem:i},o.push(l),n(a),{destroy:function(){c()}}}(function(){var e=t.performance&&performance.now?performance.now():+new Date;E||(E=e);var n=e-E;if(y("y"!=q?p(S,T,F(n/O)):T,"x"!=q?p(M,L,F(n/O)):L),n>=O)if(y("y"!=q?S:T,"x"!=q?M:L),null!=q&&++Y<2){switch(q){case"x":q="y",T=S;break;case"y":q="x",L=M}E=null}else nt(!1,!1)},nt,!f(w.allowAnimationOverlap,u.allowAnimationOverlap),W)}function _(){et(),nt(!0,!1)}function tt(t){D.indexOf(t.keyCode)>-1&&(et(),nt(!0,!1))}function et(){for(var t=0;t<Q.length;t++){var n=Q[t];W?c(W,n,_):(c(e,n,_),c(r,n,_))}c(W||document,"keydown",tt)}function nt(t,e){var n=m(W);x.destroy(),C||et(),N&&N({xPos:S,yPos:M,scrollingElement:W,duration:O,currentXPos:n.x,currentYPos:n.y,interrupted:t,canceled:e})}},smoothScroll.stopAll=function(){return g()},smoothScroll.easing={linear:function(t){return t},swing:function(t){return.5-Math.cos(t*Math.PI)/2}};for(var v={Sine:function(t){return 1-Math.cos(t*Math.PI/2)},Circ:function(t){return 1-Math.sqrt(1-t*t)},Elastic:function(t){return 0===t||1===t?t:-Math.pow(2,8*(t-1))*Math.sin((80*(t-1)-7.5)*Math.PI/15)},Back:function(t){return t*t*(3*t-2)},Bounce:function(t){for(var e,n=4;t<((e=Math.pow(2,--n))-1)/11;);return 1/Math.pow(4,3-n)-7.5625*Math.pow((3*e-2)/22-t,2)}},w=["Quad","Cubic","Quart","Quint","Expo"],y=0;y<w.length;y++)v[w[y]]=function(t){return Math.pow(t,y+2)};for(var E in v)if(null!=E&&null!=v[E]){var x=v[E];smoothScroll.easing["easeIn"+E]=x,smoothScroll.easing["easeOut"+E]=function(t){return 1-x(1-t)},smoothScroll.easing["easeInOut"+E]=function(t){return t<.5?x(2*t)/2:1-x(-2*t+2)/2}}smoothScroll.scrolling=function(){return!!o.length};var b=["xPos","yPos","duration","scrollingElement","toElement","preventUserScroll","easing","complete","firstAxis","scrollEvents","scrollKeys","block","inline","allowAnimationOverlap","paddingTop","paddingLeft"];smoothScroll.defaults=function(t){if(null!=t)for(var e=0;e<b.length;e++){var n=b[e];null!=t[n]&&(u[n]=t[n])}return u},smoothScroll.nativeSupported="scrollBehavior"in r.style}(window);
</script>
"""));

# ╔═╡ aa74f780-96c5-4b91-9658-a34c8c3fcab9
md"""
## Basics
"""

# ╔═╡ a777b426-42e9-4c91-aebd-506388449042
_basics = HTLScript(
	@htl("""
	<script>
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

	// Get next and previous sibling, taken from:
	// https://gomakethings.com/finding-the-next-and-previous-sibling-elements-that-match-a-selector-with-vanilla-js/
	var getNextSibling = function (elem, selector) {

		// Get the next sibling element
		var sibling = elem.nextElementSibling;
	
		// If there's no selector, return the first sibling
		if (!selector) return sibling;
	
		// If the sibling matches our selector, use it
		// If not, jump to the next sibling and continue the loop
		while (sibling) {
			if (sibling.matches(selector)) return sibling;
			sibling = sibling.nextElementSibling
		}
	
	};
	var getPreviousSibling = function (elem, selector) {

		// Get the next sibling element
		var sibling = elem.previousElementSibling;
	
		// If there's no selector, return the first sibling
		if (!selector) return sibling;
	
		// If the sibling matches our selector, use it
		// If not, jump to the next sibling and continue the loop
		while (sibling) {
			if (sibling.matches(selector)) return sibling;
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

	function set_state(div, state, value, init = false) {
		div.classList.toggle(state, value)
		if (!init) {
			window.toc_state[get_link_id(div)][state] = value
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
	</script>
	""")
);

# ╔═╡ 6e2397db-6f95-44ed-b874-bb0e6c853169
md"""
## floating-ui library
"""

# ╔═╡ 3c27af28-4fee-4b74-ad10-f57c11237dbb
_floating_ui = HTLScript(@htl("""
<script>
	const floating_ui = await import('https://esm.sh/@floating-ui/dom')
	// window.floating_ui = floating_ui
</script>
"""));

# ╔═╡ e9413fd1-d43c-4288-bcfa-850c30cc9513
md"""
## modify\_cell_attributes
"""

# ╔═╡ c1fa9fa5-b35e-43c5-bd32-ebca9cb01848
_modify_cell_attributes = HTLScript(@htl("""
<script>
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
</script>
"""));

# ╔═╡ e9668acb-451d-4d16-b9cb-cf0ddcd6a681
md"""
## modify\_notebook\_attributes
"""

# ╔═╡ d65daa79-cb1d-4425-9693-b737d43e9981
_modify_notebook_attributes = HTLScript(@htl("""
<script>
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
</script>
"""));

# ╔═╡ 123da4b2-710e-4962-b255-80fb33894b79
md"""
## hide\_cell\_blocks
"""

# ╔═╡ 904a2b12-6ffa-4cf3-95cf-002cf2673099
_hide_cell_blocks = HTLScript(@htl("""
<script>
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
</script>
"""));

# ╔═╡ 60075509-fbdb-48c8-8e63-69f6fd5218b5
md"""
## mutation\_observer
"""

# ╔═╡ 702d5075-baad-4c11-a732-d062213e00e4
_mutation_observer = HTLScript(@htl("""
<script>
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
		if (use_smoothscroll) {
			const this_cell = document.getElementById(id)
			let old_f = a.onclick;
			a.onclick = (e) => {
				old_f(e)
				smoothScroll({toElement: this_cell, block: 'start'})
			}
		}
		const level = Number(a.classList[0][1])
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
		update_hidden()
	})

	observer.observe(toc, {childList: true})
</script>
"""),
"observer.disconnect()"
);

# ╔═╡ 2bb6e943-f99d-4eef-9846-4ee71a7fa426
@htl """
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
	.drag_enabled .toc-row.dragged {
		border: 2px dashed grey;
	}

	.drag_enabled .toc-row {
		position: relative;
	}
	.drag_enabled .toc-row:after {
		position: absolute;
		content: '';
		height: 100%;
		width: 100%;
		bottom: 0px;
	}
</style>
"""

# ╔═╡ a271f2cd-b941-46af-888d-3274d21b3703
md"""
## move\_entries\_handler
"""

# ╔═╡ 5f60d643-d79c-4081-a31e-603e062e544f
_move_entries_handler = HTLScript(@htl("""
<script>
	const { default: interact } = await import('https://esm.sh/interactjs')

	function dragEnabler(e) {
		if (e.key !== 'Alt') { return }
		switch (e.type) {
			case "keydown":
				toc.classList.add('drag_enabled')
				break;
			case "keyup":
				toc.classList.remove('drag_enabled')
				break;
		}
	}

	const window_events = {
		keydown: dragEnabler,
		keyup: dragEnabler,
	}

	addScriptEventListeners(window, window_events)

	// Interact.js part

	let activeDrop = undefined

	function isValidSeparator(sep) {
		let temp = getNextSibling(sep, '.toc-row:not(.parent-collapsed)')
		if (!_.isNil(temp) && temp.classList.contains('dragged')) { return false }
		
		temp = getPreviousSibling(sep, '.toc-row:not(.parent-collapsed)')
		if (!_.isNil(temp) && temp.classList.contains('dragged')) { return false }

		return true
	}

	function updateActiveSeparator(e) {
		if (_.isNil(activeDrop)) {return}
		const { y, height } = activeDrop.getBoundingClientRect()
		// Check if the current position of the mouse is below or above the middle of the active drop zone
		const isBelow = e.client.y > y + height/2
		const getSep = isBelow ? getNextSibling : getPreviousSibling
		const newSep = getSep(activeDrop)
		const currentSep = toc.querySelector('.toc-row-separator.active') ?? newSep
		if (currentSep !== newSep) {
			currentSep.classList.remove('active')
		}
		if (isValidSeparator(newSep)) {
			newSep.classList.add('active')
		}
	}

	interact('.drag_enabled .toc-row').draggable({
		listeners: {
			start: function (e) {
				// console.log('start: ', e)
				e.target.classList.add('dragged')
			},
			move: updateActiveSeparator,
			end: function (e) {
				// console.log('end: ', e)
				e.target.classList.remove('dragged')
				const dropZone = toc.querySelector('.toc-row-separator.active')
				if (_.isNil(dropZone)) {return}
				// We find the cell after the active separator and move the dragged row before that
				const rowAfter = getNextSibling(dropZone)
				const cellIdsToMove = getBlockIds(e.target)
				pluto_actions.move_remote_cells(cellIdsToMove, editor_state.notebook.cell_order.indexOf(get_link_id(rowAfter)))
			},
		}
	})
	
	interact('.drag_enabled .toc-row').dropzone({
		ondragenter: function (e) {
			// console.log('enter: ', e)
			activeDrop = e.target
			e.target.classList.add('active_drop')
		},
		ondragleave: function (e) {
			activeDrop = undefined
			e.target.classList.remove('active_drop')
		}
	})

</script>
"""), """
interact('.drag_enabled .toc-row').unset()
""");

# ╔═╡ 6dbebad0-cc03-499c-9d3a-0aa7e9b32549
md"""
## header_manipulation
"""

# ╔═╡ ef5eff51-e6e4-4f40-8763-119cbd479d66
_header_manipulation = HTLScript(@htl("""
<script>
	const header = toc.querySelector('header')
	const header_container = header.insertAdjacentElement('afterbegin', html`<span class='toc-header-container'><span class='toc-header-icon toc-header-hide'>`)
	const notebook_hide_icon = header_container.firstChild
	
	const save_file_icon = header.insertAdjacentElement('beforeend', html`<span class='toc-header-icon toc-header-save'>`)
	save_file_icon.addEventListener('click', save_to_file)

	header.addEventListener('click', e => {
		if (e.target != header) {return}
		if (use_smoothscroll) {
			smoothScroll({toElement: cell, block: 'start'})
		} else {
			cell.scrollIntoView({block: 'center', behavior: 'smooth'})
		}
	})

	header.addEventListener('mouseenter', (e) => {
		floating_ui.computePosition(header, header_container, {
			placement: "left",
			strategy: "fixed",
		}).then(pos => {
			header_container.style.top = pos.y + "px"
		})
	})

	notebook_hide_icon.addEventListener('click', (e) => toggle_notebook_attribute('hide-enabled'))
</script>
"""));

# ╔═╡ 7b8f25a8-e0cf-4b1b-8cfc-9de6334e75dd
md"""
## save\_to\_file
"""

# ╔═╡ 2ece4464-df5e-48e5-96d2-607213daebda
_save_to_file = HTLScript(@htl("""
<script>
	function save_to_file() {
		const state = window.toc_state
		for (const [k,v] of Object.entries(state)) {
			toggle_cell_attribute(k, 'toc-hidden', v.hidden)	
			toggle_cell_attribute(k, 'toc-collapsed', v.collapsed)	
		}
	}
</script>
"""));

# ╔═╡ 59e74c4f-c561-463e-b096-e9e587417285
md"""
## toc_style
"""

# ╔═╡ 0b11ce0a-bc66-41d2-9fbf-1be98b1ce39b
_toc_style = @htl """
<style>
	.plutoui-toc header {
		cursor: pointer;
	}
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
	.plutoui-toc section div.toc-row a {
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
	span.toc-header-container {
		position: fixed;
		right: calc(min(80vw, 300px) + 1rem - 50px + 3px);
		display: flex;
		--size: 25px;
		width: calc(var(--size) + 50px);
		height: calc(51px - 1rem);
		z-index: -1;
	}
	.toc-header-hide {
		align-self: stretch;
		--size: 1em;
		width: var(--size);
		display: block;
		background-size: var(--size) var(--size);
	    background-repeat: no-repeat;
	    background-position: center;
		filter: var(--image-filters);
		background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/eye-outline.svg);
		cursor: pointer;
		opacity: 50%;
		visibility: hidden;
	}
	.toc-header-save {
		position: absolute;
		right: 0px;
		top: .55em;
		--size: 1em;
		cursor: pointer;
		--size: 1em;
		width: var(--size);
		height: var(--size);
		z-index: 500;
	}
	.toc-header-save:hover:before {
		content: "";
		display: inline-block;
		width: var(--size);
		height: var(--size);
		background-size: var(--size) var(--size);
	    background-repeat: no-repeat;
	    background-position: center;
		filter: var(--image-filters);
		background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/save-outline.svg);
	}
	.plutoui-toc header:hover .toc-header-hide,
	.toc-header-container:hover > .toc-header-hide {
		visibility: visible;
	}
	pluto-notebook[hide-enabled] span.toc-header-hide {
		background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/eye-off-outline.svg);
	}
</style>
""";

# ╔═╡ 0aac28b7-4771-447c-ab62-92250f46154f
md"""
# Main Function
"""

# ╔═╡ a1a09dae-b441-484e-8f40-e51e31fb34dd
"""
	ExtendedTableOfContents(;hide_preamble = true, force_hide_enabled = hide_preamble, use_smoothscroll = true, kwargs...)

# Keyword Arguments
- `hide_preamble` -> When true, all the cells from the beginning of the notebook till the first heading are hidden (when the notebook is in `hide-enabled` state)
- `force_hide_enabled` -> Set the notebook `hide-enabled` status to true when creating the ToC. This status is used to decide whether to show or not hidden cells via CSS.
- `use_smoothscroll` -> Replace scrolling into view from the ToC to use the [`smoothScroll`](https://github.com/LieutenantPeacock/SmoothScroll/) library for better compatibility.
- `kwargs` -> The remaining kwargs are simply passed to `TableOfContents` from PlutoUI which is used internally to generate the ToC.

# Description

Extends the `TableOfContents` from `PlutoUI` to allow collapsing and hiding sections of the ToC.
Collapsing is performed by clicking on the chevron icon next to a toc header that has children.

Hiding of an entry is done by clicking on the eye icon that appears as overlay to the left of the ToC row.
When a section of the ToC is hidden, all lower level heading depending on the hidden entry are also indirectly hidden.

By default, hidden ToC entries disappear from the ToC and the corresponding group of cells belonging to the hidden ToC entries are also hidden from the notebook.
To trigger visibility of hidden cells and toc entries without modifying their hidden status, one can click the eye icon that appears to the left of the ToC title when hovering over it. This toggles the notebook `hide-enabled` status. 

Clicking on the ToC title itself scrolls the viewport to bring the cell where the ToC is defined into view.

When hovering the mouse to the right of the ToC title, a save icon appears. Upon clicking, the status of the hidden/collapsed toc entires is saved to the notebook file using cell metadata to preserve the status even upon reloading of the notebook.
"""
ExtendedTableOfContents(;hide_preamble = true, force_hide_enabled = hide_preamble, use_smoothscroll = true, kwargs...) = @htl """
$(TableOfContents(;kwargs...))
$(combine_scripts([
	"const use_smoothscroll = $use_smoothscroll",
	"const hide_preamble = $hide_preamble",
	"const force_hide_enabled = $force_hide_enabled",
	_smoothScroll(use_smoothscroll),
	_basics,
	_modify_notebook_attributes,
	_modify_cell_attributes,
	_hide_cell_blocks,
	_save_to_file,
	_header_manipulation,
	"cell.toggleAttribute('always-show', true)",
	_mutation_observer,
	_move_entries_handler,
]))
$_toc_style
"""

# ╔═╡ d05d4e8c-bf50-4343-b6b5-9b77caa646cd
ExtendedTableOfContents()

# ╔═╡ 1bdb12d3-899d-4ce0-a053-6cf1fa15072d
export ExtendedTableOfContents

# ╔═╡ 48540378-5b63-4c20-986b-75c08ceb24b7
# ╠═╡ custom_attrs = ["toc-collapsed"]
md"""
# Tests
"""

# ╔═╡ 091dbcb6-c5f6-469b-889a-e4b23197d2ad
md"""
## very very very very very very very very very long
"""

# ╔═╡ c9bcf4b9-6769-4d5a-bbc0-a14675e11523
md"""
### Short
"""

# ╔═╡ c4490c71-5994-4849-914b-ec1a88ec7881
md"""
# Fillers
"""

# ╔═╡ fd6772f5-085a-4ffa-bf55-dfeb8e93d32b
md"""
## More Fillers
"""

# ╔═╡ 863e6721-98f1-4311-8b9e-fa921030f7d7
md"""
## More Fillers
"""

# ╔═╡ 515b7fc0-1c03-4c82-819b-4bf70baf8f14
md"""
## More Fillers
"""

# ╔═╡ e4a29e2e-c2ec-463b-afb2-1681c849780b
md"""
## More Fillers
"""

# ╔═╡ eb559060-5da1-4a9e-af51-9007392885eb
md"""
## More Fillers
"""

# ╔═╡ 1aabb7b3-692f-4a27-bb34-672f8fdb0753
md"""
## More Fillers
"""

# ╔═╡ ac541f37-7af5-49c8-99f8-c5d6df1a6881
md"""
## More Fillers
"""

# ╔═╡ fdf482d1-f8fa-4628-9417-2816de367e94
md"""
## More Fillers
"""

# ╔═╡ 6de511d2-ad79-4f0e-95ff-ce7531f3f0c8
md"""
## More Fillers
"""

# ╔═╡ a8bcd2cc-ae01-4db7-822f-217c1f6bbc8f
md"""
## More Fillers
"""

# ╔═╡ 6dd2c458-e02c-4850-a933-fe9fb9dcdf39
md"""
## More Fillers
"""

# ╔═╡ 9ddc7a20-c1c9-4af3-98cc-3b803ca181b5
md"""
## More Fillers
"""

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
HypertextLiteral = "~0.9.4"
PlutoDevMacros = "~0.5.0"
PlutoUI = "~0.7.49"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-beta3"
manifest_format = "2.0"
project_hash = "f6b7f28150a0363dfa2e3afc8c0c832e230b1612"

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

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "eb7f0f8307f71fac7c606984ea5fb2817275d6e4"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.4"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.0.2+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

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

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

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
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

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
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.21+0"

[[deps.Parsers]]
deps = ["Dates", "SnoopPrecompile"]
git-tree-sha1 = "151d91d63d8d6c1a5789ecb7de51547e00480f1b"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.4"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlutoDevMacros]]
deps = ["HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Random", "Requires"]
git-tree-sha1 = "fa04003441d7c80b4812bd7f9678f721498259e7"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.5.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "eadad7b14cf046de6eb41f13c9275e5aa2711ab6"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.49"

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
deps = ["Preferences"]
git-tree-sha1 = "e760a70afdcd461cf01a575947738d359234665c"
uuid = "66db9d55-30c0-4569-8b51-7e840670fc0c"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["Libdl", "LinearAlgebra", "Random", "Serialization", "SuiteSparse_jll"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.9.0"

[[deps.SuiteSparse_jll]]
deps = ["Artifacts", "Libdl", "Pkg", "libblastrampoline_jll"]
uuid = "bea87d4a-7f5b-5778-9afe-8cc45184846c"
version = "5.10.1+0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.Tricks]]
git-tree-sha1 = "6bac775f2d42a611cdfcd1fb217ee719630c4175"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.6"

[[deps.URIs]]
git-tree-sha1 = "ac00576f90d8a259f2c9d823e91d1de3fd44d348"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.1"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.2.0+0"

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
# ╠═464fc674-5ed7-11ed-0aff-939456ebc5a8
# ╠═d05d4e8c-bf50-4343-b6b5-9b77caa646cd
# ╟─46520c1a-bbd8-46aa-95d9-bad3d220ee85
# ╟─5795b550-5799-4b62-bc25-bc36f3802a8d
# ╟─052e26d7-8bed-46fe-8b5b-a879e76714cb
# ╟─aa74f780-96c5-4b91-9658-a34c8c3fcab9
# ╠═a777b426-42e9-4c91-aebd-506388449042
# ╠═6e2397db-6f95-44ed-b874-bb0e6c853169
# ╠═3c27af28-4fee-4b74-ad10-f57c11237dbb
# ╟─e9413fd1-d43c-4288-bcfa-850c30cc9513
# ╠═c1fa9fa5-b35e-43c5-bd32-ebca9cb01848
# ╟─e9668acb-451d-4d16-b9cb-cf0ddcd6a681
# ╠═d65daa79-cb1d-4425-9693-b737d43e9981
# ╠═123da4b2-710e-4962-b255-80fb33894b79
# ╠═904a2b12-6ffa-4cf3-95cf-002cf2673099
# ╠═60075509-fbdb-48c8-8e63-69f6fd5218b5
# ╠═702d5075-baad-4c11-a732-d062213e00e4
# ╠═2bb6e943-f99d-4eef-9846-4ee71a7fa426
# ╟─a271f2cd-b941-46af-888d-3274d21b3703
# ╠═5f60d643-d79c-4081-a31e-603e062e544f
# ╟─6dbebad0-cc03-499c-9d3a-0aa7e9b32549
# ╠═ef5eff51-e6e4-4f40-8763-119cbd479d66
# ╠═7b8f25a8-e0cf-4b1b-8cfc-9de6334e75dd
# ╠═2ece4464-df5e-48e5-96d2-607213daebda
# ╟─59e74c4f-c561-463e-b096-e9e587417285
# ╠═0b11ce0a-bc66-41d2-9fbf-1be98b1ce39b
# ╟─0aac28b7-4771-447c-ab62-92250f46154f
# ╠═a1a09dae-b441-484e-8f40-e51e31fb34dd
# ╠═1bdb12d3-899d-4ce0-a053-6cf1fa15072d
# ╟─48540378-5b63-4c20-986b-75c08ceb24b7
# ╠═091dbcb6-c5f6-469b-889a-e4b23197d2ad
# ╠═c9bcf4b9-6769-4d5a-bbc0-a14675e11523
# ╠═c4490c71-5994-4849-914b-ec1a88ec7881
# ╠═fd6772f5-085a-4ffa-bf55-dfeb8e93d32b
# ╠═863e6721-98f1-4311-8b9e-fa921030f7d7
# ╠═515b7fc0-1c03-4c82-819b-4bf70baf8f14
# ╠═e4a29e2e-c2ec-463b-afb2-1681c849780b
# ╠═eb559060-5da1-4a9e-af51-9007392885eb
# ╠═1aabb7b3-692f-4a27-bb34-672f8fdb0753
# ╠═ac541f37-7af5-49c8-99f8-c5d6df1a6881
# ╠═fdf482d1-f8fa-4628-9417-2816de367e94
# ╠═6de511d2-ad79-4f0e-95ff-ce7531f3f0c8
# ╠═a8bcd2cc-ae01-4db7-822f-217c1f6bbc8f
# ╠═6dd2c458-e02c-4850-a933-fe9fb9dcdf39
# ╠═9ddc7a20-c1c9-4af3-98cc-3b803ca181b5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
