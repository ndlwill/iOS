# Copying Data to a Private Resource
Use a blit command encoder to copy buffer or texture data to a private resource.

Resources with an MTLStorageMode.private storage mode are accessible only to the GPU.
Private resources perform better than shared resources,
and you don’t have to explicitly synchronize them the way you do for managed resources.

However, because private resources aren’t accessible to the CPU, you can’t populate them with it. 、
To write data from the CPU to a private resource, you must first write the data to a shared or managed resource.
You can then copy the data from that resource to the private resource.


## Copying Data from a Shared Buffer to a Private Buffer
First, create a shared buffer and populate its contents using the makeBuffer(bytes:length:options:) method.

```Swift
// Create and populate a source buffer.
let bufferData = <#UnsafeRawPointer#>, bufferLength = <#Int#>
let bufferOptions = MTLResourceOptions.storageModeShared
if let sourceBuffer = device.makeBuffer(bytes: bufferData, length: bufferLength, options: bufferOptions) {
    ...
}
```

Next, create a private buffer that’s large enough to store your buffer data using the makeBuffer(length:options:)method.
```Swift
// Create a private buffer.
if let privateBuffer = device.makeBuffer(length: bufferLength, options: .storageModePrivate) {
    ...
}
```

Finally, encode and commit a copy(from:sourceOffset:to:destinationOffset:size:) command.
Set the shared buffer as the sourceBuffer parameter.
Set the private buffer as the destinationBuffer parameter.

```Swift
// Create a command buffer for GPU work.
guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }


// Create a blit command encoder.
guard let blitCommandEncoder = commandBuffer.makeBlitCommandEncoder() else { return }


// Copy data from the source buffer to the private buffer.
let sourceBuffer = <#MTLBuffer#>, privateBuffer = <#MTLBuffer#>, bufferLength = <#Int#>
blitCommandEncoder.copy(from: sourceBuffer, sourceOffset: 0, to: privateBuffer, destinationOffset: 0, size: bufferLength)
blitCommandEncoder.endEncoding()


// Add a completion handler and commit the command buffer.
let commandBufferHandler = <#MTLCommandBufferHandler#>
commandBuffer.addCompletedHandler(commandBufferHandler)
commandBuffer.commit()
```

Note
In macOS, Metal doesn’t reformat buffer contents or layout to improve GPU access.
There’s no difference in GPU performance between managed or private buffers,
so there’s no performance benefit in copying data from a managed buffer to a private buffer.


## Copying Data from a Shared Buffer to a Private Texture
Use this implementation to copy texture data from the CPU to a private texture in one operation,
without having to synchronize a managed texture.

First, create a shared buffer and populate its contents with your texture data.

```Swift
// Create and populate a source buffer with texture data.
let textureData = <#UnsafeRawPointer#>, textureSize = <#MTLSize#>
let textureLength = pixelSize * textureSize.width * textureSize.height
let textureOptions = MTLResourceOptions.storageModeShared
if let sourceBuffer = device.makeBuffer(bytes: textureData, length: textureLength, options: textureOptions) {
    ...
}
```

Next, create a private texture with a suitable configuration for the texture data.

```Swift
// Create a texture descriptor.
let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                 width: textureSize.width,
                                                                 height: textureSize.height,
                                                                 mipmapped: true)


// Set the texture descriptor's storage mode to private.
textureDescriptor.storageMode = MTLStorageMode.private


// Create a private texture from the descriptor.
let privateTexture = device.makeTexture(descriptor: textureDescriptor)
```

Finally, encode and commit a
copy(from:sourceOffset:sourceBytesPerRow:sourceBytesPerImage:sourceSize:to:destinationSlice:destinationLevel:destinationOrigin:) command.
Set the shared buffer as the sourceBuffer parameter. Set the private texture as the destinationTexture parameter.

```Swift
// Create a command buffer for GPU work.
guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }


// Create a blit command encoder.
guard let blitCommandEncoder = commandBuffer.makeBlitCommandEncoder() else { return }


// Copy data from the source buffer to the private texture.
sourceBuffer = <#MTLBuffer#>, textureSize = <#MTLSize#>, privateTexture = <#MTLTexture#>, textureOrigin = <#MTLOrigin#>
let bytesPerRow = pixelSize * textureSize.width
let bytesPerImage = pixelSize * textureSize.width * textureSize.height
blitCommandEncoder.copy(from: sourceBuffer, sourceOffset: 0, sourceBytesPerRow: bytesPerRow,
                        sourceBytesPerImage: bytesPerImage, sourceSize: textureSize, to: privateTexture,
                        destinationSlice: 0, destinationLevel: 0, destinationOrigin: textureOrigin)
blitCommandEncoder.endEncoding()


// Add a completion handler and commit the command buffer.
let commandBufferHandler = <#MTLCommandBufferHandler#>
commandBuffer.addCompletedHandler(commandBufferHandler)
commandBuffer.commit()
```


## Copying Data from a Shared or Managed Texture to a Private Texture
First, create a shared texture or for Mac apps, a managed texture.
Then populate the contents of the source texture using the replace(region:mipmapLevel:withBytes:bytesPerRow:) method.

```Swift
// Create and populate a source texture.
let sourceTexture = device.makeTexture(descriptor: textureDescriptor)
let region = MTLRegionMake2D(textureOrigin.x, textureOrigin.y, textureSize.width, textureSize.height)
let textureData = <#UnsafeRawPointer#>
let bytesPerRow = pixelSize * textureSize.width
sourceTexture.replace(region: region, mipmapLevel: 0, withBytes: textureData, bytesPerRow: bytesPerRow)
```

Next, create a private texture with a suitable configuration for your texture data.
If appropriate, reuse the texture descriptor that you configured for the shared or managed texture.

```Swift
// Set the texture descriptor's storage mode to private.
textureDescriptor.storageMode = MTLStorageMode.private

// Create a private texture from the descriptor.
let privateTexture = device.makeTexture(descriptor: textureDescriptor)
```

Finally, encode and commit a
copy(from:sourceSlice:sourceLevel:sourceOrigin:sourceSize:to:destinationSlice:destinationLevel:destinationOrigin:) command.
Set the shared or managed texture as the sourceTexture parameter.
Set the private texture as the destinationTexture parameter.

```Swift
// Create a command buffer for GPU work.
guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }


// Create a blit command encoder.
guard let blitCommandEncoder = commandBuffer.makeBlitCommandEncoder() else { return }


// Copy data from the source texture to the private texture.
blitCommandEncoder.copy(from: sourceTexture, sourceSlice: 0, sourceLevel: 0, sourceOrigin: textureOrigin,
                        sourceSize: textureSize, to: privateTexture, destinationSlice: 0, destinationLevel: 0,
                        destinationOrigin: textureOrigin)
blitCommandEncoder.endEncoding()


// Add a completion handler and commit the command buffer.
let commandBufferHandler = <#MTLCommandBufferHandler#>
commandBuffer.addCompletedHandler(commandBufferHandler)
commandBuffer.commit()
```

Copying data from a managed texture to a private texture involves two copy operations.
For the first operation,
Metal synchronizes the managed texture and copies the texture data from CPU-accessible memory to GPU-accessible memory.
For the second operation, Metal copies the texture data from the managed texture to the private texture.


## Copying Data from a Private Texture to a Shared Buffer
Use this implementation to copy texture data from the GPU to a shared buffer, without having to synchronize a managed texture.

First, create a private texture.

```Swift
// Create a texture descriptor.
let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                 width: textureSize.width,
                                                                 height: textureSize.height,
                                                                 mipmapped: false)

// Set the texture descriptor's storage mode to private.
textureDescriptor.storageMode = MTLStorageMode.private

// Create a private texture from the descriptor.
let sourceTexture = device.makeTexture(descriptor: textureDescriptor)
```

Next, create a shared buffer that’s large enough to store your texture data.

```Swift
// Create a shared buffer.
let textureLength = pixelSize * textureSize.width * textureSize.height
let textureOptions = MTLResourceOptions.storageModeShared
if let sourceBuffer = device.makeBuffer(length: textureLength, options: textureOptions) {
    ...
}
```

Next, encode a compute, render, or blit pass to populate the contents of your private texture.

```Swift
// Create a command buffer for GPU work.
guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }


// Encode a compute, render, or blit pass to populate the source texture's contents.
...
```

Finally, encode and commit a
copy(from:sourceSlice:sourceLevel:sourceOrigin:sourceSize:to:destinationOffset:destinationBytesPerRow:destinationBytesPerImage:) command.
Set the private texture as the sourceTexture parameter.
Set the shared buffer as the destinationBuffer parameter.

```Swift
// Create a blit command encoder.
guard let blitCommandEncoder = commandBuffer.makeBlitCommandEncoder() else { return }


// Encode a blit pass to copy data from the source texture to the shared buffer.
let bytesPerRow = pixelSize * textureSize.width
let bytesPerImage = pixelSize * textureSize.width * textureSize.height
let privateBuffer = <#MTLBuffer#>, bufferLength = <#Int#>
blitCommandEncoder.copy(from: sourceTexture, sourceSlice: 0, sourceLevel: 0,
                        sourceOrigin: textureOrigin, sourceSize: textureSize, to: sharedBuffer,
                        destinationOffset: 0, destinationBytesPerRow: bytesPerRow,
                        destinationBytesPerImage: bytesPerImage)
blitCommandEncoder.endEncoding()


// Add a completion handler and commit the command buffer.
let commandBufferHandler = <#MTLCommandBufferHandler#>
commandBuffer.addCompletedHandler(commandBufferHandler)
commandBuffer.commit()
```
