# StructBond Definition #

"""
	StructBond(T;description = typedescription(T))
Create an HTML widget to be used with `@bind` from Pluto that allows to define
the custom type `T` by assigning a widget to each of its fields. 
The widget will automatically use the docstring of each field as its description
if present, or the fieldname otherwise.

When used with `@bind`, it automatically generates a instance of `T` by using
the various fields as keyword arguments. *This means that the the structure `T`
has to support a keyword-only contruction, such as those generated with
`Base.@kwdef` or `Parameters.@with_kw`.

In order to work, the widget (and optionally the description) to associate to
eachfield of type `T` has to be provided using the convenience macro
`@fielddata`. 

The optional `description` kwarg default to the Type name but can be overridden
with anything showable as `MIME"text/html"` 

See also: [`BondTable`](@ref), [`@NTBond`](@ref), [`@BondsList`](@ref),
[`Popout`](@ref), [`popoutwrap`](@ref), [`@fielddata`](@ref),
[`@fieldhtml`](@ref), [`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
Base.@kwdef struct StructBond{T}
	widget::Any
	description::String
	secret_key::String=String(rand('a':'z', 10))
end
StructBond(::Type{T}; description = string(nameof(T))) where T = StructBond{T}(;widget = typehtml(T), description)

## structbondtype ##
structbondtype(::StructBond{T}) where T = T
structbondtype(::Type{StructBond{T}}) where T = T

## Show - StructBond ##

# Basic script part used for the show method
_show(t::StructBond{T}) where T = @htl("""
<struct-bond class='$T'>
	$(t.widget)
	<script id = $(t.secret_key)>
		
		const parent = currentScript.parentElement
		const widget = currentScript.previousElementSibling
	
		// Overwrite the description
		const desc = widget.querySelector('.description')
	
		// Set-Get bond
	
		const set_input_value = setBoundElementValueLikePluto
		const get_input_value = getBoundElementValueLikePluto
	
		Object.defineProperty(parent, 'value', {
			get: () => get_input_value(widget),
			set: (newval) => {
				set_input_value(widget, newval)
			},
			configurable: true,
		});
	
		const old_oninput = widget.oninput ?? function(e) {}
		widget.oninput = (e) => {
			old_oninput(e)
			e.stopPropagation()
			parent.dispatchEvent(new CustomEvent('input'))
		}
	</script>
	<style>
		/* The flex below is needed in some weird cases where the bond is display flex and the child becomes small. */
		struct-bond {
  			flex: 1;
		}
	</style>
	</struct-bond>
""")

Base.show(io::IO, mime::MIME"text/html", t::StructBond) = show(io, mime, _show(t))

# Create methods for AbstractPlutoDingetjes.Bonds
function Bonds.initial_value(t::StructBond{T}) where T
	transformed = Bonds.initial_value(t.widget)
	typeconstructor(T)(transformed)
end

# We have to parse the received array and collect reinterpretarrays as they are
# likely the cause of the weird error in Issue #31
collect_reinterpret!(@nospecialize(x)) = x
function collect_reinterpret!(x::AbstractArray)
	for i in eachindex(x)
		el = x[i]
		if el isa Base.ReinterpretArray
			x[i] = collect(el)
		elseif el isa AbstractArray
			# We do recursive processing
			collect_reinterpret!(el)
		end
	end
	return x
end

function Bonds.transform_value(t::StructBond{T}, from_js) where T
	# We remove reinterpreted_arrays (See Issue #31)
	transformed = Bonds.transform_value(t.widget, collect_reinterpret!(from_js))
	typeconstructor(T)(transformed)
end
Bonds.validate_value(::StructBond, from_js) = true

# BondWithDescription #
struct BondWithDescription
	description
	bond
	function BondWithDescription(description, bond)
		_isvalid(BondWithDescription, bond) || error("It looks like the `bond` provided to `BondWithDescription` is not of the correct type, provide the bond given as output by the `Pluto.@bind` macro")
		new(description, bond)
	end
end

_isvalid(::Type{BondWithDescription}, value::T) where T = nameof(T) == :Bond && fieldnames(T) == (:element, :defines, :unique_id)

_getbond(x::T) where T = let
	if nameof(T) == :Bond && fieldnames(T) == (:element, :defines, :unique_id) 
		return x
	else
		error("The provided input is not a bond or does not seem to wrap a bond")
	end
end

## Show - BondWithDescription ##
Base.show(io::IO, mime::MIME"text/html", bd::BondWithDescription) = show(io, mime, @htl("""
<bond-with-description>
	<bond-description title=$(join(["This bond is assigned to variable `", String(_getbond(bd.bond).defines), "`"]))>
		$(bd.description)
	</bond-description>
	<bond-value>
		$(bd.bond)
	</bond-value>
	<style>
		$(CSS_Sheets.bondwithdescription)
	</style>
</bond-with-description>
"""))

# Bonds List #
Base.@kwdef struct BondsList
	description
	bonds::Vector{BondWithDescription}
	secret_key::String=String(rand('a':'z', 10))
end
BondsList(description, bonds) = BondsList(;description, bonds)

## Show - BondsList ##
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
	$(CSS_Sheets.bondslist)		
	</style>
</bondslist-container>
"""))


# Popout #
"""
	Popout(T)
Create an HTML widget wrapping the widget `T` and showing it either on hover or
upon click.

This is useful to generat widgets to be used with [`StructBond`](@ref) for
custom fields whose types are custom Types.

The convenience function [`popoutwrap`](@ref) can be used to directly create a
`Popup` of a `StructBond{T}` to facilitate nested `StructBond` views.

See also: [`BondTable`](@ref), [`StructBond`](@ref), [`popoutwrap`](@ref),
[`@fieldbond`](@ref), [`@fielddescription`](@ref), [`@fieldhtml`](@ref),
[`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
Base.@kwdef struct Popout{T}
	element::T
	secret_key::String=String(rand('a':'z', 10))
end
Popout(element::T) where T = Popout{T}(;element)

# Create methods for AbstractPlutoDingetjes.Bonds
function Bonds.initial_value(t::Popout{T}) where T
	transformed = Bonds.initial_value(t.element)
end
function Bonds.transform_value(t::Popout{T}, from_js) where T
	transformed = Bonds.transform_value(t.element, from_js |> first)
end

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
popoutwrap(t::Union{StructBond, BondsList}) = Popout(t)

## Interact.js - Popout ##
popup_interaction_handler = ScriptContent("""
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
""")

## Show - Popout ##
_show_popout(p::Popout) = wrapped() do Child
@htl("""
<popout-container key='$(p.secret_key)'>
	<popout-header><span class='popout-icon popout'></span></popout-header>
	<popout-contents>$(Child(p.element))</popout-contents>
</popout-container>
<script id='$(p.secret_key)'>
	// Load the floating-ui and interact libraries
	window.floating_ui = await import('https://esm.sh/@floating-ui/dom@1.7.4')

	const { computePosition, autoPlacement } = floating_ui
	
	const container = currentScript.previousElementSibling
	const header = container.firstElementChild
	const contents = container.lastElementChild

	// Load the interactjs part
	$popup_interaction_handler

	function positionContents() {
        // Deal with scrolling
        const scrollContainer = document.querySelector('main') || document.documentElement
        const scrollTop = scrollContainer.scrollTop || window.pageYOffset

		computePosition(header, contents, {
			strategy: "fixed",
			middleware: [
                autoPlacement(),
            ],
		}).then((pos) => {
			contents.style.left = pos.x + "px"
			contents.style.top = pos.y - scrollTop + "px"
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
	$(CSS_Sheets.popout)
</style>
""")
end
# Base.show method
Base.show(io::IO, mime::MIME"text/html", p::Popout) = show(io, mime, _show_popout(p))

## Methods for other structs
_isvalid(T::Type{BondWithDescription}, p::Popout) = _isvalid(T, p.element)
_getbond(x::Popout) = _getbond(x.element)


# BondTable #
"""
	BondTable(bondarray; description, collapsed)
Take as input an array of bonds and creates a floating table that show all the
bonds in the input array. 

If `description` is not provided, it defaults to the text *BondTable*.
Description can be either a string or a HTML output.

The optional `collapsed` kwarg can be used to specify whether the BondTable
should stay collapsed or not when shown. If not provided, the BondTable will
*not* be collapsed.

The *collapsed* status of the BondTable is persistent across reactive runs of
the cell showing the BondTable.


See also: [`StructBond`](@ref), [`Popout`](@ref), [`popoutwrap`](@ref),
[`@fieldbond`](@ref), [`@fielddescription`](@ref), [`@fieldhtml`](@ref),
[`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
Base.@kwdef struct BondTable
	bonds::Array
	description::Any
	secret_key::String
	collapsed::Union{Bool, Nothing}
	function BondTable(v::Array; description = NotDefined(), secret_key = cell_id_letters(), collapsed = nothing)
		for el in v
			T = typeof(el)
			valid = el isa BondsList || nameof(T) == :Bond && hasfield(T, :element) && hasfield(T, :defines)
			valid || error("All the elements provided as input to a `BondTable` have to be bonds themselves (i.e. created with the `@bind` macro from Pluto)")
		end
		new(v, description, secret_key, collapsed)
	end
end

## Interact.js - BondTable ##
bondtable_interaction_handler = ScriptContent("""
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
""")

## CSS - BondTable ##
bondtable_style = @htl """
<style>
	$(CSS_Sheets.bondtable)
</style>
""";

## Show - BondTable ##
function show_bondtable(b::BondTable; description = b.description, collapsed = b.collapsed)
	desc = description isa NotDefined ? "BondTable" : description
	@htl("""
	<bondtable-container key='$(b.secret_key)' class='collapsed'>
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
		const container = currentScript.parentElement.querySelector('bondtable-container')
		const header = container.firstElementChild
		const contents = container.lastElementChild

		const cell = container.closest('pluto-cell')

        // This is only used to leverage the pluto js functionality for persistency in JS
        const return_element = this ?? html`<span class='script-return'></span>`

        if (return_element.collapsed === undefined) {
            return_element.collapsed = $collapsed ?? false
        }

		const help_btn = header.firstElementChild
		const collapse_btn = header.lastElementChild

		container.collapse = (force) => {
            return_element.collapsed = force ?? !return_element.collapsed
			container.classList.toggle('collapsed', return_element.collapsed)
		}
        // Force the initial status
        container.collapse(return_element.collapsed)

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

        return return_element
	</script>
	$bondtable_style
	""")
end
Base.show(io::IO, mime::MIME"text/html", b::BondTable) = show(io, mime, show_bondtable(b))