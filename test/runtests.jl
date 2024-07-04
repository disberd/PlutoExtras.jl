using SafeTestsets
using Aqua
using PlutoExtras

Aqua.test_all(PlutoExtras)

@safetestset "PlutoCombineHTL Module" begin include("combinehtl_module.jl") end
@safetestset "Basic Widgets" begin include("basics.jl") end
@safetestset "LaTeX Equations" begin include("latex.jl") end
@safetestset "Extended Toc" begin include("toc.jl") end
@safetestset "StructBond Module" begin include("structbond.jl") end