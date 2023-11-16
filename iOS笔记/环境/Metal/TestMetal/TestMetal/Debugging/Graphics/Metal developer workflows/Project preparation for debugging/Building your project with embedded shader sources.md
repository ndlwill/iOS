# Building your project with embedded shader sources
Prepare to debug your project’s shaders by including source code in the build.

To debug your shaders in Xcode, configure your build to include shader source code by changing your project’s build settings.
Select your project in the Project navigator, click the Build Settings tab, and search for the Produce Debugging Information
setting in the Metal Compiler Build Options section.
Then, change the setting’s Debug entry to “Yes, include source code.”

Alternatively, you can debug the shaders that you compile for release by generating a separate symbol file for each Metal
library in your project.
For more information on using this approach, see Generating and Loading a Metal Library Symbol File.

Important
To ensure you don’t include debugging information in apps you ship to customers,
be sure to reset the Produce Debugging Information for Release option to No when you finish debugging.
