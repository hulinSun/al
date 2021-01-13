//
//  QStack.swift
//  Algorithm
//
//  Created by hony on 2021/1/12.
//

import Foundation


class QStack {
    /// q1 保存始终队尾元素 O(1)
    private var q1 = LQueue<Int>()
    private var q2 = LQueue<Int>()
    
    public func push(ele: Int) {
        q1.enQueue(element: ele)
        while q1.size() > 1 {
            q2.enQueue(element: q1.deQueue())
        }
    }
    
    public func pop() -> Int {
        if q1.isEmpty() {
            print("这里出错了")
            return 0
        }
        let v = q1.deQueue()
        while !q2.isEmpty() {
            q1.enQueue(element: q2.deQueue())
        }
        while q1.size() > 1 {
            q2.enQueue(element: q1.deQueue())
        }
        return v
    }
    
    public func top() -> Int {
        if q1.isEmpty() {
            print("这里出错了 top")
            return 0
        }
        return q1.front()
    }
    
    public func dispaly() {
        q1.display()
        q2.display()
    }
    
    class func QStackTest() {
        let s = QStack()
        s.push(ele: 1)
        s.push(ele: 2)
        s.push(ele: 3)
        s.push(ele: 4)
        print(s.top())
        print(s.pop())
        print(s.pop())
        
    }
}


class QStack2 {
    /// 保持一个为空的。用来做中转
    private var q1 = LQueue<Int>()
    private var q2 = LQueue<Int>()
    
    public func push(ele: Int) {
        // 优先使用q1
        if q1.isEmpty() && q2.isEmpty() {
            q1.enQueue(element: ele)
            return
        }
        // q1 为空， 数据都放在q2里
        if q1.isEmpty() {
            q2.enQueue(element: ele)
            return
        }
        if q2.isEmpty() {
            q1.enQueue(element: ele)
        }
    }
    
    public func pop() -> Int {
        if q1.isEmpty() && q2.isEmpty() {
            print("这里没数据")
            return 0
        }
        // q2有值.
        if q1.isEmpty() {
            while q2.size() > 1 {
                q1.enQueue(element: q2.deQueue())
            }
            return q2.deQueue()
        }
        
        if q2.isEmpty() {
            while q1.size() > 1 {
                q2.enQueue(element: q1.deQueue())
            }
            return q1.deQueue()
        }
        return 0
    }
    
    public func top() -> Int {
        if q1.isEmpty() && q2.isEmpty() {
            print("这里没数据")
            return 0
        }
        // q2有值.
        if q1.isEmpty() {
            while q2.size() > 1 {
                q1.enQueue(element: q2.deQueue())
            }
            let v = q2.front()
            q1.enQueue(element: q2.deQueue())
            return v
        }
        
        if q2.isEmpty() {
            while q1.size() > 1 {
                q2.enQueue(element: q1.deQueue())
            }
            let v = q1.front()
            q2.enQueue(element: q1.deQueue())
            return v
        }
        return 0
    }
    
    public func dispaly() {
        q1.display()
        q2.display()
    }
    
    class func QStackTest() {
        let s = QStack2()
        s.push(ele: 1)
        s.push(ele: 2)
        s.push(ele: 3)
        s.push(ele: 99)
        s.push(ele: 98)
        s.push(ele: 4)
        print(s.pop())
        print(s.pop())
        print(s.pop())
        s.push(ele: 14)
        print(s.pop())
    }
}





