//
//  SelectSort.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/4.
//

import Foundation

class MergeSort: Sort {
    
    override func name() -> String {
        return "归并排序"
    }
    
    public func mergeSort(array: [Int]) -> [Int] {
        guard array.count > 1 else { return array }
        let mid = array.count / 2
        let leftArray = mergeSort(array: Array(array[0..<mid]))
        let rightArray = mergeSort(array: Array(array[mid..<array.count]))
        return merge(left: leftArray, right: rightArray)
    }
    
    private func merge(left: [Int], right: [Int]) -> [Int] {
        var result = Array<Int>(repeating: 0, count: left.count + right.count)
        var leftIdx = 0
        let leftEndIdx = left.count
        var rightIdx = 0
        let rightEndIdx = right.count
        
        var resIdx = 0
        while leftIdx < leftEndIdx && rightIdx < rightEndIdx {
            // 左边的比较小
            if compare(left[leftIdx], right[rightIdx]) <= 0{
                result[resIdx] = left[leftIdx]
                leftIdx += 1
            } else {
                result[resIdx] = right[rightIdx]
                rightIdx += 1
            }
            resIdx += 1
        }
        
        // 如果左边有剩余
        while leftIdx < leftEndIdx {
            result[resIdx] = left[leftIdx]
            leftIdx += 1
            resIdx += 1
        }
        // 如果右边有剩余
        while rightIdx < rightEndIdx {
            result[resIdx] = right[rightIdx]
            rightIdx += 1
            resIdx += 1
        }
        return result
    }
    
    private func mergeTwo() {
        
        let array1 = [2,3,4,5,7,100]
        let array2 = [44,46,78,89,123,155]
        var result = Array<Int>(repeating: 0, count: array1.count + array2.count)
        var leftIdx = 0
        let leftEndIdx = array1.count
        var rightIdx = 0
        let rightEndIdx = array2.count
        var resIdx = 0
        
        while leftIdx < leftEndIdx && rightIdx < rightEndIdx {
            // 左边的比较小
            if compare(array1[leftIdx], array2[rightIdx]) <= 0{
                result[resIdx] = array1[leftIdx]
                leftIdx += 1
                resIdx += 1
            } else {
                result[resIdx] = array2[rightIdx]
                rightIdx += 1
                resIdx += 1
            }
        }
        // 能来到这里上边必有一个是结束了
        
        // 如果左边有剩余
        while leftIdx < leftEndIdx {
            result[resIdx] = array1[leftIdx]
            leftIdx += 1
            resIdx += 1
        }
        // 如果右边有剩余
        while rightIdx < rightEndIdx {
            result[resIdx] = array2[rightIdx]
            rightIdx += 1
            resIdx += 1
        }
    }
}
