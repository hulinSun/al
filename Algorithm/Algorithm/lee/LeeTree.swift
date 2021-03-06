//
//  LeeTree.swift
//  Algorithm
//
//  Created by 孙虎林 on 2021/1/8.
//

import Foundation

public class TreeNode: Comparable {
    public static func < (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.val < rhs.val
    }
    
    public static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        return lhs.val == rhs.val
    }
    
     public var val: Int
     public var left: TreeNode?
     public var right: TreeNode?
     public init() { self.val = 0; self.left = nil; self.right = nil; }
     public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
     public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
         self.val = val
         self.left = left
         self.right = right
     }
}

/// 链接：https://leetcode-cn.com/problems/lowest-common-ancestor-of-a-binary-tree
/// 给定一个二叉树, 找到该树中两个指定节点的最近公共祖先。
/// 百度百科中最近公共祖先的定义为：“对于有根树 T 的两个结点 p、q，最近公共祖先表示为一个结点 x，满足 x 是 p、q 的祖先且 x 的深度尽可能大（一个节点也可以是它自己的祖先）。”
/// 例如，给定如下二叉树:  root = [3,5,1,6,2,0,8,null,null,7,4]
/// 二叉树的公共祖先
/// 如果有父节点的话，可以抽象成  两个链表的第一个公共节点
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

/// 恢复二叉树
/// 链接：https://leetcode-cn.com/problems/recover-binary-search-tree
/// 给你二叉搜索树的根节点 root ，该树中的两个节点被错误地交换。请在不改变其结构的情况下，恢复这棵树。
/// 进阶：使用 O(n) 空间复杂度的解法很容易实现。你能想出一个只使用常数空间的解决方案吗？
func recoverTree(_ root: TreeNode?) {
    /// 中序遍历从小到大的。
    var pre:TreeNode? = nil
    var first:TreeNode? = nil
    var second:TreeNode? = nil
    findWrongNode(node: root, pre: &pre, first: &first, second: &second)
    
    // 交换
    if let f = first, let s = second {
        let temp = f.val
        f.val = s.val
        s.val = temp
    }
}

func findWrongNode(node: TreeNode?, pre: inout TreeNode?, first: inout TreeNode?, second: inout TreeNode?)  {
    // 中序遍历
    if node == nil {
        return
    }
    // 【1,2,3,4,5,6】
    // 【1,5,3,4,2,6】
    // 【1,3,2,4,5,6】
    // 左 中 右
    findWrongNode(node: node?.left, pre: &pre, first: &first, second: &second)
    // 找到逆序对
    // 第一个错误节点是 第一个逆序对的较大节点
    // 第二个错误节点是 第二个逆序对的较小节点
    
    // 逆序对
    if let nd = node, let p = pre, nd.val < p.val {
        if first == nil {
            first =  pre
        }
        second = node
    }
    // 标记上一个
    pre = node
    
    findWrongNode(node: node?.right, pre: &pre, first: &first, second: &second)
}

/// 给一个是，求最大二叉搜索树。返回size
func largestBSTSubtree(root: TreeNode?, maxSz: inout Int)  {
    if root == nil {
        return
    }
    // 遍历
    largestBSTSubtree(root: root?.left, maxSz: &maxSz)
    largestBSTSubtree(root: root?.right, maxSz: &maxSz)
    
    if isBST(node: root) {
        var sz = 0
        getSize(node: root, size: &sz)
        maxSz = max(sz, maxSz)
    }
    
}

/// 给一个节点，判断是否是BST
func isBST(node: TreeNode?) -> Bool {
    if node == nil {
        return false
    }
    // 后续遍历
    _ = isBST(node: node?.left)
    _ = isBST(node: node?.right)
    if node?.left != nil && node?.right != nil {
        return node!.val > node!.left!.val &&   node!.val < node!.right!.val
    }
    if node?.left != nil && node?.right == nil {
        return node!.val > node!.left!.val
    }
    if node?.left == nil && node?.right != nil {
        return node!.val < node!.right!.val
    }
    if node?.left == nil || node?.right == nil {
        return true
    }
    return false
}

func getSize(node: TreeNode? , size: inout Int) {
    if node == nil {
        return
    }
    getSize(node: node?.left, size: &size)
    getSize(node: node?.right, size: &size)
    if node?.left != nil {
        size += 1
    }
    if node?.right != nil {
        size += 1
    }
}

class TreeNodeInfo {
    public var size = 0
    public var max = 0
    public var min = 0
    public var root: TreeNode?
    
    init(sz: Int, ma: Int, mi: Int, ro: TreeNode?) {
        size = sz
        max = ma
        min = mi
        root = ro
    }
}

/// 自底向上。。 后续遍历
func largestBSTSubtree(root: TreeNode?) -> Int {
    if let info = getInfo(node: root) {
        return info.size
    }
    return 0
}

func getInfo(node: TreeNode?) -> TreeNodeInfo? {
    if node == nil {
        return nil
    }
    let left = getInfo(node: node?.left)
    let right = getInfo(node: node?.right)
    /*
    有4种情况，以root为根节点的二叉树就是一棵BST，最大BST子树就是其本身
    ① li != null && ri != null
    && li.root == root.left && root.val > li.max
    && ri.root == root.right && root.val < ri.min

    ② li != null && ri == null
    && li.root == root.left && root.val > li.max

    ③ li == null && ri != null
    && ri.root == root.right && root.val < ri.min

    ④ li == null && ri == null
     */
    var leftBstSize = -1
    var rightBstSize = -1
    var maxVal = node!.val
    var minVal = node!.val
    
    if left == nil {
        leftBstSize = 0
    } else if left != nil && left?.root?.val == node?.left?.val && node!.val > left!.max {
        leftBstSize = left!.size
        minVal = left!.min
    }
    
    if right == nil {
        rightBstSize = 0
    } else if right != nil && right?.root?.val == node?.right?.val && node!.val < right!.min {
        rightBstSize = right!.size
        maxVal = right!.max
    }
    
    if leftBstSize >= 0 && rightBstSize >= 0 {
        let sz = max(leftBstSize, rightBstSize)
        return TreeNodeInfo(sz:sz + 1, ma:maxVal, mi: minVal, ro: node)
    }
    
    if left != nil && right != nil {
        return (left!.size > right!.size) ? left : right
    }
    return left != nil ? left : right
}


/// 二叉树的中序遍历
/// https://leetcode-cn.com/problems/binary-tree-inorder-traversal/
func inorderTraversal(_ root: TreeNode?) -> [Int] {
    func pinorderTraversal(node: TreeNode?, res: inout [Int]) {
        if node == nil {
            return
        }
        if node?.left != nil {
            pinorderTraversal(node: node?.left, res: &res)
        }
        
        res.append(node!.val)
        
        if node?.right != nil {
            pinorderTraversal(node: node?.right, res: &res)
        }
    }
    var res = [Int]()
    pinorderTraversal(node: root, res: &res)
    return res
}

func isPostOrderArray(root: TreeNode?, array: [Int]) -> Bool {
    // 后续遍历
    func isPostOrderNum(node: TreeNode?, idx: inout Int, array: [Int]) -> Bool {
        if node == nil {
            // 最后一个了
            if idx == array.count - 1 {
                return true
            } else {
                return false
            }
        }
        if node?.left != nil {
            _ = isPostOrderNum(node: node?.left, idx: &idx, array: array)
        }
        if node?.right != nil {
            _ = isPostOrderNum(node: node?.right, idx: &idx, array: array)
        }
        // current
        if idx >= array.count || node?.val != array[idx]  {
            return false
        }
        idx += 1
        return true
    }
    
    if root == nil {
        return false
    }
    var idx = 0
    return isPostOrderNum(node: root, idx: &idx, array: array)
}


/// 重建二叉树
/// 知道前序遍历 跟中序遍历的结果，重建二叉树
func rebuild(pre: [Int], inorder: [Int]) -> TreeNode? {
    // 返回根节点
    if pre.count == 0 || inorder.count == 0 || (pre.count != inorder.count) {
        return nil
    }
    // 找到根节点值
    let rootValue = pre.first!
    let root = TreeNode(rootValue)
    
    print("创建了节点\(root.val)")
    var rootIdx = 0
    for (idx,item) in inorder.enumerated() {
        if rootValue == item {
            rootIdx = idx
            break
        }
    }
    var leftPre: [Int]
    // 没有左子树
    if rootIdx == 0 {
        leftPre = [Int]()
    } else {
        // 有左子树
        leftPre = Array<Int>(pre[1...rootIdx])
    }
    
    let rightpre = Array<Int>(pre[rootIdx + 1..<pre.count])
    let leftInorder = Array<Int>(inorder[0..<rootIdx])
    let rightInorder = Array<Int>(inorder[(rootIdx + 1)..<inorder.count])
    // 构建左子树
    root.left = rebuild(pre: leftPre, inorder: leftInorder)
    root.right = rebuild(pre: rightpre, inorder: rightInorder)
    
    return root
}


/// 遍历
func treeInorder(node: TreeNode?) {
    if node == nil {
        return
    }
    treeInorder(node: node?.left)
    print("遍历到了\(node!.val)")
    treeInorder(node: node?.right)
}


func treepreorder(node: TreeNode?) {
    if node == nil {
        return
    }
    print("遍历到了\(node!.val)")
    treepreorder(node: node?.left)
    treepreorder(node: node?.right)
}


/// 二叉树合并
/// https://leetcode-cn.com/problems/merge-two-binary-trees/
func mergeTrees(_ t1: TreeNode?, _ t2: TreeNode?) -> TreeNode? {
    func dfs(_ n1: TreeNode?, _ n2: TreeNode?) -> TreeNode?{
        if n1 == nil || n2 == nil {
            return n1 == nil ? n2 : n1
        }
        n1!.val += n2!.val
        n1?.left = dfs(n1?.left, n2?.left)
        n1?.right = dfs(n1?.right, n2?.right)
        return n1
    }
    
    if t1 == nil {
        return t2
    }
    if t2 == nil {
        return t1
    }
    return dfs(t1, t2)
}

/// 遍历做法
/// 补0法
func mergeTrees2(_ t1: TreeNode?, _ t2: TreeNode?) -> TreeNode? {
    if t1 == nil {
        return t2
    }
    if t2 == nil {
        return t1
    }
    let q = LQueue<TreeNode>()
    q.enQueue(element: t1!)
    q.enQueue(element: t2!)
    while !q.isEmpty() {
        let n1 = q.deQueue()
        let n2 = q.deQueue()
        n1.val += n2.val
        
        if n1.left != nil && n2.left != nil {
            q.enQueue(element: n1.left!)
            q.enQueue(element: n2.left!)
        }
        if n1.left == nil || n2.left == nil {
            let vn = n1.left == nil ? n2.left : n1.left
            q.enQueue(element: vn!)
            q.enQueue(element: TreeNode(0))
        }
        
        if n1.right != nil && n2.right != nil{
            q.enQueue(element: n1.right!)
            q.enQueue(element: n2.right!)
        }
        
        if n1.right == nil || n2.right == nil {
            let vn = n1.right == nil ? n2.right : n1.right
            q.enQueue(element: vn!)
            q.enQueue(element: TreeNode(0))
        }
    }
    return t1
}

func mergeTrees3(_ t1: TreeNode?, _ t2: TreeNode?) -> TreeNode? {
    if t1 == nil {
        return t2
    }
    if t2 == nil {
        return t1
    }
    let q = LQueue<TreeNode>()
    q.enQueue(element: t1!)
    q.enQueue(element: t2!)
    while !q.isEmpty() {
        let n1 = q.deQueue()
        let n2 = q.deQueue()
        n1.val += n2.val
        
        if n1.left != nil && n2.left != nil {
            q.enQueue(element: n1.left!)
            q.enQueue(element: n2.left!)
        } else if n1.left == nil {
            n1.left = n2.left
        }
        
        if n1.right != nil && n2.right != nil{
            q.enQueue(element: n1.right!)
            q.enQueue(element: n2.right!)
        } else if n1.right == nil {
            n1.right = n2.right
        }
    }
    return t1
}

/// 二叉树的最大深度
/// 递归解法
func maxDepth(_ root: TreeNode?) -> Int {
    if root == nil {
        return 0
    }
    var left = 0
    var right = 0
    if root?.left != nil {
        left = maxDepth(root?.left)
    }
    if root?.right != nil {
        right = maxDepth(root?.right)
    }
    return max(left, right) + 1
}

/// 层序遍历法
func maxDepth2(_ root: TreeNode?) -> Int {
    if root == nil {
        return 0
    }
    let q = LQueue<TreeNode>()
    q.enQueue(element: root!)
    /// 每一层有多少个节点
    var levelSize = 1
    var hight = 0
    
    while !q.isEmpty() {
        let node = q.deQueue()
        levelSize -= 1
        if node.left != nil {
            q.enQueue(element: node.left!)
        }
        if node.right != nil {
            q.enQueue(element: node.right!)
        }
        // 都添加完毕之后，levelsize = q.size
        if levelSize == 0 {
            hight += 1
            levelSize = q.size()
        }
    }
    return hight
}


