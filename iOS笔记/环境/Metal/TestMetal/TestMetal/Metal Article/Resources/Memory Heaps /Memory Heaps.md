# Memory Heaps
Take control of your app’s GPU memory management by creating a large memory allocation for
various buffers, textures, and other resources.

Use an MTLHeap to quickly create and destroy GPU resources.
Heaps can also help your apps save memory by aliasing portions of it in multiple places.

Create a heap by calling an MTLDevice instance’s makeHeap(descriptor:) method.

Note
Metal only synchronizes resources that you create from a Metal heap
and that have the hazardTrackingMode property set to MTLHazardTrackingMode.tracked.
