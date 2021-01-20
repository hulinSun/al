//
//  leeDP.swift
//  Algorithm
//
//  Created by 孙虎林 on 2021/1/6.
//

import Foundation

/// 礼物的最大价值
/// https://leetcode-cn.com/problems/li-wu-de-zui-da-jie-zhi-lcof/
/// 在一个 m*n 的棋盘的每一格都放有一个礼物，每个礼物都有一定的价值（价值大于0）。
/// 你可以从棋盘的左上角开始拿格子里的礼物，并每次向右或者向下移动一格、直到到达棋盘的右下角。给定一个棋盘及其上面的礼物的价值，请计算你最多能拿到多少价值的礼物？
//[
//  [1,3,1],
//  [1,5,1],
//  [4,2,1]
//]
//解释: 路径 1→3→5→2→1 可以拿到最多价值的礼物

//dp[row,col] = max(dp[row - 1, col],max(row, col - 1)) + grid[row,col]
func maxValue(_ grid: [[Int]]) -> Int {
    if grid.count == 0 {
        return 0
    }
    let row = grid.count
    let col = grid.first!.count
    var dp = Array2D<Int>(columns: col, rows: row, initialValue: 0)
    // dp[0,0] = pre
    let pre = grid.first!.first!
    dp[0,0] = pre
    for row in 0..<grid.count {
        let cols = grid[row]
        for col in 0..<cols.count {
            // 取出当前这个数
            let g = cols[col]
            if row == 0 && col > 0{
                dp[0,col] = dp[0,col - 1] + g
            }
            if col == 0 && row > 0{
                dp[row,0] = dp[row - 1, 0] + g
            }
            if row > 0 && col > 0 {
                dp[row,col] = max(dp[row - 1, col], dp[row, col - 1]) + g
            }
        }
    }
    print(dp)
    return 0
}

func maxValueTest() {
    _ = maxValue( [
            [1,3,1],
            [1,5,1],
            [4,2,1],
    ])
}



/// https://leetcode-cn.com/problems/best-time-to-buy-and-sell-stock/
/// 给定一个数组，它的第 i 个元素是一支给定股票第 i 天的价格。
/// 如果你最多只允许完成一笔交易（即买入和卖出一支股票一次），设计一个算法来计算你所能获取的最大利润。
/// 注意：你不能在买入股票前卖出股票。
/// 输入: [7,1,5,3,6,4]
/// 输出: 5
/// 解释: 在第 2 天（股票价格 = 1）的时候买入，在第 5 天（股票价格 = 6）的时候卖出，最大利润 = 6-1 = 5 。
///      注意利润不能是 7-1 = 6, 因为卖出价格需要大于买入价格；同时，你不能在买入前卖出股票。

func maxProfit(_ prices: [Int]) -> Int {
    if prices.count == 0 {
        return 0
    }
    // 考虑。第i天卖出的最大利润 。求出其中最大的利润即可
    var maxprofit = 0
    // 标记最小买入价格
    var minBuy = prices.first!
    for idx in 1..<prices.count {
        let current = prices[idx]
        if current < minBuy {
            minBuy = current
        }
        maxprofit = max(maxprofit, current - minBuy)
    }
    return maxprofit
}

/// 动态规划解法
func maxProfit2(_ prices: [Int]) -> Int {
    // 可以转化为求最大连续子数组的和
    var detas = Array<Int>(repeating: 0, count: prices.count - 1)
    for idx in 1..<prices.count {
        let realIdx = idx - 1
        detas[realIdx] = prices[idx] - prices[idx - 1]
    }
    print(detas)
    // 求 [-6,4,-2,3,-2] 最大连续子序列和
    // dp[i] 以i为结尾的连续子序列和
    // dp[0] = -6
    // dp[1] = 4
    // dp[2] = 2
    // dp[4] = 5
    // dp[5] = 3
    var dp = Array<Int>(repeating: 0, count: detas.count)
    dp[0] = detas.first!
    var maxDp = dp[0]
    for idx in 1..<detas.count {
        if dp[idx - 1] > 0 {
            dp[idx] = dp[idx - 1] + detas[idx]
        } else {
            dp[idx] = detas[idx]
        }
        maxDp = max(maxDp, dp[idx])
    }
    return maxDp
}

func maxProfitTest() {
    print(maxProfit2([7,1,5,3,6,4]))
}


//链接：https://leetcode-cn.com/problems/edit-distance
//给你两个单词 word1 和 word2，请你计算出将 word1 转换成 word2 所使用的最少操作数 。
//你可以对一个单词进行如下三种操作：
//插入一个字符
//删除一个字符
//替换一个字符
//输入：word1 = "horse", word2 = "ros"
//输出：3
//解释：
//horse -> rorse (将 'h' 替换为 'r')
//rorse -> rose (删除 'r')
//rose -> ros (删除 'e')
func minDistance(_ word1: String, _ word2: String) -> Int {
    var s1 = Array<Character>(repeating: " ", count: word1.count)
    var s2 = Array<Character>(repeating: " ", count: word2.count)
    for (i,c) in word1.enumerated() {
        s1[i] = c
    }
    for (i,c) in word2.enumerated() {
        s2[i] = c
    }
    var dp = Array2D<Int>(columns: s2.count + 1, rows: s1.count + 1, initialValue: 0)
    // dp[i,j] = s1 [0, i) 转换成 s2[0,j) 的最少操作数
    // dp[0,j] = j的长度
    // dp[i,0] = i的长度
    for i in 1...s1.count {
        dp[i,0] = i
    }
    for j in 1...s2.count {
        dp[0,j] = j
    }
    // dp 方程
//    dp[i,j] = dp[i - 1,j] + 1
//    dp[i,j] = dp[i, j - 1] + 1
//    if s1[i - 1] == s2[j - 1] {
//        dp[i.j] = dp[i - 1, j - 1]
//    } else {
//        dp[i.j] = dp[i - 1, j - 1] + 1
//    }
    for row in 1..<dp.rows {
        for col in 1..<dp.columns {
            let top = dp[row - 1,col] + 1
            let left = dp[row, col - 1] + 1
            var x = 0
            // 最后一个字符相等
            if s1[row - 1] == s2[col - 1] {
                x = dp[row - 1, col - 1]
            } else {
                x = dp[row - 1, col - 1] + 1
            }
            dp[row,col] = min(min(top, left), x)
        }
    }
    print(dp)
    return dp[s1.count,s2.count]
}

func minDistanceTest() {
    print(minDistance("horse", "ros"))
    
}

/// https://leetcode-cn.com/problems/longest-palindromic-substring/
/// 给定一个字符串 s，找到 s 中最长的回文子串。你可以假设 s 的最大长度为 1000。
/// 输入: "babad" 输出: "bab" 注意: "aba" 也是一个有效答案。
func longestPalindrome(_ s: String) -> String {
    if s.count == 0 {
        return ""
    }
    var dp = Array2D<Bool>(columns: s.count, rows: s.count, initialValue: false)
    var cs = Array<Character>(repeating: " ", count: s.count)
    for (i,c) in s.enumerated() {
        cs[i] = c
    }
    dp[0,0] = true
    // dp[i,j] 代表 s[i,j] 是否是回文字符串
    var maxLong = 1
    var longStr = ""
    // 从下到上（i由大到小）
    for row in (0..<dp.rows).reversed() {
        // 从左到右（j由小到大）
        for col in row..<dp.columns {
            // 如果长度小于等于1，判断是否相等就好了，两个或者一个字符串
            if col - row <= 1 && cs[row] == cs[col]{
                dp[row,col] = true
                if col - row + 1 > maxLong {
                    longStr = String(cs[row...col])
                    maxLong = col - row + 1
                }
            }
            // 大于两个字符串 .判断 cs[i + 1, j - 1] 是否是回文字符串. 在判断最后一个字符串是否相等
            if col - row > 1 && col > 0 {
                if dp[row + 1, col - 1] && cs[col] == cs[row] {
                    dp[row,col] = true
                    if col - row + 1 > maxLong {
                        longStr = String(cs[row...col])
                        maxLong = col - row + 1
                    }
                }
            }
        }
    }
    print(longStr,maxLong)
    return longStr
}

/// 反转做法
func longestPalindrome3(_ s: String) -> String {
    if s.count == 0 {
        return ""
    }
    let count = s.count
    var cs = Array<Character>(repeating: " ", count: count)
    var rcs = Array<Character>(repeating: " ", count: count)
    for (i,c) in s.enumerated() {
        cs[i] = c
        rcs[count - 1 - i] = c
    }
    print(cs)
    print(rcs)
    var dp = Array2D<Int>(columns: cs.count, rows: cs.count, initialValue: 0)
    var maxLong = 0
    for row in 0..<dp.rows {
        for col in 0..<dp.columns {
            if cs[row] == rcs[col] {
                if row == 0 || col == 0 {
                    dp[row,col] = 1
                } else {
                    dp[row,col] = dp[row - 1, col - 1] + 1
                }
            }
            maxLong = max(maxLong, dp[row,col])
        }
    }
    print(dp)
    
    return ""
}

/// 扩展中心法
func longestPalindrome2(_ s: String) -> String {
    if s.count == 0 {
        return ""
    }
    if s.count == 1 {
        return s
    }
    var cs = Array<Character>(repeating: " ", count: s.count)
    for (i,c) in s.enumerated() {
        cs[i] = c
    }
    var maxLen = 1
    var begin = 0
    // 向外扩展
    for i in 1..<s.count - 1 {
        let spacePali = palindromeLength(cs: cs, l: i, r: (i + 1))
        let iPali = palindromeLength(cs: cs, l: (i-1), r: (i + 1))
        let ma = max(spacePali, iPali)
        if ma > maxLen {
            // 最长的 -> 找到开始索引
            maxLen = ma
            begin = i - (ma - 1) >> 1
        }
    }
    // 漏掉第一个的间隙第一个的判断,
    if maxLen == 1, cs[0] == cs[1] {
        return String(cs[0...1])
    }
    print(maxLen, begin, String(cs[begin..<begin + maxLen]))
    return String(cs[begin..<begin + maxLen])
}

func palindromeLength(cs: [Character],  l: Int,  r: Int) -> Int {
    var left = l
    var right = r
    while left >= 0 && right < cs.count && left < right  && cs[left] == cs[right] {
        left -= 1
        right += 1
    }
    return right - left - 1
}

/**
public String longestPalindrome(String s) {
    if (s.equals(""))
        return "";
    String origin = s;
    String reverse = new StringBuffer(s).reverse().toString(); //字符串倒置
    int length = s.length();
    int[][] arr = new int[length][length];
    int maxLen = 0;
    int maxEnd = 0;
    for (int i = 0; i < length; i++)
        for (int j = 0; j < length; j++) {
            if (origin.charAt(i) == reverse.charAt(j)) {
                if (i == 0 || j == 0) {
                    arr[i][j] = 1;
                } else {
                    arr[i][j] = arr[i - 1][j - 1] + 1;
                }
            }
            if (arr[i][j] > maxLen) {
                maxLen = arr[i][j];
                maxEnd = i; //以 i 位置结尾的字符
            }

        }
    }
    return s.substring(maxEnd - maxLen + 1, maxEnd + 1);
}
*/

func longestPalindromeTest() {
    _ = longestPalindrome3("dadbaabfds")
}

/// 最大连续子数组的和
func maxSubArray(_ nums: [Int]) -> Int {
    if nums.count == 0 {
        return 0
    }
    // dp[i] 以 i为结尾的连续子数组的和
    var dp = Array<Int>(repeating: 0, count: nums.count)
    dp[0] = nums.first!
    var maxDp = dp[0]
    for i in 1..<nums.count {
        if dp[i - 1] > 0 {
            dp[i] = dp[i - 1] + nums[i]
        } else {
            dp[i] = nums[i]
        }
        maxDp = max(maxDp, dp[i])
    }
    return maxDp
}

/// 不同路径
/// 机器人只能向右 向下走 m * n
/// 机器人试图达到网格的右下角（在下图中标记为 “Finish” ）。
/// 问总共有多少条不同的路径？
func uniquePaths(_ m: Int, _ n: Int) -> Int {
    // 3 * 2
    var dp = Array2D(columns: m, rows: n, initialValue: 0)
    for idx in 0..<m {
        dp[0,idx] = 1
    }
    for idx in 0..<n {
        dp[idx,0] = 1
    }
    for col in 1..<m {
        for row in 1..<n {
            dp[row,col] = dp[row - 1, col] + dp[row, col - 1]
        }
    }
    
    return dp[n - 1 , m - 1]
}

//https://leetcode-cn.com/problems/search-in-rotated-sorted-array/
/// 搜索旋转数组
func search(_ nums: [Int], _ target: Int) -> Int {
    if nums.count == 0 {
        return -1
    }
    if nums.count == 1 {
        return nums[0] == target ? 0 : -1
    }
    // 大于两个
    var left = 0
    var right = nums.count - 1
    while left <= right {
        let mid = (left + right) / 2
        if target == nums[mid] {
            return mid
        }
        // 先判断那边是有序的
        // 左边是有序的。在左边找
        if nums[0] <= nums[mid]{
            if nums[0] <= target && target < nums[mid] {
                right = mid - 1
            } else {
                left = mid + 1
            }
        } else {
            // 右边是有序的
            if target > nums[mid] && target <= nums[nums.count - 1] {
                left = mid + 1
            } else {
                right = mid - 1
            }
        }
    }
    return -1
}

/// https://leetcode-cn.com/problems/minimum-path-sum/
/// 最小路径和
func minPathSum(_ grid: [[Int]]) -> Int {
    if grid.count == 0 {
        return 0
    }
    let row = grid.count
    let col = grid.first!.count
    var dp = Array2D(columns: col, rows: row, initialValue: 0)
    dp[0,0] = grid[0][0]
    // dp[i,0]  dp[0,i]
    for idx in 1..<row {
        dp[idx,0] = dp[idx - 1, 0] + grid[idx][0]
    }
    for idx in 1..<col {
        dp[0,idx] = dp[0, idx - 1] + grid[0][idx]
    }
    for r in 1..<row {
        for c in 1..<col {
            dp[r,c] = min(dp[r, c - 1], dp[r - 1,c]) + grid[r][c]
        }
    }
    return dp[row - 1, col - 1]
}




