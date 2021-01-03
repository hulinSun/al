//
//  LeeStack_Queue.swift
//  Algorithm
//
//  Created by 孙虎林 on 2021/1/3.
//

/// 栈， 队列相关
import Foundation

/// 最小栈  https://leetcode-cn.com/problems/min-stack/
/// 设计一个支持 push ，pop ，top 操作，并能在常数时间内检索到最小元素的栈。
/// push(x) —— 将元素 x 推入栈中。
/// pop() —— 删除栈顶的元素。
/// top() —— 获取栈顶元素。
/// getMin() —— 检索栈中的最小元素。

class MinStack {
    private var stack: LStack<Int>
    private var minStack: LStack<Int>
    init() {
        stack = LStack<Int>()
        minStack = LStack<Int>()
    }
    
    func push(_ x: Int) {
        stack.push(element: x)
        if minStack.isEmpty() {
            minStack.push(element: x)
        } else {
            // push一个最小的。
            minStack.push(element: min(x, minStack.top()))
        }
    }
    
    func pop() {
        _ = stack.pop()
        _ = minStack.pop()
    }
    
    func top() -> Int {
        return stack.top()
    }
    
    func getMin() -> Int {
        return minStack.top()
    }
    
}
/// 链表，头插法
class LinkMinStack {
    class MinNode {
        var value: Int
        var min: Int
        var next: MinNode?
        init(val: Int, m: Int) {
            value = val
            min = m
        }
    }
    private var head: MinNode?
    
    func push(_ x: Int) {
        if head == nil {
            head = MinNode(val: x, m: x)
        } else {
            let originHead = head!
            let newNode = MinNode(val: x, m: min(originHead.min, x))
            newNode.next = originHead
            head = newNode
        }
    }
    
    func pop() {
        if head != nil {
            head = head!.next
        }
    }
    
    func top() -> Int {
        if head != nil {
            return head!.value
        }
        return 0
    }
    
    func getMin() -> Int {
        if head != nil {
            return head!.min
        }
        return 0
    }
}


