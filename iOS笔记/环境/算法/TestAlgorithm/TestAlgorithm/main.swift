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

func bubbleSort(_ arr: [Int]) {
    
}

bubbleSort([12, 76, 35, 34, 8])

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
