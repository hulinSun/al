//
//  LinkedList.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/10/26.
//

import Foundation

//static final int ELEMENT_NOT_FOUND = -1;

protocol ListProtocol {
    
    typealias T = Int
    /**
     * 清除所有元素
     */
    func clear();

    /**
     * 元素的数量
     * @return
     */
    func size() -> Int;

    /**
     * 是否为空
     * @return
     */
    func isEmpty() -> Bool;

    /**
     * 是否包含某个元素
     * @param element
     * @return
     */
    func contains(element: T) -> Bool;

    /**
     * 添加元素到尾部
     * @param element
     */
    func add(element: T);

    /**
     * 获取index位置的元素
     * @param index
     * @return
     */
    func get(index: Int) -> T;

    /**
     * 设置index位置的元素
     * @param index
     * @param element
     * @return 原来的元素ֵ
     */
    func set(index:Int, element: T) -> Error;

    /**
     * 在index位置插入一个元素
     * @param index
     * @param element
     */
    func add(index: Int, element: T);

    /**
     * 删除index位置的元素
     * @param index
     * @return
     */
    func remove(index: Int) -> T;

    /**
     * 查看元素的索引
     * @param element
     * @return
     */
    func indexOf(element: T) -> Int;
}

class LinkedList<T: Comparable> {
    
    /// 节点
    class LinkedListNode<T>: CustomStringConvertible {
        public var next:Node?
        public var element: T
        init(elem: T) {
            element = elem
        }
        var description: String {
            return "\(element)"
        }
    }

    typealias Node = LinkedListNode<T>
    
    /// 链表头结点
    // readonly (当前有多少个元素)
    private(set) var size : Int = 0
    private(set) var first: Node?
    
    init() {}
    
    /// 链表反转 三个指针法
    /// https://www.cnblogs.com/luego/p/11421590.html
    ///  【1】 --->【2】 --->【3】 --->【4】 ---> null
    ///   pre          now          next
    public func reverse() {
        if isEmpty() || size == 1{
            print("链表为空或者只有头结点，无需反转")
            return
        }
        /// 当前位置
        var now = first
        /// 前一个
        var ppre :Node?
        /// 下一个
        var pnext :Node?
        /// 新的头结点
//        var newHead : Node
        /// 循环至pnow一直有值
        while let pnow = now {
            /// 去取下一个
            pnext = pnow.next
            /**
             * 解法1： 如果now 后面已经没有值了。那么说明遍历到最后了。则把新的头结点赋值返回。这里是swift 在泛型类里面还不会创建，所以直接改了原来的first
            if pnext == nil {
                newHead = pnow
                first = newHead
            }
             */
            pnow.next = ppre
            /// 往后移动，不能断掉
            ppre =  now
            now = pnext
            /** 解法2
             * 注意这里一定是 first = pnow 。一定要保证pnow有值。每次遍历之后，新的节点永远都是pnow
             */
            first = pnow
        }
    }
    
    /** 递归法
    public ListNode reverseList(ListNode head) {
        if (head == null || head.next == null) return head;
        ListNode newHead = reverseList(head.next);
        // head.next 是新链表的尾巴节点，其实是想让新链表的尾节点连上最后一个，就全链表完成了
        head.next.next = head;
        head.next = null;
        return newHead;
    } */
    
    /** 判断聊表是否有环
     * 在操场上跑步，快的人一定会追上慢的人。
     * 一次循环，差距小一步
     * 如果快指针走三步，容易错过。有不确定因素在。
     *
    public boolean hasCycle(ListNode head) {
        if (head == null || head.next == null) return false;
        ListNode slow = head;
        ListNode fast = head.next;
        while (fast != null && fast.next != null) { // 让fast跑到头就行了
            slow = slow.next;
            fast = fast.next.next; // 注意这里的判断条件，各自跑各自的。
            if (slow == fast) return true;
        }
        return false;
    }
     */
    /**
     * 清除所有元素
     */
    public func clear() {
        first = nil
        size = 0
    }

    /**
     * 是否为空
     * @return
     */
    public func isEmpty() -> Bool {
        return size == 0
    }

    /**
     * 是否包含某个元素
     * @param element
     * @return
     */
    public func contains(element: T) -> Bool {
        return indexOf(element: element) != -1
    }

    /**
     * 添加元素到尾部
     * @param element
     */
    public func add(element: T) {
        add(index: size, element: element)
    }

    /**
     * 获取index位置的元素
     * @param index
     * @return
     */
    public func get(index: Int) -> T {
        let node = getNode(index: index)
        return node.element
    }

    /**
     * 设置index位置的元素
     * @param index
     * @param element
     * @return 原来的元素ֵ
     */
    public func set(index:Int, element: T) -> T {
        // 找到这个node
        let node = getNode(index: index)
        let ele = node.element
        node.element = element
        return ele
    }

    /**
     * 在index位置插入一个元素
     * @param index
     * @param element
     */
    public func add(index: Int, element: T) {
        // 判断是否是第一个
        if index == 0 {
            first = Node(elem: element)
        } else {
            // 找到index前一个
            let pre = getNode(index: index - 1)
            let toAdd = Node(elem: element)
            toAdd.next = pre.next
            pre.next = toAdd
        }
        size+=1
    }

    /**
     * 删除index位置的元素
     * @param index
     * @return
     */
    public func remove(index: Int) -> T {
        assert(size >= index, "remove outOfRange")
        var current: Node = first!
        // 删除的是第一个
        if index == 0 {
            first = current.next!
        } else {
            // 删除的是中间的
            // 获取前一个
            let pre = getNode(index: index - 1)
            current = pre.next!
            pre.next = current.next
        }
        size-=1
        return current.element
    }

    /**
     * 查看元素的索引
     * @param element
     * @return
     */
    public func indexOf(element: T) -> Int {
        if first == nil {
            return -1
        }
        var node = first
        for i in 0..<size {
            if node?.element == element {
                return i
            }
            node = node?.next
        }
        return -1
    }
    
    private func getNode(index: Int) -> Node {
        assert(first != nil, "List is empty")
        assert(rangeCheck(index: index) , "outOfRange")
        
        var currentNode = first!
        for _ in 0..<index {
            currentNode = currentNode.next!
        }
        return currentNode
    }
    
    private func rangeCheckForAdd(index: Int)-> Bool {
        if index < 0 || index > size {
            print("add: 非法访问 index:\(index) size:\(size)")
            return false
        } else {
            return true
        }
    }
    
    private func rangeCheck(index: Int)-> Bool {
        if index < 0 || index >= size {
            print("非法访问 index:\(index) size:\(size)")
            return false
        } else {
            return true
        }
    }
    public class func linkedListTes() {
        let link = LinkedList<Int>()
        print(link.isEmpty())
        link.add(element: 1)
        link.add(element: 2)
        link.add(element: 3)
        link.add(element: 4)
        link.add(element: 5)
        link.add(index: 2, element: 99)
        print(link)
        
        link.add(index: 2, element: 199)
        print(link)
        
        _ = link.remove(index: 3)
        print(link)
        
        print(link.indexOf(element: 199))
        print(link.contains(element: 5))
        print(link.get(index: 0))
        print(link.set(index: 1, element: 88))
        print(link)
        _ = link.remove(index: 2)
        print(link)
        
        link.reverse()
        print(link)
    }
}

extension LinkedList: CustomStringConvertible {
    public var description: String {
        var s = "size: \(size), content: ["
        var node = first
        while let nd = node {
            s += "\(nd.element)"
            node = nd.next
            if node != nil { s += " -> " }
        }
        return s + "]"
    }
}

/// 链表输出小技巧
///  1 2 3  -->  1 3  给你2的节点
/** 拿不到前一个节点时，进行值替换操作，将下一个节点的值赋值给当前节点，跳过下一个节点。
func removeNode(node: Node) {
    node.value = node.next.value
    node.next = node.next.next
}
 */

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class Solution {
    func deleteNode(_ node: ListNode?) {
        if let nd = node {
            nd.val =  (nd.next)!.val
            nd.next = (nd.next)!.next
        }
    }
}
