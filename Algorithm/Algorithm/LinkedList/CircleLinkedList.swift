//
//  CircleLinkedList.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/2.
//

import Foundation

/// 单向循环链表
class CircleLinkedList<T: Comparable> {
    /// 节点
    class CircleLinkedListNode<T: Comparable>: CustomStringConvertible {
        public var next:Node?
        public var element: T
        init(elem: T) {
            element = elem
        }
        var description: String {
            var s = ""
            s += "【\(element)】"
            s += "->\(next!.element)"
            s += " , "
            return s
        }
//        deinit {
//            print("值为\(element)的节点释放了")
//        }
    }

    typealias Node = CircleLinkedListNode<T>
    
    /// 链表头结点
    // readonly (当前有多少个元素)
    private(set) var size : Int = 0
    private(set) var first: Node?
    private(set) var current: Node? // 标记当前指向的节点
    
    init() {}
    
    /**
     * 清除所有元素
     */
    public func clear() {
        first = nil
        size = 0
    }
    /**
     * 恢复current 指向first
     */
    public func reset() {
        current = first
    }
    /**
     * current 指向下一个节点
     */
    public func next() {
        current = current?.next
    }
    /**
     * 移除current指向的节点
     */
    public func remove() {
        assert(current != nil, "current 有值才能删除")
        let newCurrent = current!.next
        let elme = removeNode(node: current!)
        print("删除的元素是\(elme)")
        current = newCurrent
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
        assert(rangeCheckForAdd(index: index), "outofrange")
        // 判断是否是第一个
        if index == 0 {
            let newFirst = Node(elem: element)
            if isEmpty() {
                first = newFirst
                newFirst.next = first
            } else {
                newFirst.next = first
                let last = getNode(index: size - 1)
                last.next = newFirst
                first = newFirst
            }
        } else if index == size { // 在最后添加
            let newLast = Node(elem: element)
            if size == 1 {
                first?.next = newLast
            } else {
                let last = getNode(index: size - 1)
                last.next = newLast
            }
            newLast.next = first
        } else { // 中间添加
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
            if size == 1 { // 链表只有一个元素.就是头结点
                first = nil
            } else {
                let last = getNode(index: size - 1)
                first = current.next!
                last.next = first
            }
        } else if index == size - 1 { // 删除最后一个
            //找到删除的前一个
            let pre = getNode(index: index - 1)
            current = pre.next!
            pre.next = first
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
    
    private func removeNode(node: Node) -> T {
        let index = indexOf(element: node.element)
        assert(index >= 0, "不包含")
        return remove(index: index)
    }
    
    public class func CircleLinkedListTest() {
        let link = CircleLinkedList<Int>()
        print(link.isEmpty())
        link.add(element: 1)
        link.add(element: 2)
        link.add(element: 5)
        print(link)
        link.add(index: 2, element: 99) // 1 2 99 5
        print(link)
        link.add(index: 0, element: 299) // 299 1 2 99 5
        print(link)
        link.add(index: 2, element: 199) // 299 1 199 2 99 5
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
        _ = link.remove(index: 0)
        print(link)
    }
    
    
    public class func YuesesiProblemTest() {
        let link = CircleLinkedList<Int>()
        for i in 1...8 {
            link.add(element: i)
        }
        link.reset()
        while !link.isEmpty() {
            link.next()
            link.next()
            link.remove()
        }
        
        print(link)
    }
}

extension CircleLinkedList: CustomStringConvertible {
    public var description: String {
        var s = "size: \(size), content: ["
        var node = first
        for _ in 0..<size {
            s += node!.description
            node = node?.next
        }
        return s + "]"
    }
}
