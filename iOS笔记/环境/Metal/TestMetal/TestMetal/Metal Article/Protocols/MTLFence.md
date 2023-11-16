# MTLFence
An object that can capture, track, and manage resource dependencies across command encoders.

```Swift
// iOS10.0
protocol MTLFence
```

A MTLFence object is typically used to track a sub-allocated resource created from a MTLHeap object.
However, it can also track a non-heap resource that specifies a hazardTrackingModeUntracked resource option.

Don’t implement this protocol yourself;
instead, to create a MTLFence object, call the makeFence() method of a MTLDevice object.
A command encoder can either update a fence or wait for a fence.
Refer to the methods listed in the following table for further information.

| Command encoder object | Method to update a fence | Method to wait for a fence |
| ---- | ---- | ---- |
| MTLBlitCommandEncoder | updateFence(_:) | waitForFence(_:) |
| MTLComputeCommandEncoder | updateFence(_:) | waitForFence(_:) |
| MTLRenderCommandEncoder | updateFence(_:after:) | waitForFence(_:before:) |


## MTLRenderCommandEncoder

updateFence(_:after:)
Encodes a command that instructs the GPU to update a fence after one or more stages,
which signals passes waiting on the fence.

Fences maintain global order to prevent GPU deadlocks as the GPU runs various passes,
including render passes, within the same command queue.
The render pass notifies any passes waiting for fence (see waitForFence(_:before:))
each time it finishes running a stage in the stages parameter.


waitForFence(_:before:)
Encodes a command that instructs the GPU to pause before starting one or more stages of the render pass
until a pass updates a fence.

Fences maintain global order to prevent GPU deadlocks as the GPU runs various passes,
including render passes, within the same command queue.
The render pass waits for a pass to update fence (see updateFence(_:after:))
before running any stage in the stages parameter.

Important
For a render pass that updates and waits for the same fence,
call waitForFence(_:before:) only before calling updateFence(_:after:), but not the reverse.


The GPU driver evaluates the pass’s fences and the commands that
depend on them when your app commits the enclosing MTLCommandBuffer.

An Apple silicon GPU can update and respond to fences on a per-stage basis.
That allows those GPUs to run portions of different stages, such as vertex and fragment, at the same time.
You can check whether a GPU is in an Apple GPU family with the supportsFamily(_:) method.
