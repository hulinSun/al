//
//  SelectSort.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/4.
//

import Foundation

class ShellSort: Sort {
    
    override func name() -> String {
        return "希尔排序"
    }
    
    override func sort(array: inout [Int]) {
        // {8,4,2,1}
        let steps = stepSeq(count: array.count)
        // 分多少个列
        for step in steps {
            shellSort(step: step, array: &array)
        }
    }
    private func stepSeq(count: Int) -> [Int] {
        var step = [Int]()
        var c = count
        while  c > 0 {
            c = c >> 1
            step.append(c)
        }
        return step
    }
    
    
    /// 对插入排序的优化
    /// - Parameters:
    ///   - step: 步长
    ///   - array: array
    private func shellSort(step: Int, array: inout [Int]) {
        // col: 列数。 step 步长
        for col in 0..<step {
            for begin in col + step ..< array.count {
                // 默认第一个是排好序的。
                var cur = begin
                while cur > 0 {
                    if compare(array[cur], array[cur - col]) < 0 {
                        swap(cur, cur - col, &array)
                    }
                    cur -= col
                }
            }
        }
    }
    
}

/**
public class ShellSort<T extends Comparable<T>> extends Sort<T> {
    @Override
    protected void sort() {
        List<Integer> stepSequence = shellStepSequence();
        for (Integer step : stepSequence) {
            sort(step);
        }
    }
    
    /**
     * 分成step列进行排序
     */
    private void sort(int step) {
        // col : 第几列，column的简称
        for (int col = 0; col < step; col++) { // 对第col列进行排序
            // col、col+step、col+2*step、col+3*step
            for (int begin = col + step; begin < array.length; begin += step) {
                int cur = begin;
                while (cur > col && cmp(cur, cur - step) < 0) {
                    swap(cur, cur - step);
                    cur -= step;
                }
            }
        }
    }
    
    private List<Integer> shellStepSequence() {
        List<Integer> stepSequence = new ArrayList<>();
        int step = array.length;
        while ((step >>= 1) > 0) {
            stepSequence.add(step);
        }
        return stepSequence;
    }
    
}
 */
