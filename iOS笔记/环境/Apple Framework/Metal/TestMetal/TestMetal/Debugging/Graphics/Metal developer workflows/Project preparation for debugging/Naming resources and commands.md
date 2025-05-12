# Naming resources and commands
Enhance the debugging of your Metal app using labels and grouping.

Resource labels and command debug groups are useful when debugging and profiling your app using Metal tools.
Assigning meaningful resource labels helps you find your specific resources more quickly.
Logically grouping commands lets you easily navigate the workload after capturing it.

Note
The properties and methods described here don’t affect the graphics-rendering or compute-processing behavior of your app.

## Annotate resources
Many Metal objects provide a label property where you can assign a meaningful string.
These labels appear in each Metal tool, allowing you to easily identify specific objects.

In addition, for MTLBuffer, the addDebugMarker(_:range:) method allows you to mark and identify specific data ranges.
You can call the removeAllDebugMarkers() method to clear the existing markers.

## Annotate commands
Command buffers and command encoders provide the following methods for you to easily identify specific groups of Metal
commands in your app:
* On an MTLCommandBuffer object, call pushDebugGroup(_:) and popDebugGroup() to group commands within that buffer.
* On an MTLCommandEncoder object, call pushDebugGroup(_:) and popDebugGroup() to group commands within that encoder.
In addition, call insertDebugSignpost(_:) to mark interesting locations in the encoder.

Xcode pushes and pops debug groups using unique stacks that exist only within the lifetime of their associated
MTLCommandBuffer or MTLCommandEncoder.
You can nest debug groups by pushing multiple groups onto the stack before popping previous groups.

Use these methods to simplify your app development process,
particularly for tasks that involve many Metal commands per buffer or encoder.

The following example demonstrates pushing and popping multiple debug groups:
```Swift
func encodeRenderPass(commandBuffer: MTLCommandBuffer, descriptor: MTLRenderPassDescriptor) { 
    guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor) else { return }
    renderEncoder.label = "My Render Encoder"
    renderEncoder.pushDebugGroup("My Render Pass")

        renderEncoder.pushDebugGroup("Pipeline Setup")
        // Render pipeline commands.
        renderEncoder.popDebugGroup() // Pops "Pipeline Setup".

        renderEncoder.pushDebugGroup("Vertex Setup")
        // Vertex function commands.
        renderEncoder.popDebugGroup() // Pops "Vertex Setup".

        renderEncoder.pushDebugGroup("Fragment Setup")
        // Fragment function commands.
        renderEncoder.popDebugGroup() // Pops "Fragment Setup".

        renderEncoder.pushDebugGroup("Draw Calls")
        // Drawing commands.
        renderEncoder.popDebugGroup() // Pops "Draw Calls".

    renderEncoder.popDebugGroup() // Pops "My Render Pass".
    renderEncoder.endEncoding()
}
```
