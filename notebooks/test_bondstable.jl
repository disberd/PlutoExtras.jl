### A Pluto.jl notebook ###
# v0.20.5

#> custom_attrs = ["hide-enabled"]

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    #! format: off
    return quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
    #! format: on
end

# ╔═╡ 949ac1ef-c502-4e28-81ff-f99b0d19aa03
begin
	using PlutoExtras.StructBondModule
    using PlutoExtras
	using PlutoExtras: ExtendedTableOfContents, Editable
	using HypertextLiteral
	using PlutoUI
end

# ╔═╡ 9d4455af-96f1-46d7-a4f3-434495b11c8a
md"""
# Packages
"""

# ╔═╡ 707175a9-d356-43cf-8038-620ebc401c93
ExtendedTableOfContents()

# ╔═╡ cbfc6eec-8991-4a9c-ada0-295c8052854d
# html"""
# <style>
# main {
# 	margin-right: 350px !important;
# }
# </style>
# """

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
@typeasfield String = TextField() # String fields with no struct-specific default will use this 
@fielddata ASD begin
	a = (md"Markdown description, including ``LaTeX``", Slider(1:10))
	b = (@htl("<span>Field with <b>HTML</b> description</span>"), Scrubbable(1:10))
	c = ("Normal String Description", TextField())
	# d has no ASD-specific custom bond, so it will use the field docstring as description and the default String widget as widget
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

# ╔═╡ 466995a2-dfd4-4374-8339-bc0232039b27
md"""
## transformed_value
"""

# ╔═╡ 4cb128aa-7ad8-4d17-bced-36845703e6a8
md"""
`@NTBond` is also quite useful in combination with `transformed_value` from `PlutoUI.Experimental`. For this reason, the `@NTBond` macro supports an optional third argument which shall be a function that when provided is directly used to transform the value of the widget.
"""

# ╔═╡ 7855826e-ccaa-4c27-a060-f5ceb927bbe8
@bind transformed_value_example @NTBond "Transformed!" begin
	a = Slider(1:10)
	b = Slider(1:10)
end nt -> nt.a + nt.b

# ╔═╡ 1d5573ee-872e-4dfb-a785-1ac9e836ad98
transformed_value_example

# ╔═╡ f65b3231-f2b2-45dc-b72e-1ad3107083fc
md"""
# StructBondSelect
"""

# ╔═╡ 67c0860b-b4c1-412d-870a-a4ce4987465e
md"""
Sometimes, one wants to create a more complex binding where the number of parameters to control a bond can vary depending on some other variable. The `StructBondSelect` can be of help in some of these cases, by providing a way to select out of a number of arbitrary `StructBonds` (which include `@NTBond`) by using a dropdown to select the one to be displayed and used for generating the `StructBondSelect` widget's output.

This structure can be constructed with a vector of `StructBond` or `transformed_value(f, ::StructBond)` elements, and will take care of generating an appropriate widget to display and process only the selected one.

The main signature of the constructor is the following:
```julia
StructBondSelect(els::Vector; description = "StructBondSelect", default_idx = 1, selector_text = "Selector")
```

The names to select upon will be taken from the `description` of the provided `StructBonds`, while the text displayed next to the _selector_ will default to `Selector` but can be customized with the `selector_text` kwarg to the constructor.
The `description` kwarg can be used to customize the text in the widget container (similar to the same kwarg in `StructBond` and to `@NTBond`). Finally, the `default_idx` should be an integer and will select which of the provided `StructBond`s will be selected as default when instantiating the widget.
"""

# ╔═╡ bd5ec086-5156-4e7c-a70b-5ca9f089bb49
sbs_bond = @bind sbs StructBondSelect([
	@NTBond "cos(arg)" begin
		arg = Slider(range(0,1,100))
	end (nt -> cos(nt.arg)) # We need to wrap the function given to `@NTBond` in () to avoid parse problems when providing a function
	@NTBond "atan(y,x)" begin
		x = Slider(range(0,10; step = 0.1); default = 3, show_value=true)
		y = Slider(range(0, 10; step = 0.1); default = 5, show_value=true)
	end nt -> atan(nt.y, nt.x)
]; default_idx = 2, selector_text = "Options:")

# ╔═╡ 7853cc7f-4e58-44d1-8d3b-f8d4745564e6
sbs

# ╔═╡ 9d23382c-cf35-4b20-a46c-0f4e2de17fc7
md"""
# @BondsList
"""

# ╔═╡ 959acb40-1fd6-43f5-a1a6-73a6ceaae1d7
md"""
In some cases, one does not want to have a single bond wrapping either a Structure or a NamedTuple because single independent bonds are more convenient.

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
@bind lol_pop popoutwrap(LOL)

# ╔═╡ 065bad73-5fa8-4496-ba33-9e66940b5806
lol_pop

# ╔═╡ 2073f11e-8196-4ebc-922f-5fa589e91797
md"""
The ability to also wrap pre-existing bonds around StructBonds is convenient for organizing the various bonds one have in a `BondsList` or `BondTable`

As an example, one can create a `BondsList` containing the two `StructBond` bonds generated at the beginning of this notebook with the follwing code.
"""

# ╔═╡ 811cf78b-e870-45bb-9173-89a3b3d495f5
blc = @BondsList "Popout Container" begin
	"Structure ASD" = Popout(asd_bond)
	"NamedTuple" = Popout(nt_bond)
	"StructBondSelect" = Popout(sbs_bond)
end

# ╔═╡ e7d67662-77b3-482a-b032-8db4afbc01a6
asd

# ╔═╡ 996b4085-114c-48f4-9f90-8e637f29c06a
nt

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

# ╔═╡ 08d711c0-e2cc-4444-94ca-0c4c3cfe901f
nt

# ╔═╡ 03e9d75e-e6c9-4199-933b-2be306daf978
asd

# ╔═╡ 26d11600-2827-4e08-9195-109c8a8bddc3
freq

# ╔═╡ be2a7820-e194-4410-b00d-a9332b234ad6
alt

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
HypertextLiteral = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
PlutoExtras = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.11.4"
manifest_format = "2.0"
project_hash = "0ca0567f5f0621438fc69800c85ba1867d3b56e4"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "6e1d2a35f2f90a4bc7c2ed98079b2ba09c35b83a"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.3.2"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"
version = "1.1.2"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"
version = "1.11.0"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"
version = "1.11.0"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "b10d0b65641d57b8b4d5e234446582de5047050d"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.5"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"
version = "1.1.1+0"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"
version = "1.11.0"

[[deps.DocStringExtensions]]
git-tree-sha1 = "e7b7e6f178525d17c720ab9c081e4ef04429f860"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.9.4"

[[deps.Downloads]]
deps = ["ArgTools", "FileWatching", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"
version = "1.6.0"

[[deps.FileWatching]]
uuid = "7b1f6079-737a-58dc-b8bc-7a2ca5c1b5ee"
version = "1.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "05882d6995ae5c12bb5f36dd2ed3f61c98cbb172"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.5"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "179267cfa5e712760cd43dcae385d7ea90cc25a4"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.5"

[[deps.HypertextLiteral]]
deps = ["Tricks"]
git-tree-sha1 = "7134810b1afce04bbc1045ca1985fbe81ce17653"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.5"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "b6d6bfdd7ce25b0f9b2f6b3dd56b2673a66c8770"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.5"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"
version = "1.11.0"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "31e996f0a15c7b280ba9f76636b3ff9e2ae58c9a"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.4"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"
version = "0.6.4"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "8.6.0+0"

[[deps.LibGit2]]
deps = ["Base64", "LibGit2_jll", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"
version = "1.11.0"

[[deps.LibGit2_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll"]
uuid = "e37daf67-58a4-590a-8e99-b0245dd2ffc5"
version = "1.7.2+0"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.11.0+1"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"
version = "1.11.0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "OpenBLAS_jll", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
version = "1.11.0"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"
version = "1.11.0"

[[deps.MIMEs]]
git-tree-sha1 = "c64d943587f7187e751162b3b84445bbbd79f691"
uuid = "6c6e2e6c-3030-632d-7369-2d6c69616d65"
version = "1.1.0"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"
version = "1.11.0"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.6+0"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"
version = "1.11.0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2023.12.12"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"
version = "0.3.27+1"

[[deps.Parsers]]
deps = ["Dates", "PrecompileTools", "UUIDs"]
git-tree-sha1 = "44f6c1f38f77cafef9450ff93946c53bd9ca16ff"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.8.2"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "Random", "SHA", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.11.0"
weakdeps = ["REPL"]

    [deps.Pkg.extensions]
    REPLExt = "REPL"

[[deps.PlutoExtras]]
deps = ["AbstractPlutoDingetjes", "DocStringExtensions", "HypertextLiteral", "InteractiveUtils", "Markdown", "PlutoUI", "REPL", "Random"]
git-tree-sha1 = "3d3ec40825d248b096fd4afe780db72919c4b979"
repo-rev = "69805dacb340097257462ceb535f8ddeac406a90"
repo-url = "https://github.com/disberd/PlutoExtras.jl.git"
uuid = "ed5d0301-4775-4676-b788-cf71e66ff8ed"
version = "0.7.14"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "FixedPointNumbers", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "MIMEs", "Markdown", "Random", "Reexport", "URIs", "UUIDs"]
git-tree-sha1 = "d3de2694b52a01ce61a036f18ea9c0f61c4a9230"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.62"

[[deps.PrecompileTools]]
deps = ["Preferences"]
git-tree-sha1 = "5aa36f7049a63a1528fe8f7c3f2113413ffd4e1f"
uuid = "aea7be01-6a6a-4083-8856-8a6e6704d82a"
version = "1.2.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "9306f6085165d270f7e3db02af26a400d580f5c6"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.4.3"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"
version = "1.11.0"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "StyledStrings", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"
version = "1.11.0"

[[deps.Random]]
deps = ["SHA"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"
version = "1.11.0"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"
version = "0.7.0"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"
version = "1.11.0"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"
version = "1.11.0"

[[deps.Statistics]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "ae3bb1eb3bba077cd276bc5cfc337cc65c3075c0"
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"
version = "1.11.1"

    [deps.Statistics.extensions]
    SparseArraysExt = ["SparseArrays"]

    [deps.Statistics.weakdeps]
    SparseArrays = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.StyledStrings]]
uuid = "f489334b-da3d-4c2e-b8f0-e476e12c162b"
version = "1.11.0"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"
version = "1.0.3"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"
version = "1.10.0"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"
version = "1.11.0"

[[deps.Tricks]]
git-tree-sha1 = "6cae795a5a9313bbb4f60683f7263318fc7d1505"
uuid = "410a4b4d-49e4-4fbc-ab6d-cb71b17b3775"
version = "0.1.10"

[[deps.URIs]]
git-tree-sha1 = "cbbebadbcc76c5ca1cc4b4f3b0614b3e603b5000"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.5.2"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"
version = "1.11.0"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"
version = "1.11.0"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"
version = "1.2.13+1"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"
version = "5.11.0+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.59.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+2"
"""

# ╔═╡ Cell order:
# ╟─9d4455af-96f1-46d7-a4f3-434495b11c8a
# ╠═949ac1ef-c502-4e28-81ff-f99b0d19aa03
# ╠═707175a9-d356-43cf-8038-620ebc401c93
# ╠═cbfc6eec-8991-4a9c-ada0-295c8052854d
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
# ╟─466995a2-dfd4-4374-8339-bc0232039b27
# ╟─4cb128aa-7ad8-4d17-bced-36845703e6a8
# ╠═7855826e-ccaa-4c27-a060-f5ceb927bbe8
# ╠═1d5573ee-872e-4dfb-a785-1ac9e836ad98
# ╟─f65b3231-f2b2-45dc-b72e-1ad3107083fc
# ╟─67c0860b-b4c1-412d-870a-a4ce4987465e
# ╠═bd5ec086-5156-4e7c-a70b-5ca9f089bb49
# ╠═7853cc7f-4e58-44d1-8d3b-f8d4745564e6
# ╟─9d23382c-cf35-4b20-a46c-0f4e2de17fc7
# ╟─959acb40-1fd6-43f5-a1a6-73a6ceaae1d7
# ╠═4d611425-c8e3-4bc3-912b-8bc0465363bc
# ╠═a5490a6b-dc11-42b7-87e0-d38870fc55e4
# ╠═705e30fe-77a3-4b06-8b99-1807290edffb
# ╟─2ee7f26d-f383-4e7e-a69a-8fb72717467c
# ╟─79beba88-932f-4147-b3a0-d821ef1bc1e2
# ╠═63d6c2df-a411-407c-af11-4f5d09fbb322
# ╠═633029af-8cac-426e-b35c-c9fb3938b784
# ╠═065bad73-5fa8-4496-ba33-9e66940b5806
# ╟─2073f11e-8196-4ebc-922f-5fa589e91797
# ╠═811cf78b-e870-45bb-9173-89a3b3d495f5
# ╠═e7d67662-77b3-482a-b032-8db4afbc01a6
# ╠═996b4085-114c-48f4-9f90-8e637f29c06a
# ╟─3a066bf4-3466-469e-90d0-6b14be3ed8d5
# ╟─3213d977-7b65-43b0-a881-10fcc2523f14
# ╠═903fee67-6b23-41dc-a03d-f1040b696be6
# ╠═08d711c0-e2cc-4444-94ca-0c4c3cfe901f
# ╠═03e9d75e-e6c9-4199-933b-2be306daf978
# ╠═26d11600-2827-4e08-9195-109c8a8bddc3
# ╠═be2a7820-e194-4410-b00d-a9332b234ad6
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
