# Metal developer workflows
Locate and fix issues related to your app’s use of the Metal API and GPU functions.

Metal comes with a comprehensive suite of advanced developer tools to help you debug and optimize your Metal apps.

## Runtime diagnostics
You can enable API Validation when running your app to check for incorrect Metal API usage. 
[Validating your app’s Metal API usage]
(https://developer.apple.com/documentation/xcode/validating-your-apps-metal-api-usage)

Enable Shader Validation when running your app to check for issues like out-of-bounds memory access,
missing useResource calls, and stack overflows.
[Validating your app’s Metal shader usage]
(https://developer.apple.com/documentation/xcode/validating-your-apps-metal-shader-usage)

The Metal Performance HUD offers a visual overlay to catch performance issues while your app is running.
[Monitoring your Metal app’s graphics performance]
(https://developer.apple.com/documentation/xcode/monitoring-your-metal-apps-graphics-performance)

## Runtime performance analysis
The Metal system trace tool in Instruments provides a visual timeline of the parallel work on the CPU and the GPU,
and the memory usage of your Metal app.

You can begin profiling with the Game Performance template
[Analyzing the performance of your Metal app]
(https://developer.apple.com/documentation/xcode/analyzing-the-performance-of-your-metal-app)
or the Game Memory template
[Analyzing the memory usage of your Metal app]
(https://developer.apple.com/documentation/xcode/analyzing-the-memory-usage-of-your-metal-app)

## Advanced Metal debugging and profiling
The Metal debugger in Xcode provides advanced tools for debugging and profiling your Metal app.

[Metal debugger](https://developer.apple.com/documentation/xcode/metal-debugger)

You can get summaries of your Metal workload with the Dependencies viewer and the Memory viewer,
inspect individual resources, and selectively debug your shaders
For more information on debugging
[Investigating visual artifacts](https://developer.apple.com/documentation/xcode/investigating-visual-artifacts)

In addition, you can optimize your Metal app by drilling down performance bottlenecks
with the Performance timeline and the per-line shader profiling results.
For more information on profiling
[Optimizing GPU performance](https://developer.apple.com/documentation/xcode/optimizing-gpu-performance)
