import Pluto: update_save_run!, update_run!, WorkspaceManager, ClientSession,
ServerSession, Notebook, Cell, project_relative_path, SessionActions,
load_notebook, Configuration
using PlutoExtras

function noerror(cell; verbose=true)
    if cell.errored && verbose
        @show cell.output.body
    end
    !cell.errored
end


options = Configuration.from_flat_kwargs(; disable_writing_notebook_files=true, workspace_use_distributed_stdlib = true)
srcdir = normpath(@__DIR__, "./notebooks")
eval_in_nb(sn, expr) = WorkspaceManager.eval_fetch_in_workspace(sn, expr)

@testset "ToC notebook" begin
    ss = ServerSession(; options)
    path = joinpath(srcdir, "extended_toc.jl")
    nb = SessionActions.open(ss, path; run_async=false)
    for cell in nb.cells
        @test noerror(cell)
    end
    SessionActions.shutdown(ss, nb)
end