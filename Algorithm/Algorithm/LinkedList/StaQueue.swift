//
//  StaQueue.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/4.
//

import Foundation

///  利用两个栈，实现一个队列
/// 思想： instack  outstack
/// instack 负责进来。
/// outstack 负责出去
class StaQueue<T: Comparable> {
    
    private let inStack = LStack<T>()
    private let outStack = LStack<T>()
    
    /// 队列元素大小
    public func size() -> Int{
        return inStack.size() + outStack.size()
    }
    /// 是否为空
    public func isEmpty() -> Bool {
        return inStack.isEmpty() && outStack.isEmpty()
    }
    /// 清空
    public func clear() {
        inStack.clear()
        outStack.clear()
    }
    /// 入队
    public func enQueue(element: T) {
        inStack.push(element: element)
    }
   /// 出队
    public func deQueue() -> T{
       assert(isEmpty() == false, "不能为空")
        // 如果outstack 有东西，则直接出栈
        // 如果outstack 没东西，则将instack的东西全部倒进outstack 在出栈
        if outStack.isEmpty() {
            while !inStack.isEmpty() {
                outStack.push(element: inStack.pop())
            }
        }
        return outStack.pop()
    }

    /// 看下队头的元素
    public func front() -> T{
        if outStack.isEmpty() {
            while !inStack.isEmpty() {
                outStack.push(element: inStack.pop())
            }
        }
        return outStack.top()
    }
    
    public func display() {
        print("----------  inStack ----------")
        inStack.display()
        print("--------  inStack end  --------")
        print("----------  outStack ----------")
        outStack.display()
        print("--------  outStack end  --------")
        print("\n")
    }
    
    public class func StaQueueTest() {
        let staQ = StaQueue<Int>()
        print(staQ.isEmpty())
        staQ.enQueue(element: 1)
        print(staQ.isEmpty())
        staQ.enQueue(element: 2)
        staQ.enQueue(element: 3)
        
        print(staQ.front())
        print(staQ.deQueue())
        
        staQ.display()
        staQ.enQueue(element: 4)
        staQ.enQueue(element: 5)
        print(staQ.deQueue())
        
        staQ.display()
    }
}
