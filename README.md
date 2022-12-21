# ExtendedPlutoUI

This provides some widgets to be used in Pluto, including an extended version of the TableOfContents from PlutoUI

# IMPORTANT!
This package was originally called PlutoUtils but is undergoing significant internal restructuring and will be published to the General Registry after this restructuring is done.

## ExtendedTableOfContents
This package exports `ExtendedTableOfContents` which takes the `TableOfContents` from `PlutoUI` and adds the following functionalities:
- Hiding cells from notebook and TableOfContents
  - All cells before the first heading are automatically hidden from the notebook
  - Showing of hidden cells can be toggled by pressing the _eye_ button that appears while hovering on the ToC title
  - Hidden status of specific headings in the notebook can be toggled by pressing on the eye button that appears to the left each heading when hovering over them
- Collapsing headings in the Table of Contents, done by using the caret symbol that appears to the left of headings that contains sub-headings
- Fixing the scrolling issue apperaing on chromium brosers with the scrolling in the TableOfContents (see https://github.com/JuliaPluto/PlutoUI.jl/issues/238) by relying on the [SmoothScroll](https://github.com/LieutenantPeacock/SmoothScroll/) library
- Preserving the status of collapsed/hidden heading by writing to the notebook file using notebook and cell metadata
  - Saving the current state of the TableOfContents can be achieved by pressing the save-icon that appears to the right of the TableOfContents title when hovering with the mouse


This functionality is implemented in the [extended_toc.jl](./src/extended_toc.jl) notebook.

### Example usage

![ExtendedTableOfContents](https://user-images.githubusercontent.com/12846528/128350961-c4ccbcea-ba75-48dc-bd92-7c6551cc68f9.gif)
