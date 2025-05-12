# Creating an Indirect Command Buffer
Configure a descriptor to specify the properties of an indirect command buffer.

An indirect command buffer stores encoded GPU commands persistently.
Using an indirect command buffer, you can encode a command once and reuse it multiple times.
You can also encode commands into an indirect command buffer simultaneously with multiple threads on the CPU or with a
compute kernel on the GPU.

To create an indirect command buffer, first create a MTLIndirectCommandBufferDescriptor object and configure the
descriptor’s properties.
Then call makeIndirectCommandBuffer(descriptor:maxCommandCount:options:) on a MTLDevice object to create the indirect
command buffer.
