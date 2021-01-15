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

/// 荷兰国旗问题 .排颜色
/// 计数排序法 . 两趟
func sortColors(_ nums: inout [Int]) {
    if nums.count == 0 {
        return
    }
    // 分别对应 0 1 2 出现次数
    var counts = [0,0,0]
    for item in nums {
        if item == 0 {
            counts[0] += 1
        }
        if item == 1 {
            counts[1] += 1
        }
        if item == 2 {
            counts[2] += 1
        }
    }
    // 计数排序
    var last = 0
    for (idx, item) in counts.enumerated() {
        var c = item
        while c != 0 {
            // idx 代表值
            nums[last] = idx
            last += 1
            c -= 1
        }
    }
}

/// 指针一趟搞定
func sortColors2(_ nums: inout [Int]) {
    func swap(nums: inout [Int], i: Int, j: Int) {
        let temp = nums[i]
        nums[i] = nums[j]
        nums[j] = temp
    }
    
    if nums.count == 0 {
        return
    }
    // p0 用来换0
    // p1 用来换1
    // p0 < p1
    var p0 = 0
    var p1 = 0
    for i in 0..<nums.count {
        let n = nums[i]
        if n == 0 {
            swap(nums: &nums, i: i, j: p0)
            // p0 移动完之后，p1再与i换一下
            if p0 < p1 {
                swap(nums: &nums, i: i, j: p1)
            }
            p0 += 1
            p1 += 1
        }
        if n == 1 {
            swap(nums: &nums, i: i, j: p1)
            p1 += 1
        }
    }
    print(nums)
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

/// 打印菱形
func printLinxin(n: Int) {
    let a = (n + 1) / 2
    var s = ""
    for row in 0...n {
        for col in 0...n {
            let x = abs(col - a)
            let y = abs(row - a)
            if abs(x + y) < a {
                s += "*"
            } else {
                s += " "
            }
        }
        s += "\n"
    }
    print(s)
}
