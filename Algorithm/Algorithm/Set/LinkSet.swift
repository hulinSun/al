//
//  LinkSet.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/11/23.
//

import Foundation

class LinkSet<T: Comparable> {
    
    private let linkList = DLinkedList<T>()
    
    public func size() -> Int {
        return linkList.size
    }
    
    public func clear() {
        linkList.clear()
    }
    
    public func contain(ele: T) -> Bool {
        return linkList.contains(element: ele)
    }
    
    // 如果没有在添加，有了在覆盖
    // O(n)
    public func add(ele: T) {
        let index = linkList.indexOf(element: ele)
        if index != -1 {
            _ = linkList.set(index: index, element: ele)
        } else {
            linkList.add(element: ele)
        }
    }
    // O(n)
    public func remove(ele: T) {
        let index = linkList.indexOf(element: ele)
        if index != -1 {
            _ = linkList.remove(index: index)
        }
    }
    public func vistor(visit: (_ ele: T) -> Void ) {
        for i in 0..<linkList.size {
            let e = linkList.get(index: i)
            // 回调出去
            visit(e)
        }
    }
}


extension LinkSet {
    public class func linkSetTest() {
        let set = LinkSet<Int>()
        set.add(ele: 1)
        set.add(ele: 1)
        set.add(ele: 4)
        set.add(ele: 7)
        set.add(ele: 0)
        set.vistor { (e) in
            print("遍历到了\(e)")
        }
        print(set.contain(ele: 1),set.size())
    }
}
