# PlutoExtras
[![Build Status](https://github.com/disberd/PlutoExtras.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/disberd/PlutoExtras.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/disberd/PlutoExtras.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/disberd/PlutoExtras.jl)

This package provides some widgets to be used in Pluto, including an extended version of the TableOfContents from PlutoUI and a new experimental bond container (`BondTable`). 

This was formerly a non-registered package named PlutoUtils

## BondTable (NEW!)

There is some new under-development experimental feature to simplify the grouping and displaying of many bonds within a given notebook in a floating table (similar to the TableOfContents) that stays on the left and can be hidden, resized and moved around.

Have a look at the notebook at [notebooks/test_bondstable.jl](https://rawcdn.githack.com/disberd/PlutoExtras.jl/94fdc84217b5591343ba4671666511d16b1c0eaf/html_exports/test_bondstable.jl.html) for an example of the features/capabilities. (The link points to a static html export of the notebook. If you want to execute the notebook, remember that it has to be executed from the cloned repository as it currently uses the package environment of the package)

## ExtendedTableOfContents
The [extended_toc.jl](./test/notebooks/extended_toc.jl) notebook shows the example use of `ExtendedTableOfContents`, which takes the `TableOfContents` from `PlutoUI` and adds the following functionalities:

### Hiding Heading/Cells
Hiding headings and all connected cells from notebook view can be done via ExtendedTableOfContents
- All cells before the first heading are automatically hidden from the notebook
- All hidden cells/headings can be shown by pressing the _eye_ button that appears while hovering on the ToC title. 
  - When the hidden cells are being shown, the hidden headings in the ToC are underlined
- Hidden status of specific headings in the notebook can be toggled by pressing on the eye button that appears to the left each heading when hovering over them

### Collapsing Headings in ToC
ToC headings are grouped based on heading level, sub-headings at various levels can be collapsed by using the caret symbol that appears to the left of headings in the ToC upon hover.

### Save Hide/Collapsed status on notebook file
Preserving the status of collapsed/hidden heading is supported by writing to the notebook file using notebook and cell metadata, allowing to maintain the status even upon reload of Julia/Pluto
- When the current collapsed/hidden status of each heading is not reflected in the notebook file, a save icon/button appears on the left of the ToC title upon hover. Clicking the icon saves the current state in the notebook file.

### Changing Headings/Cells order
The `ExtendedTableOfContents` allow to re-order the cell groups identified by each heading within the notebook:
- Each cell group is identified by the cell containing the heading, plus all the cells below it and up to the next heading (excluded)
- Holding the mouse on a ToC heading triggers the ability to move headings around
  - The target heading is surrounded by a dashed border
  - While moving the mouse within the ToC, a visual separator appears to indicate the position where the dragged heading will be moved to, depending on the mouse position
  - Hovering on collapsed headings for at least 300ms opens them up to allow moving headings within collapsed parents
- By default, headings can only be moved below or above headings of equal or lower level (H1 < H2 < H3...)
  - Holding shift during the dragging process allows to put headings before/after any other heading regardless of the level


### Example usage

#### State Manipulation

![State_Manipulation](https://user-images.githubusercontent.com/12846528/217245898-5166682d-b41d-4f1e-b71b-4d7f69c8f192.gif)

#### Cell Reordering

![Cell_Reordering](https://user-images.githubusercontent.com/12846528/217245256-58e4d537-9547-42ec-b1d8-2994b6bcaf51.gif)

