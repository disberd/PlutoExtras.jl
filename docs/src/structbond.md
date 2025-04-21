# StructBond Module

The StructBondModule submodule of PlutoExtras defines and exports functionality to easily create widgets for custom structure and combine multiple bonds together in a convenient floating side table.

!!! note
    The StructBondModule is currently not re-exported by PlutoExtras so it has to be explicitly used with `using PlutoExtras.StructBondModule`

Open the [structbond test notebook static html](https://rawcdn.githack.com/disberd/PlutoExtras.jl/0e3153d29d3b112f93507c042a35b8161a3bb661/html_exports/test_bondstable.jl.html) to see the look of the widgets exported.\
Or open the [related notebook](https://github.com/disberd/PlutoExtras.jl/blob/master/test/notebooks/structbondmodule.jl) directy in Pluto to check their functionality in action!
!!! note
    The notebook must be run from the original folder (`test/notebooks`) within the `PlutoExtras` package folder to properly load the PlutoExtras package

## StructBond
Generating automatic widgets for custom structs is quite straightforward with
the aid of the [`@fielddata`](@ref) macro and the [`StructBond`](@ref) type.

The `StructBond` structure wraps another structure and generates a widget that can be used together with `@bind` to obtain instances of a custom structure.
In order to correctly display the widget, the description and widget associated to each field of the structure must be specified either.

This can be done either using [`@fielddata`](@ref) as in the example video below or by using the separate [`@fieldbond`](@ref) and [`@fielddescription`](@ref) separately.

```@raw html
<video controls=true>
<source src="https://user-images.githubusercontent.com/12846528/264639467-ecda1c22-141a-4297-98d7-0667d2e8d5a4.mp4" type="video/mp4">
</video>
```

## @NTBond
Sometimes custom structs are not needed and it would be useful to just use the same nice bond structure of [`StructBond`](@ref) to simply create arbitrary NamedTuples. 

This is possible with the convenience macro [`@NTBond`](@ref) which can be called as shown below to create a nice display for an interactive bond creating an arbitrary NamedTuple.

The macro simply create a [`StructBond`](@ref) wrapping the desired NamedTuple type.
```@raw html
<video controls=true>
<source src="https://user-images.githubusercontent.com/12846528/264640510-c605d3af-77c8-4752-9b80-8bc85545d566.mp4" type="video/mp4">
</video>
```

## StructBondSelect
Sometimes, one wants to create a more complex binding where the number of parameters to control a bond can vary depending on some other variable. The `StructBondSelect` can be of help in some of these cases, by providing a way to select out of a number of arbitrary `StructBonds` (which include `@NTBond`) by using a dropdown to select the one to be displayed and used for generating the `StructBondSelect` widget's output.

This structure can be constructed with a vector of `StructBond` or `transformed_value(f, ::StructBond)` elements, and will take care of generating an appropriate widget to display and process only the selected one.

The main signature of the constructor is the following:
```julia
StructBondSelect(els::Vector; description = "StructBondSelect", default_idx = 1, selector_text = "Selector")
```

The names to select upon will be taken from the `description` of the provided `StructBonds`, while the text displayed next to the _selector_ will default to `Selector` but can be customized with the `selector_text` kwarg to the constructor.
The `description` kwarg can be used to customize the text in the widget container (similar to the same kwarg in `StructBond` and to `@NTBond`). Finally, the `default_idx` should be an integer and will select which of the provided `StructBond`s will be selected as default when instantiating the widget.

```@raw html
<video controls=true>
<source src="https://private-user-images.githubusercontent.com/12846528/435671114-795c3da9-ede1-4f96-a971-038a8ce506c3.mp4?jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NDUyNDA0ODgsIm5iZiI6MTc0NTI0MDE4OCwicGF0aCI6Ii8xMjg0NjUyOC80MzU2NzExMTQtNzk1YzNkYTktZWRlMS00Zjk2LWE5NzEtMDM4YThjZTUwNmMzLm1wND9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTA0MjElMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUwNDIxVDEyNTYyOFomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTdmMWZmYjJhNTIyNGI5NDFmMDk3ODcxZWU2ZTE3Njk1MGYyZDk2MmQ5ZTI1NzEyNzJlZTZkNjUxMDhkNDI4ODYmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.XXQ6NJLqc1MoBVQXY9MNageij2F0DhsEzvQpHSP9F4A" type="video/mp4">
</video>
```

## @BondsList
In some cases, one does not want to have a single bond wrapping either a Structure or a NamedTuple because single independent bonds are more convenient.

[`@BondsList`](@ref) is a convenience macro to create an object of type [`BondsList`](@ref) which simply allow to add a description to separate bonds and group them all together in a table-like format equivalent to those of [`StructBond`](@ref).

!!! note
	Unlike [`StructBond`](@ref), a BondsList is already composed of bond created with [`@bind`](@ref) and it just groups them up with a description. The output of [`@BondsList`](@ref) is not supposed to be bound to a variable using [`@bind`](@ref).\
	The bonds grouped in a BondsList still act and update independently from one another.

See the example below for understanding the synthax. The header of a BondsList is shown in an orange background to easily differentiate it from [`StructBond`](@ref).
```@raw html
<video controls=true>
<source src="https://user-images.githubusercontent.com/12846528/264641605-7ab58c12-2c30-47c3-a93a-d64784c34a71.mp4" type="video/mp4">
</video>
```

## Popout/popoutwrap
The structures above can also be used nested within one another. To facilitate accessing nested structures, one can use the [`Popout`](@ref) type.

In its simple form, you can give an instance of a StructBond, a bond wrapping a StructBond or a BondsList as input to Popout to create a table that is hidden behind a popup window.
If an instance present, but you want a custom type for which you have defined custom bonds and descriptions with [`@fielddata`](@ref) to appear as popout, you can use the function `popoutwrap(TYPE)` to generate a small icon which hides a popup containing the [`StructBond`](@ref) of the provided type `TYPE`.

The StructBond table appears on hover upon the icon, can be made fixed by clicking on the icon and can then be moved around or resized.
A double click on the header of the popout hides it again:
```@raw html
<video controls=true>
<source src="https://user-images.githubusercontent.com/12846528/264643126-cdf19078-70cb-46e2-aeb0-304a05ecf08a.mp4" type="video/mp4">
</video>
```

The ability to also wrap pre-existing bonds around StructBonds is convenient for organizing the various bonds one have in a [`BondsList`](@ref) or [`BondTable`](@ref)

As an example, one can create a [`BondsList`](@ref) containing the two [`StructBond`](@ref) bonds generated at the beginning of this notebook (the videos in the [structbond section above](#StructBond)) like in the following example:
```@raw html
<video controls=true>
<source src="https://user-images.githubusercontent.com/12846528/264645841-263f0cb3-ac79-4fe2-b66a-f8d5a4a70896.mp4" type="video/mp4">
</video>
```

## BondTable
The final convenience structure provided by this module is the [`BondTable`](@ref). It can be created to group a list of bonds in a floating table that stays on the left side of the notebook (similar to the TableOfContents of PlutoUI) and can be moved around and resized or hidden for convenience.

The BondTable is intended to be used either with bonds containing [`StructBond`](@ref) or with [`BondsList`](@ref). Future types with similar structure will also be added.

Here is an example of a bondtable containing all the examples seen so far.
```@raw html
<video controls=true>
<source src="https://user-images.githubusercontent.com/12846528/264646632-8c1b3eed-1adf-434b-925a-d57b99fc3c29.mp4" type="video/mp4">
</video>
```

## API

### Main
```@docs
StructBondModule.StructBond
StructBondModule.@fielddata
StructBondModule.@NTBond
StructBondModule.@BondsList
StructBondModule.popoutwrap
StructBondModule.BondTable
```

### Secondary/Advanced
```@docs
StructBondModule.@fieldbond
StructBondModule.@fielddescription
StructBondModule.Popout
StructBondModule.@popoutasfield
StructBondModule.@typeasfield
```