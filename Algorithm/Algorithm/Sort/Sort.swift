//
//  Sort.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/3.
//

import Foundation

class Sort: CustomStringConvertible {
    
    /// 比较次数
    private var compareCount: Int = 0
    /// 交换次数
    private var swapCount: Int = 0
    private var array: [Int]
    init(data: [Int]) {
        array = data
        sort(array: &array)
    }
    
    public func sort(array: inout [Int]) {
        /// 子类实现
    }
    
    public func name() -> String {
        /// 子类实现
        return ""
    }
    
    public func swap(_ index1: Int, _ index2: Int, _ array: inout [Int]) {
        swapCount+=1
        let temp = array[index1]
        array[index1] = array[index2]
        array[index2] = temp
    }
    
    public func compare(_ value1: Int , _ value2: Int) -> Int {
        compareCount+=1
        return value1 - value2
    }
    
    var description: String {
        let nm = name()
        var s = "\n【\(nm)】:\n"
        s += "比较结果: \(array)"
        s += "\n"
        s += "比较次数: \(compareCount) \t 交换次数: \(swapCount)"
        s += "\n"
        return s
    }
}

extension Sort {
    public class func test() {
        let array = Int.randomArray()
        print("原始数组: \(array) \n")

        let bubble = BubbleSort(data: Int.arrayCopy(array: array))
        print(bubble)

        let selectSort = SelectSort(data: Int.arrayCopy(array: array))
        print(selectSort)

        let heapSort = HeapSort(data: Int.arrayCopy(array: array))
        print(heapSort)

        let insertSort = InsertSort(data: Int.arrayCopy(array: array))
        print(insertSort)
        
        let mergeSort = MergeSort(data: Int.arrayCopy(array: array))
        let result = mergeSort.mergeSort(array: Int.arrayCopy(array: array))
        print("\n【归并排序】:\n\(result)")
//        BinarySearch.test()
        
        _ = QuickSort(data: Int.arrayCopy(array: array))
        
        let countSort = CountSort(data: Int.arrayCopy(array: array))
        print(countSort)
    }
}

extension Int {
    private static func randoms(eleCount: Int, maxRandom: Int) -> [Int] {
        var result = Array<Int>()
        while result.count < eleCount {
            let number = Int(arc4random() % UInt32(maxRandom))
            if !result.contains(number) {
                result.append(number)
            }
        }
        return result
    }
    public static func randomArray() -> [Int] {
        return randoms(eleCount: 10, maxRandom: 40)
    }
    public static func arrayCopy(array: [Int]) -> [Int] {
        var newArray = Array<Int>()
        newArray.append(contentsOf: array)
        return newArray
    }
}
