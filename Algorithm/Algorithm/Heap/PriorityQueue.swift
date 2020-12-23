//
//  PriorityQueue.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/29.
//

import Foundation


/// 优先级队列
class PriorityQueue {
    private var heap: BinaryHeap
    init() {
        heap = BinaryHeap()
    }
    /// 队列元素大小
    public func size() -> Int{
        return heap.size
    }
    /// 是否为空
    public func isEmpty() -> Bool {
        return heap.isEmpty()
    }
    /// 清空
    public func clear() {
        heap.clear()
    }
    /// 入队
    public func enQueue(element: Int) {
        heap.add(ele: element)
    }
   /// 出队
    public func deQueue() -> Int{
        return heap.remove()
    }

    /// 看下队头的元素
    public func front() -> Int{
        return heap.get()
    }
    
    public func display() {
        heap.display()
    }
    
    public class func PriorityQueueTest() {
//        let data = [77, 61, 71, 64, 17, 36, 83, 66, 98, 39, 23]
        let data = [77, 71, 2,2,2,2]
        let queue = PriorityQueue()
        for i in data {
            queue.enQueue(element: i)
        }
        
        while !queue.isEmpty() {
            print("优先级为【 \(queue.deQueue()) 】出队")
        }
    }
}
