//
//  SelectSort.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/4.
//

import Foundation

class SelectSort: Sort {
    
    override func name() -> String {
        return "选择排序"
    }
    
    /// 选择排序
    /// 在冒泡排序的基础上，少了交换次数.每一趟都选择一个最大的放在最后面. 下一趟忽略这个最大的
    /// O(n^2)
    override func sort(array: inout [Int]) {
        for end in (1..<array.count).reversed() {
            /// 默认第0个最大
            var maxIndex = 0
            for begin in 1...end {
                if compare(array[begin], array[maxIndex]) > 0 {
                    // 打擂台
                    maxIndex = begin
                }
            }
            /// 最大的那个，跟最后一个交换
            swap(maxIndex, end, &array)
        }
    }
}
