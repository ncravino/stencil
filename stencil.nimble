# Package

version       = "0.1.0"
author        = "nunocravino"
description   = "Eldritch Stencil: A templated static blog generator in Nim"
license       = "BSD-3-Clause-Clear"
srcDir        = "src"
binDir        = "build"
bin           = @["stencil"]


# Dependencies

requires "nim >= 1.6.10", "markdown >= 0.8.5", "mustache >= 0.4.3"
