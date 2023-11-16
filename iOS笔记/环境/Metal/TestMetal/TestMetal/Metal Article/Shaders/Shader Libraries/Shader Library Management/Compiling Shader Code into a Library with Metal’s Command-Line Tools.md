# Compiling Shader Code into a Library with Metal’s Command-Line Tools
Build Shader Libraries project by running the Metal compiler toolchain in a command-line environment.

You can manually compile a Metal shader library from your Metal shader source files outside your Xcode project by directly
invoking the command-line tools.
The Metal compiler converts each of your Metal Shading Language (MSL) source files into an Apple intermediate
representation, or AIR, format.
You can then compile AIR files into a Metal library or into an archive, which you can also build into a library.

The diagram starts at the source code stage, which contains multiple files that end with a dot-metal suffix,
flowing into the intermediate representation stage, which contains files that end with a dot-AIR suffix.

The arrow connecting them shows a command line tool named ‘metal’.

The intermediate representation stage flows into two other stages: the library stage,
which contains a single file that ends with a dot ‘metal’ LIB suffix, and the archive stage,
which has multiple files that end with dot ‘metal’ AR.

The arrow that connects the intermediate representation stage to the archive stage shows the command line tool named,
metal, dash, a, r.

The arrows that connect both the intermediate representation and archives stages to the library stage shows the command line
tool named ‘metal’ LIB.

## Compile a Shader Source File into a Library
The following code shows the minimum number of commands that
you need to compile and build a single .metal file into a single .metallib file.
You can run these commands in the Terminal app and use the -help command to
display the available options for each Metal tool.
This example uses the macosx SDK, but you can use the iphoneos or appletvos SDK instead.

```Shell
xcrun -sdk macosx metal -c MyLibrary.metal -o MyLibrary.air
xcrun -sdk macosx metallib MyLibrary.air -o MyLibrary.metallib
```

Open a Terminal window, with the following steps:
1. Use the metal tool to compile each .metal file into a single .air file,
which stores an intermediate representation of Metal Shading Language source code.
2. Optionally, use the metal-ar tool to archive several .air files together into a single .metalar file.
(The metal-ar tool is similar to the UNIX ar tool.)
3. Use the metallib tool to build .air or .metalar files into a single .metallib file, which stores the Metal library.

## Retrieve and Access a Built Library
After you’ve built a library with Metal’s command-line tools, add the resulting .metallib file to your Xcode project.
Then, at runtime, call the makeLibrary(filepath:) method to retrieve and access your library as a MTLLibrary object.

```Swift
guard let libraryFile = Bundle.main.path(forResource: "MyLibrary", ofType: "metallib") else { return }
do {
    let myLibrary = try device.makeLibrary(filepath: libraryFile)
} catch let error {
    print("Library error: \(error.localizedDescription)")
}
```
