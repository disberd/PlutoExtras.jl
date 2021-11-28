### A Pluto.jl notebook ###
# v0.17.2

# using Markdown
# using InteractiveUtils

# ╔═╡ 783c97d0-30ba-11ec-0c84-715ee12ad5ca
#=╠═╡ notebook_exclusive
begin
	using HypertextLiteral
	import PlutoUtils: prettytable
	using UUIDs
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ bab9140d-054a-4bb6-99cd-1a972679f730
#=╠═╡ notebook_exclusive
md"""
This notebook implements a function that saves html tables generated with `prettytable` (or in general any table that has a parent element with a specific id).
Before using, the `initialize_hml2canvas_savediv()` function must be called in a cell of its own.
After that, to save table whose parent container has an `id` equivalent to `table_id`, the function `savediv(table_id,figures_path)` can be called in its own separate cell (this is needed as it only works by executing custom javascript output).
The table will be saved as `table_id.png` inside the folder identified by `figures_path`.

Check the code of savediv for understanding the other parameters
"""
  ╠═╡ notebook_exclusive =#

# ╔═╡ 080093c3-39ca-43ea-ba38-c80cf800e547
function try_moveimage(srcname,dstpath)
	sdir = joinpath(homedir(),"Downloads")
	srcpath = joinpath(sdir,srcname)
	# Check if the source file exists
	if !isfile(srcpath)
		return false
	end

	# Since the file exists, we move it to the new location
	mv(srcpath,dstpath;force=true)
	return true
end

# ╔═╡ 4df9f351-3cda-40b3-a78d-de3097d03e2b
function savediv(table_id,figures_path; interval = 5, trials = 40)
	random_id = uuid4() |> x -> string(x) * ".png"
	dstpath = joinpath(figures_path,"$(table_id).png")
	
	@async begin
		i = 0
		saved = false
		while !(saved || i > trials)
			println("$table_id move attempt # $i")
			saved = try_moveimage($random_id,$dstpath)
			sleep(interval)
			i += 1
		end
		println(saved ? "picture $random_id moved as $table_id" : "$trials attempts reached for $table_id")
	end
	@htl """
	saving HTML element using html2canvas
<script>
	const myDiv = document.getElementById("html2canvas_savediv_container")
	myDiv.addToQueue({table_id: $table_id, random_name : $random_id})

</script>
"""
end

# ╔═╡ e5a3af7b-8323-4fc4-baed-26e287ac00d0
function initialize_html2canvas_savediv()
	@htl """

		<!-- Load the html2canvas library -->
		<script type='text/javascript' src='https://html2canvas.hertzen.com/dist/html2canvas.min.js'></script>
	<!-- Create the div that will be accessed to initiate the html2canvas function -->
		<div id="html2canvas_savediv_container">
			html2canvas initialized
		</div>
		<script>
			const mydiv = document.getElementById("html2canvas_savediv_container")
			
			function saveAs(uri, filename) {
			
			    var link = document.createElement('a');
			
			    if (typeof link.download === 'string') {
			
			        link.href = uri;
			        link.download = filename;
			
			        //Firefox requires the link to be in the body
			        document.body.appendChild(link);
			
			        //simulate click
			        link.click();
			
			        //remove the link when done
			        document.body.removeChild(link);
			
			    } else {
			
			        window.open(uri);
			
			    }
			}

			const queue = []

			let isQueueRunning = false
			let queueSlots = 3

			const addToQueue = ({table_id, random_name}) => {
				// Add the save pointers to the queue array
				queue.push({table_id, random_name})
				if (!isQueueRunning) {
					// Start the queue processing function
					isQueueRunning = true
					console.log('Queue Processing Starting!')
					processQueue()
				}
			}

			const processQueue = () => {
				if (queue.length == 0) {
					console.log('Finished processing the queue')
					isQueueRunning = false
					return
				}
				if (queueSlots < 1) {
					// We can't do anything for the moment
					console.log('No slots for processing, waiting for other processes to end')
					return
				}
				// Add the first element of the array to the processing
				const el = queue.pop()
				console.log('start processing element with id',el.table_id)
				queueSlots -= 1
				saveTable(el)
				return setTimeout(processQueue,100)
			}

			mydiv.addToQueue = addToQueue

			const saveTable = async ({table_id, random_name}) => {
				const table = document.getElementById(table_id).querySelector('table')
				const canvas = await html2canvas(table,{scale:2})
				saveAs(canvas.toDataURL(), random_name)
				queueSlots += 1
				if (isQueueRunning) {
					processQueue()	
				}
			}
			
		</script>
	"""
end

# ╔═╡ 2ed4b0a8-c9d5-4ac4-8d44-e9190cbd4450
#=╠═╡ notebook_exclusive
initialize_html2canvas_savediv()
  ╠═╡ notebook_exclusive =#

# ╔═╡ d9d97df5-52ca-4293-ad38-1cbd40752e87
export initialize_html2canvas_savediv, savediv

# ╔═╡ 228dedcf-81c0-486d-b644-a0caef1b6af9
#=╠═╡ notebook_exclusive
prettytable(rand(10,4);id="gesure")
  ╠═╡ notebook_exclusive =#

# ╔═╡ 90802873-b87f-484f-a8cd-8427d28e1fba
#=╠═╡ notebook_exclusive
prettytable(rand(10,4);id="gesure1")
  ╠═╡ notebook_exclusive =#

# ╔═╡ ff25c91c-52d8-4a9b-aac8-b710da04e0b8
#=╠═╡ notebook_exclusive
prettytable(rand(10,4);id="gesure2")
  ╠═╡ notebook_exclusive =#

# ╔═╡ e9494543-1a62-4efe-8b3b-487e81ecc19c
#=╠═╡ notebook_exclusive
prettytable(rand(10,4);id="gesure3")
  ╠═╡ notebook_exclusive =#

# ╔═╡ 0e5dfdf1-89ec-4f1f-b1a1-263b2c29d9e7
#=╠═╡ notebook_exclusive
prettytable(rand(10,4);id="gesure4")
  ╠═╡ notebook_exclusive =#

# ╔═╡ 9575aa97-4aa2-4f38-9eef-0b6896366bf3
#=╠═╡ notebook_exclusive
prettytable(rand(10,4);id="gesure5")
  ╠═╡ notebook_exclusive =#

# ╔═╡ a2514ace-4d35-4a5d-adbe-4aeec97294de
#=╠═╡ notebook_exclusive
# Change the figures_path below and set this to true to try saving the tables
save_figures = false
  ╠═╡ notebook_exclusive =#

# ╔═╡ 7d212bef-6d2e-418d-a637-093712612d84
#=╠═╡ notebook_exclusive
figures_path = joinpath(homedir())
  ╠═╡ notebook_exclusive =#

# ╔═╡ 24cd661f-cf72-4c0f-9cc6-a4a800354993
#=╠═╡ notebook_exclusive
if save_figures
	savediv("gesure",figures_path)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ dccc21a0-e1a5-4a4f-8b6b-255082e9fdfa
#=╠═╡ notebook_exclusive
if save_figures
	savediv("gesure1",figures_path)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ b57aa8d9-0c8f-4c77-9813-43295be41bb6
#=╠═╡ notebook_exclusive
if save_figures
	savediv("gesure2",figures_path)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ 9cbe62ff-ff77-4327-aeb4-ee8194360b87
#=╠═╡ notebook_exclusive
if save_figures
	savediv("gesure3",figures_path)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ 2db10955-4f9b-4bdf-9a70-32f05816ba87
#=╠═╡ notebook_exclusive
if save_figures
	savediv("gesure4",figures_path)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ ec05e16c-9725-4680-982f-e93fd70f17da
#=╠═╡ notebook_exclusive
if save_figures
	savediv("gesure5",figures_path)
end
  ╠═╡ notebook_exclusive =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoUtils = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
UUIDs = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[compat]
HypertextLiteral = "~0.9.1"
PlutoUtils = "~0.3.13"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.0-rc1"
manifest_format = "2.0"

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
git-tree-sha1 = "f6532909bf3d40b308a0f360b6a0e626c0e263a8"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.1"

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

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "5a5bc6bf062f0f95e62d0fe0a2d99699fed82dd9"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.8"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "98f59ff3639b3d9485a03a72f3ab35bab9465720"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.0.6"

[[deps.PlutoDevMacros]]
deps = ["MacroTools"]
git-tree-sha1 = "cfd40e6f7c23fc38a751e4ba4a5c25b8a68fd4b2"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.2.0"

[[deps.PlutoTest]]
deps = ["HypertextLiteral", "InteractiveUtils", "Markdown", "Test"]
git-tree-sha1 = "b7da10d62c1ffebd37d4af8d93ee0003e9248452"
uuid = "cb4044da-4d16-4ffa-a6a3-8cad7f73ebdc"
version = "0.1.2"

[[deps.PlutoUI]]
deps = ["Base64", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "4c8a7d080daca18545c56f1cac28710c362478f3"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.16"

[[deps.PlutoUtils]]
deps = ["Chain", "Glob", "HypertextLiteral", "InteractiveUtils", "Markdown", "PlutoDevMacros", "PlutoTest", "PlutoUI", "PrettyTables", "Reexport", "Requires", "UUIDs"]
git-tree-sha1 = "26ba8b1c0fd702007c0c8c7bb2496d65256beaf1"
uuid = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
version = "0.3.13"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "d940010be611ee9d67064fe559edbb305f8cc0eb"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.2.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["Serialization"]
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

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
"""

# ╔═╡ Cell order:
# ╠═783c97d0-30ba-11ec-0c84-715ee12ad5ca
# ╟─bab9140d-054a-4bb6-99cd-1a972679f730
# ╠═2ed4b0a8-c9d5-4ac4-8d44-e9190cbd4450
# ╠═d9d97df5-52ca-4293-ad38-1cbd40752e87
# ╠═4df9f351-3cda-40b3-a78d-de3097d03e2b
# ╠═080093c3-39ca-43ea-ba38-c80cf800e547
# ╠═e5a3af7b-8323-4fc4-baed-26e287ac00d0
# ╠═228dedcf-81c0-486d-b644-a0caef1b6af9
# ╠═90802873-b87f-484f-a8cd-8427d28e1fba
# ╠═ff25c91c-52d8-4a9b-aac8-b710da04e0b8
# ╠═e9494543-1a62-4efe-8b3b-487e81ecc19c
# ╠═0e5dfdf1-89ec-4f1f-b1a1-263b2c29d9e7
# ╠═9575aa97-4aa2-4f38-9eef-0b6896366bf3
# ╠═a2514ace-4d35-4a5d-adbe-4aeec97294de
# ╠═7d212bef-6d2e-418d-a637-093712612d84
# ╠═24cd661f-cf72-4c0f-9cc6-a4a800354993
# ╠═dccc21a0-e1a5-4a4f-8b6b-255082e9fdfa
# ╠═b57aa8d9-0c8f-4c77-9813-43295be41bb6
# ╠═9cbe62ff-ff77-4327-aeb4-ee8194360b87
# ╠═2db10955-4f9b-4bdf-9a70-32f05816ba87
# ╠═ec05e16c-9725-4680-982f-e93fd70f17da
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
