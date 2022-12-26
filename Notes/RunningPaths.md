# Running paths

A simple recap.

Executables can be in any folder and optionally sym linked or added to PATH.

The paths passed to the CLI should be handled automatically.

We can get the path to the executable like so

`CommandLine.arguments.first`

But make no mistake, this is not what we ever want, the following is what we usually want to get absolute path to the location where the executable is called from.

`FileManager.default.currentDirectoryPath`

`URL(fileURLWithPath: path)` // path being `./`
