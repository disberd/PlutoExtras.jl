module PlutoExtras
using HypertextLiteral
using AbstractPlutoDingetjes.Bonds
using AbstractPlutoDingetjes
import PlutoUI

# This is similar to `@reexport` but does not exports undefined names and can
# also avoid exporting the module name
function re_export(m::Module; modname = false)
    mod_name = nameof(m)
    nms = names(m)
    exprts = filter(nms) do n
        isdefined(m, n) && (!modname || n != mod_name)
    end
    eval(:(using .$mod_name))
    eval(:(export $(exprts...)))
end

export Editable, StringOnEnter # from basic_widgets.jl

include("helpers.jl")

include("combine_htl/PlutoCombineHTL.jl")

include("basic_widgets.jl")
include("latex_equations.jl") 
module ExtendedToc include("extended_toc.jl") end

include("structbond/StructBondModule.jl")
using .StructBondModule

## ReExports ##
re_export(StructBondModule)
re_export.((ExtendedToc, LaTeXEqModule); modname = false)
re_export(PlutoUI)

end # module
