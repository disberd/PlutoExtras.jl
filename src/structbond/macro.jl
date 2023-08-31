# Helper Functions #
# Generic function for the convenience macros to add methods for the field functions
function _add_generic_field(s, block, fnames)
	if !Meta.isexpr(block, [:block, :let])
		error("The second argument to the `@fieldbond` macro has to be a begin or let block")
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

# Generic function for the convenience macros to add methods for the type functions
function _add_generic_type(block, fname)
	if !Meta.isexpr(block, [:block, :let])
		error("The second argument to the `@fieldtype` macro has to be a begin or let block")
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

# @fieldbond #
"""
	@fieldbond typename block
Convenience macro to define custom widgets for each field of `typename`. This is
mostly inteded to be used in combintation with [`StructBond`](@ref).

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
where `asd` will be an instance of type `ASD` with each field interactively
controllable by the specified widgets and showing the field description next to
each widget.

See also: [`BondTable`](@ref), [`StructBond`](@ref), [`Popout`](@ref),
[`popoutwrap`](@ref), [`@fielddescription`](@ref), [`@fieldhtml`](@ref),
[`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
macro fieldbond(s, block)
	_add_generic_field(s, block, [:fieldbond])
end

# @fielddescription #
"""
	@fielddescription typename block
Convenience macro to define custom descriptions for the widgets of each field of
`typename`. This is mostly inteded to be used in combintation with
[`StructBond`](@ref).

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
where `asd` will be an instance of type `ASD` with each field interactively
controllable by the specified widgets and showing the field description next to
each widget.

See also: [`BondTable`](@ref), [`StructBond`](@ref), [`Popout`](@ref),
[`popoutwrap`](@ref), [`@fieldbond`](@ref), [`@fieldhtml`](@ref),
[`@typeasfield`](@ref), [`@popoutasfield`](@ref)
"""
macro fielddescription(s, block)
	_add_generic_field(s, block, [:fielddescription])
end

# @fieldhtml #
macro fieldhtml(s, block)
	_add_generic_field(s, block, [:fieldhtml])
end

# @typeasfield #
"""
	@typeasfield T = Widget
	@typeasfield begin
		T1 = Widget1
		T2 = Widget2
		...
	end

Macro to give a default widget for a specific type `T`, `T1`, or `T2`.
This can be over-ridden by specifying a more specific default for a custom type
using [`@fieldbond`](@ref)
When a custom type is wrapped inside a [`StructBond`](@ref) and a custom widget
for one of its field is not defined, the show method will use the one defined by
this macro for the field type.

# Examples
The following julia code will error because a default widget is not defined for field `a`

```
using PlutoExtras.StructBondModule
struct ASD 
	a::Int
end
StructBond(ASD)
```

Apart from defining a specific value for `ASD` with [`@fieldbond`](@ref), one
can also define a default widget for Int with:
```julia
@typeasfield Int = Slider(1:10)
```

Now calling `StructBond(ASD)` will not error and will default to showing a
`Slider(1:10)` as bond for field `a` of `ASD`.
"""
macro typeasfield(block)
	if Meta.isexpr(block, :(=))
		block = Expr(:block, block)
	end
	_add_generic_type(block, :typeasfield)
end

# @popoutasfield #
"""
	@popoutasfield T
	@popoutasfield T1 T2 ...
This macro will make the default widget for fields of type `T` a
[`Popout`](@ref) wrapping a `StructBond{T}` type.
For this to work, the `StructBond{T}` must have a default widget associated to
each of its field, either by using [`@fieldbond`](@ref) or
[`@typeasfield`](@ref)

# Example (in Pluto)
```julia
# ╔═╡ 8db82e94-5c81-4c52-9228-7e22395fb68f
using PlutoExtras.StructBondModule

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
boh === BOH(MAH(1))
```
"""
macro popoutasfield(args...)
	block = Expr(:block)
	for arg in args
		arg isa Symbol || error("The types to show as popups have to be given as symbols")
		push!(block.args, :($arg = $(popoutwrap)($arg)))
	end
	_add_generic_type(block, :typeasfield)
end

# @fielddata #
"""
	@fielddata typename block
Convenience macro to define custom widgets for each field of `typename`. This is
mostly inteded to be used in combintation with [`StructBond`](@ref).

Given for example the following structure `ASD`, one can create a nice widget to
create instances of type `ASD` wih the following code:
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

# @NTBond #

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


# BondsList #
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

