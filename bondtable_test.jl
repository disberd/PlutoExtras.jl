### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : missing
        el
    end
end

# ╔═╡ c1e79b08-c9fe-4d0c-9266-a9fe364b2119
begin
	using PlutoUtils
	using HypertextLiteral
end

# ╔═╡ b30c5506-5385-497a-b5a3-707112bcfa80
md"## Define Parameters (Bonds)"

# ╔═╡ a33a6799-ce3d-4f03-9ca2-8fefa6723adf
bonds_dict = Dict{String,Dict{String,Main.PlutoRunner.Bond}}()

# ╔═╡ 43a30718-e688-4201-b66c-234fbed876bd
table_bond_dict = Dict{String,HypertextLiteral.Result}(); 

# ╔═╡ e9c113f1-3137-412e-a63f-4d9f8e8e2275
params_ref = Ref{NamedTuple}()

# ╔═╡ ad0a6274-e659-4038-b9a2-7f4bf4c72543
table_bond_dict["Test"] = table_bond_dict["Power"]

# ╔═╡ e5f1da69-d325-4d0e-a7ac-cc8527e034a2
md"## Editable Widget"

# ╔═╡ dc61cc8d-74ad-4753-a747-569f941d720d
# Editable is basical a copy of the Scrubbable widget from PlutoUI, but allows to have data that can be given with keyboard input
begin	
	Base.@kwdef struct Editable
		default::Real
		format::Union{AbstractString,Nothing}=nothing
		prefix::AbstractString=""
		suffix::AbstractString=""
	end
	Editable(x::Number; kwargs...) = Editable(; default=x, kwargs...)
	
	Base.get(s::Editable) = s.default
	
	function Base.show(io::IO, m::MIME"text/html", s::Editable)
		format = if s.format === nothing
			# TODO: auto format
			if eltype(s.default) <: Integer
				""
			else
				".4~g"
			end
		else
			String(s.format)
		end

		write(io, """
        
		<script>

			const d3format = await import("https://cdn.jsdelivr.net/npm/d3-format@2/+esm")

			const elp = html`
			<span style="
			touch-action: none;
			background: rgb(175, 222, 253);
			padding: 0em .2em;
			border-radius: .3em;
			font-weight: bold;">$((s.prefix))<span contentEditable=true>$(s.default)</span>$((s.suffix))</span>
			`

			const formatter = s => d3format.format($(repr(format)))(s)
			const el = elp.querySelector("span")

			let localVal = parseFloat($(s.default))
			el.innerText = formatter($(s.default))
			
			Object.defineProperty(elp,"value",{
				get: () => localVal,
				set: x => {
					localVal = parseFloat(x)
					el.innerText = formatter(x)
				}
			})

			// Function to blur the element when pressing enter instead of adding a newline
			const onEnter = (e) => {
				if (e.keyCode === 13) {
				e.preventDefault();
				if (el.innerText === "") {
					elp.value = $(s.default)   
				} else {
					elp.value =  el.innerText
				}
				elp.dispatchEvent(new CustomEvent("input"))
				el.blur()
				}
			}

			el.addEventListener('input',(e) => {
				console.log(e)
				e.preventDefault()
				e.stopImmediatePropagation()
			})

			function selectText(el){
				var sel, range;
				if (window.getSelection && document.createRange) { //Browser compatibility
				sel = window.getSelection();
				if(sel.toString() == ''){ //no text selection
					window.setTimeout(function(){
						range = document.createRange(); //range object
						range.selectNodeContents(el); //sets Range
						sel.removeAllRanges(); //remove all ranges from selection
						sel.addRange(range);//add Range to a Selection.
					},1);
				}
				}else if (document.selection) { //older ie
					sel = document.selection.createRange();
					if(sel.text == ''){ //no text selection
						range = document.body.createTextRange();//Creates TextRange object
						range.moveToElementText(el);//sets Range
						range.select(); //make selection.
					}
				}
			}

			el.addEventListener('keydown',onEnter)
			elp.addEventListener('click',(e) => {
				//el.innerText = ""
				selectText(el)
				el.focus()
				el.select()
			})

			return elp

		</script>""")
	end
	
	Editable
end

# ╔═╡ 7a361c0e-6900-4cd0-92aa-685387efbd83
trigger_bond = @bind trigger Button("Trigger Calculation");

# ╔═╡ fc0d5547-5487-4d12-a314-9b3f835059e0
begin
	trigger
	params = params_ref[]
end

# ╔═╡ f901b817-a1c0-43d6-bd41-3a9c7f2f1edd
"Function that takes as input a Dict that associates String (names of parameters) to Pluto Bonds an create a nice table to have easy access the the values for modification"
function parameters_table(dict;head_name="Parameters",kwargs...)
	# Define the header of the table
	head = @htl("""
	<tr><th colspan="2"> $head_name
	<tr><th>Name <th>Value
	""")
	
	out = @htl("$head")
	
	# Populate the rows
	for (k,v) ∈ pairs(dict)
		out = @htl("""
			$out
			<tr>
				<td>$k
				<td>$v
			""")
	end
	
	# Put the table tag around
	out = @htl("""
		<table style="margin=2em; flex: 0 0 12em;">
			$out
		</table>
		""")
	
	out
end

# ╔═╡ 7082a9d5-b0e9-4085-b7b7-3379927c1596
# Power parameters
bonds_dict["Power"],table_bond_dict["Power"] = let
	dict = Dict{String,Main.PlutoRunner.Bond}()
	dict["ADC DC power per GHz"] = @bind ADC_W_pGHz Editable(2,suffix=" W/GHz")
	dict["LNA DC power per element"] = @bind LNA_W_pel Editable(.5,format=".2~s",suffix="W")
	dict["Amplifier Efficiency"] = @bind amp_eff Editable(.5,format=".1~%")

	# Generate the table
	table = parameters_table(dict;head_name="Power Consumption")
	(dict,table)
end;

# ╔═╡ c11e109f-d139-47c8-b77e-36f6450a1e48
# Mass parameters
bonds_dict["Mass"],table_bond_dict["Mass"] = let
	dict = Dict{String,Main.PlutoRunner.Bond}()
	dict["ADC mass per GHz"] = @bind ADC_g_pGHz Editable(500,format=".2~s",suffix="g/GHz")
	dict["LNA mass per element"] = @bind LNA_g_pel Editable(1000,format=".2~s",suffix="g")
	# Generate the table
	table = parameters_table(dict;head_name="Mass")
	(dict,table)
end;

# ╔═╡ 6b15458f-44f0-476c-965e-f550117c5f0b
bonds_dict["Other"],table_bond_dict["Other"] = let
	dict = Dict{String,Main.PlutoRunner.Bond}()
	dict["Coverage Radius"] = @bind cov_deg Editable(3,suffix="˚")
	dict["Bandwidth"] = @bind Bu Editable(2e9;format=".2~s",suffix="Hz")
	dict["Single Antenna Flag"] = @bind single_antenna Editable(1;format=".0d")

	# Generate the table
	table = parameters_table(dict;head_name="Other")
	(dict,table)
end;

# ╔═╡ f26c2923-9146-47fd-b172-0d4f41b52d36
params_ref[] = (
	ADC_W_pGHz = ADC_W_pGHz,
	LNA_W_pel = LNA_W_pel,
	amp_eff = amp_eff,
	ADC_g_pGHz = ADC_g_pGHz,
	LNA_g_pel = LNA_g_pel,
	cov_deg = cov_deg,
	Bu = Bu,
	single_antenna = single_antenna
	)

# ╔═╡ 6aca033c-9eb2-43c3-9431-c8eb32ccb291
function table_merge(table_dict;names=keys(table_dict),button=nothing)
	
	out = @htl("")
	for k ∈ names
		out = @htl("""

				$out $(table_dict[k]) <span style="flex: 0 0 10px;"></span>

			""")
	end
	# Put this in a separate div
	out = @htl("""
		<div style="display: flex; align-items: center;justify-content: flex-start; overflow: auto;">
			$out
		</div>
		""")
	if button !== nothing
		# Add the button in a subsequent div
		out = @htl("""
			$out
			<div align='center'>
				$(@htl(button))
			</div>
			""")
	end
	# return @htl("""
	# 	<div align="center">
	# 		$out
	# 	</div>
	# 	""")
end

# ╔═╡ 2e8ce03b-44d9-4619-b255-e5ccf1d068f3
table_merge(table_bond_dict;button=trigger_bond)

# ╔═╡ Cell order:
# ╠═c1e79b08-c9fe-4d0c-9266-a9fe364b2119
# ╟─b30c5506-5385-497a-b5a3-707112bcfa80
# ╠═a33a6799-ce3d-4f03-9ca2-8fefa6723adf
# ╠═43a30718-e688-4201-b66c-234fbed876bd
# ╠═7082a9d5-b0e9-4085-b7b7-3379927c1596
# ╠═c11e109f-d139-47c8-b77e-36f6450a1e48
# ╠═6b15458f-44f0-476c-965e-f550117c5f0b
# ╠═e9c113f1-3137-412e-a63f-4d9f8e8e2275
# ╠═f26c2923-9146-47fd-b172-0d4f41b52d36
# ╠═7a361c0e-6900-4cd0-92aa-685387efbd83
# ╠═ad0a6274-e659-4038-b9a2-7f4bf4c72543
# ╠═2e8ce03b-44d9-4619-b255-e5ccf1d068f3
# ╠═fc0d5547-5487-4d12-a314-9b3f835059e0
# ╟─e5f1da69-d325-4d0e-a7ac-cc8527e034a2
# ╠═dc61cc8d-74ad-4753-a747-569f941d720d
# ╠═f901b817-a1c0-43d6-bd41-3a9c7f2f1edd
# ╠═6aca033c-9eb2-43c3-9431-c8eb32ccb291
