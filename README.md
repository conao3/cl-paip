# cl-paip

A Common Lisp implementation of code and concepts from Peter Norvig's "Paradigms of Artificial Intelligence Programming" (PAIP). This project uses Nix for reproducible builds across multiple Common Lisp implementations.

## Features

- Pattern matching (`pat-match`) inspired by PAIP
- Nix-based build system with support for 8 Common Lisp implementations
- FiveAM test suite with code coverage support

## Quick Start

Run the main program:

```sh
nix run .#main-sbcl
```

Run tests:

```sh
nix run .#test-sbcl
```

Start an interactive REPL:

```sh
nix develop -c sbcl
```

Then load the project:

```lisp
(require :uiop)
(load (uiop:getenv "ASDF"))
(require :paip)
```

## Supported Implementations

| Implementation | Run | Test | Coverage |
|----------------|-----|------|----------|
| SBCL | `.#main-sbcl` | `.#test-sbcl` | `.#coverage-sbcl` |
| ECL | `.#main-ecl` | `.#test-ecl` | - |
| ABCL | `.#main-abcl` | `.#test-abcl` | - |
| CCL | `.#main-ccl` | `.#test-ccl` | - |
| MKCL | `.#main-mkcl` | `.#test-mkcl` | - |
| CLISP | `.#main-clisp` | `.#test-clisp` | - |
| CMUCL | `.#main-cmucl_binary` | `.#test-cmucl_binary` | - |
| Clasp | `.#main-clasp-common-lisp` | `.#test-clasp-common-lisp` | - |

## Using as a Dependency

This project exports Nix packages and overlays for use in other projects.

### Packages

- `packages.lib-<impl>` - Library package for the specified implementation
- `packages.main-<impl>` - Executable package for the specified implementation

### Overlay

Add this project's overlay to your Nix configuration:

```nix
let
  pkgs = import nixpkgs {
    inherit system;
    overlays = [
      paip.overlays.default
    ];
  };
in
  # Use pkgs.paip-sbcl or pkgs.sbcl.paip
```

The overlay provides:

- `pkgs.paip-<impl>` - Executables (e.g., `pkgs.paip-sbcl`)
- `pkgs.<impl>.paip` - Libraries (e.g., `pkgs.sbcl.paip`)

## Project Structure

This project uses ASDF's package-inferred-system. Source code is in `src/` and tests are in `test/`.

## License

Inspired by [Comamoca/nix-template](https://github.com/Comamoca/scaffold/tree/main/cl-nix) (CC0 1.0).

MIT No Attribution

Copyright 2024 Masaya Taniguchi

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
