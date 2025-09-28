# Changelog

This file contains the changelog for the PlutoExtras package. It follows the [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) format.

## [0.7.16] - 2025-09-26

### Fixed
- Fixed problems with `ExtendedTableOfContents` with recent PlutoUI versions, also resolving an issue with `hide-heading` icon not appearing next to the corresponding heading in the ToC.
- Fixed styling issue with `BondsTable` in #19
- The `show_output_when_hidden` function now works correctly with `ExtendedTableOfContents`, not incorrectly hiding the cell input when cell should be shown normally (Fixes #46)

### Added
- Added possibility of providing any valid object with a `MIME"text/html"` representation as description of the `@NTBond` macro.
- Added the possibility of simplifying application of `PlutoUI.Experimental.transformed_value` to the fields of an `@NTBond` using the `@tv` decorator (see the example notebook for details).

### Changed
- Changed the hiding behavior of the `Popout` container so that it stays displayed if the mouse is hovering over its contents even if not popped out
- The internal logic for hiding cells in the notebook based on the ToC rows hiding status is now relying purely on JS attributes attached to cells rather than complex dynamic CSS, simplifying logic and allowing to fix some issues.


## [0.7.15] - 2025-04-22
Changelog was introduced in this version. Only changes w.r.t. version v0.7.14 are listed

### Added
- Added an option to the `@NTBond` macro to provide a function as third argument which is applied via `PlutoUI.Experimental.transformed_value` to the bond resulting from the `@NTBond` macro.
- Added a new exported type `StructBondSelect` to the module `StructBondModule` which simplifies creating a widget whose value may have different number of fields/parameters depending on a dropdown selector.
- The package now re-exports the names exported by its `StructBondModule` submodule.