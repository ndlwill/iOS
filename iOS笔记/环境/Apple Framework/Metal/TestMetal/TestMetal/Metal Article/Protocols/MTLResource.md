# MTLResource
An allocation of memory that is accessible to a GPU.

```Swift
// iOS8.0
protocol MTLResource
```

When you execute commands on the GPU, those commands can only affect memory allocated as MTLResource objects.
These Metal resources can only be modified by the MTLDevice that created them.
Different resource types have different uses.
The most common resource types are buffers (MTLBuffer),
which are linear allocations of memory, and textures (MTLTexture), which hold structured image data.
Don’t implement this protocol yourself; instead, create resources by calling methods on MTLDevice, MTLBuffer, or MTLTexture.

