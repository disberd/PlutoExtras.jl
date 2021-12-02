### A Pluto.jl notebook ###
# v0.17.2

# using Markdown
# using InteractiveUtils

# ╔═╡ 8c4e16f0-7e73-4f5a-b0e3-c565a0b92f47
#=╠═╡ notebook_exclusive
using HypertextLiteral
  ╠═╡ notebook_exclusive =#

# ╔═╡ d1bba282-0212-4149-a24a-7b036a7a9458
#=╠═╡ notebook_exclusive
using PlotlyBase
  ╠═╡ notebook_exclusive =#

# ╔═╡ d64feb66-4cd5-4818-b912-1efebcdb8432
using UUIDs

# ╔═╡ 7799649c-d265-4042-a4cb-16e376d4ea45
using StaticArrays

# ╔═╡ f0aae837-cf93-46df-b204-d4ed57836d12
#=╠═╡ notebook_exclusive
md"""
# Packages
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ ab8c40b4-982c-4063-b209-177a9b72e527
#=╠═╡ notebook_exclusive
import PlutoUtils
  ╠═╡ notebook_exclusive =#

# ╔═╡ caa6aad3-50ab-4041-ab27-525ec9ec56ee
#=╠═╡ notebook_exclusive
PlutoUtils.TableOfContents()
  ╠═╡ notebook_exclusive =#

# ╔═╡ 3c3d991b-6970-495b-8d80-d3c42b7c9617
#=╠═╡ notebook_exclusive
md"""
## Mixed Utils
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ c5f520f4-c26c-4ec8-90b5-6e74375cf9d7
#=╠═╡ notebook_exclusive
PlutoUtils.toggle_htmlmixed_shortcut()
  ╠═╡ notebook_exclusive =#

# ╔═╡ c27179fa-c2c0-45a2-afbf-8350d817ef08
#=╠═╡ notebook_exclusive
PlutoUtils.hide_cell_shortcut()
  ╠═╡ notebook_exclusive =#

# ╔═╡ 2dfdbd07-15fc-4a43-8849-d0154bf2192e
#=╠═╡ notebook_exclusive
md"""
# Show implementation
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ e093832c-d490-4468-97ee-e902b24a3e44
begin
	plotlylower(x) = x
	plotlylower(x::Vector{<:Number}) = x
	plotlylower(x::AbstractVector) = Any[plotlylower(z) for z in x]
	plotlylower(x::AbstractMatrix) = Any[plotlylower(r) for r in eachrow(x)]
	plotlylower(d::Dict) = Dict(
		k => plotlylower(v)
		for (k,v) in d
	)
end

# ╔═╡ 84560ed3-1ea7-4eb8-8db1-99eaa5219dd2
to_js(x) = HypertextLiteral.JavaScript(Main.PlutoRunner.publish_to_js(plotlylower(x)))

# ╔═╡ f7dfb8b4-bcbd-4aed-8af0-c2ea37c1ac90
#=╠═╡ notebook_exclusive
show1(plt::PlotlyBase.Plot) = @htl("""
			<div>
			<script id=asdf>
			const {plotly} = await import("https://cdn.plot.ly/plotly-2.2.0.min.js")
			const PLOT = this ?? document.createElement("div");
		
			if (this == null) {
		
				Plotly.newPlot(PLOT, $(HypertextLiteral.JavaScript(PlotlyBase.json(plt))));


			} else {				
				Plotly.react(PLOT, $(to_js((map(plt.data) do x x.fields end))),$(to_js(plt.layout.fields)));
			}
		
			const pluto_output = currentScript.parentElement.closest('pluto-output')

			const resizeObserver = new ResizeObserver(entries => {
				Plotly.Plots.resize(PLOT)
			})

			resizeObserver.observe(pluto_output)

			invalidation.then(() => {
				resizeObserver.disconnect()
			})
		
			return PLOT
			</script>
			</div>
""")
  ╠═╡ notebook_exclusive =#

# ╔═╡ 740bcc3f-5304-4f8e-9324-af1f392b13a6
function show2(plt::PlotlyBase.Plot) 
	hasproperty(plt,:config) && plt.config.responsive && (plt.config.responsive = false)
	# script_id = "pluto-script-" * string(uuid4())
	script_id = "pluto-plotly-plot"
	@htl("""
			<div>
			<script id=$script_id>
			const {plotly} = await import("https://cdn.plot.ly/plotly-2.5.1.min.js")
			const PLOT = this ?? document.createElement("div");
		

		
			Plotly.react(PLOT, $(HypertextLiteral.JavaScript(PlotlyBase.json(plt))));


		
			const pluto_output = currentScript.parentElement.closest('pluto-output')

			const resizeObserver = new ResizeObserver(entries => {
				Plotly.Plots.resize(PLOT)
			})

			resizeObserver.observe(pluto_output)

			invalidation.then(() => {
				resizeObserver.disconnect()
			})
		
			return PLOT
			</script>
			</div>
""")
end

# ╔═╡ e389da42-7f04-4bad-acc5-334a4277e5ac
function Base.show(io::IO, mimetype::MIME"text/html", plt::PlotlyBase.Plot)
		show(io,mimetype, show2(plt))
end

# ╔═╡ 0c835811-ec85-4f91-8a33-536256ac281d
#=╠═╡ notebook_exclusive
lon0 = 195
  ╠═╡ notebook_exclusive =#

# ╔═╡ 943c3293-fba2-44f5-9e61-2f821bd5c65e
#=╠═╡ notebook_exclusive
let
	lat = zeros(181)
	lon = 0:180
	data = scattergeo(lat=lat,lon=lon,mode="lines")
	layout = Layout(
		geo =  attr(
			projection =  attr(
				type =  "satellite",
				rotation =  attr(
					lon =  lon0,
					lat =  40
				),
			),
			showocean =  true,
			oceancolor =  "rgb(0, 255, 255)",
			showland =  true,
			landcolor =  "rgb(230, 145, 56)",
			showlakes =  true,
			lakecolor =  "rgb(0, 255, 255)",
			showcountries =  true,
			lonaxis =  attr(
				showgrid =  true,
				gridcolor =  "rgb(102, 102, 102)"
			),
			lataxis =  attr(
				showgrid =  true,
				gridcolor =  "rgb(102, 102, 102)"
			)
		)
	)
	Plot([data],layout)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ 01aef0a4-e96d-403d-be40-b118e6db614a
#=╠═╡ notebook_exclusive
function scattersatellite()
  # Markers for the satellites
  # Create the tracks for the past of each satellite
  # tracks = [
  #   scattergeo(
  #     lat = getfield.(pos_history[s,max(begin,t_index-20):t_index],:lat),
  #       lon = getfield.(pos_history[s,max(begin,t_index-20):t_index],:lon),
  #     mode = "lines",
  #     line_color = "red",
  #     showlegend = false,
  #     ) for s ∈ axes(pos_history,1)]

  # Create Amerca Box
  box = [
    scattergeo(
      # lat = [-35, 35, 35, -35,-35],
      lat = [-35:35;ones(size(collect(-120:-35)))*35;35:-1:-35;-35*ones(size(collect(-35:-1:-120)))],
        # lon = [-120,-120,-35,-35,-120],
        lon = [-120*ones(size(collect(-35:35)));-120:-35;-35*ones(size(collect(35:-1:-35)));-35:-1:-120],
      mode = "lines",
      line_color = "red",
      fill = "toself",
      fillcolor = "rgba(255,0,0,.9)",
      showlegend = false,
      )]
  
  # Create the geo layout
  layout = Layout(
    geo =  attr(
      projection =  attr(
        type =  "robinson",
      ),
      showocean =  true,
      # oceancolor =  "rgb(0, 255, 255)",
      oceancolor =  "rgb(255, 255, 255)",
      showland =  true,
      # landcolor =  "rgb(230, 145, 56)",
      landcolor =  "rgb(217, 217, 217)",
      showlakes =  true,
      # lakecolor =  "rgb(0, 255, 255)",
      lakecolor =  "rgb(255, 255, 255)",
      showcountries =  true,
      lonaxis =  attr(
        showgrid =  true,
        gridcolor =  "rgb(102, 102, 102)"
      ),
      lataxis =  attr(
        showgrid =  true,
        gridcolor =  "rgb(102, 102, 102)"
      )
    )
  )
  # Plot([mar,tracks...],layout)
  Plot([box...],layout)
end;
  ╠═╡ notebook_exclusive =#

# ╔═╡ 6d85da33-f8f4-4435-b572-991a0b6e5511
#=╠═╡ notebook_exclusive
scattersatellite()
  ╠═╡ notebook_exclusive =#

# ╔═╡ 55f63e7b-f81a-48ff-9857-a8cfd6b3c7dd
#=╠═╡ notebook_exclusive
html"""
<style>
main {
	max-width: min(1200px, calc(95% - 300px));
	margin-right: 300px !important;
}
</style>
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 0123b5ce-5455-4227-b916-3d1e1c814911
#=╠═╡ notebook_exclusive
c = 3
  ╠═╡ notebook_exclusive =#

# ╔═╡ 02583ec4-a758-47e6-aeea-f6d897b307bc
#=╠═╡ notebook_exclusive
a = rand(10,c)
  ╠═╡ notebook_exclusive =#

# ╔═╡ 37374eb5-075f-4ecc-ae91-472b55c18c6f
#=╠═╡ notebook_exclusive
p = Plot(a)
  ╠═╡ notebook_exclusive =#

# ╔═╡ c0ff610e-1370-456a-b955-d16b5032c199
#=╠═╡ notebook_exclusive
println("Loaded plotly_show")
  ╠═╡ notebook_exclusive =#

# ╔═╡ f4d9e48f-f9fe-4587-b855-f6e961c78277
#=╠═╡ notebook_exclusive
md"""
# Test subplots
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ c7bdf29e-21f5-4c45-9892-86efc16225b8
#=╠═╡ notebook_exclusive
begin
	Abar5 = 7.6
	λ5 = 0.5
	m5 = 2.0
	ϕ5 = 0.2
	rbar5 = 2.0
	γ5 = 4.5
	Yᴾ5 = 14.0
	πᵉ5 = 2.0
	ρ5 = 0.0
	πd_max5 = (Abar5 / (λ5 * ϕ5)) - rbar5/λ5 
	πs_min5 = πᵉ5 - γ5 * Yᴾ5 + ρ5 
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ 0f6a5618-c338-41ac-b6e3-cba211c070be
#=╠═╡ notebook_exclusive
md"""
# Plotly traces additional methods
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ c805105a-9444-49df-b06f-12e91aa9b26c
const NNumber = Union{Nothing,<:Number}

# ╔═╡ 9c57f29a-e143-41d0-af16-6bc5ec7b5a4f
const Point{N} = Union{Tuple{Vararg{<:Number, N}}, StaticVector{N,<:Number}}

# ╔═╡ 93f04d55-9ed8-43b1-ace6-1084e95bba67
const Point2D = Point{2}

# ╔═╡ 79a9dcad-4b5f-4206-8ab4-50b712ebf07b
const Point3D = Point{3}

# ╔═╡ b956aa02-48fb-416e-aa39-c9fa291ed47a
#=╠═╡ notebook_exclusive
md"""
## scatter
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ b16f5014-a4dd-48e0-b8c8-6c839b5f52c3
begin
	function PlotlyBase.scatter(xy::AbstractVector{<:Point2D};kwargs...)
		PlotlyBase.scatter(;x=first.(xy),y=last.(xy),kwargs...)
	end
	function PlotlyBase.scatter(xy::Tuple{<:AbstractVector,<:AbstractVector};kwargs...)
		PlotlyBase.scatter(;x=xy[1],y=xy[2],kwargs...)
	end
end

# ╔═╡ b64c1114-b013-43f6-9226-12290160ecb6
#=╠═╡ notebook_exclusive
begin
	Y5 = 12.0:0.01:15.0
	
	πd5 = πd_max5 .- ((1 ./(m5 .* ϕ5 .* λ5)) .* Y5) 
	πs5 = πs_min5 .+ γ5 .*Y5             
	
	trace9_0 = scatter(; x = [14,14] , y = [-7,14] , mode = "line", 
		line_width = "4", name = "Yp", line_color = "Cyan")
	
	trace9_1 = scatter(; x = Y5, y = πd5, mode="lines" , 
		line_color = "Blue", line_width = "3", name = "AD")
	
	trace9_2 = scatter(; x = Y5, y = πs5, mode="lines" , 
		line_color = "Red", line_width = "3", name  = "AS")
	
	trace9_3 = scatter(; x = [14.0], y = [2.0], text =["1"], 
		textposition = "top center", name = "Eq.", mode = "markers+text", 
		marker_size = "12", marker_color = "Blue", textcolor = "Black")
	
	
	layout9_3 = Layout(;title="Macroeconomic Equilibrium",
        xaxis = attr(title=" GDP trillion dollars (Y)", 
			showgrid=true, zeroline=false),
        xaxis_range = [13.5, 14.5],	
        yaxis = attr(title="Rate of inflation (π)", zeroline = false),
		yaxis_range = [-0 , 5],
	)

   p9_3 = Plot([trace9_0, trace9_1, trace9_2, trace9_3], layout9_3)
	
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ deb417ed-977d-4a9e-b333-763326bec365
#=╠═╡ notebook_exclusive
begin
	r5 = 0.0:0.01:5.0
	
	πmp5 = - (rbar5 ./ λ5) .+  r5 ./ λ5 
	
	trace4_0 = scatter(; x = r5, y = πmp5, mode = "lines", line_color = "Brown", 
		line_width = "3", name  = "MP")
	
	trace4_1 = scatter(; x = [3.0], y = [2.0], text =["1"], 
		textposition = "top center", name ="Eq.", mode="markers+text", 
		marker_size = "12",
		marker_color = "Brown", textcolor = "Black")
	
	layout4_1 = Layout(;title="MP Function",
        xaxis = attr(title=" Real interest rate (r)", showgrid=true, 
			zeroline=false),
        xaxis_range = [2.0, 4.5],
		xaxis_tickvals = [2, 2.5, 3, 3.5, 4, 4.5],
        yaxis = attr(title="Rate of inflation (π)", zeroline = false),
		yaxis_range = [-0 , 5])

   p4_1 = Plot([trace4_0, trace4_1], layout4_1)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ 4c160e08-4f1c-4ec1-818b-475331f71435
#=╠═╡ notebook_exclusive
p02 =[p4_1   p9_3]
  ╠═╡ notebook_exclusive =#

# ╔═╡ 0622aaae-5d43-4113-b770-eb937fec963f
#=╠═╡ notebook_exclusive
@htl """
$p4_1
$p9_3
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 31de5995-b2a2-48ce-9bf3-fd61059e8f61
#=╠═╡ notebook_exclusive
scatter([(rand(),rand()) for _ ∈ 1:100];mode="markers") |> Plot
  ╠═╡ notebook_exclusive =#

# ╔═╡ 6edb683a-b544-4b51-9824-d8ddb19de525
#=╠═╡ notebook_exclusive
scatter(rand(SVector{2,Float64},100);mode="markers") |> Plot
  ╠═╡ notebook_exclusive =#

# ╔═╡ 302e8097-be38-44e3-ba24-8f834115bb94
#=╠═╡ notebook_exclusive
scatter((rand(100),rand(100));mode="markers") |> Plot
  ╠═╡ notebook_exclusive =#

# ╔═╡ f5a6204d-0346-4435-9e7a-48f005883995
#=╠═╡ notebook_exclusive
md"""
## surface
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ eb608938-7ede-464f-9c5f-0c19d7847fb5
begin
	function PlotlyBase.surface(xy::AbstractArray{<:Point3D};kwargs...)
		PlotlyBase.surface(;x=getindex.(xy,1),y=getindex.(xy,2),z=getindex.(xy,3),kwargs...)
	end
	function PlotlyBase.surface(xy::Tuple{<:AbstractArray,<:AbstractArray, <: AbstractArray};kwargs...)
		PlotlyBase.surface(;x=xy[1],y=xy[2],z=xy[3],kwargs...)
	end
end

# ╔═╡ 3522fa4c-6b11-430e-995c-e0cb9de4ccef
#=╠═╡ notebook_exclusive
let
	x = -5:5
	y = -5:5
	z = [x^2 + y^2 for x ∈ x, y ∈ y]
	surface((x,y,z)) |> Plot
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ a4404f41-84a5-48d0-92e4-bbc1705401bf
#=╠═╡ notebook_exclusive
let
	x = -5:5
	y = -5:5
	z = [x^2 + y^2 for x ∈ x, y ∈ y]
	xgrid = [x for x ∈ x, y ∈ y]
	ygrid = [y for x ∈ x, y ∈ y]
	surface(collect(zip(xgrid,ygrid,z))) |> Plot
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ f1d07f52-f53a-40f0-a8ca-6bfc38cd033f
#=╠═╡ notebook_exclusive
md"""
## Contour
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 2eae61ad-e45e-4581-92d8-6c0781e25de1
begin
	function PlotlyBase.contour(x::AbstractVector,y::AbstractVector, z:: AbstractMatrix;kwargs...)
		PlotlyBase.contour(;x=x,y=y,z=z,kwargs...)
	end
end

# ╔═╡ 0a3a8cfc-e0d4-4a4d-a029-6a70ee744dc8
#=╠═╡ notebook_exclusive
let
	x = -5:5
	y = -5:5
	z = [x^2 + y^2 for x ∈ x, y ∈ y]
	contour(x,y,z) |> Plot
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlotlyBase = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
PlutoUtils = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
StaticArrays = "90137ffa-7385-5640-81b9-e52037218182"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[compat]
HypertextLiteral = "~0.9.3"
PlotlyBase = "~0.8.18"
PlutoUtils = "~0.4.5"
StaticArrays = "~1.2.13"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-rc2"
manifest_format = "2.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "0bc60e3006ad95b4bb7497698dd7c6d649b9bc06"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.1"

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

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "a851fec56cb73cfdf43762999ec72eff5b86882a"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.15.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

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

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

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

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

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

[[deps.Parameters]]
deps = ["OrderedCollections", "UnPack"]
git-tree-sha1 = "34c0e9ad262e5f7fc75b10a9952ca7692cfc5fbe"
uuid = "d96e819e-fc66-5662-9728-84c9c7592b0a"
version = "0.12.3"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "ae4bbcadb2906ccc085cf52ac286dc1377dceccc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.1.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotlyBase]]
deps = ["ColorSchemes", "Dates", "DelimitedFiles", "DocStringExtensions", "JSON", "LaTeXStrings", "Logging", "Parameters", "Pkg", "REPL", "Requires", "Statistics", "UUIDs"]
git-tree-sha1 = "180d744848ba316a3d0fdf4dbd34b77c7242963a"
uuid = "a03496cd-edff-5a9b-9e67-9cda94a718b5"
version = "0.8.18"

[[deps.PlutoDevMacros]]
deps = ["MacroTools"]
git-tree-sha1 = "cfd40e6f7c23fc38a751e4ba4a5c25b8a68fd4b2"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.2.0"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "92b8ae1eee37c1b8f70d3a8fb6c3f2d81809a1c5"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.2.0"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "e071adf21e165ea0d904b595544a8e514c8bb42c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.19"

[[deps.PlutoUtils]]
deps = ["Chain", "Glob", "HypertextLiteral", "InteractiveUtils", "Markdown", "PlutoDevMacros", "PlutoTest", "PlutoUI", "PrettyTables", "Reexport", "Requires", "UUIDs"]
git-tree-sha1 = "ae74b417ca618a4a24fea3240433f969efa2f9b3"
uuid = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
version = "0.4.5"

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

[[deps.UnPack]]
git-tree-sha1 = "387c1f73762231e86e0c9c5443ce3b4a0a9a0c2b"
uuid = "3a884ed6-31ef-47d7-9d2a-63182c4928ed"
version = "1.0.2"

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
# ╟─f0aae837-cf93-46df-b204-d4ed57836d12
# ╠═8c4e16f0-7e73-4f5a-b0e3-c565a0b92f47
# ╠═d1bba282-0212-4149-a24a-7b036a7a9458
# ╠═ab8c40b4-982c-4063-b209-177a9b72e527
# ╠═caa6aad3-50ab-4041-ab27-525ec9ec56ee
# ╠═d64feb66-4cd5-4818-b912-1efebcdb8432
# ╟─3c3d991b-6970-495b-8d80-d3c42b7c9617
# ╠═c5f520f4-c26c-4ec8-90b5-6e74375cf9d7
# ╠═c27179fa-c2c0-45a2-afbf-8350d817ef08
# ╟─2dfdbd07-15fc-4a43-8849-d0154bf2192e
# ╠═e093832c-d490-4468-97ee-e902b24a3e44
# ╠═84560ed3-1ea7-4eb8-8db1-99eaa5219dd2
# ╠═f7dfb8b4-bcbd-4aed-8af0-c2ea37c1ac90
# ╠═740bcc3f-5304-4f8e-9324-af1f392b13a6
# ╠═e389da42-7f04-4bad-acc5-334a4277e5ac
# ╠═02583ec4-a758-47e6-aeea-f6d897b307bc
# ╠═37374eb5-075f-4ecc-ae91-472b55c18c6f
# ╠═0c835811-ec85-4f91-8a33-536256ac281d
# ╠═943c3293-fba2-44f5-9e61-2f821bd5c65e
# ╠═6d85da33-f8f4-4435-b572-991a0b6e5511
# ╠═01aef0a4-e96d-403d-be40-b118e6db614a
# ╠═55f63e7b-f81a-48ff-9857-a8cfd6b3c7dd
# ╠═0123b5ce-5455-4227-b916-3d1e1c814911
# ╠═c0ff610e-1370-456a-b955-d16b5032c199
# ╟─f4d9e48f-f9fe-4587-b855-f6e961c78277
# ╠═c7bdf29e-21f5-4c45-9892-86efc16225b8
# ╠═b64c1114-b013-43f6-9226-12290160ecb6
# ╠═deb417ed-977d-4a9e-b333-763326bec365
# ╠═4c160e08-4f1c-4ec1-818b-475331f71435
# ╠═0622aaae-5d43-4113-b770-eb937fec963f
# ╟─0f6a5618-c338-41ac-b6e3-cba211c070be
# ╠═c805105a-9444-49df-b06f-12e91aa9b26c
# ╟─b956aa02-48fb-416e-aa39-c9fa291ed47a
# ╠═b16f5014-a4dd-48e0-b8c8-6c839b5f52c3
# ╠═31de5995-b2a2-48ce-9bf3-fd61059e8f61
# ╠═302e8097-be38-44e3-ba24-8f834115bb94
# ╟─f5a6204d-0346-4435-9e7a-48f005883995
# ╠═eb608938-7ede-464f-9c5f-0c19d7847fb5
# ╠═3522fa4c-6b11-430e-995c-e0cb9de4ccef
# ╠═a4404f41-84a5-48d0-92e4-bbc1705401bf
# ╟─f1d07f52-f53a-40f0-a8ca-6bfc38cd033f
# ╠═2eae61ad-e45e-4581-92d8-6c0781e25de1
# ╠═0a3a8cfc-e0d4-4a4d-a029-6a70ee744dc8
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
