//
//  Greedy.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/12/12.
//

import Foundation

/**
贪心策略并不一定能得到全局最优解
因为一般没有测试所有可能的解，容易过早做决定，所以没法达到最佳解 贪图眼前局部的利益最大化，看不到长远未来，走一步看一步
◼ 优点:简单、高效、不需要穷举所有可能，通常作为其他算法的辅助算法来使用
◼ 缺点:鼠目寸光，不从整体上考虑其他可能，每次采取局部最优解，不会再回溯，因此很少情况会得到最优解
 */

class Greedy {
    /// 加勒比问题 (最优装载问题)
    /// 海盗船的载重量为 W，每件古董的重量为 𝑤i，海盗们该如何把尽可能多数量的古董装上海盗船?
    /// 比如 W 为 30，𝑤i 分别为 3、5、4、10、7、14、2、11
    /// 数量最多 --> 每次选择的应该是重量最小的那一个。
    class func haidao() {
        let array = [3,5,4,10,7,14,2,11]
        let sortedArray = array.sorted(by: <)
        /// 装载件数
        var count = 0
        /// 已经装载重量
        var hasBaged = 0
        /// 船的载重
        let capacity = 30
        /// 优先选择最小的
        for weight in sortedArray {
            let willBag = weight + hasBaged
            if willBag <= capacity {
                print("装载重量 \(weight) ")
                hasBaged = willBag
                count += 1
            }
        }
        
        print("最多能装载件数：\(count)")
    }
    
    /// 零钱兑换
    /// 假设有 25 分、10 分、5 分、1 分的硬币，现要找给客户 41 分的零钱，如何办到硬币个数最少?
    /// 每次取出的是最大面额即可
    class func cionChange() {
        let array = [25,10,5,1]
        /// 优先取最大的面额
        let sortedArray = array.sorted(by: >)
        /// 硬币个数
        var count = 0
        /// 已经找了多少钱
        var changed = 0
        /// 找多少钱
        let money = 41
        
        /// 只要没找完，就一直找
        while changed < money {
            for idx in 0 ..< sortedArray.count{
                let singleMax = sortedArray[idx]
                let willChanged = changed + singleMax
                if willChanged <= money {
                    changed = willChanged
                    print("找了 \(singleMax) 分, 还剩下\(money - changed) 没有找")
                    count += 1
                    // 找完一次，下次从头找
                    break
                }
            }
        }
    }
    
    
    /// 01 背包问题
    /**
    ◼有 n 件物品和一个最大承重为 W 的背包，每件物品的重量是 𝑤i、价值是 𝑣i
    在保证总重量不超过 W 的前提下，将哪几件物品装入背包，可以使得背包的总价值最大?
    注意:每个物品只有 1 件，也就是每个物品只能选择 0 件或者 1 件，因此称为 0-1背包问题
    ◼ 如果采取贪心策略，有3个方案
    1 价值主导:优先选择价值最高的物品放进背包
    2 重量主导:优先选择重量最轻的物品放进背包
    3 价值密度主导:优先选择价值密度最高的物品放进背包(价值密度 = 价值 ÷ 重量)
    */
    class func bag() {
        let goods = [
            Goods(w: 35, v: 10),
            Goods(w: 30, v: 40),
            Goods(w: 60, v: 30),
            Goods(w: 50, v: 50),
            Goods(w: 40, v: 35),
            Goods(w: 10, v: 40),
            Goods(w: 25, v: 30)
        ]
        
        for good in goods {
            print(good)
        }
        
        /// 背包最多装重量为150。
        let maxCapacity = 150
        print("价值优先:")
        valueFirst(goods: goods, maxCapacity: maxCapacity)

        print("价值密度优先:")
        densityFirst(goods: goods, maxCapacity: maxCapacity)

        print("重量优先:")
        weightFirst(goods: goods, maxCapacity: maxCapacity)
    }
    
    /// 价值优先
    private class func valueFirst(goods: [Goods], maxCapacity: Int) {
        // 按照价值从大到小排序。优先选择价值最大的
        let sortedGoods = goods.sorted { (g1, g2) -> Bool in
            return g1.value > g2.value
        }
        /// 已经放入包里面的
        var baged = 0
        /// 存储结果
        var result = [Goods]()
        for good in sortedGoods {
            let willBaged = baged + good.weight
            if willBaged <= maxCapacity {
                // 放入包里
                result.append(good)
                baged = willBaged
            }
        }
        displayGoods(goods: result)
    }
    
    
    /// 重量优先
    private class func weightFirst(goods: [Goods], maxCapacity: Int) {
        let sortedGoods = goods.sorted { (g1, g2) -> Bool in
            return g1.weight < g2.weight
        }
        /// 已经放入包里面的
        var baged = 0
        /// 存储结果
        var result = [Goods]()
        for good in sortedGoods {
            let willBaged = baged + good.weight
            if willBaged <= maxCapacity {
                // 放入包里
                result.append(good)
                baged = willBaged
            }
        }
        displayGoods(goods: result)
    }

    
    private class func densityFirst(goods: [Goods], maxCapacity: Int) {
        let sortedGoods = goods.sorted { (g1, g2) -> Bool in
            return g1.denstiy > g2.denstiy
        }
        /// 已经放入包里面的
        var baged = 0
        /// 存储结果
        var result = [Goods]()
        for good in sortedGoods {
            let willBaged = baged + good.weight
            if willBaged <= maxCapacity {
                // 放入包里
                result.append(good)
                baged = willBaged
            }
        }
        displayGoods(goods: result)
    }

    
    private class func displayGoods(goods:[Goods]) {
        print("------------------------------")
        var value = 0
        var weight = 0
        for good in goods {
            print(good)
            value += good.value
            weight += good.weight
        }
        print("总价值为: \(value), 总重量: \(weight)")
        print("------------------------------")
    }
}

extension Greedy {
    
    class func GreedyTest() {
//        haidao()
//        cionChange()
        bag()
    }
}




class Goods: CustomStringConvertible {
    /// 重量
    var weight = 0
    /// 价值
    var value = 0
    /// 价值密度
    var denstiy: Double {
        Double(value) / Double(weight)
    }
    init(w: Int, v: Int) {
        weight = w
        value = v
    }
    
    var description: String {
        return "重量: \(weight), 价值: \(value), 价值密度：\(denstiy)"
    }
}
