# CHANGELOG

## [1.1.0] - 2026-03-24

### Added
- **Interactive Wizard Mode**: If you run the converter without arguments, it now starts an interactive menu with three options:
  - Choose Files manually (with MultiSelect support for .jsx files).
  - Convert all .jsxbin files in the current working directory.
  - Change working directory within the session.
- **Optional Output Path**: The output filename is now optional in CLI mode. If omitted, files will be saved in a `jsxbin-converted/` directory.
- **Filename Collision Resolution**: Added logic to automatically append a numbered suffix (e.g., `filename-(1).jsx`) if the output file already exists, preventing accidental overwrites.
- **Improved Directory Handling**: The tool now automatically creates necessary directories for the output paths.

### Changed
- Refactored core decoding logic into a shareable `Converter` class.
- Detailed the `Usage` section in `README.md` to reflect new modes and command-line arguments.

## [1.0.0] - Prior Release
- Initial stable release of the JSXBIN to JSX converter.
- Support for AST decoding and Prettier-powered formatting.
