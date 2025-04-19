# StructBond Helpers #
## Structs ##
struct NotDefined end

## Field Functions ##

### Description ###
# This is a wrapper to extract eventual documentation strings from struct fields
_fielddoc(s,f) = try
	fielddoc(s,f)
catch
	nothing
end

# Default implementation to be overrided for specific types and fields in order to provide custom descriptions
function fielddescription(::Type, ::Val)
	@nospecialize
	return NotDefined()
end

function fielddescription(s::Type, f::Symbol)
	@nospecialize
	@assert hasfield(s, f) "The structure $s has no field $f"
	# We check if the structure has a specific method for the field
	out = fielddescription(s, Val(f))
	out isa NotDefined || return out
	# Now we try with the docstring of the field
	out = _fielddoc(s, f)
	# When fielddoc doesn't find a specific field docstring (even when called with non-existing fields), it returns a standard markdown that lists the fields of the structure, se we test for a very weird symbol name to check if the returned value is actually coming from a docstring
	out == _fielddoc(s, :__Very_Long_Nonexisting_Field__) || return out
	# Lastly, we just give the name of the field if all else failed
	out = string(f)
end

### Bond ###

# Default implementation to be overrided for specific types and fields in order to provide custom Bond
function fieldbond(::Type, ::Val)
	@nospecialize
	return NotDefined()
end

### HTML ###

# Default implementation to be overrided for specific types and fields in order to provide custom Bond
function fieldhtml(::Type, ::Val)
	@nospecialize
	return NotDefined()
end

## Struct Functions ##

### Description ###

# Override the description of a Type
typedescription(T::Type) = string(Base.nameof(T))

### Bond ###

# This function has to be overwritten if a custom show method for a Type is
# intended when the type is shown as a filed of a BondTable
typeasfield(T::Type) = NotDefined()

# Basic function that is called for extracting the bond for a given field of a struct
function fieldbond(s::Type, f::Symbol)
	@nospecialize
	@assert hasfield(s, f) "The structure $s has no field $f"
	Mod = @__MODULE__
	# We check if the structure has a specific method for the field
	out = fieldbond(s, Val(f))
	out isa NotDefined || return out
	# If we reach this point it means that no custom method was defined for the bond value of this field
	# We try to see if the type has a custom implementation when shown as field
	ft = fieldtype(s,f)
	out = typeasfield(ft)
	out isa NotDefined && error("`$(Mod).fieldbond` has no custom method for field ($f::$ft) of type $s and `$(Mod).typeasfield` has no custom method for type $ft.\n
	Please add one or the other using `@fieldsbond` or `@typeasfield`")
	return out
end

### HTML ###

# This function will be called for extracting the HTML for displaying a given field of a Type inside a BondTable
# It defaults to just creating a description from `fielddescription` and a bond from `fieldbond`
function fieldhtml(s::Type, f::Symbol)
	@nospecialize
	@assert hasfield(s, f) "The structure $s has no field $f"
	# We check if the structure has a specific method for the field
	out = fieldhtml(s, Val(f))
	out isa NotDefined || return out
	# Now we try with the docstring of the field
	out = wrapped() do Child
		@htl("""
		<field-html class='$f'>
			<field-description class='$f' title="This value is associated to field `$f`">$(fielddescription(s, f))</field-description>
			<field-bond class='$f'>$(Child(fieldbond(s, f)))</field-bond>
		</field-html>
		<style>
			field-html {
				display: grid;
				grid-template-columns: 1fr minmax(min(50px, 100%), .4fr);
				grid-auto-rows: fit-content(40px);
				justify-items: center;
				//padding: 2px 5px 10px 0px;
				align-items: center;
				row-gap: 5px;
			}
			field-bond {
				display: flex;
			}
			field-bond input {
				width: 100%;
			}
   			field-description {
				text-align: center;
			}
		</style>
		""")
	end
	return out
end

function typehtml(T::Type)
	inner_bond = combine() do Child
		@htl """
		$([
			Child(string(name), fieldhtml(T, name))
			for name in fieldnames(T) if !Base.isgensym(name)
		])
		"""
	end
    togglereactive_container(inner_bond; description = typedescription(T), title = "This generates a struct of type $(nameof(T))")
end

## ToggleReactiveContainer ##
# This is a helperfunction to create a togglereactive container around a bond with collapsible content
function togglereactive_container(inner_bond; description, title)
	ToggleReactiveBond(wrapped() do Child
		@htl("""
			$(Child(inner_bond))
		
	<script>
		const trc = currentScript.closest('togglereactive-container')
		const header = trc.firstElementChild
		const desc = header.querySelector('.description')
		desc.setAttribute('title', $title)

		// add the collapse button
		const collapse_btn = html`<span class='collapse'>`
		header.insertAdjacentElement('afterbegin', collapse_btn)

		trc.collapse = () => {
  			trc.classList.toggle('collapsed')
		}

		collapse_btn.onclick = (e) => trc.collapse()
		
	</script>
		<style>
			togglereactive-container field-html {
				display: contents;
			}
			togglereactive-container {
				display: grid;
				grid-template-columns: 1fr minmax(min(50px, 100%), .4fr);
				grid-auto-rows: fit-content(40px);
				justify-items: center;
				align-items: center;
				row-gap: 5px;
				/* The flex below is needed in some weird cases where the bond is display flex and the child becomes small. */
				flex: 1;
			}
			togglereactive-header {
				grid-column: 1 / -1;
				display: flex;
			}
			togglereactive-header > .collapse {
				--size: 17px;
			    display: block;
			    align-self: stretch;
			    background-size: var(--size) var(--size);
			    background-repeat: no-repeat;
			    background-position: center;
			    width: var(--size);
			    filter: var(--image-filters);
				background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-down.svg);
				cursor: pointer;
			}
			togglereactive-container.collapsed > togglereactive-header > .collapse {
				background-image: url(https://cdn.jsdelivr.net/gh/ionic-team/ionicons@5.5.1/src/svg/chevron-forward.svg);
			}
			togglereactive-header {
				display: flex;
				align-items: stretch;
				width: 100%;
			}
			togglereactive-header > .description {
				text-align: center;
				flex-grow: 1;
				font-size: 18px;
				font-weight: 600;
			}
			togglereactive-header > .toggle {
				align-self: center
			}
			togglereactive-container.collapsed togglereactive-header + * {
				display: none !important;
			}
		</style>
		""")
	end; description = description)
end

### Constructor ###
typeconstructor(T::Type) = f(args) = T(;args...)
typeconstructor(::Type{<:NamedTuple}) = identity
