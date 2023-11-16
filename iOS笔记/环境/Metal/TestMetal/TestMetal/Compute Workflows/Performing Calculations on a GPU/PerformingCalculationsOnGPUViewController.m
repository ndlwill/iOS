//
//  PerformingCalculationsOnGPUViewController.m
//  TestMetal
//
//  Created by youdun on 2023/8/24.
//

#import "PerformingCalculationsOnGPUViewController.h"
#import <Metal/Metal.h>
#import "MetalAdder.h"

void add_arrays(const float* inA,
                const float* inB,
                float* result,
                int length)
{
    for (int index = 0; index < length ; index++)
    {
        result[index] = inA[index] + inB[index];
    }
}

@interface PerformingCalculationsOnGPUViewController ()

@end

// MARK: - for macOS
@implementation PerformingCalculationsOnGPUViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    id<MTLDevice> device = MTLCreateSystemDefaultDevice();
    
    if ([device supportsFeatureSet:MTLFeatureSet_iOS_GPUFamily4_v1]) {
        MetalAdder *adder = [[MetalAdder alloc] initWithDevice:device];
        [adder prepareData];
        [adder sendComputeCommand];
        NSLog(@"Execution finished");
    } else {
        NSLog(@"Dispatch Threads with Non-Uniform Threadgroup Size is only supported on MTLGPUFamilyApple4 and later.");
    }
}

@end
