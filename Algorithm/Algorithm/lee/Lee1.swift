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
func swap(nums: inout [Int], i: Int, j: Int) {
    let temp = nums[i]
    nums[i] = nums[j]
    nums[j] = temp
}

/// 指针一趟搞定
func sortColors2(_ nums: inout [Int]) {
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


/// 1.遍历矩阵matrix，将值为0的元素的行的值和列的值分别存放在两个数组row 和 col中（定位）；
/// 2.再次分别遍历 row 和 col，修改matrix的元素为0
func setZeroes(_ matrix: inout [[Int]]) {
    if matrix.count == 0 {
        return
    }
    print(matrix)
    let col = matrix.first!.count
    let row = matrix.count
    var rows = [Int]()
    var cols = [Int]()
    
    for r in 0..<row {
        for c in 0..<col {
            if matrix[r][c] == 0 {
                rows.append(r)
                cols.append(c)
            }
        }
    }
    for r in 0..<row {
        for c in 0..<col {
            if rows.contains(r) || cols.contains(c) {
                matrix[r][c] = 0
            }
        }
    }
    print(matrix)
}


// 移动0
/// https://leetcode-cn.com/problems/move-zeroes/
func moveZeroes(_ nums: inout [Int]) {
    if nums.count == 0 {
        return
    }
    var current = 0
    var zeroCount = 0
    for item in nums {
        if item != 0 {
            nums[current] = item
            current += 1
        } else {
            zeroCount += 1
        }
    }
    var i = 0
    while i < zeroCount {
        nums[nums.count - 1 - i] = 0
        i += 1
    }
}

/// 三数之和
/// https://leetcode-cn.com/problems/3sum/
func threeSum(_ nums: [Int]) -> [[Int]] {
    var result = [[Int]]()
    if nums.count <= 2 {
        return result
    }
    // 先排序
    let a = nums.sorted()
    // 三数之和
    let count = nums.count
    // i l r
    // i 做第一个
    // l r 作为另外两个
    for i in 0..<count - 2 {
        if i > 0 && a[i] == a[i - 1] {
            continue
        }
        var l = i + 1
        var r = count - 1
        let remain = 0 - a[i]
        while l < r && l <= count - 2 && r > 0 {
            let twoSum = a[l] + a[r]
            if twoSum == remain {
                // 找到了
                result.append([a[i],a[l],a[r]])
                while l < r && a[l] == a[l + 1] {
                    l += 1
                }
                while l < r && a[r] == a[r - 1] {
                    r -= 1
                }
                r -= 1
                l += 1
            } else if twoSum > remain {
                r -= 1
            } else {
                l += 1
            }
        }
    }
    return result
}

/// 字符串到整数
func stringToNum(str: String) -> Int {
    if str.count == 0 {
        return 0
    }
    var num = 0
    for c in str {
        if c.isNumber {
            num = num * 10 + c.wholeNumberValue!
        } else {
            // 不是字符
            return 0
        }
    }
    return num
}


/// 两数之和
/// 返回下标
func twoSum2(_ nums: [Int], _ target: Int) -> [Int] {
    if nums.count <= 1 {
        return [Int]()
    }
    var result = [Int]()
    var dict = Dictionary<Int,Int>()
    // 大于两个
    for (idx,item) in nums.enumerated() {
        // key 是值 ，value 是下标
        // target - item
        if dict.keys.contains(target - item) {
            result.append(idx)
            result.append(dict[target - item]!)
        }
        dict[item] = idx
    }
    return result
}

//输入: s = "abcabcbb"
//输出: 3
//解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
func lengthOfLongestSubstringx(_ s: String) -> Int {
    if s.count == 0 {
        return 0
    }
    var cs = Array<Character>(repeating: " ", count: s.count)
    for (i,c) in s.enumerated() {
        cs[i] = c
    }
    // key 是字符， value 是之前出现的idx
    var pres = Dictionary<Character,Int>()
    pres[s.first!] = 0
    var left = 0
    var maxLong = 1
    for idx in 1..<cs.count {
        let c = cs[idx]
        // 之前没出现过
        if !pres.keys.contains(c) {
            // 什么都不做
        } else {
            // 之前出现过了
            let pidx = pres[c]!
            left = max(left, pidx + 1)
        }
        maxLong = max(maxLong, idx - left + 1)
        print(String(cs[left...idx]))
        pres[c] = idx
    }
    print(maxLong)
    return maxLong
}

func maxAreaa(_ height: [Int]) -> Int {
    if height.count <= 1 {
        return 0
    }
    var left = 0
    var right = height.count - 1
    var maxA = 0
    while left < right {
        let w = right - left
        var h = 0
        if height[left] < height[right]  {
            h = height[left]
            left += 1
        } else {
            h = height[right]
            right -= 1
        }
        maxA = max(maxA, w*h)
    }
    return maxA
}


/// 数组中重复的数
/// 0 ~ n个数。
func getDumpNum(num: inout [Int]) -> [Int] {
    if num.count == 0 {
        return [Int]()
    }
    print(num)
    var res = [Int]()
    /// 贼他妈重要的判断
    for idx in 0..<num.count {
        while num[idx] != num[num[idx]] && num[idx] < num.count {
            swap(nums: &num, i: num[idx], j: idx)
        }
    }
    print(num)
    for (idx, item) in num.enumerated() {
        if idx != item {
            res.append(item)
        }
    }
   
    print(res)
    return res
}



/// https://leetcode-cn.com/problems/spiral-matrix/
/// 螺旋矩阵
/**
[
  [1, 2, 3, 4],
  [5, 6, 7, 8],
  [9,10,11,12]
]
*/

func spiralOrder(_ matrix: [[Int]]) -> [Int] {
    if matrix.count == 0 {
        return [Int]()
    }
    var res = Array<Int>()
    // 上 右 下 左
    var top = 0
    var bottom = matrix.count - 1
    var left = 0
    var right = matrix[0].count - 1
    while left <= right && top <= bottom {
        // 左右
        for idx in left...right {
            res.append(matrix[top][idx])
        }
        top += 1
        if top > bottom {
            break
        }
        // 右下
        for idx in top...bottom {
            res.append(matrix[idx][right])
        }
        right -= 1
        if left > right {
            break
        }
        //右左
        for idx in (left...right).reversed() {
            res.append(matrix[bottom][idx])
        }
        bottom -= 1
        if top > bottom {
            break
        }
        // 左上
        for idx in (top...bottom).reversed() {
            res.append(matrix[idx][left])
        }
        left += 1
    }
    
    return res
}
