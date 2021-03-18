//
//  BinaryHeap.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/28.
//

import Foundation

let HeapDefaultCapactiy = 10

/// 二叉堆 (完全二叉堆)  大顶堆
class BinaryHeap {
    /// 比较器
    var comparetor: ((Int, Int) -> Bool)
    
    init(element: Array<Int>?, compare: ((Int, Int) -> Bool)?) {
        if let cmp = compare {
            comparetor = cmp
        } else {
            comparetor = { a, b in
                return a > b
            }
        }
        if let elems = element {
            let capacity = max(elems.count, HeapDefaultCapactiy)
            elements = Array<Int>(repeating: 0, count: capacity)
            for (idx,item) in elems.enumerated() {
                elements[idx] = item
            }
            size = elements.count
            // 堆化
            heapfiy()
        } else {
            elements = Array<Int>(repeating: 0, count: HeapDefaultCapactiy)
        }
    }
    
    convenience init() {
        // 默认大顶堆
        self.init(element: nil , compare: nil)
    }
    
    // 比较器
    convenience init(compareLogic: @escaping ((Int, Int) -> Bool)) {
        self.init(element: nil , compare: compareLogic)
    }
    
    // 传入需要堆化的数组
    convenience init(elems: Array<Int>) {
        self.init(element: elems , compare: nil)
    }
    
    private var elements: [Int]
    
    // 元素的数量
    private(set) var size = 0
    
    // 是否为空
    public func isEmpty() -> Bool {
        return size == 0
    }
    
    // 清空
    public func clear() {
        size = 0
    }
    
    // 添加元素
    public func add(ele: Int) {
        // 需要保证有那么多的容量
        ensureCapacity(count: size + 1)
        // 添加
        elements[size] = ele
        size += 1
        
        // 向上冒泡
        siftUp(index: size - 1)
    }
    
    // 获得堆顶元素
    public func get() -> Int {
        assert(isEmpty() == false, "不能为空")
        return elements[0]
    }
    
    // 删除堆顶元素
    public func remove() -> Int {
        assert(isEmpty() == false, "不能为空")
        // 将最后一个元素替换在堆顶上，堆顶元素下滤
        // 完全二叉堆只要第一个节点为叶子节点，那么后面的节点都是叶子节点
        // 完全二叉堆非叶子节点个数为 size / 2
        // 第一个叶子节点的索引为 (size / 2) + 1
        // 下滤到叶子节点就没办法下滤了
        let root = get()
        let last = elements[size - 1]
        elements[0] = last
        size -= 1
        siftDown(index: 0)
        return root
    }
    
   // 删除堆顶元素的同时插入一个新元素
    public func replace(ele: Int) -> Int {
        var result = ele
        if isEmpty() {
            elements[0] = ele
            size += 1
        } else {
            result = get()
            // 新添加的元素放在堆顶,然后下滤
            elements[0] = ele
            siftDown(index: 0)
        }
        return result
    }
    
    // 打印
    public func display() {
        var s = "【 "
        for i in 0..<size {
            if i == 0 {
                s += "\(elements[i])"
             } else {
                s += ", \(elements[i])"
            }
        }
        s += " 】"
        print(s)
    }
    
    // 扩容
    private func ensureCapacity(count: Int) {
        if count < elements.count {
            return
        }
        // 超过了。扩容下
        let oldCapacity = elements.count
        let newCapacity = oldCapacity + oldCapacity >> 1
        var newElements = Array<Int>(repeating: 0, count: newCapacity)
        for (idx,item) in elements.enumerated() {
            newElements[idx] = item
        }
        elements = newElements
        print("数组扩容了.原容量\(oldCapacity) , 新容量\(newCapacity)")
    }
    
    /// index位置向上冒泡 上滤
    /// - Parameter index: idx
    private func siftUp(index: Int) {
        /// 做法一： 频繁交换，不太好。先把current存一遍去，最后在交换
        // index 位置， 父节点的索引为 (index - 1) / 2
        let currentNode = elements[index]
        var idx = index
//        while idx > 0 {
//            // 父节点index
//            let parentIndex = (idx - 1) >> 1
//            let parent = elements[parentIndex]
//            if currentNode <= parent {
//                return
//            }
//            // 交换位置.父子交换 ，更新索引
//            let temp = elements[parentIndex]
//            elements[parentIndex] = currentNode
//            elements[idx] = temp
//            idx = parentIndex
//        }
        
        while idx > 0 {
            // 父节点index
            let parentIndex = (idx - 1) >> 1
            let parent = elements[parentIndex]
            if compare(a: parent, b: currentNode) {
                break
            }
            // 比我小的下来
            elements[idx] = parent
            idx = parentIndex
        }
        
        // 遍历完了。最终添加位置
        elements[idx] = currentNode
    }
    
    
    /// 从index 位置下滤  下滤
    /// - Parameter index: idx
    private func siftDown(index: Int) {
        // 完全二叉堆只要第一个节点为叶子节点，那么后面的节点都是叶子节点
        // 完全二叉堆非叶子节点个数为 size / 2
        // 第一个叶子节点的索引为 (size / 2) + 1
        // 下滤到叶子节点就没办法下滤了
        let currentNode = elements[index]
        var idx = index
        while idx < size / 2 {
            // 完全二叉堆节点两种情况 ： 要么只有左子节点， 要么左右都有 。不可能有右没有左
            // 默认为左
            var childIndex = idx * 2 + 1
            var child = elements[childIndex]
            
            // 拿到右节点indx
            let rightIndex = childIndex + 1
            // 判断是否有右节点
            if rightIndex < size {
                // 比较左右节点大小，拿出最大的比较
                if compare(a: elements[rightIndex], b: elements[childIndex]) {
                    child = elements[rightIndex]
                    childIndex = rightIndex
                }
            }
            if compare(a: currentNode, b: child) { // 不需要交换
                break
            }
            elements[idx] = child
            // 重置indx
            idx = childIndex
        }
        elements[idx] = currentNode
    }
    
    /// 比较器。决定是大顶堆还是小顶堆
    private func compare(a: Int , b: Int) -> Bool{
        return comparetor(a,b)
    }
    
    /// 堆化数组
    private func heapfiy() {
        // 从上往下 上滤.性能不好 O(nlog(n))
//        for idx in 1..<size {
//            siftUp(index: idx)
//        }
        
        // 从下往上 下滤 性能好 O(n)
        // 找到最后一个非叶子节点
        // 非叶子节点个数为 size / 2
        for idx in (0...(size / 2 - 1)).reversed() {
            siftDown(index: idx)
        }
    }
}


extension BinaryHeap {
    public class func BinaryHeapTest() {
        // 基本使用
//        let heap = BinaryHeap { (a, b) -> Bool in
//            return a > b
//        }
//        heap.add(ele: 43)
//        heap.add(ele: 100)
//        heap.add(ele: 3)
//        heap.add(ele: 33)
//        heap.add(ele: 83)
//        heap.add(ele: 46)
//        heap.add(ele: 72)
//        heap.add(ele: 50)
//
//        heap.display()
//        _ = heap.remove()
//        print("------")
//        heap.display()
//        _ = heap.replace(ele: 4)
//        heap.display()
        
        // 堆化
//        let data = [45, 19, 86, 3, 83, 24, 28, 8, 82, 64]
//        let heap = BinaryHeap(elems: data)
//        heap.display()
        
//        topK: 求集合中最大的k个数
        let data = [77, 61, 71, 64, 17, 36, 83, 66, 98, 39, 23, 67, 85, 87, 3, 52, 1, 81, 45, 32, 48, 16, 70, 49, 53, 7, 44, 12, 78, 79]
        // 用小顶堆。【重要】
        let heap = BinaryHeap { (a, b) -> Bool in
            return a < b
        }
        let k = 5
        for item in data {
            if heap.size < k {
                heap.add(ele: item)
            } else {
                // 每一次replace.都剔除了一个较小的元素
                if item > heap.get() {
                    _ = heap.replace(ele: item)
                }
            }
        }
        heap.display()
    }
}
