### A Pluto.jl notebook ###
# v0.14.7

using Markdown
using InteractiveUtils

# ╔═╡ 67afd000-c87b-11eb-04b6-73804effdcfa
begin
	using Glob
	using PlutoUI
end

# ╔═╡ 2913c797-f431-4df0-b0a8-8f2899c1f534
"""
Function to move a pasted image downloaded from the Pluto Cell into the folder where the notebook is located (inside a subfolder pastedImages
"""
function show_pasted_image(str;searchdir="")
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
	img_dir = joinpath(@__DIR__,"pastedImages")
	img_path = joinpath(img_dir,str)
	# Start by separating the name from the extension of the image
	name, ext = splitext(filename)
	# Look for all the possible files containing cell name in the searchdir, this is needed because if you paste into the same cell multiple times you might have renamed version of your file with numbers appended to them
	files = glob(name * "*" * ext,sdir)
	if isempty(files)
		error("The requested file doesn't seem to be present in the search directory")
	elseif length(files) == 1
		file = files[1]
	else
		# Take the file that has the latest creation time
		file = sort(files;by=x -> stat(x).ctime)[end]
	end
	# Check if the subdirectory exists
	if ~isdir(img_dir)
		mkdir(img_dir)
	end
	# Copy the file to the new path, overwriting other files if they exist and have been created earlier
	if stat(file).ctime > stat(img_path).ctime
		cp(file,img_path;force=true)
	end
	# Return a LocalResource pointing to the newly created file
	LocalResource(img_path)
end

# ╔═╡ b4507f04-ae53-462a-9cf3-864774dabe62
export show_pasted_image

# ╔═╡ Cell order:
# ╠═67afd000-c87b-11eb-04b6-73804effdcfa
# ╠═b4507f04-ae53-462a-9cf3-864774dabe62
# ╠═2913c797-f431-4df0-b0a8-8f2899c1f534
