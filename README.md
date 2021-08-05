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

This functionality is implemented in the [ToC.jl](./src/ToC.jl) notebook 

## @ingredients macro

	@ingredients path nameskwargs...
	@ingredients modname=path namekwargs...

This macro is used to include external julia files inside a pluto notebook and is inspired by the discussion on [this Pluto issue](https://github.com/fonsp/Pluto.jl/issues/1101).

It requires Pluto > v0.15.1 (requires macro analysis functionality) and includes and external file, taking care of putting in the caller namespace all varnames that are tagged with `export varname` inside the included file.

The macro relies on the use of `Base.names` to get the variable names to be exported, and support providing the names of the keyword arguments of `names` to be set to true as additional strings (as example, calling `@ingredients "file_path" "all"` will bring into the caller namespace all the variables that are defined in the included file, regardless of whether they are `exported` or not.)

Finally, to allow to correctly reflect variations (in Pluto) in defined and exported variables inside of the included file, a custom `HTML` element is placed as last output of the macro block, so that it is sent to the cell output and executed on the browser.
This overwrites shortcut for *Shift-Enter* inside the cell that contains the `@ingredients` macro.
It simply adds a function call to toggle adding and removing a whitespace at the end of the cell input before *running* the cell when pressing the keyboard shortcut *Shift-Enter*.

This has the effect of re-expand the macro and recompute the symbols that are assigned in the cell, rather than using the cached version as it's done when the cell input didn't change.

This functionality is implemented in the [ingredients_macro.jl](./src/ingredients_macro.jl) notebook 

### Example usage

![@ingredients usage gif](gifs/ingredients_macro_example.gif?raw=true)