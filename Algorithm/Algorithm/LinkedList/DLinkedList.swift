//
//  DLinkedList.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/1.
//

import Foundation

/// 双向链表
class DLinkedList<T: Comparable> {
    
    /// 双向链表节点
    class DLinkedListNode<T: Comparable>: CustomStringConvertible {
        public var next:Node?
        public var pre:Node?
        public var element: T
        init(elem: T, nextNode: Node?, preNode: Node?) {
            element = elem
            next = nextNode
            pre = preNode
        }
        convenience init(elem: T) {
            self.init(elem: elem, nextNode: nil, preNode: nil)
        }
        var description: String {
            var s = ""
            if pre == nil {
                s += "null<-"
            } else {
                s += "\(pre!.element)<-"
            }
            s += "【\(element)】"
            if next == nil {
                s += "->null"
            } else {
                s += "->\(next!.element)"
            }
            if next == nil {
                s += " "
            } else {
                s += " , "
            }
            return s
        }
//        deinit {
//            print("值为\(element)的节点释放了")
//        }
    }

    typealias Node = DLinkedListNode<T>
    /// 链表头结点
    // readonly (当前有多少个元素)
    private(set) var size : Int = 0
    /// 头结点
    private(set) var first: Node?
    /// 尾节点
    private(set) var last: Node?
    
    init() {}
    
    /**
     * 清除所有元素
     */
    public func clear() {
        first = nil
        last = nil
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
        // 获取index位置的节点，此时应该是添加后的下一个节点，
        if index == 0{ // 如果添加的第0个
            let node = Node(elem: element)
            if isEmpty() {
                first = node
                last = node
            } else {
                let oldFirst = first
                node.next = oldFirst
                oldFirst?.pre = node
                first = node
            }
        } else if index == size && !isEmpty() { // 添加的是最后一个.并且不为空。 index==size的时候，链表为空也满足
            let oldLast = last
            let node = Node(elem: element, nextNode: nil, preNode:oldLast)
            oldLast?.next = node
            last = node
        } else { // 中间插入
            let next = getNode(index: index)
            let pre = next.pre
            let node = Node(elem: element, nextNode: next, preNode:pre)
            pre?.next = node
            next.pre = node
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
        assert(!isEmpty(), "list empty")
    
        var deletedNode: Node! // 确定是有值的。
        if index == 0 { // 删除第一个
            let oldFirst = first!
            let next = oldFirst.next
            next?.pre = nil
            oldFirst.next = nil // 清空操作
            
            first = next
            deletedNode = oldFirst
        } else if index == size - 1 && !isEmpty() { // 删除最后一个
            let oldLast = last!
            let pre = oldLast.pre
            pre?.next = nil
            oldLast.pre = nil
            
            last = pre
            deletedNode = oldLast
        } else { // 删除中间的
            let node = getNode(index: index)
            let pre = node.pre
            let next = node.next
            pre?.next = next
            next?.pre = pre
            deletedNode = node
        }
        size-=1
        return deletedNode.element
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
        // 判断是从前面遍历还是从后面遍历
        if index < (size >> 1) { // 左边遍历
            var currentNode = first!
            for _ in 0..<index {
                currentNode = currentNode.next!
            }
            return currentNode
        } else { // 右边遍历
            var currentNode = last!
            // 计算出遍历多少次
            let time = size - index - 1  // 这里注意，size是个数
            for _ in 0..<time {
                currentNode = currentNode.pre!
            }
            return currentNode
        }
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
            assert(false,"非法访问")
            return false
        } else {
            return true
        }
        
    }
    public class func DLinkedListTest() {
        let link = DLinkedList<Int>()
        print(link.isEmpty())
        link.add(element: 1)
        link.add(element: 2)
        link.add(element: 3)
        print(link)
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
        
    }
}

extension DLinkedList: CustomStringConvertible {
    public var description: String {
        var s = "size: \(size), content: [ "
        var node = first
        while let nd = node {
            s += nd.description
            node = nd.next
        }
        return s + "]"
    }
}
