//
//  AStack.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/2.
//

import Foundation

///  数组实现的栈
class AStack {
    
    private var array: ArrayList = ArrayList(initCapacity: 10)
    
    public func clear() {
        array.clear()
    }
    
    public func isEmpty() -> Bool{
        return array.isEmpty()
    }
    
    public func size() -> Int {
        return array.size
    }
    
    public func push(element: Int) {
        array.add(item: element)
    }

    public func pop() -> Int {
        assert(isEmpty() == false, "栈不能为空")
        let value = top()
        array.remove(index: array.size - 1)
        return value
    }
    
    public func top() -> Int {
        assert(isEmpty() == false, "栈不能为空")
        return array.getItem(at: array.size - 1)!
    }
    
    public func display() {
        array.display()
    }
    
    public class func AStackTest(){
        let stack = AStack()
        for i in 1...8 {
            stack.push(element: i)
        }
        stack.display()
        while !stack.isEmpty() {
            print(stack.pop())
        }
    }
}
