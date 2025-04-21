@testsnippet setup_structbond begin
    using PlutoExtras
    using Markdown
    using PlutoExtras.StructBondModule
    using PlutoExtras.StructBondModule: structbondtype, popoutwrap, fieldbond, NotDefined, typeasfield, collect_reinterpret!
    import PlutoExtras.AbstractPlutoDingetjes.Bonds
    using Test

    include(joinpath(@__DIR__, "setup_helper.jl"))
end


@testitem "APD methods and Coverage" setup=[setup_structbond] begin
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

@testitem "StructBondSelect" setup=[setup_structbond] begin
    els = [
        @NTBond "cos(arg)" begin
            arg = Slider(range(0,1,100))
        end nt -> cos(nt.arg)
        @NTBond "atan(y,x)" begin
            x = Slider(range(0,10; step = 0.1); default = 3, show_value=true)
            y = Slider(range(0, 10; step = 0.1); default = 5, show_value=true)
        end nt -> atan(nt.y, nt.x)
        @NTBond "mah" begin
            a = Slider(1:10)
        end
    ]
sbs = StructBondSelect(els; default_idx = 2, selector_text = "Options:")
@test sbs.selectors == ["cos(arg)", "atan(y,x)", "mah"]

@test Bonds.initial_value(sbs) == Bonds.initial_value(els[2])

sbs = StructBondSelect(els; default_idx = 3, selector_text = "Options:")
@test Bonds.initial_value(sbs) == Bonds.initial_value(els[3])
@test Bonds.validate_value(sbs, [[3, [3]]]) === true
@test Bonds.transform_value(sbs, [[3, [[[3]]]]]) == (;a = 3)

@test_throws "default_idx must be a positive integer" StructBondSelect(els; default_idx = 0, selector_text = "Options:")
@test_throws "default_idx must be a positive integer" StructBondSelect(els; default_idx = 4, selector_text = "Options:")

@test_throws "must be either a StructBond" StructBondSelect([1])

custom_names = ["asd", "qwe", "zxc"]
sbs_custom = StructBondSelect(els, custom_names; default_idx = 2, selector_text = "Options:")
@test sbs_custom.selectors == custom_names

sbs_custom = StructBondSelect([nm => el for (nm, el) in zip(custom_names, els)]; default_idx = 2, selector_text = "Options:")
@test sbs_custom.selectors == custom_names
end

@testitem "collect_reinterpret!" setup=[setup_structbond] begin
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

@testitem "Struct Bond notebook" setup=[setup_structbond] begin
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