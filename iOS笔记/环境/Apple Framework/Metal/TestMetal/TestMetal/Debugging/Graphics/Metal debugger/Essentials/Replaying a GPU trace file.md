# Replaying a GPU trace file
Debug and profile your app’s performance using a GPU trace file in the Metal debugger.

Replaying a GPU trace file allows you to debug and profile previously captured GPU commands using the Metal debugger. 

To replay a GPU trace file, open it in Xcode. Before clicking Replay,
you can configure which device to use (if there’s more than one available),
as well as configure whether to run with profiling.

## Configure replay
If you have multiple devices, you need to select a device before you can replay the GPU trace file.
Xcode automatically selects the most compatible device, but you can select a different device using the Device popover.

Warning
GPU trace files are only compatible with devices of the same type, the same GPU, and the same operating system.
Otherwise, performance may vary.
For example, if you capture a Metal workload on a Mac with an AMD GPU,
replaying the exported GPU trace file on a Mac with the Apple M1 chip may not work or behave the same.

You can optionally enable the Profile GPU Trace option to have Xcode automatically profile after replaying.
Profiling has an initial performance impact on the Metal debugger,
so only enable this option when debugging your app’s performance.
You can always profile later as needed.
