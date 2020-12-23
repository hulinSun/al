//
//  TreeMap.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/26.
//

import Foundation

/// 局限性： key 必须具有可比较性
class TreeMap<K: Comparable,V> {
    
    typealias Node = KVNode<K,V>
    /// 红黑树根节点
    private var root: Node?
    /// size
    private(set) var size: Int = 0
    /// 是否为空
    /// - Returns: 是否
    public func isEmpty() -> Bool {
        return size == 0
    }
    /// 清空
    public func clear() -> Void {
        size = 0
        root = nil
    }
    
    /// 遍历
    /// - Returns:
    public func travse(_ visitor: (Node)-> Bool) -> Void {
        if isEmpty() {
            return
        }
        travse(node: root!, visitor)
    }
    
    /// 添加
    /// - Parameters:
    ///   - key: key
    ///   - value: value
    /// - Returns: 返回value
    public func put(key: K, value: V) -> V {
        let newNode = Node(k: key, v: value)
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
                    compareValue = compare(key1: key, key2: nd.key)
                    if compareValue < 0 {
                        node = node?.left
                    } else if compareValue > 0 {
                        node = node?.right
                    } else { // 相等
                        nd.value = value
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
        return newNode.value
    }
    
    public func get(key: K) -> V? {
        return node(key: key)?.value
    }
    
    public func remove(key: K) {
        guard let nd = node(key: key) else {
            return
        }
        remove(node: nd)
    }
    
    public func containKey(_ key: K) -> Bool {
        return node(key: key) != nil
    }
        
    private func compare(key1: K, key2: K) -> Int {
        if key1 > key2 {
            return 1
        } else if key1 < key2 {
            return -1
        } else {
            return 0
        }
    }
    
    private func afterAddNode(node: Node) {
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
        node.color = color
        return node
    }
    private func red(node: Node) -> Node {
        makeMolor(node: node, color: .Red)
    }
    private func black(node: Node) -> Node {
        makeMolor(node: node, color: .Black)
    }
    private func isBlack(node: Node?) -> Bool {
        /// 虚拟节点默认为黑色
        guard let nd = node else { return true }
        return nd.color == .Black
    }
    private func isRed(node: Node?) -> Bool {
        guard let nd = node else { return false }
        return nd.color == .Red
    }
    
    private func node(key: K) -> Node? {
        if isEmpty() {
            return nil
        }
        var node: Node? = root
        var compareValue = 0
        while node != nil {
            if let nd = node {
                compareValue = compare(key1: key, key2: nd.key)
                if compareValue < 0 {
                    node = node?.left
                } else if compareValue > 0 {
                    node = node?.right
                } else { // 相等
                    return nd
                }
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
            node.key = prede.key
            node.value = prede.value
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
    
    /// 删除节点
    /// - Parameters:
    /// - node: 删除的节点
    /// - replacement: 用以替代删除节点的节点，单叶子节点
    private func afterRemoveNode(node: Node, replacement: Node?) {
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
                        _ = makeMolor(node: sibling, color: parent.color)
                        _ = black(node: parent)
                        _ = black(node: sibling.right!)
                    } else {
                        rotateRight(node: sibling)
                        rotateLeft(node: parent)
                        _ = makeMolor(node: sibling.left!, color: parent.color)
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
                        _ = makeMolor(node: sibling, color: parent.color)
                        _ = black(node: parent)
                        _ = black(node: sibling.left!)
                    } else { // LR
                        rotateLeft(node: sibling)
                        rotateRight(node: parent)
                        _ = makeMolor(node: sibling.right!, color: parent.color)
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
    
    /// 中序遍历
    private func travse(node: Node, _ visitor: (Node)-> Bool) {
        if node.hasLeft() {
            travse(node: node.left!, visitor)
        }
        if visitor(node) {
            return
        }
        if node.hasRight() {
            travse(node: node.right!, visitor)
        }
    }
}

extension TreeMap {
    public class func treeMapTest() {
        let treemap = TreeMap<String, Int>()
        _ = treemap.put(key: "a", value: 1)
        _ = treemap.put(key: "b", value: 2)
        _ = treemap.put(key: "c", value: 3)
        _ = treemap.put(key: "d", value: 4)
        _ = treemap.put(key: "e", value: 5)
       
        print(treemap.size)
        print(treemap.containKey("a"))
        treemap.remove(key: "a")
        treemap.travse { (node) in
            print(node)
            if node.key == "d" {
                return true
            }
            return false
        }
//        treemap.clear()
//        print(treemap.size)
    }
}
