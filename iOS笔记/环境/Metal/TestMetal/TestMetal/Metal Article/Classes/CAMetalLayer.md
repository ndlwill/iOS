# CAMetalLayer
A Core Animation layer that Metal can render into, typically displayed onscreen.

```Swift
class CAMetalLayer : CALayer
```

Use a CAMetalLayer when you want to use Metal to render a layer’s contents; for example, to render into a view.
Consider using MTKView instead, because this class automatically wraps a CAMetalLayer object and provides a higher-level abstraction.

If you’re using UIKit, to create a view that uses a CAMetalLayer,
create a subclass of UIView and override its layerClass class method to return a CAMetalLayer:

```Objective-C
+ (Class)layerClass
{
    return [CAMetalLayer class];
}
```

If you’re using AppKit, configure an NSView object to use a backing layer and assign a CAMetalLayer object to the view:

```Objective-C
myView.wantsLayer = YES;
myView.layer = [CAMetalLayer layer];
```

Adjust the layer’s properties to configure its underlying pixel format and other display behaviors.

## Rendering the Layer's Contents
A CAMetalLayer creates a pool of Metal drawable objects (CAMetalDrawable).
At any given time, one of these drawable objects contains the contents of the layer.
To change the layer’s contents, ask the layer for a drawable object, render into it,
and then update the layer’s contents to point to the new drawable.

Call the layer’s nextDrawable() method to obtain a drawable object.
Get the drawable object’s texture and create a render pass that renders to that texture, as shown in the code below:

```Objective-C
CAMetalLayer *metalLayer = (CAMetalLayer*)self.layer;
id<CAMetalDrawable> *drawable = [metalLayer nextDrawable];


MTLRenderPassDescriptor *renderPassDescriptor
                               = [MTLRenderPassDescriptor renderPassDescriptor];


renderPassDescriptor.colorAttachments[0].texture = drawable.texture;
renderPassDescriptor.colorAttachments[0].loadAction = MTLLoadActionClear;
renderPassDescriptor.colorAttachments[0].clearColor = MTLClearColorMake(0.0,0.0,0.0,1.0);
...
```

To change the layer’s contents to the new drawable,
call the present(_:) method (or one of its variants) on the command buffer containing the encoded render pass,
passing in the drawable object to present.

```Objective-C
[commandBuffer presentDrawable:drawable];
```

## Keeping References to Drawables
The layer reuses a drawable only if it isn’t onscreen and there are no strong references to it.
Further, if a drawable isn’t available when you call nextDrawable(), the system waits for one to become available.
To avoid stalls in your app, request a new drawable only when you need it,
and release any references to it as quickly as possible after you’re done with it.

For example, before retrieving a new drawable,
you might perform other work on the CPU or submit commands to the GPU that don’t require the drawable.
Then, obtain the drawable and encode a command buffer to render into it, as described above.
After you commit this command buffer, release all strong references to the drawable.
If you don’t release drawables correctly, the layer runs out of drawables, and future calls to nextDrawable() return nil.

## Releasing the Drawable
Don’t release the drawable explicitly; instead, embed your render loop within an autorelease pool block:

```Swift
func draw(in view: MTKView) {
    autoreleasepool {
        render(view: view)
    }
}
```

This block releases drawables promptly and avoids possible deadlock situations with multiple drawables.
Release drawables as soon as possible after committing your onscreen render pass.

Note
As of iOS 10 and tvOS 10, you can safely retain a drawable to query its properties,
such as drawableID and presentedTime, after the system has presented it.
If you don’t need to query these properties, release the drawable when you no longer need it.

## Instance Property

The number of Metal drawables in the resource pool managed by Core Animation.
```Swift
// iOS11.2
var maximumDrawableCount: Int { get set }
```
You can set this value to 2 or 3 only;
if you pass a different value, Core Animation ignores the value and throws an exception.
The default value is 3.
