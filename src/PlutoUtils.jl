module PlutoUtils
using Requires
using Reexport
@reexport using HypertextLiteral
@reexport using PlutoUI 
@reexport using Chain
# @reexport using PrettyTables
using PlutoDevMacros

include("imagepaste.jl")
include("editable.jl")
include("mixedutils.jl")
include("ToC.jl")
include("./latex_equations.jl")
# include("./prettytable.jl")
include("./kbd_shortcuts.jl")
include("./html2canvas_savediv.jl")
module BondsDict include("bonds_dict.jl") end
module ExtendedToc include("extended_toc.jl") end # exports the ExtendedTableOfContents object
using .ExtendedToc
export ExtendedTableOfContents

function __init__()
	@require PlotlyBase="a03496cd-edff-5a9b-9e67-9cda94a718b5" begin
		println("PlutoUtils: Loading plotly convenience methods")
		include("plotly_colors.jl")
		include("plotly_show.jl")
		include("plotly_save.jl")
	end
end

end # module
