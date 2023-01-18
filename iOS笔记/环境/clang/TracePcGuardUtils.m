//
//  TracePcGuardUtils.m
//  TestSwift
//
//  Created by youdun on 2022/12/1.
//

#import "TracePcGuardUtils.h"
#import <dlfcn.h>
#import <libkern/OSAtomic.h>

// 原子队列，其目的是保证写入安全，线程安全
static OSQueueHead queue = OS_ATOMIC_QUEUE_INIT;
// 定义符号结构体，以链表的形式
typedef struct {
    void *pc;
    void *next;
} SymbolNode;


// This callback is inserted by the compiler as a module constructor
// into every DSO. 'start' and 'stop' correspond to the
// beginning and end of the section with the guards for the entire
// binary (executable or DSO). The callback will be called at least
// once per DSO and may be called multiple times with the same parameters.
void __sanitizer_cov_trace_pc_guard_init(uint32_t *start, uint32_t *stop) {
    static uint64_t N;  // Counter for the guards.
    if (start == stop || *start) return;  // Initialize only once.
    printf("INIT: %p %p\n", start, stop);
    for (uint32_t *x = start; x < stop; x++) {
        *x = (uint32_t)++N;  // Guards should start from 1.
    }
}

/**
 hook方法、函数、以及block调用，用于捕捉符号
 是在多线程进行的，这个方法中只存储pc，以链表的形式
 guard是一个哨兵，告诉我们是第几个被调用的
 */
// This callback is inserted by the compiler on every edge in the
// control flow (some optimizations apply).
// Typically, the compiler will emit the code like this:
//    if(*guard)
//      __sanitizer_cov_trace_pc_guard(guard);
// But for large functions it will emit a simple call:
//    __sanitizer_cov_trace_pc_guard(guard);
void __sanitizer_cov_trace_pc_guard(uint32_t *guard) {// 捕获所有的启动时刻的符号
    // 将load方法过滤掉了，所以需要注释掉
//    if (!*guard) return;  // Duplicate the guard check.
    
    // If you set *guard to 0 this code will not be called again for this edge.
    // Now you can get the PC and do whatever you want:
    //   store it somewhere or symbolize it and print right away.
    // The values of `*guard` are as you set them in
    // __sanitizer_cov_trace_pc_guard_init and so you can make them consecutive
    // and use them to dereference an array or a bit vector.
    /**
     - PC: 当前函数返回上一个调用的地址
     - 0: 当前这个函数地址，即当前函数的返回地址
     - 1: 当前函数调用者的地址，即上一个函数的返回地址
     */
    void *PC = __builtin_return_address(0);
    SymbolNode *node = malloc(sizeof(SymbolNode));
    *node = (SymbolNode){PC, NULL};
    
    /**
     加入队列。
     符号的访问不是通过下标访问，是通过链表的next指针。
     所以需要借用offsetof（结构体类型，下一个的地址即next）
     */
    OSAtomicEnqueue(&queue, node, offsetof(SymbolNode, next));
    // offsetof 求某个结构体的特定成员在结构体里面的偏移量
}

@implementation TracePcGuardUtils

+ (void)generateOrderFile {
    NSMutableArray<NSString *> *symbolNames = [NSMutableArray array];
            
    while (YES) {
        SymbolNode *node = OSAtomicDequeue(&queue, offsetof(SymbolNode, next));
        if (node == NULL) break;
        
        Dl_info info;
        dladdr(node->pc, &info);
        NSLog(@"dli_sname = %s", info.dli_sname);
        
        if (info.dli_sname) {
            // 判断是不是OC方法，如果不是，需要加下划线存储。反之，则直接存储
            NSString *name = @(info.dli_sname);
            BOOL isObjcMethod = [name hasPrefix:@"-["] || [name hasPrefix:@"+["];
            /**
             非oc方法，一般会加上一个'_'，这是由于UNIX下的C语言规定全局的变量和函数经过编译后会在符号前加下划线从而减少多种语言目标文件之间的符号冲突的概率；
             可以通过编译选项'-fleading-underscore'开启、'-fno-leading-underscore'来关闭
             */
            NSString *symbolName = isObjcMethod ? name : [@"_" stringByAppendingString:name];
            [symbolNames addObject:symbolName];
        }
    }
    NSLog(@"==========symbolNames==========");
    NSLog(@"symbolNames = %@", symbolNames);
            
    if (symbolNames.count == 0) {
        return;
    }
            
    // 取反（队列的存储是反序的）
    NSEnumerator *emt = [symbolNames reverseObjectEnumerator];
            
    // 去重（由于一个函数可能执行多次，__sanitizer_cov_trace_pc_guard会执行多次）
    NSMutableArray<NSString *> *funcs = [NSMutableArray arrayWithCapacity:symbolNames.count];
            
    NSString *name;
    while (name = [emt nextObject]) {
        if (![funcs containsObject:name]) {
            [funcs addObject:name];
        }
    }
            
    NSString *excludedFunc = [NSString stringWithFormat:@"%s", __FUNCTION__];
    // 去掉自己
    [funcs removeObject:excludedFunc];
            
    NSString *funcStr = [funcs componentsJoinedByString:@"\n"];
    NSLog(@"funcStr = %@", funcStr);
    NSString *filePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"result.order"];
    NSLog(@"filePath = %@", filePath);
    NSData *fileContents = [funcStr dataUsingEncoding:NSUTF8StringEncoding];
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:fileContents attributes:nil];
}

@end
