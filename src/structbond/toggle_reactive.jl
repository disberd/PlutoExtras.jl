# Struct #
Base.@kwdef struct ToggleReactiveBond
    element::Any
    description::String
    secret_key::String=String(rand('a':'z', 10))
    classes::Vector{String}=String[]
    description_html = description
end
ToggleReactiveBond(element; description = "", classes = String[], description_html = description) = ToggleReactiveBond(;element, description, classes, description_html)

# AbstractPlutoDingetjes Methods #
function Bonds.initial_value(r::ToggleReactiveBond)
    Bonds.initial_value(r.element)
end
function Bonds.validate_value(r::ToggleReactiveBond, from_js)
    Bonds.validate_value(r.element, from_js)
end
function Bonds.transform_value(r::ToggleReactiveBond, from_js)
    Bonds.transform_value(r.element, from_js)
end
function Bonds.possible_values(r::ToggleReactiveBond)
    Bonds.possible_values(r.element)
end

# Show Method #
Base.show(io::IO, mime::MIME"text/html", r::ToggleReactiveBond) = show(io, mime, @htl("""
<togglereactive-container class=$(r.classes)>
	<togglereactive-header>
        <span class='collapse-btn'></span>
		<span class='description'>$(r.description_html)</span>
		<input type='checkbox' class='toggle' checked>
	</togglereactive-header>
	$(r.element)
	<script id=$(r.secret_key)>
		const parent = currentScript.parentElement
		const el = currentScript.previousElementSibling
		const toggle = parent.querySelector('togglereactive-header .toggle')
        const collapse_btn = parent.querySelector('togglereactive-header .collapse-btn')

        parent.collapse = () => {
            parent.classList.toggle('collapsed')
        }

        collapse_btn.onclick = (e) => parent.collapse()

		const set_input_value = setBoundElementValueLikePluto
		const get_input_value = getBoundElementValueLikePluto

		// We use clone to avoid pointing to the same array
		let public_value = _.cloneDeep(get_input_value(el))

		function dispatch() {
			public_value = _.cloneDeep(get_input_value(el))
			parent.dispatchEvent(new CustomEvent('input'))
		}

		const old_oninput = el.oninput ?? function(e) {}
		el.oninput = (e) => {
			old_oninput(e)
			if (toggle.checked) {dispatch()}
		}

		toggle.oninput = e => {
			if (toggle.checked && !_.isEqual(get_input_value(el), public_value)) {
				dispatch()
			}
			e.stopPropagation()
		}

		Object.defineProperty(parent, 'value', {
			get: () => public_value,
			set: (newval) => {
				public_value = newval
				
				set_input_value(el, newval)
				toggle.checked = true
			},
			configurable: true,
		});
	</script>
	<style>
        $(CSS_Sheets.togglereactive)		
	</style>
</togglereactive-container>
"""))