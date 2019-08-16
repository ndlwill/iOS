//
//  TwoWayLinkedList.h
//  NDL_Category
//
//  Created by dzcx on 2018/11/29.
//  Copyright © 2018 ndl. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Node;

NS_ASSUME_NONNULL_BEGIN

// 双向链表 (首节点的前驱指针和尾节点的后继指针均指向空地址)
@interface TwoWayLinkedList : NSObject

+ (instancetype)twoWayLinkedList;

- (BOOL)isEmpty;

- (void)printAllNode;

- (void)addNodeData:(id)nodeData;

- (void)removeNodeData:(id)nodeData;
- (void)removeNode:(Node *)node;





@end

NS_ASSUME_NONNULL_END

/*
 在单链表的第一个结点之前附设一个结点，它没有直接前驱，称之为头结点
 
 MARK:单链表翻转
 输入: 1->2->3->4->5->NULL
 输出: 5->4->3->2->1->NULL
 递归算法实现：
 ListNode* reverseList(ListNode* head)
 {
 if(NULL == head || NULL == head->next)
 return head;
 ListNode * p = reverseList(head->next);
 head->next->next = head;
 head->next = NULL;
 
 return p;
 }
 
 非递归算法实现：
 在遍历列表时，将当前节点的 next 指针改为指向前一个元素。由于节点没有引用其上一个节点，因此必须事先存储其前一个元素。在更改引用之前，还需要另一个指针来存储下一个节点。不要忘记在最后返回新的头引用
 public ListNode reverseList(ListNode head) {
 ListNode prev = null;
 ListNode curr = head;
 while (curr != null) {
 ListNode nextTemp = curr.next;
 curr.next = prev;
 prev = curr;
 curr = nextTemp;
 }
 return prev;
 }
 
 MARK:单链表判断是否有环
 1.存一个所有 Node 地址的 Hash 表，从头开始遍历，将 Node 存到 Hash 表中，如果出现了重复，则说明链表有环
 2.双指针（也叫快慢指针），使用两个指针遍历链表，一个指针一次走一步，另一个一次走两步，如果链表有环，两个指针必然相遇
 双指针算法实现：
 
 bool hasCycle(ListNode *head) {
 if (head == nullptr) {
 return false;
 }
 ListNode *fast,*slow;
 slow = head;
 fast = head->next;
 while (fast && fast->next) {
 slow = slow->next;
 fast = fast->next->next;
 if (slow == fast) {
 return true;
 }
 }
 return false;
 }
 
 MARK:单链表找中间节点
 用快慢指针法，当快指针走到链表结尾时，慢指针刚好走到链表的中间：
 
 ListNode* middleNode(ListNode* head) {
 ListNode *slow = head;
 ListNode *fast = head;
 while (fast && fast->next) {
 slow = slow->next;
 fast = fast->next->next;
 }
 
 return slow;
 }
 */
