module PlutoUtils
using Requires
using PlutoDevMacros
using Reexport
@reexport using HypertextLiteral: @htl, @htl_str, JavaScript, Result
@reexport using PlutoUI 
@reexport using Chain
@reexport using PrettyTables

include("imagepaste.jl")
include("editable.jl")
include("mixedutils.jl")
include("ToC.jl")
include("./latex_equations.jl")
include("./prettytable.jl")
include("./kbd_shortcuts.jl")
include("./ingredients_macro.jl")

function __init__()
	@require PlotlyBase="a03496cd-edff-5a9b-9e67-9cda94a718b5" include("plotly_show.jl")
end

end # module
