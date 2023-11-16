# MTLTexture
A resource that holds formatted image data.

```Swift
// iOS8.0
protocol MTLTexture
```
Don’t implement this protocol yourself; instead, use one of the following methods to create a MTLTexture instance:
* Create an MTLTextureDescriptor instance to describe the texture’s properties and then call the makeTexture(descriptor:) method of the MTLDevice protocol to create the texture.
* To create a texture that uses an existing IOSurface to hold the texture data, create an MTLTextureDescriptor instance to describe the image data in the surface. Call the makeTexture(descriptor:iosurface:plane:) method to create the texture.
* To create a texture that reinterprets another texture’s data as if it had a different format, call the makeTextureView(pixelFormat:) or makeTextureView(pixelFormat:textureType:levels:slices:) method on a texture instance. You must choose a pixel format for the new texture compatible with the source texture’s pixel format. The new texture shares the same storage allocation as the source texture. If you make changes to the new texture, the source texture reflects those changes, and vice versa.
* To create a texture that uses an MTLBuffer instance’s contents to hold pixel data, create an MTLTextureDescriptor object to describe the texture’s properties. Then call the makeTexture(descriptor:offset:bytesPerRow:) method on the buffer object. The new texture object shares the storage allocation of the source buffer object. If you make changes to the texture, the buffer reflects those changes, and vice versa.

After you create a MTLTexture object, most of its characteristics,
such as its size, type, and pixel format are all immutable. Only the texture’s pixel data is mutable.

To copy pixel data from system memory into the texture, call
replace(region:mipmapLevel:slice:withBytes:bytesPerRow:bytesPerImage:) or replace(region:mipmapLevel:withBytes:bytesPerRow:).

To copy pixel data back to system memory, call
getBytes(_:bytesPerRow:bytesPerImage:from:mipmapLevel:slice:) or getBytes(_:bytesPerRow:from:mipmapLevel:).
