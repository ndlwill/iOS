Learn the common attributes of all Metal memory resources, including buffers and textures, and how to manage the underlying memory.

A resource is a memory asset, such as an MTLBuffer or MTLTexture, that a GPU can access (see Buffers and Textures).

You can either allocate a resource from an MTLDevice instance or an MTLHeap instance (see Memory Heaps).
Metal sets a resource’s hazardTrackingMode property to MTLHazardTrackingMode.default if you don’t specify another tracking mode.
The default value depends on what Metal instance creates the resource.
* Resources from Metal device instances default to MTLHazardTrackingMode.tracked.
* Resources from Metal heap instances default to MTLHazardTrackingMode.untracked.

Each resource your app creates typically uses one of these storage modes:
MTLStorageMode.private
Apps can only access resources in private storage from the GPU.

MTLStorageMode.shared
Apps can access resources in shared storage from both the CPU and the GPU.

MTLStorageMode.managed
Apps can access resources in managed storage from both the CPU and the GPU, just like shared storage. However, the GPU backs resources in managed mode with memory in private storage.

Private mode resources give your app optimization opportunities that shared mode resources don’t.
Managed mode resources also give your app the same opportunities and allow your to app access them from the CPU.
