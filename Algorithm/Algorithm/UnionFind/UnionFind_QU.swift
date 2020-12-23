//
//  UnionFind_QU.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/5.
//

import Foundation

/// quick union 并查集  O(logN)
/// union (1,2) 的话，最差情况下回编程O(N)   树退化成链表的情况。所以还需要优化。
/// 避免union到最后成链表。
class UnionFind_QU: UnionFind {

    /// 找根节点 ( v = parent[v]的时候。才是根节点,)
    /// 通过parent链条不断地向上找，直到找到根节点
    override func find(v: Int) -> Int {
        var value = v
        while value != parent[value] {
            value = parent[value]
        }
        return value
    }
    
    /// 让v1的根节点，指向v2的根节点
    /// union(3,4) 3的根节点改为4的根节点
    /// 将v1的根节点嫁接到v2的根节点上
    override func union(v1: Int, v2: Int) {
        let rootV1 = find(v: v1)
        let rootV2 = find(v: v2)
        if rootV1 == rootV2 {
            return
        }
        // rootV1 是idx,又是value 因为 rootV1 = parent[rootV1]
        // 修改v1的根节点
        parent[rootV1] = rootV2
    }
}
