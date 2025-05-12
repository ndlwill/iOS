# Setting Load and Store Actions
Set actions that define how a render pass loads and stores a render target.

```Swift
// Types of actions performed for an attachment at the start of a rendering pass.
/**
case dontCare
The GPU has permission to discard the existing contents of the attachment at the start of the render pass, replacing them with arbitrary data.
case load
The GPU preserves the existing contents of the attachment at the start of the render pass.
case clear
The GPU writes a value to every pixel in the attachment at the start of the render pass.
*/
enum MTLLoadAction : UInt, @unchecked Sendable

// Types of actions performed for an attachment at the end of a rendering pass.
/**
case dontCare
The GPU has permission to discard the rendered contents of the attachment at the end of the render pass, replacing them with arbitrary data.
case store
The GPU stores the rendered contents to the texture.
case multisampleResolve
The GPU resolves the multisampled data to one sample per pixel and stores the data to the resolve texture, discarding the multisample data afterwards.
case storeAndMultisampleResolve
The GPU stores the multisample data to the multisample texture, resolves the data to a sample per pixel, and stores the data to the resolve texture.
case unknown
The app will specify the store action when it encodes the render pass.
case customSampleDepthStore
The GPU stores depth data in a sample-position–agnostic representation.
*/
enum MTLStoreAction : UInt, @unchecked Sendable
```

MTLLoadAction and MTLStoreAction values
allow you to define how a render pass loads and stores your MTLRenderPassAttachmentDescriptor objects.
By choosing appropriate actions for your render targets,
you can avoid costly and unnecessary work at the start (load) or end (store) of a render pass.

Set a render targetʼs texture on its texture property. Then, set its actions on its loadAction and storeAction properties:

```Swift
let renderPassDescriptor = MTLRenderPassDescriptor()

// Color render target
renderPassDescriptor.colorAttachments[0].texture = colorTexture
renderPassDescriptor.colorAttachments[0].loadAction = .clear
renderPassDescriptor.colorAttachments[0].storeAction = .store

// Depth render target
renderPassDescriptor.colorAttachments[0].texture = depthTexture
renderPassDescriptor.colorAttachments[0].loadAction = .dontCare
renderPassDescriptor.colorAttachments[0].storeAction = .dontCare

// Stencil render target
renderPassDescriptor.colorAttachments[0].texture = stencilTexture
renderPassDescriptor.colorAttachments[0].loadAction = .dontCare
renderPassDescriptor.colorAttachments[0].storeAction = .dontCare
```

## Choose a Load Action
Several options are available, depending on which of the following scenarios describes your render targetʼs loading needs.

You donʼt need the previous contents of the render target and you render to all of its pixels.
Choose MTLLoadAction.dontCare.
This action incurs no cost, and pixel values are always undefined at the start of the render pass.

You donʼt need the previous contents of the render target and you render to only some of its pixels.
Choose MTLLoadAction.clear.
This action incurs the cost of writing the render targetʼs clear value to each pixel.

You do need the previous contents of the render target and you render to only some of its pixels.
Choose MTLLoadAction.load.
This action incurs the cost of loading the previous values of each pixel from memory.
This action is significantly slower than MTLLoadAction.dontCare or MTLLoadAction.clear.

Note
You canʼt choose MTLLoadAction.load for a memoryless render target because it isnʼt backed by system memory.

## Choose a Store Action
Several options are available, depending on which of the following scenarios describes your render targetʼs storage needs.

You donʼt need to preserve the contents of the render target.
Choose MTLStoreAction.dontCare.
This action incurs no cost, and pixel values are always undefined at the end of the render pass.
Choose this action for intermediary render targets that you use within the render pass, but you donʼt need afterward.
This is typically the correct action for depth and stencil render targets.

You do need to preserve the contents of the render target.
Choose MTLStoreAction.store.
This action incurs the cost of storing the values of each pixel to memory.
This is always the correct action for drawables.

Your render target is a multisample texture.
When you perform multisampling, you decide whether to store the render targetʼs multisampled or resolved data.
Multisampled data is stored in the render targetʼs texture property.
Resolved data is stored in the render targetʼs resolveTexture property.
Refer to this table to choose a store action when multisampling:

| Multisampled data stored | Resolved data stored | Resolve texture required | Required store action |
| ---- | ---- | ---- | ---- |
| Yes | Yes | Yes | MTLStoreAction.storeAndMultisampleResolve |
| Yes | No | No | MTLStoreAction.store |
| No | Yes | Yes | MTLStoreAction.multisampleResolve |
| No | No | No | MTLStoreAction.dontCare |

To store and resolve a multisample texture in a single render pass,
always choose the MTLStoreAction.storeAndMultisampleResolve action and use a single render command encoder.

You need to defer your storage choice.
In some cases, you might not know which store action to use for a particular render target until you gather more render pass information.
To defer your store action choice,
set the temporary MTLStoreAction.unknown value when you create your MTLRenderPassAttachmentDescriptor object.
Setting an unknown store action may avoid potential costs incurred by setting another store action prematurely.
However, you must specify a valid store action before you finish encoding your render pass; otherwise, an error occurs.

Note
You canʼt choose MTLStoreAction.store or MTLStoreAction.storeAndMultisampleResolve for a memoryless render target
because it isnʼt backed by system memory.

## Evaluate Actions Between Render Passes
You can use the same render targets across multiple render passes.
Several load and store combinations are possible for the same render target between any two render passes,
depending on which of the following scenarios describes your render targetʼs needs from one render pass to another.

You donʼt need the previous contents of a render target in the next render pass.
In the first render pass, choose MTLStoreAction.dontCare to avoid storing the contents of the render target.
In the second render pass, choose MTLLoadAction.dontCare or MTLLoadAction.clear to avoid loading the contents of the render target.

You do need the previous contents of a render target in the next render pass.
In the first render pass, choose MTLStoreAction.store,
MTLStoreAction.multisampleResolve, or MTLStoreAction.storeAndMultisampleResolve to store the contents of the render target.
In the second render pass, choose MTLLoadAction.load to load the contents of the render target.
