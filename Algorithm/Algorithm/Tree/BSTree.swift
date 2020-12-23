//
//  BSTree.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/9.
//

import Foundation

/// 二叉搜索树
class BSTree<T: Comparable>: BinaryTree<T> {
   
    /// 是否包含某元素
    /// - Parameter ele: ele
    /// - Returns: 是否包含
    public func contain(ele: T) -> Bool {
        return node(ele: ele) != nil
    }
    
    ///  添加元素
    /// - Parameter ele: ele
    public func add(ele: T) {
        let newNode = createNode(ele: ele)
        if isEmpty() {
            /// 根节点无父节点
            newNode.parent = nil
            root = newNode
        } else {
            // 找到父节点。插进去
            var node:Node? = root
            var parent: Node!
            var compareValue = 0
            while node != nil {
                if let nd = node {
                    parent = nd
                    compareValue = compare(n1: ele, n2: nd.element)
                    if compareValue < 0 {
                        node = node?.left
                    } else if compareValue > 0 {
                        node = node?.right
                    } else { // 相等
                        nd.element = ele
                    }
                }
            }
            // 添加: 这个时候 parent有值了  compareValue 代表添加在左右
            newNode.parent = parent
            if compareValue > 0 {
                parent.right = newNode
            } else if compareValue < 0 {
                parent.left = newNode
            } else {
                // do nothing
            }
            
        }
        size+=1
        afterAddNode(node: newNode)
    }
    
    ///  删除元素
    /// - Parameter ele: ele
    public func remove(ele: T) {
        if let nd = node(ele: ele) {
            remove(node: nd)
        }
    }
    
    /// 比较两个元素的大小
    /// - Parameters:
    ///   - n1: n1
    ///   - n2: n2
    /// - Returns: 1: n1> n2     0: n1=n2     -1: n1 < n2
    private func compare(n1: T, n2: T) -> Int {
        if n1 > n2 {
            return 1
        } else if n1 < n2 {
            return -1
        } else {
            return 0
        }
    }
    
    /// 根据元素查找Node
    /// - Parameter ele: 元素值
    /// - Returns: node
    private func node(ele: T)-> Node? {
        if isEmpty() {
            return nil
        }
        var current = root
        while current != nil {
            let cmp = compare(n1: ele, n2: current!.element)
            if cmp < 0 {
                current = current?.left
            } else if cmp > 0 {
                current = current?.right
            } else {
                return current
            }
        }
        return nil
    }
    
    /// 三种情况：删除叶子节点 ，删除节点度为1的，删除节点度为2的
    /// 删除节点
    /// - Parameter node: 删除节点
    private func remove(node: Node) {
        size-=1
        var toDelete = node
        var replace: Node?
        // 度为2
        if toDelete.hasTwoChild() {
            // 找到他的前驱节点
            let predessor =  predecessor(node: node)
            guard let prede = predessor else {
                return
            }
            // 替换值
            node.element = prede.element
            ///////////////// 度为2的节点，他的前驱或者后继节点只能为0 或者1 ///////////////////////////////////
            toDelete = prede // 标记这个要删除的节点，
        }
        
        // 下面分别处理 删除 0 1的情况
        /// 删除的是叶子节点
        if toDelete.isLeaf() {
            /// 有父节点
            if toDelete.hasParent() {
                if toDelete.isLeftChild() {
                    toDelete.parent!.left = nil
                }
                if toDelete.isRightChild() {
                    toDelete.parent!.right = nil
                }
            } else {
                // 叶子节点，且没有父节点。那么只能是根节点。删除的是根节点
                root = nil
            }
            replace = nil
        }
        
        /// 删除的度为1的节点
        if toDelete.hasSingleChild() {
            let replaceNode = toDelete.hasLeft() ? toDelete.left! : toDelete.right!
            if toDelete.hasParent() {
                replace = replaceNode
                if toDelete.isLeftChild() {
                    toDelete.parent?.left = replaceNode
                } else {
                    toDelete.parent?.right = replaceNode
                }
                replaceNode.parent = toDelete.parent
            } else {
                // 删除的是根节点
                root = replaceNode
                // 根节点无父节点
                replaceNode.parent = nil
                replace = nil
            }
            
        }
        // toDelete parent 这根线不能断
        afterRemoveNode(node: toDelete,replacement: replace)
    }
    
    public func createNode(ele: T) -> Node {
        return Node(ele: ele)
    }
    
    /// 子类拓展，用于平衡
    public func afterAddNode(node: Node) {}
    public func afterRemoveNode(node: Node, replacement: Node?) {}
}


extension BSTree {
    public class func test () {
        let bst = BSTree<Int>()
        let data = [ 38, 18, 4, 69, 85, 71, 34, 36, 29, 100]
//        let data = [85, 71, 34, 36, 29, 100,38, 18, 4,123]
//        let data = [ 84, 58, 20, 41, 26, 90, 88, 72, 98, 94, 39, 81, 99, 85, 62, 13, 55]
        for i in data {
            bst.add(ele: i)
        }
        bst.printTree()

//        for i in data {
//            print("删除节点 \(i)")
//            bst.remove(ele: i)
//            bst.printTree()
//        }
//        bst.preOrder()
//        bst.preOrder2()
//        bst.preOrder3()
//        bst.inOrder2()
//        bst.inOrder()
        bst.postOrder()
        bst.postOrder2()
    }
}

//2020-11-15 00:14:26.521287+0800 BinaryTreePrinterOC[39419:2564180] right = 122
//2020-11-15 00:14:26.521572+0800 BinaryTreePrinterOC[39419:2564180] right = 127
//2020-11-15 00:14:26.521635+0800 BinaryTreePrinterOC[39419:2564180] right = 119
//2020-11-15 00:14:26.521672+0800 BinaryTreePrinterOC[39419:2564180] right = 130
//2020-11-15 00:14:26.521695+0800 BinaryTreePrinterOC[39419:2564180] right = 116
//2020-11-15 00:14:26.521714+0800 BinaryTreePrinterOC[39419:2564180] right = 121
//2020-11-15 00:14:26.521733+0800 BinaryTreePrinterOC[39419:2564180] right = 113
//2020-11-15 00:14:26.521751+0800 BinaryTreePrinterOC[39419:2564180] right = 124
//2020-11-15 00:14:26.521769+0800 BinaryTreePrinterOC[39419:2564180] right = 110
