using TestItemRunner

@testitem "Aqua" begin
    using Aqua
    using PlutoExtras
    Aqua.test_all(PlutoExtras)
end

@run_package_tests filter = ti -> :before ∈ ti.tags verbose=true
@run_package_tests filter = ti -> :before ∉ ti.tags verbose=true

 