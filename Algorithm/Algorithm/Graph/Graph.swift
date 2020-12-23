//
//  Graph.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/6.
//

import Foundation

/// 图API
/// G<V,E>
/// v 代表顶点集合 ，E 代表边集合
/// 常见实现图的方案
/// 邻接矩阵： V:一维数组 E： 二维数组 （适合比较稠密的图。不然浪费内存）
/// 邻接表： V: 一维数组， E： 链表。 相当于数组存放的都是链表表头。 表后面的元素为根这个定点有关系的元素

/// 社交网络 地图导航等

class Graph<V: Hashable> : CustomStringConvertible {
    
    ///  key是v的值， value 是顶点对象。 存储所有的顶点
    private var vertices = Dictionary<V,Vertex<V>>()
    
    /// 存储所有的边
    private var edges = Set<Edge<V>>()
    
    /// 添加一个顶点
    public func addVertex(value: V) {
        // 如果已经有顶点了。不在重复添加
        if vertices[value] != nil {
            return
        }
        // 创建新的顶点
        let newVertex = Vertex(v: value)
        vertices[value] = newVertex
    }
    
    /// 添加一条边
    public func addEdge(from: V, to: V) {
        addEdge(from: from, to: to, weight: 0)
    }
    
    /// 添加一条边,带有权重的
    public func addEdge(from: V, to: V, weight: Int) {
        // 1.先判断value对应的值是否已经有顶点了
        if getVertex(value: from) == nil {
            addVertex(value: from)
        }
        if getVertex(value: to) == nil {
            addVertex(value: to)
        }
        // 获取节点
        let fromVertex: Vertex<V>! = getVertex(value: from)
        let toVertex: Vertex<V>! = getVertex(value: to)
        // 2.有可能是已经存在这条边了。只是需要更新下权重
        // 创建一条边
        let edge = Edge<V>(fromV: fromVertex, toV: toVertex)
        if edges.contains(edge) {
            // 删除重新添加
            edges.remove(edge)
        }
        // 获取到顶点了之后。建立下关系
        fromVertex.outEdges.insert(edge)
        toVertex.inEdges.insert(edge)
        // 统计边
        edges.insert(edge)
    }
    
    /// 删除一个顶点
    public func removeVertex(value: V) {
        guard let vertex = getVertex(value: value) else {
            return
        }
        // 删除出边,入边相关
        
        // 出边
        let newOutSet = vertex.outEdges.filter { (edge) -> Bool in
            return edge.from.value != vertex.value
        }
        vertex.outEdges = newOutSet
        
        // 入边
        let newInSet = vertex.inEdges.filter { (edge) -> Bool in
            return edge.to.value != vertex.value
        }
        vertex.inEdges = newInSet
        
        // 顶点集合
        vertices.removeValue(forKey: value)
        
        // 删除边集合
        let newEdges = edges.filter { (edge) -> Bool in
            if edge.from.value == value || edge.to.value == value {
                return false
            }
            return true
        }
        edges = newEdges
    }
    
    /// 删除一条边
    public func removeEdge(from: V, to: V) {
        // 先看看这条边是否存在
        if getVertex(value: from) == nil || getVertex(value: to) == nil {
            // 顶点不存在，边肯定都不存在
            return
        }
        
        // 顶点存在
        // 获取顶点
        let fromVertex: Vertex<V>! = getVertex(value: from)
        let toVertex: Vertex<V>! = getVertex(value: to)
        
        let edge = Edge<V>(fromV: fromVertex, toV: toVertex)
        fromVertex.outEdges.remove(edge)
        toVertex.inEdges.remove(edge)
        
        // 边集合 -> 注意这里的equal方法非常重要。
        edges.remove(edge)
    }
    
    /// 顶点总个数
    public func verticeSzie() -> Int {
        return vertices.count
    }
    
    /// 边的条数
    public func edgesSize() -> Int {
        return edges.count
    }
    
    /// 广度优先遍历
    public func bfs(value: V) {
        guard let begin = getVertex(value: value) else {
            return
        }
        // 存储已经访问过得节点
        var visitedVertex = Set<Vertex<V>>()
        let queue = LQueue<Vertex<V>>()
        queue.enQueue(element: begin)
        while !queue.isEmpty() {
            let vertex = queue.deQueue()
            print(vertex)
            // 遍历出 -> 能触达的
            vertex.outEdges.forEach { (edge) in
                if !visitedVertex.contains(edge.to) {
                    queue.enQueue(element: edge.to)
                    visitedVertex.insert(edge.to)
                }
            }
        }
    }
    
    public func dfs2(value: V) {
        guard let begin = getVertex(value: value) else {
            return
        }
        let stack = LStack<Vertex<V>>()
        stack.push(element: begin)
        var vistedVertex = Set<Vertex<V>>()
        print(begin)
        vistedVertex.insert(begin)
        while !stack.isEmpty() {
            let vertex = stack.pop()
            for edge in vertex.outEdges {
                if vistedVertex.contains(edge.to) {
                    continue
                }
                stack.push(element: edge.from)
                stack.push(element: edge.to)
                vistedVertex.insert(edge.to)
                print(edge.to)
                break
            }
        }
    }
    
    /// 深度优先遍历 递归版本
    public func dfs(value: V) {
        guard let begin = getVertex(value: value) else {
            return
        }
        // 存储已经访问过得节点
        var visitedVertex = Set<Vertex<V>>()
        dfs(vertex: begin, vistedVertex: &visitedVertex)
    }
    
    /// 拓扑排序执行结果
    public func topoLoginSort() -> [V] {
        var result = [V]()
        let queue = LQueue<Vertex<V>>()
        /// 顶点， 对应入度
        var ins = Dictionary<Vertex<V>,Int>()
        for (_, vertex) in vertices {
            // 入度为0
            if vertex.inEdges.count == 0 {
                queue.enQueue(element: vertex)
            } else {
                // 入度表
                ins[vertex] = vertex.inEdges.count
            }
        }
        // queue
        while !queue.isEmpty() {
            // 出来了
            let vt = queue.deQueue()
            result.append(vt.value)
            vt.outEdges.forEach { (edge) in
                // 更新
                // 更新入度-1
                let toVertex = edge.to
                var inValue = ins[toVertex]!
                inValue -= 1
                if inValue > 0 {
                    ins[toVertex] = inValue
                } else {
                    queue.enQueue(element: toVertex)
                }
            }
        }
        return result
    }
    
    private func dfs(vertex: Vertex<V>, vistedVertex: inout Set<Vertex<V>>) {
        // 访问节点
        print(vertex)
        // 访问过了
        vistedVertex.insert(vertex)
        vertex.outEdges.forEach { (edge) in
            if !vistedVertex.contains(edge.to) {
                dfs(vertex: edge.to, vistedVertex: &vistedVertex)
            }
        }
    }
    
    
    var description: String {
        var vv = ""
        for v in vertices {
            vv += "\(v.value) \n"
        }
        var s = "**************** begin *********************\n"
        s += "顶点个数:\(verticeSzie()) \n"
        s += "顶点集合:\n\(vv) \n"
        s += "边个数: \(edgesSize()) \n"
        s += "边集合: \(edges)\n"
        s += "**************** end *********************\n"
        return s
    }
    
    private func getVertex(value: V) -> Vertex<V>? {
        return vertices[value]
    }
}


/// 顶点
class Vertex<V: Hashable>: Hashable, CustomStringConvertible, Comparable {
    
    /// 进来的边
    var inEdges = Set<Edge<V>>()
    /// 出去的边
    var outEdges = Set<Edge<V>>()
    /// 存储的值
    var value: V
    
    init(v: V) {
        value = v
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }
    
    static func == (lhs: Vertex<V>, rhs: Vertex<V>) -> Bool {
        var lhsHasher = Hasher()
        var rhsHasher = Hasher()
        lhs.hash(into: &lhsHasher)
        rhs.hash(into: &rhsHasher)
        return lhsHasher.finalize() == rhsHasher.finalize()
    }
    
    static func < (lhs: Vertex<V>, rhs: Vertex<V>) -> Bool {
        return false
    }
    
    var description: String {
        var s = "顶点值：\(value)"
        s += " 出边集合: \(outEdges),"
        s += " 入边集合: \(inEdges)"
        return s
    }
}

/// 边
class Edge<V: Hashable>: Hashable, CustomStringConvertible {
   
    /// 权重
    var weght: Int = 0
    /// from  出顶点
    var from: Vertex<V>
    /// to 入顶点
    var to: Vertex<V>
    
    init(fromV: Vertex<V>, toV: Vertex<V>) {
        from = fromV
        to = toV
    }
    
    var description: String {
        return "\(from.value) -> \(to.value)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(from)
        hasher.combine(to)
    }
    static func == (lhs: Edge<V>, rhs: Edge<V>) -> Bool {
        var lhsHasher = Hasher()
        var rhsHasher = Hasher()
        lhs.hash(into: &lhsHasher)
        rhs.hash(into: &rhsHasher)
        return lhsHasher.finalize() == rhsHasher.finalize()
    }
}




extension Graph {
    public class func test() {
        topo()
    }
    
    public class func test1() {
        let g = Graph<Int>()
        g.addEdge(from: 3, to: 7)
        g.addEdge(from: 3, to: 6)
        g.addEdge(from: 3, to: 5)
        g.addEdge(from: 6, to: 7)
        g.addEdge(from: 4, to: 7)
        g.addEdge(from: 4, to: 6)
        g.addEdge(from: 5, to: 6)
        g.addEdge(from: 6, to: 2)
        
//        g.removeVertex(value: 5)
//        g.removeEdge(from: 3, to: 6)
//        g.removeVertex(value: 6)
//        g.bfs(value: 6)
        g.dfs(value: 1)
        print(g)
    }
    
    public class func test2() {
        let g = Graph<Int>()
        g.addEdge(from: 2, to: 0)
        g.addEdge(from: 6, to: 2)
        g.addEdge(from: 1, to: 2)
        g.addEdge(from: 1, to: 3)
        g.addEdge(from: 1, to: 5)
        g.addEdge(from: 7, to: 6)
        g.addEdge(from: 5, to: 6)
        g.addEdge(from: 5, to: 7)
        
//        g.removeVertex(value: 5)
//        g.removeEdge(from: 3, to: 6)
//        g.removeVertex(value: 6)
//        g.bfs(value: 5)
        g.dfs(value: 1)
        print("---")
        g.dfs2(value: 1)
        print(g)
    }
    public class func topo() {
        let g = Graph<Int>()
        g.addEdge(from: 3, to: 1)
        g.addEdge(from: 3, to: 7)
        g.addEdge(from: 3, to: 5)
        
        g.addEdge(from: 1, to: 0)
        
        g.addEdge(from: 0, to: 2)
        
        g.addEdge(from: 5, to: 7)
        
        g.addEdge(from: 2, to: 5)
        g.addEdge(from: 2, to: 6)
        
        g.addEdge(from: 7, to: 6)
        g.addEdge(from: 6, to: 4)
        
        print(g.topoLoginSort())
        print(g)
    }
}
