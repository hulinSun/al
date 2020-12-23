//
//  TreeSet.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/23.
//

import Foundation


class TreeSet<T: Comparable> {
    
    private let tree = RBTree<T>()
    
    public func size() -> Int {
        return tree.size
    }
    
    public func clear() {
        tree.clear()
    }
    
    public func contain(ele: T) -> Bool {
        return tree.contain(ele: ele)
    }
    
    public func add(ele: T) {
        tree.add(ele: ele)
    }
    
    public func remove(ele: T) {
        tree.remove(ele: ele)
    }
    
    public func vistor(visit: (_ ele: T) -> Void) {
        levelOrderVistor(visit: visit)
    }
    
    private func levelOrderVistor(visit: (_ ele: T) -> Void) {
        if tree.isEmpty() {
            return
        }
        tree.levelOrderWith { (node) in
            visit(node.element)
        }
    }
}


extension TreeSet {
    public class func TreeSetTest() {
        let treeSet = TreeSet<Int>()
        treeSet.add(ele: 1)
        treeSet.add(ele: 3)
        treeSet.add(ele: 4)
        treeSet.vistor { (i) in
            print("遍历 \(i)")
        }
    }
}
