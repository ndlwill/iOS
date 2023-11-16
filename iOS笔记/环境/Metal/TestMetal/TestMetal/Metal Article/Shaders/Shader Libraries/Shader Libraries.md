# Shader Libraries
Manage and load collections of shaders that Xcode compiles with your project or your app compiles at runtime.

A Metal library represents a collection of one or more shaders.
Your app can create libraries from the shaders that Xcode builds with your project,
an AIR (Apple intermediate representation), or directly from source code.
You can also create AIR files directly by running the Metal compiler on a command prompt.

Typically apps create a default library, which contains all your project’s shaders that Xcode compiles at build time,
by calling a Metal device’s makeDefaultLibrary() method. Apps can also create a library by passing:
* A Metal AIR file to the makeLibrary(URL:) method or one of its siblings
* Source code as an instance of String to the makeLibrary(source:options:) method

To use a shader, such as in a compute or render pass,
you can retrieve an MTLFunction from a library by calling its makeFunction(name:) method.
Metal functions are references to a shader within a library.

Dynamic libraries are a collection of shader functions that you can share and reuse with other shaders.
You can build and distribute dynamic libraries with your app or as middleware for other people’s apps.
