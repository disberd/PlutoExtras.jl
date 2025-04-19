module StructBondModule 
    import PlutoUI.Experimental: wrapped
    using ..PlutoCombineHTL.WithTypes
    import AbstractPlutoDingetjes.Bonds
    import REPL: fielddoc
    using HypertextLiteral
    using PlutoUI: combine, Select, Experimental.TransformedValueNotebook.TransformedWidget
    using ..PlutoExtras: cell_id_letters

    export BondTable, StructBond, @NTBond, @BondsList, Popout, @popoutasfield,
    @typeasfield, popoutwrap, @fieldbond, @fielddescription, @fielddata
    export StructBondSelect
    export ToggleReactiveBond

    const CSS_Sheets = map(readdir(joinpath(@__DIR__, "css"))) do file
        name = replace(file, r"\.[\w]+$" => "") |> Symbol
        path = joinpath(@__DIR__, "css", file)
        name => read(path, String)
    end |> NamedTuple

    include("toggle_reactive.jl")
    include("basics.jl")
    include("main_definitions.jl")
    include("structbond_select.jl")
    include("macro.jl")
end