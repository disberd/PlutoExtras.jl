module PlutoExtras
using HypertextLiteral
using PlutoDevMacros
using PlutoDevMacros.PlutoCombineHTL.WithTypes
using AbstractPlutoDingetjes.Bonds
using AbstractPlutoDingetjes
using Reexport
@reexport using PlutoUI

# This is similar to `@reexport` but does not export the module name
function re_export_without_modname(m::Module)
    mod_name = nameof(m)
    exprts = setdiff(names(m), (nameof(m),))
    eval(:(using .$mod_name))
    eval(:(export $(exprts...)))
end

export Editable, StringOnEnter # from basic_widgets.jl
export ToggleReactiveBond # From within StructBondModule

include("basic_widgets.jl")
include("latex_equations.jl") 
module ExtendedToc include("extended_toc.jl") end

include("structbond/StructBondModule.jl")
using .StructBondModule

## ReExports ##
re_export_without_modname.((ExtendedToc, LaTeXEqModule))

end # module
