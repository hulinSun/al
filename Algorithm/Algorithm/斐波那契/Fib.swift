//
//  Fib.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/10/25.
//

import Foundation


// 1 2 3 4 5 6 7 8
// 0 1 1 2 3 5 8 13

func fib(n: Int) -> Int {
    if n == 1 {
        return 0
    }
    if n == 2 {
        return 1
    }
    return fib(n: n - 1) + fib(n: n - 2);
}

func fib2(n: Int) -> Int {
    if n == 1 {
        return 0
    }
    if n == 2 {
        return 1
    }
    var first = 0;
    var second = 1;
    for _ in 0..<n - 2 {
        let sum = first + second
        first = second
        second = sum
    }
    return second
}

func testfib() {
    let n1 = fib(n: 10)
    let n2 = fib2(n: 10)
    print("n1 = \(n1), n2 = \(n2)")
}

/**
int fib(int n) {
    if (n == 1) return 0;
    if (n == 2) return 1;
    return fib(n - 1) + fib(n - 2);
}
int fib2 (int n) {
    // 0 1 不算，直接返回了。到第三个数的时候才开始相加
    if (n == 1) return 0;
    if (n == 2) return 1;
    int first = 0;
    int second = 1;
    for (int i = 0;  i < n - 2; i++) {
        cout << " i = " << i  << endl;
        int sum = first + second;
        first = second;
        second = sum;
    }
    return second;
}
*/


