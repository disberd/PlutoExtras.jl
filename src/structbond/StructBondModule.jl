module StructBondModule 
    import PlutoUI.Experimental: wrapped
    import AbstractPlutoDingetjes.Bonds
    using HypertextLiteral

    export BondTable, StructBond, @NTBond, @BondsList, Popout, @popoutasfield,
    @typeasfield, popoutwrap, @fieldbond, @fielddescription, @fielddata,
    ToggleReactiveBond

    include("toggle_reactive.jl")
    include("basics.jl")
    include("main_definitions.jl")
    include("macro.jl")
end