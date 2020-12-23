//
//  Trie.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/29.
//

import Foundation


/// 结构特别重要
class TrieNode: CustomStringConvertible {
    /// 代表是否是单词
    public var word: Bool
    /// 子节点们
    public var childred: Dictionary<Character,TrieNode>?
    /// 存储的值
    public var value: Int
    /// 存储的字符
    public var ckey: Character
    /// parent 兼容删除
    public weak var parent: TrieNode?
    
    public func childEmpty() -> Bool {
        return  childred == nil
    }
    
    init() {
        word = false
        value = -1
        ckey = "0"
    }
    var description: String{
        var s = "\(ckey) "
        if let c = childred {
            s += " \(c)"
        }
        s += " w=\(word)"
        return s
    }
}

class Trie {
    
    private var root: TrieNode = TrieNode()
    
    private(set) var size = 0
    
    public func isEmpty() -> Bool {
        return size == 0
    }
    
    public func clear() {
        size = 0
        if !root.childEmpty() {
            root.childred!.removeAll()
        }
    }
    
    public func contain(key: String) -> Bool {
        if let nd = node(key: key), nd.word {
            return true
        }
        return false
    }
    
    public func startWith(prefix: String) -> Bool {
        if prefix.count == 0 {
            return false
        }
        var node = root
        for  c in prefix {
            if node.childEmpty() {
                return false
            } else {
                if let childNode = node.childred![c] {
                    node = childNode
                } else {
                    return false
                }
            }
        }
        return true
    }
    
    public func add(key:String,value: Int) {
        assert(key.count != 0 ,"key must not be null")
        var node = root
        for c in key {
            if node.childEmpty() {
                node.childred = Dictionary<Character,TrieNode>()
            }
            // 如果已经有这个节点了。不用添加，下次循环
            if let childNode = node.childred![c] {
                node = childNode
            } else {
                // 新node。 添加
                let newNode = TrieNode()
                newNode.ckey = c
                newNode.parent = node
                node.childred![c] = newNode
                // 继续往下找
                node = newNode
            }
        }
        // 如果不是单词，把它标记为单词
        if !node.word {
            // 遍历完了之后。node是最后一个
            node.word = true
        }
        node.value = value
        size += 1
    }
    
    public func get(key: String) -> Int {
        if let node = node(key: key) {
            return node.word ? node.value : -1
        }
        return -1
    }
    
    public func remove(key: String) -> Int {
        // 删除，需要先看下是否有这个单词
        guard var nd = node(key: key) else {
            // 没有这个单词，不用删除
            return -1
        }
        // 有这个node。但是得确定下他是不是单词， 比如删除dogg。 他不是单词
        if !nd.word {
            return -1
        }
        size -= 1
        // 他是单词，如果是单词的话，看下有没有子节点.如果有其他子节点，那么也不能删除掉
        let oldValue = nd.value
        if !nd.childEmpty() && nd.childred!.count > 0{
            nd.word = false
            nd.value = -1
            return oldValue
        }
        
        // 这个单词尾部没有子节点。从下往上删除，直到parent有其他子节点就不能删除了
        while nd.parent != nil {
            if var parentChild = nd.parent!.childred {
                nd.value = -1
                print("删除了\(nd.ckey)")
                parentChild.removeValue(forKey: nd.ckey)
                if (nd.parent!.word || parentChild.count > 0){
                    break
                }
                nd = nd.parent!
            }
        }
        return oldValue
    }
    
    private func node(key: String) -> TrieNode? {
        if key.count == 0 {
            return nil
        }
        // 遍历
        var node = root
        for c in key {
            if node.childEmpty() {
                return nil
            } else {
                if let childNode = node.childred![c] {
                    // 继续往下遍历
                    node = childNode
                } else {
                    return nil
                }
            }
        }
        // 遍历完之后
        return node
    }
}


extension Trie {
    public class func trieTest() {
        let trie = Trie()
        trie.add(key: "haha", value: 1)
        trie.add(key: "dog", value: 2)
        trie.add(key: "doggy", value: 5)
        trie.add(key: "he", value: 7)
        trie.add(key: "hea", value: 9)
        
        print(trie.size)
        _ = trie.remove(key: "doggy")
//        _ = trie.remove(key: "dog")
        print(trie.size)
//        print(trie.get(key: "doggy"))
        
//        print(trie.get(key: "haha"))
        
//        print(trie.get(key: "doggy"))
        
//        print(trie.startWith(prefix: "ha"))
//        print(trie.startWith(prefix: "dog"))
//        print(trie.startWith(prefix: "dox"))
    }
}
