### A Pluto.jl notebook ###
# v0.14.8

using Markdown
using InteractiveUtils

# ╔═╡ 61533af4-d761-4519-8f69-ba1a8fa32995
if !hasmethod(var"@only_in_nb",Tuple{LineNumberNode,Module,Any})
	# Create the macro to only excecute code from within the current notebook, and not when included from antoher julia file or Pluto notebook
	# https://github.com/disberd/PlutoDevMacros
	function is_notebook_local(filesrc)
		if isdefined(Main,:PlutoRunner)
			cell_id = tryparse(Base.UUID,last(filesrc,36))
			cell_id !== nothing && cell_id === Main.PlutoRunner.currently_running_cell_id[] && return true
		end
		return false
	end

	macro only_in_nb(ex) 
		is_notebook_local(String(__source__.file::Symbol)) ? esc(ex) : nothing 
	end
	macro only_out_nb(ex) 
		is_notebook_local(String(__source__.file::Symbol)) ? nothing : esc(ex) 
	end
end

# ╔═╡ b480f790-d1ec-11eb-3ae8-19d868ca20c0
@only_in_nb begin
	import Pkg
	Pkg.activate("..")
	using HypertextLiteral
	using PlotlyBase
end

# ╔═╡ 78d985d6-980c-4d54-8c2e-ebc14e0e4c12
@only_in_nb using PlutoUI

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

# ╔═╡ 740bcc3f-5304-4f8e-9324-af1f392b13a6
function show2(plt::PlotlyBase.Plot) 
	hasproperty(plt,:config) && plt.config.responsive && (plt.config.responsive = false)
	@htl("""
			<div>
			<script id=asdf>
			const {plotly} = await import("https://cdn.plot.ly/plotly-2.2.0.min.js")
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

# ╔═╡ 55f63e7b-f81a-48ff-9857-a8cfd6b3c7dd
@only_in_nb html"""
<style>
main {
	max-width: 800px;
}
</style>
"""

# ╔═╡ 0123b5ce-5455-4227-b916-3d1e1c814911
@only_in_nb c = 3

# ╔═╡ 02583ec4-a758-47e6-aeea-f6d897b307bc
@only_in_nb a = rand(10,c)

# ╔═╡ 37374eb5-075f-4ecc-ae91-472b55c18c6f
@only_in_nb p = Plot(a)

# ╔═╡ c0ff610e-1370-456a-b955-d16b5032c199
@only_out_nb println("Loaded plotly_show")

# ╔═╡ f4d9e48f-f9fe-4587-b855-f6e961c78277
@only_in_nb md"""
## Test subplots
"""

# ╔═╡ c7bdf29e-21f5-4c45-9892-86efc16225b8
@only_in_nb begin
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

# ╔═╡ b64c1114-b013-43f6-9226-12290160ecb6
@only_in_nb begin
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

# ╔═╡ deb417ed-977d-4a9e-b333-763326bec365
@only_in_nb begin
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

# ╔═╡ 4c160e08-4f1c-4ec1-818b-475331f71435
@only_in_nb p02 =[p4_1   p9_3]

# ╔═╡ Cell order:
# ╠═61533af4-d761-4519-8f69-ba1a8fa32995
# ╠═b480f790-d1ec-11eb-3ae8-19d868ca20c0
# ╠═e093832c-d490-4468-97ee-e902b24a3e44
# ╠═84560ed3-1ea7-4eb8-8db1-99eaa5219dd2
# ╠═f7dfb8b4-bcbd-4aed-8af0-c2ea37c1ac90
# ╠═740bcc3f-5304-4f8e-9324-af1f392b13a6
# ╠═e389da42-7f04-4bad-acc5-334a4277e5ac
# ╠═02583ec4-a758-47e6-aeea-f6d897b307bc
# ╠═37374eb5-075f-4ecc-ae91-472b55c18c6f
# ╠═55f63e7b-f81a-48ff-9857-a8cfd6b3c7dd
# ╠═0123b5ce-5455-4227-b916-3d1e1c814911
# ╠═c0ff610e-1370-456a-b955-d16b5032c199
# ╟─f4d9e48f-f9fe-4587-b855-f6e961c78277
# ╠═78d985d6-980c-4d54-8c2e-ebc14e0e4c12
# ╠═c7bdf29e-21f5-4c45-9892-86efc16225b8
# ╠═b64c1114-b013-43f6-9226-12290160ecb6
# ╟─deb417ed-977d-4a9e-b333-763326bec365
# ╠═4c160e08-4f1c-4ec1-818b-475331f71435
