//
//  ArrayList.swift
//  Algorithm
//
//  Created by 孙虎林 on 2020/10/25.
//

import Foundation

let DefaultCapacity: Int = 6

class ArrayList {
    
    // readonly (当前有多少个元素)
    private(set) var size : Int
    
    private var capacity: Int
    private var elements: [Int]
    
    init(initCapacity: Int) {
        capacity = initCapacity < DefaultCapacity ? DefaultCapacity : initCapacity
        elements =  [Int](repeating: 0, count: 10) // 这里swift内置数组没有设置容量的方法，无法设置容量。暂且用size控制。
        size = 0
    }
    
    public func add(item: Int) {
        insert(item: item, at: size)
    }
    
    //////////////////////////////////////////////////贼他妈重要//////////////////////////////////////////////////////////////////////
    public func remove(index: Int) {
        if rangeCheck(index: index) == false {
            return
        }
        // 删除 从左往右遍历
        var i = index
        while i < size {
            // 处理的是当前的这个，不会影响到下一趟的数据即可
            elements[i] = elements[i + 1] // i < i + 1 -> 箭头是< .那么向左移动 左边赋值永远是i
            i+=1
        }
        size-=1
        
        // 删除完毕之后再缩容
        trim()
    }
    
    //////////////////////////////////////////////////贼他妈重要//////////////////////////////////////////////////////////////////////
    /// 在index位置插入一个元素
    public func insert(item:Int ,at:Int) {
        if rangeCheckForAdd(index: at) == false {
            return
        }
        // 保证扩容条件
        ensureCapacity(size: size + 1)
        
        /**
        for (int i = size; i > index; i--) {
            elements[i] = elements[i - 1];
        }*/
        // 添加 从右往左遍历。
        var i = size
        while i > at {
            elements[i] = elements[i - 1]; // i > i - 1; -> 箭头是>，那么是往右移动 。 左边赋值永远是i
            i-=1
        }
        elements[at] = item
        size+=1
    }
    
    public func set(item: Int, at: Int) {
        if rangeCheck(index: at) {
            elements[at] = item
        }
    }
    public func getItem(at: Int) -> Int?{
        if rangeCheck(index: at) {
            return elements[at]
        }
        return nil
    }
    public func isEmpty() -> Bool{
        return size == 0
    }
    public func indexOf(item: Int) -> Int {
        for i in 0..<size {
            if elements[i] == item {
                return i
            }
        }
        return NSNotFound
    }
    public func contain(item: Int) -> Bool{
        return indexOf(item: item) > 0
    }
    public func clear() {
        size = 0
    }
    public func display() {
        var string = "size = \(size), 当前容量:\(capacity) [ "
        for i in 0..<size {
            if i == 0 {
                string.append("\(elements[i])")
            } else {
                string.append(", \(elements[i])")
            }
        }
        string.append(" ]")
        print(string)
    }
    //////////////////////////////////////////////////贼他妈重要//////////////////////////////////////////////////////////////////////
    private func ensureCapacity(size: Int) {
        if size <= capacity {
            // 不需要扩容
            return
        }
        // 扩容 1.5倍
        let newCapacity = capacity + (capacity >> 1)
        var newElements = Array<Int>(repeating: 0, count: newCapacity);
        print("数组扩容,原来容量：\(capacity),扩容后容量：\(newCapacity)")
        capacity = newCapacity;
        // 拷贝
        for i in 0..<size-1 {
            newElements[i] = elements[i]
        }
        elements = newElements
    }
    private func rangeCheck(index: Int) -> Bool {
        if index < 0 || index >= size {
            print("访问违法 index = \(index) , size= \(size)")
            return false
        } else {
            return true
        }
    }
    //////////////////////////////////////////////////贼他妈重要 数组缩容//////////////////////////////////////////////////////////////////////
    /// 数组扩容缩容时机一定要正确，可能会导致复杂度震荡 -> 扩容倍数 跟缩容倍数 相乘 不能等于1  
    /// 如果还剩下一半容量没有用。那么我们缩容下，避免内存空间的浪费
    private func trim() {
        let oldCapacity = capacity
        /// 用超过了一半了。不需要锁绒
        if size >= (oldCapacity >> 1) {
            return
        }
        // 再跟默认值比较
        if oldCapacity <= DefaultCapacity {
            return
        }
        let newCapacity = capacity >> 1  // 除以2
        // 缩容
        var newElements = Array<Int>(repeating: 0, count: newCapacity);
        for i in 0..<size  {
            newElements[i] = elements[i]
        }
        elements = newElements
        capacity = newCapacity
        print("数组缩容,原来容量：\(oldCapacity),缩容后容量：\(newCapacity)")
    }
    
    //////////////////////////////////////////////////贼他妈重要//////////////////////////////////////////////////////////////////////
    private func rangeCheckForAdd(index: Int) -> Bool {
        if index < 0 || index > size {
            print("访问违法 index = \(index) , size= \(size)")
            return false
        } else {
            return true
        }
    }
    
    
    public class func testArrayList(){
        let list: ArrayList = ArrayList(initCapacity: 4)
        let isempty = list.isEmpty()
        print(isempty ? "数组为空": "数组不为空")
        list.add(item: 3)
        list.add(item: 5)
        list.add(item: 7)
        list.add(item: 9)
        list.display()
        list.add(item: 10)
        list.add(item: 11)
        list.display()

        list.insert(item: 100, at: 2)
        list.display()
        
        list.remove(index: 2)
        list.display()
        
        list.add(item: 15)
        list.add(item: 12)
        list.add(item: 23)
        list.display()
        list.add(item: 33)
        list.add(item: 43)
        list.display()
        list.add(item: 53)
        list.add(item: 63)
        list.display()
        list.add(item: 73)
        list.add(item: 83)
        list.display()
        
        if let n = list.getItem(at: 4){
            print("第5个位置是\(n)")
        }
        
        for i in 0..<50 {
            list.add(item: i)
        }
        
        for _ in 0..<60 {
            list.remove(index: 0)
        }
    }
    
    public class func twoSum() {
        let array = [3,2,4]
        let target = 6
        
        // fix
        var dict = Dictionary<Int,Int>()
        
        var result = [Int]()
        for (idx, item) in array.enumerated() {
            let other = target - item
            if dict.keys.contains(other) {
                // 过滤掉相同的自己
                result.append(idx)
                result.append(dict[other]!)
            }
            dict[item] = idx
        }
        print("结果 \(result)");
    }
    
    
    /// 有序数组，删除重复元素，返回删除重复元素之后的长度
    public class func removeDump(nums: inout [Int]) -> Int {
        func getNotEqlIdx(nums: [Int], target: Int, from: Int) -> Int {
            for idx in from..<nums.count {
                if nums[idx] != target {
                    return idx
                }
            }
            return -1
        }
        
        if nums.count == 0 {
            return 0
        }
        var last = 1
        var i = 1
        while i < nums.count {
            if nums[i - 1] == nums[i] {
                // 相等. 找到右边第一个不相等的元素
                let notEqlIdx = getNotEqlIdx(nums: nums, target: nums[i], from: i)
                if notEqlIdx > 0 {
                    let v = nums[notEqlIdx]
                    nums[last] = v
                    last += 1
                    i = notEqlIdx + 1
                } else {
                    // 错误情况
                    print("错误情况 \(i)")
                }
            } else {
                nums[last] = nums[i]
                last += 1
                i += 1
            }
        }
        return last
    }
    public class func removeDumpTest() {
        var nums = [1,4,4,4,5,6,6,6,7,8]
        print(nums)
        let c = ArrayList.removeDump(nums: &nums)
        for idx in 0..<c {
            print(nums[idx])
        }
    }
    
    /// 删除数组中的元素，返回删除后的长度
    public class func removeEle(nums: inout [Int],target: Int) -> Int {
        if nums.count == 0 {
            return 0
        }
        var last = 0
        var i = 0
        while i < nums.count {
            if nums[i] != target {
                nums[last] = nums[i]
                last += 1
            }
            i += 1
        }
        return last
    }
    
    public class func removeEleTest() {
        var nums = [1,4,4,4,5,6,6,6,7,8]
        print(nums)
        let c = ArrayList.removeEle(nums: &nums, target: 4)
        for idx in 0..<c {
            print(nums[idx])
        }
    }
    
    /// 接雨水
    public class func mostWater(nums: [Int]) -> Int {
        if nums.count == 0 {
            return 0
        }
        var start = 0
        var end = nums.count - 1
        var maxWater = 0
        /// 对撞指针
        while start < end {
            let width = end - start
            var high = 0
            if nums[start] < nums[end] {
                high = nums[start]
                start += 1
            } else {
                high = nums[end]
                end -= 1
            }
            maxWater = max(width * high, maxWater)
        }
        
        /// 暴力解决法： 两层遍历
//        for start in 0..<nums.count {
//            for end in start + 1 ..< nums.count {
//                let width = end - start
//                var high = 0
//                if nums[start] < nums[end] {
//                    high = nums[start]
//                } else {
//                    high = nums[end]
//                }
//                maxWater = max(maxWater, width * high)
//            }
//        }
        return maxWater
    }
    
    public class func mostWaterTest() {
        print(mostWater(nums: [1,8,6,2,5,4,8,3,7]))
    }
}

/**
public class ArrayList<E> {
    /**
     * 元素的数量
     */
    private int size;
    /**
     * 所有的元素
     */
    private E[] elements;
    
    private static final int DEFAULT_CAPACITY = 10;
    private static final int ELEMENT_NOT_FOUND = -1;
    
    public ArrayList(int capaticy) {
        capaticy = (capaticy < DEFAULT_CAPACITY) ? DEFAULT_CAPACITY : capaticy;
        elements = (E[]) new Object[capaticy];
    }
    
    public ArrayList() {
        this(DEFAULT_CAPACITY);
    }
    
    /**
     * 清除所有元素
     */
    public void clear() {
        for (int i = 0; i < size; i++) {
            elements[i] = null;
        }
        size = 0;
    }

    /**
     * 元素的数量
     * @return
     */
    public int size() {
        return size;
    }

    /**
     * 是否为空
     * @return
     */
    public boolean isEmpty() {
         return size == 0;
    }

    /**
     * 是否包含某个元素
     * @param element
     * @return
     */
    public boolean contains(E element) {
        return indexOf(element) != ELEMENT_NOT_FOUND;
    }

    /**
     * 添加元素到尾部
     * @param element
     */
    public void add(E element) {
        add(size, element);
    }

    /**
     * 获取index位置的元素
     * @param index
     * @return
     */
    public E get(int index) {
        rangeCheck(index);
        return elements[index];
    }

    /**
     * 设置index位置的元素
     * @param index
     * @param element
     * @return 原来的元素ֵ
     */
    public E set(int index, E element) {
        rangeCheck(index);
        
        E old = elements[index];
        elements[index] = element;
        return old;
    }

    /**
     * 在index位置插入一个元素
     * @param index
     * @param element
     */
    public void add(int index, E element) {
        rangeCheckForAdd(index);
        
        ensureCapacity(size + 1);
        
        for (int i = size; i > index; i--) {
            elements[i] = elements[i - 1];
        }
        elements[index] = element;
        size++;
    }

    /**
     * 删除index位置的元素
     * @param index
     * @return
     */
    public E remove(int index) {
        rangeCheck(index);
        
        E old = elements[index];
        for (int i = index + 1; i < size; i++) {
            elements[i - 1] = elements[i];
        }
        elements[--size] = null;
        return old;
    }

    /**
     * 查看元素的索引
     * @param element
     * @return
     */
    public int indexOf(E element) {
        if (element == null) {  // 1
            for (int i = 0; i < size; i++) {
                if (elements[i] == null) return i;
            }
        } else {
            for (int i = 0; i < size; i++) {
                if (element.equals(elements[i])) return i; // n
            }
        }
        return ELEMENT_NOT_FOUND;
    }
    
//    public int indexOf2(E element) {
//        for (int i = 0; i < size; i++) {
//            if (valEquals(element, elements[i])) return i; // 2n
//        }
//        return ELEMENT_NOT_FOUND;
//    }
//
//    private boolean valEquals(Object v1, Object v2) {
//        return v1 == null ? v2 == null : v1.equals(v2);
//    }
    
    /**
     * 保证要有capacity的容量
     * @param capacity
     */
    private void ensureCapacity(int capacity) {
        int oldCapacity = elements.length;
        if (oldCapacity >= capacity) return;
        
        // 新容量为旧容量的1.5倍
        int newCapacity = oldCapacity + (oldCapacity >> 1);
        E[] newElements = (E[]) new Object[newCapacity];
        for (int i = 0; i < size; i++) {
            newElements[i] = elements[i];
        }
        elements = newElements;
        
        System.out.println(oldCapacity + "扩容为" + newCapacity);
    }
    
    private void outOfBounds(int index) {
        throw new IndexOutOfBoundsException("Index:" + index + ", Size:" + size);
    }
    
    private void rangeCheck(int index) {
        if (index < 0 || index >= size) {
            outOfBounds(index);
        }
    }
    
    private void rangeCheckForAdd(int index) {
        if (index < 0 || index > size) {
            outOfBounds(index);
        }
    }
    
    @Override
    public String toString() {
        // size=3, [99, 88, 77]
        StringBuilder string = new StringBuilder();
        string.append("size=").append(size).append(", [");
        for (int i = 0; i < size; i++) {
            if (i != 0) {
                string.append(", ");
            }
            
            string.append(elements[i]);
            
//            if (i != size - 1) {
//                string.append(", ");
//            }
        }
        string.append("]");
        return string.toString();
    }
}
*/
