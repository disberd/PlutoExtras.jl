module PlutoUtils
using Requires
using Reexport
@reexport using HypertextLiteral: @htl, @htl_str, JavaScript, Result
@reexport using PlutoUI 
@reexport using Chain
@reexport using PrettyTables
@reexport using PlutoDevMacros

# Create the filtering functions for include calls from PlutoDevMacros
pluto_mapexpr = include_mapexpr()

include(pluto_mapexpr,"imagepaste.jl")
include(pluto_mapexpr,"editable.jl")
include(pluto_mapexpr,"mixedutils.jl")
include(pluto_mapexpr,"ToC.jl")
include(pluto_mapexpr,"./latex_equations.jl")
include(pluto_mapexpr,"./prettytable.jl")
include(pluto_mapexpr,"./kbd_shortcuts.jl")
include(pluto_mapexpr,"./html2canvas_savediv.jl")

function __init__()
	@require PlotlyBase="a03496cd-edff-5a9b-9e67-9cda94a718b5" include("plotly_show.jl")
end

end # module
