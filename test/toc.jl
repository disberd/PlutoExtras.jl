@testsnippet setup_toc begin
    using PlutoExtras
    include(joinpath(@__DIR__, "setup_helper.jl"))
end

@testitem "ToC notebook" setup=[setup_toc] begin
    ss = ServerSession(; options)
    path = joinpath(srcdir, "extended_toc.jl")
    nb = SessionActions.open(ss, path; run_async=false)
    for cell in nb.cells
        @test noerror(cell)
    end
    SessionActions.shutdown(ss, nb)
end