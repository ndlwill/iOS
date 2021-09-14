//
//  TestDataStructures.m
//  NDL_Category
//
//  Created by youdone-ndl on 2020/12/14.
//  Copyright © 2020 ndl. All rights reserved.
//

#import "TestDataStructures.h"

// MARK: DataStructures
/**
 栈:
 栈是限定仅在表尾进行插入和删除操作的线性表。我们把允许插入和删除的一端称为栈顶，另一端称为栈底，不含任何数据元素的栈称为空栈
 栈是一种具有后进先出的数据结构，又称为后进先出的线性表。栈的应用—递归
 
 队列:
 队列是只允许在一端进行插入操作、而在另一端进行删除操作的线性表。允许插入的一端称为队尾，允许删除的一端称为队头。
 队列是一种先进先出的数据结构，又称为先进先出的线性表。
 
 用两个栈模拟一个队列:
 思路：准备2个栈：inStack，outStack；入队时，push到inStack中；出队时，如果outStack为空，将inStack所有元素逐一弹出，push到outStack，outStack弹出栈顶元素；如果outStack不为空，outStack弹出栈顶元素。
 */

@implementation TestDataStructures

@end
