# LaTeX Equations
PlutoExtras provides some convenience functions to display numbered equations using [KaTeX](https://katex.org).
The use of KaTeX as opposed to Mathjax as in Markdown is that complex interpolation of Julia variables work better and automatic equation numbering based on the cell position in the notebook is possible.

KaTeX [supports](https://katex.org/docs/supported.html) automatic numbering of
*equation* environments.  While it does not support equation reference and
labelling, [this](https://github.com/KaTeX/KaTeX/issues/2003) hack on github
shows how to achieve the label functionality.

Unfortunately, since automatic numbering in KaTeX uses CSS counters, it is not
possible to access the value of the counter at a specific DOM element.  We then
create a function that loops through all possible katex equation and counts
them, putting the relevant number in the appropriate hyperlink innerText to
create equation references that automatically update.

If one wants the exploit equation referencing with automatic numbering update, this functionality **must be initialized** by having a cell which calls [`initialize_eqref`](@ref) as its last statement (so that the javascript code it generates is sent to the cell output)

## Example
```@raw html
<video controls=true>
<source src="https://user-images.githubusercontent.com/12846528/264626063-1dd7ca9b-9463-4e27-b1ac-d8b2a860ea9b.mp4" type="video/mp4">
</video>
```
Open the [latex test notebook](https://github.com/disberd/PlutoExtras.jl/blob/master/test/notebooks/latex_equations.jl) to check this functionality in action!

## API
```@docs
initialize_eqref
texeq
@texeq_str
eqref
```