# Helper Functions #
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

# @fieldbond #
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

# @fielddescription #
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

# @fieldhtml #
macro fieldhtml(s, block)
	_add_generic_field(s, block, [:fieldhtml])
end

# @typeasfield #
macro typeasfield(block)
	if Meta.isexpr(block, :(=))
		block = Expr(:block, block)
	end
	_add_generic_type(block, :typeasfield)
end

# @popoutasfield #
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

