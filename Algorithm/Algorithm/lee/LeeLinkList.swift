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


/// 删除倒数第N个节点
func removeNthFromEnd(_ head: LeeListNode?, _ n: Int) -> LeeListNode? {
    if head == nil || n <= 0{
        return nil
    }
    let dummpy: LeeListNode! = LeeListNode(-1)
    dummpy.next = head
    
    // 两个指针，快指针先走N步， 然后快慢一起走，走到头了。慢指针就是倒数第N个节点
    // 虚拟头结点 。找到前一个节点。。他妈的。贼重要
    var slow = dummpy
    var fast = head
    
    for _ in 0..<n {
        fast = fast?.next
    }
    while fast != nil {
        fast = fast?.next
        slow = slow?.next
    }
    slow?.next = slow?.next?.next
    return dummpy.next
}

/// 合并两个有序链表
func mergeTwoLists(_ l1: LeeListNode?, _ l2: LeeListNode?) -> LeeListNode? {
    if l1 == nil {
        return l2
    }
    if l2 == nil {
        return l1
    }
    
    // 两个都不为空
    let dumpy = LeeListNode(-1)
    var last:LeeListNode? = dumpy
    dumpy.next = last
    
    var a = l1
    var b = l2
    // 两个链表都有值
    while a != nil && b != nil {
        if a!.val < b!.val {
            last?.next = a
            a = a?.next
        } else {
            last?.next = b
            b = b?.next
        }
        last = last?.next
    }
    
    // 判断有剩余
    while a != nil {
        last?.next = a
        last = last?.next
        a = a?.next
    }
    
    while b != nil {
        last?.next = b
        last = last?.next
        b = b?.next
    }
    return dumpy.next
}


/// 合并两个有序链表
/// 递归解法
func mergeTwoLists2(_ l1: LeeListNode?, _ l2: LeeListNode?) -> LeeListNode? {
    if l1 == nil {
        return l2
    }
    if l2 == nil {
        return l1
    }
    if l1!.val < l2!.val {
        l1?.next = mergeTwoLists2(l1?.next, l2)
        return l1
    } else {
        l2?.next = mergeTwoLists2(l1, l2?.next)
        return l2
    }
}


/// 判断两个链表是否相交

/// 第一种情况；如果链表都没有环的情况。就看最后一个是否相等
func isJoined(_ l1: LeeListNode?, l2: LeeListNode?) -> Bool {
    if l1 == nil || l2 == nil {
        return false
    }
    var c1 = l1
    var c2 = l2
    while c1?.next != nil {
        c1 = c1?.next
    }
    while c2?.next != nil {
        c2 = c2?.next
    }
    return c1?.val == c2?.val
}

/// 两个相交链表，找到第一个相交的节点
func isJoined2(_ l1: LeeListNode?, l2: LeeListNode?) -> LeeListNode? {
    if l1 == nil || l2 == nil {
        return nil
    }
    var c1 = l1
    var c2 = l2
    while c1?.val != c2?.val {
        c1 = c1?.next == nil ? c2 : c1?.next
        c2 = c2?.next == nil ? c1 : c2?.next
    }
    return c1
}

/// LRU
/// https://leetcode-cn.com/problems/lru-cache/
class LRUCache {
    class LRUNode: CustomStringConvertible {
        var next: LRUNode?
        var pre: LRUNode?
        var key: Int
        var value: Int
        init(k: Int, v: Int) {
            key = k
            value = v
        }
        var description: String {
            return "\(value)"
        }
    }
    
    private var dict: Dictionary<Int,LRUNode>
    private var head: LRUNode!
    private var tail: LRUNode!
    private var capa = 2
    
    init(_ capacity: Int) {
        capa = capacity
        dict = Dictionary<Int,LRUNode>()
        head = LRUNode(k: 0, v: 0)
        tail = LRUNode(k: 0, v: 0)
        head.next = tail
        tail.pre = head
    }
    
    func get(_ key: Int) -> Int {
        // 获取
        if let node = dict[key] {
            // 访问，放在最前面
            removeNode(node: node)
            insertHead(node: node)
            
            return node.value
        }
        return -1
    }
    
    func put(_ key: Int, _ value: Int) {
        // 存在
        if let node = dict[key] {
            node.value = value
            removeNode(node: node)
            insertHead(node: node)
            dict[key] = node
        } else {
            // 不存在
            // 容量
            let node = LRUNode(k: key, v: value)
            // 超过容量了.删除最后一个
            if dict.count >= capa {
                // 找到最后一个
                let last = tail.pre
                dict[last!.key] = nil
                removeNode(node: last!)
            }
            dict[key] = node
            insertHead(node: node)
        }
    }
    
    func removeNode(node: LRUNode) {
        // 移除node
        let pre = node.pre
        let next = node.next
        pre?.next = next
        next?.pre = pre
    }
    
    func insertHead(node: LRUNode) {
        // head 下一个
        let next = head.next
        next?.pre = node
        node.next = next
        head.next = node
        node.pre = head
    }
    func display() {
        print(dict)
        var s = ""
        var v = head.next
        while v?.next != nil {
            s += " - \(v!.value)"
            v = v?.next
        }
        s += "\n"
        print(s)
    }
}

extension LRUCache {
    class func lruTest() {
//        ["LRUCache", "put", "put", "get", "put", "get", "put", "get", "get", "get"]
//        [[2], [1, 1], [2, 2], [1], [3, 3], [2], [4, 4], [1], [3], [4]]
//        输出
//        [null, null, null, 1, null, -1, null, -1, 3, 4]

        let lRUCache =  LRUCache(2);
        lRUCache.put(1, 1); // 缓存是 {1=1}
        lRUCache.display()
        
        lRUCache.put(2, 2); // 缓存是 {1=1, 2=2}
        lRUCache.display()
        
        print(lRUCache.get(1));    // 返回 1
        lRUCache.display()
        
        lRUCache.put(3, 3); // 该操作会使得关键字 2 作废，缓存是 {1=1, 3=3}
        lRUCache.display()
        
        print(lRUCache.get(2));    // 返回 -1 (未找到)
        lRUCache.display()
        
        lRUCache.put(4, 4); // 该操作会使得关键字 1 作废，缓存是 {4=4, 3=3}
        lRUCache.display()
        
        print(lRUCache.get(1));    // 返回 -1 (未找到)
        lRUCache.display()
        
        print(lRUCache.get(3));    // 返回 3
        lRUCache.display()
        
        print(lRUCache.get(4));    // 返回 4
        lRUCache.display()

    }
}

func mergeTwoLists3(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
    if l1 == nil {
        return l2
    }
    if l2 == nil {
        return l1
    }
    if l1!.val < l2!.val {
        l1?.next = mergeTwoLists3(l1?.next, l2)
        return l1
    } else {
        l2?.next = mergeTwoLists3(l1, l2?.next)
        return l2
    }
}

/// https://leetcode-cn.com/problems/rotate-list/
/// 旋转k链表
func rotateRight(_ head: LeeListNode?, _ k: Int) -> LeeListNode? {
    func reverse(_ node: LeeListNode?) -> LeeListNode? {
        if head == nil {
            return nil
        }
        let newHead = reverse(node?.next)
        node?.next?.next = node
        node?.next = nil
        return newHead
    }
    
    if head == nil  {
        return nil
    }
    /// 第一遍反转
    let newH = reverse(head)
    
    // 单个反转
    return newH
}

/// 旋转k链表
/// 方法2
func rotateRight2(_ head: LeeListNode?, _ k: Int) -> LeeListNode? {
    /// 链表连成环
    return nil
}

/// 排序链表
/// https://leetcode-cn.com/problems/sort-list/?utm_source=LCUS&utm_medium=ip_redirect&utm_campaign=transfer2china
func sortList(_ head: ListNode?) -> ListNode? {
    // 合并两个链表
    func merge(_ left: ListNode?, _ right: ListNode?) -> ListNode? {
        if left == nil {
            return right
        }
        if right == nil {
            return left
        }
        // 两个都有值
        let dummpy = ListNode(-1)
        var last: ListNode? = dummpy
        var h1 = left
        var h2 = right
        while h1 != nil && h2 != nil {
            if h1!.val < h2!.val {
                last?.next = h1
                h1 = h1?.next
            } else {
                last?.next = h2
                h2 = h2?.next
            }
            last = last?.next
        }
        // h1剩下的
        while h1 != nil {
            last?.next = h1
            h1 = h1?.next
            last = last?.next
        }
        while h2 != nil {
            last?.next = h2
            h2 = h2?.next
            last = last?.next
        }
        return dummpy.next
    }
    
    if head == nil || head?.next == nil {
        return head
    }
    // 找到中点，左右归并
    var slow = head
    var fast = head?.next
    while fast != nil && fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
    }
    // 中点slow
    let rightHead = slow?.next
    slow?.next = nil // 切断
    
    let left = sortList(head)
    let right = sortList(rightHead)
    
    // 合并两个有序链表
    return merge(left, right)
}

/// LFU
/// https://leetcode-cn.com/problems/lfu-cache/solution/java-13ms-shuang-100-shuang-xiang-lian-biao-duo-ji/

class LFUNode: CustomStringConvertible {
    var pre: LFUNode?
    var next: LFUNode?
    var key: Int
    var value: Int
    var count: Int = 0
    
    init(k: Int, v: Int) {
        key = k
        value = v
    }
    var description: String {
        get{
            return "【\(key):\(value)】"
        }
    }
}

/// 双向链表
class LFULinkList {
    var head: LFUNode?
    var tail: LFUNode?
    var size: Int = 0
    
    func isEmpty() -> Bool {
        return size == 0
    }
    
    func insertToHead(node: LFUNode) {
        if isEmpty() {
            head = node
            tail = node
        } else {
            head?.pre = node
            node.next = head
            head = node
        }
        size += 1
    }
    
    /// 删除最久未使用的
    func removeTail() -> Int {
        if isEmpty() {
            return -1
        }
        return remove(node: tail!)
    }
    
    func remove(node: LFUNode) -> Int {
        if isEmpty() {
            return -1
        }
        if size == 1 {
            let v = head!.key
            if node === head {
                head = nil
                tail = nil
                size = 0
                return v
            } else {
                print("非法删除")
            }
        } else {
            size -= 1
            /// 删除的是头结点
            if node === head {
                let v = head!.key
                let willHead = head?.next
                willHead?.pre = nil
                head?.next = nil
                head = willHead
                return v
            }
            /// 删除的是尾节点
            if node === tail {
                let v = tail!.key
                let willTail = tail?.pre
                willTail?.next = nil
                tail?.pre = nil
                tail = willTail
                return v
            }
            let v = node.value
            // 删除自己在feq链表中
            let pre = node.pre
            let next = node.next
            pre?.next = next
            next?.pre = pre
            return v
        }
        return -1
    }
}

class LFUCache {
  
    // key -> node
    var nodes: [Int: LFUNode]
    // feq -> list
    var feqs: [Int: LFULinkList]
    var cap: Int
    var minFeq = Int.max
    init(_ capacity: Int) {
        cap = capacity
        nodes = [Int : LFUNode](minimumCapacity: cap)
        feqs = [Int : LFULinkList](minimumCapacity: cap)
    }
    
    func get(_ key: Int) -> Int {
        if nodes.isEmpty {
            return -1
        }
        guard let node = nodes[key] else {
            return -1
        }
        // 获取频次
        let feq = node.count
        let value = node.value
        guard let curList = feqs[feq] else {
            return 0
        }
        _ = curList.remove(node: node)
        if curList.isEmpty() {
            feqs[feq] = nil
        }
        node.next = nil
        node.pre = nil
        
        // 新链表中
        let newFeqList = feqs[feq + 1] ?? LFULinkList()
        newFeqList.insertToHead(node: node)
        node.count = feq + 1
        feqs[feq + 1] = newFeqList
        nodes[node.key] = node
        if feq == minFeq {
            // 重新计算minFeq
            minFeq = Int.max
            for (_,item) in nodes.enumerated() {
                minFeq = min((minFeq), item.value.count)
            }
        }
        return value
    }
    
    func put(_ key: Int, _ value: Int) {
        // 添加之前淘汰
        if nodes.keys.count == cap && !nodes.keys.contains(key) {
            guard let minList = feqs[minFeq] else {
                return
            }
            let k = minList.removeTail()
            if minList.isEmpty() {
             feqs[minFeq] = nil
            }
            if k != -1 {
                nodes[k] = nil
            }
            minFeq = Int.max
            for (_,item) in nodes.enumerated() {
                minFeq = min(minFeq, item.value.count)
            }
        }
        
        // 已经存在了
        if let node = nodes[key] {
            // 获取频次
            let feq = node.count
            if let curList = feqs[feq] {
                _ = curList.remove(node: node)
            }
            node.next = nil
            node.pre = nil
            // 新链表中
            let newFeqList = feqs[feq + 1] ?? LFULinkList()
            newFeqList.insertToHead(node: node)
            node.count = feq + 1
            node.value = value
            nodes[key] = node
            feqs[node.count] = newFeqList
            minFeq = min(minFeq, node.count)
        } else {
            let nd = LFUNode(k: key, v: value)
            nd.count = 1
            nodes[key] = nd
            let newFeqList = feqs[nd.count] ?? LFULinkList()
            newFeqList.insertToHead(node: nd)
            feqs[nd.count] = newFeqList
            minFeq = min(minFeq, nd.count)
        }
    }
}

extension LFULinkList: CustomStringConvertible {
    public var description: String {
        var s = "size: \(size), content: [ "
        var node = head
        while let nd = node {
            s += nd.description
            node = nd.next
        }
        return s + "]"
    }
}
//"get","put", "get","get",  "put","get","get","get"]
//[1],  [3,3],  [2],  [3],   [4,4],  [1],  3],   [4]]

extension LFUCache {
    public class func LFUCacheTest() {
        let c = LFUCache(2)
        
        c.put(3, 1)
        c.put(2, 1)
        c.put(2, 2) //  1 3
        c.put(4, 4)
        print(c.get(2)) // 没有值 -1
        
//        c.put(1, 1)
//        c.put(2, 2)
//        print(c.get(1))
//        c.put(3, 3) //  1 3
//        print(c.get(2)) // 没有值 -1
//        print(c.get(3)) // 没有值 3
//        c.put(4, 4)
//        print(c.get(1)) // 没有值 -1
//        print(c.get(3)) // 没有值 -1
//        print(c.get(4)) // 没有值 -1
    }
}
