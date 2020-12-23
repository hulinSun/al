//
//  LStack.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/2.
//

import Foundation

/// 双向链表实现的栈
class LStack<T:Comparable> {
    
    private var linkList: DLinkedList = DLinkedList<T>()
    
    public func clear() {
        linkList.clear()
    }
    
    public func isEmpty() -> Bool{
        return linkList.isEmpty()
    }
    
    public func size() -> Int {
        return linkList.size
    }
    
    public func push(element: T) {
        linkList.add(element: element)
    }

    public func pop() -> T {
        assert(isEmpty() == false, "栈不能为空")
        return linkList.remove(index: linkList.size - 1)
    }
    
    public func top() -> T {
        assert(isEmpty() == false, "栈不能为空")
        return linkList.get(index: linkList.size - 1)
    }
    
    public func display() {
        print(linkList)
    }
    
    public class func LStackTest(){
        let stack = LStack<Int>()
        for i in 1...8 {
            stack.push(element: i)
        }
        stack.display()
        while !stack.isEmpty() {
            print(stack.pop())
        }
    }
}


/** 有效的括号
 * https://leetcode-cn.com/problems/valid-parentheses/
 * 给定一个只包括 '('，')'，'{'，'}'，'['，']' 的字符串，判断字符串是否有效。
 * 有效字符串需满足：
 左括号必须用相同类型的右括号闭合。
 左括号必须以正确的顺序闭合。
 */

// () {[]} ()[]{} -> YES   ([}): NO
/// 最简单粗暴的方法。直接将匹配到的整个对称的给消掉。 消消乐思想 ，但是性能特别差。
public func isValid(str: NSString) -> Bool {
    var string = NSString(string: str)
    while string.contains("()") || string.contains("[]") || string.contains("{}") {
        string = string.replacingOccurrences(of: "()", with: "") as NSString
        string = string.replacingOccurrences(of: "[]", with: "") as NSString
        string = string.replacingOccurrences(of: "{}", with: "") as NSString
    }
    let res = string.length == 0
    print(res ? "是有效的括号": "不是有效的括号")
    return res
}

public func isValid2(str: String) -> Bool {
    let stack = LStack<Character>()
    for i in str {
        if i == "(" || i == "{" || i == "[" { // 左括号
            stack.push(element: i)
        } else { // 一定是右括号
            if stack.isEmpty() { // 如果没有匹配到左括号，匹配到了右括号。一定不是有效的
                print("不是有效的括号")
                return false
            }
            let left = stack.pop()
            // 一定是右括号
            if i == "}" && left != "{"{
                print("不是有效的括号")
                return false
            }
            if i == "]" && left != "["{
                print("不是有效的括号")
                return false
            }
            if i == ")" && left != "("{
                print("不是有效的括号")
                return false
            }
        }
    }
    let res = stack.isEmpty()
    print(res ? "是有效的括号": "不是有效的括号")
    return res
}


public func isValid3(str: String) -> Bool {
    let stack = LStack<Character>()
    let dict: [Character : Character] = [
        "{" : "}",
        "[" : "]",
        "(" : ")",
    ]
    for i in str {
        if dict.keys.contains(i) { // 左括号
            stack.push(element: i)
        } else { // 一定是右括号
            if stack.isEmpty() { // 如果没有匹配到左括号，匹配到了右括号。一定不是有效的
                print("不是有效的括号")
                return false
            }
            // 匹配到的值 i
            // 拿出来比较的值 dict[stack.pop()]
            if dict[stack.pop()] != i {
                print("不是有效的括号")
                return false
            }
        }
    }
    let res = stack.isEmpty()
    print(res ? "是有效的括号": "不是有效的括号")
    return res
}

public func testValidString() {
    _ = isValid(str: "([{}]}")
    _ = isValid2(str: "()]")
    _ = isValid3(str: "[{}]")
}
