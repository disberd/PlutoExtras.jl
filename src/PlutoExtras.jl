module PlutoExtras
using HypertextLiteral
using PlutoDevMacros

include("editable.jl") # exports: Editable 
include("latex_equations.jl") # exports the following: texeq, eqref, initialize_eqref, @texeq_str
module BondsDict include("bonds_dict.jl") end
module ExtendedToc include("extended_toc.jl") end
import .ExtendedToc: ExtendedTableOfContents
export ExtendedTableOfContents

end # module
