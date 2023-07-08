### A Pluto.jl notebook ###
# v0.19.26

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

# ╔═╡ c132e4b8-eaec-435f-95ea-4c96ca8e3118
begin
	using PlutoDevMacros.Script
	using PlutoDevMacros
end

# ╔═╡ 478090cb-6d31-43c5-b5d4-c3e059bfff5e
@fromparent begin
	using >.HypertextLiteral
	using >.PlutoUI
	import ^: ExtendedTableOfContents
	using *
end

# ╔═╡ d933d50a-9649-4acc-81f7-e3eac26a6ae5
md"""
# Packages
"""

# ╔═╡ e44cac24-ee90-43b6-8c45-8a3afd61918d
# ╠═╡ skip_as_script = true
#=╠═╡
ExtendedTableOfContents()
  ╠═╡ =#

# ╔═╡ 57ac01d8-a284-4388-8670-184ffd25b17f
md"""
# Notebook Local Variables
"""

# ╔═╡ 0bab1bff-138d-4db3-b092-052ff3205f16
md"""
# Load inner modules
"""

# ╔═╡ 1d38cc1a-6e05-4fd2-8cb1-86cad5ee5151
md"""
# NTBond
"""

# ╔═╡ 55b394f2-ebfa-4d98-84f2-ee94d81f41c7
md"""
# Popout
"""

# ╔═╡ 6a1db028-e0a9-4de9-8fb6-991993aba41e
begin
"""
	Popout(T)
Create an HTML widget wrapping the widget `T` and showing it either on hover or upon click.

This is useful to generat widgets to be used with [`StructBond`](@ref) for custom fields whose types are custom Types.

The convenience function [`popoutwrap`](@ref) can be used to directly create a `Popup` of a `StructBond{T}` to facilitate nested `StructBond` views.

See also: [`BondTable`](@ref), [`StructBond`](@ref), [`popoutwrap`](@ref), [`@fieldbond`](@ref), [`@fielddescription`](@ref), [`@fieldhtml`](@ref), [`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
Base.@kwdef struct Popout{T}
	element::T
	secret_key::String=String(rand('a':'z', 10))
end
Popout(element::T) where T = Popout{T}(;element)
end

# ╔═╡ 722ff625-e232-47ca-9c2a-6c5c2ec2a6cc
begin
	function Bonds.initial_value(t::Popout{T}) where T
		transformed = Bonds.initial_value(t.element)
	end
	function Bonds.transform_value(t::Popout{T}, from_js) where T
		transformed = Bonds.transform_value(t.element, from_js |> first)
	end
end

# ╔═╡ eb139a5e-1d4c-4c2f-9f0c-4e305fc0fc7c
md"""
## popoutwrap
"""

# ╔═╡ 3ea95602-765e-4ec6-87e3-b49404673e1e
"""
	popoutwrap(T)
Convenience function to construct a `Popout` wrapping a `StructBond` of type `T`. This is convenient when one wants to create nested `StructBond` types.

Given for example the following two structures
```
Base.@kwdef struct ASD
	a::Int 
	b::Int
	c::String
end
Base.@kwdef struct LOL
	asd::ASD 
	text::String
end
```
one can create a nice widget to create instances of type `LOL` that also include a popout of widget generating `ASD` wih the following code:
```
# Define the widget for ASD
@fieldbond ASD begin
	a = Slider(1:10)
	b = Scrubbable(1:10)
	c = TextField()
end
@fielddescription ASD begin
	a = md"Magical field with markdown description"
	b = @htl "<span>Field with HTML description</span>"
	c = "Normal String Description"
end

# Define the widget for LOL
@fieldbond LOL begin
	asd = popoutwrap(ASD)
	text = TextField(;default = "Some Text")
end
@fielddescription LOL begin
	asd = "Click on the icon to show the widget to generate this field"
	text = "Boring Description"
end
@bind lol StructBond(LOL)
```
where `lol` will be an instance of type `LOL` with each field interactively controllable by the specified widgets and showing the field description next to each widget.

See also: [`BondTable`](@ref), [`StructBond`](@ref), [`Popout`](@ref), [`@fieldbond`](@ref), [`@fielddescription`](@ref), [`@fieldhtml`](@ref), [`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
popoutwrap(T::Type) = Popout(StructBond(T))

# ╔═╡ d8340d9b-cd1c-4aae-9aaf-de6819fb10b6
md"""
## Interact
"""

# ╔═╡ 898c1182-e115-4548-93ba-ac95ec5fe6c9
popup_interaction_handler = HTLScriptPart(@htl """
<script>
	// We use the interactjs library to provide drag and resize handling across devices
	const { default: interact } = await import('https://esm.sh/interactjs')

	contents.offset = contents.offset ?? { x: 0, y: 0}
	const startPosition = {x: 0, y: 0}
	interact(contents.querySelector('togglereactive-header .description, bondslist-header .description')).draggable({
		listeners: {
			start (event) {
				contents.offset.y = startPosition.y = contents.offsetTop
				contents.offset.x = startPosition.x = contents.offsetLeft
			},
			move (event) {
		      contents.offset.x += event.dx
		      contents.offset.y += event.dy
		
		      contents.style.top = `min(95vh, \${contents.offset.y}px`
		      contents.style.left = `min(95vw, \${contents.offset.x}px`
		    },
		}
	}).on('doubletap', function (event) {
		  // Double-tap on header reset the position
		container.popout()
	})
	interact(contents)
	  .resizable({
	    edges: { top: true, left: false, bottom: true, right: true },
	    listeners: {
	      move: function (event) {		
	        Object.assign(event.target.style, {
	          width: `\${event.rect.width}px`,
	          height: `\${event.rect.height}px`,
	        })
	      }
	    }
	  }).on('doubletap', function (event) {
		  // Double-tap on resize reset the width
			contents.style.width = ''
		  	contents.style.height = ''
	  })
</script>
""");

# ╔═╡ ed2bb10a-0bb6-4c34-bd19-daba2be037d2
md"""
## Show
"""

# ╔═╡ 01e6edd9-d3ed-464f-9267-bf8f3ed24b21
_show_popout(p::Popout) = wrapped() do Child
@htl("""
<popout-container key='$(p.secret_key)'>
	<popout-header><span class='popout-icon popout'></span></popout-header>
	<popout-contents>$(Child(p.element))</popout-contents>
</popout-container>
<script id='$(p.secret_key)'>
	// Load the floating-ui and interact libraries
	window.floating_ui = await import('https://esm.sh/@floating-ui/dom')

	const { computePosition, autoPlacement } = floating_ui
	
	const container = currentScript.previousElementSibling
	const header = container.firstElementChild
	const contents = container.lastElementChild

	// Load the interactjs part
	$popup_interaction_handler

	function positionContents() {
		computePosition(header, contents, {
			strategy: "fixed",
			middleware: [autoPlacement()],
		}).then((pos) => {
			contents.style.left = pos.x + "px"
			contents.style.top = pos.y + "px"
		})
	}

	container.popout = (force = undefined) => {
		container.classList.toggle('popped', force)
		positionContents()
	}

	header.onclick = (e) => {container.popout()}

	contents.onmouseenter = (e) => container.classList.toggle('contents-hover', true)
	contents.onmouseleave = (e) => container.classList.toggle('contents-hover', false)

	header.onmouseenter = (e) => {
		container.classList.toggle('header-hover', true)
		container.classList.contains('popped') ? null : positionContents()
	}
	header.onmouseleave = (e) => container.classList.toggle('header-hover', false)
</script>
<style>
	popout-header {
		display: flex;
		border: 3px dashed transparent;
		border-radius: 10px;
		justify-content: center;
	}
	popout-contents {
		display: none;
		width: 400px;
		background: var(--overlay-button-bg);
    	border: 3px solid var(--overlay-button-border);
    	border-radius: 10px;
    	padding: 8px;
	}
	popout-container.popped > popout-contents,
 	popout-container.header-hover > popout-contents {
		display: block;
		position: fixed;
		z-index: 500;
	}
	popout-container.contents-hover > popout-header {
		border-color: var(--pluto-logs-warn-accent-color);
	}
	.popout-icon {
		--size: 20px;
	    display: block;
	    align-self: stretch;
	    background-size: var(--size) var(--size);
	    background-repeat: no-repeat;
	    background-position: center;
	    width: var(--size);
		min-height: var(--size);
	    filter: var(--image-filters);
	}
	.popout-icon.popout {	
	    background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/expand.svg);
	}
	popout-container.popped .popout {
	    background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/contract.svg);
	}
	popout-container.popped togglereactive-header > .description {
		touch-action: none;
		user-select: none;
	}
</style>
""")
end

# ╔═╡ 728831d6-4222-4ea2-9ac4-35e1b9434d0e
Base.show(io::IO, mime::MIME"text/html", p::Popout) = show(io, mime, _show_popout(p))

# ╔═╡ 7f644704-ad49-437c-8b18-ad657e4d78e8
md"""
# BondWithDescription
"""

# ╔═╡ 30aec475-caef-46f5-b8d4-e4ad4febb132
begin
struct BondWithDescription
	description
	bond
	function BondWithDescription(description, bond)
		_isvalid(BondWithDescription, bond) || error("It looks like the `bond` provided to `BondWithDescription` is not of the correct type, provide the bond given as output by the `Pluto.@bind` macro")
		new(description, bond)
	end
end
_isvalid(T::Type{BondWithDescription}, p::Popout) = _isvalid(T, p.element)
_isvalid(::Type{BondWithDescription}, value::T) where T = nameof(T) == :Bond && fieldnames(T) == (:element, :defines, :unique_id)
end

# ╔═╡ 9dcb9704-3029-458a-80c4-cb1a0635b78c
_getbond(x::T) where T = let
	if nameof(T) == :Bond && fieldnames(T) == (:element, :defines, :unique_id) 
		return x
	else
		error("The provided input is not a bond or does not seem to wrap a bond")
	end
end

# ╔═╡ 183af7ed-4825-4c2f-935b-0c222e4a8054
_getbond(x::Popout) = _getbond(x.element)

# ╔═╡ 4f63b9ae-2ba5-49a7-928b-18b5f5e200b3
md"""
## Show
"""

# ╔═╡ 5efe7901-2f11-42c1-b59d-17074e3899fe
Base.show(io::IO, mime::MIME"text/html", bd::BondWithDescription) = show(io, mime, @htl("""
<bond-with-description>
	<bond-description title=$(join(["This bond is assigned to variable `", String(_getbond(bd.bond).defines), "`"]))>
		$(bd.description)
	</bond-description>
	<bond-value>
		$(bd.bond)
	</bond-value>
	<style>
		bond-with-description {
			display: grid;
			grid-template-columns: 1fr minmax(min(50px, 100%), .4fr);
			grid-auto-rows: fit-content(40px);
			justify-items: center;
		}
		bondtable-contents bond-with-description,
		bondslist-contents bond-with-description {
			display: contents;
		}
		bond-value bond {
			display: flex; // Needed for consistent sizing (width) of the input
		}
		bond-value input {
			width: 100%; // Needed for consistent sizing (width) of the input
		}
	</style>
</bond-with-description>
"""))

# ╔═╡ 145a1b46-16b5-497c-a949-6f61507190b8
# ╠═╡ skip_as_script = true
#=╠═╡
BondWithDescription("DIO", @bind slakdjflaskdfj Slider(1:10))
  ╠═╡ =#

# ╔═╡ 94a04779-0a3f-4e40-8c0e-c9cb1db08dd7
md"""
# Bonds List
"""

# ╔═╡ d04b6c4c-aa81-4442-a992-e70351128433
begin
Base.@kwdef struct BondsList
	description
	bonds::Vector{BondWithDescription}
	secret_key::String=String(rand('a':'z', 10))
end
BondsList(description, bonds) = BondsList(;description, bonds)
end

# ╔═╡ 8b802a62-eb1e-47f7-bb04-1566fe9c4fe3
popoutwrap(t::Union{StructBond, BondsList}) = Popout(t)

# ╔═╡ c8a3ab1c-91dc-4955-97e0-1d45477b4e05
md"""
## Show
"""

# ╔═╡ c1ab1625-dd01-4a51-bd8b-6b9d32104a0f
Base.show(io::IO, mime::MIME"text/html", bl::BondsList) = show(io, mime, @htl("""
<bondslist-container class='no-popout'>
	<bondslist-header>
		<span class='collapse bondslist-icon'></span>
		<span class='description' title="This list contains independent bonds">$(bl.description)</span>
		<span class='toggle bondslist-icon'></span>
	</bondslist-header>
	<bondslist-contents>
	$(bl.bonds)	
	</bondslist-contents>
	<script id=$(bl.secret_key)>
		const container = currentScript.parentElement
		container.collapse = (force) => {
			container.classList.toggle('collapsed', force)
		}
		const collapse_btn = container.querySelector('span.collapse')
		collapse_btn.onclick = (e) => container.collapse()
	</script>
	<style>
		bondslist-header {
			grid-column: 1 / -1;
			display: flex;
			background: var(--overlay-button-bg);
		}		
		bondslist-header:before {
			content: '';
			display: inline-block;
			position: absolute;
			top: 0px;
			bottom: 0px;
			left: 0px;
			right: 0px;
			z-index: -1;
			background: #ffac4540;
		}
		bondslist-container.no-popout > bondslist-header {
			align-self: start;
			position: sticky;
			top: 0px;
			padding-top: 12px;
			margin-top: -12px;
			z-index: 10;
		}
		bondslist-contents {
			display: contents;
		}
		bondslist-container.no-popout:before {
			content: '';
			display: block;
			grid-column: 1 / -1;
			justify-self: center;
			border-bottom: 2px solid;
			padding-top: 5px;
			width: 100%;
			align-self: start;
			position: sticky;
			top: 0px;
			background: var(--overlay-button-bg);
			z-index: 20;
		}
		bondslist-header > .bondslist-icon {
			--size: 17px;
			display: block;
			align-self: stretch;
			background-size: var(--size) var(--size);
			background-repeat: no-repeat;
			background-position: center;
			width: var(--size);
			filter: var(--image-filters);
		}
		bondslist-header > .collapse {
			background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down.svg);
			cursor: pointer;
		}
		bondslist-container.collapsed > bondslist-header > .collapse {
			background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-forward.svg);
		}
		bondslist-header > .toggle {
			display: inline-block;
			width: 30px;
			margin: 0 10px;
		}
		bondslist-header {
			display: flex;
			align-items: stretch;
			width: 100%;
		}
		bondslist-header > .description {
			text-align: center;
			flex-grow: 1;
			font-size: 18px;
			font-weight: 600;
		}
		bondslist-header > .toggle {
			align-self: center
		}
		bondslist-container.collapsed bondslist-header + * {
			display: none !important;
		}
		bondslist-container {
			display: grid;
		    grid-template-columns: 1fr minmax(min(50px, 100%), .4fr);
		    grid-auto-rows: fit-content(40px);
		    justify-items: center;
		    align-items: center;
		    row-gap: 5px;
		}
		bondstable-container bondslist-container {
			display: contents;
		}
		
</style>
</bondslist-container>
"""))

# ╔═╡ 8712d1bf-1a00-4553-8794-0ae411be7e00
md"""
## Macro
"""

# ╔═╡ 04739111-2441-4274-860f-b571cdcb1156
"""
	@BondsList description block
Convenience macro to create a `BondsList`, which is a grouping of a various bonds (created with `@bind`) inside a table-like HTML output that can be used inside [`BondTable`](@ref). Each bond can additionally be associated to a custom description.
The `block` given as second input to this macro must be a `begin` or `let` block where each line is an assignment of the type `description = bond`. The description can be anything that has a `show` method for MIME type `text/html`.

An example usage is given in the code below:
```
@BondsList "My Group of Bonds" let tv = PlutoUI.Experimental.transformed_value
	 # We use transformed_value to translate GHz to Hz in the bound variable `freq`
	"Frequency [GHz]" = @bind freq tv(x -> x * 1e9, Slider(1:10))
	md"Altitude ``h`` [m]" = @bind alt Scrubbable(100:10:200)
end
```
which will create a table-like display grouping together the bonds for the frequency `freq` and the altitude `alt`.

Unlike [`StructBond`](@ref), the output of `@BondsList` is not supposed to be bound using `@bind`, as it just groups pre-existing bonds. Also unlike `StructBond`, each row of a `BondsList` upates its corresponding bond independently from the other rows.

To help identify and differentiate a `BondsList` from a `StructBond`

See also: [`BondTable`](@ref), [`@NTBond`](@ref), [`StructBond`](@ref), [`Popout`](@ref), [`popoutwrap`](@ref), [`@fielddata`](@ref), [`@fieldhtml`](@ref), [`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
macro BondsList(description, block)
	Meta.isexpr(block, [:block, :let]) || error("Only `let` or `begin` blocks are supported as second argument to the `@BondsList` macro")
	bindings, block = if block.head == :let
		block.args
	else
		# This is a normal begin-end so we create an empty bindings block
		Expr(:block), block
	end
	# We escape all the arguments in the bindings
	for i in eachindex(bindings.args)
		bindings.args[i] = esc(bindings.args[i])
	end		
	vec = Expr(:vect)
	for arg in block.args
		arg isa LineNumberNode && continue
		Meta.isexpr(arg, :(=)) || error("Only entries of the type `description = bond` are supported as arguments to the input block of `@BondsList`")
		desc, bond = arg.args
		push!(vec.args, esc(:($(BondWithDescription)($desc, $bond))))
	end
	out = quote
		vec = $vec
		$BondsList($(esc(description)), vec)
	end
	Expr(:let, bindings, out)
end

# ╔═╡ 719a79f9-c8bd-4c57-b404-290f27562ac0
# ╠═╡ skip_as_script = true
#=╠═╡
@BondsList "GESU" begin
	"DIO" = @bind sldakjf Slider(1:10)
	"GESU" = @bind iosdfsi Slider(1:10)
end
  ╠═╡ =#

# ╔═╡ edead187-0175-4cb7-9144-a9c919bf41da
#=╠═╡
sldakjf
  ╠═╡ =#

# ╔═╡ 1234fcbf-1f66-4150-9899-9454a0488ee5
# ╠═╡ skip_as_script = true
#=╠═╡
blist = BondsList("DIORE",[
	BondWithDescription("ASD1", @bind lskdjfaslkfjd Slider(1:10)),
	BondWithDescription("ASD2", @bind sldfjksldkf Slider(1:10)),
])
  ╠═╡ =#

# ╔═╡ c2c9f39f-0f35-4920-b132-8ff4a8f59daa
#=╠═╡
Popout(blist)
  ╠═╡ =#

# ╔═╡ 8235e54b-9899-4e25-bbee-36680b66ea12
#=╠═╡
popoutwrap(blist)
  ╠═╡ =#

# ╔═╡ d527a400-7e66-4cc4-9f9d-cfaf8c947a4a
md"""
# BondTable
"""

# ╔═╡ dcff7076-afaa-46b7-ae3d-5ebae0b041c4
begin
"""
	BondTable(bondarray; description)
Take as input an array of bonds and creates a floating table that show all the bonds in the input array. 

If `description` is not provided, it defaults to the text *BondTable*. Description can be either a string or a HTML output.

See also: [`StructBond`](@ref), [`Popout`](@ref), [`popoutwrap`](@ref), [`@fieldbond`](@ref), [`@fielddescription`](@ref), [`@fieldhtml`](@ref), [`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
Base.@kwdef struct BondTable
	bonds::Array
	description::Any
	secret_key::String
	function BondTable(v::Array; description = NotDefined(), secret_key = String(rand('a':'z', 10)))
		for el in v
			T = typeof(el)
			valid = el isa BondsList || nameof(T) == :Bond && hasfield(T, :element) && hasfield(T, :defines)
			valid || error("All the elements provided as input to a `BondTable` have to be bonds themselves (i.e. created with the `@bind` macro from Pluto)")
		end
		new(v, description, secret_key)
	end
end
end

# ╔═╡ ba3462ab-998c-47f1-99a6-4cee8aefffea
md"""
## Interact
"""

# ╔═╡ ccc7615a-a139-4f61-9893-2b5d36a29863
bondtable_interaction_handler = HTLScriptPart(@htl """
<script>
	// We use the interactjs library to provide drag and resize handling across devices
	const { default: interact } = await import('https://esm.sh/interactjs')

	container.offset = container.offset ?? { x: 0, y: 0}
	const startPosition = {x: 0, y: 0}
	interact(container.querySelector('bondtable-header .description')).draggable({
		listeners: {
			start (event) {
				container.offset.y = startPosition.y = container.offsetTop
				container.offset.x = startPosition.x = container.offsetLeft
			},
			move (event) {
		      container.offset.x += event.dx
		      container.offset.y += event.dy
		
		      container.style.top = `min(95vh, \${container.offset.y}px`
		      container.style.left = `min(95vw, \${container.offset.x}px`
		    },
		}
	}).on('doubletap', function (event) {
		  // Double-tap on header reset the position
		container.style.top = ''
		container.style.left = ''
	})
	interact(container)
	  .resizable({
		ignoreFrom: 'popout-container',
	    edges: { top: true, left: false, bottom: true, right: true },
	    listeners: {
	      move: function (event) {		
	        Object.assign(event.target.style, {
	          width: `\${event.rect.width}px`,
	          height: `\${event.rect.height}px`,
			  maxHeight: 'none',
	        })
	      }
	    }
	  }).on('doubletap', function (event) {
		  // Double-tap on resize reset the width
			container.style.width = ''
		  	container.style.height = ''
		  	container.style.maxHeight = ''
	  })
</script>
""");

# ╔═╡ b6e31301-4d4a-4d1e-a68b-bac2a70d60f6
md"""
## Style
"""

# ╔═╡ e9af18f8-801b-48bc-b36c-4fbcd63c5dd3
bondtable_style = @htl """
<style>
	bondtable-container {
		display: flex;
		flex-direction: column;
		position: fixed;
		top: 50px;
		left: 10px;
		background: var(--overlay-button-bg);
    	border: 3px solid #e7e7e7;
    	border-radius: 10px;
    	padding-left: 8px;
    	padding-top: 8px;
		z-index: 600;
		width: 400px;
		max-height: 600px;
		transition: transform 300ms cubic-bezier(0.18, 0.89, 0.45, 1.12);
	}
	bondtable-container:not(.collapsed) > * {
		padding-right: 8px;
	}
	bondtable-contents {
		display: grid;
		grid-template-columns: 1fr minmax(min(50px, 100%), .4fr);
		grid-auto-rows: fit-content(40px);
		justify-items: center;
		padding-bottom: 8px;
		align-items: center;
		row-gap: 5px;
		overflow: auto;
	}
	bondtable-contents togglereactive-container.no-popout,
	bondtable-contents > *, 
	bondtable-contents struct-bond {
		display: contents
	}
	togglereactive-container.no-popout:before {
		content: '';
  		display: block;
		grid-column: 1 / -1;
		justify-self: center;
		border-bottom: 2px solid;
		padding-top: 5px;
		width: 100%;
		align-self: start;
		position: sticky;
		top: 0px;
		background: var(--overlay-button-bg);
		z-index: 20;
	}
	togglereactive-container.no-popout > togglereactive-header {
		align-self: start;
		position: sticky;
		top: 0px;
		background: var(--overlay-button-bg);
		padding-top: 12px;
		margin-top: -12px;
		z-index: 10;
	}
	bondtable-header {
		display: flex;
		justify-items: stretch;
	}
	bondtable-header > .description {
		flex-grow: 1;
		text-align: center;
		font-size: 20px;
		font-weight: 800;
		touch-action: none;
		user-select: none;
	}
	bondtable-header > .icon {
		filter: var(--image-filters);
		cursor: pointer;
	}
	bondtable-header .table-collapse {
		--size: 23px;
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/arrow-back.svg");
	}
	bondtable-container.collapsed .table-collapse {
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/options-outline.svg");
		margin-right: 0px;
	}
	bondtable-container.collapsed .table-collapse:hover {
		background-image: url("https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/arrow-forward.svg");
	}
	bondtable-container.collapsed {
		transform: translateX(calc(-100% + 35px));
		height: auto !important;
		left: 0px !important;
		overflow: hidden;
		padding: 5px;
	}
	bondtable-container.collapsed bondtable-contents,
	bondtable-container.collapsed separator {
		display: none;
	}
	@media (prefers-color-scheme: dark) {
		bondtable-container {
			border-color: #7d7d7d;
		}
	}
</style>
""";

# ╔═╡ 7ba0e7e5-d273-45aa-8dc2-5f95c0ea4838
md"""
## Show
"""

# ╔═╡ c5140f99-9c40-4dd5-b7ec-18d4a85ba35c
function show_bondtable(b::BondTable; description = b.description)
	desc = description isa NotDefined ? "BondTable" : description
	@htl("""
	<bondtable-container key='$(b.secret_key)'>
		<bondtable-header>
			<span class='table-help icon'></span>
			<span class='description'>$desc</span>
			<span class='table-collapse icon'></span>
		</bondtable-header>
		<bondtable-contents>
			$(b.bonds)
		</bondtable-contents>
	</bondtable-container>
	<script id='$(b.secret_key)'>
		const container = currentScript.previousElementSibling
		const header = container.firstElementChild
		const contents = container.lastElementChild

		const cell = container.closest('pluto-cell')

		
		const help_btn = header.firstElementChild
		const collapse_btn = header.lastElementChild

		container.collapse = (force) => {
			container.classList.toggle('collapsed', force)
		}
		collapse_btn.onclick = e => container.collapse()

		// Load the interact script
		$bondtable_interaction_handler

		// Now we assign a specific class to all toggle-container that are direct children
		for (const tr of contents.querySelectorAll('togglereactive-container')) {
			tr.closest('popout-container') ?? tr.classList.toggle('no-popout', true)
		}
		// We also flag the first togglereactive-container in the table
		contents.firstElementChild.querySelector('togglereactive-container.no-popout')?.classList.toggle('first',true)

		// Click to go to definition
		container.jumpToCell = () => {
			cell.scrollIntoView()
		}
		help_btn.onclick = container.jumpToCell
	</script>
	$bondtable_style
	""")
end

# ╔═╡ 4dae020e-5fbc-4798-9874-98c0ba3409f0
Base.show(io::IO, mime::MIME"text/html", b::BondTable) = show(io, mime, show_bondtable(b))

# ╔═╡ 7040e11d-5e53-48a7-91b9-9799fa3626a2
md"""
# Macros
"""

# ╔═╡ 9ea60044-789d-4954-befb-414c723cb593
# Generic function for the convenience macros to add methods for the field functions
function _add_generic_field(s, block, fnames)
	if !Meta.isexpr(block, [:block, :let])
		error("The second argument to the `@addfieldbonds` macro has to be a begin or let block")
	end
	Mod = @__MODULE__
	# We create the output block
	out = Expr(:block)
	for ex in block.args
		ex isa Expr || continue # We skip linenumbernodes
		Meta.isexpr(ex, :(=)) || error("Only expression of the type `fieldname = value` are allowed in the second argument block") 
		symbol, value = ex.args
		symbol isa Symbol || error("The fieldname has to be provided as a symbol ($symbol was given instead)")
		symbol = Meta.quot(symbol)
		# Push the check  of field name expression
		push!(out.args, esc(:(hasfield($s, $symbol) || error("The provided symbol name $($symbol) does not exist in the structure $($s)"))))
		# If the value is not already a tuple or vect or expressions, we wrap it in a tuple
		values = Meta.isexpr(value, [:vect, :tuple]) ? value.args : (value,)
		for (fname,val) in zip(reverse(fnames), reverse(values))
			# Push the expression to overload the method
			push!(out.args, esc(:($Mod.$fname(::Type{$s}, ::Val{$symbol}) = $val)))
		end
	end
	out
end

# ╔═╡ f2489fa4-ccc9-48ea-ac59-552ec1960b9d
"""
	@NTBond description block
Convenience macro to create a [`StructBond`](@ref) wrapping a NamedTuple with field names provided in the second argument `block`.

Useful when one wants a quick way of generating a bond that creates a NamedTuple. An example usage is given in the code below:
```
@bind nt @NTBond "My Fancy NTuple" begin
	a = ("Description", Slider(1:10))
	b = (md"*Bold* field", Slider(1:10))
	c = Slider(1:10) # No description, defaults to the name of the field
end
```
which will create a `NamedTuple{(:a, :b, :c)}` and assign it to variable `nt`.

See also: [`BondTable`](@ref), [`@NTBond`](@ref), [`@BondsList`](@ref), [`Popout`](@ref), [`popoutwrap`](@ref), [`@fielddata`](@ref), [`@fieldhtml`](@ref), [`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
macro NTBond(desc, block)
	Meta.isexpr(block, [:let, :block]) || error("You can only give `let` or `begin` blocks to the `@NTBond` macro")
	# We will return a let block at the end anyhow to avoid method redefinitino errors in Pluto. We already create the two blocks composing the let
	bindings, block = if block.head == :let
		block.args
	else
		# This is a normal begin-end so we create an empty bindings block
		Expr(:block), block
	end
	# We escape all the arguments in the bindings
	for i in eachindex(bindings.args)
		bindings.args[i] = esc(bindings.args[i])
	end		
	fields = Symbol[gensym()] # This will make this unique even when defining multiple times with the same set of parameters
	# now we just and find all the symbols defined in the block
	for arg in block.args
		arg isa LineNumberNode && continue
		Meta.isexpr(arg, :(=)) || error("Only expression of type `fieldname = fieldbond` or `fieldname = (fielddescription, fieldbond)` can be provided inside the block fed to @NTBond")
		push!(fields, arg.args[1])
	end
	Mod = @__MODULE__
	T = NamedTuple{Tuple(fields)}
	out = _add_generic_field(T, block, [:fielddescription, :fieldbond])
	# We add the generation of the StructBond
	push!(out.args, :($(StructBond)($T;description = $desc)))
	Expr(:let, bindings, out)
end

# ╔═╡ 9f86bc62-c06c-45f2-b28e-1b34ec9dfa7f
@only_in_nb test = @NTBond "GESU" let
	a = ("Descrizione Magica", Slider(1:10))
	b = Slider(1:10)
end

# ╔═╡ ae3de6c7-015a-4853-9fff-53703c3e1ef6
@only_in_nb test2 = @NTBond "Madre" begin
	c = Editable(15)
	d = popoutwrap(test)
end;

# ╔═╡ e16a19db-8d99-41f2-bf56-7dfd6c61e90e
# ╠═╡ skip_as_script = true
#=╠═╡
@bind madonnare test2
  ╠═╡ =#

# ╔═╡ c1c7241f-d912-42ef-8672-d728b834309c
#=╠═╡
madonnare
  ╠═╡ =#

# ╔═╡ 900157a7-5892-462a-abb3-0d4eb79a571c
# Generic function for the convenience macros to add methods for the type functions
function _add_generic_type(block, fname)
	if !Meta.isexpr(block, [:block, :let])
		error("The second argument to the `@addfieldbonds` macro has to be a begin or let block")
	end
	Mod = @__MODULE__
	# We create the output block
	out = Expr(:block)
	for ex in block.args
		ex isa Expr || continue # We skip linenumbernodes
		Meta.isexpr(ex, :(=)) || error("Only expression of the type `Type = value` are allowed in the argument block") 
		
		typename, value = ex.args
		typename isa Symbol || error("The typename has to be provided as a symbol ($typename was given instead)")
		# Push the expression to overload the method
		push!(out.args, esc(:($Mod.$fname(::Type{$typename}) = $value)))
	end
	out
end

# ╔═╡ 71cc4f9a-a9ee-472b-ab43-27a6b5876bca
md"""
## add fields bond
"""

# ╔═╡ 35a20c0f-f3cf-4387-9804-019f76e1ead8
"""
	@fieldbond typename block
Convenience macro to define custom widgets for each field of `typename`. This is mostly inteded to be used in combintation with [`StructBond`](@ref).

Given for example the following structure
```
Base.@kwdef struct ASD
	a::Int 
	b::Int
	c::String
end
```
one can create a nice widget to create instances of type `ASD` wih the following code:
```
@fieldbond ASD begin
	a = Slider(1:10)
	b = Scrubbable(1:10)
	c = TextField()
end
@fielddescription ASD begin
	a = md"Magical field with markdown description"
	b = @htl "<span>Field with HTML description</span>"
	c = "Normal String Description"
end
@bind asd StructBond(ASD)
```
where `asd` will be an instance of type `ASD` with each field interactively controllable by the specified widgets and showing the field description next to each widget.

See also: [`BondTable`](@ref), [`StructBond`](@ref), [`Popout`](@ref), [`popoutwrap`](@ref), [`@fielddescription`](@ref), [`@fieldhtml`](@ref), [`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
macro fieldbond(s, block)
	_add_generic_field(s, block, [:fieldbond])
end

# ╔═╡ 2657b4a2-4d45-4b2e-924a-b939477b08c2
md"""
## add fields description
"""

# ╔═╡ 52c41cf4-6b2b-4544-9f41-05503c80eadd
"""
	@fielddescription typename block
Convenience macro to define custom descriptions for the widgets of each field of `typename`. This is mostly inteded to be used in combintation with [`StructBond`](@ref).

Given for example the following structure
```
Base.@kwdef struct ASD
	a::Int 
	b::Int
	c::String
end
```
one can create a nice widget to create instances of type `ASD` wih the following code:
```
@fieldbond ASD begin
	a = Slider(1:10)
	b = Scrubbable(1:10)
	c = TextField()
end
@fielddescription ASD begin
	a = md"Magical field with markdown description"
	b = @htl "<span>Field with HTML description</span>"
	c = "Normal String Description"
end
@bind asd StructBond(ASD)
```
where `asd` will be an instance of type `ASD` with each field interactively controllable by the specified widgets and showing the field description next to each widget.

See also: [`BondTable`](@ref), [`StructBond`](@ref), [`Popout`](@ref), [`popoutwrap`](@ref), [`@fieldbond`](@ref), [`@fieldhtml`](@ref), [`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
macro fielddescription(s, block)
	_add_generic_field(s, block, [:fielddescription])
end

# ╔═╡ a316127a-f814-4eca-aa45-c87b6ca1f73a
md"""
## add fields HTML
"""

# ╔═╡ 0098a7fb-fd2f-4bd3-857f-67a2b5d3037d
macro fieldhtml(s, block)
	_add_generic_field(s, block, [:fieldhtml])
end

# ╔═╡ 68a4b777-d214-405a-84b9-072febef3ee5
md"""
## add type as field
"""

# ╔═╡ c78acfce-07a3-411b-b4a7-ae1a3723a476
macro typeasfield(block)
	if Meta.isexpr(block, :(=))
		block = Expr(:block, block)
	end
	_add_generic_type(block, :typeasfield)
end

# ╔═╡ 2833a3c3-3741-442e-a329-516c2c73d1d0
macro popoutasfield(args...)
	block = Expr(:block)
	for arg in args
		arg isa Symbol || error("The types to show as popups have to be given as symbols")
		push!(block.args, :($arg = $(popoutwrap)($arg)))
	end
	_add_generic_type(block, :typeasfield)
end

# ╔═╡ 9c4f2e93-0712-4824-af4e-0735352bb772
md"""
## add field data
"""

# ╔═╡ e69b85b2-c667-468e-8acf-d2427c017b72
"""
	@fielddata typename block
Convenience macro to define custom widgets for each field of `typename`. This is mostly inteded to be used in combintation with [`StructBond`](@ref).

Given for example the following structure `ASD`, one can create a nice widget to create instances of type `ASD` wih the following code:
```
begin
Base.@kwdef struct ASD
	a::Int 
	b::Int
	c::String
	d::String
end
@fielddata ASD begin
	a = (md"Magical field with markdown description", Slider(1:10))
	b = (@htl("<span>Field with HTML description</span>"), Scrubbable(1:10))
	c = ("Normal String Description", TextField())
	d = TextField()
end
@bind asd StructBond(ASD)
end
```
where `asd` will be an instance of type `ASD` with each field interactively controllable by the specified widgets and showing the field description next to each widget.
The rightside argument of each `:(=)` in the `block` can either be a single element or a tuple of 2 elements. In case a single elemnent is provided, the provided value is interpreted as the `fieldbond`, so the bond/widget to show for that field. 
If two elements are given, the first is assigned to the description and the second as the bond to show

See also: [`BondTable`](@ref), [`StructBond`](@ref), [`@NTBond`](@ref), [`Popout`](@ref), [`popoutwrap`](@ref), [`@fieldbond`](@ref), [`@fielddescription`](@ref), [`@fieldhtml`](@ref), [`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
macro fielddata(s, block)
	_add_generic_field(s, block, [:fielddescription, :fieldbond])
end

# ╔═╡ 08ad83e1-20a1-4501-be9b-c249a8333017
export BondTable, StructBond, @NTBond, @BondsList, Popout, @popoutasfield, @typeasfield, popoutwrap, @fieldbond, @fielddescription, @fielddata

# ╔═╡ 2c7f286b-29c5-4a61-805e-0273dd411f46
@macroexpand @fielddata ASD begin
	a = Slider(1:10)
end

# ╔═╡ f64169a0-43b6-4789-b59d-1f9cef967902
md"""
# Tests
"""

# ╔═╡ 3f425bd4-ddec-479b-8f89-ba7c2ce14e8f
@only_in_nb Base.@kwdef struct LONG
	a
	b
	c
	d
	e
	f
	g
	h
	i
	l
	m
	n
	o
	p
	q
end

# ╔═╡ 46a0f39f-ee8a-42ed-a757-8a5b1b86cab9
@only_in_nb @fieldbond LONG begin
	a = Slider(1:10)
	b = Slider(1:10)
	c = Slider(1:10)
	d = Slider(1:10)
	e = Slider(1:10)
	f = Slider(1:10)
	g = Slider(1:10)
	h = Slider(1:10)
	i = Slider(1:10)
	l = Slider(1:10)
	m = Slider(1:10)
	n = Slider(1:10)
	o = Slider(1:10)
	p = Slider(1:10)
	q = Slider(1:10)
end

# ╔═╡ e18e9140-7345-4d5e-9bfd-8912a1409ccf
@only_in_nb begin
	"""
Magical Structure
"""
Base.@kwdef struct ASD
	"magical *field* ``\\alpha``"
	α::Int
	"Normal field `b`"
	b::Int
end
@addmethod fieldbond(::Type{ASD}, ::Val{:α}) = Scrubbable(1:10)
@addmethod fieldbond(::Type{ASD}, ::Val{:b}) = Slider(1:10)
@addmethod fielddescription(::Type{ASD}, ::Val{:b}) = md"``\alpha``"
end

# ╔═╡ 1a73d400-737a-420c-8bb2-9ef0598be648
# ╠═╡ skip_as_script = true
#=╠═╡
@bind pp Popout(StructBond(ASD))
  ╠═╡ =#

# ╔═╡ 1d1d7911-ddb9-4f16-8ef7-63a414f87018
#=╠═╡
pp
  ╠═╡ =#

# ╔═╡ 6f9a7506-ab5f-425d-9068-89db9187b276
# ╠═╡ skip_as_script = true
#=╠═╡
a = @bind diosanto StructBond(ASD)
  ╠═╡ =#

# ╔═╡ 8e23f3ed-f144-49b8-9e1c-8ad03e630cc4
#=╠═╡
a
  ╠═╡ =#

# ╔═╡ 230c72d9-fa26-4b76-a012-999b03fe9e14
#=╠═╡
diosanto
  ╠═╡ =#

# ╔═╡ 970dc73e-fd93-4a13-bd45-84708e67ea94
@only_in_nb @popoutasfield ASD

# ╔═╡ 78170a85-904c-40f5-97db-60fbe5c3881b
@only_in_nb Base.@kwdef struct LOL
	a::ASD
	b::Int
end

# ╔═╡ 99de3a1a-7139-4a1c-a40a-e1fcca45adca
@only_in_nb @fieldbond LOL begin
	b = Slider(1:10)
end

# ╔═╡ 3af19c77-3c8f-4794-affc-8c34d0217c60
# ╠═╡ skip_as_script = true
#=╠═╡
b = @bind diosantore StructBond(LOL)
  ╠═╡ =#

# ╔═╡ 11821dc7-6f51-46bb-8ec9-4d2a0acffde1
#=╠═╡
diosantore
  ╠═╡ =#

# ╔═╡ 983409c0-d7ba-4282-8f8f-b7541f971284
# ╠═╡ skip_as_script = true
#=╠═╡
c = @bind lolol StructBond(LONG)
  ╠═╡ =#

# ╔═╡ 8c88240f-182f-4302-8017-74bec846795f
#=╠═╡
show_bondtable(BondTable([a, blist ,a,b, c]))
  ╠═╡ =#

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
PlutoDevMacros = "a0499f29-c39b-4c5c-807c-88074221b949"

[compat]
PlutoDevMacros = "~0.5.5"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.9.2"
manifest_format = "2.0"
project_hash = "826daeda7b954256c3315394d715e1379bcb080a"

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
version = "0.6.3"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"
version = "7.84.0+0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"
version = "1.10.2+0"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "42324d08725e200c23d4dfb549e0d5d89dede2d2"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.10"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"
version = "2.28.2+0"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"
version = "2022.10.11"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"
version = "1.2.0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "FileWatching", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"
version = "1.9.2"

[[deps.PlutoDevMacros]]
deps = ["HypertextLiteral", "InteractiveUtils", "MacroTools", "Markdown", "Pkg", "Random", "TOML"]
git-tree-sha1 = "44b59480bdd690eb31b32f4ba3418e0731145cea"
uuid = "a0499f29-c39b-4c5c-807c-88074221b949"
version = "0.5.5"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
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
version = "1.2.13+0"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"
version = "1.48.0+0"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"
version = "17.4.0+0"
"""

# ╔═╡ Cell order:
# ╟─d933d50a-9649-4acc-81f7-e3eac26a6ae5
# ╠═c132e4b8-eaec-435f-95ea-4c96ca8e3118
# ╠═e44cac24-ee90-43b6-8c45-8a3afd61918d
# ╠═57ac01d8-a284-4388-8670-184ffd25b17f
# ╠═e18e9140-7345-4d5e-9bfd-8912a1409ccf
# ╠═9f86bc62-c06c-45f2-b28e-1b34ec9dfa7f
# ╠═ae3de6c7-015a-4853-9fff-53703c3e1ef6
# ╠═08ad83e1-20a1-4501-be9b-c249a8333017
# ╟─0bab1bff-138d-4db3-b092-052ff3205f16
# ╠═478090cb-6d31-43c5-b5d4-c3e059bfff5e
# ╟─1d38cc1a-6e05-4fd2-8cb1-86cad5ee5151
# ╠═f2489fa4-ccc9-48ea-ac59-552ec1960b9d
# ╠═e16a19db-8d99-41f2-bf56-7dfd6c61e90e
# ╠═c1c7241f-d912-42ef-8672-d728b834309c
# ╠═55b394f2-ebfa-4d98-84f2-ee94d81f41c7
# ╠═6a1db028-e0a9-4de9-8fb6-991993aba41e
# ╠═722ff625-e232-47ca-9c2a-6c5c2ec2a6cc
# ╟─eb139a5e-1d4c-4c2f-9f0c-4e305fc0fc7c
# ╠═3ea95602-765e-4ec6-87e3-b49404673e1e
# ╠═8b802a62-eb1e-47f7-bb04-1566fe9c4fe3
# ╟─d8340d9b-cd1c-4aae-9aaf-de6819fb10b6
# ╠═898c1182-e115-4548-93ba-ac95ec5fe6c9
# ╟─ed2bb10a-0bb6-4c34-bd19-daba2be037d2
# ╠═01e6edd9-d3ed-464f-9267-bf8f3ed24b21
# ╠═728831d6-4222-4ea2-9ac4-35e1b9434d0e
# ╠═1a73d400-737a-420c-8bb2-9ef0598be648
# ╠═1d1d7911-ddb9-4f16-8ef7-63a414f87018
# ╟─7f644704-ad49-437c-8b18-ad657e4d78e8
# ╠═30aec475-caef-46f5-b8d4-e4ad4febb132
# ╠═9dcb9704-3029-458a-80c4-cb1a0635b78c
# ╠═183af7ed-4825-4c2f-935b-0c222e4a8054
# ╟─4f63b9ae-2ba5-49a7-928b-18b5f5e200b3
# ╠═5efe7901-2f11-42c1-b59d-17074e3899fe
# ╠═145a1b46-16b5-497c-a949-6f61507190b8
# ╟─94a04779-0a3f-4e40-8c0e-c9cb1db08dd7
# ╠═d04b6c4c-aa81-4442-a992-e70351128433
# ╟─c8a3ab1c-91dc-4955-97e0-1d45477b4e05
# ╠═c1ab1625-dd01-4a51-bd8b-6b9d32104a0f
# ╟─8712d1bf-1a00-4553-8794-0ae411be7e00
# ╠═04739111-2441-4274-860f-b571cdcb1156
# ╠═719a79f9-c8bd-4c57-b404-290f27562ac0
# ╠═edead187-0175-4cb7-9144-a9c919bf41da
# ╠═1234fcbf-1f66-4150-9899-9454a0488ee5
# ╠═c2c9f39f-0f35-4920-b132-8ff4a8f59daa
# ╠═8235e54b-9899-4e25-bbee-36680b66ea12
# ╟─d527a400-7e66-4cc4-9f9d-cfaf8c947a4a
# ╠═dcff7076-afaa-46b7-ae3d-5ebae0b041c4
# ╟─ba3462ab-998c-47f1-99a6-4cee8aefffea
# ╠═ccc7615a-a139-4f61-9893-2b5d36a29863
# ╟─b6e31301-4d4a-4d1e-a68b-bac2a70d60f6
# ╠═e9af18f8-801b-48bc-b36c-4fbcd63c5dd3
# ╟─7ba0e7e5-d273-45aa-8dc2-5f95c0ea4838
# ╠═c5140f99-9c40-4dd5-b7ec-18d4a85ba35c
# ╠═4dae020e-5fbc-4798-9874-98c0ba3409f0
# ╠═8c88240f-182f-4302-8017-74bec846795f
# ╟─7040e11d-5e53-48a7-91b9-9799fa3626a2
# ╠═9ea60044-789d-4954-befb-414c723cb593
# ╠═900157a7-5892-462a-abb3-0d4eb79a571c
# ╟─71cc4f9a-a9ee-472b-ab43-27a6b5876bca
# ╠═35a20c0f-f3cf-4387-9804-019f76e1ead8
# ╟─2657b4a2-4d45-4b2e-924a-b939477b08c2
# ╠═52c41cf4-6b2b-4544-9f41-05503c80eadd
# ╟─a316127a-f814-4eca-aa45-c87b6ca1f73a
# ╠═0098a7fb-fd2f-4bd3-857f-67a2b5d3037d
# ╟─68a4b777-d214-405a-84b9-072febef3ee5
# ╠═c78acfce-07a3-411b-b4a7-ae1a3723a476
# ╠═2833a3c3-3741-442e-a329-516c2c73d1d0
# ╟─9c4f2e93-0712-4824-af4e-0735352bb772
# ╠═e69b85b2-c667-468e-8acf-d2427c017b72
# ╠═2c7f286b-29c5-4a61-805e-0273dd411f46
# ╟─f64169a0-43b6-4789-b59d-1f9cef967902
# ╠═6f9a7506-ab5f-425d-9068-89db9187b276
# ╠═8e23f3ed-f144-49b8-9e1c-8ad03e630cc4
# ╠═230c72d9-fa26-4b76-a012-999b03fe9e14
# ╠═970dc73e-fd93-4a13-bd45-84708e67ea94
# ╠═78170a85-904c-40f5-97db-60fbe5c3881b
# ╠═99de3a1a-7139-4a1c-a40a-e1fcca45adca
# ╠═3af19c77-3c8f-4794-affc-8c34d0217c60
# ╠═11821dc7-6f51-46bb-8ec9-4d2a0acffde1
# ╠═3f425bd4-ddec-479b-8f89-ba7c2ce14e8f
# ╠═46a0f39f-ee8a-42ed-a757-8a5b1b86cab9
# ╠═983409c0-d7ba-4282-8f8f-b7541f971284
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
