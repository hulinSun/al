//
//  LeeStack_Queue.swift
//  Algorithm
//
//  Created by 孙虎林 on 2021/1/3.
//

/// 栈， 队列相关
import Foundation

public class TreeNode {
     public var val: Int
     public var left: TreeNode?
     public var right: TreeNode?
     public init() { self.val = 0; self.left = nil; self.right = nil; }
     public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
     public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
         self.val = val
         self.left = left
         self.right = right
     }
}


/// 最小栈  https://leetcode-cn.com/problems/min-stack/
/// 设计一个支持 push ，pop ，top 操作，并能在常数时间内检索到最小元素的栈。
/// push(x) —— 将元素 x 推入栈中。
/// pop() —— 删除栈顶的元素。
/// top() —— 获取栈顶元素。
/// getMin() —— 检索栈中的最小元素。

class MinStack {
    private var stack: LStack<Int>
    private var minStack: LStack<Int>
    init() {
        stack = LStack<Int>()
        minStack = LStack<Int>()
    }
    
    func push(_ x: Int) {
        stack.push(element: x)
        if minStack.isEmpty() {
            minStack.push(element: x)
        } else {
            // push一个最小的。
            minStack.push(element: min(x, minStack.top()))
        }
    }
    
    func pop() {
        _ = stack.pop()
        _ = minStack.pop()
    }
    
    func top() -> Int {
        return stack.top()
    }
    
    func getMin() -> Int {
        return minStack.top()
    }
    
}
/// 链表，头插法
class LinkMinStack {
    class MinNode {
        var value: Int
        var min: Int
        var next: MinNode?
        init(val: Int, m: Int) {
            value = val
            min = m
        }
    }
    private var head: MinNode?
    
    func push(_ x: Int) {
        if head == nil {
            head = MinNode(val: x, m: x)
        } else {
            let originHead = head!
            let newNode = MinNode(val: x, m: min(originHead.min, x))
            newNode.next = originHead
            head = newNode
        }
    }
    
    func pop() {
        if head != nil {
            head = head!.next
        }
    }
    
    func top() -> Int {
        if head != nil {
            return head!.value
        }
        return 0
    }
    
    func getMin() -> Int {
        if head != nil {
            return head!.min
        }
        return 0
    }
}



/// https://leetcode-cn.com/problems/sliding-window-maximum/
/// 给你一个整数数组 nums，有一个大小为 k 的滑动窗口从数组的最左侧移动到数组的最右侧。你只可以看到在滑动窗口内的 k 个数字。滑动窗口每次只向右移动一位。
/// 返回滑动窗口中的最大值。
/// 滑动窗口的最大值
func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
    if nums.count == 0  || k < 1 {
        return []
    }
    if k == 1 {
        return nums
    }
    var result = Array<Int>(repeating: 0, count: nums.count - k + 1)
    // 保证队列从大到小.存放的是索引
    // 队尾添加数据， 队头是最大的
    // 单调队列
    let dequ = LDQueue<Int>()
    for (idx, item) in nums.enumerated() {
        // 跟队尾比较。如果大于队尾，删除直到小于队尾
        while !dequ.isEmpty() && nums[dequ.rear()] < item {
            _ = dequ.deQueueRear()
        }
        dequ.enQueueRear(element: idx)
        // 检查是否过界了了
        let w = idx - k + 1
        if dequ.front() < w {
            _ = dequ.deQueueFront()
        }
        if w >= 0 {
            result[w] = nums[dequ.front()]
        }
        dequ.display()
    }
    return result
}

func windowTest() {
    let nums = [1,7,5,3,-3,-1,8,2]
    print(maxSlidingWindow(nums, 3))
}


/// 最大二叉树
/// https://leetcode-cn.com/problems/maximum-binary-tree/
/// 给定一个不含重复元素的整数数组 nums 。一个以此数组直接递归构建的 最大二叉树 定义如下：
/// 二叉树的根是数组 nums 中的最大元素。
/// 左子树是通过数组中 最大值左边部分 递归构造出的最大二叉树。
/// 右子树是通过数组中 最大值右边部分 递归构造出的最大二叉树。
/// 返回有给定数组 nums 构建的 最大二叉树 。
func constructMaximumBinaryTree(_ nums: [Int]) -> TreeNode? {
    /// 返回根节点
    /// - Parameters:
    ///   - nums: nums
    ///   [left, right)
    func findRoot(_ nums: [Int], left: Int, right: Int) -> TreeNode? {
        if nums.count == 0 {
            return nil
        }
        if left == right {
            return nil
        }
        // 最大的为根节点
        var maxIdx = left
        for idx in left..<right {
            if nums[maxIdx] < nums[idx] {
                maxIdx = idx
            }
        }
        let leftNode = findRoot(nums, left: left, right: maxIdx)
        // 这里跳过一个。
        let rightNode = findRoot(nums, left: maxIdx + 1, right: right)
        let root = TreeNode(nums[maxIdx], leftNode, rightNode)
        return root
    }
    return findRoot(nums, left: 0, right: nums.count)
}

// 变种: 返回一个数组，数组里面存着每个节点的父节点的索引(如果没有父节点，就存-1)
// 利用栈求左边,右边第一个比他大的数  -> 单调栈
// 保持栈由底到顶是递减的
// push的时候，栈顶是左边第一个比他大的元素
// pop的时候，待加入的元素是栈顶元素右边第一个比他大的元素
func findParents(_ nums: [Int]) -> [Int] {
    print(nums)
    // 左边第一个比他大的数的idx
    var lefts = Array<Int>(repeating: -1, count: nums.count)
    // 右边第一个比他大的数的idx
    var rights = Array<Int>(repeating: -1, count: nums.count)
    let stack = LStack<Int>()
    var result = Array<Int>(repeating: -1, count: nums.count)
    
    for (idx, item) in nums.enumerated() {
        if stack.isEmpty() {
            stack.push(element: idx)
        } else {
            // 如果栈顶元素小于待插入的元素。
            while !stack.isEmpty() && item > nums[stack.top()] {
                // pop
                let popIdx = stack.pop()
                rights[popIdx] = idx
            }
            if !stack.isEmpty() {
                let topIdx = stack.top()
                lefts[idx] = topIdx
            }
            stack.push(element: idx)
        }
    }
    
    print("左边第一个大的idx: \(lefts)")
    print("右边第一个大的idx: \(rights)")
    
    for idx in 0..<result.count {
        if lefts[idx] == -1 && rights[idx] == -1 {
            result[idx] = -1
            continue
        }
        if lefts[idx] == -1 {
            result[idx] = rights[idx]
            continue
        }
        if rights[idx] == -1 {
            result[idx] = lefts[idx]
            continue
        }
        // 父节点的索引是较小的那一个
        if nums[lefts[idx]] < nums[rights[idx]] {
            result[idx] = lefts[idx]
        } else {
            result[idx] = rights[idx]
        }
    }
    print("父节点: \(result)")
    return result
}

func parentsTest() {
    let nums = [3,2,1,6,0,5]
    _ = findParents(nums)
}


/// 每日温度
/// 对应位置的输出为：要想观测到更高的气温，至少需要等待的天数。如果气温在这之后都不会升高，请在该位置用 0 来代替。
/// 例如，给定一个列表 temperatures = [73, 74, 75, 71, 69, 72, 76, 73]，你的输出应该是 [1, 1, 4, 2, 1, 1, 0, 0]。
/// 提示：气温 列表长度的范围是 [1, 30000]。每个气温的值的均为华氏度，都是在 [30, 100] 范围内的整数。
///
/// 求右边第一个大的数与当前数的差值
func dailyTemperatures(_ T: [Int]) -> [Int] {
    print(T)
    var rights = Array<Int>(repeating: -1, count: T.count)
    var result = Array<Int>(repeating: 0, count: T.count)
    let stack = LStack<Int>()
    for (idx, item) in T.enumerated() {
        if stack.isEmpty() {
            stack.push(element: idx)
        } else {
            while !stack.isEmpty() && T[stack.top()] < item {
                let topIdx = stack.pop()
                rights[topIdx] = idx
            }
            stack.push(element: idx)
        }
    }
    print("rights = \(rights)")
    for idx in 0..<T.count {
        print("当前遍历到 \(T[idx])")
        if rights[idx] != -1 {
            print("第一个比他大的数 \(T[rights[idx]])")
            result[idx] = rights[idx] - idx
        }
    }
    print(result)
    return result
}

func dailyTemperaturesTest() {
    let nums =  [73, 74, 75, 71, 69, 72, 76, 73]
    _ = dailyTemperatures(nums)
}
