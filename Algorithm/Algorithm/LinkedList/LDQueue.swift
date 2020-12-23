//
//  LDQueue.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/4.
//

import Foundation

/// 链表实现的双端队列
/// 可以从队头出，队头近  队尾出，队尾近
class LDQueue<T: Comparable> {
    private let list = DLinkedList<T>()
    
    public func size() -> Int{
        return list.size
    }

    public func isEmpty() -> Bool {
        return list.isEmpty()
    }

    public func  clear() {
        list.clear()
    }

    public func enQueueRear(element: T) {
        list.add(element: element)
    }

    public func deQueueFront() -> T{
        return list.remove(index: 0)
    }

    public func enQueueFront(element: T) {
        list.add(index: 0, element: element)
    }

    public func deQueueRear() -> T{
        list.remove(index: list.size - 1)
    }

    public func front() -> T{
        assert(list.isEmpty() == false)
        return list.get(index: 0)
    }

    public func rear() -> T {
        assert(list.isEmpty() == false)
        return list.get(index: list.size - 1)
    }
    
    public func display () {
        print(list)
    }
    
    public class func LDQueueTest() {
        let dequeue = LDQueue<Int>()
        
        dequeue.enQueueRear(element: 10)
        dequeue.enQueueRear(element: 9)
        dequeue.enQueueRear(element: 8)
        dequeue.enQueueFront(element: 1)
        dequeue.enQueueFront(element: 2)
        dequeue.enQueueFront(element: 3)
        
        dequeue.display()
        print(dequeue.deQueueRear())
        print(dequeue.deQueueRear())
        dequeue.display()
        print(dequeue.deQueueFront())
        dequeue.display()
    }
}
