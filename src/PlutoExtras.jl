module PlutoExtras
using HypertextLiteral
using PlutoDevMacros

include("editable.jl") # exports: Editable 
include("latex_equations.jl") # exports the following: texeq, eqref, initialize_eqref, @texeq_str
module ExtendedToc include("extended_toc.jl") end
import .ExtendedToc: ExtendedTableOfContents
export ExtendedTableOfContents

include("toggle_reactive_bond.jl") # exports: ToggleReactiveBond

include("structbond/StructBondModule.jl")


end # module
