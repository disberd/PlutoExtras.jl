### A Pluto.jl notebook ###
# v0.15.1

using Markdown
using InteractiveUtils

# ╔═╡ f0aae837-cf93-46df-b204-d4ed57836d12
#=╠═╡ notebook_exclusive
md"""
# Packages
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 8c4e16f0-7e73-4f5a-b0e3-c565a0b92f47
#=╠═╡ notebook_exclusive
using HypertextLiteral
  ╠═╡ notebook_exclusive =#

# ╔═╡ d1bba282-0212-4149-a24a-7b036a7a9458
#=╠═╡ notebook_exclusive
using PlotlyBase
  ╠═╡ notebook_exclusive =#

# ╔═╡ ab8c40b4-982c-4063-b209-177a9b72e527
#=╠═╡ notebook_exclusive
import PlutoUtils
  ╠═╡ notebook_exclusive =#

# ╔═╡ caa6aad3-50ab-4041-ab27-525ec9ec56ee
#=╠═╡ notebook_exclusive
PlutoUtils.ToC()
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
	@htl("""
			<div>
			<script id=asdf>
			const {plotly} = await import("https://cdn.plot.ly/plotly-2.3.1.min.js")
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

# ╔═╡ 02583ec4-a758-47e6-aeea-f6d897b307bc
#=╠═╡ notebook_exclusive
a = rand(10,c)
  ╠═╡ notebook_exclusive =#

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

# ╔═╡ 37374eb5-075f-4ecc-ae91-472b55c18c6f
#=╠═╡ notebook_exclusive
p = Plot(a)
  ╠═╡ notebook_exclusive =#

# ╔═╡ 55f63e7b-f81a-48ff-9857-a8cfd6b3c7dd
#=╠═╡ notebook_exclusive
html"""
<style>
main {
	max-width: 800px;
}
</style>
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 0123b5ce-5455-4227-b916-3d1e1c814911
#=╠═╡ notebook_exclusive
c = 3
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

# ╔═╡ Cell order:
# ╟─f0aae837-cf93-46df-b204-d4ed57836d12
# ╠═8c4e16f0-7e73-4f5a-b0e3-c565a0b92f47
# ╠═d1bba282-0212-4149-a24a-7b036a7a9458
# ╠═ab8c40b4-982c-4063-b209-177a9b72e527
# ╠═caa6aad3-50ab-4041-ab27-525ec9ec56ee
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
# ╠═0c835811-ec85-4f91-8a33-536256ac281d
# ╠═943c3293-fba2-44f5-9e61-2f821bd5c65e
# ╠═37374eb5-075f-4ecc-ae91-472b55c18c6f
# ╠═55f63e7b-f81a-48ff-9857-a8cfd6b3c7dd
# ╠═0123b5ce-5455-4227-b916-3d1e1c814911
# ╠═c0ff610e-1370-456a-b955-d16b5032c199
# ╟─f4d9e48f-f9fe-4587-b855-f6e961c78277
# ╠═c7bdf29e-21f5-4c45-9892-86efc16225b8
# ╠═b64c1114-b013-43f6-9226-12290160ecb6
# ╟─deb417ed-977d-4a9e-b333-763326bec365
# ╠═4c160e08-4f1c-4ec1-818b-475331f71435
