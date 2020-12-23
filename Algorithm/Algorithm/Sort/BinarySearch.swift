//
//  BinarySearch.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/4.
//

import Foundation

/// 二分查找
class BinarySearch {
    
    /// 二分查找
    /// - Parameters:
    ///   - value: 查找的值
    ///   - array: 数组
    /// - Returns: 索引，查不到返回 -1
    public class func indexOf(value: Int, array:[Int]) -> Int {
        var begin = 0
        var end = array.count
        while begin != end {
            let mid = begin + (end - begin) / 2 // 减少溢出
            if value < array[mid] {
                end = mid
            } else if value > array[mid] {
                begin = mid
            } else {
                return mid
            }
        }
        return -1
    }
    
    public class func test() {
        let array = [1,2,3,4,5,6,7,8,9]
        let idx = indexOf(value: 9, array: array)
        print(idx)
    }
}
