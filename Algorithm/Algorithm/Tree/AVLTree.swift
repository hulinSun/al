//
//  AVLTree.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/11.
//

import Foundation

class AVLNode<T: Comparable>: BSTNode<T> {
    
    override var description: String {
        let s = "\(element)"
//        s += "_\(height)"
//        if hasParent() {
//            s+="_\(parent!.element)"
//        }
        return s
    }
    
    /// 节点的高度.
    private(set) var height: Int = 1
    
    /// 平衡因子, 左字数的高度 - 右子树的高度
    private var blanceFactory: Int {
        get {
            let childHight = getChildHeight()
            return childHight.leftHeight - childHight.rightHeight
        }
    }
    
    /// 是否平衡
    /// - Returns: 是否平衡
    public func isBlance() -> Bool{
        return fabs(Double(blanceFactory)) <= 1
    }
    
    /// 更新高度
    public func updateHeight() {
       let childHight = getChildHeight()
        height = max(childHight.leftHeight, childHight.rightHeight) + 1
    }
    
    /// 获取高度较高的child
    /// - Returns: 节点
    public func tallerChild() -> AVLNode {
       let childHight = getChildHeight()
        if childHight.leftHeight > childHight.rightHeight {
            return left as! AVLNode
        } else if childHight.leftHeight < childHight.rightHeight {
            return right as! AVLNode
        } else { // 度为2，那么都相等，则返回跟父节点相同方向的节点
            if isLeftChild() {
                return left as! AVLNode
            } else {
                return right as! AVLNode
            }
        }
    }
    
    private func getChildHeight() -> (leftHeight: Int, rightHeight: Int) {
        var leftHeight = 0
        var rightHeight = 0
        if hasLeft()  {
            leftHeight = (left as! AVLNode<T>).height
        }
        if hasRight()  {
            rightHeight = (right as! AVLNode<T>).height
        }
        return (leftHeight, rightHeight)
    }
    
}

class AVLTree<T: Comparable>: BSTree<T> {
    
    typealias Avlnode = AVLNode<T>
    /// 添加之后，平衡操作
    /// - Parameter node: 添加的那个节点传过来
    override func afterAddNode(node: Node) {
        var nd = node
        while nd.hasParent() {
            nd = nd.parent! // 从父节点开始，因为新添加的节点的高度为1，从父节点更新高度才有意义
            if (nd as! Avlnode).isBlance() { // 如果已经平衡了。那么在添加之后更新高度
                (nd as! Avlnode).updateHeight()
            } else { // 恢复平衡
                /// 失衡的永远为高度最低的祖先节点
                rebalance(node:(nd as! Avlnode))
                // 恢复平衡之后直接返回了。只要把最低的平衡了就没事了
                break
            }
        }
    }

    /// 删除的节点传过来
    override func afterRemoveNode(node: Node, replacement: Node?) {
        var nd = node
        while nd.hasParent() {
            nd = nd.parent!
            if (nd as! Avlnode).isBlance() {
                (nd as! Avlnode).updateHeight()
            } else {
                // 不平衡了 ,这里要一直递归,旋转有可能会导致高度减1.会影响祖先的平衡。
                rebalance(node: nd as! Avlnode)
            }
        }
    }
    
    /// 平衡节点
    /// - Parameter node: grand 。失去平衡的节点，永远是高度最低的祖先节点
    private func rebalance(node: Avlnode) {
        let grand = node
        let parent = grand.tallerChild()
        let nd = parent.tallerChild()
        if parent.isLeftChild() { // L
            if nd.isLeftChild() { // LL
                rotateRight(node: grand)
            } else { // LR
                rotateLeft(node: parent)
                rotateRight(node: grand)
            }
        } else { // R
            if nd.isLeftChild() { // RL
                rotateRight(node: parent)
                rotateLeft(node: grand)
            } else { // RR
                rotateLeft(node: grand)
            }
        }
    }
    
    /// 左旋转
    /// - Parameter node: 需要旋转的节点
    private func rotateLeft(node: Avlnode) {
        let grand = node
        let parent = grand.right as! Avlnode
        let t1 = parent.left
        grand.right = t1
        parent.left = grand
        
        afterRotate(grand: grand, parent: parent, child: t1 as? Avlnode)
    }
    
    /// 右旋转
    /// - Parameter node: 需要旋转的节点
    private func rotateRight(node: Avlnode) {
        let grand = node
        let parent = grand.left as! Avlnode
        let t2 = parent.right
        
        grand.left = t2
        parent.right = grand
        
        afterRotate(grand: grand, parent: parent, child: t2 as? Avlnode)
    }
    
    
    /// 旋转之后的操作
    /// - Parameters:
    ///   - grand: grand
    ///   - parent: p
    ///   - child: p的子节点
    private func afterRotate(grand: Avlnode, parent: Avlnode, child: Avlnode?) {
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
        
        grand.updateHeight()
        parent.updateHeight()
    }
    
    /// 根据数的类型创建不同节点
    /// - Parameter ele: 元素
    /// - Returns: 节点，子类用于拓展
    override func createNode(ele: T) -> Node {
        return AVLNode(ele: ele)
    }
}

extension AVLTree {
    public class func avlTest() {
        let avl = AVLTree<Int>()
        let data = [85, 71, 34, 36, 29, 100,38]
        for i in data {
            avl.add(ele: i)
        }
        avl.printTree()
        
        avl.remove(ele: 100)
        avl.printTree()
        
    }
}

