# MTLIndirectCommandBufferDescriptor
A configuration you create to customize an indirect command buffer.

```Swift
// iOS12.0
class MTLIndirectCommandBufferDescriptor : NSObject
```

## Declaring Command Types to Encode
```Swift
var commandTypes: MTLIndirectCommandType
```
The set of command types that you can encode into the indirect command buffer.

## Declaring Command Inheritance
```Swift
var inheritBuffers: Bool
```
A Boolean value that determines where commands in the indirect command buffer get their buffer arguments from when you
execute them.

```Swift
var inheritPipelineState: Bool
```
A Boolean value that determines where commands in the indirect command buffer get their pipeline state from when you execute
them.

## Declaring the Maximum Number of Argument Buffers Per Command
```Swift
var maxVertexBufferBindCount: Int
```
The maximum number of buffers that you can set per command for the vertex stage.

```Swift
var maxFragmentBufferBindCount: Int
```
The maximum number of buffers that you can set per command for the fragment stage.

```Swift
var maxKernelBufferBindCount: Int
```
The maximum number of buffers that you can set per command for the compute kernel.
