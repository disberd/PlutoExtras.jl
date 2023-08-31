using PlutoExtras
using Documenter

DocMeta.setdocmeta!(PlutoExtras, :DocTestSetup, :(using PlutoExtras); recursive=true)

makedocs(;
    modules= Module[],
    authors="Alberto Mengali <disberd@gmail.com>",
    repo="https://github.com/disberd/PlutoExtras.jl/blob/{commit}{path}#{line}",
    sitename="PlutoExtras.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="master",
        assets=String[],
    ),
    pages=[
        "index.md",
        "basic_widgets.md",
        "latex_equations.md",
    ],
)

# This controls whether or not deployment is attempted. It is based on the value
# of the `SHOULD_DEPLOY` ENV variable, which defaults to the `CI` ENV variables or
# false if not present.
should_deploy = get(ENV,"SHOULD_DEPLOY", get(ENV, "CI", "") === "true")

if should_deploy
    @info "Deploying"

deploydocs(
    repo = "github.com/disberd/PlutoExtras.jl.git",
)

end