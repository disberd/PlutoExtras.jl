### A Pluto.jl notebook ###
# v0.15.0

using Markdown
using InteractiveUtils

# ╔═╡ 67afd000-c87b-11eb-04b6-73804effdcfa
begin
	using Glob
	using PlutoUI
	using Chain
end

# ╔═╡ 8abd5d27-f3f4-4a1e-86e9-b130c08b3f3e
function find_notebook_caller()
	st = stacktrace()
	for (i,s) ∈ enumerate(st)
		# The pluto cell being evaluated has a filename that ends with a string of the form `#==#cell-UUID` where cell-UUID is the 36 characters UUID of the cell
		path_vec = @chain s begin
			_.file # Extract the filename from the trace
			String # Make it a string
			splitpath # Split the path to be able to extract the 
		end
		# Skip if the file does not contain the correct ending sequence
		findnext("#==#",path_vec[end],1) === nothing && continue
		name,uuid = split(path_vec[end],"#==#")
		return (name,joinpath(path_vec[1:end-1]...),uuid)
	end
end

# ╔═╡ 2913c797-f431-4df0-b0a8-8f2899c1f534
"""
Function to move a pasted image downloaded from the Pluto Cell into the folder where the notebook is located (inside a subfolder pastedImages
"""
function show_pasted_image(str,args...;searchdir="",kwargs...)
	# Separate the eventaul directory from the provided string
	dir,filename = splitdir(str)
	if isempty(dir)
		# The string provided is only a file name, check if a custom searchdir was provided
		if isempty(searchdir)
			sdir = joinpath(homedir(),"Downloads")
		else
			sdir = searchdir
		end
	else
		# Check if the provided directory is absolute or relative
		if isabspath(dir)
			# Use this directly as the searchdir
			sdir = dir
		else
			sdir = joinpath(searchdir,dir)
		end
	end
	nb_name,nb_dir,_ = find_notebook_caller()
	img_dir = joinpath(nb_dir,"pastedImages",nb_name)
	img_path = joinpath(img_dir,filename)
	# Check if file and dir already exist in the notebook dir
	dir_exists = isdir(img_dir)
	file_exists = isfile(img_path)
	# Start by separating the name from the extension of the image
	name, ext = splitext(filename)
	# Look for all the possible files containing cell name in the searchdir, this is needed because if you paste into the same cell multiple times you might have renamed version of your file with numbers appended to them
	files = glob(name * "*" * ext,sdir)
	if isempty(files)
		file_exists ? # Check if file already exists in the notebook folder
		file = "" : # Set to empty string if exists
		error("The requested file doesn't seem to be present in the search directory or in the current pastedImages subdirectory")
	elseif length(files) == 1
		file = files[1]
	else
		# Take the file that has the latest creation time
		file = sort(files;by=x -> stat(x).ctime)[end]
	end
	# Check if the subdirectory exists
	if ~isdir(img_dir)
		mkpath(img_dir)
	end
	# Move the file to the new path, overwriting other files if they exist and have been created earlier
	if stat(file).ctime > stat(img_path).ctime
		mv(file,img_path;force=true)
	end
	# Return a LocalResource pointing to the newly created file
	LocalResource(img_path,args...;kwargs...)
end

# ╔═╡ b4507f04-ae53-462a-9cf3-864774dabe62
export show_pasted_image

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
Chain = "8be319e6-bccf-4806-a6f7-6fae938471bc"
Glob = "c27321d9-0574-5035-807b-f59d2c89b15c"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"

[compat]
Chain = "~0.4.7"
Glob = "~1.3.0"
PlutoUI = "~0.7.9"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.6.2"
manifest_format = "2.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Chain]]
git-tree-sha1 = "c72673739e02d65990e5e068264df5afaa0b3273"
uuid = "8be319e6-bccf-4806-a6f7-6fae938471bc"
version = "0.4.7"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Glob]]
git-tree-sha1 = "4df9f7e06108728ebf00a0a11edee4b29a482bb2"
uuid = "c27321d9-0574-5035-807b-f59d2c89b15c"
version = "1.3.0"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "81690084b6198a2e1da36fcfda16eeca9f9f24e4"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.1"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "c8abc88faa3f7a3950832ac5d6e690881590d6dc"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "1.1.0"

[[deps.PlutoUI]]
deps = ["Base64", "Dates", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "Suppressor"]
git-tree-sha1 = "44e225d5837e2a2345e69a1d1e01ac2443ff9fcb"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.9"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Random]]
deps = ["Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Reexport]]
git-tree-sha1 = "5f6c21241f0f655da3952fd60aa18477cf96c220"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.1.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Suppressor]]
git-tree-sha1 = "a819d77f31f83e5792a76081eee1ea6342ab8787"
uuid = "fd094767-a336-5f1f-9728-57cf17d0bbfb"
version = "0.2.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
"""

# ╔═╡ Cell order:
# ╠═67afd000-c87b-11eb-04b6-73804effdcfa
# ╠═b4507f04-ae53-462a-9cf3-864774dabe62
# ╠═8abd5d27-f3f4-4a1e-86e9-b130c08b3f3e
# ╠═2913c797-f431-4df0-b0a8-8f2899c1f534
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
