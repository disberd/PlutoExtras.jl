import Pluto: update_save_run!, update_run!, WorkspaceManager, ClientSession,
ServerSession, Notebook, Cell, project_relative_path, SessionActions,
load_notebook, Configuration, set_bond_values_reactive
using PlutoExtras
import PlutoExtras.AbstractPlutoDingetjes.Bonds
using Test

function noerror(cell; verbose=true)
    if cell.errored && verbose
        @show cell.output.body
    end
    !cell.errored
end

@testset "APD methods" begin
    ed = Editable(3)
    @test Base.get(ed) == 3
    @test Bonds.initial_value(ed) == 3
    @test Bonds.possible_values(ed) == Bonds.InfinitePossibilities()
    @test Bonds.possible_values(Editable(true)) == (true, false)
    @test Bonds.validate_value(ed, 5) === true
    @test Bonds.validate_value(ed, 3im) === false

    soe = StringOnEnter("asd")
    @test Base.get(soe) == "asd"
    @test Bonds.initial_value(soe) == "asd"
    @test Bonds.possible_values(soe) == Bonds.InfinitePossibilities()
    @test Bonds.validate_value(soe, 5) === false
    @test Bonds.validate_value(soe, "lol") === true
end


options = Configuration.from_flat_kwargs(; disable_writing_notebook_files=true, workspace_use_distributed_stdlib = true)
srcdir = normpath(@__DIR__, "./notebooks")
eval_in_nb(sn, expr) = WorkspaceManager.eval_fetch_in_workspace(sn, expr)

function set_bond_value_sn(sn)
    (session, notebook) = sn
    function set_bond_value(name, value, is_first_value=false)
        notebook.bonds[name] = Dict("value" => value)
        set_bond_values_reactive(; session, notebook, bound_sym_names=[name],
            is_first_values=[is_first_value],
            run_async=false,
        )
    end
end

@testset "Basic Widgets notebook" begin
    ss = ServerSession(; options)
    path = joinpath(srcdir, "basic_widgets.jl")
    nb = SessionActions.open(ss, path; run_async=false)
    sn = (ss, nb)
    set_bond_value = set_bond_value_sn(sn)
    for cell in nb.cells
        @test noerror(cell)
    end
    set_bond_value(:text, "asdasd")
    @test eval_in_nb(sn, :text) === "asdasd"

    set_bond_value(:num, 15)
    @test eval_in_nb(sn, :num) === 15
    SessionActions.shutdown(ss, nb)
end