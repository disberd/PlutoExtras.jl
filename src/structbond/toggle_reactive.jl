using HypertextLiteral
import AbstractPlutoDingetjes.Bonds

# Structure #
Base.@kwdef struct ToggleReactiveBond
    element::Any
    description::Any
    secret_key::String=String(rand('a':'z', 10))
end
ToggleReactiveBond(element; description = "") = ToggleReactiveBond(;element, description)

# AbstractPlutoDingetjes.Bonds methods
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

## Show ##
# Base.show
function Base.show(io::IO, mime::MIME"text/html", r::ToggleReactiveBond)
show(io, mime, @htl("""
<togglereactive-container>
	<togglereactive-header>
		<span class='description'>$(r.description)</span>
		<input type='checkbox' class='toggle' checked>
	</togglereactive-header>
	$(r.element)
	<script id=$(r.secret_key)>
		const parent = currentScript.parentElement
		const el = currentScript.previousElementSibling
		const toggle = parent.querySelector('togglereactive-header .toggle')

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
    $(CSS_PARTS.togglereactive)
    </style>
</togglereactive-container>
""")
)
end