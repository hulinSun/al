//
//  LevelOrderPrinter.swift
//  PrintTree
//
//  Created by hony on 2020/11/10.
//  Copyright © 2020 hony. All rights reserved.
//

import UIKit

let TOP_LINE_SPACE = 1
let MIN_SPACE = 1

class LOPLevelInfo<T: Comparable> {
    typealias LopNode = LOPNode<T>
    var leftX = 0
    var rightX = 0
    init(left: LopNode, right: LopNode) {
        leftX = left.leftBound()
        rightX = right.rightBound()
    }
}

class LOPNode<T: Comparable>: CustomStringConvertible {

    var description: String {
        var s = ""
        if nullNode {
            s+="null"
        } else {
            if let bt = btNode {
                s += "\(bt.element)"
            }
            s+=string
        }
        
        return s
    }
    
    typealias Node = BSTNode<T>
    typealias LopLevelInfo = LOPLevelInfo<T>
    
    var x: Int = 0
    var y: Int = 0
    var width: Int = 0
    var treeHeight: Int = 0
    var string: String = ""
    
    var left: LOPNode?
    var right: LOPNode?
    weak var parent: LOPNode?
    
    weak var btNode: Node?
    var nullNode: Bool = false
    
    
    init(nodeString: String?) {
        string = nodeString ?? " "
        width = string.count
    }
    
    convenience init(btnode: Node, tree: BinaryTreeInfo<T>) {
        let s = tree.string(node: btnode)
        self.init(nodeString: s)
        btNode = btnode
    }
    
    convenience init(null: Bool) {
          self.init(nodeString: "")
          nullNode = true
    }
    
    public func leftBound() -> Int {
        if left == nil {
            return x
        }
        return left!.topLineX()
    }
    
    public func rightBound() -> Int {
        if right == nil {
            return rightX()
        }
        return right!.topLineX() + 1
    }
    
    public func rightX() -> Int {
          return x + width
    }
    
    public func topLineX() -> Int {
        var delta = width
        if delta % 2 == 0 {
            delta-=1
        }
        delta = delta >> 1
        if parent != nil && self === parent!.left {
            return rightX() - 1 - delta
        } else {
            return x + delta
        }
    }
    
    public func leftBoundLength() -> Int {
        return x - leftBound()
    }
    
    public func rightBoundLength() -> Int {
        return rightBound() - rightX()
    }
    
    public func leftBoundEmptyLength() -> Int {
        return leftBoundLength() - 1 - TOP_LINE_SPACE
    }
    
    public func rightBoundEmptyLength() -> Int {
        return rightBoundLength() - 1 - TOP_LINE_SPACE
    }
    
    public func translateX(deltaX: Int) {
        if deltaX == 0 {
            return
        }
        x += deltaX
        if btNode == nil {
            return
        }
        if let l = left {
            l.translateX(deltaX: deltaX)
        }
        if let r = right {
            r.translateX(deltaX: deltaX)
        }
    }
    
    public func balance(left:LOPNode? , right: LOPNode?) {
        if left == nil || right == nil {
            return
        }
        let deltaLeft = x - left!.rightX()
        let deltaRight = right!.x - rightX()
        let delta = max(deltaLeft, deltaRight)
        let newRightX = rightX() + delta
        right!.translateX(deltaX: newRightX - right!.x)
        
        let newLeftX = x - delta - left!.width
        left!.translateX(deltaX: newLeftX - left!.x)
    }
    
    public func cacluTreeHeight(node: LOPNode?) -> Int {
        guard let nd = node else {
            return 0
        }
        if nd.treeHeight > 0 {
            return nd.treeHeight
        }
        let leftH = cacluTreeHeight(node: nd.left)
        let rightH = cacluTreeHeight(node: nd.right)
        nd.treeHeight = 1 + max(leftH, rightH)
        return nd.treeHeight
    }

    public func levelInfo(level: Int) -> LopLevelInfo? {
        if level == 0 {
            return nil
        }
        let levelY = y + level
        if level >= cacluTreeHeight(node: self) {
            return nil
        }
        
        var list = [LOPNode]()
        var queue = [LOPNode]()
        queue.append(self)
        while queue.count > 0 {
            let node = queue.first!
            queue.remove(at: 0) // 队头出
            if levelY == node.y {
                list.append(node)
            } else if node.y > levelY {
                break
            }
            
            if let nf = node.left {
                queue.append(nf)
            }
            if let nr = node.right {
                queue.append(nr)
            }
        }
        if let left = list.first, let right = list.last {
          return LOPLevelInfo(left: left, right: right)
        }
        return nil
    }
    
    public func minLevelSpaceToRight(right: LOPNode?) -> Int {
        guard let nd = right else {
            return 0
        }
        let thisHeight = cacluTreeHeight(node: self)
        let rightHeight = cacluTreeHeight(node: right)
        var minSpace = 10000
        let minI = min(thisHeight, rightHeight)
        for i in 0..<minI {
            if let l = nd.levelInfo(level: i), let me = self.levelInfo(level: i) {
                let space = l.leftX - me.rightX
                minSpace = min(minSpace, space)
            }
        }
        return minSpace
    }
}

class LevelOrderPrinter<T: Comparable>: TreePrinter<T> {
    typealias LopNode = LOPNode<T>
    typealias Node = BSTNode<T>
    
    var root: LopNode
    var maxWidth = 0
    var minX = 0
    var nodes = [[LopNode]]()
    override init(treeInfo: BinaryTreeInfo<T>) {
        root = LOPNode(btnode:treeInfo.root, tree: treeInfo)
        maxWidth = root.width
        super.init(treeInfo: treeInfo)
    }
    
    override func printString() -> String {
        fillNodes()
//        print(nodes)
//        print("")
        cleanNodes()
//        print(nodes)
//        print("")
        compressNodes()
//        print(nodes)
//        print("")
        addLineNodes()
//        print(nodes)
//        print("")
        
        let rowCount = nodes.count
        var string = ""
        for i in 0..<rowCount {
            if i > 0 {
                string+="\n"
            }
            let rowNodes = nodes[i]
            var rowString = ""
            for node in rowNodes {
                let leftSpace = node.x - rowString.count - minX
                rowString+=String.bt_blank(count: leftSpace)
                rowString+=node.string
            }
            string+=rowString
            
        }
        return string
    }
    
    private func fillNodes() {
        var firstRowNodes = [LopNode]()
        firstRowNodes.append(root)
        nodes.append(firstRowNodes)
        
        while true {
            let preRowNodes = nodes.last!
            var rowNodes = [LopNode]()
            var notNull = false
            for node in preRowNodes {
                if node.nullNode {
                    rowNodes.append(LopNode(null: true))
                    rowNodes.append(LopNode(null: true))
                } else {
                    var leftBtnode:Node? = nil
                    if let lbt = node.btNode{
                        leftBtnode = tree.left(node: lbt)
                    }
                    let left = addNode(nodes: &rowNodes, btnode: leftBtnode)
                    
                    if left.nullNode == false {
                        node.left = left
                        left.parent = node
                        notNull = true
                    }
                    
                    var rightBtnode:Node? = nil
                    if let rbt = node.btNode{
                        rightBtnode = tree.right(node: rbt)
                    }
                    let right = addNode(nodes: &rowNodes, btnode: rightBtnode)
                    if right.nullNode == false {
                        node.right = right
                        right.parent = node
                        notNull = true
                    }
                }
            }
            if notNull == false {
                break
            }
            nodes.append(rowNodes)
        }
    }
    
    private func cleanNodes() {
        let rowCount = nodes.count
        if rowCount < 2 {
            return
        }
        let lastRowNodeCount = nodes.last!.count
        let nodeSpace = maxWidth + 2
        let lastRowLength = lastRowNodeCount * maxWidth + nodeSpace * (lastRowNodeCount - 1)
        for i in 0..<rowCount {
            let rowNodes: [LOPNode] = nodes[i]
            let rowNodeCount = rowNodes.count
            let allSpace = lastRowLength - (rowNodeCount - 1) * nodeSpace
            var cornerSpace = allSpace / rowNodeCount - maxWidth
            cornerSpace = cornerSpace >> 1
            
            var rowLength = 0
            for j in 0..<rowNodeCount {
                if j > 0 {
                    rowLength += nodeSpace
                }
                rowLength += cornerSpace
                let node = rowNodes[j]
                if node.nullNode == false {
                    let deltax = (maxWidth - node.width) >> 1
                    node.x = rowLength + deltax
                    node.y = i
                }
                rowLength += maxWidth
                rowLength += cornerSpace
            }
            // 删除所有的null
            nodes[i] = clearNullnode(rowNodes: rowNodes)
        }
    }
    
    private func clearNullnode(rowNodes: [LopNode]) -> [LopNode] {
        var tempRows = [LopNode]()
        for item in rowNodes {
            if !item.nullNode {
                tempRows.append(item)
            }
        }
        return tempRows
    }
    
    /// 这个方法有问题 干！
    private func compressNodes() {
        let rowCount = nodes.count
        if rowCount < 2 {
            return
        }
        for i in (0...(rowCount - 2)).reversed() {
            let rowNodes = nodes[i]
            for node in rowNodes {
                let left = node.left
                let right = node.right
                if left == nil && right == nil {
                    continue
                }
                if left != nil && right != nil {
                    node.balance(left: left!, right: right!)
                    
                    var leftEmpty = node.leftBoundEmptyLength()
                    var rightEmpty = node.rightBoundEmptyLength()
                    var empty = min(leftEmpty, rightEmpty)
                    let otherEmpty = (right!.x - left!.rightX()) >> 1
                    empty = min(empty, otherEmpty)
                    
                    var space = left!.minLevelSpaceToRight(right: right!) - MIN_SPACE
                    space = min(space >> 1, empty)
                    
                    if space > 0 {
                        left!.translateX(deltaX: space)
                        right!.translateX(deltaX: -space)
                    }
                    
                    space = left!.minLevelSpaceToRight(right: right!) - MIN_SPACE
                    if space < 1 {
                        continue
                    }
                    
                    leftEmpty = node.leftBoundEmptyLength()
                    rightEmpty = node.rightBoundEmptyLength()
                    if leftEmpty < 1 && rightEmpty < 1 {
                        continue
                    }
                    if leftEmpty > rightEmpty {
                        left!.translateX(deltaX: min(leftEmpty, space))
                    } else {
                        right!.translateX(deltaX: -min(rightEmpty, space))
                    }
                } else if left != nil {
                    left!.translateX(deltaX: node.leftBoundEmptyLength())
                } else {
                    right!.translateX(deltaX: node.rightBoundEmptyLength())
                }
            }
        }
    }
    
    private func addLineNode(curRow: inout [LopNode], nextRow: inout [LopNode], parent: LopNode, child: LopNode?) -> LopNode?{
        guard let cd = child else {
            return nil
        }
        var top: LopNode
        let topx = cd.topLineX()
        print("right = \(topx)")
        if cd === parent.left {
            top = LOPNode(nodeString: "┌")
            curRow.append(top)
            for i in ((topx+1)..<parent.x) {
                let line = LopNode(nodeString: "─")
                line.x = i
                line.y = parent.y
                curRow.append(line)
            }
        } else {
            let x = parent.rightX()
            for i in x..<topx {
                let line = LopNode(nodeString: "─")
                line.x = i
                line.y = parent.y
                curRow.append(line)
            }
            top = LOPNode(nodeString: "┐")
            curRow.append(top)
        }
        top.x = topx
        top.y = parent.y
        cd.y = parent.y + 2
        minX = min(minX, cd.x)
//        print("--- \(curRow)")
        let bottom = LopNode(nodeString: "│")
        bottom.x = topx
        bottom.y = parent.y + 1
        nextRow.append(bottom)
        return top
    }
    
    private func addNode(nodes:inout [LopNode], btnode: Node?) -> LopNode {
        var node: LopNode
        if let bt = btnode {
            node = LOPNode(btnode: bt, tree: tree)
            maxWidth = max(maxWidth, node.width)
            nodes.append(node)
        } else {
            node = LOPNode(null: true)
            nodes.append(node)
        }
        return node
    }
    
    private func addLineNodes() {
        var newNodes = [[LopNode]]()
        let  rowCount = nodes.count
        if rowCount < 2 {
            return
        }
        
        minX = root.x
        for i in 0..<rowCount {
            let rowNodes = nodes[i]
            if i == rowCount - 1 {
                newNodes.append(rowNodes)
                continue
            }
            var newRowNodes = [LopNode]()
            var lineNodes = [LopNode]()
            for node in rowNodes {
                _ = addLineNode(curRow: &newRowNodes, nextRow: &lineNodes, parent: node, child: node.left)
                newRowNodes.append(node)
                _ = addLineNode(curRow: &newRowNodes, nextRow: &lineNodes, parent: node, child: node.right)
            }
            // Swift 数组是值类型，用的时候千万注意。不再是引用类型
            newNodes.append(newRowNodes)
            newNodes.append(lineNodes)
        }
        nodes = newNodes
    }
}


extension String {
    func bt_repeat(count: Int) -> String {
        var s = ""
        var c = count
        while (c > 0){
            s.append(contentsOf: self)
            c-=1
        }
        return s
    }
    
    static func bt_blank(count: Int) -> String {
        return " ".bt_repeat(count: count)
    }
}

