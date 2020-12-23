//
//  RBTree.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/16.
//

import Foundation

enum NodeColor {
    case Red
    case Black
}

class RBNode<T: Comparable>: BSTNode<T> {
    var color = NodeColor.Red // 默认是红色
    override var description: String {
        var s = "\(element)"
        if color == .Red {
            s += "_R"
        }
        return s
    }
}

class RBTree<T: Comparable>: BSTree<T> {
    
    public override func createNode(ele: T) -> Node {
        return RBNode(ele: ele)
    }
    
    public override func afterAddNode(node: Node) {
        // 添加的是根节点
        if !node.hasParent() {
            _ = black(node: node)
            return
        }
        
        // 父节点是黑色，添加红色不需要处理 : 4中情况
        if isBlack(node: node.parent) {
            return
        }
        
        // 父节点是红色，双红，需要处理下
        
        let parent = node.parent!
        let uncle = parent.sibling()
        let grand = parent.parent!
        
        // 如果uncle 是红色，那么是 原来的节点(B树节点)为红黑红。 会发生上溢  -> 红黑红 4种情况
        if isRed(node: uncle) {
            _ = black(node: parent)
            if let uc = uncle {
                _ = black(node: uc)
            }
            // 将grand染成红色，当做新节点添加
            _ = red(node: grand)
            afterAddNode(node: grand)
            return
        }
        
        // 能来到这里 uncle节点 不是红色 .则旋转   红黑 , 黑红 4种情况
        if parent.isLeftChild() { // L
            if node.isLeftChild() { // LL
                // 将父节点染成黑色，
                _ = black(node: parent)
                _ = red(node: grand)
                rotateRight(node: grand)
            } else { // LR
                _ = black(node: node)
                _ = red(node: grand)
                rotateLeft(node: parent)
                rotateRight(node: grand)
            }
        } else { //R
            if node.isLeftChild() { // RL
                _ = black(node: node)
                _ = red(node: grand)
                rotateRight(node: parent)
                rotateLeft(node: grand)
            } else { // RR
                _ = black(node: parent)
                _ = red(node: grand)
                rotateLeft(node: grand)
            }
        }
    }
    
    
    /// 删除节点
    /// - Parameters:
    ///   - node: 删除的节点
    ///   - replacement: 用以替代删除节点的节点，单叶子节点
    public override func afterRemoveNode(node: Node, replacement: Node?) {
        // 如果删除的是红色，啥也不用干
        if isRed(node: node) {
            return
        }
        // 删除的是黑色根节点
        if node.parent == nil {
            return
        }
        
        // 处理删除黑色的情况
        
        // 用以替代的节点时红色，是叶子节点，那么将它染黑就好。
        if let rp = replacement, isRed(node: rp) {
            _ = black(node: rp)
            return
        }
        
        // 能来到这里，删除的是叶子节点。单个黑
        
        // 获取parent
        let parent = node.parent!
        
        // 获取兄弟节点
        // 这个节点也就被删除了。那么通过node.sibling拿不到兄弟节点，只能判断当初删除的是那边获取兄弟节点
        // 删除的是左边
        let left = parent.left == nil || node.isLeftChild()
        // 兄弟节点一定有值，因为4阶B树的节点个数为1-3个
        var sibling = left ? parent.right! : parent.left!
        
        // 判断方向，涉及到旋转
        // 删除的叶子节点时左节点
        if left {
            if isBlack(node: sibling) {
                if isBlack(node: sibling.left) && isBlack(node: sibling.right) {
                    if isRed(node: parent) {
                        _ = red(node: sibling)
                        _ = black(node: parent)
                    } else {
                        _ = red(node: sibling)
                        afterRemoveNode(node: parent, replacement: nil)
                    }
                } else {
                    if sibling.hasRight() {
                        rotateLeft(node: parent)
                        _ = makeMolor(node: sibling, color: (parent as! RBNode).color)
                        _ = black(node: parent)
                        _ = black(node: sibling.right!)
                    } else {
                        rotateRight(node: sibling)
                        rotateLeft(node: parent)
                        _ = makeMolor(node: sibling.left!, color: (parent as! RBNode).color)
                        _ = black(node: parent)
                    }
                }
            } else {
                rotateLeft(node: parent)
                _ = black(node: parent)
                _ = red(node: sibling)
                afterRemoveNode(node: node, replacement: nil)
            }
        } else {
            // 判断是不是黑兄弟
            if isBlack(node: sibling) {
                // 黑兄弟没有节点借给我
                if isBlack(node: sibling.left) && isBlack(node: sibling.right) {
                    // 黑兄弟借不了。那么只能父节点下移合并
                    if isRed(node: parent) {
                        _ = red(node: sibling)
                        _ = black(node: parent)
                    } else {
                        // 父节点也是黑色。下移合并也会发生下溢
                        _ = red(node: sibling)
                        // 把parent当做删除的节点
                        afterRemoveNode(node: parent, replacement: nil)
                    }
                } else {
                    // 黑兄弟，并且有一个或者两个红色节点借给我
                    if sibling.hasLeft() { // LL
                        rotateRight(node: parent)
                        // 中心节点继承parent颜色
                        _ = makeMolor(node: sibling, color: (parent as! RBNode).color)
                        _ = black(node: parent)
                        _ = black(node: sibling.left!)
                    } else { // LR
                        rotateLeft(node: sibling)
                        rotateRight(node: parent)
                        _ = makeMolor(node: sibling.right!, color: (parent as! RBNode).color)
                        _ = black(node: parent)
                    }
                }
            } else {
                // 兄弟节点为红色,兄弟没得借，这个时候应该问兄弟的儿子借，因为兄弟不在一个层级上
                // 让跟兄弟的儿子做兄弟 -> 旋转 LL
                _ = black(node: sibling)
                _ = red(node: parent)
                rotateRight(node: parent)
                sibling = parent.left! // 兄弟要变一下
                afterRemoveNode(node: node, replacement: nil)
                
            }
        }
    }
    
    
    /// 右旋转 LL
    /// - Parameter node: grand节点
    private func rotateRight(node: Node) {
        let grand = node
        let parent = grand.left
        let child = parent?.right
        
        parent?.right = grand
        grand.left = child
        
        afterRotate(grand: grand, parent: parent!, child: child)
    }
    
    /// 左旋转 RR
    /// - Parameter node: grand
    private func rotateLeft(node: Node) {
        let grand = node
        let parent = grand.right
        let child = parent?.left
        
        parent?.left = grand
        grand.right = child
        
        afterRotate(grand: grand, parent: parent!, child: child)
    }
    
    /// 旋转之后的操作
    /// - Parameters:
    ///   - grand: grand
    ///   - parent: p
    ///   - child: p的子节点
    private func afterRotate(grand: Node, parent: Node, child: Node?) {
        // 让p成为root
        if grand.isLeftChild() {
            grand.parent?.left = parent
        } else if grand.isRightChild() {
            grand.parent?.right = parent
        } else {
            root = parent
        }
        parent.parent = grand.parent
        grand.parent = parent
        child?.parent = grand
    }
    
    /// 染色
    private func makeMolor(node: Node, color: NodeColor) -> Node {
        (node as! RBNode<T>).color = color
        return node
    }
    private func red(node: Node) -> Node {
        makeMolor(node: node, color: .Red)
    }
    private func black(node: Node) -> Node {
        makeMolor(node: node, color: .Black)
    }
    public func isBlack(node: Node?) -> Bool {
        /// 虚拟节点默认为黑色
        guard let nd = node else { return true }
        return (nd as! RBNode<T>).color == .Black
    }
    public func isRed(node: Node?) -> Bool {
        guard let nd = node else { return false }
        return (nd as! RBNode<T>).color == .Red
    }
    
}

extension RBTree {
    public class func rbttest() {
        let rb = RBTree<Int>()
//        let data = [85, 71, 34, 36, 29, 100,38]
//        let data = [ 11, 22, 33]
//        let data = [ 82, 75, 67, 99, 40, 55, 64, 8, 79, 73 ]
        let data = [ 84, 58, 20, 41, 26, 90, 88, 72, 98, 94, 39, 81, 99, 85, 62, 13, 55]
        
        for i in data {
            rb.add(ele: i)
        }
        rb.printTree()
        
        
        for i in data {
            print("删除节点 \(i)")
            rb.remove(ele: i)
            rb.printTree()
        }
    }
}

