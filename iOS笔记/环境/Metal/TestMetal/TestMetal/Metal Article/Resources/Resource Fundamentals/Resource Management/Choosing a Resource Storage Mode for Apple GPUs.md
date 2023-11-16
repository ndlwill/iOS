# Choosing a Resource Storage Mode for Apple GPUs
Select an appropriate storage mode for your textures and buffers on Apple GPUs.

Apple GPUs have a unified memory model in which the CPU and the GPU share system memory.
However, CPU and GPU access to that memory depends on the storage mode you choose for your resources.
The MTLStorageMode.shared mode defines system memory that both the CPU and the GPU can access.
The MTLStorageMode.private mode defines system memory that only the GPU can access.

The MTLStorageMode.memoryless mode defines tile memory within the GPU that only the GPU can access.
Tile memory has higher bandwidth, lower latency, and consumes less power than system memory.

## Choose a Resource Storage Mode for Buffers or Textures
Several options are available, depending on your resource’s access needs:
Populated and updated by the CPU. Choose the MTLStorageMode.shared mode if your resource requires CPU access.

Accessed exclusively by the GPU. Choose the MTLStorageMode.private mode
if you populate your resource with the GPU through a compute, render, or blit pass.
This case is common for render targets, intermediary resources, or texture streaming.


## Create a Memoryless Render Target
To create a memoryless render target,
set the storageMode property of an MTLTextureDescriptor to MTLStorageMode.memoryless
and use this descriptor to create a new MTLTexture.
Then set this new texture as the texture property of an MTLRenderPassAttachmentDescriptor.

```Swift
let memorylessDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .r16Float,
                                                                    width: 256,
                                                                    height: 256,
                                                                    mipmapped: true)
memorylessDescriptor.storageMode = .memoryless
let memorylessTexture = device.makeTexture(descriptor: memorylessDescriptor)


let renderPassDescriptor = MTLRenderPassDescriptor()
renderPassDescriptor.depthAttachment.texture = memorylessTexture
```

[Rendering a Scene with Deferred Lighting in Objective-C]
(https://developer.apple.com/documentation/metal/metal_sample_code_library/rendering_a_scene_with_deferred_lighting_in_objective-c)

See Rendering a Scene with Deferred Lighting in Objective-C
for an example of an app that uses a memoryless render target.

Note
You can create only textures, not buffers, using MTLStorageMode.memoryless mode.
You can’t use buffers as memoryless render targets.
