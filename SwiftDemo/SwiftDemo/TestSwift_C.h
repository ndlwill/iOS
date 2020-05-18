//
//  TestSwift_C.h
//  SwiftDemo
//
//  Created by youdone-ndl on 2020/5/18.
//  Copyright © 2020 dzcx. All rights reserved.
//

#ifndef TestSwift_C_h
#define TestSwift_C_h

#include <stdio.h>

typedef struct {
    void *info;
    const void *(*retain)(const void *info);
} Context;

void abcPrint(Context *info, void (*callback)(void *));
    
// c 的实现文件
void abcPrint(Context *info, void (*callback)(void *)){
    (*callback)(info->info);
    printf("==abcPrint call==\n");
}

#endif /* TestSwift_C_h */
