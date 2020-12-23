//
//  BSTNode.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/9.
//

import Foundation

/// 二叉树的节点
class BSTNode<T: Comparable>: CustomStringConvertible {
    /// 左子节点
    var left: BSTNode?
    /// 右子节点
    var right: BSTNode?
    /// 父节点
    weak var parent: BSTNode?
    /// 元素内容
    var element: T
    init(ele: T) {
        element = ele
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
    public func sibling()-> BSTNode<T>? {
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
    public func uncle()-> BSTNode<T>? {
        if hasParent() {
            return parent?.sibling()
        }
        return nil
    }
    
    var description: String {
        if parent == nil {
//            return "【\(element)】🚀 "
            return "\(element)"
        } else {
//            return "【\(element)】_ P(\(parent!.element))"
            return "\(element)"
        }
//        if isLeaf() {
//            return "\(element)"
//        } else {
//            if hasTwoChild() {
//                return "\(left!.element) \(element) \(right!.element)"
//            } else {
//                if hasLeft() {
//                    return "\(left!.element) \(element) *"
//                } else {
//                    return "* \(element) \(right!.element)"
//                }
//            }
//        }
    }
}


/// 添加这个只是想让Node可以添加到队列里去
extension BSTNode: Comparable {
    static func < (lhs: BSTNode<T>, rhs: BSTNode<T>) -> Bool {
        return true
    }
    static func == (lhs: BSTNode<T>, rhs: BSTNode<T>) -> Bool {
        return false
    }
}
