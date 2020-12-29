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
    
    /// 合并两个有序数组
    class func mergeTwoArray(array1: [Int], array2: [Int]) -> [Int]{
        let array1Count = array1.count
        let array2Count = array2.count
        var result = Array<Int>(repeating: 0, count: array1Count + array2Count)
        // 合并
        var i = 0
        var j = 0
        var cur = 0
        while i < array1Count && j < array2Count {
            // 小的先放前面
            if array1[i] < array2[j]{
                result[cur] = array1[i]
                i += 1
            } else {
                result[cur] = array2[j]
                j += 1
            }
            cur += 1
        }
        
        // 判断是否有剩余
        while i < array1Count {
            result[cur] = array1[i]
            i += 1
            cur += 1
        }
        
        while j < array2Count {
            result[cur] = array2[j]
            j += 1
            cur += 1
        }
        return result
    }
    
    /// 合并两个有序的数组，array1 是结果的长度，已经预留出来位置了,如[2,4,6,0,0,0]
    /// validCount array1真实的元素个数，不包含预留的位置 如上面的例子为3
    class func mergeTwoArray(array1: inout [Int], validCount: Int, array2: [Int]) {
        // 从后往前来
        var cur = array1.count - 1
        var i = validCount - 1
        // j 是小数组
        var j = array2.count - 1
        
        while j > 0 {
            // 大的放在最后面
            if array1[i] > array2[j] && i > 0{
                array1[cur] = array1[i]
                i -= 1
            } else {
                array1[cur] = array2[j]
                j -= 1
            }
            cur -= 1
        }
        
        print(array1)
    }
}



extension Lee1 {
    class func test() {
        mergeTwo()
    }
    
    class func validString() {
        print(isValidStr2("()"))
        print(isValidStr2("()[]"))
        print(isValidStr2("()[]["))
        print(isValidStr2("()[][[]]"))
        print(isValidStr2("([[]]"))
        print(isValidStr2("(]"))
        print(isValidStr2("([)]"))
        print(isValidStr2("([{}])"))
    }
    
    class func mergeTwo() {
//        let array1 = [1,3,5,7,9]
//        let array2 = [2,4,6,7,10]
//        print(mergeTwoArray(array1: array1, array2: array2))
        
        var array1 = [1,3,5,7,9,0,0,0,0,0,0]
        let array2 = [2,4,6,7,10,11]
        mergeTwoArray(array1: &array1, validCount: 5, array2: array2)
    }
}
