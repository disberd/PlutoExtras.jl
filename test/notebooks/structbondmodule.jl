### A Pluto.jl notebook ###
# v0.19.27

#> custom_attrs = ["hide-enabled"]

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 8db82e94-5c81-4c52-9228-7e22395fb68f
begin
	using PlutoDevMacros
end

# ╔═╡ 949ac1ef-c502-4e28-81ff-f99b0d19aa03
@frompackage "../.." begin
	using ^.StructBondModule
	using ^: ExtendedTableOfContents, Editable
	using >.HypertextLiteral
	using >.PlutoUI
end

# ╔═╡ 9d4455af-96f1-46d7-a4f3-434495b11c8a
md"""
# Packages
"""

# ╔═╡ 707175a9-d356-43cf-8038-620ebc401c93
ExtendedTableOfContents()

# ╔═╡ 4843983c-df64-4b94-8634-7a10d9423a70
md"""
# StructBond
"""

# ╔═╡ a8995224-83c6-4f82-b5a5-87a6f86fc7a0
md"""
Generating automatic widgets for custom structs is quite straightforward with the aid of the `@fielddata` macro and the `StructBond` type.

The top-left arrow can be used to show-hide the field elements (useful inside a `BondTable`, shown below), while the green toggle on the top-right can be used to disable temporarily the synch between the JS widgets and the bond values in Pluto.
"""

# ╔═╡ 9e3601f5-efc2-44e9-83d8-5b65ce7e9ccf
begin
"""
	struct ASD
"""
Base.@kwdef struct ASD
	a::Int 
	b::Int
	c::String
	"This field is _special_"
	d::String
	e::Int
end
@fielddata ASD begin
	a = (md"Markdown description, including ``LaTeX``", Slider(1:10))
	b = (@htl("<span>Field with <b>HTML</b> description</span>"), Scrubbable(1:10))
	c = ("Normal String Description", TextField())
	d = TextField() # No description, defaults to the docstring since it's present
	e = Slider(20:25) # No description, defaults to the fieldname as no docstring is present
end
asd_bond = @bind asd StructBond(ASD; description = "Custom Description")
end

# ╔═╡ cdc0a7ad-a3ac-4270-b707-35b1939da276
asd

# ╔═╡ fe891b4e-f440-4823-b43b-72572f6a6c12
md"""
## Default Type Widgets
"""

# ╔═╡ 86a80228-f495-43e8-b1d4-c93b7b52c8d8
begin
	@kwdef struct MAH
		a::Int
	end
	@kwdef struct BOH
		mah::MAH
	end
	
	# This will make the default widget for an Int a Slider
	@typeasfield Int = Slider(1:10)
	# This will make the default widget for fields of type ASD a popout that wraps a StructBond{ASD}
	@popoutasfield MAH
	
	@bind boh StructBond(BOH)
end

# ╔═╡ 2358f686-1950-40f9-9d5c-dac2d98f4c24
boh

# ╔═╡ 49516374-f625-4a84-ac5c-f92497d45025
md"""
# @NTBond
"""

# ╔═╡ 8cc53cd2-9114-4067-ab0b-37fd8cd79240
md"""
Sometimes custom structs are not needed and it would be useful to just use the same nice bond structure of `StructBond` to simply create arbitrary NamedTuples. 

This is possible with the convenience macro `@NTBond` which can be called as shown below to create a nice display for an interactive bond creating an arbitrary NamedTuple.

The macro simply create a `StructBond` wrapping the desired NamedTuple type.
"""

# ╔═╡ 0db51d39-7c05-4e00-b951-7fe776a8e0f9
nt_bond = @bind nt @NTBond "My Fancy NTuple" begin
	a = ("Description", Slider(1:10))
	b = (md"**Bold** field", Slider(1:10))
	c = Slider(1:10) # No description, defaults to the name of the field
end

# ╔═╡ e2b79a58-e66e-4d40-8673-418823753b38
nt

# ╔═╡ 9d23382c-cf35-4b20-a46c-0f4e2de17fc7
md"""
# @BondsList
"""

# ╔═╡ 959acb40-1fd6-43f5-a1a6-73a6ceaae1d7
md"""
In some cases, one does not want to have a single bond wrapping either a Structure or a NamedTuple, and single independent bonds are more convenient.

`@BondsList` is a convenience macro to create an object of type `BondsList` which simply allow to add a description to separate bonds and group them all together in a table-like format equivalent to those of `StructBond`.

!!! note
	Unlike `StructBond`, a BondsList is already composed of bond created with `@bind` and it just groups them up with a description. The output of `@BondsList` is not supposed to be bound to a variable using `@bind`.\
	The bonds grouped in a BondsList still act and update independently from one another.

See the example below for understanding the synthax. The header of a BondsList is shown in an orange background to easily differentiate it from `StructBond`.
"""

# ╔═╡ 4d611425-c8e3-4bc3-912b-8bc0465363bc
bl = @BondsList "My Group of Bonds" let tv = PlutoUI.Experimental.transformed_value
	 # We use transformed_value to translate GHz to Hz in the bound variable `freq`
	"Frequency [GHz]" = @bind freq tv(x -> x * 1e9, Editable(20; suffix = " GHz"))
	md"Altitude ``h`` [m]" = @bind alt Scrubbable(100:10:200)
end

# ╔═╡ a5490a6b-dc11-42b7-87e0-d38870fc55e4
freq

# ╔═╡ 705e30fe-77a3-4b06-8b99-1807290edffb
alt

# ╔═╡ 2ee7f26d-f383-4e7e-a69a-8fb72717467c
md"""
# Popout
"""

# ╔═╡ 79beba88-932f-4147-b3a0-d821ef1bc1e2
md"""
The structures above can also be used nested within one another. To facilitate accessing nested structures, one can use the `Popout` type.

In its simple form, you can give an instance of a StructBond, a bond wrapping a StructBond or a BondsList as input to Popout to create a table that is hidden behind a popup window.
If an instance present, but you want a custom type for which you have defined custom bonds and descriptions with `@fielddata` to appear as popout, you can use the function `popoutwrap(TYPE)` to generate a small icon which hides a popup containing the `StructBond` of the provided type `TYPE`.

The StructBond table appears on hover upon the icon, can be made fixed by clicking on the icon and can then be moved around or resized.
A double click on the header of the popout hides it again:
"""

# ╔═╡ 63d6c2df-a411-407c-af11-4f5d09fbb322
begin
Base.@kwdef struct LOL
	a::Int 
	b::Int
end
@fielddata LOL begin
	a = (md"Wonder!", Slider(1:10))
	b = (@htl("<span>Field B</span>"), Scrubbable(1:10))
end
end

# ╔═╡ 633029af-8cac-426e-b35c-c9fb3938b784
popoutwrap(LOL)

# ╔═╡ 2073f11e-8196-4ebc-922f-5fa589e91797
md"""
The ability to also wrap pre-existing bonds around StructBonds is convenient for organizing the various bonds one have in a `BondsList` or `BondTable`

As an example, one can create a `BondsList` containing the two `StructBond` bonds generated at the beginning of this notebook with the follwing code.
"""

# ╔═╡ 811cf78b-e870-45bb-9173-89a3b3d495f5
blc = @BondsList "Popout Container" begin
	"Structure ASD" = Popout(asd_bond)
	"NamedTuple" = Popout(nt_bond)
end

# ╔═╡ 3a066bf4-3466-469e-90d0-6b14be3ed8d5
md"""
# BondTable
"""

# ╔═╡ 3213d977-7b65-43b0-a881-10fcc2523f14
md"""
The final convenience structure provided by this module is the `BondTable`. It can be created to group a list of bonds in a floating table that stays on the left side of the notebook (similar to the TableOfContents of PlutoUI) and can be moved around and resized or hidden for convenience.

The BondTable is intended to be used either with bonds containing `StructBond` or with `BondsList`. Future types with similar structure will also be added.

Here is an example of a bondtable containing all the examples of this notebook.
"""

# ╔═╡ 903fee67-6b23-41dc-a03d-f1040b696be6
BondTable([
	asd_bond,
	nt_bond,
	bl,
	blc
]; description = "My Bonds")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"

[compat]
PlutoDevMacros = "~0.5.8"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.10.0-beta2"
manifest_format = "2.0"
project_hash = "084d4a4eea3f50c290f093f3e626669cb4e8656d"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.1"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "c47c5fa4c5308f27ccaac35504858d8914e102f9"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.4"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.0.1+1"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "9ee1618cbf5240e6d4e0371d6f24065083f60c48"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.11"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+1"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.1.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.10.0"

[[deps.PlutoDevMacros]]
deps = ["HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Pkg", "Random", "TOML"]
git-tree-sha1 = "6ce1d9f7c078b493812161349c48735dee275466"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.5.8"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Tricks]]
git-tree-sha1 = "aadb748be58b492045b4f56166b5188aa63ce549"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.7"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.52.0+1"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─9d4455af-96f1-46d7-a4f3-434495b11c8a
# ╠═8db82e94-5c81-4c52-9228-7e22395fb68f
# ╠═949ac1ef-c502-4e28-81ff-f99b0d19aa03
# ╠═707175a9-d356-43cf-8038-620ebc401c93
# ╟─4843983c-df64-4b94-8634-7a10d9423a70
# ╟─a8995224-83c6-4f82-b5a5-87a6f86fc7a0
# ╠═9e3601f5-efc2-44e9-83d8-5b65ce7e9ccf
# ╠═cdc0a7ad-a3ac-4270-b707-35b1939da276
# ╟─fe891b4e-f440-4823-b43b-72572f6a6c12
# ╠═86a80228-f495-43e8-b1d4-c93b7b52c8d8
# ╠═2358f686-1950-40f9-9d5c-dac2d98f4c24
# ╟─49516374-f625-4a84-ac5c-f92497d45025
# ╟─8cc53cd2-9114-4067-ab0b-37fd8cd79240
# ╠═0db51d39-7c05-4e00-b951-7fe776a8e0f9
# ╠═e2b79a58-e66e-4d40-8673-418823753b38
# ╟─9d23382c-cf35-4b20-a46c-0f4e2de17fc7
# ╟─959acb40-1fd6-43f5-a1a6-73a6ceaae1d7
# ╠═4d611425-c8e3-4bc3-912b-8bc0465363bc
# ╠═a5490a6b-dc11-42b7-87e0-d38870fc55e4
# ╠═705e30fe-77a3-4b06-8b99-1807290edffb
# ╟─2ee7f26d-f383-4e7e-a69a-8fb72717467c
# ╟─79beba88-932f-4147-b3a0-d821ef1bc1e2
# ╠═63d6c2df-a411-407c-af11-4f5d09fbb322
# ╠═633029af-8cac-426e-b35c-c9fb3938b784
# ╟─2073f11e-8196-4ebc-922f-5fa589e91797
# ╠═811cf78b-e870-45bb-9173-89a3b3d495f5
# ╟─3a066bf4-3466-469e-90d0-6b14be3ed8d5
# ╟─3213d977-7b65-43b0-a881-10fcc2523f14
# ╠═903fee67-6b23-41dc-a03d-f1040b696be6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
