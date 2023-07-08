module StructBondModule 
    import PlutoUI.Experimental: wrapped

    export BondTable, StructBond, @NTBond, @BondsList, Popout, @popoutasfield,
    @typeasfield, popoutwrap, @fieldbond, @fielddescription, @fielddata

    include("basics.jl")
    include("main_definitions.jl")
    include("macro.jl")
end