using PlutoExtras
using PlutoExtras.StructBondModule
using Documenter

DocMeta.setdocmeta!(PlutoExtras, :DocTestSetup, :(using PlutoExtras); recursive=true)

makedocs(;
    modules= [PlutoExtras],
    authors="Alberto Mengali <disberd@gmail.com>",
    repo=Remotes.GitHub("disberd", "PlutoExtras.jl"),
    sitename="PlutoExtras.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        edit_link="master",
        assets=String[],
    ),
    warnonly = true,
    pages=[
        "index.md",
        "basic_widgets.md",
        "latex_equations.md",
        "toc.md",
        "structbond.md",
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