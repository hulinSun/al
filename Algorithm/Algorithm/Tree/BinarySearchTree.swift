//
//  BinarySearchTree.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/7.
//

/// http://520it.com/binarytrees/

import Foundation

/// 二叉树节点
class BTNode<T: Comparable> {
    /// 左子节点
    var left: BTNode?
    /// 右子节点
    var right: BTNode?
    /// 父节点
    weak var parent: BTNode?
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
}

extension BTNode : CustomStringConvertible {
    var description: String {
        if parent == nil {
            return "【\(element)】🚀 "
        } else {
            return "【\(element)】_ P(\(parent!.element))"
        }
    }
}

/// 添加这个只是想让Node可以添加到队列里去
extension BTNode: Comparable {
    static func < (lhs: BTNode<T>, rhs: BTNode<T>) -> Bool {
        return true
    }
    
    static func == (lhs: BTNode<T>, rhs: BTNode<T>) -> Bool {
        return false
    }
}


/// 二叉搜索树
/// 左边的节点小
/// 右边的节点大
class BinarySearchTree<T: Comparable> {
    
    typealias Node = BTNode<T>
    
    /// 根节点
    var root: Node?
    
    ///  元素的数量
    private(set) var size: Int = 0
    
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
    
    ///  添加元素
    /// - Parameter ele: ele
    public func add(ele: T) {
        let newNode = Node(ele: ele)
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
    }
    
    ///  删除元素
    /// - Parameter ele: ele
    public func remove(ele: T) {
        if let nd = node(ele: ele) {
            remove(node: nd)
        }
    }
    
    /// 是否包含某元素
    /// - Parameter ele: ele
    /// - Returns: 是否包含
    public func contain(ele: T) -> Bool {
        return false
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
                        shouldLeaf = true // 后面遍历的节点都必须是叶子节点
                        queue.enQueue(element: node.left!)
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
        var toDelete = node
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
        }
        
        /// 删除的度为1的节点
        if toDelete.hasSingleChild() {
            let replaceNode = toDelete.hasLeft() ? toDelete.left! : toDelete.right!
            if toDelete.hasParent() {
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
            }
        }
        
        size-=1
    }

}

/// 不带有访问器的遍历
extension BinarySearchTree {
    
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
extension BinarySearchTree {
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

extension BinarySearchTree {
    
    public class func BSTTest() {
        let bst = BinarySearchTree<Int>()
//        let data = [7,4,9,2,5,8,11,1,3,10,12]
//        let data = [4,2,7,1,3,6,9]
//        let data = [7,4,9,6]
//        let data = [8,4,13,2,6,10,1,3,5,7,9,12,11]
        let data = [7,4,9,6,8,1,32,5,2,3]
        for i in data {
            bst.add(ele: i)
        }
        bst.remove(ele: 7)
        bst.levelOrderWith { (node) in
            print(node)
        }
//        bst.levelOrderWith { (node) in
//            print(node)
//        }
//        bst.remove(ele: 3)
//        bst.levelOrderWith { (node) in
//            print(node)
//        }
//        bst.inOrderWith { (node) in
//            print(node)
//        }
//        bst.levelOrder()
//        bst.inOrder()
//        bst.preOrder()
//        bst.postOrder()
//        bst.preOrderWith { (node) in
//            let s = "【" + node.description + "】"
//            print(s)
//        }
//        bst.levelOrderWith { (node) in
//            print(node)
//        }
//        bst.invert2()
//        bst.levelOrderWith { (node) in
//            print(node)
//        }
//        bst.levelOrderWith { (node) in
//            print(node)
//        }
//        print(bst.isComplete())
//        print(bst.height())
//        print(bst.height2())
        
//        if let nd = bst.node(ele: 8) ,let p = bst.predecessor(node: nd) {
//            print(p)
//        }
//
//        if let nd = bst.node(ele: 1) ,let p = bst.predecessor(node: nd){
//            print(p)
//        } else {
//            print("没找到前驱节点")
//        }
        
//        if let nd = bst.node(ele: 8) ,let p = bst.successor(node: nd) {
//            print(p)
//        }
//
//        if let nd = bst.node(ele: 13) ,let p = bst.successor(node: nd){
//            print(p)
//        } else {
//            print("没找到后继节点")
//        }
    }
}

 
