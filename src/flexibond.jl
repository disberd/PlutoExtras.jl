### A Pluto.jl notebook ###
# v0.19.22

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 6303ec9e-7084-456c-a994-774b1f1fea0e
begin
	using AbstractPlutoDingetjes
	using HypertextLiteral
	using PlutoDevMacros.Script
end

# ╔═╡ 870bd8b3-812b-4570-b2eb-4be19584f45e
begin
	using PlutoUI
end

# ╔═╡ 888c268f-a8ed-43fd-8692-370a0a50b249
TableOfContents()

# ╔═╡ afc972ef-802c-472a-8b89-c963a7c402f7
randstr(n::Int) = join(rand("abcdefghilmnopqrstuvzABCDEFGHILMNOPQRSTUVZ", n))

# ╔═╡ 9edb3e2e-17a3-41fd-8c03-cfb73be0e987
md"""
## FlexiWrapper
"""

# ╔═╡ 73aaf8a6-1956-4bda-a12e-c7c25cbdc3ee
struct FlexiWrapper{E}
	element::E
	id::String
	function FlexiWrapper(element::E) where E
		id = randstr(6)
		new{E}(element,id)
	end
end	

# ╔═╡ a82a6f30-ca93-4770-8d3e-9c0f890b9c1c
md"""
### AbstractPlutoDingetjes
"""

# ╔═╡ 02ce7546-935b-4f24-be88-91bf3f00aa36
md"""
### show
"""

# ╔═╡ da92a4d3-7b0d-447e-9d7c-305f890f6efa
# ╠═╡ skip_as_script = true
#=╠═╡
dio = @bind asdlol FlexiWrapper(Slider(1:10))
# dio = @bind asdlol FlexiWrapper(MultiSelect(["🥕", "🐟", "🍌"]))
  ╠═╡ =#

# ╔═╡ 73bcdcb7-a40e-4b39-b4fc-d3909a82f271
# ╠═╡ skip_as_script = true
#=╠═╡
ddd = 1
  ╠═╡ =#

# ╔═╡ b4f38258-4079-42c7-898f-3b6704d17a49
#=╠═╡
let
# sleep(.3)
	asdlol
end
  ╠═╡ =#

# ╔═╡ 8da1ebcf-a180-4705-8026-e6a5310f3ed8
#=╠═╡
let
ddd
dio
end
  ╠═╡ =#

# ╔═╡ bef96792-dccc-4ae5-a515-0f1513b6085e
get_element_recursive(x) = hasproperty(x,:element) ? get_element_recursive(x.element) : hasproperty(x,:bond) ? get_element_recursive(x.bond) : x

# ╔═╡ cd5fabf1-ba09-4e14-9ea4-ae34b6b12935
function has_flexiwrapper_child(x)
	hasproperty(x, :bond) && return has_flexiwrapper_child(x.bond.element)
	return x isa FlexiWrapper ? true : false
end

# ╔═╡ 5a732ec3-4dd3-4c38-b3ce-45177e39049b
md"""
## StaticBond
"""

# ╔═╡ 3e88a85e-1f04-45db-bca8-17e991ab95ba
struct StaticBond{E}
	bond::Any
	element::E
	id::String
	function StaticBond(b::B) where B
		@assert nameof(B) == :Bond "Only a Bond can be given as input to generate a StaticBond"
		id = randstr(6)
		element = b.element
		new{typeof(element)}(b, element, id)
	end
end

# ╔═╡ 24237ad1-3dbb-480a-9201-bb6ac9dba053
foreach([:possible_values, :transform_value, :initial_value, :validate_value]) do f
	full_name = :(AbstractPlutoDingetjes.Bonds.$f)
	if f in (:possible_values, :initial_value)
		eval(:($(full_name)(b::Union{FlexiWrapper, StaticBond}) = $(full_name)(b.element)))
	else
		eval(:($(full_name)(b::Union{FlexiWrapper, StaticBond}, from_browser) = $(full_name)(b.element, from_browser)))
	end
end

# ╔═╡ 1e1becd2-bc0d-4cbc-9ee3-e0930f5cd35c
md"""
### show
"""

# ╔═╡ 8e512166-16b5-4474-915d-e370bd9c6fa3
#=╠═╡
asdfasdf = @bind madonnamia StaticBond(dio)
  ╠═╡ =#

# ╔═╡ 4f1ce88a-188f-4f20-b2a4-14edb11f52d3
#=╠═╡
@htl """
$asdfasdf
<script>
	const staticbond = currentScript.closest('pluto-cell').querySelector('span.staticbond')
	if (staticbond !== undefined) {
		staticbond.classList.toggle('hide_extra',true)
	}
</script>
"""
  ╠═╡ =#

# ╔═╡ 1973e468-51f7-4a89-b7d2-5e92261df300
#=╠═╡
asdlol, madonnamia
  ╠═╡ =#

# ╔═╡ 0f4cefed-9652-44a3-97c7-a8de930d79e5
# ╠═╡ skip_as_script = true
#=╠═╡
fjlasd = 1
  ╠═╡ =#

# ╔═╡ db895645-a107-4c32-b808-08f48778f16c
#=╠═╡
let
	fjlasd
asdfasdf
end
  ╠═╡ =#

# ╔═╡ 5a545e44-f732-467e-bae6-4544c8d2b49f
function bind_expr(calling_module, def, element, escape=true)
	if def isa Symbol
		PlutoRunner = calling_module.PlutoRunner
		_el = escape ? esc(element) : element
		quote
            $(PlutoRunner.load_integrations_if_needed)()
			local el = $_el
            global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : $(PlutoRunner.initial_value_getter_ref)[](el)
			$(PlutoRunner).create_bond(el, $(Meta.quot(def)))
		end
	else
		:(throw(ArgumentError("""\nMacro example usage: \n\n\t@bind my_number html"<input type='range'>"\n\n""")))
	end
end

# ╔═╡ de95468b-c49a-49ec-bb80-175eca04a6cf
function flexibind_expr(calling_module, def, element) 
	flexibind_mod = @__MODULE__
	if def isa Symbol
		static = Symbol(def,"_static")
		block = quote
			local $(esc(:b1)) = $flexibind_mod.FlexiWrapper($(esc(element)))
			local b2 = @bind $def b1
			local $(esc(:b3)) = $flexibind_mod.StaticBond($(esc(:b2)))
			@bind $static b3
		end
		block.args[4] = esc(block.args[4])
		block.args[8] = esc(block.args[8])
		block
	else
		:(throw(ArgumentError("""\nMacro example usage: \n\n\t@flexibind my_number html"<input type='range'>"\n\n""")))
	end
end

# ╔═╡ 80155d1c-f2b3-4345-aade-960e2c2802ee
macro flexibind(def, element)
	flexibind_expr(__module__,def,element)
end

# ╔═╡ 6d5701c6-30e5-4b8e-94b2-fd0bd1fdd129
export @flexibind

# ╔═╡ aedd6f98-da1a-401c-9d54-37125146dfdb
# ╠═╡ skip_as_script = true
#=╠═╡
(@macroexpand1 @flexibind dio Slider(1:10))
  ╠═╡ =#

# ╔═╡ fe198de7-9ddb-4d42-9251-9cee16c3cbbe
md"""
# Tests
"""

# ╔═╡ 2fb1bd81-612c-465b-a0b3-07128f8e794e
diogesu = 3

# ╔═╡ 0435001d-3ab2-41ff-813e-b5487aaa7357
# ╠═╡ skip_as_script = true
#=╠═╡
a = @flexibind test Slider(1:10)
  ╠═╡ =#

# ╔═╡ 64219202-d6d2-4d76-87fc-3cb01e9f8bd2
#=╠═╡
typeof(a)
  ╠═╡ =#

# ╔═╡ f3af3238-ba1d-45f4-b9d6-a652a039b561
#=╠═╡
let
	diogesu
	a
end
  ╠═╡ =#

# ╔═╡ dd1a1e32-61ef-4065-bf2d-9dc798e2fde9
#=╠═╡
test, test_static
  ╠═╡ =#

# ╔═╡ 5febe0d1-7d07-4252-a060-e156f0d81c5e
md"""
## innermost_child
"""

# ╔═╡ 93658b61-3d8c-4d9d-b8cc-4c86cc716ff9
_innermost_child = HTLScriptPart(@htl """
<script>
	function getInnermostBond(el) {
		let bond = el.querySelector('bond')
		return bond != null ? getInnermostBond(bond) : el.matches('bond') ? el : null
	}
	let innermost_bond = getInnermostBond(currentScript.parentElement)
	let innermost_child = innermost_bond.firstElementChild
</script>
""");

# ╔═╡ 8635fc03-769b-4404-81aa-3c01620bd792
md"""
## set_get
"""

# ╔═╡ 94c3741d-43d3-4a57-b88b-ca660cbb7e94
_set_get = (@htl """
<script>	

	out.public_value = this?.public_value ?? get_input_value(bond_child)
	
	Object.defineProperty(parent, 'value', {
		get: () => {
			return out.public_value
	   },
		set: (newVal) => {
			out.public_value = newVal
			return newVal
		},
		configurable: true,
	})


	const dispatch = () => parent.dispatchEvent(new CustomEvent('input'))

	const private_updated = (force_update) => {
		if (force_update) {
			out.public_value = get_input_value(bond_child)
			dispatch()
		}
	}

	bond_child.addEventListener(event_type, (e) => {
		e.stopPropagation()
		private_updated(out.online)
	})
</script>
""") |> HTLScriptPart;

# ╔═╡ 32a12484-79ad-4179-a0ef-3dbbe259cdf3
md"""
## preamble
"""

# ╔═╡ 96d72536-1cf0-4b31-b659-edb008f5bbdc
_preamble = (@htl """
<script>
	let parent = currentScript.parentElement
	
	let get_input_value = getBoundElementValueLikePluto
	let set_input_value = setBoundElementValueLikePluto
	let eventof = getBoundElementEventNameLikePluto
</script>
""") |> HTLScriptPart;

# ╔═╡ 53f4d1ed-5d94-4905-9bb6-fa7b5c061a29
function _show(f::StaticBond)
	bond = f.bond
	id = f.id
	@htl """
	<span class='staticbond'>$bond<script id='$id'>
		$_preamble

		let bond = parent.firstElementChild
		let element = bond.firstElementChild
		let run_btn = currentScript.nextElementSibling
		
		parent.value = element.reactive ?? get_input_value(element)

		run_btn.addEventListener('click', (e) => {
			parent.value = element.reactive ?? get_input_value(element)
			parent.dispatchEvent(new CustomEvent('input'))
		})
	</script><span class='icon run extra_item' title='Trigger a manual update of the bond value'></span></span>
	<style>
		.staticbond {
			display: contents;
		}
		.staticbond > .bond {
			display: contents;
		}
		.staticbond.hide_extra .extra_item {
			display: none !important;
		}
		.staticbond > .icon.run { 	
			--size: 20px;
	 		display: inline-block;
			cursor: pointer;
			margin: 0 0;	
			background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/arrow-redo-circle-outline.svg");
		}
	</style>
"""
end

# ╔═╡ 7c595938-0528-406b-ac16-3a63b511fec5
md"""
## style
"""

# ╔═╡ 2a41ac09-d2e9-4bdc-87e6-ad020b013595
_style = (@htl """
<style>
	span.flexiwrapper > input.mode {
		cursor: pointer;
		--size: 15px;
		position: relative;
		width: calc(2*var(--size));
		height: var(--size);
		appearance: none;
		background: #c6c6c6;
		outline: none;
		border-radius: calc(var(--size)/2);
		box-shadow: inset 0 0 calc(var(--size)/8) rgba(0,0,0,.2);
		margin: 0 10px;
	}
	span.flexiwrapper > input:checked.mode {
		background: #4BD865;
	}
	span.flexiwrapper > input.mode:before {
		content: '';
		position: absolute;
		width: var(--size);
		height: var(--size);
		border-radius: 50%;
		top: 0px;
		left: 0px;
		background: #fff;
		transform: scale(1.1);
		box-shadow: 0 calc(var(--size)/20) calc(var(--size)/8) rgba(0,0,0,.2);
		transition: .1s;
	}
	span.flexiwrapper > input:checked.mode:before {
		left: var(--size)
	}
</style>
""");

# ╔═╡ 10bd6ad3-4d0a-4d27-a40c-a160394160af
function _show(f::FlexiWrapper)
	el = f.element
	id = f.id
	@htl """
<span class='flexiwrapper' id='$id' style='display: contents'>$el
<script id='$id'>
	$_preamble
	
	let element = parent.firstElementChild
	let event_type = eventof(element)

	let setDisabled = false
	let enableSet = _.debounce(() => {
		setDisabled = false
	}, 500)

	
	let mode_btn = this ?? html`<input type="checkbox" class='mode extra_item' checked>`
	if (this == null) {
		mode_btn.default = mode_btn.reactive = get_input_value(element)
	} else {
		set_input_value(element, mode_btn.reactive)
	}
	parent.reactive = mode_btn.reactive

	// inputHandler
	function inputHandler() {
		let val = parent.reactive = mode_btn.reactive = get_input_value(element)
			let inputs = document.querySelectorAll('span.flexiwrapper[id=$id]')
			inputs.forEach(p => {
				if (p != parent) {
					p.querySelector('input.mode').reactive = p.reactive = val
					set_input_value(p.firstElementChild, val)
				}
			})
		if (!mode_btn.checked) {
		} else if (mode_btn.default != val) {
			mode_btn.default = val
			parent.dispatchEvent(new CustomEvent('input'))
		}	
	}

	const toggle_mode_btn = (flag) => {
		mode_btn.title = flag
			?
			'The bond value is reactively updated as normal. Click this button to switch to manual update mode.'
			: 
			'The bond value is not updated unless the update icon to the right is clicked. Click this button to switch to reactive update mode.'
		mode_btn.checked = flag
	}

	Object.defineProperty(parent,'value', {
		get: () => {
			return mode_btn.default
		},
		set: (newVal) => {
			if (newVal == undefined || setDisabled) return
			mode_btn.default = newVal
			if (mode_btn.checked) set_input_value(element, newVal)
		},
		configurable: true
	})

	parent.toggle_mode_btn = toggle_mode_btn

	const clickHandler = e => {
		e.stopPropagation()
		let all_inputs = document.querySelectorAll(`span.flexiwrapper[id='\${$id}']`)
		let new_flag = mode_btn.checked
		all_inputs.forEach(input => {
			if (input != parent) input.toggle_mode_btn(new_flag)
		})
		inputHandler()
	}
	
	mode_btn.addEventListener('input', clickHandler)


	element.addEventListener(event_type, (e) => {
		e.stopPropagation()
		setDisabled = true
		enableSet()
		inputHandler()
	})

	invalidation.then(() => {
		mode_btn.removeEventListener('input', clickHandler)
	})
	
	return mode_btn
</script></span>
$_style
"""
end

# ╔═╡ 9e26f37e-d272-42a2-8bb9-f2ca097838fb
Base.show(io::IO, mime::MIME"text/html", f::Union{FlexiWrapper, StaticBond}) = show(io, mime, _show(f))

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
AbstractPlutoDingetjes = "6e696c72-6542-2067-7265-42206c756150"
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
AbstractPlutoDingetjes = "~1.1.4"
HypertextLiteral = "~0.9.4"
PlutoDevMacros = "~0.4.8"
PlutoUI = "~0.7.48"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.0-beta3"
manifest_format = "2.0"
project_hash = "f4d870e97814c459000b597b650f9edd00acf5d9"

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
git-tree-sha1 = "cceb0257b662528ecdf0b4b4302eb00e767b38e7"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.5.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.0"

[[deps.PlutoDevMacros]]
deps = ["HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Random", "Requires"]
git-tree-sha1 = "b4b23b981704ac3e2c771a389c2899e69306c091"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.4.8"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "efc140104e6d0ae3e7e30d56c98c4a927154d684"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.48"

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
git-tree-sha1 = "e59ecc5a41b000fa94423a578d29290c7266fc10"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.4.0"

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
# ╠═6303ec9e-7084-456c-a994-774b1f1fea0e
# ╠═870bd8b3-812b-4570-b2eb-4be19584f45e
# ╠═888c268f-a8ed-43fd-8692-370a0a50b249
# ╠═6d5701c6-30e5-4b8e-94b2-fd0bd1fdd129
# ╠═afc972ef-802c-472a-8b89-c963a7c402f7
# ╠═9edb3e2e-17a3-41fd-8c03-cfb73be0e987
# ╠═73aaf8a6-1956-4bda-a12e-c7c25cbdc3ee
# ╟─a82a6f30-ca93-4770-8d3e-9c0f890b9c1c
# ╟─02ce7546-935b-4f24-be88-91bf3f00aa36
# ╠═10bd6ad3-4d0a-4d27-a40c-a160394160af
# ╠═da92a4d3-7b0d-447e-9d7c-305f890f6efa
# ╠═73bcdcb7-a40e-4b39-b4fc-d3909a82f271
# ╠═b4f38258-4079-42c7-898f-3b6704d17a49
# ╠═8da1ebcf-a180-4705-8026-e6a5310f3ed8
# ╠═9e26f37e-d272-42a2-8bb9-f2ca097838fb
# ╠═bef96792-dccc-4ae5-a515-0f1513b6085e
# ╠═cd5fabf1-ba09-4e14-9ea4-ae34b6b12935
# ╠═5a732ec3-4dd3-4c38-b3ce-45177e39049b
# ╠═3e88a85e-1f04-45db-bca8-17e991ab95ba
# ╠═24237ad1-3dbb-480a-9201-bb6ac9dba053
# ╟─1e1becd2-bc0d-4cbc-9ee3-e0930f5cd35c
# ╠═53f4d1ed-5d94-4905-9bb6-fa7b5c061a29
# ╠═8e512166-16b5-4474-915d-e370bd9c6fa3
# ╠═4f1ce88a-188f-4f20-b2a4-14edb11f52d3
# ╠═1973e468-51f7-4a89-b7d2-5e92261df300
# ╠═0f4cefed-9652-44a3-97c7-a8de930d79e5
# ╠═db895645-a107-4c32-b808-08f48778f16c
# ╠═5a545e44-f732-467e-bae6-4544c8d2b49f
# ╠═de95468b-c49a-49ec-bb80-175eca04a6cf
# ╠═80155d1c-f2b3-4345-aade-960e2c2802ee
# ╠═aedd6f98-da1a-401c-9d54-37125146dfdb
# ╠═fe198de7-9ddb-4d42-9251-9cee16c3cbbe
# ╠═2fb1bd81-612c-465b-a0b3-07128f8e794e
# ╠═0435001d-3ab2-41ff-813e-b5487aaa7357
# ╠═64219202-d6d2-4d76-87fc-3cb01e9f8bd2
# ╠═f3af3238-ba1d-45f4-b9d6-a652a039b561
# ╠═dd1a1e32-61ef-4065-bf2d-9dc798e2fde9
# ╠═5febe0d1-7d07-4252-a060-e156f0d81c5e
# ╠═93658b61-3d8c-4d9d-b8cc-4c86cc716ff9
# ╠═8635fc03-769b-4404-81aa-3c01620bd792
# ╠═94c3741d-43d3-4a57-b88b-ca660cbb7e94
# ╠═32a12484-79ad-4179-a0ef-3dbbe259cdf3
# ╠═96d72536-1cf0-4b31-b659-edb008f5bbdc
# ╠═7c595938-0528-406b-ac16-3a63b511fec5
# ╠═2a41ac09-d2e9-4bdc-87e6-ad020b013595
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
