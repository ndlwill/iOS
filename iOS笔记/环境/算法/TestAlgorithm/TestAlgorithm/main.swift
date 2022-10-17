//
//  main.swift
//  TestAlgorithm
//
//  Created by youdone-ndl on 2022/7/11.
//

import Foundation

// MARK: - https://www.jianshu.com/p/ab29ae0ec873

// MARK: - 88合并两个有序数组
/**
 nums1 = [1, 2, 3, 0, 0, 0] m=3
 nums1 = [2, 5, 6] n=3
 out: [1, 2, 2, 3, 5, 6]
 
 搞两个指针，分别指向nums1和nums2两个数组最后一个元素，即3和6。再拿一个指针指向nums1最后一个位置。
 拿出nums1和nums2两个数组最后一个元素进行比较，将两者中较大值放在nums1最后一位指针处，并将该指针位置向前移动一位。并且较大值数组指针也向前移动一位。
 循环以上步骤，直到nums2数组下标小于0，则排序完成。
 若nums1数组下标小于0，则只需要将nums2数组剩余值依次赋给nums1即完成排序。
 */
func merge2OrderedArray(nums1: inout [Int], count1: Int, nums2: [Int], count2: Int) {
    var index1 = count1 - 1
    var index2 = count2 - 1
    var curIndex = count1 + count2 - 1 // 最后一位指针
    
    while index2 >= 0 {
        if index1 >= 0 && (nums1[index1] > nums2[index2]) {
            nums1[curIndex] = nums1[index1]
            curIndex -= 1
            index1 -= 1 // 较大值数组指针
        } else {
            nums1[curIndex] = nums2[index2]
            curIndex -= 1
            index2 -= 1 // 较大值数组指针
        }
    }
    print("\(#function) nums1 = \(nums1)")
}

var nums1 = [1, 2, 3, 0, 0, 0]
merge2OrderedArray(nums1: &nums1,
                   count1: 3,
                   nums2: [2, 5, 6],
                   count2: 3)

// MARK: - 75颜色分类
/**
 涉及扫描一遍即完成排序的，都会涉及双指针，三指针
 该题需要准备三个指针，紫色指针代表存放2，绿色指针代表存放0，红色指针代表遍历数组。
 红色指针遍历时，遇到1则跳过，红色指针++，遇到0则跟绿色指针交换值，绿色指针++，红色指针++。
 遇到2，跟紫色指针交换位置，紫色指针--，再次对红色指针的值进行判断。
 当红色指针的下标大于紫色指针，则退出排序。
 
 [2, 0, 2, 1, 1, 0]
 out: [0, 0, 1, 1, 2, 2]
 */
func colorSort(colorArray: inout [Int]) {
    var purpleIndex = colorArray.count - 1
    var greenIndex = 0
    var redIndex = 0
    
    while redIndex <= purpleIndex {
        let curValue = colorArray[redIndex]
        if curValue == 0 {
            if greenIndex != redIndex {
                colorArray.swapAt(greenIndex, redIndex)
            }
            greenIndex += 1
            redIndex += 1
        } else if curValue == 1 {
            redIndex += 1
        } else {
            colorArray.swapAt(purpleIndex, redIndex)
            purpleIndex -= 1
        }
    }
    print("\(#function) colorArray = \(colorArray)")
}
var colorArray = [2, 0, 2, 1, 1, 0]
colorSort(colorArray: &colorArray)

// MARK: - 16部分排序
/**
 思路是寻找逆序对
 分别从左往右和从右往左找到逆序对，这样即可确定范围。
 从左往右扫描，记录最大值，如果发现当前值小于最大值，则记录它的位置（有可能是逆序对最大范围），如果当前值大于最大值，则覆盖最大值。
 从右往左扫描，记录最小值，如果发现当前值大于最小值，则记录它的位置（有可能是逆序对最大范围），如果当前值小于最小值，则覆盖最小值。
 两次扫描记录的位置范围，就是需要排序的范围。
 
 [1, 2, 4, 7, 10, 11, 7, 12, 6, 7, 16, 18, 19]
 out: [3, 9]
 */
func partialSort(array: [Int]) -> [Int] {
    let count = array.count
    
    if count == 0 {
        return [-1, -1]
    }
    
    // 从左往右寻找逆序对 （正序：逐渐变大）
    var max = array[0]
    // 最右边的逆序对位置
    var rightIndex = -1
    
    for index in 1..<count {
        let val = array[index]
        if val >= max {
            max = val
        } else {
            rightIndex = index
        }
    }
    
    if rightIndex == -1 { return [-1, -1] }
    
    // 从右往左寻找逆序对 （正序：逐渐变小）
    var min = array[count - 1]
    // 最左边的逆序对位置
    var leftIndex = -1
    for index in (0..<count - 1).reversed() {
        let val = array[index]
        if val <= min {
            min = val
        } else {
            leftIndex = index
        }
    }
    
    let result = [leftIndex, rightIndex]
    print("\(#function) result = \(result)")
    return result
}
_ = partialSort(array: [1, 2, 4, 7, 10, 11, 7, 12, 6, 7, 16, 18, 19])


// MARK: - 冒泡排序（Bubble Sort）
/**
 从头开始比较每一对相邻元素，如果第一个比第二个大，就交换它们的位置。
 执行完一轮后，最末尾那个元素就是最大元素。
 忽略上一步中曾经找到的最大元素，重复执行步骤一，直到全部元素有序。
 */
func bubbleSort(array: inout [Int]) {
    let count = array.count
    for endIndex in (1..<count).reversed() {
        for startIndex in 1...endIndex {
            if array[startIndex] < array[startIndex - 1] {// 生序排序
                array.swapAt(startIndex, startIndex - 1)
            }
        }
    }
    print("\(#function) array = \(array)")
}
var array1 = [12, 76, 35, 34, 8]
bubbleSort(array: &array1)

/**
 如果序列已经完全有序，可以提前终止冒泡排序
 
 增加一个bool值，用于判断一次循环后是否有数据交换，如果没有，则退出排序。
 如果数据不是完全有序，此优化会因添加成员变量而导致计算时间更长。
 */
func optimizedBubbleSort1(array: inout [Int]) {
    let count = array.count
    for endIndex in (1..<count).reversed() {
        var sorted = false
        for startIndex in 1...endIndex {
            if array[startIndex] < array[startIndex - 1] {// 生序排序
                array.swapAt(startIndex, startIndex - 1)
                sorted = true
            }
        }
        if !sorted {
            break
        }
    }
    print("\(#function) array = \(array)")
}
var array2 = [12, 34, 35, 38, 85]
optimizedBubbleSort1(array: &array2)

/**
 如果序列尾部已经局部有序，可以记录最后一次交换的位置，减少比较次数。
 
 记录上一次循环最后一次交换的位置，将其作为下一次循环的截止位置。
 
 平均时间复杂度O(n^2)
 最好时间复杂度O(n)
 空间复杂度O(1)
 */
func optimizedBubbleSort2(array: inout [Int]) {
    let count = array.count
    var endIndex = count - 1
    while endIndex > 0 {
        // sortedIndex的初始值在数组完全有序的时候有用
        var sortedIndex = 1
        for startIndex in 1...endIndex {
            if array[startIndex] < array[startIndex - 1] {// 生序排序
                array.swapAt(startIndex, startIndex - 1)
                sortedIndex = startIndex
            }
        }
        
        endIndex = sortedIndex
        endIndex -= 1
    }
    print("\(#function) array = \(array)")
}
var array3 = [12, 76, 35, 34, 88, 98, 100]
optimizedBubbleSort2(array: &array3)

/**
 排序算法的稳定性（Stability）:
 如果相等的2个元素，在排序前后的相对位置保持不变，那么这是稳定的排序算法。
 排序前：5，1，3a，4，7，3b
 稳定的排序：1，3a，3b，4，5，7
 不稳定的排序：1，3b，3a，4，5，7
 冒泡排序是稳定排序算法
 
 原地算法（In-place Algorithm）:
 不依赖额外的资源或依赖少数的额外资源，仅依靠输出来覆盖输入。
 空间复杂度为O(1)的都可以认为是原地算法。
 非原地算法，称为Not-in-place或者Out-of-place。
 冒泡排序属于In-place。
 */

// MARK: - 选择排序（Selection Sort）
/**
 从序列中找出最大的那个元素，然后与最末尾的元素交换位置。执行完一轮后，最末尾的那个元素就是最大的元素。
 忽略上一步中曾经找到的最大元素，重复执行上一步。
 
 选择排序的交换次数要远远少于冒泡排序，平均性能优于冒泡排序。
 最好，最坏，平均时间复杂度：O(n^2)，空间复杂度：O(1)。
 属于不稳定排序。
 */
func selectionSort(array: inout [Int]) {
    let count = array.count
    for endIndex in (1..<count).reversed() {
        var maxIndex = 0
        for startIndex in 1...endIndex {
            if array[maxIndex] <= array[startIndex] {
                maxIndex = startIndex
            }
        }
        array.swapAt(maxIndex, endIndex)
    }
    print("\(#function) array = \(array)")
}
var array4 = [50, 21, 80, 43, 38, 14]
selectionSort(array: &array4)

// MARK: - 堆排序（Heap Sort）
/**
 堆排序可以认为是对选择排序的一种优化
 */
func heapSort(array: inout [Int]) {
    
}

// MARK: - 归并排序（Merge Sort）
/**
 不断地将当前序列平均分割成2个子序列，直到不能再分割。（序列中只剩1个元素）
 不断地将2个子序列合并成一个有序序列，直到最终只剩下1个有序序列。
 
 divide（划分）
 递归调用，将数据递归划分到最小，然后再合并
 */

// MARK: - 插入排序（Insertion Sort）
/**
 在执行过程中，插入排序会将序列分为两部分。头部是已经排好序的，尾部是待排序的。
 
 */
