# Resource Synchronization
Coordinate the contents of data buffers, textures, and other resources that CPUs and GPUs share access to.

By default, Metal tracks the write hazards and synchronizes the resources you create from an MTLDevice and directly bind to
a pipeline.
However, Metal doesn’t, by default, track resources you allocate from an MTLHeap.

Note
You can also create a resource from a Metal device and set it to MTLHazardTrackingMode.untracked,
or create a resource from a Metal heap and set it to MTLHazardTrackingMode.tracked.

Your app is responsible for manually synchronizing the resources that Metal doesn’t track.
You can synchronize resources with these mechanisms, which are in ascending scope order:
* Memory barriers
* Memory fences
* Metal events
* Metal shared events

A memory barrier forces any subsequent commands to wait until the previous commands in a pass
(such as a render or compute pass) finishes using memory.
You can limit the scope of a memory barrier to a buffer, texture, render attachment, or a combination.

An MTLFence synchronizes access to one or more resources across different passes within a command buffer.
Use fences to specify any inter-pass resource dependencies within the same command buffer.

An MTLEvent synchronizes access to one or more resources on a single MTLDevice.
You can tell the GPU to pause work until another command signals an event.
See Synchronizing Events Within a Single Device for more information.
[Synchronizing Events Within a Single Device]
(https://developer.apple.com/documentation/metal/resource_synchronization/synchronizing_events_within_a_single_device)

An MTLSharedEvent synchronizes access to one or more resources with other Metal device instances or with the CPU.
Shared events are similar to a regular event, but with a larger scope that goes beyond a single GPU to include the CPU and
other GPUs.
See Synchronizing Events Between a GPU and the CPU and Synchronizing Events Across Multiple Devices or Processes for more
information.
[Synchronizing Events Between a GPU and the CPU]
(https://developer.apple.com/documentation/metal/resource_synchronization/synchronizing_events_between_a_gpu_and_the_cpu)
[Synchronizing Events Across Multiple Devices or Processes]
(https://developer.apple.com/documentation/metal/resource_synchronization/synchronizing_events_across_multiple_devices_or_processes)

Tip
For better performance, use the synchronization mechanism with the smallest scope possible.


Memory barriers and fences synchronize resource data within a command buffer.
