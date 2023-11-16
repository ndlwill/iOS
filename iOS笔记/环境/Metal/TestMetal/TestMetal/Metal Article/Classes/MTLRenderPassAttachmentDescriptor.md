# MTLRenderPassAttachmentDescriptor

```Swift
// iOS8.0
class MTLRenderPassAttachmentDescriptor : NSObject
```

Use a MTLRenderPassAttachmentDescriptor object to configure an individual render target of a framebuffer.
Each MTLRenderPassAttachmentDescriptor object specifies one texture that a graphics rendering pass can write into.

|  Attachment type   | Descriptor subclass  |
|  ----  | ----  |
| Color  | MTLRenderPassColorAttachmentDescriptor |
| Depth  | MTLRenderPassDepthAttachmentDescriptor |
| Stencil | MTLRenderPassStencilAttachmentDescriptor |



