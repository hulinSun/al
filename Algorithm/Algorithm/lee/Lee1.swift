//
//  Lee1.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/23.
//

import Foundation

class Lee1 {
    // https://leetcode-cn.com/problems/valid-parentheses/
    /// 给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。
    /// 有效字符串需满足：
    /// 左括号必须用相同类型的右括号闭合。
    /// 左括号必须以正确的顺序闭合。
    /// 注意空字符串可被认为是有效字符串。
    class func isValidStr(_ s: String) -> Bool {
        let stack = LStack<String>()
        let dict = [")": "(","]": "[","}": "{"]
        for c in s {
            let cString = String(c)
            // 左
            if dict.values.contains(cString)  {
                stack.push(element: cString)
            } else {
                // 右括号
                // 栈里面取出来的永远是左括号
                let top = stack.pop()
                guard let resultLeft = dict[cString] else {
                    // 这里是非法字符
                    return false
                }
                // print("栈取出来的\(top), 当前遍历的字符串\(cString)")
                if resultLeft != top {
                    return false
                }
            }
        }
        if stack.isEmpty() {
            return true
        }
        return false
    }
    
    /// 消消乐解法
    class func isValidStr2(_ s: String) -> Bool {
        var str = s
        for _ in 0..<3 {
            str = str.replacingOccurrences(of: "()", with: "")
            str = str.replacingOccurrences(of: "{}", with: "")
            str = str.replacingOccurrences(of: "[]", with: "")
        }
        return str.count == 0
    }
    
    /**
    给定一个整数数组，编写一个函数，找出索引m和n，只要将索引区间[m,n]的元素排好序，整个数组就是有序的。注意：n-m尽量最小，也就是说，找出符合条件的最短序列。函数返回值为[m,n]，若不存在这样的m和n（例如整个数组是有序的），请返回[-1,-1]。
    示例：
    输入： [1,2,4,7,10,11,7,12,6,7,16,18,19]
    输出： [3,9]
     */
    class func findReversePair() -> (Int,Int) {
        // 寻找逆序对
        // 右边的位置： 从左往右 最后一个逆序对的位置
//        let array = [1,5,4,3,2,6,7]
        let array = [1,2,4,7,10,11,7,12,6,7,16,18,19]
        // 逆序对，找到当前的最大值来比较
        var max = array[0]
        var right = -1
        for idx in 1..<array.count {
            if array[idx] >= max {
                max = array[idx]
            } else {
                right = idx
            }
        }

        // 左边的位置： 从右往左，最后一个逆序对的位置
        // 标记最小值
        var left = -1
        var min = array.last!
        for idx in (0..<array.count-1).reversed() {
            if array[idx] <= min {
                min = array[idx]
            } else {
                left = idx
            }
        }
        
        return (left, right)
    }
}



extension Lee1 {
    class func test() {
//        print(isValidStr2("()"))
//        print(isValidStr2("()[]"))
//        print(isValidStr2("()[]["))
//        print(isValidStr2("()[][[]]"))
//        print(isValidStr2("([[]]"))
//        print(isValidStr2("(]"))
//        print(isValidStr2("([)]"))
//        print(isValidStr2("([{}])"))
        
        print(findReversePair())
    }
}
