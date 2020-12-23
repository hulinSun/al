//
//  UnionFind_QU.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/5.
//

import Foundation

/// quick find 并查集
class UnionFind_QF: UnionFind {
    
    // 0(1)
    override func find(v: Int) -> Int {
        return parent[v]
    }
    
    // 0(N)
    // 让v1 的父节点指向 v2的父节点
    override func union(v1: Int, v2: Int) {
        let pv1 = find(v: v1)
        let pv2 = find(v: v2)
        if pv1 == pv2 {
            return
        }
        
        //合并
        // union(1,2) 1跟随2 把1的父节点改为2的父节点
        for idx in 0..<parent.count {
            if parent[idx] == pv1 {
                parent[idx] = pv2
            }
        }
    }
  
}
