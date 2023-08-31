module PlutoExtras
using HypertextLiteral
using PlutoDevMacros
using PlutoDevMacros.Script
using AbstractPlutoDingetjes.Bonds
using AbstractPlutoDingetjes
using Reexport
@reexport using PlutoUI

export Editable, StringOnEnter # from basic_widgets.jl
export ToggleReactiveBond # From within StructBondModule

include("basic_widgets.jl")
include("latex_equations.jl") # exports the following: texeq, eqref, initialize_eqref, @texeq_str
module ExtendedToc include("extended_toc.jl") end
import .ExtendedToc: ExtendedTableOfContents, show_output_when_hidden
export ExtendedTableOfContents, show_output_when_hidden

include("structbond/StructBondModule.jl")
using .StructBondModule


end # module
