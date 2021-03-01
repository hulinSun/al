//
//  DP.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/12.
//

import Foundation


class DP {
    
    /// 零钱兑换
    /// 假设有 25 分、20 分、5 分、1 分的硬币，现要找给客户 41 分的零钱，如何办到硬币个数最少?
    /// 兑换money，最低需要多少枚硬币
    /// 暴力递归 (自顶向上的)。 要想知道大的，必须得知道小的，
    /// 有很多重复的计算，重复的子问题
    class func changeCoins(money: Int) -> Int{
        if money < 1 {
            return Int.max
        }
        // 递归基
        if money == 1 || money == 5 || money == 20 || money == 25 {
            return 1
        }
        
        // 兑换money的第一步分四种情况 -> 求出下面四种的最小值就可以了
        /// changeCoins(money - 1) + 1
        /// changeCoins(money - 5) + 1
        /// changeCoins(money - 10) + 1
        /// changeCoins(money - 25) + 1
        
        let minCount1 = min(changeCoins(money: money - 25), changeCoins(money: money - 20))
        let minCount2 = min(changeCoins(money: money - 5), changeCoins(money: money - 1))
        
        return  min(minCount1, minCount2) + 1
    }
    
    /// 记忆搜索优化，自顶向下的。 避免了重复计算
    class func changeCoins2(money: Int) -> Int{
        if money < 1 {
            return Int.max
        }
        var dp = Array<Int>(repeating: 0, count: money + 1)
        return changeCoins2(money: money, dp: &dp)
    }
    
    private class func changeCoins2(money: Int, dp: inout [Int]) -> Int {
        // 递归基
        if money == 1 || money == 5 || money == 20 || money == 25 {
            return 1
        }
        /// 没有缓存才计算
        if dp[money] == 0 {
            // 兑换money的第一步分四种情况 -> 求出下面四种的最小值就可以了
            /// changeCoins(money - 1) + 1
            /// changeCoins(money - 5) + 1
            /// changeCoins(money - 10) + 1
            /// changeCoins(money - 25) + 1
            let minCount1 = min(changeCoins(money: money - 25), changeCoins(money: money - 20))
            let minCount2 = min(changeCoins(money: money - 5), changeCoins(money: money - 1))
            dp[money] = min(minCount1, minCount2) + 1
        }
        return dp[money]
    }
    
    /// 自底向上
    class func changeCoins3(money: Int) -> Int {
        if money < 1 {
            return 0
        }
        var dp = Array<Int>(repeating: 0, count: money + 1)
        for idx in 1..<dp.count {
            var minCount = Int.max
            if idx >= 1 {
                dp[1] = 1
                minCount = min(dp[idx - 1], minCount)
            }
            if idx >= 5 {
                dp[5] = 1
                minCount = min(dp[idx - 5], minCount)
            }
            if idx >= 20 {
                dp[20] = 1
                minCount = min(dp[idx - 20], minCount)
            }
            if idx >= 25 {
                dp[25] = 1
                minCount = min(dp[idx - 25], minCount)
            }
            
            dp[idx] = minCount + 1
        }
        return dp[money]
    }
    
    
    
    /// 给定一个长度为 n 的整数序列，求它的最大连续子序列和
    /// 比如 –2、1、–3、4、–1、2、1、–5、4 的最大连续子序列和是 4 + (–1) + 2 + 1 = 6
    /// ◼这道题也属于最大切片问题(最大区段，Greatest Slice)
    /// ◼ 概念区分
    /// 子串、子数组、子区间必须是连续的，子序列是可以不连续的
    
    class func maxSubArray() {
        let array = [-2,1,-3,4,-1,2,1,-5,4]
        // dp[i]: 以 array[i]为节点的最大连续子序列的和  -> 求出 dp[i] 的最大值即可
        
        // dp[0] = -2
        // dp[1] = 1
        // dp[2] = -2
        // dp[3] = 4
        // dp[4] = 3
        // dp[5] = 5
        // dp[6] = 6
        // dp[7] = 1
        // dp[8] = 5
        
        // 如果dp[i - 1] > 0 的话，dp[i] = dp[i - 1] + array[i]
        // 如果dp[i - 1] <= 0 的话，dp[i] = array[i]
        var dp = Array<Int>(repeating: 0, count: array.count)
        dp[0] = array[0]
        var maxDp = array[0]
        for idx in 1..<array.count {
            if dp[idx - 1] > 0 {
                dp[idx] = dp[idx - 1] + array[idx]
            } else {
                dp[idx] = array[idx]
            }
            maxDp = max(dp[idx], maxDp)
        }
        print("最长连续子序列和\(maxDp), dp数组: \(dp)")
        
    }
    
    /// 暴力递归看看
    /// 以 idx 结尾的最大连续子序列的和
    class func maxSubArray2(idx: Int, array: [Int]) -> Int {
        if idx < 1 {
            return array[0]
        }
        let pre = maxSubArray2(idx: idx - 1,array: array)
        if pre > 0 {
            return pre + array[idx]
        } else {
            return array[idx]
        }
    }
    
    class func maxSub() {
        let array = [-2,1,-3,4,-1,2,1,-5,4]
        var dp = [Int]()
        for idx in 0..<array.count{
            dp.append(maxSubArray2(idx: idx, array: array))
        }
        print(dp)
    }
    
    
    /// 给你一个整数数组 nums ，找到其中最长严格递增子序列的长度。
    /// 子序列是由数组派生而来的序列，删除（或不删除）数组中的元素而不改变其余元素的顺序。例如，[3,6,2,7] 是数组 [0,3,1,6,2,2,7] 的子序列。
    /// 最长上升子序列
    /// 输入：nums = [10,9,2,5,3,7,101,18]
    /// 输出：4
    /// 解释：最长递增子序列是 [2,3,7,101]，因此长度为 4 。
    class func longestIncreastSeq() {
        
        let nums = [10,9,2,5,3,7,101,18]
        var dp = Array<Int>(repeating: 1, count: nums.count)
        /// dp[i] 以 num[i] 结尾的递增子序列长度
        
        /// dp[0] = 1
        /// dp[1] = 1
        /// dp[2] = 1
        /// dp[3] = 2
        /// dp[4] = 2
        /// dp[5] = 3
        /// dp[6] = 4
        /// dp[7] = 4
        
        // dp[i] 与 之前的 dp[0...i - 1]
        var maxLong = 1
        for i in 1..<nums.count {
            for j in 0..<i {
                if nums[i] > nums[j] {
                    dp[i] = max(dp[j] + 1, dp[i])
                }
                maxLong = max(dp[i],maxLong)
            }
        }
        print(dp)
        print("最长的序列: \(maxLong)")
    }
    
    
    /// 以num[idx] 为结尾的最长dp数组
    class func longestIncreastSeq2(nums: [Int]) -> Int{
        let maxLong = longestIncreastSeq2(nums: nums, idx: nums.count - 1)
        print(maxLong)
        return maxLong
    }
    
    class func longestIncreastSeq2(nums: [Int], idx: Int) -> Int{
        var value = 1
        for i in 0..<idx {
            if nums[idx] > nums[i] {
                value = longestIncreastSeq2(nums: nums, idx: i) + 1
            }
        }
        return value
    }
    
    
    
    /// 最长公共子序列
    /// 给定两个字符串 text1 和 text2，返回这两个字符串的最长公共子序列的长度。
    /// 一个字符串的 子序列 是指这样一个新的字符串：它是由原字符串在不改变字符的相对顺序的情况下删除某些字符（也可以不删除任何字符）后组成的新字符串。
    /// 例如，"ace" 是 "abcde" 的子序列，但 "aec" 不是 "abcde" 的子序列。两个字符串的「公共子序列」是这两个字符串所共同拥有的子序列。
    /// 若这两个字符串没有公共子序列，则返回 0。
    class func longestCommonSeq() {
        let num1 = [1,3,4,5,7,9]
        let num2 = [1,4,7,9]
        
        // dp[i][j] => 代表 num1前i个元素 与 num2前j个元素的最长公共子序列
        // 看最后一个
        // 如果 num[i - 1] == num[j - 1] 最后一个相等，那么 dp[i][j] =  dp[i - 1][j - 1] + 1
        // 如果不相等 ，则dp[i][j] =  max(dp[i][j - 1] , dp[i - 1][j] )
        
        let maxCount = max(num2.count + 1, num1.count + 1)
        var dp = Array2D<Int>(columns: maxCount, rows: maxCount, initialValue: 0)
        var maxLong = 0
        for i in 1...num1.count {
            for j in 1...num2.count {
                if num1[i - 1] == num2[j - 1] {
                    dp[i, j] = dp[i - 1, j - 1] + 1
                } else {
                    dp[i, j] = max(dp[i - 1, j], dp[i, j - 1])
                }
                maxLong = max(maxLong, dp[i,j])
            }
        }
        print("最长 ：\(maxLong)")
        print(dp)
    }
    
    class func longestCommonSeq(num1: [Int], num2: [Int]) -> Int {
        if num1.count == 0 || num1.count == 0 {
            return 0
        }
        return longestCommonSeq(num1: num1, i: num1.count, num2: num2, j: num2.count)
    }
    
    class func longestCommonSeq(num1: [Int],i: Int, num2: [Int], j: Int) -> Int {
        // 递归基
        if i == 0 || j == 0 {
            return 0
        }
        if num1[i - 1] == num2[j - 1] {
            return longestCommonSeq(num1: num1, i: i - 1, num2: num2, j: j - 1) + 1
        } else {
            return max(longestCommonSeq(num1: num1, i: i , num2: num2, j: j - 1),
                       longestCommonSeq(num1: num1, i: i - 1, num2: num2, j: j))
        }
    }
    
    /// 最长公共子串问题
    /// ◼最长公共子串(Longest Common Substring)
    /// 子串是连续的子序列
    /// ◼ 求两个字符串的最长公共子串长度
    /// ABCBA 和 BABCA 的最长公共子串是 ABC，长度为 3
    class func longestCommonStr() {
        let str1 = [1,2,3,2,1]
        let str2 = [2,1,2,3,1]
        print(longestCommonStr(str1: str1, str2: str2))
    }
    class func longestCommonStr(str1: [Int], str2: [Int]) -> Int {
        // dp[i][j]: str1以str1[i -1]与 str2以 str2[j-1] 的最长公共子串
        // dp[0][j] = 0 dp[i][0] = 0
        if str1.count == 0 || str2.count == 0{
            return 0
        }
        return longestCommonSeq(num1: str1, i: str1.count - 1 , num2: str2, j: str2.count - 1)
    }
    
    class func longestCommonStr(str1: [Int], i: Int, str2: [Int], j: Int) -> Int {
        // dp[i][j]: str1以i-1与 str2以j-1的最长公共子串
        // dp[0][j] = 0 dp[i][0] = 0
        
        if i == 0 || j == 0 {
            return 0
        }
        if str1[i - 1] == str2[j - 1] {
            return longestCommonSeq(num1: str1, i: i - 1, num2: str2, j: j - 1) + 1
        } else {
            return 0
        }
    }
    
    class func longestCommonStr2() {
        let str1 = [1,2,3,2,1]
        let str2 = [2,1,2,3,1]
        var dp = Array2D<Int>(columns: str2.count + 1, rows: str2.count + 1, initialValue: 0)
        var maxLong = 0
        for i in 1...str1.count {
            for j in 1...str2.count {
                if str1[i - 1] == str2[j - 1] {
                    dp[i, j] = dp[i - 1, j - 1] + 1
                } else {
                    dp[i, j] = 0
                }
                maxLong = max(maxLong, dp[i, j])
            }
        }
        print(maxLong)
        print(dp)
    }
    
    class func bag() {
        let values = [6,3,5,4,6]
        let weights = [2,2,6,5,4]
        // dp[i][j] = 在前i个物品中，挑选总重量为j的 最大价值
        let capacity = 10
        
        // 看最后一个
        // 最后一个有两种选择， 选与不选
        // 如果没有超重 weights[j] < capacity
            // 如果最后一个不选， 那么 dp[i][j] = dp[i - 1][j]
            // 如果选最后一个 那么 dp[i][j] = value[i - 1] + dp[i - 1][j - value[i - 1]]
            // dp[i][j] = max(a,b)
        // 如果超重了.选不了了。物品往前选小的
            // dp[i][j] = dp[i - 1][j]
        
        var dp = Array2D<Int>(columns: capacity + 1, rows: capacity + 1, initialValue: 0)
        var maxV = 0
        for i in 1...values.count {
            for j in 1...capacity {
                // 不可以选了
                if j < weights[i - 1] {
                    dp[i,j] = dp[i - 1 ,j]
                } else {
                    dp[i , j] = max( dp[i - 1,j], values[i - 1] + dp[i - 1, j - weights[i - 1]] )
                }
                maxV = max(maxV, dp[i ,j])
            }
        }
        print(maxV)
        print(dp)
    }
}

extension DP {
    class func test() {
//        print(changeCoins3(money: 19))
//        maxSubArray()
//        maxSub()
//        longestIncreastSeq()
//        _ = longestIncreastSeq2(nums: [10,9,2,5,3,7,101,18])
//        longestCommonSeq()
        
//        let num1 = [1,3,4,5,7,9]
//        let num2 = [1,4,7,9]
//        print(longestCommonSeq(num1: num1, num2: num2))
        
//        longestCommonStr()
//        longestCommonStr2()
        
        bag()
        var array = Array2D<Int>(columns: 3, rows: 4, initialValue: 0)
        array[2,1] = 4
        print(array)
    }
}


/// 剪绳子
/// 长度为N的绳子，剪成M段。 n1*n2*n3.. 最大和
func maxProductAfterCuting(length: Int) -> Int {
    if length == 0 {
        return 0
    }
    if length == 1 {
        return length
    }
    if length == 2 {
        return 1
    }
    if length == 3 {
        // 1 * 2
        return 2
    }
    var dp = Array<Int>(repeating: 0, count: length + 1)
    dp[0] = 0
    dp[1] = 1
    dp[2] = 1
    dp[3] = 2
    for idx in 4..<length {
        var maxP = 0
        for i in 1...idx/2 {
            let v = dp[i] * dp[idx - i]
            if maxP < v {
                maxP = v
                dp[idx] = maxP
            }
        }
    }
    print(dp)
    return dp[length]
}
