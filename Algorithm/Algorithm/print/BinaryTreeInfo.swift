//
//  BinaryTreeInfo.swift
//  PrintTree
//
//  Created by hony on 2020/11/10.
//  Copyright © 2020 hony. All rights reserved.
//

import UIKit

//protocol BinaryTreeInfo {
//
//    associatedtype Node
//    /// 根节点
//    func rootNode() -> Node
//    /// 返回指定节点的左节点
//    func left(node: Node) -> Node?
//    /// 返回指定节点的右节点
//    func right(node: Node) -> Node?
//    /// 如何打印这个节点。一般打印元素
//    func string(node: Node) -> String
//
//}

class BinaryTreeInfo<T: Comparable> {
    typealias Node = BSTNode<T>

    var root: Node
    init(rootNode: Node) {
        root = rootNode
    }

    /// 返回指定节点的左节点
    public func left(node: Node) -> Node? {
        if node.hasLeft() {
            return node.left!
        }
        return nil
    }
    /// 返回指定节点的右节点
    public func right(node: Node) -> Node? {
        if node.hasRight() {
            return node.right!
        }
        return nil
    }
    /// 如何打印这个节点。一般打印元素
    public func string(node: Node) -> String {
        return node.description
    }
}
