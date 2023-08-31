using SafeTestsets

@safetestset "Basic Widgets" begin include("basics.jl") end
@safetestset "Extended Toc" begin include("toc.jl") end