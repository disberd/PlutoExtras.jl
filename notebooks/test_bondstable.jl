### A Pluto.jl notebook ###
# v0.19.22

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

# ╔═╡ 1ffc6489-6a3d-4bd1-94e5-4a843b614b20
# ╠═╡ show_logs = false
# ╠═╡ skip_as_script = true
#=╠═╡
begin
	import Pkg
	Pkg.activate(Base.current_project())
	using Revise
end
  ╠═╡ =#

# ╔═╡ 5a4abd25-143a-49ea-a6b9-2b6c55e70a2c
begin
	using PlutoExtras
	using PlutoExtras.StructBondModule # This submodule has the features listed in this notebook
	using PlutoUI
	using HypertextLiteral
end

# ╔═╡ 5fbd1401-c7a1-4d4f-b16d-ac9d45e2fed5
md"""
# Packages
"""

# ╔═╡ cfa79196-9e04-4d0e-a6b1-5641e123f3d3
ExtendedTableOfContents()

# ╔═╡ 5a9b27c3-df02-415c-87bd-06ebd3c9d246
md"""
# StructBond
"""

# ╔═╡ 9da65874-608a-4c84-a0e6-813c624c07ba
md"""
Generating automatic widgets for custom structs is quite straightforward with the aid of the `@fielddata` macro and the `StructBond` type.

The top-left arrow can be used to show-hide the field elements (useful inside a `BondTable`, shown below), while the green toggle on the top-right can be used to disable temporarily the synch between the JS widgets and the bond values in Pluto.
"""

# ╔═╡ 9a9fc01e-c25d-11ed-0147-b155e63ffba7
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

# ╔═╡ 1442a2eb-b38b-4757-b02c-96b599084889
asd

# ╔═╡ 65a3ed8e-6204-4aee-adfc-befe9ea5153e
md"""
# @NTBond
"""

# ╔═╡ 8c8fd549-0afc-4452-bd6a-6564862a1d63
md"""
Sometimes custom structs are not needed and it would be useful to just use the same nice bond structure of `StructBond` to simply create arbitrary NamedTuples. 

This is possible with the convenience macro `@NTBond` which can be called as shown below to create a nice display for an interactive bond creating an arbitrary NamedTuple.

The macro simply create a `StructBond` wrapping the desired NamedTuple type.
"""

# ╔═╡ 9faf2258-3f2b-450c-bbfe-d8231e0e4d74
nt_bond = @bind nt @NTBond "My Fancy NTuple" begin
	a = ("Description", Slider(1:10))
	b = (md"**Bold** field", Slider(1:10))
	c = Slider(1:10) # No description, defaults to the name of the field
end

# ╔═╡ c183e38f-84e3-4a1f-a631-6d1db39f1179
nt

# ╔═╡ 8ab2af4c-92a2-429f-b641-95a028808ae5
md"""
# @BondsList
"""

# ╔═╡ 29592194-2f89-49cc-9a20-7a8e9cd44ae9
md"""
In some cases, one does not want to have a single bond wrapping either a Structure or a NamedTuple, and single independent bonds are more convenient.

`@BondsList` is a convenience macro to create an object of type `BondsList` which simply allow to add a description to separate bonds and group them all together in a table-like format equivalent to those of `StructBond`.

!!! note
	Unlike `StructBond`, a BondsList is already composed of bond created with `@bind` and it just groups them up with a description. The output of `@BondsList` is not supposed to be bound to a variable using `@bind`.\
	The bonds grouped in a BondsList still act and update independently from one another.

See the example below for understanding the synthax. The header of a BondsList is shown in an orange background to easily differentiate it from `StructBond`.
"""

# ╔═╡ 6091cdf4-c0ec-45f6-8aa0-d4faf6666d2d
bl = @BondsList "My Group of Bonds" let tv = PlutoUI.Experimental.transformed_value
	 # We use transformed_value to translate GHz to Hz in the bound variable `freq`
	"Frequency [GHz]" = @bind freq tv(x -> x * 1e9, Editable(20; suffix = " GHz"))
	md"Altitude ``h`` [m]" = @bind alt Scrubbable(100:10:200)
end

# ╔═╡ 8d912297-925e-4c8b-98b8-19b43c9b29d7
freq

# ╔═╡ 9a1baa3d-1420-473c-8380-bb5c23881e00
md"""
# Popout
"""

# ╔═╡ 93255c24-d486-416d-aefc-7575feff7543
md"""
The structures above can also be used nested within one another. To facilitate accessing nested structures, one can use the `Popout` type.

In its simple form, you can give an instance of a StructBond, a bond wrapping a StructBond or a BondsList as input to Popout to create a table that is hidden behind a popup window.
If an instance present, but you want a custom type for which you have defined custom bonds and descriptions with `@fielddata` to appear as popout, you can use the function `popoutwrap(TYPE)` to generate a small icon which hides a popup containing the `StructBond` of the provided type `TYPE`.

The StructBond table appears on hover upon the icon, can be made fixed by clicking on the icon and can then be moved around or resized.
A double click on the header of the popout hides it again:
"""

# ╔═╡ 978f70ea-393e-4f3d-93fb-c5a83443d079
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

# ╔═╡ 6c56c205-ac72-4556-b95e-b278e4b3f822
popoutwrap(LOL)

# ╔═╡ 38535cbe-093d-4452-b2a9-999183199801
md"""
The ability to also wrap pre-existing bonds around StructBonds is convenient for organizing the various bonds one have in a `BondsList` or `BondTable`

As an example, one can create a `BondsList` containing the two `StructBond` bonds generated at the beginning of this notebook with the follwing code.
"""

# ╔═╡ 95ad9428-73f8-4f57-9185-9685b9a2123f
blc = @BondsList "Popout Container" begin
	"Structure ASD" = Popout(asd_bond)
	"NamedTuple" = Popout(nt_bond)
end

# ╔═╡ 373bc244-110a-43f8-aaa1-51b5cb751128
md"""
# BondTable
"""

# ╔═╡ b3fb23b8-8652-469b-8d0c-0c6c2723b631
md"""
The final convenience structure provided by this module is the `BondTable`. It can be created to group a list of bonds in a floating table that stays on the left side of the notebook (similar to the TableOfContents of PlutoUI) and can be moved around and resized or hidden for convenience.

The BondTable is intended to be used either with bonds containing `StructBond` or with `BondsList`. Future types with similar structure will also be added.

Here is an example of a bondtable containing all the examples of this notebook.
"""

# ╔═╡ 75fc40a3-4231-4125-b52c-ad21f5b8a388
BondTable([
	asd_bond,
	nt_bond,
	bl,
	blc
]; description = "My Bonds")

# ╔═╡ Cell order:
# ╠═1ffc6489-6a3d-4bd1-94e5-4a843b614b20
# ╟─5fbd1401-c7a1-4d4f-b16d-ac9d45e2fed5
# ╠═5a4abd25-143a-49ea-a6b9-2b6c55e70a2c
# ╠═cfa79196-9e04-4d0e-a6b1-5641e123f3d3
# ╟─5a9b27c3-df02-415c-87bd-06ebd3c9d246
# ╟─9da65874-608a-4c84-a0e6-813c624c07ba
# ╠═9a9fc01e-c25d-11ed-0147-b155e63ffba7
# ╠═1442a2eb-b38b-4757-b02c-96b599084889
# ╟─65a3ed8e-6204-4aee-adfc-befe9ea5153e
# ╟─8c8fd549-0afc-4452-bd6a-6564862a1d63
# ╠═9faf2258-3f2b-450c-bbfe-d8231e0e4d74
# ╠═c183e38f-84e3-4a1f-a631-6d1db39f1179
# ╟─8ab2af4c-92a2-429f-b641-95a028808ae5
# ╟─29592194-2f89-49cc-9a20-7a8e9cd44ae9
# ╠═6091cdf4-c0ec-45f6-8aa0-d4faf6666d2d
# ╠═8d912297-925e-4c8b-98b8-19b43c9b29d7
# ╟─9a1baa3d-1420-473c-8380-bb5c23881e00
# ╟─93255c24-d486-416d-aefc-7575feff7543
# ╠═978f70ea-393e-4f3d-93fb-c5a83443d079
# ╠═6c56c205-ac72-4556-b95e-b278e4b3f822
# ╟─38535cbe-093d-4452-b2a9-999183199801
# ╠═95ad9428-73f8-4f57-9185-9685b9a2123f
# ╟─373bc244-110a-43f8-aaa1-51b5cb751128
# ╟─b3fb23b8-8652-469b-8d0c-0c6c2723b631
# ╠═75fc40a3-4231-4125-b52c-ad21f5b8a388
