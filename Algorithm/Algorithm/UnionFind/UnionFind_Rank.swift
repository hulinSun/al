//
//  UnionFind_QU.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/5.
//

import Foundation


/// quick union
/// 基于rank的优化
/// 矮的树嫁接到高的树上
class UnionFind_Rank: UnionFind_QU {

    private var rank: [Int]
    override init(capa: Int) {
        rank = Array<Int>(repeating: 0, count: capa)
        super.init(capa: capa)
        // rank赋值, idx: 是值， value = 这个值得高度
        for idx in 0..<rank.count {
            // 默认为1.
            rank[idx] = 1
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
        /// 因为是从根节点嫁接。所以两棵树高度不等时，嫁接后整体高度还是不变
        if rank[rootV1] < rank[rootV2] {
            parent[rootV1] = rootV2
        } else if rank[rootV1] > rank[rootV2]{
            parent[rootV2] = rootV1
        } else {
            // 只有两颗树的高度相等,才需要更新树的高度。
            // 两颗树，一高一矮，不会影响到树的整体高度
            // 两个树的高度相等。随便哪边都可以，
            parent[rootV1] = rootV2
            rank[rootV2] += 1
        }
    }
    
    override func display() {
        super.display()
        var idxStr = "  值:"
        var valueStr = "高度:"
        for (idx, value) in rank.enumerated() {
            idxStr += "[\(idx)] "
            valueStr += " \(value)  "
        }
        print(idxStr)
        print(valueStr)
        print("\n")
    }
}

