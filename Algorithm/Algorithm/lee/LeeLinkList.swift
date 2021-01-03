//
//  LeeLinkList.swift
//  Algorithm
//
//  Created by 孙虎林 on 2021/1/2.
//

/// 链表相关题目

import Foundation

/// 虚拟头节点
/// 构造链表的思想， tail  ->  tail.next = nil
/// 反转。求指针中点
/// 快慢指针

public class LeeListNode {
    public var val: Int
    public var next: LeeListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}


/// 移除链表元素
/// https://leetcode-cn.com/problems/remove-linked-list-elements/
func removeElements(_ head: LeeListNode?, _ val: Int) -> LeeListNode? {
    guard let _ = head else {
        return nil
    }
    // 虚拟头结点
    let dummpyHead = LeeListNode(0)
    var tail = dummpyHead
    var cur = head
    while cur != nil {
        if let nd = cur, nd.val != val {
            tail.next = cur
            if tail.next != nil {
                tail = tail.next!
            }
        }
        cur = cur?.next
    }
    // 尾节点的next必须要清空，这是个小坑
    tail.next = nil
    // 创建一个虚拟头结点
    return dummpyHead.next
}

/** java 解法
public ListNode removeElements(ListNode head, int val) {
       if (head == null) return null;
       // 哨兵结点
       ListNode newHead = new ListNode(0);
       newHead.next = head;
       
       ListNode pre = newHead;
       ListNode node = newHead.next;

       while(node != null) {
           // 找到了
           if (node.val == val) {
               pre.next = node.next;;
           } else {
               pre = node;
           }
           node = node.next;
       }
       return newHead.next;
   }
 */


/// 两数相加
/// https://leetcode-cn.com/problems/add-two-numbers/
//给出两个 非空 的链表用来表示两个非负的整数。其中，它们各自的位数是按照 逆序 的方式存储的，并且它们的每个节点只能存储 一位 数字。
//如果，我们将这两个数相加起来，则会返回一个新的链表来表示它们的和。
//您可以假设除了数字 0 之外，这两个数都不会以 0 开头。
//输入：(2 -> 4 -> 3) + (5 -> 6 -> 4)
//输出：7 -> 0 -> 8
//原因：342 + 465 = 807

func addTwoNumbers(_ l1: LeeListNode?, _ l2: LeeListNode?) -> LeeListNode? {
    guard let _ = l1 else {
        return l2
    }
    guard let _ = l2 else {
        return l1
    }
    var nd1 = l1
    var nd2 = l2
    let dummpy = LeeListNode(0)
    var tail = dummpy
    
    // 是否近位
    var carray = 0
    /// 只要有一个不为空都要继续遍历
    while nd1 != nil || nd2 != nil {
        let v1 = nd1?.val ?? 0
        let v2 = nd2?.val ?? 0
        let sum = v1 + v2 + carray
        // 更新近位
        carray = sum / 10
        // 个位数 sum % 10
        let newNdValue = LeeListNode(sum % 10)
        tail.next = newNdValue
        tail = tail.next!
        
        nd1 = nd1?.next
        nd2 = nd2?.next
    }
    // 遍历完之后，看最后一个是否有近位
    if carray > 0 {
        tail.next = LeeListNode(1)
        tail = tail.next!
    }
    return dummpy.next
}

/// 找到两个单链表相交的起始节点。
/// https://leetcode-cn.com/problems/intersection-of-two-linked-lists/

/// 先走法
func getIntersectionNode(_ headA: LeeListNode?, _ headB: LeeListNode?) -> LeeListNode? {
    if headA == nil || headB == nil {
        return nil
    }
    var nd1 = headA
    var nd2 = headB
    
    // 先求出各链表长度
    var l1 = 0
    while nd1 != nil {
        l1 += 1
        nd1 = nd1?.next
    }
    
    var l2 = 0
    while nd2 != nil {
        l2 += 1
        nd2 = nd2?.next
    }
    
    // 归位
    nd1 = headA
    nd2 = headB
    
    // l1 先走
    if l1 > l2 {
        let deta = l1 - l2
        var i = 0
        while i < deta {
            i += 1
            nd1 = nd1?.next
        }
    } else {
        // l2 先走
        let deta = l2 - l1
        var i = 0
        while i < deta {
            i += 1
            nd2 = nd2?.next
        }
    }
    // 一起走
    while nd1 != nil && nd2 != nil {
        if nd1?.val == nd2?.val {
            return nd1
        }
        nd1 = nd1?.next
        nd2 = nd2?.next
    }
    return nil
}

/// 3 -> 5 -> 2 -> 1   +     6-> 3 -> 2 -> 1 -> 2 -> 1
/// 6-> 3 -> 2 -> 1 -> 2 -> 1  + 3 -> 5 -> 2 -> 1
/// 拼在一起，长度相等，找到第一个相等的节点
/// 拼接法
func getIntersectionNode2(_ headA: LeeListNode?, _ headB: LeeListNode?) -> LeeListNode? {
    if(headA == nil || headB == nil) {
        return nil
    }
    var pA = headA
    var pB = headB
    while(pA?.val != pB?.val) {
        pA = (pA == nil) ? headB : pA?.next;
        pB = (pB == nil) ? headA : pB?.next;
    }
    return pA;
}

/** java 解法
public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
       ListNode p = headA, q = headB;
       while(p != q){
           p = (p == null) ? headB : p.next;
           q = (q == null) ? headA : q.next;
       }
       return p;
}
 */

/// 分割链表 https://leetcode-cn.com/problems/partition-list/
/// 给你一个链表和一个特定值 x ，请你对链表进行分隔，使得所有小于 x 的节点都出现在大于或等于 x 的节点之前。
/// 你应当保留两个分区中每个节点的初始相对位置。
/// 输入：head = 1->4->3->2->5->2, x = 3
/// 输出：1->2->2->4->3->5
func partition(_ head: LeeListNode?, _ x: Int) -> LeeListNode? {
    let leftH = LeeListNode(0)
    var leftTail = leftH
    
    let rightH = LeeListNode(0)
    var rightTail = rightH
    
    var cur = head
    while cur != nil {
        if let nd = cur {
            if nd.val < x {
                leftTail.next = cur
                leftTail = leftTail.next!
            } else {
                rightTail.next = cur
                rightTail = rightTail.next!
            }
        }
        cur = cur?.next
    }
    // tail.next 是一定要情况的。
    rightTail.next = nil
    leftTail.next = rightH.next
    return leftH.next
}

/// 回文链表
/// 请判断一个链表是否为回文链表。
/// 输入: 1->2 输出: false
/// 输入: 1->2->2->1 输出: true
func isPalindrome(_ head: LeeListNode?) -> Bool {
    if head == nil {
        return false
    }
    
    // 一个
    if head?.next == nil {
        return true
    }
    
    // 两个
    if head?.next != nil && head?.next?.next == nil && head?.next?.val == head?.val {
        return true
    }
    
    let mid = getMidNode(head)
    let reverseHead = reverse(mid?.next)
    var cur = head
    var reverseCur = reverseHead
    
    while reverseCur != nil {
        if cur?.val != reverseCur?.val {
            return false
        }
        cur = cur?.next
        reverseCur = reverseCur?.next
    }
    return true
}

/// 获取中点
func getMidNode(_ head: LeeListNode?) -> LeeListNode? {
    if head == nil {
        return nil
    }
    var slow = head
    var fast = head
    while fast?.next != nil && fast?.next?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
    }
    return slow
}

func reverse(_ head: LeeListNode?) -> LeeListNode? {
    if head == nil || head?.next == nil {
        return head
    }
    let rh = reverse(head?.next)
    head?.next?.next = head
    head?.next = nil
    return rh
}
