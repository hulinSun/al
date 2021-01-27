//
//  LeeDFS.swift
//  Algorithm
//
//  Created by 孙虎林 on 2021/1/11.
//

import Foundation

/// 排列组合相关的，DFS解决
/// 电话号码组合
/// 给定一个仅包含数字 2-9 的字符串，返回所有它能表示的字母组合。
/// 给出数字到字母的映射如下（与电话按键相同）。注意 1 不对应任何字母。
/// 输入："23" 输出：["ad", "ae", "af", "bd", "be", "bf", "cd", "ce", "cf"].
/// https://leetcode-cn.com/problems/letter-combinations-of-a-phone-number/

class NumberSolution {
    
    private var data: Array<String>!
    private var result: Array<Character>!
    private var cs: Array<Character>!
    let numbers: Dictionary<Character,[Character]> = [
        "2": ["a","b","c"],
        "3": ["d","e","f"],
        "4": ["g","h","i"],
        "5": ["j","k","l"],
        "6": ["m","n","o"],
        "7": ["p","q","r","s"],
        "8": ["t","u","v"],
        "9": ["w","x","y","z"],
    ]
    
    
    func letterCombinations(_ digits: String) -> [String] {
        if digits.count == 0 {
            return [String]()
        }
        result = Array<Character>(repeating: " ", count: digits.count)
        cs = Array<Character>(repeating: " ", count: digits.count)
        data = Array<String>()
        for (i,c) in digits.enumerated() {
            cs[i] = c
        }
        dfsNumbers(idx: 0)
        return data
    }

    func dfsNumbers(idx: Int) {
        if idx == result.count{
            // 满了
            data.append(String(result))
            return
        }
        // 字母
        let chs = numbers[cs[idx]]!
        for item in chs {
            result[idx] = item
            dfsNumbers(idx: idx + 1)
        }
    }
    
    class func test() {
        print(NumberSolution().letterCombinations("23"))
    }
}


/// 全排列
/// 链接：https://leetcode-cn.com/problems/permutations
/// 给定一个 没有重复 数字的序列，返回其所有可能的全排列。
/// 输入: [1,2,3]
/// 输出:
/// [
/// [1,2,3],
/// [1,3,2],
/// [2,1,3],
/// [2,3,1],
/// [3,1,2],
/// [3,2,1]
/// ]

class PermuteSoultion {
    
    private var data: Array<Array<Int>>!
    // 已经选择过得
    private var sel: Array<Int>!
    // 总的数字
    private var cs: Array<Int>!
    
    func permute(_ nums: [Int]) -> [[Int]] {
        if nums.count == 0 {
            return [[Int]]()
        }
        cs = Array<Int>(nums)
        sel = Array<Int>(repeating: 0, count: nums.count)
        data = [[Int]]()
        dfs(idx: 0)
        return data
    }
    
    func dfs(idx: Int) {
        if idx == cs.count {
            // 结果
            data.append(sel)
            return
        }
        
        // 全部 - 已经选择过 = 可选项
        let can = getCan()
        for item in can {
            sel[idx] = item
            dfs(idx: idx + 1)
            // 还原现场
            sel[idx] = 0
        }
    }
    
    func getCan() -> [Int] {
        return cs.filter { (item) -> Bool in
            return !sel.contains(item)
        }
    }
    
    class func test() {
        print(PermuteSoultion().permute([1,2,3]))
    }
}

class PermuteSoultion2 {
    
    private var data: Array<Array<Int>>!
    // 已经选择过得
    private var sel: Array<Int>!
    
    private var used: Array<Bool>!
    // 总的数字
    private var cs: Array<Int>!
    
    func permute(_ nums: [Int]) -> [[Int]] {
        if nums.count == 0 {
            return [[Int]]()
        }
        cs = Array<Int>(nums)
        sel = Array<Int>(repeating: 0, count: nums.count)
        used = Array<Bool>(repeating: false, count: nums.count)
        data = [[Int]]()
        dfs(idx: 0)
        return data
    }
    
    func dfs(idx: Int) {
        if idx == cs.count {
            data.append(sel)
            return
        }
        // 全部 - 已经选择过 = 可选项
        for (i, item) in cs.enumerated() {
            if used[i] {
                continue
            }
            // 注意这里是idx
            sel[idx] = item
            // 这里是i
            used[i] = true
            dfs(idx: idx + 1)
            used[i] = false
            
        }
    }
    class func test() {
        print(PermuteSoultion2().permute([1,2,3]))
    }
}

class PermuteSoultion3 {
    
    private var data: Array<Array<Int>>!
    // 总的数字
    private var cs: Array<Int>!
    
    func permute(_ nums: [Int]) -> [[Int]] {
        if nums.count == 0 {
            return [[Int]]()
        }
        cs = Array<Int>(nums)
        data = [[Int]]()
        dfs(idx: 0)
        return data
    }
    
    func dfs(idx: Int) {
        if idx == cs.count {
            data.append(cs)
            return
        }
        for i in idx..<cs.count {
            swap(i: i, j: idx)
            dfs(idx: idx + 1)
            // 还原现场
            swap(i: i, j: idx)
        }
    }
    func swap(i: Int , j: Int) {
        let temp = cs[i]
        cs[i] = cs[j]
        cs[j] = temp
    }
    class func test() {
        print(PermuteSoultion3().permute([1,2,3]))
    }
}





// https://leetcode-cn.com/problems/generate-parentheses/
//数字 n 代表生成括号的对数，请你设计一个函数，用于能够生成所有可能的并且 有效的 括号组合。
//输入：n = 3
//输出：[
//       "((()))",
//       "(()())",
//       "(())()",
//       "()(())",
//       "()()()"
//     ]

class ParenthesisSolution {
    /// 只有"(" “)”当剩余的个数相等时，才选"("
    var data = [String]()
    var sel: Array<Character>!
    
    func generateParenthesis(_ n: Int) -> [String] {
        if n < 0 {
            return data
        }
        sel = Array<Character>(repeating: " ", count: 2 * n)
        dfs(idx: 0, level: n, left: n, right: n)
        return data
    }
    
    func dfs(idx: Int, level: Int, left: Int, right: Int) {
        if idx == 2 * level {
            data.append(String(sel))
            return
        }
        // 选左边： 只要 leftRemain > 0 就能选
        // 选右边: rightRemain> 0 && rightRemain != leftRemain
        if left > 0 {
            sel[idx] = "("
            dfs(idx: idx + 1, level: level, left: left - 1,right: right)
        }
        if right > 0 && left != right {
            sel[idx] = ")"
            dfs(idx: idx + 1, level: level, left: left ,right: right - 1)
        }
    }
    class func ParenthesisSolutionTest() {
        print(ParenthesisSolution().generateParenthesis(1))
    }
}

/// 矩阵中是否某个字符串的路径
/// 只能上下左右移动一格
class MatrixPathSolution {
        
    private var matrix: [[Character]]!
    private var cs: [Character]!
    private var length = 0
    private var visted: Array2D<Bool>!
    private var rows = 0
    private var cols = 0
    func generateParenthesis(nums:[[Character]], str: String) -> Bool {
        if nums.count == 0 || str.count == 0 {
            return false
        }
        matrix = nums
        cs = Array<Character>(repeating: " ", count:str.count)
        visted = Array2D<Bool>(columns: nums[0].count, rows: nums.count, initialValue: false)
        
        for (i,c) in str.enumerated() {
            cs[i] = c
        }
        rows = nums.count
        cols = nums[0].count
        for r in 0..<nums.count {
            for c in 0..<nums[0].count {
                if hasPath(row: r, col: c) {
                    return true
                }
            }
        }
        return false
    }
    
    func hasPath(row: Int,  col: Int) -> Bool {
        if length == cs.count {
            return true
        }
        var has = false
        if row >= 0 && row < rows  && col >= 0 && col < cols && visted[row,col] == false && matrix[row][col] == cs[length] {
            print(matrix[row][col])
            // 匹配到了
            length += 1
            visted[row,col] = true
            has = hasPath(row: row - 1,col: col) ||
                hasPath(row: row + 1, col: col) ||
                hasPath(row: row, col: col - 1) ||
                hasPath(row: row, col: col + 1)
            
            if has == false {
                // 回溯
                length -= 1
                visted[row,col] = false
            }
        }
        return has
    }
}

/// 机器人的运动范围
class MovingSolution {
    private var visted: Array2D<Bool>!
    private var rows = 0
    private var cols = 0
    private var limit = 0
    
    func canMoveing(r: Int, c: Int, k: Int) -> Int {
        if r <= 0 || c <= 0 || k <= 0 {
            return 0
        }
        rows = r
        cols = c
        limit = k
        visted = Array2D<Bool>(columns: c, rows: r, initialValue: false)
        return canMovingCore(row: 0, col: 0)
    }
    
    func canMovingCore(row: Int, col: Int) -> Int {
        var count = 0
        if row >= 0 && row < rows && col >= 0 && col < cols && canJump(row: row, col: col){
            visted[row,col] = true
            count = 1 + canMovingCore(row: row - 1, col: col) +
                        canMovingCore(row: row + 1, col: col) +
                        canMovingCore(row: row, col: col - 1) +
                        canMovingCore(row: row, col: col + 1)
        }
        return count
    }
    func canJump(row: Int, col: Int) -> Bool {
        // 没访问过且和小于等于k
        if visted[row,col] == false && (getDigNum(num: col) + getDigNum(num: row)) <= limit {
            print("(\(row),\(col))")
            return true
        }
        return false
    }
    
    func getDigNum(num: Int) -> Int {
        if num < 10 {
            return num
        }
        var total = 0
        var a = num
        while a > 0 {
            total += (a % 10)
            a /= 10
        }
        return total
    }
}
