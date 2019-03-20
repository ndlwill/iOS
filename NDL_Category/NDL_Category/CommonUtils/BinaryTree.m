//
//  BinaryTree.m
//  NDL_Category
//
//  Created by dzcx on 2019/3/7.
//  Copyright © 2019 ndl. All rights reserved.
//

#import "BinaryTree.h"

@implementation BinaryTree

+ (BinaryTreeNode *)createBinarySortTreeWithValues:(NSArray *)valueArray
{
    BinaryTreeNode *rootNode = nil;
    for (NSInteger i = 0; i < valueArray.count; i++) {
        NSInteger value = [((NSNumber *)valueArray[i]) integerValue];
        rootNode = [BinaryTree addNode:rootNode value:value];
    }
    return rootNode;
}

/*
              50
           /      \
          /        \
         25         75
       /   \      /    \
      /     \    /      \
    10      28  60      80
   /  \       \           \
  /    \       \           \
 8      12     30          100
 */

// 返回rootNode
/*
 eg:
 value: 50, 25, 75, 28
 
 add 28
 
 28 < rootNode.value(50)   28 > rootNode.leftNode.value(25)
 add-1: rootNode.leftNode = (add-2: rootNode.leftNode.rightNode value = 28 ,return rootNode.leftNode), return rootNode
 */
+ (BinaryTreeNode *)addNode:(BinaryTreeNode *)node value:(NSInteger)value
{
    if (!node) {
        // 根节点
        node = [BinaryTreeNode new];
        node.value = value;
        return node;
    }
    
    if (value <= node.value) {
        // 值小于根节点，则插入到左子树
        node.leftNode = [BinaryTree addNode:node.leftNode value:value];// 递归
    } else {
        node.rightNode = [BinaryTree addNode:node.rightNode value:value];
    }
    return node;
}

// 二叉树中某个位置的节点 位置从0开始算
+ (BinaryTreeNode *)nodeAtIndex:(NSInteger)index inRootNode:(BinaryTreeNode *)rootNode
{
    if (!rootNode || index < 0) {
        return nil;
    }

    NSMutableArray *queueArray = [NSMutableArray array];// 数组当成队列
    [queueArray addObject:rootNode];
    while (queueArray.count > 0) {
        BinaryTreeNode *node = queueArray.firstObject;
        if (index == 0) {
            return node;
        }

//        [queueArray removeFirstObject];
        [queueArray removeObjectAtIndex:0];
        index--;

        if (node.leftNode) {
            [queueArray addObject:node.leftNode];
        }
        if (node.rightNode) {
            [queueArray addObject:node.rightNode];
        }
    }
    return nil;
}

// 先序遍历: 先访问根，再遍历左子树，再遍历右子树
/*
 [
 50,
 
 25,
 10,
 8,
 12,
 28,
 30,
 
 75,
 60,
 80,
 100
 ]
 */
+ (void)preOrderTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler
{
    if (rootNode) {
        if (handler) {
            handler(rootNode);
        }
        
        [self preOrderTraversalTree:rootNode.leftNode handler:handler];
        [self preOrderTraversalTree:rootNode.rightNode handler:handler];
    }
}

//中序遍历: 先遍历左子树，再访问根，再遍历右子树  中序遍历得到的序列是一个从小到大排序好的序列
/*
 [
 8,
 10,
 12,
 25,
 28,
 30,
 50,
 60,
 75,
 80,
 100
 ]
 */
+ (void)inOrderTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler
{
    if (rootNode) {
        // (L(看成一个整体树) = (L, M, R), M, R)
        [self inOrderTraversalTree:rootNode.leftNode handler:handler];
        
        if (handler) {
            handler(rootNode);
        }
        
        [self inOrderTraversalTree:rootNode.rightNode handler:handler];
    }
}

// 后序遍历 先遍历左子树，再遍历右子树，再访问根
/*
 [
 8,
 12,
 10,
 30,
 28,
 25,
 60,
 100,
 80,
 75,
 50
 ]
 */
+ (void)postOrderTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler
{
    if (rootNode) {
        [self postOrderTraversalTree:rootNode.leftNode handler:handler];
        [self postOrderTraversalTree:rootNode.rightNode handler:handler];
        
        if (handler) {
            handler(rootNode);
        }
    }
}

// 层次遍历 按照从上到下、从左到右的次序进行遍历。先遍历完一层，再遍历下一层，因此又叫广度优先遍历。需要用到队列，在OC里可以用可变数组来实现
// 层次遍历（广度优先）
// 广度优先遍历: BFS即Breadth(宽度) FirstSearch  广度优先遍历树，需要用到队列（Queue）来存储节点对象,队列的特点就是先进先出
/*
 A(B(D, E(I)), C(F, G, H))
 
 其过程检验来说是对每一层节点依次访问，访问完一层进入下一层，而且每个节点只能访问一次
 结果是：A,B,C,D,E,F,G,H,I
 
 首先将A节点插入队列中，队列中有元素（A）;
 将A节点弹出，同时将A节点的左、右节点依次插入队列，B在队首，C在队尾，（B，C），此时得到A节点；
 继续弹出队首元素，即弹出B，并将B的左、右节点插入队列，C在队首，E在队尾（C,D，E），此时得到B节点；
 继续弹出，即弹出C，并将C节点的左、中、右节点依次插入队列，（D,E,F,G,H），此时得到C节点；
 将D弹出，此时D没有子节点，队列中元素为（E,F,G,H），得到D节点；
 。。。以此类推。。。
 */
// 假设每层(行)节点从左到右访问
+ (void)BFSTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler
{
    if (!rootNode) {
        return;
    }
    
    NSMutableArray<BinaryTreeNode *> *queueArray = [NSMutableArray array];
    [queueArray addObject:rootNode];
    
    while (queueArray.count > 0) {
        BinaryTreeNode *tempNode = queueArray.firstObject;
        if (handler) {
            handler(tempNode);
        }
        
//        [queueArray removeObjectAtIndex:0];
        [queueArray removeFirstObject];
        
        if (tempNode.leftNode) {
            [queueArray addObject:tempNode.leftNode];
        }
        
        if (tempNode.rightNode) {
            [queueArray addObject:tempNode.rightNode];
        }
    }
}


/*
 A(B(D, E(I)), C(F, G, H))
 
 深度优先:英文缩写为DFS即Depth First Search
 其过程简要来说是对每一个可能的分支路径深入到不能再深入为止，而且每个节点只能访问一次
 结果就是：A,B,D,E,I,C,F,G,H.(假设先走子节点的的左侧)
 
 深度优先遍历各个节点，需要使用到栈（Stack）这种数据结构。stack的特点是是先进后出
 ##先往栈中压入右节点，再压左节点，这样出栈就是先左节点后右节点了##
 
 首先将A节点压入栈中，stack（A）;
 将A节点弹出，同时将A的子节点C，B压入栈中，此时B在栈的顶部，stack(B,C)；
 将B节点弹出，同时将B的子节点E，D压入栈中，此时D在栈的顶部，stack（D,E,C）；
 将D节点弹出，没有子节点压入,此时E在栈的顶部，stack（E，C）；
 将E节点弹出，同时将E的子节点I压入，stack（I,C）；
 ...依次往下，最终遍历完成
 
 */
// DFS非递归
+ (void)DFSNonRecursiveTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler
{
    if (!rootNode) {
        return;
    }
    
    NSMutableArray<BinaryTreeNode *> *stackArray = [NSMutableArray array];
    [stackArray addObject:rootNode];
    while (stackArray.count > 0) {
        BinaryTreeNode *tempNode = stackArray.lastObject;
        if (handler) {
            handler(tempNode);
        }
        
        BinaryTreeNode *leftNode = tempNode.leftNode;
        BinaryTreeNode *rightNode = tempNode.rightNode;
        
//        [stackArray removeObjectAtIndex:(stackArray.count - 1)];
        [stackArray removeLastObject];
        
        
        
        if (rightNode) {
            [stackArray addObject:rightNode];
        }
        
        if (leftNode) {
            [stackArray addObject:leftNode];
        }
    }
}

// DFS递归
//+ (void)DFSRecursionTraversalTree:(BinaryTreeNode *)rootNode
//{
//    if (!rootNode) {
//        
//    }
//}


// 二叉树的深度  二叉树的深度定义为：从根节点到叶子结点依次经过的结点形成树的一条路径,最长路径的长度为树的深度
/*
 1）如果根节点为空，则深度为0；
 2）如果左右节点都是空，则深度为1；
 3）递归思想：二叉树的深度=max（左子树的深度，右子树的深度）+ 1
 */
+ (NSInteger)depthOfTree:(BinaryTreeNode *)rootNode
{
    if (!rootNode) {
        return 0;
    }
    
    if (!rootNode.leftNode && !rootNode.rightNode) {
        return 1;
    }
    
    NSInteger leftDepth = [self depthOfTree:rootNode.leftNode];
    NSInteger rightDepth = [self depthOfTree:rootNode.rightNode];
    return MAX(leftDepth, rightDepth) + 1;
}
// test master
@end
