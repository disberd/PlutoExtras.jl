import Pluto: update_save_run!, update_run!, WorkspaceManager, ClientSession,
ServerSession, Notebook, Cell, project_relative_path, SessionActions,
load_notebook, Configuration, set_bond_values_reactive
using PlutoExtras
using Markdown
using PlutoExtras.StructBondModule
using PlutoExtras.StructBondModule: structbondtype, popoutwrap, fieldbond, NotDefined, typeasfield, collect_reinterpret!
import PlutoExtras.AbstractPlutoDingetjes.Bonds
using Test


@testset "APD methods and Coverage" begin
    tr = ToggleReactiveBond(Editable(3))
    @testset "Toggle Reactive" begin
        @test Bonds.validate_value(tr, 3) === true
        @test Bonds.validate_value(tr, 3im) === false
        @test Bonds.transform_value(tr, 3) === 3
        @test Bonds.possible_values(tr) === Bonds.InfinitePossibilities()
    end
    ntb = @NTBond "My Fancy NTuple" begin
        a = ("Description", Slider(1:10))
        b = (md"**Bold** field", Slider(1:10))
        c = Slider(1:10) # No description, defaults to the name of the field
    end
    nt = (;a=1,b=1,c=1)
    @testset "StructBond" begin
        @test structbondtype(ntb) <: NamedTuple
        @test structbondtype(typeof(ntb)) <: NamedTuple

        @test Bonds.transform_value(ntb, [[[1], [1], [1]]]) === nt
        @test fieldbond(structbondtype(ntb), Val(:a)) isa Slider
        @test fieldbond(structbondtype(ntb), Val(:asd)) isa NotDefined

        # Test custom field bonds
        struct ASD
            a::Int
        end
        # This is needed for local testing to reset the typeasfield to NotDefined
        StructBondModule.typeasfield(::Type{Int}) = NotDefined()
        @test_throws "no custom method" StructBond(ASD)
        @typeasfield Int = Slider(1:10)
        @test StructBond(ASD) isa StructBond
        struct BOH
            asd::ASD
        end
        # This is needed for local testing to reset the typeasfield to NotDefined
        StructBondModule.typeasfield(::Type{ASD}) = NotDefined()
        @test_throws "no custom method" StructBond(BOH)
        @popoutasfield ASD
        @test StructBond(BOH) isa StructBond
        @test typeasfield(ASD) isa Popout
        @test fieldbond(BOH, :asd) isa Popout
    end

    p = popoutwrap(ntb)
    @testset "Popout" begin
       @test Bonds.initial_value(p) === nt
       @test Bonds.transform_value(p, [[[[1], [1], [1]]]]) === nt
    end
end

function noerror(cell; verbose=true)
    if cell.errored && verbose
        @show cell.output.body
    end
    !cell.errored
end

@testset "collect_reinterpret!" begin
    @test collect_reinterpret!(3) === 3   
    re = collect(reinterpret(UInt8, [.5])) |> x -> reinterpret(Float64, x)
    arr = [
        0.2,
        [1.0],
        re,
    ]
    @test collect_reinterpret!(arr) == [
        0.2,
        [1.0],
        [0.5],
    ]
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

@testset "Struct Bond notebook" begin
    ss = ServerSession(; options)
    path = joinpath(srcdir, "structbondmodule.jl")
    nb = SessionActions.open(ss, path; run_async=false)
    sn = (ss, nb)
    set_bond_value = set_bond_value_sn(sn)
    for cell in nb.cells
        @test noerror(cell)
    end

    @test eval_in_nb(sn, :nt) == (;a = 1, b = 1, c = 1)
    @test eval_in_nb(sn, :(asd == ASD(1,6,"","",20)))
    @test eval_in_nb(sn, :(boh == BOH(MAH(1))))

    @test eval_in_nb(sn, :alt) == 150
    @test eval_in_nb(sn, :freq) == 2e10
    SessionActions.shutdown(ss, nb)
end