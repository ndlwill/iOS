/*
 * runtime.cpp
 * libclosure
 *
 * Copyright (c) 2008-2010 Apple Inc. All rights reserved.
 *
 * @APPLE_LLVM_LICENSE_HEADER@
 */


#include "Block_private.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <os/assumes.h>
#ifndef os_assumes
#define os_assumes(_x) os_assumes(_x)
#endif
#ifndef os_assert
#define os_assert(_x) os_assert(_x)
#endif

//Cannot find _platform_memmove
//#define memmove _platform_memmove

#if TARGET_OS_WIN32 // win32 __sync_bool_compare_and_swap()函数
#define _CRT_SECURE_NO_WARNINGS 1
#include <windows.h>
static __inline bool OSAtomicCompareAndSwapLong(long oldl, long newl, long volatile *dst) 
{ 
    // fixme barrier is overkill -- see objc-os.h
    long original = InterlockedCompareExchange(dst, newl, oldl);
    return (original == oldl);
}

static __inline bool OSAtomicCompareAndSwapInt(int oldi, int newi, int volatile *dst) 
{ 
    // fixme barrier is overkill -- see objc-os.h
    int original = InterlockedCompareExchange(dst, newi, oldi);
    return (original == oldi);
}
#else

// __sync_bool_compare_and_swap 是 GCC 内建的原子操作函数， 执行CAS操作，比较 _Ptr 和 _Old。 如果相等就将 _New 放到 _Ptr 中，并且返回true，否则返回false
#define OSAtomicCompareAndSwapLong(_Old, _New, _Ptr) __sync_bool_compare_and_swap(_Ptr, _Old, _New)
#define OSAtomicCompareAndSwapInt(_Old, _New, _Ptr) __sync_bool_compare_and_swap(_Ptr, _Old, _New)
#endif


/*******************************************************************************
Internal Utilities
********************************************************************************/


static int32_t latching_incr_int(volatile int32_t *where) {
    while (1) {
        int32_t old_value = *where;
        if ((old_value & BLOCK_REFCOUNT_MASK) == BLOCK_REFCOUNT_MASK) {
            return BLOCK_REFCOUNT_MASK;
        }
        if (OSAtomicCompareAndSwapInt(old_value, old_value+2, where)) {
            return old_value+2;
        }
    }
}

static bool latching_incr_int_not_deallocating(volatile int32_t *where) {
    while (1) {
        int32_t old_value = *where;
        if (old_value & BLOCK_DEALLOCATING) {
            // if deallocating we can't do this
            return false;
        }
        if ((old_value & BLOCK_REFCOUNT_MASK) == BLOCK_REFCOUNT_MASK) {
            // if latched, we're leaking this block, and we succeed
            return true;
        }
        
        if (OSAtomicCompareAndSwapInt(old_value, old_value+2, where)) {
            // otherwise, we must store a new retained value without the deallocating bit set
            return true;
        }
    }
}


// return should_deallocate?
static bool latching_decr_int_should_deallocate(volatile int32_t *where) {
    while (1) {
        int32_t old_value = *where;
        if ((old_value & BLOCK_REFCOUNT_MASK) == BLOCK_REFCOUNT_MASK) {
            return false; // latched high
        }
        if ((old_value & BLOCK_REFCOUNT_MASK) == 0) {
            return false;   // underflow, latch low
        }
        int32_t new_value = old_value - 2;
        bool result = false;
        if ((old_value & (BLOCK_REFCOUNT_MASK|BLOCK_DEALLOCATING)) == 2) {
            new_value = old_value - 1;
            result = true;
        }
        if (OSAtomicCompareAndSwapInt(old_value, new_value, where)) {
            return result;
        }
    }
}


/**************************************************************************
Framework callback functions and their default implementations.
***************************************************************************/
#if !TARGET_OS_WIN32
#pragma mark Framework Callback Routines
#endif

static void _Block_retain_object_default(const void *ptr __unused) { }

static void _Block_release_object_default(const void *ptr __unused) { }

static void _Block_destructInstance_default(const void *aBlock __unused) {}

static void (*_Block_retain_object)(const void *ptr) = _Block_retain_object_default;
static void (*_Block_release_object)(const void *ptr) = _Block_release_object_default;
static void (*_Block_destructInstance) (const void *aBlock) = _Block_destructInstance_default;


/**************************************************************************
Callback registration from ObjC runtime and CoreFoundation
***************************************************************************/

void _Block_use_RR2(const Block_callbacks_RR *callbacks) {
    _Block_retain_object = callbacks->retain;
    _Block_release_object = callbacks->release;
    _Block_destructInstance = callbacks->destructInstance;
}

/****************************************************************************
Accessors for block descriptor fields
*****************************************************************************/
#if 0
static struct Block_descriptor_1 * _Block_descriptor_1(struct Block_layout *aBlock)
{
    return aBlock->descriptor;
}
#endif

static struct Block_descriptor_2 * _Block_descriptor_2(struct Block_layout *aBlock)
{
    if (! (aBlock->flags & BLOCK_HAS_COPY_DISPOSE)) return NULL;
    uint8_t *desc = (uint8_t *)aBlock->descriptor;
    desc += sizeof(struct Block_descriptor_1);
    return (struct Block_descriptor_2 *)desc;
}

static struct Block_descriptor_3 * _Block_descriptor_3(struct Block_layout *aBlock)
{
    if (! (aBlock->flags & BLOCK_HAS_SIGNATURE)) return NULL;
    uint8_t *desc = (uint8_t *)aBlock->descriptor;
    desc += sizeof(struct Block_descriptor_1);
    if (aBlock->flags & BLOCK_HAS_COPY_DISPOSE) {
        desc += sizeof(struct Block_descriptor_2);
    }
    return (struct Block_descriptor_3 *)desc;
}

static void _Block_call_copy_helper(void *result, struct Block_layout *aBlock)
{
    struct Block_descriptor_2 *desc = _Block_descriptor_2(aBlock);
    if (!desc) return;

    (*desc->copy)(result, aBlock); // do fixup
}

static void _Block_call_dispose_helper(struct Block_layout *aBlock)
{
    struct Block_descriptor_2 *desc = _Block_descriptor_2(aBlock);
    if (!desc) return;

    (*desc->dispose)(aBlock);
}

/*******************************************************************************
Internal Support routines for copying
********************************************************************************/

#if !TARGET_OS_WIN32
#pragma mark Copy/Release support
#endif

// Copy, or bump refcount, of a block.  If really copying, call the copy helper if present.
// 拷贝 block，
// 如果原来就在堆上，就将引用计数加 1;
// 如果原来在栈上，会拷贝到堆上，引用计数初始化为 1，并且会调用 copy helper 方法（如果存在的话）；
// 如果 block 在全局区，不用加引用计数，也不用拷贝，直接返回 block 本身
// 参数 arg 就是 Block_layout 对象，
// 返回值是拷贝后的 block 的地址
void *_Block_copy(const void *arg) {
    struct Block_layout *aBlock;

    // 如果 arg 为 NULL，直接返回 NULL
    if (!arg) return NULL;
    
    // The following would be better done as a switch statement
    // 强转为 Block_layout 类型
    aBlock = (struct Block_layout *)arg;
    // 如果现在已经在堆上
    if (aBlock->flags & BLOCK_NEEDS_FREE) {
        // latches on high
        // 就只将引用计数加 1
        latching_incr_int(&aBlock->flags);
        return aBlock;
    }
    // 如果 block 在全局区，不用加引用计数，也不用拷贝，直接返回 block 本身
    else if (aBlock->flags & BLOCK_IS_GLOBAL) {
        return aBlock;
    }
    else {
        // Its a stack block.  Make a copy.
        // block 现在在栈上，现在需要将其拷贝到堆上
        // 在堆上重新开辟一块和 aBlock 相同大小的内存
        struct Block_layout *result =
            (struct Block_layout *)malloc(aBlock->descriptor->size);
        // 开辟失败，返回 NULL
        if (!result) return NULL;
        // 将 aBlock 内存上的数据全部移到新开辟的 result 上
        memmove(result, aBlock, aBlock->descriptor->size); // bitcopy first
#if __has_feature(ptrauth_calls)
        // Resign the invoke pointer as it uses address authentication.
        result->invoke = aBlock->invoke;
#endif
        // reset refcount
        // 将 flags 中的 BLOCK_REFCOUNT_MASK 和 BLOCK_DEALLOCATING 部分的位全部清为 0
        result->flags &= ~(BLOCK_REFCOUNT_MASK|BLOCK_DEALLOCATING);    // XXX not needed
        // 将 result 标记位在堆上，需要手动释放；并且引用计数初始化为 1
        result->flags |= BLOCK_NEEDS_FREE | 2;  // logical refcount 1
        // copy 方法中会调用做拷贝成员变量的工作
        _Block_call_copy_helper(result, aBlock);
        // Set isa last so memory analysis tools see a fully-initialized object.
        // isa 指向 _NSConcreteMallocBlock
        result->isa = _NSConcreteMallocBlock;
        return result;
    }
}


// Runtime entry points for maintaining the sharing knowledge of byref data blocks.

// A closure has been copied and its fixup routine is asking us to fix up the reference to the shared byref data
// Closures that aren't copied must still work, so everyone always accesses variables after dereferencing the forwarding ptr.
// We ask if the byref pointer that we know about has already been copied to the heap, and if so, increment and return it.
// Otherwise we need to copy it and update the stack forwarding pointer

static struct Block_byref *_Block_byref_copy(const void *arg) {
    struct Block_byref *src = (struct Block_byref *)arg;

    if ((src->forwarding->flags & BLOCK_REFCOUNT_MASK) == 0) {
        // src points to stack
        struct Block_byref *copy = (struct Block_byref *)malloc(src->size);
        copy->isa = NULL;
        // byref value 4 is logical refcount of 2: one for caller, one for stack
        copy->flags = src->flags | BLOCK_BYREF_NEEDS_FREE | 4;
        copy->forwarding = copy; // patch heap copy to point to itself
        src->forwarding = copy;  // patch stack to point to heap copy
        copy->size = src->size;

        if (src->flags & BLOCK_BYREF_HAS_COPY_DISPOSE) {
            // Trust copy helper to copy everything of interest
            // If more than one field shows up in a byref block this is wrong XXX
            struct Block_byref_2 *src2 = (struct Block_byref_2 *)(src+1);
            struct Block_byref_2 *copy2 = (struct Block_byref_2 *)(copy+1);
            copy2->byref_keep = src2->byref_keep;
            copy2->byref_destroy = src2->byref_destroy;

            if (src->flags & BLOCK_BYREF_LAYOUT_EXTENDED) {
                struct Block_byref_3 *src3 = (struct Block_byref_3 *)(src2+1);
                struct Block_byref_3 *copy3 = (struct Block_byref_3*)(copy2+1);
                copy3->layout = src3->layout;
            }
            (*src2->byref_keep)(copy, src);
        }
        else {
            // Bitwise copy.
            // This copy includes Block_byref_3, if any.
            memmove(copy+1, src+1, src->size - sizeof(*src));
        }
    }
    // already copied to heap
    else if ((src->forwarding->flags & BLOCK_BYREF_NEEDS_FREE) == BLOCK_BYREF_NEEDS_FREE) {
        latching_incr_int(&src->forwarding->flags);
    }
    
    return src->forwarding;
}


static void _Block_byref_release(const void *arg) {
    struct Block_byref *byref = (struct Block_byref *)arg;

    // dereference the forwarding pointer since the compiler isn't doing this anymore (ever?)
    byref = byref->forwarding;
    
    if (byref->flags & BLOCK_BYREF_NEEDS_FREE) {
        int32_t refcount = byref->flags & BLOCK_REFCOUNT_MASK;
        os_assert(refcount);
        if (latching_decr_int_should_deallocate(&byref->flags)) {
            if (byref->flags & BLOCK_BYREF_HAS_COPY_DISPOSE) {
                struct Block_byref_2 *byref2 = (struct Block_byref_2 *)(byref+1);
                (*byref2->byref_destroy)(byref);
            }
            free(byref);
        }
    }
}


/************************************************************
 *
 * API supporting SPI
 * _Block_copy, _Block_release, and (old) _Block_destroy
 *  API - Application Programming Interface
 * API 和 SPI 都是相对的概念，他们的差别只在语义上，API 直接被应用开发人员使用，SPI 被框架扩张人员使用
 ***********************************************************/

#if !TARGET_OS_WIN32
#pragma mark SPI/API
#endif


// API entry point to release a copied Block
// 对 block 做 release 操作。
// block 在堆上，才需要 release，在全局区和栈区都不需要 release.
// 先将引用计数减 1，如果引用计数减到了 0，就将 block 销毁
void _Block_release(const void *arg) {
    struct Block_layout *aBlock = (struct Block_layout *)arg;
    // 如果 block == nil
    if (!aBlock) return;
    // 如果 block 在全局区
    if (aBlock->flags & BLOCK_IS_GLOBAL) return;
    // block 不在堆上
    if (! (aBlock->flags & BLOCK_NEEDS_FREE)) return;

    // 引用计数减 1，如果引用计数减到了 0，会返回 true，表示 block 需要被销毁
    if (latching_decr_int_should_deallocate(&aBlock->flags)) {
        // 调用 block 的 dispose helper，dispose helper 方法中会做诸如销毁 byref 等操作
        _Block_call_dispose_helper(aBlock);
        // _Block_destructInstance 啥也不干，函数体是空的
        _Block_destructInstance(aBlock);
        free(aBlock);
    }
}

// 尝试 retain block。当 block 不是处于 dealloc 时，引用计数加 1
// 返回值是是否成功，只有在 block 处于 deallocating 时，才会失败
bool _Block_tryRetain(const void *arg) {
    struct Block_layout *aBlock = (struct Block_layout *)arg;
    return latching_incr_int_not_deallocating(&aBlock->flags);
}

// 判断 block 是否处于 deallocating 状态
bool _Block_isDeallocating(const void *arg) {
    struct Block_layout *aBlock = (struct Block_layout *)arg;
    return (aBlock->flags & BLOCK_DEALLOCATING) != 0;
}


/************************************************************
 *
 * SPI used by other layers
 *
 ***********************************************************/
// 取得 block 的完整大小
size_t Block_size(void *aBlock) {
    return ((struct Block_layout *)aBlock)->descriptor->size;
}

// 如果 block 的返回值在栈上，则返回 TRUE，反之返回 FALSE
bool _Block_use_stret(void *aBlock) {
    struct Block_layout *layout = (struct Block_layout *)aBlock;

    // block 的 flag 有 BLOCK_HAS_SIGNATURE 和 BLOCK_USE_STRET，才会返回 TRUE
    int requiredFlags = BLOCK_HAS_SIGNATURE | BLOCK_USE_STRET;
    return (layout->flags & requiredFlags) == requiredFlags;
}

// Checks for a valid signature, not merely the BLOCK_HAS_SIGNATURE bit.
// 判断 block 是否有签名，不判断 BLOCK_HAS_SIGNATURE，而是通过直接取签名字符串来确定存在与否
bool _Block_has_signature(void *aBlock) {
    return _Block_signature(aBlock) ? true : false;
}

// 取得 block 的签名字符串，可能是 NULL
const char * _Block_signature(void *aBlock)
{
    struct Block_layout *layout = (struct Block_layout *)aBlock;
    struct Block_descriptor_3 *desc3 = _Block_descriptor_3(layout);
    // 如果没有 desc3，则一定没有签名，返回 NULL
    if (!desc3) return NULL;

    return desc3->signature;
}

const char * _Block_layout(void *aBlock)
{
    // Don't return extended layout to callers expecting old GC layout
    struct Block_layout *layout = (struct Block_layout *)aBlock;
    if (layout->flags & BLOCK_HAS_EXTENDED_LAYOUT) return NULL;

    struct Block_descriptor_3 *desc3 = _Block_descriptor_3(layout);
    if (!desc3) return NULL;

    return desc3->layout;
}

const char * _Block_extended_layout(void *aBlock)
{
    // Don't return old GC layout to callers expecting extended layout
    struct Block_layout *layout = (struct Block_layout *)aBlock;
    if (! (layout->flags & BLOCK_HAS_EXTENDED_LAYOUT)) return NULL;

    struct Block_descriptor_3 *desc3 = _Block_descriptor_3(layout);
    if (!desc3) return NULL;

    // Return empty string (all non-object bytes) instead of NULL 
    // so callers can distinguish "empty layout" from "no layout".
    if (!desc3->layout) return "";
    else return desc3->layout;
}

#if !TARGET_OS_WIN32
#pragma mark Compiler SPI entry points
#endif

    
/*******************************************************

Entry points used by the compiler - the real API!


A Block can reference four different kinds of things that require help when the Block is copied to the heap.
1) C++ stack based objects
2) References to Objective-C objects
3) Other Blocks
4) __block variables

In these cases helper functions are synthesized by the compiler for use in Block_copy and Block_release, called the copy and dispose helpers.  The copy helper emits a call to the C++ const copy constructor for C++ stack based objects and for the rest calls into the runtime support function _Block_object_assign.  The dispose helper has a call to the C++ destructor for case 1 and a call into _Block_object_dispose for the rest.

The flags parameter of _Block_object_assign and _Block_object_dispose is set to
    * BLOCK_FIELD_IS_OBJECT (3), for the case of an Objective-C Object,
    * BLOCK_FIELD_IS_BLOCK (7), for the case of another Block, and
    * BLOCK_FIELD_IS_BYREF (8), for the case of a __block variable.
If the __block variable is marked weak the compiler also or's in BLOCK_FIELD_IS_WEAK (16)

So the Block copy/dispose helpers should only ever generate the four flag values of 3, 7, 8, and 24.

When  a __block variable is either a C++ object, an Objective-C object, or another Block then the compiler also generates copy/dispose helper functions.  Similarly to the Block copy helper, the "__block" copy helper (formerly and still a.k.a. "byref" copy helper) will do a C++ copy constructor (not a const one though!) and the dispose helper will do the destructor.  And similarly the helpers will call into the same two support functions with the same values for objects and Blocks with the additional BLOCK_BYREF_CALLER (128) bit of information supplied.

So the __block copy/dispose helpers will generate flag values of 3 or 7 for objects and Blocks respectively, with BLOCK_FIELD_IS_WEAK (16) or'ed as appropriate and always 128 or'd in, for the following set of possibilities:
    __block id                   128+3       (0x83)
    __block (^Block)             128+7       (0x87)
    __weak __block id            128+3+16    (0x93)
    __weak __block (^Block)      128+7+16    (0x97)
        

 
 这是给编译器提供的 API
 
 block 可以引用 4 种不同的类型的对象，当 block 被拷贝到堆上时，需要 help，即帮助拷贝一些东西。
 1）基于 C++ 栈的对象
 2）Objective-C 对象
 3）其他 Block
 4）被 __block 修饰的变量
 
 block 的 helper 函数是编译器合成的（比如编译器写的 __main_block_copy_1() 函数），它们被用在 _Block_copy() 函数和 _Block_release() 函数中。copy helper 对基于 C++ 栈的对象调用调用 C++ 常拷贝构造函数，对其他三种对象调用 _Block_object_assign 函数。 dispose helper 对基于 C++ 栈的对象调用析构函数，对其他的三种调用 _Block_object_dispose 函数。
 
 _Block_object_assign 和 _Block_object_dispose 函数的第三个参数 flags 有可能是：
 1）BLOCK_FIELD_IS_OBJECT(3) 表示是一个对象
 2）BLOCK_FIELD_IS_BLOCK(7) 表示是一个 block
 3）BLOCK_FIELD_IS_BYREF(8) 表示是一个 byref，一个被 __block 修饰的变量；如果 __block 变量还被 __weak 修饰，则还会加上 BLOCK_FIELD_IS_WEAK(16)
 
 所以 block 的 copy/dispose helper 只会传入四种值：3，7，8，24
 
 上述的4种类型的对象都会由编译器合成 copy/dispose helper 函数，和 block 的 helper 函数类似，byref 的 copy helper 将会调用 C++ 的拷贝构造函数（不是常拷贝构造），dispose helper 则会调用析构函数。还一样的是，helpers 将会一样调用进两个支持函数中，对于对象和 block，参数值是一样的，都另外附带上 BLOCK_BYREF_CALLER (128) bit 的信息。
 
 所以 __block copy/dispose helper 函数生成 flag 的值为：对象是 3，block 是 7，带 __weak 的是 16，并且一直有 128，有下面这么几种组合：
    __block id                   128+3       (0x83)
    __block (^Block)             128+7       (0x87)
    __weak __block id            128+3+16    (0x93)
    __weak __block (^Block)      128+7+16    (0x97)
 
********************************************************/

//
// When Blocks or Block_byrefs hold objects then their copy routine helpers use this entry point
// to do the assignment.
// 当 block 和 byref 要持有对象时，它们的 copy helper 函数会调用这个函数来完成 assignment，
// 参数 destAddr 其实是一个二级指针，指向真正的目标指针
void _Block_object_assign(void *destArg, const void *object, const int flags) {
    const void **dest = (const void **)destArg;
    switch (os_assumes(flags & BLOCK_ALL_COPY_DISPOSE_FLAGS)) {
      case BLOCK_FIELD_IS_OBJECT:
        /*******
        id object = ...;
        [^{ object; } copy];
        ********/
        // 默认什么都不干，但在 _Block_use_RR() 中会被 Objc runtime 或者 CoreFoundation 设置 retain 函数，
        // 其中，可能会与 runtime 建立联系，操作对象的引用计数什么的
        _Block_retain_object(object);
        // 使 dest 指向的目标指针指向 object
        *dest = object;
        break;

      case BLOCK_FIELD_IS_BLOCK:
        /*******
        void (^object)(void) = ...;
        [^{ object; } copy];
        ********/

       // 使 dest 指向的拷贝到堆上object
        *dest = _Block_copy(object);
        break;
    
      case BLOCK_FIELD_IS_BYREF | BLOCK_FIELD_IS_WEAK:
      case BLOCK_FIELD_IS_BYREF:
        /*******
         // copy the onstack __block container to the heap
         // Note this __weak is old GC-weak/MRC-unretained.
         // ARC-style __weak is handled by the copy helper directly.
         __block ... x;
         __weak __block ... x;
         [^{ x; } copy];
         ********/
         // 使 dest 指向的拷贝到堆上的byref
        *dest = _Block_byref_copy(object);
        break;
        
      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_OBJECT:
      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_BLOCK:
        /*******
         // copy the actual field held in the __block container
         // Note this is MRC unretained __block only. 
         // ARC retained __block is handled by the copy helper directly.
         __block id object;
         __block void (^object)(void);
         [^{ object; } copy];
         ********/

        // 使 dest 指向的目标指针指向 object
        *dest = object;
        break;

      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_OBJECT | BLOCK_FIELD_IS_WEAK:
      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_BLOCK  | BLOCK_FIELD_IS_WEAK:
        /*******
         // copy the actual field held in the __block container
         // Note this __weak is old GC-weak/MRC-unretained.
         // ARC-style __weak is handled by the copy helper directly.
         __weak __block id object;
         __weak __block void (^object)(void);
         [^{ object; } copy];
         ********/

        // 使 dest 指向的目标指针指向 object
        *dest = object;
        break;

      default:
        break;
    }
}

// When Blocks or Block_byrefs hold objects their destroy helper routines call this entry point
// to help dispose of the contents
// 当 block 和 byref 要 dispose 对象时，它们的 dispose helper 会调用这个函数
void _Block_object_dispose(const void *object, const int flags) {
    switch (os_assumes(flags & BLOCK_ALL_COPY_DISPOSE_FLAGS)) {
      // 如果是 byref
      case BLOCK_FIELD_IS_BYREF | BLOCK_FIELD_IS_WEAK:
      case BLOCK_FIELD_IS_BYREF:
        // get rid of the __block data structure held in a Block
        // 对 byref 对象做 release 操作
        _Block_byref_release(object);
        break;
      // 如果是 block
      case BLOCK_FIELD_IS_BLOCK:
        // 对 block 做 release 操作
        _Block_release(object);
        break;
      // 如果是对象
      case BLOCK_FIELD_IS_OBJECT:
        // 默认啥也不干，但在 _Block_use_RR() 中可能会被 Objc runtime 或者 CoreFoundation 设置一个 release 函数，里面可能会涉及到 runtime 的引用计数
        _Block_release_object(object);
        break;
      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_OBJECT:
      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_BLOCK:
      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_OBJECT | BLOCK_FIELD_IS_WEAK:
      case BLOCK_BYREF_CALLER | BLOCK_FIELD_IS_BLOCK  | BLOCK_FIELD_IS_WEAK:
        break;
      default:
        break;
    }
}


// Workaround for <rdar://26015603> dylib with no __DATA segment fails to rebase
__attribute__((used))
static int let_there_be_data = 42;
