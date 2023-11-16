# MTLIndirectCommandBuffer
A command buffer containing reusable commands, encoded either on the CPU or GPU.

```Swift
// iOS12.0
protocol MTLIndirectCommandBuffer
```

Use an indirect command buffer to encode commands once and reuse them, and to encode commands on multiple CPU or GPU threads.

Don’t implement this protocol yourself; instead, create a MTLIndirectCommandBufferDescriptor object,
configure its properties, and tell the MTLDevice to create the indirect command buffer.
