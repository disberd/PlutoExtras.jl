# Changelog

This file contains the changelog for the PlutoExtras package. It follows the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.

## [Unreleased]
Changelog was introduced in this version. Only changes w.r.t. version v0.7.14 are listed

### Added
- Added an option to the `@NTBond` macro to provide a function as third argument which is applied via `PlutoUI.Experimental.transformed_value` to the bond resulting from the `@NTBond` macro.
- Added a new exported type `StructBondSelect` to the module `StructBondModule` which simplifies creating a widget whose value may have different number of fields/parameters depending on a dropdown selector.
- The package now re-exports the names exported by its `StructBondModule` submodule.