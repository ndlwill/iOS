# Metal debugger
Debug and profile your Metal workload with a GPU trace.

The Metal debugger consists of a suite of tools for debugging and profiling your Metal app.

Unlike pausing at breakpoints during runtime,
you can capture your Metal workload for multiple frames and then jump back and forth in time to explore the captured work.
The Metal debugger enables you to explore the dependencies between passes,
and offers insights for improving the performance of your app. 
You can also debug your shaders in draw commands and compute dispatches to fix sources of artifacts
[Investigating visual artifacts](https://developer.apple.com/documentation/xcode/investigating-visual-artifacts)

In addition, the Metal debugger displays your Metal workload on a profiling timeline and
offers detailed statistics like performance counters and per-line shader profiling data. 
These tools can help you identify and eliminate performance bottlenecks in your app
[Optimizing GPU performance](https://developer.apple.com/documentation/xcode/optimizing-gpu-performance)
