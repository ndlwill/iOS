Create and manage untyped data your app uses to exchange information with its shader functions.

Each MTLBuffer instance represents a general purpose,
typeless memory allocation that your app uses to send and retrieve data from a shader.
Your app decides how to use and interpret the buffer’s underlying bytes.

You create buffers from either an MTLDevice or MTLHeap instance.

```Swift
let deviceBuffer = device.makeBuffer(length: bufferSize,
                                     options: .storageModeShared)

let heapBuffer = heap.makeBuffer(length: bufferSize,
                                 options: .storageModePrivate)
```
                                 
Buffers inherently support the MTLResource protocol’s properties and methods,
including storageMode, which controls how the GPU handles its memory (see Resource Fundamentals).
