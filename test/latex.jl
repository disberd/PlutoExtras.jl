@testsnippet setup_latex begin
    using PlutoExtras
    include(joinpath(@__DIR__, "setup_helper.jl"))
end

@testitem "Latex Equations notebook" setup=[setup_latex] begin
    ss = ServerSession(; options)
    path = joinpath(srcdir, "latex_equations.jl")
    nb = SessionActions.open(ss, path; run_async=false)
    sn = (ss, nb)
    set_bond_value = set_bond_value_sn(sn)
    for cell in nb.cells
        @test noerror(cell)
    end
    SessionActions.shutdown(ss, nb)
end