@testsnippet setup_basics begin
    using PlutoExtras
    import PlutoExtras.AbstractPlutoDingetjes.Bonds
    using Test

    include(joinpath(@__DIR__, "setup_helper.jl"))
end


@testitem "APD methods" setup=[setup_basics] begin
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



@testitem "Basic Widgets notebook" setup=[setup_basics] begin
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