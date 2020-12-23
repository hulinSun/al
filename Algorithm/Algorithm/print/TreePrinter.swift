//
//  TreePrinter.swift
//  PrintTree
//
//  Created by hony on 2020/11/10.
//  Copyright © 2020 hony. All rights reserved.
//

import UIKit

class TreePrinter<T: Comparable> {
    
    var tree: BinaryTreeInfo<T>
    init(treeInfo: BinaryTreeInfo<T>) {
        tree = treeInfo
    }
    public func println() {
        printTree()
        print("\n")
    }
    public func printTree() {
        print(printString().utf8)
    }
    
    public func printString() -> String{
        /// 子类实现
        return ""
    }
}
