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

/// https://leetcode-cn.com/problems/reverse-integer/
/// 整数反转
func reverse(_ x: Int) -> Int {
    var res = 0
    var n = x
    var pre = 0
    while n != 0 {
        pre = res
        let mod = n % 10
        res = mod + pre * 10
        if (res - mod) / 10 != pre {
            return 0
        }
        n = n / 10
    }
    return res
}


//public int reverse(int x) {
//    int res = 0;
//    while (x != 0) {
//        int prevRes = res;
//        int mod = x % 10;
//        res = prevRes * 10 + mod;
//        if ((res - mod) / 10 != prevRes) return 0;
//        x /= 10;
//    }
//    return res;
//}


// 会议室
func canJoin(num: [[Int]]) -> Bool {
    if num.count == 0 {
        return true
    }
    //根据开始时间排序
    var meeting = num
    meeting.sort { (m1, m2) -> Bool in
        return m1[0] < m2[0]
    }
    print(meeting)
    
    for idx in 1..<meeting.count {
        // 前一个
        let pre = meeting[idx - 1]
        let cur = meeting[idx]
        
        // 如果当前的开始时间 小于前一个的结束时间，那么不能全部参加
        if cur[0] < pre[1] {
            return false
        }
    }
    
    return true
}


/// 会议室2 。会议室个数
func getMeetingCount(num: [[Int]]) -> Int {
    if num.count == 0 {
        return 0
    }
    //根据开始时间排序
    var meeting = num
    meeting.sort { (m1, m2) -> Bool in
        return m1[0] < m2[0]
    }
    print(meeting)
    // 用小顶堆。【重要】
    let heap = BinaryHeap { (a, b) -> Bool in
        return a < b
    }
    // 堆立面有东西
    // 放最早的结束时间
    heap.add(ele: meeting[0][1])
    for idx in 1..<meeting.count {
        let cur = meeting[idx]
        // 开始时间在之前结束会议之后。可以复用
        if cur[0] > heap.get() {
            _ = heap.remove()
        }
        heap.add(ele: cur[1])
    }
    
    return heap.size
}


/// https://leetcode-cn.com/problems/trapping-rain-water/
/// 接雨水
func trap(_ height: [Int]) -> Int {
    if height.count == 0 || height.count == 1{
        return 0
    }
   
    var leftMax = Array<Int>(repeating: 0, count: height.count)
    var rightMax = Array<Int>(repeating: 0, count: height.count)
    let lastIdx = height.count - 1
    for idx in 1..<lastIdx {
        // 左边的最大值
       leftMax[idx] = max(leftMax[idx - 1], height[idx - 1])
    }
    
    for idx in (1..<lastIdx).reversed(){
        rightMax[idx] = max(rightMax[idx + 1], height[idx + 1])
    }
    
    var res = 0
    // 第一根柱子跟最后一个柱子都没水
    for idx in 1..<lastIdx {
        let minMax = min(leftMax[idx], rightMax[idx])
        // 说明这根柱子不能放水
        if (minMax <= height[idx]) {
            continue
        }
        res += (minMax - height[idx])
    }
    
    return res
}


/// 有序二维数组查找数字
/// 行从左到右变大。 列从上到下变大
func containNum(num: [[Int]], target: Int) -> Bool {
    // 右上角
    if num.count == 0 {
        return false
    }
    let row = num.count - 1
    let col = num[0].count - 1
    var top = 0
    var right = col
    // 从右上角开始
    while top < row && right > 0 {
        print("遍历到\(num[top][right])")
        if num[top][right] == target {
            return true
        } else if num[top][right] > target {
            right -= 1
        } else {
            top += 1
        }
    }
    return false
}

func containNum2(num: [[Int]], target: Int) -> Bool {
    if num.count == 0 {
        return false
    }
    // 考虑从左下角开始
    let row = num.count - 1
    let col = num[0].count - 1
    var bottom = row
    var left = 0
    // 从右上角开始
    while bottom > 0 && left < col {
        print("遍历到\(num[bottom][left])")
        if num[bottom][left] == target {
            return true
        } else if num[bottom][left] > target {
            bottom -= 1
        } else {
            left += 1
        }
    }
    return false
}

/// 旋转数组的最小数字
func rotareMin(num: [Int]) -> Int {
    if num.count == 0 {
        return 0
    }
    if num.count == 1 {
        return num[0]
    }
    if num.count == 2 {
        return max(num[0], num[1])
    }
    // 12345
    // 3 4 5 1 2
    var left = 0
    var right = num.count - 1
    while num[left] >= num[right] {
        if right - left == 1 {
            return num[right]
        }
        
        let mid = (left + right) / 2
        // 先确认那边是有序的
        // 左边是有序的. 最小值在右边
        if num[left] <= num[mid] {
            left = mid
        } else if num[mid] <= num[right] {
            right = mid
        }
    }
    return 0
}
    
//[
//     [1],
//    [1,1],
//   [1,2,1],
//  [1,3,3,1],
// [1,4,6,4,1]
//]
/// 杨辉三角
func getRow(_ n: Int) -> [[Int]] {
    if n == 0 {
        return[[Int]]()
    }
    var result = [[Int]]()
    for idx in 1...n {
        var sub = Array<Int>(repeating: 1, count: idx)
        if idx > 2 {
            // 取出之前的
            let prev = result[idx - 1 - 1]
            for pi in 0..<prev.count - 1 {
                sub[pi + 1] = prev[pi] + prev[pi + 1]
            }
        }
        result.append(sub)
    }
    
    result.forEach { (item) in
        print(item)
    }
    return result
}

/// 最长递减子序列
func getLongDecreaseSeq(num: [Int]) -> Int {
    if num.count == 0 {
        return 0
    }
    var dp = Array<Int>.init(repeating: 1, count: num.count)
    dp[0] = 1
    var maxDp = dp[0]
    for idx in 1..<dp.count {
        if num[idx] < num[idx - 1] {
            dp[idx] = dp[idx - 1] + 1
        } else {
            dp[idx] = 1
        }
        maxDp = max(maxDp, dp[idx])
    }
    print(dp)
    return maxDp
}


/// 字符串数组 最长公共前缀
func longestCommonPrefix(_ strs: [String]) -> String {
    if strs.count == 0 {
        return ""
    }
    var css = [[Character]]()
    for str in strs {
        var cs = Array<Character>(repeating: " ", count: str.count)
        for (i,c) in str.enumerated() {
            cs[i] = c
        }
        css.append(cs)
    }
    var res = [Character]()
    // 从第一个字符串开始遍历
    for idx in 0..<css[0].count {
        // 取出第一个
        let first = css[0][idx]
        var allSame = true
        for j in 1..<css.count {
            // 字符串不相等的情况也要考虑下
            if idx < css[j].count {
                // 取出字符
                if css[j][idx] != first {
                    allSame = false
                }
            } else {
                allSame = false
            }
        }
        
        if allSame {
            // 前缀+
            res.append(first)
        } else {
            break
        }
    }
    if res.count == 0 {
        return ""
    }
    let pre = String(res)
    print(pre)
    return pre
}

/// 是否是回文数
func isPalindromeNum(_ x: Int) -> Bool {
    if x < 0 {
        return false
    }
    if x >= 0 && x < 10 {
        return true
    }
    var nums = [Int]()
    var temp = x
    while temp > 0 {
        let a = temp % 10
        nums.append(a)
        temp /= 10
    }
    var left = 0
    var right = nums.count - 1
    while left <= right {
        if nums[left] == nums[right] {
            left += 1
            right -= 1
        } else {
            return false
        }
    }
    return true
}

/// 原地删除，数组中重复的元素
/// 返回数组的长度
func removeDuplicates(_ nums: inout [Int]) -> Int {
    if nums.count <= 1 {
        return nums.count
    }
    // 第一个数不需要删除
    var last = 1
    for idx in 1..<nums.count {
        // 取出这个数
        let temp = nums[idx]
        if temp != nums[idx - 1] {
            nums[last] = temp
            last += 1
        }
    }
    return last
}

/// haystack 里找 needle 。返回第一个idx
func strStr(_ haystack: String, _ needle: String) -> Int {
    if needle.count == 0 || haystack.count == 0 {
        return -1
    }
    if needle.count > haystack.count  {
        return -1
    }
    var ns = [Character](repeating: " ", count: needle.count)
    for (i,c) in needle.enumerated() {
        ns[i] = c
    }
    var hs = [Character](repeating: " ", count: haystack.count)
    for (i,c) in haystack.enumerated() {
        hs[i] = c
    }
    var res = 0
    var jfirst = 0
    var contain = true
    for (idx,c) in hs.enumerated() {
        // 第一个
        if c != ns[jfirst] {
            continue
        } else {
            // 找到了第一个
            while jfirst < ns.count {
                if idx + jfirst < hs.count && ns[jfirst] == hs[idx + jfirst] {
                    jfirst += 1
                } else {
                    // 超出边间了 或者不相等
                    contain = false
                    break
                }
            }
            if contain {
                res = idx
                break
            } else {
                jfirst = 0
                contain = true
            }
        }
    }
    print(res)
    return res
}

/// 排序数组。
/// 返回数组中第一个大于或等于它的idx
func searchInsert(_ nums: [Int], _ target: Int) -> Int {
    if nums.count == 0 {
        return 0
    }
    var left = 0
    var right = nums.count - 1
    var a = -1
    while left <= right {
        let mid = (left + right) / 2
        // 找到了
        if target <= nums[mid] {
            a = mid
            right = mid - 1
        } else {
            left = mid + 1
        }
    }
    return a
}

/// https://leetcode-cn.com/problems/longest-increasing-subsequence/
/// 最长递增子序列
func lengthOfLIS(_ nums: [Int]) -> Int {
    if nums.count == 0 {
        return 0
    }
    var dp = Array<Int>(repeating: 1, count: nums.count)
    // dp[i] 代表以i idx 结尾的递增子序列
    /// dp[i] 与 dp[i - 1]
    var maxL = 1
    for idx in 1..<nums.count {
        for j in 0..<idx {
            if nums[idx] > nums[j] {
                dp[idx] = max(dp[j] + 1, dp[idx])
            }
        }
        maxL = max(maxL, dp[idx])
    }
    print(dp)
    return maxL
}

/// 跳跃游戏，是否可达
/// 贪心算法，每个位置都计算自己能达到的最远距离，同时每个位置要判断自己是否可达，也就是本位置需要在当前最远能到达的距离中。最终计算出来能到达的最远距离，与数组长度比较即可。
func canJump(_ nums: [Int]) -> Bool {
    if nums.count == 0 {
        return false
    }
    var rightMost = 0
    for (idx,item) in nums.enumerated() {
        if idx <= rightMost {
            rightMost = max(idx + item, rightMost)
        }
    }
    if rightMost >= nums.count - 1{
        return true
    }
    return false
}
