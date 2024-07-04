/* 
This simple module simply tries to recreate the same environment created by
Pluto and is mostly based on the file in
https://github.com/fonsp/Pluto.jl/blob/5b96b85f1a2500dcefb0a739399f77edf5ae78d6/frontend/common/SetupCellEnvironment.js
but it also adds the _lodash_ package which is available within Pluto
*/

import { Library } from "https://cdn.jsdelivr.net/npm/@observablehq/stdlib@3.3.1/+esm"
import { default as lodash } from "https://cdn.jsdelivr.net/npm/lodash-es@4.17.20/+esm"

const library = new Library()

export const DOM =  library.DOM
export const Files = library.Files
export const Generators = library.Generators
export const Promises = library.Promises
export const now = library.now
export const svg = library.svg()
export const html = library.html()
export const require = library.require()
export const _ = lodash

const mod = {
    DOM, Files, Generators, Promises, now, svg, html, require, _
}

export default mod