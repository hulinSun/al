//
//  SelectSort.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/4.
//

import Foundation

class CountSort: Sort {
    
    override func name() -> String {
        return "计数排序"
    }
    
    // 优化思路： 最大值 - 最小值。省去不必要的空间浪费
    override func sort(array: inout [Int]) {
        array = [5,5,3,7,9,12,12,2,10,15,16,4]
        // 寻找最值
        let mvalue = MValue(array: array)
        let max = mvalue.max
        let min = mvalue.min
        
        
        // 计数数组 索引为值的相对位置 (idx + min) ， value为出现次数
        var countArray = Array<Int>(repeating: 0, count: max - min + 1)
        for value in array {
            var idxTimes = countArray[value - min]
            idxTimes += 1
            countArray[value - min] = idxTimes
        }
        print("\n计数数组:")
        prettyPrint(array: countArray)
        // 次数累加 value 这里为idx。 但是跟array中的值有关联
        for idx in 1..<countArray.count {
            // 次数累加
            // 当前索引存放的值 .
            var count = countArray[idx]
            let preCount = countArray[idx - 1]
            
            count += preCount
            countArray[idx] = count
        }
        print("累计之后计数数组:")
        prettyPrint(array: countArray)
        
        // 最终的结果数组
        var result = Array<Int>(repeating: 0, count: array.count)
        
        // 从后往前遍历，保持稳定性
        for idx in (0..<array.count).reversed() {
            // 取出值
            let value = array[idx]
            // 对应计数表的 idx
            let countIdx = value - min
            // 出现次数
            var count = countArray[countIdx]
            count = count - 1 // 此时，count就是新数组的idx
            result[count] = value
            // 次数保存
            countArray[countIdx] = count
        }
        
        // 回写
        array.removeAll()
        array.append(contentsOf: result)
    }
    
    private func MValue(array: [Int]) -> (max: Int , min: Int) {
        var max = array[0]
        var min = array[0]
        for item in array {
            if item > max {
                max = item
            }
            if item < min {
                min = item
            }
        }
        return (max,min)
    }
    
    private func prettyPrint(array: [Int]) {
        var idxStr = "索引:"
        var valueStr = " 值:"
        for (idx, value) in array.enumerated() {
            idxStr += "[\(idx)] "
            valueStr += " \(value)  "
        }
        print(idxStr)
        print(valueStr)
        print("\n")
    }
    
    /// 计数排序
    /// 空间复杂度比较差，取决于最大值
    /// 不能对负数排序
    /// 不稳定  -> 需要优化
//    override func sort(array: inout [Int]) {
//        // 寻找最大值
//        var max = array[0]
//        for item in array {
//            if item > max {
//                max = item
//            }
//        }
//        // 计数数组 索引为值， value为出现次数
//        var countArray = Array<Int>(repeating: 0, count: max + 1)
//        for value in array {
//            var idxTimes = countArray[value]
//            idxTimes += 1
//            countArray[value] = idxTimes
//        }
//
//        // 根据 count 表。算出最后数组
//        // value 代表值
//        // count 代表出现次数
//        // value 已经是从小到大排序好了
//        var arrayIdx = 0
//        for (value, var count) in countArray.enumerated() {
//            while count > 0 {
//                array[arrayIdx] = value
//                arrayIdx += 1
//                count -= 1
//            }
//        }
//    }
}
