//
//  LQueue.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/4.
//

import Foundation

 /**
  * 队尾   ------->   队头
  *  队尾近， 队头出
  */

/// 双向链表实现的队列
class LQueue<T: Comparable> {
    
    private var linkList: DLinkedList = DLinkedList<T>()
    /// 队列元素大小
    public func size() -> Int{
        return linkList.size
    }
    /// 是否为空
    public func isEmpty() -> Bool {
        return linkList.isEmpty()
    }
    /// 清空
    public func clear() {
        linkList.clear()
    }
    /// 入队
    public func enQueue(element: T) {
        linkList.add(element: element)
    }
   /// 出队
    public func deQueue() -> T{
        linkList.remove(index: 0)
    }

    /// 看下队头的元素
    public func front() -> T{
        return linkList.get(index: 0)
    }
    
    public func display() {
        print(linkList)
    }
    
    public class func LQueueTest() {
        let queue = LQueue<Int>()
        for i in 0..<10 {
            queue.enQueue(element: i)
        }
        queue.display()
        print("队头元素\(queue.front())")
        while !queue.isEmpty() {
            print(" \(queue.deQueue()) 出队")
        }
    }
}
