### A Pluto.jl notebook ###
# v0.17.2

# using Markdown
# using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 6efb9ff0-52e7-11ec-2a4d-b788e3955703
begin
	using OrderedCollections
	using HypertextLiteral
	using PlutoUI
end

# ╔═╡ ecd45d5d-40c7-4ebe-b541-4bffa3b7abd5
#=╠═╡ notebook_exclusive
md"""
# Packages
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 695dfef3-f0d3-43d7-9d83-38c1a94cec89
#=╠═╡ notebook_exclusive
import PlutoUtils
  ╠═╡ notebook_exclusive =#

# ╔═╡ 7719b308-c856-4419-b700-be6feb4d3115
#=╠═╡ notebook_exclusive
PlutoUtils.ToC()
  ╠═╡ notebook_exclusive =#

# ╔═╡ 54a91ec9-de06-43e8-b4ef-8f436292f749
#=╠═╡ notebook_exclusive
"""
	position_fixed(x;zindex = 500, kwargs...)
Puts the content of x in a separate div that is given the style of position: fixed.
This can be used to have some cell output fixed on the viewport (for example for a table of bonds/parameters) so that one has easy access to the various parameters.

All the values that are passed as kwargs are copied in the css style of the div as `name: value;`.
"""
function position_fixed(x;zindex = 500, kwargs...)
id = "fixed_div_$(rand(Int))"

io = IOBuffer()
for (n,v) ∈ kwargs
	if v !== nothing
		println(io,"$n: $v;")
	end
end
style = String(take!(io))
@htl """
<div id=$id>
	$x
</div>
<style>
	#$id {
		position: fixed;
		$style
		z-index: $zindex;
	}
</style>
"""
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ 278449d8-b67d-4ca9-9910-e19836e42a93
#=╠═╡ notebook_exclusive
md"""
# Exports
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 48414943-3a16-4826-8098-19089ed00646
#=╠═╡ notebook_exclusive
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
  ╠═╡ notebook_exclusive =#

# ╔═╡ 0b14e883-7548-4f65-a789-3cde165cc240
#=╠═╡ notebook_exclusive
md"""
# BondWrapper definition
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 564f1605-72cf-460a-9b8a-00277b12be8b
struct BondWrapper{B}
	description::String
	cell_id::String
	bond::B # This is supposed to be a Bond, but I don't know how to have the type without importing Pluto
end

# ╔═╡ 90b11594-8b04-41c6-9a53-b1de98f71de2
const BondTable = LittleDict{String, <:BondWrapper}

# ╔═╡ 0d106c02-717a-4665-b211-76962bc054ae
function Base.getproperty(b::BondWrapper, s::Symbol)
	if s in fieldnames(BondWrapper)
		getfield(b,s)
	else
		getfield(getfield(b,:bond),s)
	end
end

# ╔═╡ 685e1202-a553-4fcd-ae9d-152b92aede9f
#=╠═╡ notebook_exclusive
md"""
# Show Methods
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 1defc7ea-501c-40a2-b311-c2d171a09401
#=╠═╡ notebook_exclusive
md"""
## table_row
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 44cc8f3b-d633-47d4-b39b-7ea299ffe281
function table_row(b::BondWrapper, addbutton = false)
	out = @htl """
		<td class='bondtable_desc'>
			$(b.description):
		</td>
		<td class='bondtable_bond'>
			$(b.bond)
		</td>
	"""
	if addbutton
		out = @htl """
			<td class='bondtable_link'>
				<span class='bondtable_icon bondcell_link' cellref=$(b.cell_id)></span>
			</td>
			$out
		"""
	end
	@htl """
	<tr class='bond_table_row'>
		$out
	</tr>
	"""
end

# ╔═╡ 7eea8ae9-8d6c-448c-841d-dc9639244fb5
Base.show(io::IO, m::MIME"text/html", b::BondWrapper) = show(io,m,@htl """
<table>
	$(table_row(b, false))
</table>
""")

# ╔═╡ c74801ab-de4e-4748-aec8-339d56789506
#=╠═╡ notebook_exclusive
md"""
## Main Method
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ ce661fec-c1b5-4150-b863-c42e47defd0a
#=╠═╡ notebook_exclusive
md"""
## show_bondsdict
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 72841851-4303-4b33-842b-d6812737023e
function show_bondsdict(d::BondTable; name = "Parameters", class = nothing, id = nothing)
	out = @htl ""
	for (n,v) ∈ d
		out = @htl "$(out)$(table_row(v,true))"
	end
	# Add the header
	out = @htl """
	<table id=$id class='bondtable $class'>
		<tr class='bondtable_header'>
			<th class='bondtable_link'><span class='bondtable_icon bondtable_show_link'></span></th>
			<th class='bondtable_name' colspan=2>$name</th>
		</tr>
		$out
	</table>
	<script>
		const cell = currentScript.closest('pluto-cell')
		const show_id = cell.id

		const table = cell.querySelector('table')
		const rerun_btn = table.querySelector('input[value="rerun"]')

		table.addEventListener('keydown', (e) => {
			if (e.ctrlKey && e.key == 'Enter') {
				rerun_btn.click()
			}
			
		})
		
		const cell_jump = id => {
			const func = (e) => {
				const tocell = document.getElementById(id)
				history.pushState({},'')			
				tocell.scrollIntoView({
					behavior: 'smooth',
					block: 'center',				
				})
			}
			return func
		}

		const refresh_button = cell.querySelector('.bondtable_show_link')
		refresh_button.addEventListener('click',cell_jump(show_id))
		const cellrefs = cell.querySelectorAll('.bondcell_link')


		for (const but of cellrefs) {
			const cell_id = but.getAttribute('cellref')
			but.addEventListener('click', cell_jump(cell_id))
		}

	</script>
	<style>
		.bondtable_icon {    
			display: inline-block;
			--size: 17px;
		    width: var(--size);
		    height: var(--size);
		    background-size: var(--size) var(--size);
		    background-position: center;
		    background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/at-circle-outline.svg");
		}
		.bondtable_icon:hover {
			cursor: pointer;
		}	
	</style>
	"""
end

# ╔═╡ 93283b1f-3f5d-436e-bdb8-8fa755871466
Base.show(io::IO, m::MIME"text/html", d::BondTable) = show(io, m, show_bondsdict(d))

# ╔═╡ ad60610b-aebb-454a-9e33-bb8affb0d484
#=╠═╡ notebook_exclusive
md"""
## Clean Dictionary
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 4ee12b02-a0bb-4216-a9cf-92bcb89e664f
# Remove entries that are associated with variables that don't exist anymore
function clean_dict!(d, mod)
	for (n,v) ∈ d
		isdefined(mod,v.defines) || delete!(d,n)
	end
end

# ╔═╡ f9dc72b6-d9d1-4777-94fe-942e9b1a2635
#=╠═╡ notebook_exclusive
md"""
## update\_show
"""
  ╠═╡ notebook_exclusive =#

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
#=╠═╡ notebook_exclusive
md"""
# Macros definitions
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ ea30c6b9-d55a-4257-8344-347d5060c0c8
function splitdef(name::Expr)
	if name.head !== :ref || !(name.args[2] isa String)
		error("The provided expression must be in the form name[description] as first argument, where description must be a string")
	end
	dictname, desc = name.args
	bname = Symbol("_#params_button_$dictname")
	dictname, desc, bname
end

# ╔═╡ 957927ab-0c60-4557-b550-23b14546fa6a
classname(dictname::Symbol) = "$(dictname)"

# ╔═╡ 5a5bf586-8987-49b7-af82-1fc7ae7d8c33
#=╠═╡ notebook_exclusive
md"""
## @bondsdict
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 420d8430-b5bd-485e-b164-a1fecebc4700
macro bondsdict(s::Symbol)
	# Button name and bond name
	bname = Symbol("_#params_button_$s")
	# Find the cell_id of the macrocall where this bond is defined
	cell_id = split(__source__.file::Symbol |> String,"#==#") |> last |> String
	quote
		$s = PlutoUtils.LittleDict("__rerun_button__" => PlutoUtils.BondWrapper("Rerun non-reactive bonds" ,$cell_id, @bind $bname Button("rerun")))
		$s["__rerun_button__"]
	end |> esc
end

# ╔═╡ 5e5b7c87-4f0b-4826-b25c-b71028c9ec90
#=╠═╡ notebook_exclusive
md"""
## @showbonds
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ a5785b34-577b-467d-96eb-b376477c58f2
macro showbonds(dictname::Symbol, name::String = "Parameters")
	class = classname(dictname)
	quote
		# Clean the dict of unused vars
		PlutoUtils.clean_dict!($dictname, $(__module__))
		# Show the dict in a table
		PlutoUtils.show_bondsdict($dictname; name = $name, class = $class)
	end |> esc
end

# ╔═╡ c0105f4e-632e-405a-b59d-25eaf17767ef
#=╠═╡ notebook_exclusive
md"""
## @addbond
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 6b856cef-0b95-48f6-8077-96eff0928b20
macro addbond(name, bondvalue)
	dictname, desc, _ = splitdef(name)
	symbolname = Symbol(:_params_,dictname,:_,gensym()) # We append a _ so pluto doesn't filter this variable
	# Find the cell_id of the macrocall where this bond is defined
	cell_id = split(__source__.file::Symbol |> String,"#==#") |> last |> String
	dict = getfield(__module__,dictname) # We do this to check for existing keys, should find a better way
	if haskey(dict, desc) && dict[desc].cell_id !== cell_id
		error("The provided key/description is already present in the dict and defined in another cell, please change the definition from that cell")
	end
	quote
		$dictname[$desc] = PlutoUtils.BondWrapper($desc ,$cell_id, @bind $symbolname $bondvalue)
		PlutoUtils.update_show($dictname, $desc, $(".bondtable."*classname(dictname)))
	end|> esc
end

# ╔═╡ b1f64f22-da01-45c0-a2f8-48cb6673d473
#=╠═╡ notebook_exclusive
md"""
## @getbond, @getbond_reactive
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 0bfaa239-75a1-47da-9cc1-e6b596190ec8
function _getbond_reactive_expr(name, mod)
	dictname, desc, _ = splitdef(name)
	# For the reactivity we still assume the dict is in global scope and access it, to check if it can be done elseway
	dict = getfield(mod,dictname)
	symbol = dict[desc].defines
end

# ╔═╡ fa1b5db7-5d3b-4e9b-bd08-8e11c1e84305
function _getbond_expr(name, mod)
	dictname, desc = splitdef(name)
	# To be able to correctly get the module I have this obscue eval call to :(@__MODULE__) otherwise the @__MODULE__ is only expanded at compile time and when re-running it doesn't work
	:(getfield(eval(:(@__MODULE__)), $dictname[$desc].defines))
end

# ╔═╡ 772ee1a0-a460-47c9-b572-87c9813c0ef1
macro getbond_reactive(names...)
	ex = Expr(:tuple)
	for nm ∈ names
		push!(ex.args, _getbond_reactive_expr(nm, __module__))
	end
	if length(names) == 1
		ex = ex.args[1]
	end
	esc(ex)
end

# ╔═╡ 59c09e9a-a26b-45c3-9c17-25eeb78208d9
macro getbond(names...)
	ex = Expr(:tuple, )
	_, _, bname = splitdef(names[1])
	for nm ∈ names
		push!(ex.args, _getbond_expr(nm, __module__))
	end
	if length(names) == 1
		ex = ex.args[1]
	end
	Expr(:block, bname, ex) |> esc
end

# ╔═╡ f88ad8a5-8875-41b8-9680-8de93c27948d
begin
	# export BondWrapper, LittleDict
	export @bondsdict, @showbonds, @addbond, @getbond, @getbond_reactive
end

# ╔═╡ ca5fbe4a-14c2-4770-a12d-5ff35ffe496f
#=╠═╡ notebook_exclusive
@bondsdict params
  ╠═╡ notebook_exclusive =#

# ╔═╡ 811197c7-af34-424f-b129-bb14a4478019
#=╠═╡ notebook_exclusive
position_fixed(@showbonds params; top = "20px", left = "20px", width = "25%")
  ╠═╡ notebook_exclusive =#

# ╔═╡ f7d1c223-ef9a-431d-9847-56c7ad9f1214
#=╠═╡ notebook_exclusive
@addbond params["Magic"] Slider(1:10)
  ╠═╡ notebook_exclusive =#

# ╔═╡ b00dfdba-e624-4a8c-b87e-6921aec4244e
#=╠═╡ notebook_exclusive
@addbond params["ASD"] Slider(1:10)
  ╠═╡ notebook_exclusive =#

# ╔═╡ 907f68d9-0f31-43c7-9b5c-deaedba3f3dd
#=╠═╡ notebook_exclusive
@addbond params["Fancy Select"] Select([Int => "Int", Float32 => "Float32", Float64 => "Float64"])
  ╠═╡ notebook_exclusive =#

# ╔═╡ 2ec714d2-6f4f-476a-8935-52902ad013ad
#=╠═╡ notebook_exclusive
@addbond params["Editable"] PlutoUtils.Editable(15)
  ╠═╡ notebook_exclusive =#

# ╔═╡ cae2cfac-91d0-4f1a-8831-d91c37c5df05
#=╠═╡ notebook_exclusive
let 
	a,b,c = @getbond params["Magic"] params["ASD"] params["Fancy Select"]
	c(a+b)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ d336773d-e139-427a-a868-ad8887522cd5
#=╠═╡ notebook_exclusive
let 
	a,b,c = @getbond_reactive params["Magic"] params["ASD"] params["Fancy Select"]
	c(a+b)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
OrderedCollections = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
PlutoUtils = "ed5d0301-4775-4676-b788-cf71e66ff8ed"

[compat]
HypertextLiteral = "~0.9.3"
OrderedCollections = "~1.4.1"
PlutoUI = "~0.7.21"
PlutoUtils = "~0.5.2"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-rc2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "abb72771fd8895a7ebd83d5632dc4b989b022b5b"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Chain]]
git-tree-sha1 = "cac464e71767e8a04ceee82a889ca56502795705"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.4.8"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Crayons]]
git-tree-sha1 = "3f71217b538d7aaee0b69ab47d9b7724ca8afa0d"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.0.4"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.Glob]]
git-tree-sha1 = "4df9f7e06108728ebf00a0a11edee4b29a482bb2"
uuid = "c27321d9-0574-5035-807b-f59d2c89b15c"
version = "1.3.0"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "8076680b162ada2a031f707ac7b4953e30667a37"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.2"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlutoDevMacros]]
deps = ["MacroTools", "Requires"]
git-tree-sha1 = "f5cbbcaa26fe68fd63bc25f5a9e626b7f0e515b0"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.4.4"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "b68904528fd538f1cb6a3fbc44d2abdc498f9e8e"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.21"

[[deps.PlutoUtils]]
deps = ["Chain", "Glob", "HypertextLiteral", "OrderedCollections", "PlutoDevMacros", "PlutoUI", "PrettyTables", "Reexport", "Requires", "StaticArrays", "UUIDs"]
git-tree-sha1 = "c44cc3fe250c4339264f1b09a0c843d3885172b2"
uuid = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
version = "0.5.2"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

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
git-tree-sha1 = "4036a3bd08ac7e968e27c203d45f5fff15020621"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.1.3"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "3c76dde64d03699e074ac02eb2e8ba8254d428da"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.2.13"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "TableTraits", "Test"]
git-tree-sha1 = "fed34d0e71b91734bf0a7e10eb1bb05296ddbcd0"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.6.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
"""

# ╔═╡ Cell order:
# ╟─ecd45d5d-40c7-4ebe-b541-4bffa3b7abd5
# ╠═6efb9ff0-52e7-11ec-2a4d-b788e3955703
# ╠═695dfef3-f0d3-43d7-9d83-38c1a94cec89
# ╠═7719b308-c856-4419-b700-be6feb4d3115
# ╠═54a91ec9-de06-43e8-b4ef-8f436292f749
# ╟─278449d8-b67d-4ca9-9910-e19836e42a93
# ╠═f88ad8a5-8875-41b8-9680-8de93c27948d
# ╠═48414943-3a16-4826-8098-19089ed00646
# ╠═90b11594-8b04-41c6-9a53-b1de98f71de2
# ╟─0b14e883-7548-4f65-a789-3cde165cc240
# ╠═564f1605-72cf-460a-9b8a-00277b12be8b
# ╠═0d106c02-717a-4665-b211-76962bc054ae
# ╠═7eea8ae9-8d6c-448c-841d-dc9639244fb5
# ╟─685e1202-a553-4fcd-ae9d-152b92aede9f
# ╟─1defc7ea-501c-40a2-b311-c2d171a09401
# ╠═44cc8f3b-d633-47d4-b39b-7ea299ffe281
# ╟─c74801ab-de4e-4748-aec8-339d56789506
# ╠═93283b1f-3f5d-436e-bdb8-8fa755871466
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
# ╠═a5785b34-577b-467d-96eb-b376477c58f2
# ╟─c0105f4e-632e-405a-b59d-25eaf17767ef
# ╠═6b856cef-0b95-48f6-8077-96eff0928b20
# ╟─b1f64f22-da01-45c0-a2f8-48cb6673d473
# ╠═0bfaa239-75a1-47da-9cc1-e6b596190ec8
# ╠═fa1b5db7-5d3b-4e9b-bd08-8e11c1e84305
# ╠═772ee1a0-a460-47c9-b572-87c9813c0ef1
# ╠═59c09e9a-a26b-45c3-9c17-25eeb78208d9
# ╠═ca5fbe4a-14c2-4770-a12d-5ff35ffe496f
# ╠═811197c7-af34-424f-b129-bb14a4478019
# ╠═f7d1c223-ef9a-431d-9847-56c7ad9f1214
# ╠═b00dfdba-e624-4a8c-b87e-6921aec4244e
# ╠═907f68d9-0f31-43c7-9b5c-deaedba3f3dd
# ╠═2ec714d2-6f4f-476a-8935-52902ad013ad
# ╠═cae2cfac-91d0-4f1a-8831-d91c37c5df05
# ╠═d336773d-e139-427a-a868-ad8887522cd5
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
