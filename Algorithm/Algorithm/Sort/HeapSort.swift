//
//  SelectSort.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/4.
//

import Foundation

class HeapSort: Sort {
    
    override func name() -> String {
        return "堆排序"
    }
    /// 每一趟之后对的大小要-1
    private var heapSize = 0
    /// 堆排序 其实是选择排序的优化，选择排序待优化的点是选取最值的时候都要扫描比较. 堆的特性是直接获取最值
    /// 数组先原地建堆 On)
    /// 下滤 下滤 下滤  -> 性能最好。
    /// O(nlogn)
    override func sort(array: inout [Int]) {
        heapSize = array.count
        // 原地建堆
        heapfiy(array: &array) // O(n)
        for end in (1..<array.count).reversed() {
            swap(end, 0, &array)
            /// 每一步之后，堆的最后一步都是最大的。每一步都要让堆的大小-1
            heapSize -= 1
            // 0位置下滤
            sifdDown(index: 0,array: &array) // O(logn)
        }
    }
    private func heapfiy(array: inout [Int]) {
        let noLeafCount = array.count / 2
        let lastNoleafIndex = noLeafCount - 1
        for idx in (0...lastNoleafIndex).reversed() {
            sifdDown(index: idx, array: &array)
        }
    }
    /// index位置下滤
    private func sifdDown(index: Int, array: inout [Int]) {
        var idx = index
        let node = array[idx]
        while idx < heapSize / 2 {
            // 完全二叉堆，要么只有左， 要么有左右，无 有右无左的情况
            // 找最大的子节点比较
            // 默认为左子节点
            var childIdx = 2 * idx + 1
            var child = array[childIdx]
            // 判断是否有右子节点
            let rightIdx = childIdx + 1
            // 有右节点
            if rightIdx < heapSize && compare(array[rightIdx], child) > 0{
                child = array[rightIdx]
                childIdx = rightIdx
            }
            if compare(node, child) > 0 {
                break
            }
            array[idx] = child
            // 让子节点重复操作
            idx = childIdx
        }
        // 最后node归位
        array[idx] = node
    }
}
