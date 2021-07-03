### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ b480f790-d1ec-11eb-3ae8-19d868ca20c0
@only_in_nb begin
	import Pkg
	Pkg.activate("..")
	using HypertextLiteral
	using PlotlyBase
end

# ╔═╡ 61533af4-d761-4519-8f69-ba1a8fa32995
using PlutoDevMacros

# ╔═╡ e389da42-7f04-4bad-acc5-334a4277e5ac
begin
	plotlylower(x) = x
	plotlylower(x::Vector{<:Number}) = x
	plotlylower(x::AbstractVector) = Any[plotlylower(z) for z in x]
	plotlylower(x::AbstractMatrix) = Any[plotlylower(r) for r in eachrow(x)]
	plotlylower(d::Dict) = Dict(
		k => plotlylower(v)
		for (k,v) in d
	)
	
	to_js(x) = HypertextLiteral.JavaScript(Main.PlutoRunner.publish_to_js(plotlylower(x)))
	
	function Base.show(io::IO, mimetype::MIME"text/html", plt::PlotlyBase.Plot)
		show(io,mimetype, @htl("""
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
"""))
	end
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

# ╔═╡ Cell order:
# ╠═61533af4-d761-4519-8f69-ba1a8fa32995
# ╠═b480f790-d1ec-11eb-3ae8-19d868ca20c0
# ╠═e389da42-7f04-4bad-acc5-334a4277e5ac
# ╠═02583ec4-a758-47e6-aeea-f6d897b307bc
# ╠═37374eb5-075f-4ecc-ae91-472b55c18c6f
# ╠═55f63e7b-f81a-48ff-9857-a8cfd6b3c7dd
# ╠═0123b5ce-5455-4227-b916-3d1e1c814911
# ╠═c0ff610e-1370-456a-b955-d16b5032c199
