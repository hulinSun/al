//
//  LeeString.swift
//  Algorithm
//
//  Created by 孙虎林 on 2021/1/5.
//

import Foundation

/// 字符串相关
/// 字符串轮转。给定两个字符串s1和s2，请编写代码检查s2是否为s1旋转而成（比如，waterbottle是erbottlewat旋转后的字符串）。
/// 输入：s1 = "waterbottle", s2 = "erbottlewat" 输出：True
/// https://leetcode-cn.com/problems/string-rotation-lcci/

func isFlipedString(_ s1: String, _ s2: String) -> Bool {
    if s1.count != s2.count {
        return false
    }
    if s1 == "" && s2 == "" {
        return true
    }
    return (s1 + s1).contains(s2)
}

/// 给定两个非空二叉树 s 和 t，检验 s 中是否包含和 t 具有相同结构和节点值的子树。s 的一个子树包括 s 的一个节点和这个节点的所有子孙。s 也可以看做它自身的一棵子树。
/// 链接：https://leetcode-cn.com/problems/subtree-of-another-tree
/// 序列化成字符串，然后看是否包含.建议使用后序遍历，前序遍历有坑,比如 (2!#!#1) (12!#!#1)、如果确实想用前序遍历， 在前面再加上一个！
func isSubtree(_ s: TreeNode?, _ t: TreeNode?) -> Bool {
    if s == nil || t == nil {
        return false
    }
    var full = ""
    var sub = ""
    postOrder(node: s, string: &full)
    postOrder(node: t, string: &sub)
    if full.contains(sub) {
        return true
    }
    return false
}

/// 序列化一个树
/// # 代表空节点   ! 代表节点的结束
func postOrder(node: TreeNode?, string: inout String)  {
    if node == nil {
        return
    }
    if node?.left == nil {
        string += "#!"
    } else {
        postOrder(node: node!.left, string: &string)
    }
    if node?.right == nil {
        string += "#!"
    } else {
        postOrder(node: node!.right, string: &string)
    }
    string += "\(node!.val)!"
}

/// 有效的字母异位词
/// 给定两个字符串 s 和 t ，编写一个函数来判断 t 是否是 s 的字母异位词。
/// 输入: s = "anagram", t = "nagaram" 输出: true
/// 输入: s = "rat", t = "car" 输出: false
/// https://leetcode-cn.com/problems/valid-anagram/
/// 各单词个数相同。
func isAnagram(_ s: String, _ t: String) -> Bool {
    if s.count != t.count {
        return false
    }
    // 不用hash
    // 都是小写。
    var ccounts = Array<Int>(repeating: 0, count: 26)
    for c in s {
        let idx = Int(c.asciiValue! - Character("a").asciiValue!);
        ccounts[idx] = ccounts[idx] + 1
    }
    
    for c in t {
        let idx = Int(c.asciiValue! - Character("a").asciiValue!);
        ccounts[idx] = ccounts[idx] - 1
    }
    
    for (_,item) in ccounts.enumerated() {
        if item != 0 {
            return false
        }
    }
    return true
}

func isAnagramTest() {
    print(isAnagram("anagram", "nagaram"))
}


/// 链接：https://leetcode-cn.com/problems/reverse-words-in-a-string
/// 给定一个字符串，逐个翻转字符串中的每个单词。
/// 无空格字符构成一个 单词 。
/// 输入字符串可以在前面或者后面包含多余的空格，但是反转后的字符不能包括。
/// 如果两个单词间有多余的空格，将反转后单词间的空格减少到只含一个。

func reverseWords(_ s: String) -> String {
    /// 过滤空格
    var cs = Array<Character>(repeating: " ", count: s.count)
    for (i,c) in s.enumerated() {
        cs[i] = c
    }
    // 过滤空格
    var cur = 0
    // 标记前面的是否是空格
    var space = true
    var length = 0
    for (_,c) in cs.enumerated() {
        if c != " " {
            cs[cur] = c
            cur += 1
            // 前面不是空格
            space = false
        } else {
            // 当前这个是空格。并且前面的不是空格。说明单词结尾。
            if space == false {
                cs[cur] = " "
                cur += 1
                space = true
            }
        }
    }
    length = space ? cur - 1 : cur
    cs.removeSubrange(length..<cs.count)
    reverse(words: &cs, li: 0, ri: length)
    
    var pre = -1
    for (i,c) in cs.enumerated() {
        if c == " " {
            reverse(words: &cs, li: pre + 1, ri: i)
            pre = i
        }
    }
    // 最后一个
    reverse(words: &cs, li: pre + 1, ri: cs.count)
    // 间隔
    return String(cs)
}

func reverse(words: inout [Character], li: Int, ri: Int) {
    
    var l = li
    var r = ri - 1
    while l < r {
        let temp = words[l]
        words[l] = words[r]
        words[r] = temp
        l += 1
        r -= 1
    }
}

func reverseWordsTest() {
    _ = reverseWords("hello  word hahah das f")
}


/// https://leetcode-cn.com/problems/longest-substring-without-repeating-characters/
/// 给定一个字符串，请你找出其中不含有重复字符的 最长子串 的长度。
/// 输入: s = "abcabcbb" 输出: 3
/// 解释: 因为无重复字符的最长子串是 "abc"，所以其长度为 3。
func lengthOfLongestSubstring(_ s: String) -> Int {
    if s.count == 0 {
        return 0
    }
    var cs = Array<Character>(repeating: " ", count: s.count)
    for (idx,c) in s.enumerated() {
        cs[idx] = c
    }
    
    // 第一个先放里面
    var pres = Dictionary<Character,Int>()
    pres[s.first!] = 0
    var li = 0
    var long = 1
    for idx in 1..<cs.count {
        let c = cs[idx]
        // 获取pi
        if let pi = pres[c] , li < pi {
            li = pi + 1
        }
        // 存储上一次出现的位置
        pres[c] = idx
        long = max(long, idx - li)
    }
    return long
}

/// start不动，end向后移动
/// 当end遇到重复字符，start应该放在上一个重复字符的位置的后一位，同时记录最长的长度
/// 怎样判断是否遇到重复字符，且怎么知道上一个重复字符的位置？--用哈希字典的key来判断是否重复，用value来记录该字符的下一个不重复的位置。
func lengthOfLongestSubstring2(_ s: String) -> Int {
    if s.count == 0 {
        return 0
    }
    var cs = Array<Character>(repeating: " ", count: s.count)
    for (idx,c) in s.enumerated() {
        cs[idx] = c
    }
    // 第一个先放里面
    var pres = Dictionary<Character,Int>()
    var left = 0
    var long = 0
    for idx in 0..<cs.count {
        let c = cs[idx]
        // 如果之前存在过
        if pres.keys.contains(c) {
            left = max(left, pres[c]! + 1)
        }
        pres[c] = idx
        long = max(long, idx - left + 1)
    }
    return long
}


func lengthOfLongestSubstringTest() {
//    print(lengthOfLongestSubstring("abcabcbb"))
    print(lengthOfLongestSubstring2("abcabcbb"))
}

/// 最大水
func maxArea(_ height: [Int]) -> Int {
    if height.count == 0 {
        return 0
    }
    var left = 0
    var right = height.count - 1
    var maxH = 0
    while left < height.count && right > 0 {
        let w = right - left
        var h = 0
        if height[left] < height[right] {
            h = height[left]
            left += 1
        } else {
            h = height[right]
            right -= 1
        }
        maxH = max(maxH, w * h)
    }
    return maxH
}

/// 在一个字符串中找到第一个只出现一次的字符。如输入 abaccdeff，则输出 b。
func firstExsitChar(str: String) -> Character? {
    /// 26个字母
    var cs = Array<Int>(repeating: -1, count: 26)
    for (i,c) in str.enumerated() {
        let idx = Int(c.asciiValue! - Character("a").asciiValue!);
        // 这个位置出现过了。不算它
        if cs[idx] != -1 {
            print("\(c)出现两次")
            cs[idx] = -1
        } else {
            // 只出现一次的
            cs[idx] = i
        }
    }
    
    print(cs)
    for (i, ci) in cs.enumerated() {
        if ci != -1 && ci >= 0 {
            // 找到了
            print(i + Int( Character("a").asciiValue!))
            return nil
        }
    }
    return nil
}



func longNumber(str: String) -> Int {
    if str.count == 0 {
        return 0
    }
    var cs = Array<Character>(repeating: " ", count: str.count)
    for (i,c) in str.enumerated() {
        cs[i] = c
    }
    var dp = Array<Int>(repeating: 0, count: str.count)
    // dp[i] 是以i idx 结尾的最长数字串
    if cs.first!.isNumber {
        dp[0] = 1
    } else {
        dp[0] = 0
    }
    var long = dp[0]
    for idx in 1..<cs.count {
        if cs[idx].isNumber {
            dp[idx] = dp[idx - 1] + 1
        } else {
            dp[idx] = 0
        }
        long = max(long, dp[idx])
    }
    print(dp)
    return long
}

/// 左旋转k 字符串
/// 如把字符串 ab cdef 左旋转2 位得到字符串 cdef ab。请实现字符串左旋转的函数。
func rotatekString(str: String) -> String {
    /// 给一个字符数组， 从l 到 r 翻转
    func reverse(cs: inout [Character],l: Int, r: Int) {
        var left = l
        var right = r
        while left < right {
            let temp = cs[left]
            cs[left] = cs[right]
            cs[right] = temp
            left += 1
            right -= 1
        }
    }
    var cs = Array<Character>(repeating: " ", count: str.count)
    for (i,c) in str.enumerated() {
        cs[i] = c
    }
    // fedcba
    // cdefab
    // 旋转字符串。 两次旋转
    reverse(cs: &cs, l: 0, r: cs.count - 1)
    reverse(cs: &cs, l: 0, r: cs.count - 1 - 2)
    reverse(cs: &cs, l: cs.count - 2, r: cs.count - 1)
    
    return String(cs)
}
