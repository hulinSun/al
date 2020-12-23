//
//  SelectSort.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/4.
//

import Foundation

class QuickSort {
    private var array: [Int]
    init(data: [Int]) {
        array = data
        sort(begin: 0, end: array.count - 1)
        print("\n【快速排序】:\n\(array)")
    }
    
    private func sort(begin: Int, end: Int) {
        if end - begin < 1 {
            return
        }
        let pivotIdx = pivotIndex(begin: begin, end: end)
        sort(begin: begin, end: pivotIdx)
        sort(begin: pivotIdx + 1, end: end)
    }
   
    
    /// 确定轴点
    /// - Parameters:
    ///   - begin: 开始位置
    ///   - end: 结束位置
    /// - Returns: 轴点idx
    private func pivotIndex(begin: Int, end: Int) -> Int {
        
        // 快速排序的稳定性，最差能到O(n^2) . 如 7123456. 也就是说，总是在轴点一遍
        // 保持快速排序的稳定性： 初始轴点随机
        // 随机交换.将后面的元素随机取出一个，跟begin位置交换
        
        let randomIdx = randomPivotIdx(begin: begin, end: end)
        swap(idx1: randomIdx, idx2: begin)
        // 默认轴点点第一个
        let pivot = array[begin]
        var endIdx = end
        var beginIdx = begin
        while beginIdx < endIdx {
            // 右边
            while beginIdx < endIdx && pivot < array[endIdx]{
                endIdx -= 1
            }
            // 右边找到了比轴点小的元素了。换过去
            array[beginIdx] = array[endIdx]

            while beginIdx < endIdx && pivot > array[beginIdx] {
                beginIdx += 1
            }
            // 左边找到了比轴点大的元素了
            array[endIdx] = array[beginIdx]
        }

        array[beginIdx] = pivot
        return beginIdx
    }
    
    private func randomPivotIdx(begin: Int , end: Int) -> Int {
        let number = Int.random(in: begin..<end)
        return number
    }
    
    private func swap(idx1: Int, idx2: Int) {
        let temp = array[idx1]
        array[idx1] = array[idx2]
        array[idx2] = temp
    }
    
//    private func pivotIndex(begin: Int, end: Int) -> Int {
//        // 默认轴点点第一个
//        let pivot = array[begin]
//        var endIdx = end
//        var beginIdx = begin
//        while beginIdx < endIdx {
//            // 右边
//            while beginIdx < endIdx {
//                if pivot < array[endIdx] {
//                    endIdx -= 1
//                } else {
//                    // 右边找到了比轴点小的元素了。换过去
//                    array[beginIdx] = array[endIdx]
//                    beginIdx += 1
//                    break
//                }
//            }
//            while beginIdx < endIdx {
//                if pivot > array[beginIdx]  {
//                    beginIdx += 1
//                } else {
//                    // 左边找到了比轴点大的元素了
//                    array[endIdx] = array[beginIdx]
//                    endIdx -= 1
//                    break
//                }
//            }
//        }
//        array[beginIdx] = pivot
//        return beginIdx
//    }
}
