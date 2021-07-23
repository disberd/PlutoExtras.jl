# PlutoUtils

This package provides some very opinionated functionalities to work with PlutoNotebooks

This is mostly meant for personal use I will try to see if something can be adapted and made generic if you file an issue.

The most relevant exported functionalities are detailed in the rest of the README

## Plots using PlotlyBase
Overloading the show function for PlotlyBase.Plot items

This functionality is implemented in [the plolty_show.jl notebook](./src/plotly_show.jl) 

## Interactive TableOfContents
Custom re-implementation of the PlutoUI TableOfContents using preact. This was mostly done to experiment with preact and with creating preact components directly in the notebook.
As my first ever attempt to use React or preact, this is still very alpha but I use it regularly and it mostly works

Compared to the TableOfContents from PlutoUI, it provides some additional functionalities:
- Hiding cells from notebook and TableOfContents
  - All cells before the first heading are automatically hidden from the notebook
  - Showing of hidden cells can be toggled by Alt-clicking on the side of the TableOfContents title
  - Hidden status of specific headings in the notebook can be toggled by Alt-clicking on the related entry in the ToC (When a heading is marked as hidden and the show of hidden cells is false, all the cells between the hidden heading and the next non-hidden heading are also hidden)
- Collapsing headings in the Table of Contents, done by Ctrl+click on a heading
- Shrinking of the TableOfContents when not hovered upon
  - This is toggled by doing a left click on the right of the TableOfContents title
  - Doing so will collapse the ToC to take as little space as possible on the notebook and only expand on hover

This functionality is implemented in [the ToC.jl notebook](./src/ToC.jl) 
