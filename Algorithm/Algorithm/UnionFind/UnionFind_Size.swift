//
//  UnionFind_QU.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/5.
//

import Foundation


/// quick union
/// 基于size的优化
/// 元素少的嫁接到元素多的树上
class UnionFind_Size: UnionFind_QU {

    private var size: [Int]
    override init(capa: Int) {
        size = Array<Int>(repeating: 0, count: capa)
        super.init(capa: capa)
        // size赋值, idx: 是值， value = 对应的这个值下面子节点的个数 size
        for idx in 0..<size.count {
            // 默认为1.自己就是自己的根节点
            size[idx] = 1
        }
    }
    
    /// 基于size的优化
    /// 元素少的嫁接到元素多的树上
    override func union(v1: Int, v2: Int) {
        let rootV1 = find(v: v1)
        let rootV2 = find(v: v2)
        if rootV1 == rootV2 {
            return
        }
        if size[rootV1] < size[rootV2] {
            parent[rootV1] = rootV2
            size[rootV2] += size[rootV1]
        } else {
            parent[rootV2] = rootV1
            size[rootV1] += size[rootV2]
        }
    }
    
    override func display() {
        super.display()
        var idxStr = "  值:"
        var valueStr = "size:"
        for (idx, value) in size.enumerated() {
            idxStr += "[\(idx)] "
            valueStr += " \(value)  "
        }
        print(idxStr)
        print(valueStr)
        print("\n")
    }
}

