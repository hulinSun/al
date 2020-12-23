//
//  UnionFind.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/5.
//

import Foundation

class UnionFind {
    
    public var capacity: Int
    public var parent: [Int]!
    
    init(capa: Int) {
        assert(capa > 0 , "capacity 必须大于0")
        capacity = capa
        parent = Array<Int>(repeating: 0, count: capacity)
        // idx为存储的值， value为当前存储值得父节点
        for idx in 0..<capacity {
            parent[idx] = idx
        }
    }
    
    /// 查找v所属的集合（根节点）
    /// - Parameter v: v
    /// - Returns: 根节点
    public func find(v: Int) -> Int {
        // 子类实现
        return 0
    }
    
    /// 合并v1、v2所在的集合
    public func union(v1: Int, v2: Int) {
        // 子类实现
    }
    
    public func isSame(v1: Int, v2: Int) -> Bool {
        return find(v: v1) == find(v: v2)
    }
    
    public func display() {
        var idxStr = "   值:"
        var valueStr = "父节点:"
        for (idx, value) in parent.enumerated() {
            idxStr += "[\(idx)] "
            valueStr += " \(value)  "
        }
        print(idxStr)
        print(valueStr)
        print("\n")
    }
}


extension UnionFind {
    public class func ufTest() {
//        UnionFind_QFTest()
//        UnionFind_QUTest()
        UnionFind_QUSizeTest()
        UnionFind_QURankTest()
    }
    
    public class func UnionFind_QFTest() {
        let uf = UnionFind_QF(capa: 12)
        testWithUN(uf: uf)
    }
    
    public class func UnionFind_QUTest() {
        let uf = UnionFind_QU(capa: 12)
        testWithUN(uf: uf)
    }
    
    
    public class func UnionFind_QUSizeTest() {
        let uf = UnionFind_Size(capa: 12)
        testWithUN(uf: uf)
    }
    public class func UnionFind_QURankTest() {
        let uf = UnionFind_Rank(capa: 12)
        testWithUN(uf: uf)
    }
    
    private class func testWithUN(uf: UnionFind) {
        uf.union(v1: 4, v2: 0)
        uf.union(v1: 3, v2: 0)
        uf.union(v1: 1, v2: 0)
        uf.union(v1: 3, v2: 2)
        uf.union(v1: 5, v2: 2)
        
        uf.union(v1: 7, v2: 6)
        
        uf.union(v1: 9, v2: 8)
        uf.union(v1: 10, v2: 8)
        uf.union(v1: 11, v2: 9)
        
        uf.display()
        
        print(uf.isSame(v1: 0, v2: 5))
        print(uf.isSame(v1: 1, v2: 7))
        print(uf.isSame(v1: 6, v2: 7))
        print(uf.isSame(v1: 10, v2: 7))
        print(uf.isSame(v1: 10, v2: 8))
        
        uf.union(v1: 6, v2: 10)
        uf.display()
        print(uf.isSame(v1: 6, v2: 11))
    }
    
}

