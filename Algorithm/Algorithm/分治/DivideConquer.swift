//
//  DivideConquer.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/12.
//

import Foundation

/// 分治： 分而治之 。递归比较实用
//分治，也就是分而治之。它的一般步骤是
//1 将原问题分解成若干个规模较小的子问题(子问题和原问题的结构一样，只是规模不一样)
//2 子问题又不断分解成规模更小的子问题，直到不能再分解(直到可以轻易计算出子问题的解) 3 利用子问题的解推导出原问题的解
//◼ 因此，分治策略非常适合用递归
//◼ 需要注意的是:子问题之间是相互独立的
  
class DivideConquer {
    
    /// 给定一个长度为 n 的整数序列，求它的最大连续子序列和
    /// 比如 –2、1、–3、4、–1、2、1、–5、4 的最大连续子序列和是 4 + (–1) + 2 + 1 = 6
    /// ◼这道题也属于最大切片问题(最大区段，Greatest Slice)
    /// ◼ 概念区分
    /// 子串、子数组、子区间必须是连续的，子序列是可以不连续的
    
    class func maxSubArray() {
        let array = [-2,1,-3,4,-1,2,1,-5,4]
//        let max = maxSub2(array: array)
//        let max = maxSub(array: array)
        
        // 左闭右开 [begin, end)
        let max = maxSub(array: array, begin: 0, end: array.count)
        print(max)
    }
    
    /// 求begin - end 之间的最大连续序列和
    class func maxSub(array:[Int], begin: Int, end: Int) -> Int{
        // 只有一个了
        if end - begin < 2 {
            return array[begin]
        }
        
        /// 求出 左边最大序列 右边最大序列。  左右都包含的最大序列
        /// 只会有这三种情况
        
        var resultMax = Int.min
        let mid = (begin + end) >> 1
        
        // 1.单边情况
        // 左边的最大和
        let singleLeftMax = maxSub(array: array, begin: begin, end: mid)
        // 右边的最大和
        let singleRightMax = maxSub(array: array, begin: mid, end: end)
        resultMax = max(singleLeftMax, singleRightMax)
        
        // 2.第三种情况是， 最大连续和序列不在单边，左右都有
        
        // 左边的部分 mid 往左走，找出最大和
        var leftMax = Int.min
        var leftSum = 0
        
        for leftIdx in (begin..<mid).reversed() {
            leftSum += array[leftIdx]
            leftMax = max(leftMax, leftSum)
        }
        
        // 右边的部分 mid 往右走，找出最大和
        var rightMax = Int.min
        var rightSum = 0
        for rightIdx in mid..<end {
            rightSum += array[rightIdx]
            rightMax = max(rightMax, rightSum)
        }
        let midMax = leftMax + rightMax
        resultMax = max(midMax, resultMax)
        
        return resultMax
    }
    
    
    
    /// 暴力出奇迹 O(N^3)
    class func maxSub(array: [Int]) -> Int {
        var maxValue = Int.min
        for begin in 0..<array.count {
            for end in begin..<array.count {
                // 求出【begin end】之间的和的最大值
                let sum = seqTotal(array: array, begin: begin, end: end)
                maxValue = max(maxValue, sum)
            }
        }
        return maxValue
    }
    
    
    /// 暴力计算，优化版本.减少重复计算 O(n^2)
    class func maxSub2(array: [Int]) -> Int {
        var maxValue = Int.min
        for begin in 0..<array.count {
            var sum = 0
            for end in begin..<array.count {
                sum += array[end]
                maxValue = max(sum, maxValue)
            }
        }
        return maxValue
    }
    
    class func seqTotal(array: [Int], begin: Int, end: Int) -> Int{
        var sum = 0
        for idx in begin...end {
            sum += array[idx]
        }
        return sum
    }
}

extension DivideConquer {
    class func DivideConquerTest() {
        maxSubArray()
    }
}
