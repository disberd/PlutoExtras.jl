### A Pluto.jl notebook ###
# v0.17.2

# using Markdown
# using InteractiveUtils

# ╔═╡ c0d99e41-82bf-4c05-a751-cdb9ed8c4584
using HypertextLiteral

# ╔═╡ 75765246-98f8-408e-87bb-a6d68f5284c7
function plotly_save_button(;left = nothing, right = left === nothing ? "30px" : nothing, z_index = 400, kwargs...)
# Populate the main icon style
under_to_hyphen(s) = replace(String(s), '_' => '-')
io = IOBuffer()
if right === nothing
	ref = "left"
	println(io, "left: $left;")
else
	ref = "right"
	println(io, "right: $right;")
end
for (n,v) ∈ kwargs
	if v !== nothing
		println(io,"$(under_to_hyphen(n)): $v;")
	end
end
style = String(take!(io))
	@htl """
<!-- <p id="p1" draggable="true">This element is draggable.</p> -->
<div class='plotly_save_container'>
	<span id='plutoutils_plotlysave' class="plotly_save_icon" draggable="true"></span>
	<div class='plotly_save_data'>
		<div>
			<label>
				Width: 
				<input type='number' name='width' value=700>
				px
			</label>
		</div>
		
		<div>
			<label>
				Height: 
				<input type='number' name='height' value=500>
				px
			</label>
		</div>
		
		<div>
			<label>
				Scale: 
				<input type='number' name='scale' value=2>
				px
			</label>
		</div>

		<div>				 
			<label>
				<input type="radio" name="format" value="png" checked>
				png
			</label>
			
			<label>
				<input type="radio" name="format" value="jpeg">
				jpg
			</label>
		</div>
			
		<div>
			<label>
				<input type="radio" name="format" value="svg">
				svg
			</label>
			
			<label>
				<input type="radio" name="format" value="webp">
				webp
			</label>
		</div>

		<div>
			<label>
				Filename: 
				<input type='text' name='filename' value='newplot'>
			</label>
		</div>
	</div>
</div>

<script>
  function dragstart_handler(ev) {
    // Add the target element's id to the data transfer object
  	const el = ev.target.parentElement
	let data = {}
	data.format = el.querySelector('input[name="format"]:checked').value
	data.width = el.querySelector('input[name="width"]').value
	data.height = el.querySelector('input[name="height"]').value
	data.scale = el.querySelector('input[name="scale"]').value
	data.filename = el.querySelector('input[name="filename"]').value
    ev.dataTransfer.setData("plotly-config", JSON.stringify(data));
  }
    const element = document.getElementById("plutoutils_plotlysave");

    element.addEventListener("dragstart", dragstart_handler);
</script>

<style>
	.plotly_save_container {
		--icon-size: 25px;
		display: inline-block;
		position: fixed;
		$style
		z-index: $z_index;
	}
	.plotly_save_icon {   
		display: inline-block;
		width: var(--icon-size);
		height: var(--icon-size);
		background-size: var(--icon-size) var(--icon-size);
		background-position: center;
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/save-outline.svg");
	}
	.plotly_save_icon:hover {
		cursor: pointer;
	}
	.plotly_save_container:not(:hover) .plotly_save_data {
		$ref: -10000px;
		transition-delay: 0.3s;
	}
	.plotly_save_data {
		position: absolute;
		$ref: 0px;
		top: calc(var(--icon-size) + 10px);
		width: 140px;
	}
	.plotly_save_data label {
		display: inline;
	}
	.plotly_save_data input[type='number'] {
		max-width: 50px;
	}
	.plotly_save_data input[type='text'] {
		max-width: 140px;
	}
	.plotly_save_data div {
		margin: 10px 0;
	}
</style>
"""
end

# ╔═╡ 1d26e300-acbf-4fa2-a3bc-cf464cb99828
export plotly_save_button

# ╔═╡ fd496d1a-0aae-4c9a-a949-9707b6366d8e
plotly_save_button(;right = "30px", top = "30px")

# ╔═╡ c06d6141-e262-4b93-bc63-f17e04e0ce51
#=╠═╡ notebook_exclusive
html"""
<p id="target">Drop Zone</p>

<script>
function dragover_handler(ev) {
	// Only allow dropping when our custom data is available.
	if (event.dataTransfer.types.includes('plotly-config')) {
		event.preventDefault();
	}
}
function drop_handler(ev) {
 ev.preventDefault();
 // Get the id of the target and add the moved element to the target's DOM
 const data = JSON.parse(ev.dataTransfer.getData("plotly-config"));
	console.log(data)
}
p.addEventListener('dragover',dragover_handler)
p.addEventListener('drop',drop_handler)
const p = document.getElementById('target')
</script>
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"

[compat]
HypertextLiteral = "~0.9.3"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-rc2"
manifest_format = "2.0"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"
"""

# ╔═╡ Cell order:
# ╠═c0d99e41-82bf-4c05-a751-cdb9ed8c4584
# ╠═1d26e300-acbf-4fa2-a3bc-cf464cb99828
# ╠═75765246-98f8-408e-87bb-a6d68f5284c7
# ╠═fd496d1a-0aae-4c9a-a949-9707b6366d8e
# ╠═c06d6141-e262-4b93-bc63-f17e04e0ce51
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
