//
//  BubbleSort.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/4.
//

import Foundation

class BubbleSort: Sort {
    
    override func name() -> String {
        return "冒泡排序"
    }
    
    /**
    protected void sort() {
    for (int end = array.length - 1; end > 0; end--) {
        for (int begin = 1; begin <= end; begin++) {
            if (cmp(begin, begin - 1) < 0) {
                swap(begin, begin - 1);
            }
          }
       }
    }
     */
   
    /**
    override func sort(array: inout [Int]) {
        for end in (1..<array.count).reversed() {
            for idx in 1...end {
                if compare(array[idx - 1],array[idx]) > 0  {
                    // 交换
                    swap(idx - 1, idx, &array)
                }
            }
        }
        print(array)
    }*/
    
    /// 冒泡排序优化版本 .已经是有序的了。那么没必要在交换了。 判断有序的标准是 是否有交换
    /// 但是这种优化的前提是已经是排好序了。如果没有排好序，那么反而徒增三条语句。性能变差。
    /// 第一层，是趟数 。每一趟都是递减的
    /// 第二次是比较交换
    /// 稳定排序： a a .如果排序之后 两个a a 的位置不变，那么算法是稳定的
    /// O(n^2)
    override func sort(array: inout [Int]) {
        for end in (1..<array.count).reversed() {
            var order = true
            for idx in 1...end {
                if compare(array[idx - 1],array[idx]) > 0  {
                    // 交换
                    swap(idx - 1, idx, &array)
                    order = false
                }
            }
            // 如果已经有序了。直接退出外面的循环了
            if order {
                break
            }
        }
    }
}
