//
//  KVNode.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/26.
//

import Foundation

class KVNode<K,V>: CustomStringConvertible {
    
    var description: String {
        var s = "K:\(key), V:\(value)"
        if color == .Red {
            s += "_R"
        }
        return s
    }
    /// 左子节点
    var left: KVNode?
    /// 右子节点
    var right: KVNode?
    /// 父节点
    weak var parent: KVNode?
    // 默认是红色
    var color = NodeColor.Red
    /// key
    var key: K
    /// value
    var value: V
    
    init(k:K, v: V) {
        key = k
        value = v
    }
    
    /// 是否包含左右子树 。度是否为2
    /// - Returns: 是否
    public func hasTwoChild() -> Bool {
        return left != nil && right != nil
    }
    
    /// 是否是叶子节点
    /// - Returns: 是否
    public func isLeaf() -> Bool {
        return left == nil && right == nil
    }
    
    /// 判断是否有左节点
    /// - Returns: 是否
    public func hasLeft() -> Bool {
        return left != nil
    }
    
    /// 判断是否有有节点
    /// - Returns: 是否
    public func hasRight() -> Bool {
        return right != nil
    }
    
    /// 判断是否有父节点
    /// - Returns: 是否
    public func hasParent() -> Bool {
        return parent != nil
    }
    
    /// 是否只有一个子节点 ,度为1的节点
    /// - Returns: 是否
    public func hasSingleChild() -> Bool {
        if (left != nil && right == nil) || (left == nil && right != nil) {
            return true
        }
        return false
    }
    
    /// 相对于父节点，是否是左子节点
    /// - Returns: 是否
    public func isLeftChild() -> Bool {
        if let p = parent , let pleft = p.left {
            if pleft === self {
                return true
            }
        }
        return false
    }
    
    /// 相对于父节点，是否是右子节点
    /// - Returns: 是否
    public func isRightChild() -> Bool {
        if let p = parent , let pright = p.right {
            if pright === self {
                return true
            }
        }
        return false
    }

    /// 兄弟节点
    /// - Returns:
    public func sibling()-> KVNode<K,V>? {
        if isLeftChild() {
            return parent?.right
        } else if isRightChild() {
            return parent?.left
        } else { // 没有父节点
            return nil
        }
    }
    
    /// 叔叔节点
    /// - Returns: 父节点的兄弟
    public func uncle()-> KVNode<K,V>? {
        if hasParent() {
            return parent?.sibling()
        }
        return nil
    }
    
//    deinit {
//        print("\(self) 节点释放了")
//    }
}
