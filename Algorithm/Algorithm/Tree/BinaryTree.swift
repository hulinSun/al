//
//  BinaryTree.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/9.
//

import Foundation

/// 普通的二叉树
class BinaryTree<T: Comparable> {
    
    typealias Node = BSTNode<T>
    
    /// 根节点
    var root: Node?
    ///  元素的数量
    public var size: Int = 0
    /// 是否为空
    /// - Returns: 是否为空
    public func isEmpty() -> Bool {
        return size == 0
    }
    /// 清空所有元素
    public func clear() {
        root = nil
        size = 0
    }
    
    /// 返回树的高度
    /// - Returns: 高度
    public func height() -> Int {
        return height(node: root)
    }
    
    /// 是否是完全二叉树
    /// 层序遍历好实现
    /// - Returns: 是否
    public func isComplete() -> Bool {
        if let nd = root {
            let queue = LQueue<Node>()
            queue.enQueue(element: nd)
            var shouldLeaf = false
            while !queue.isEmpty() {
                let node = queue.deQueue()
                if shouldLeaf && !node.isLeaf() {
                    return false
                }
                
                if node.hasTwoChild() {
                    queue.enQueue(element: node.left!)
                    queue.enQueue(element: node.right!)
                } else if node.hasSingleChild() {
                    if node.left == nil && node.hasRight() { // 左节点为空
                        return false
                    } else { // 必有左节点
                        queue.enQueue(element: node.left!)
                        shouldLeaf = true // 后面遍历的节点都必须是叶子节点
                    }
                } else { // 叶子节点
                    shouldLeaf = true
                }
            }
            return true
        }
        return false
    }
    
    /// 前驱节点的定义： 中序遍历顺序的前一个节点 【1，2，3，4，5，6，7，8】 则，8的前驱是7
    /// 获取一个节点的前驱节点
    /// - Parameter node: 节点
    /// - Returns: 前驱
    public func predecessor(node: Node?) -> Node? {
        guard let nd = node else {
            return nil
        }
        // 前驱节点一定左子树中。
        if nd.hasLeft() {
            var predecessor = nd.left!
            while predecessor.right != nil {
                predecessor = predecessor.right!
            }
            return predecessor
        }
        
        // 没有左节点。
        if !nd.hasLeft() && nd.hasParent() {
            var current = nd
            while current.parent != nil && !current.isRightChild() {
                current = current.parent!
            }
            return current.hasParent() ? current.parent! : nil
        }
        
        if !nd.hasParent() && !nd.hasLeft(){
            return nil
        }
        return nil
    }
    
    /// 查找某个节点的后继节点
    /// - Parameter node: 节点
    /// - Returns: 节点
    public func successor(node: Node?) -> Node? {
        guard let nd = node else {
            return nil
        }
        if nd.hasRight() {
            var predecessor = nd.right!
            while predecessor.left != nil {
                predecessor = predecessor.left!
            }
            return predecessor
        }
        
        if !nd.hasRight() && nd.hasParent() {
            var current = nd
            while current.parent != nil && !current.isLeftChild() {
                current = current.parent!
            }
            return current.hasParent() ? current.parent! : nil
        }
        
        if !nd.hasParent() && !nd.hasRight(){
            return nil
        }
        return nil
    }
        
    /// 层序遍历获取树的高度
    /// - Returns: 高度
    public func height2() -> Int {
        if root == nil {
            return 0
        }
        var height = 0
        var levelSize = 1 //每一层的个数，第一层为1个
        let queue = LQueue<Node>()
        queue.enQueue(element: root!)
        while !queue.isEmpty() {
            let node = queue.deQueue()
            levelSize-=1 // 出队减去1
            if node.hasLeft() {
                queue.enQueue(element: node.left!)
            }
            if node.hasRight() {
                queue.enQueue(element: node.right!)
            }
            if levelSize == 0 {
                height+=1
                levelSize = queue.size()
            }
        }
        return height
    }
    
    /// 递归获取高度
    /// - Parameter node: 节点
    /// - Returns: 高度
    private func height(node: Node?) -> Int {
        if node == nil {
            return 0
        } else {
            let leftHeight = height(node: node?.left)
            let rightHight = height(node: node?.right)
            return max(leftHeight, rightHight) + 1
        }
    }
    
    /// 翻转二叉树 https://leetcode-cn.com/problems/invert-binary-tree/
    /// - Parameter node: 给的节点
    /// - Returns: 返回新的节点
    public func invert() {
        invert(node: root)
    }
    private func invert(node: Node?) {
        if let nd = node {
            let temp = nd.left
            nd.left = nd.right
            nd.right = temp
            
            invert(node: nd.left)
            invert(node: nd.right)
        }
    }
    
    /// 遍历实现
    public func invert2() {
        if let nd = root {
            let queue = LQueue<Node>()
            queue.enQueue(element: nd)
            while !queue.isEmpty() {
                let node = queue.deQueue()
                let temp = node.left
                node.left = node.right
                node.right = temp
                
                if node.hasLeft() {
                    queue.enQueue(element: node.left!)
                }
                if node.hasRight() {
                    queue.enQueue(element: node.right!)
                }
                
            }
        }
    }
    
}

/// 不带有访问器的遍历
extension BinaryTree {
    
    /// 前序遍历  【根节点 左 右】 -> 最终的结果，永远是根节点在前面
    public func preOrder() {
        assert(isEmpty() == false, "不能为空")
        preOrder(node: root)
    }
    private func preOrder(node: Node?) {
        if node == nil {
            return
        }
        if let nd = node {
            visit(node: nd)
            preOrder(node: nd.left)
            preOrder(node: nd.right)
        }
    }
    
    /// 中序遍历  【 左 根节点 右 】  -> 升序或者降序
    public func inOrder() {
        assert(isEmpty() == false, "不能为空")
        inOrder(node: root)
    }
    private func inOrder(node: Node?) {
        if node == nil {
            return
        }
        if let nd = node {
            inOrder(node: nd.left)
            visit(node: nd)
            inOrder(node: nd.right)
        }
    }
    
    /// 后续遍历  【左 右  根节点 】  最终的结果，永远是根节点在前面
    public func postOrder() {
        assert(isEmpty() == false, "不能为空")
        postOrder(node: root)
    }
    private func postOrder(node: Node?) {
        if node == nil {
            return
        }
        if let nd = node {
            postOrder(node: nd.left)
            postOrder(node: nd.right)
            visit(node: nd)
        }
    }
    
    /// 层序遍历
    /**
    1.将根节点入队
    2.循环执行以下操作，直到队列为空
     将队头节点 A 出队，进行访问
     将 A 的左子节点入队
     将 A 的右子节点入队
    */
    public func levelOrder() {
        assert(isEmpty() == false, "不能为空")
        let queue = LQueue<Node>()
        if let nd = root {
            queue.enQueue(element: nd)
        }
        while !queue.isEmpty() {
            // 取出队头元素访问
            let node = queue.deQueue()
            visit(node: node)
            
            if node.hasLeft() {
                queue.enQueue(element: node.left!)
            }
            if node.hasRight() {
                queue.enQueue(element: node.right!)
            }
        }
    }
    
    /// 节点访问
    /// - Parameter node: 节点
    private func visit(node: Node) {
        print(node)
    }
}

/// 访问器
extension BinaryTree {
    
    /// 带有访问器的遍历
    /// 前序遍历  根节点 左 右
    public func preOrderWith(vistor: (_ node:Node) -> Void) {
        assert(isEmpty() == false, "不能为空")
        preOrder(node: root, vistor: vistor)
    }
    
    private func preOrder(node: Node?,vistor:(_ node:Node) -> Void) {
        if node == nil {
            return
        }
        if let nd = node {
            visitWithVistor(node: nd,vistor: vistor)
            preOrder(node: nd.left, vistor: vistor)
            preOrder(node: nd.right, vistor: vistor)
        }
    }
    
    /// 带有访问器的遍历
    /// 中序遍历   左 根节点 右
    public func inOrderWith(vistor: (_ node:Node) -> Void) {
        assert(isEmpty() == false, "不能为空")
        inOrderWith(node: root, vistor: vistor)
    }
    
    private func inOrderWith(node: Node?,vistor:(_ node:Node) -> Void) {
        if node == nil {
            return
        }
        if let nd = node {
            inOrderWith(node: nd.left, vistor: vistor)
            visitWithVistor(node: nd,vistor: vistor)
            inOrderWith(node: nd.right, vistor: vistor)
        }
    }

    
    
    /// 带有访问器的遍历
    /// 后序遍历   左 右 根节点
    public func postOrderWith(vistor: (_ node:Node) -> Void) {
        assert(isEmpty() == false, "不能为空")
        postOrderWith(node: root, vistor: vistor)
    }
    
    private func postOrderWith(node: Node?,vistor:(_ node:Node) -> Void) {
        if node == nil {
            return
        }
        if let nd = node {
            postOrderWith(node: nd.left, vistor: vistor)
            postOrderWith(node: nd.right, vistor: vistor)
            visitWithVistor(node: nd,vistor: vistor)
        }
    }

    /// 带有访问器的遍历
    /// 层序遍历  根节点 左 右
    public func levelOrderWith(vistor: (_ node:Node) -> Void) {
        assert(isEmpty() == false, "不能为空")
        let queue = LQueue<Node>()
        if let nd = root {
            queue.enQueue(element: nd)
        }
        
        while !queue.isEmpty() {
            let node = queue.deQueue()
            visitWithVistor(node: node, vistor: vistor)
            
            if node.hasLeft() {
                queue.enQueue(element: node.left!)
            }
            if node.hasRight() {
                queue.enQueue(element: node.right!)
            }
        }
    }
    
    /// 节点访问
    /// - Parameter node: 节点
    private func visitWithVistor(node: Node,vistor:(_ node:Node) -> Void) {
        vistor(node)
    }
}

// MARK: 非递归遍历
extension BinaryTree {
    /// 非递归前序遍历
    public func preOrder2() {
        assert(root != nil, "不能为空")
        let node = root!
        let stack = LStack<Node>()
        stack.push(element: node)
        while !stack.isEmpty() {
            // 弹出
            let nd = stack.pop()
            visit(node: nd)
            
            // 先弹出右,在弹出左
            if nd.hasRight() {
                stack.push(element: nd.right!)
            }
            if nd.hasLeft() {
                stack.push(element: nd.left!)
            }
        }
    }
    
    public func preOrder3() {
        assert(root != nil, "不能为空")
        var node = root
        let stack = LStack<Node>()
        while true {
            if let nd = node {
                // 先访问根节点
                visit(node: nd)
                if nd.hasRight() {
                    stack.push(element: nd.right!)
                }
                // 一路向左
                node = node?.left
            } else {
                if stack.isEmpty() {
                    return
                }
                node = stack.pop()
            }
        }
    }
    
    
    public func inOrder2() {
        assert(root != nil, "不能为空")
        var node = root
        let stack = LStack<Node>()
        while true {
            if let nd = node {
                stack.push(element: nd)
                // 一路想左
                node = node?.left
            } else {
                if stack.isEmpty() {
                    return
                }
               // 不能再左了.去除栈顶访问
                node = stack.pop()
                visit(node: node!)
                // 让右节点继续中序遍历
                node = node?.right
            }
        }
    }
    
    public func postOrder2() {
        assert(root != nil, "不能为空")
        let node = root!
        let stack = LStack<Node>()
        stack.push(element: node)
        // 标记之前访问的
        var previous: Node?
        while !stack.isEmpty() {
            // 看一眼
            let top = stack.top()
            if top.isLeaf() || (previous != nil && previous!.parent === top) {
                // 访问
                previous = stack.pop()
                visit(node: previous!)
            } else {
                if top.hasRight() {
                    stack.push(element: top.right!)
                }
                if top.hasLeft() {
                    stack.push(element: top.left!)
                }
            }
        }
    }
}


/// print
extension BinaryTree {
    public func printTree() {
        if root == nil {
            return
        }
        print("\n")
        print("********************** start **********************")
        let info = BinaryTreeInfo<T>(rootNode: root!)
        let treePrint = LevelOrderPrinter(treeInfo: info)
        treePrint.printTree()
        print("*********************** end **********************")
    }
}
