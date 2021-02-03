//
//  CircleQueue.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/4.
//

import Foundation

/// 循环队列 
class CircleQueue {
    
    static let defaultCapacity = 10
    private var list = Array(repeating: 0, count: defaultCapacity)
    private(set) var size : Int = 0
    private var frontIndex : Int = 0 // 存储着队头的索引
    
    /// 是否为空
    public func isEmpty() -> Bool {
        return (size == 0)
    }
    /// 清空
    public func clear() {
        size = 0
        frontIndex = 0
        for i in 0..<list.count {
            list[i] = 0
        }
    }
    /// 入队
    public func enQueue(element: Int) {
        // 扩容
        /// 因为是添加，所以保证容量为size + 1.这样才能添加元素进去
        ensureCapacity(size: size + 1)
        let realIndex = index(size)
        list[realIndex] = element
        size+=1
    }
    /// 出队
    public func deQueue() -> Int{
        assert(isEmpty() == false)
        // 队头出队。
        let frontValue = list[frontIndex]
        list[frontIndex] = 0
        frontIndex = index(1)
        size-=1
        return frontValue
    }

    /// 看下队头的元素
    public func front() -> Int {
        assert(isEmpty() == false)
        return list[frontIndex]
    }
   
    private func index(_ index: Int) -> Int {
        // 拿到真实的循环索引
        return (frontIndex + index) % list.count
    }
    
    private func ensureCapacity(size: Int) {
        let oldCapacity = list.count // 旧容量
        if size <= oldCapacity {
            return
        }
        
        // 扩容
        let newCapacity = oldCapacity + (oldCapacity >> 1)
        print("数组扩容，旧容量为：\(oldCapacity), 新容量为:\(newCapacity)")
        var newList = Array<Int>(repeating: 0, count: newCapacity)
        // 拷贝
        for i in 0..<oldCapacity {
            let realIndex = index(i)
            newList[i] = list[realIndex]
        }
        // 重置队头索引为0
        frontIndex = 0
        list = newList
        
    }
    
    public class func CircleQueueTest() {
        let queue = CircleQueue()
        for i in 0..<10 {
            let ele = i + 2
            queue.enQueue(element: ele)
        }
        print(queue)
        print("\(queue.deQueue()) 出队")
        print(queue)
        print("\(queue.deQueue()) 出队")
        print(queue)
        queue.enQueue(element: 67)
        print(queue)
        queue.enQueue(element: 57)
        print(queue)
        queue.enQueue(element: 88)
        print(queue)
    }
}

extension CircleQueue: CustomStringConvertible {
    var description: String {
        var s = "size: \(size), capacity:\(list.count), 队头索引:\(frontIndex), 队头值:\(front()) [ "
        for i in 0..<list.count {
            if i == 0 {
                s.append("\(list[i])")
            } else {
                s.append(", \(list[i])")
            }
        }
        s+=" ]"
        return s
    }
}
