# Capturing a Metal workload programmatically
Analyze your app’s performance by invoking Metal’s frame capture.

Use the MTLCaptureManager to programmatically capture information about commands you send to a specific device object.
For example, you can capture a specific frame or part of a frame, depending on your needs,
by implementing a custom UI that triggers a capture,
or by programmatically triggering a capture at runtime from within your app.

## Enable capturing programmatically
To enable Metal capture in your app, add the MetalCaptureEnabled key to your Info.plist file with a value of YES.
In Xcode’s property list editor, this key appears as Metal Capture Enabled.

Alternatively, in macOS 14 and later, you can set the environment variable on your Metal app: MTL_CAPTURE_ENABLED=1.

Tip
Enabling Metal capture has a tiny, but measurable, effect on your app’s CPU processing time.
You may want to set the value of this key using a build setting in your project so that you can enable it for some builds,
but not for your final release build.

## Capture a device or command queue
Create an MTLCaptureDescriptor object that defines which commands you want to record and what needs to happen after the
capture is complete.
To capture commands for a specific MTLDevice or MTLCommandQueue,
set the capture descriptor’s captureObject property to point at the specific object to track,
and call the startCapture(with:) method.
To stop capturing commands, call the stopCapture() method.

```Swift
func triggerProgrammaticCapture(device: MTLDevice) {
    let captureManager = MTLCaptureManager.shared()
    let captureDescriptor = MTLCaptureDescriptor()
    captureDescriptor.captureObject = self.device
    do {
        try captureManager.startCapture(with: captureDescriptor)
    } catch {
        fatalError("error when trying to capture: \(error)")
    }
}

func runMetalCommands(commandQueue: MTLCommandQueue) {
    let commandBuffer = commandQueue.makeCommandBuffer()!
    // Do Metal work.
    commandBuffer.commit()
    let captureManager = MTLCaptureManager.shared()
    captureManager.stopCapture()
}
```

The capture manager captures commands only within MTLCommandBuffer objects
that you create after the capture starts and commit before the capture stops.

Tip
When you capture a frame programmatically, you can capture Metal commands that span multiple frames.
For example, by calling startCapture at the start of frame 1 and stopCapture after frame 3,
the traces contain command data from all the buffers that the system commits in the three frames.

## Capture specific commands with a capture scope
To capture commands using a custom scope, create an MTLCaptureScope object
and set the capture descriptor’s captureObject property to point to it.

Important
Set the file extension of the outputURL to .gputrace to ensure that you can replay it later in the Metal debugger.

```Swift
func setupProgrammaticCaptureScope(device: MTLDevice) {
    myCaptureScope = MTLCaptureManager.shared().makeCaptureScope(device: device)
    myCaptureScope?.label = "My Capture Scope"
}

func triggerProgrammaticCaptureScope() {
    guard let captureScope = myCaptureScope else { return }
    let captureManager = MTLCaptureManager.shared()
    let captureDescriptor = MTLCaptureDescriptor()
    captureDescriptor.captureObject = captureScope
    do {
        try captureManager.startCapture(with: captureDescriptor)
    } catch {
        fatalError("error when trying to capture: \(error)")
    }
}
```

To define boundaries for the scoped capture,
call the MTLCaptureScope object’s begin() and end() methods just before and after the commands that you want to capture.
Xcode automatically stops capturing when your app reaches the corresponding end() method of the capture scope.

```Swift
func runMetalCommands(commandQueue: MTLCommandQueue) {
    myCaptureScope?.begin()
    let commandBuffer = commandQueue.makeCommandBuffer()!
    // Do Metal work.
    commandBuffer.commit()
    myCaptureScope?.end()
}
```

Important
The capture scope captures commands only within MTLCommandBuffer objects that
you create after the scope begins and commit before the scope ends.

## Save the capture to your computer
If you want to analyze the capture later,
you can skip launching the Metal debugger and save the GPU command information to a GPU trace file.
Call supportsDestination(_:) on the capture manager to
make sure the feature is available before attempting to record a trace file.

```Swift
let captureManager = MTLCaptureManager.shared()

guard captureManager.supportsDestination(.gpuTraceDocument) else {
    print("Capturing to a GPU trace file isn't supported.")
    return
}
```

Then, set the capture descriptor’s destination property to
MTLCaptureDestination.gpuTraceDocument and specify the file’s destination.

```Swift
let captureDescriptor = MTLCaptureDescriptor()
captureDescriptor.captureObject = self.device
captureDescriptor.destination = .gpuTraceDocument
captureDescriptor.outputURL = self.traceURL
...
```
