# MTLHeap
A memory pool from which you can suballocate resources.

```Swift
// iOS10.0
protocol MTLHeap
```

Don’t implement this protocol yourself; instead, to create a heap,
configure a MTLHeapDescriptor object and call the makeHeap(descriptor:) method of a MTLDevice object.

You suballocate resources from a heap and make them aliasable or non-aliasable.
A sub-allocated resource is non-aliased by default, preventing future resources allocated from the heap from using its
memory.
Resources are aliased when they share the same memory allocation on a heap.

All resources sub-allocated from the same heap share the same storage mode and CPU cache mode.
You can make heaps purgeable, but not the resources allocated from the heap;
they can only reflect the heap’s purgeability state.
