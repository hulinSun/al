//
//  UnionFind_QU.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/5.
//

import Foundation


/// 基于rank的优化，虽然树的高度相对平衡一些了。但是随着union的次数增多。树的高度越来越高。还需要慢慢优化下find的速度

/// 路径分裂
/// 让路径上的每个节点，都指向去祖父节点，parent.parent
class UnionFind_Spliting: UnionFind_Rank  {
    /// 基于路径分裂的优化
    override func find(v: Int) -> Int {
        var value = v
        while value != parent[value] {
            /// 保存下父节点
            let p = parent[value]
            parent[value] = parent[p]
            value = p
        }
        return value
    }
}

