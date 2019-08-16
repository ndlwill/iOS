//
//  BinaryTree.h
//  NDL_Category
//
//  Created by dzcx on 2019/3/7.
//  Copyright © 2019 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BinaryTreeNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface BinaryTree : NSObject

// recursion 递归
// non-recursive 非递归

// 二叉查找树（Binary Search Tree） 即二叉搜索树，二叉排序树
// 创建二叉排序树 二叉排序树：左节点值全部小于根节点值，右节点值全部大于根节点值
// return 二叉树根节点
+ (BinaryTreeNode *)createBinarySortTreeWithValues:(NSArray *)valueArray;

+ (BinaryTreeNode *)nodeAtIndex:(NSInteger)index inRootNode:(BinaryTreeNode *)rootNode;
+ (void)preOrderTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;
+ (void)inOrderTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;
+ (void)postOrderTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;
// non-recursive
+ (void)BFSTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;

+ (void)DFSNonRecursiveTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;
+ (void)DFSRecursionTraversalTree:(BinaryTreeNode *)rootNode handler:(void(^)(BinaryTreeNode *node))handler;

+ (NSInteger)depthOfTree:(BinaryTreeNode *)rootNode;

+ (NSInteger)widthOfTree:(BinaryTreeNode *)rootNode;

+ (NSInteger)numberOfNodesInTree:(BinaryTreeNode *)rootNode;

+ (NSInteger)numberOfNodesOnLevel:(NSInteger)level inTree:(BinaryTreeNode *)rootNode;

+ (NSInteger)numberOfLeadNodesInTree:(BinaryTreeNode *)rootNode;

+ (NSInteger)diameterOfTree:(BinaryTreeNode *)rootNode;

@end

NS_ASSUME_NONNULL_END

/*
 查找树:
 AVL 树：平衡二叉搜索树。它的平衡度也最好，左右高度差可以保证在「-1，0，1」，基于它的平衡性，它的查询时间复杂度可以保证是 O(log(n))。但每个节点要额外保存一个平衡值，或者说是高度差。这种树是二叉树的经典应用，现在最主要是出现在教科书中。AVL 的平衡算法比较麻烦，需要左右两种 rotate 交替使用。
 红黑树：平衡二叉搜索树。也就是说，如果从高度差来说，红黑树是大于 AVL 的，其实也就代表着它的实际查询时间（最坏情况）略逊于 AVL 的。数学证明红黑树的最大深度是 2log(n+1)。其实最差情况它从根到叶子的最长路可以是最短路的两倍，但也不是很差，所以它的查询时间复杂度也是 O(log(n))。从实现角度来说，保存红黑状态，每个节点只需要一位二进制，也就是一个 bit。红黑树是工业界最主要使用的二叉搜索平衡树：Java 用它来实现 TreeMap；C++ 用它来实现 std::set/map/multimap；著名的 Linux 进程调度 Completely Fair Scheduler，用红黑树管理进程控制块；epoll 在内核中的实现，用红黑树管理事件块；nginx 中，用红黑树管理 timer。
 
 以上是平衡二叉搜索树，平衡二叉搜索树的问题在于每次插入和删除都有很大可能需要进行重新平衡，数据就要不停的搬来搬去，在内存中这问题不是特别大，可如果在磁盘中，这个开销可能就大了。
 
 二叉搜索树：查找的时间复杂度是 O(log(n))，最坏情况下的时间复杂度是 O(n)。二叉搜索树有一个缺点就是，树的结构是无法预料的，随意性很大，它只与节点的值和插入的顺序有关系，往往得到的是一个不平衡的二叉树。在最坏的情况下，可能得到的是一个单支二叉树，其高度和节点数相同，相当于一个单链表，对其正常的时间复杂度有 O(log(n)) 变成了 O(n)。
 B/B+ 树：N 叉平衡树。每个节点可以有更多的孩子，新的值可以插在已有的节点里，而不需要改变树的高度，从而大量减少重新平衡和数据迁移的次数，这非常适合做数据库索引这种需要持久化在磁盘，同时需要大量查询和插入操作的应用。
 
 以上几种树都是有序的，如果你采用合适的算法遍历整个数，可以得到一个有序的列表。这也是为什么如果有数据库索引的情况下，你 order by 你索引的值，就会速度特别快，因为它并没有给你真的排序，只是遍历树而已。
 
 Trie 树：Trie 树并不是平衡树，也不一定非要有序。查询和插入时间复杂度都是 O(n)。是一种以空间换时间的方法。当节点树较多的时候，Trie 树占用的内存会很大。它主要用于前缀匹配，比如字符串。如果字符串长度是固定或者说有限的，那么 Trie 树的深度是可控制的，你可以得到很好的搜索效果，而且插入新数据后不用平衡。比如 IP 选路，也是前缀匹配，一定程度会用到 Trie 树
 */
