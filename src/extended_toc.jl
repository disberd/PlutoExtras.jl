using HypertextLiteral
using PlutoUI

# Exports #
export ExtendedTableOfContents, show_output_when_hidden

# Get the directory of this file to locate the JS and CSS files
const _src_dir = @__DIR__

# Main Function #
"""
	ExtendedTableOfContents(;hide_preamble = true, force_hide_enabled = hide_preamble, kwargs...)

# Keyword Arguments
- `hide_preamble` -> When true, all the cells from the beginning of the notebook till the first heading are hidden (when the notebook is in `hide-enabled` state)
- `force_hide_enabled` -> Set the notebook `hide-enabled` status to true when creating the ToC. This status is used to decide whether to show or not hidden cells via CSS.
- `kwargs` -> The remaining kwargs are simply passed to `TableOfContents` from PlutoUI which is used internally to generate the ToC.

# Description

Extends the `TableOfContents` from `PlutoUI` and adds the following functionality:

## Hiding Heading/Cells
Hiding headings and all connected cells from notebook view can be done via ExtendedTableOfContents
- All cells before the first heading are automatically hidden from the notebook
- All hidden cells/headings can be shown by pressing the _eye_ button that appears while hovering on the ToC title. 
  - When the hidden cells are being shown, the hidden headings in the ToC are underlined
- Hidden status of specific headings in the notebook can be toggled by pressing on the eye button that appears to the left each heading when hovering over them

## Collapsing Headings in ToC
ToC headings are grouped based on heading level, sub-headings at various levels can be collapsed by using the caret symbol that appears to the left of headings in the ToC upon hover.

## Save Hide/Collapsed status on notebook file
Preserving the status of collapsed/hidden heading is supported by writing to the notebook file using notebook and cell metadata, allowing to maintain the status even upon reload of Julia/Pluto
- When the current collapsed/hidden status of each heading is not reflected in the notebook file, a save icon/button appears on the left of the ToC title upon hover. Clicking the icon saves the current state in the notebook file.

## Changing Headings/Cells order
The `ExtendedTableOfContents` allow to re-order the cell groups identified by each heading within the notebook:
- Each cell group is identified by the cell containing the heading, plus all the cells below it and up to the next heading (excluded)
- Holding the mouse on a ToC heading triggers the ability to move headings around
  - The target heading is surrounded by a dashed border
  - While moving the mouse within the ToC, a visual separator appears to indicate the position where the dragged heading will be moved to, depending on the mouse position
  - Hovering on collapsed headings for at least 300ms opens them up to allow moving headings within collapsed parents
- By default, headings can only be moved below or above headings of equal or lower level (H1 < H2 < H3...)
  - Holding shift during the dragging process allows to put headings before/after any other heading regardless of the level


# Example usage

# State Manipulation

![State_Manipulation](https://user-images.githubusercontent.com/12846528/217245898-5166682d-b41d-4f1e-b71b-4d7f69c8f192.gif)

# Cell Reordering

![Cell_Reordering](https://user-images.githubusercontent.com/12846528/217245256-58e4d537-9547-42ec-b1d8-2994b6bcaf51.gif)
"""
ExtendedTableOfContents(; hide_preamble = true, force_hide_enabled = hide_preamble, kwargs...) = @htl(
    """
    $(TableOfContents(; kwargs...))
    
    <script>
    // Set global variables for the JavaScript
    const hide_preamble = $hide_preamble;
    const force_hide_enabled = $force_hide_enabled;

    // Load the library for consistent smooth scrolling
    const {default: scrollIntoView} = await import($(PlutoUI.TableOfContentsNotebook.smooth_scoll_lib_url))
    
    // Load and execute the JavaScript functionality
    $(read(joinpath(_src_dir, "extended_toc.js"), String) |> HypertextLiteral.JavaScript)
    </script>
    
    <style>
    /* Load CSS styles directly */
    $(read(joinpath(_src_dir, "extended_toc.css"), String))
    </style>
    """
)

# Other Functions #
## Show output when hidden ##
"""
	show_output_when_hidden(x)
Wraps the given input `x` inside a custom HTML code created with
`HypertextLiteral.@htl` that adds the `always-show-output` attribute to the
calling Pluto cell.

This makes sure that the cell output remains visible in the HTML even when the
cell is hidden using the [`ExtendedTableOfContents`](@ref) cell hiding feature.
This is mostly useful to allow having cells that generate output to be rendered
within the notebook as hidden cells.

The provided attribute will make sure (via CSS) that cell will look exactly like
a hidden cell except for its output element. When the output is floating (like
for [`BondTable`](@ref) or [`ExtendedTableOfContents`](@ref)), this will make
the cell hidden while the rendered output visible.

# Example usage
```julia
BondTable([bonds...]) |> show_output_when_hidden
```

The code above will allow putting the cell defining the `BondTable` within a
hidden part of the notebook while still rendering the floating BondTable.
Without this function, the `BondTable` generating cell would need to be located
inside a non-hidden part of the notebook.

# Note
When calling this function with an input object that is not of type `HTML` or
`HypertextLiteral.Result`, the function will wrap the object first using `@htl`
and `PlutoRunner.embed_display`. Since the `embed_display` function is only
available inside of Pluto,  
"""
show_output_when_hidden(x::Union{HTML, HypertextLiteral.Result}) = @htl(
    """
    $x
    <script>
    	const cell = currentScript.closest('pluto-cell')
    	cell.toggleAttribute('always-show-output', true)

    	invalidation.then(() => {
    		cell.toggleAttribute('always-show-output', false)
    	})
    </script>
    """
)
show_output_when_hidden(x) = isdefined(Main, :PlutoRunner) ?
    show_output_when_hidden(@htl("$(Main.PlutoRunner.embed_display(x))")) : error("You can't call
                             this function outside Pluto")
