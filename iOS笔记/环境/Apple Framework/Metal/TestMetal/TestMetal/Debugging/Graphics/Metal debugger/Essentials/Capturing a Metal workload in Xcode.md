# Capturing a Metal workload in Xcode
Analyze your app’s performance by configuring your project to leverage the Metal debugger.

You can use Xcode to capture your app’s Metal workload.
First, ensure that the GPU Frame Capture option is enabled in the runtime diagnostics options.
Then, when your app is running, click the Metal Capture button in the debug bar, select a scope, and click Capture.

## Configure the GPU Frame Capture options

Xcode automatically enables the GPU Frame Capture option if your target links to the Metal framework,
or any other framework that uses the Metal API.
If you’re collaborating on a project, it’s possible that someone else may have disabled GPU Frame Capture.
To ensure it’s enabled, follow these steps:
1. In the Xcode toolbar, choose Edit Scheme from the Scheme menu.
2. Select the Run scheme action and then click Options.
3. Choose a GPU Frame Capture option and click Close.

The GPU Frame Capture options include the following:
Automatically
Captures Metal or OpenGL ES API usage in your app.
If your target doesn’t link to the Metal framework or the OpenGL ES framework,
the Metal Capture button doesn’t appear in the debug bar.
If your app uses both the Metal API and the OpenGL ES API,
you can click and hold the Capture GPU Frame icon to choose which API usage to capture.

Metal
Captures only Metal API usage in your app.
If your app doesn’t use the Metal API, Xcode disables the Metal Capture button in the debug bar.

Disabled
Doesn’t capture Metal usage in your app.
GPU Frame Capture has a tiny, but measurable, effect on your app’s CPU processing time,
so choose this option when you want to test your app’s maximum performance level.

## Capture your Metal workload while debugging
While debugging your app, you can capture a GPU trace by following these steps:
1. Click the Metal Capture button in the debug bar.
2. Select the scope that you want to capture.
This can be a frame, Metal layer, command queue, device, or any custom scopes that you set up previously.
[Creating and using custom capture scopes]
(https://developer.apple.com/documentation/xcode/creating-and-using-custom-capture-scopes)
3. Select the capture range.
Depending on the scope, this might include the number of frames or command buffers.
4. Optionally, select Profile after Replay so that Xcode automatically profiles after capturing.
Profiling has an initial performance impact on the Metal debugger,
so only enable this option when debugging your app’s performance. You can always profile later as needed.
[Replaying a GPU trace file](https://developer.apple.com/documentation/xcode/replaying-a-gpu-trace-file)
5. Click Capture. Xcode automatically starts capturing a GPU trace when the scope triggers it,
and finishes depending on the range you select.
You can also click the Finish button at any time to manually stop the capture.

## Capture your Metal workload after deployment
You can use Xcode to capture a GPU trace after deploying your macOS or iOS app by following these steps:
1. In Xcode, choose Debug > Debug Executable.
2. Select your app in Finder and click Choose. Xcode automatically brings up the scheme editor.
3. Click the Options tab, choose a GPU Frame Capture option, and click Close.
4. Run your app by choosing Product > Run.
5. Click the Metal Capture button in the debug bar.
6. Select the scope and range that you want to capture. You can optionally select Profile after Replay.
7. Click Capture. Xcode automatically starts capturing a GPU trace when the scope triggers it,
and finishes depending on the range you select.
You can also click the Finish button at any time to manually stop the capture.

Note
You can only capture after deployment in macOS and iOS.
This feature is enabled only for your own apps when using Xcode or TestFlight to deploy them.

## Save the capture to your computer
To save your captured Metal workload as a GPU trace, choose File > Export.
