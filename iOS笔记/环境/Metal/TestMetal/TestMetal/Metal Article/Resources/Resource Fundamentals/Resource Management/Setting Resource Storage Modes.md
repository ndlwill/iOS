# Setting Resource Storage Modes
Set a storage mode that defines the memory location and access permissions of a resource.

By choosing an appropriate storage mode,
you can configure a buffer or texture to benefit from fast memory access and driver-level performance optimizations.
This article describes how to set the storage mode for a buffer or texture. 

## Set a Storage Mode for a Buffer
Create a new MTLBuffer with the makeBuffer(length:options:) method
and set its storage mode in the method’s options parameter.

```Swift
let bufferOptions = MTLResourceOptions.storageModePrivate
let buffer = device.makeBuffer(length: 256,
                               options: bufferOptions)
```

Note
The storage mode options in MTLResourceOptions are equivalent to the storage mode values in MTLStorageMode.
When you create a new buffer, you can combine multiple resource options but you can set only one storage mode.

## Set a Storage Mode for a Texture
Create a new MTLTextureDescriptor and set its storage mode in the descriptor’s storageMode property.
Then create a new MTLTexture with the makeTexture(descriptor:) method.

```Swift
let textureDescriptor = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: .bgra8Unorm,
                                                                 width: 256,
                                                                 height: 256,
                                                                 mipmapped: true)
textureDescriptor.storageMode = .private
let texture = device.makeTexture(descriptor: textureDescriptor)
```
