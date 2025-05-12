# Positioning Samples Programmatically
Configure the position of samples when rendering to a multisampled render target.

When you perform a render pass that uses multisample antialiasing (MSAA) operations,
the GPU samples and resolves subpixels using a specific visual pattern.
On GPUs that support programmable sample positions, you can change this pattern.
Programmable sample positions unlock additional rendering techniques because you can configure them into custom patterns that
you reuse or reposition in each render pass.

##  Verify Support for Programmable Sample Positions
Not all GPUs support programmable sample positions.
Check for support by reading the areProgrammableSamplePositionsSupported property on a device object.
If this property's value is false, the device object uses fixed sample positions that you can't query or modify.

Additionally, the number of sample positions that the device object supports may vary.
Call the supportsTextureSampleCount(_:) method to determine if a given number of samples is usable on that device object.

## Get the Default Sample Positions
Programmable sample positions are set on a 4-bit subpixel grid (16 x 16 subpixels).
Floating-point values are in the [0.0,1.0) range along each axis, with the origin (0,0) defined at the top-left corner.
You can set values from 0/16 up to 15/16, inclusive, in 1/16 increments along each axis.

Metal uses the same default sample positions on all GPUs that support programmable sample positions.
Get the default sample positions for a given sample count by calling the getDefaultSamplePositions(_:count:) method
Programmable sample positions are defined as an array of MTLSamplePosition values.

```Swift
let samples = self.device.getDefaultSamplePositions(sampleCount: 4)
```

## Set the Sample Positions in a Render Pass
To change the sample positions in a render pass, call the setSamplePositions(_:count:) method of a MTLRenderPassDescriptor,
as shown below, passing in the array of sample positions you want to use.

```Swift
let samplePositions = [
    MTLSamplePosition(x: 0.25, y: 0.25),
    MTLSamplePosition(x: 0.75, y: 0.25),
    MTLSamplePosition(x: 0.75, y: 0.75),
    MTLSamplePosition(x: 0.25, y: 0.75)
]
renderPassDescriptor.setSamplePositions(samplePositions)
```
