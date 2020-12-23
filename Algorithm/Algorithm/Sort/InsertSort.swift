//
//  SelectSort.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/4.
//

import Foundation

/// 插入排序
class InsertSort: Sort {
    
    override func name() -> String {
        return "插入排序"
    }
    
    /// 插入排序吧数组抽象成两部分
    /// 左边是排好序的 ，右边是未排好序的
    /// 扑克牌
    /// 假设数组第0个就是你手里的牌，后面待排序的牌是你将要抓的牌
    override func sort(array: inout [Int]) {
        for idx in 1..<array.count {
            let dest = searchIndex(idx: idx, array: array)
            insert(idx: idx, destIndex: dest, array: &array)
        }
    }
    
    
    
    ///  将idx位置数据插入目标位置去
    /// - Parameters:
    ///   - idx: idx
    ///   - destIndex: 目标
    ///   - array: 数组
    private func insert(idx: Int, destIndex: Int, array: inout [Int]) {
        let toValue = array[idx]
        for move in (destIndex..<idx).reversed() {
            array[move + 1] = array[move]
        }
        array[destIndex] = toValue
    }
    
    private func searchIndex(idx: Int, array: [Int]) -> Int {
        var begin = 0
        var end = idx
        let toValue = array[idx]
        while begin < end {
            let mid = (begin + end) / 2
            if compare(toValue, array[mid]) < 0{
                end = mid
            } else {
                begin = mid + 1
            }
        }
        return begin
    }
    
    // 挪动
//    override func sort(array: inout [Int]) {
//        for idx in 1..<array.count {
//            var current = idx
//            // 先存一下current. 最后在插入。
//            let currentValue = array[current]
//            while current > 0 {
//                // 只要插入的值比左边的小，那么左边的都往后挪动下
//                if compare(currentValue, array[current - 1]) < 0{
//                    // 挪动
//                    array[current] = array[current - 1]
//                }
//                current -= 1
//            }
//            array[current] = currentValue
//        }
//    }
    
    // 交换
//    override func sort(array: inout [Int]) {
//        for idx in 1..<array.count {
//            var current = idx
//            while current > 0 {
//                // 只要小，就交换.但是交换次数太多了
//                if compare(array[current], array[current - 1]) < 0{
//                    swap(current, current-1, &array)
//                }
//                current -= 1
//            }
//        }
//    }
    
    // 一次性挪动
//    override func sort(array: inout [Int]) {
//        for idx in 1..<array.count {
//            /// idx 左边都是排好序的牌
//            var current = idx
//            let toInsertValue = array[current]
//            while current > 0 {
//                // 在左边排好序的值中，找到插入位置： 即找到第一个比左边大的
//                if compare(toInsertValue, array[current - 1]) < 0{
//                    // 继续往左找
//                    current -= 1
//                } else {
//                    // 左边已经排好序了。已经比最大的左边还大了。那么直接插入
//                    break
//                }
//            }
//            // 找到了位置。
//            // (current -> idx) 位置往后边挪动
//            /// 注意，从后往前挪动
//            for move in (current..<idx).reversed() {
//                array[move + 1] = array[move]
//            }
//            // 插入
//            array[current] = toInsertValue
//        }
//    }
    
//        protected void sort() {
//            for (int begin = 1; begin < array.length; begin++) {
//                int cur = begin;
//                T v = array[cur];
//                while (cur > 0 && cmp(v, array[cur - 1]) < 0) {
//                    array[cur] = array[cur - 1];
//                    cur--;
//                }
//                array[cur] = v;
//            }
//        }
}
