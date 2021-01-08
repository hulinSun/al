//
//  LeeTree.swift
//  Algorithm
//
//  Created by 孙虎林 on 2021/1/8.
//

import Foundation

/// 链接：https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree
/// 给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。
/// 百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”
/// 例如，给定如下二叉树:  root = [3,5,1,6,2,0,8,null,null,7,4]
/// 二叉树的公共祖先
func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?) -> TreeNode? {
    if root == nil {
        return root
    }
    if root?.val == p?.val || root?.val == q?.val {
        return root
    }
    //公共节点在左子树
    let left = lowestCommonAncestor(root?.left, p, q)
    let right = lowestCommonAncestor(root?.right, p, q)
    // 四种情况
    // 在左边
    // 在右边
    // p q 不在树上
    // 一个在左边，一个在右边
    if left != nil && right != nil {
        return root
    }
    if left != nil && right == nil {
        return left
    }
    if left == nil && right != nil {
        return right
    }
    return nil
}
