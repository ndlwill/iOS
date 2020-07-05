//
//  ViewController.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/7/17.
//  Copyright © 2019 dzcx. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import RxDataSources
import Moya
import Alamofire

// MARK: ==解决类实例之间的强引用循环==
/**
 当另一个实例的生命周期较短时，即当另一个实例可以首先被释放时，使用weak引用。
 相反，当另一个实例有相同的生命周期或更长的生命周期时，使用unowned引用。
 
 弱引用(weak):
 因为弱引用不会对其引用的实例保持强引用，所以该实例有可能在弱引用仍然存在时就被释放了。当它所引用的实例被释放时，ARC会自动将弱引用设置为nil。当ARC将弱引用设置为nil时，属性观察器不会被调用。
 因为弱引用需要允许它们的值在运行时被设置为nil，所以它们总是声明为可选类型的变量，而不是常量。
 
 unowned引用:
 unowned引用也不会对它所引用的实例保持强引用
 
 只有当您确定这个引用总是引用着一个还未被释放的实例时，才使用unowned引用。
 如果试图在实例被释放后访问unowned引用的值，将得到一个运行时错误
 
 因为unowned引用是非可选的，所以每次使用它时，不需要解包，可以直接访问。
 当它所引用的实例被释放时，ARC不能将它设置为nil，因为非可选类型的变量不能设置为nil
 
 客户可能拥有信用卡，也可能没有，但是信用卡总是与客户相关联的。
 一个CreditCard实例的生命周期永远不会超过它所引用的客户
 class Customer {
     let name: String
   //每个客户可以持有或不持有信用卡，所以将属性card定义可选类型的变量
     var card: CreditCard?
     init(name: String) {
         self.name = name
     }
     deinit { print("\(name) is being deinitialized") }
 }

 class CreditCard {
     let number: UInt64
   /*
      1.每张信用卡总有个客户与之对应，与每张信用卡相关联的客户不能为空，而且不能更换，因此将customer属性定义为非可选的常量；
      2.由于信用卡始终拥有客户，为了避免强引用循环问题，所以将客户属性定义为unowned
      */
     unowned let customer: Customer
  // 只能通过向初始化方法传递number和customer来创建CreditCard实例，确保CreditCard实例始终具有与其关联
     init(number: UInt64, customer: Customer) {
         self.number = number
         self.customer = customer
     }
     deinit { print("Card #\(number) is being deinitialized") }
 }
 
 unowned引用和隐式解包的可选属性:
 每个国家都必须有一个首都，每个城市都必须属于一个国家
 class Country {
     let name: String
     var capitalCity: City!// 这意味着capitalCity属性的默认值为nil，与其他任何可选值一样，但可以在不需要解包的情况下访问其值。（隐式解包选项）
     init(name: String, capitalName: String) {
         self.name = name
 // 只有当一个新的Country实例完全初始化之后，Country的构造器才能将self传递给City的构造器
      // 在Country的初始化方法中来创建City实例，并将此实例存储在其capitalCity属性中
      //在Country的初始化方法中调用City的初始化方法。 但是，只有完全初始化一个新的Country实例后，才能将self传递到City初始化器中
         self.capitalCity = City(name: capitalName, country: self)// （两阶段初始化）
     }
 }
 // 因为capitalCity具有默认值nil，所以只要Country实例在其构造器中设置name属性，新的Country实例就认为被完全初始化。这意味着Country构造器可以设置在name属性后就可以开始引用和传递隐式self属性


 class City {
     let name: String
     unowned let country: Country
     //City的初始化器使用一个Country实例，并将此实例存储在其country属性中
     init(name: String, country: Country) {
         self.name = name
         self.country = country
     }
 }
 
 解决闭包的强引用循环:
 当闭包和它捕获的实例总是相互引用，并且总是在同一时间被释放时，在闭包中定义一个unowned引用。
 
 当捕获的引用在将来的某个时刻可能变成nil时，将捕获定义为weak引用。weak引用总是可选类型，当它们引用的实例被释放时，它会自动变成nil。
 
 如果捕获的引用永远不会变成nil，那么它应该总是被捕获为一个unowned引用，而不是一个weak引用。
 
 class HTMLElement {

     let name: String
     let text: String?

     lazy var asHTML: () -> String = {
         [unowned self] in
         if let text = self.text {
             return "<\(self.name)>\(text)</\(self.name)>"
         } else {
             return "<\(self.name) />"
         }
     }

     init(name: String, text: String? = nil) {
         self.name = name
         self.text = text
     }

     deinit {
         print("\(name) is being deinitialized")
     }

 }
 
 var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
 print(paragraph!.asHTML())
 如果将paragraph变量中的强引用设置为nil，则会释放HTMLElement实例
 paragraph = nil
 
 */

// MARK: Void
/*
 它只不过是一个空元组
 typealias Void = ()
 
 非正式类型不能被扩展。Void 是一个空元组，而由于元组是非正式类型，所以你不能给 Void 添加方法、属性或者遵从协议
 */

// MARK: statusBar
// 默认情况下，顶部状态栏（statusBar）为 default 样式（文字为黑色），我们可以将其改为 light 样式（文字为白色）


// https://www.hangge.com/blog/cache/category_72_11.html

// MARK: RxSwift
// https://www.jianshu.com/u/cea6393d7686

// MARK: RxCocoa中对UIKit的Delegate的处理
/**
 scrollView.rx.didScroll:
 
 NSObject被声明了实现ReactiveCompatible，因此UIScrollView也实现了该协议
 
 scrollView的rx属性就是一个UISCrollView泛型的Reactive结构体，其base属性就是这个UIScrollView本身的实例
 
 在UIScrollView+Rx.swift文件里找到，是通过extension的where语法对UIScrollView泛型的Reactive添加的一个计算型属性
 
 public var didScroll: ControlEvent<Void> {
     let source = RxScrollViewDelegateProxy.proxy(for: base).contentOffsetPublishSubject
     return ControlEvent(events: source)
 }
 
 source是通过一个对应UISrollView实例获得的RxScrollViewDelegateProxy的一个UIScrollView的contentOffset事件广播，函数最后再把这个广播封装成一个ControlEvent类型实例
 
 关键就在于RxScrollViewDelegateProxy
 
 open class RxScrollViewDelegateProxy
     : DelegateProxy<UIScrollView, UIScrollViewDelegate>
     , DelegateProxyType
 , UIScrollViewDelegate
 RxScrollViewDelegateProxy继承了DelegateProxy，并实现了两个协议:DelegateProxyType,UIScrollViewDelegate
 
 fileprivate var _contentOffsetPublishSubject: PublishSubject<()>?
 ...
 /// Optimized version used for observing content offset changes.
 internal var contentOffsetPublishSubject: PublishSubject<()> {
     if let subject = _contentOffsetPublishSubject {
         return subject
     }

     let subject = PublishSubject<()>()
     _contentOffsetPublishSubject = subject

     return subject
 }
 
 public func scrollViewDidScroll(_ scrollView: UIScrollView) {
     if let subject = _contentOffsetBehaviorSubject {
         subject.on(.next(scrollView.contentOffset))
     }
     if let subject = _contentOffsetPublishSubject {
         subject.on(.next(()))
     }
     self._forwardToDelegate?.scrollViewDidScroll?(scrollView)
 }
 发送contentOffset的数值变化广播
 发送contentOffset变化的事件广播
 调用了_forwardToDelegate属性的另一个scrollViewDidScroll函数
 
 而_forwardToDelegate应该是开发者在外部设置的delegate
 即使开发者已经为一个UIScrollView设置了delegate（或者没有设置），也不会影响通过RxCocoa框架去订阅这个UIScrollView的事件。 而且可以有多个订阅者通过RxCocoa去订阅UIScrollView的回调事件，因为这里的Observable是广播类型
 
 代码RxScrollViewDelegateProxy.proxy(for: base)当中，proxy(for:)函数把一个RxScrollViewDelegateProxy绑定到一个UIScrollView上
 proxy(for:)函数被定义在DelegateProxyType协议里，通过extension实现
 
 RxCocoa可以让开发者跳过实现Delegate函数直接获取UIKit组件的回调，其实是通过runtime把一个已经实现了Delegate的Proxy绑定到了这个组件上
 
 如果在开发者设置订阅UIScrollView之前，UIScrollView已经有一个delegate，在这里就会把这个delegate托管给proxy，让proxy在收到UIScrollView回调的时候转发给delegate，而实际上UIScrollView此时的delegate指向的是proxy。通过proxy的forwardToDelegate可以找回这个在外部设置的delegate
 */

struct Person_NDL {
    var name: String
}

class TestClo {
    var name: String = ""
}

class Person_CC {
    var desc: String = ""
    var person: Person_NDL
    
    init(person: Person_NDL) {
        self.person = person
    }
}

struct Sample {
    var number: Int
    var flag: Bool
}

public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
}

class ViewController: UIViewController {
    
    var str: String = ""
    var closures: [() -> Void] = []
    
    let range = 0.0..<1.0 // 半开区间
    let closedRange: ClosedRange = 0.0...1.0 // 闭区间
    let countableRange: CountableRange = 0..<1 // Countable 半开区间
    let countableClosedRange: CountableClosedRange = 0...1 // Countable 闭区间
    
    var test111VC: Test111ViewController?
    
    let disposeBag = DisposeBag()
    
    enum MyError: Error {
        case ErrorA
        case ErrorB
    }
    
    func testClosure(block: @escaping () -> Void) {
        self.closures.append(block)
    }
    
    func test111() {
        testClosure {
            print(self.str)
        }
    }
    
    func request1() -> Observable<String> {
        print("===start request1===")
        
        return Observable<String>.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.delay(3.0) {
                print("on event request1")
                observer.onNext("==request1==")
//                observer.onCompleted()
//                observer.onError(MyError.ErrorA)
            }
            
            return Disposables.create()
        }
    }
    
    // request11 并行 request1
    func request11() -> Observable<String> {
        print("===start request11===")
        
        return Observable<String>.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.delay(5.0) {
                print("on event request11")
                observer.onNext("==request11==")
            }
            
            return Disposables.create()
        }
    }
    
    // request2 依赖 request1
    func request2(string: String) -> Observable<String> {
        print("===start request2 with: \(string)===")
        
        return Observable<String>.create { [weak self] (observer) -> Disposable in
            guard let self = self else { return Disposables.create() }
            self.delay(3.0) {
                print("onNext request2")
                observer.onNext("\(string)|==request2==")
            }
            
            return Disposables.create()
        }
    }
    
    // request2 依赖 request1
    // 聚合2个异步操作的Observable
    func serialRequest() -> Observable<String> {
        return self.request1().flatMap {
            self.request2(string: $0)
        }
    }
    
    // MARK: 读取变量指向地址
    func address(of object: UnsafeRawPointer) -> String {
        let addr = Int(bitPattern: object)
        return String(format: "%p", addr)
    }
    
    lazy var testView: UIView = {
        print("===lazy testView===")
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    // MARK: ===leetcode算法===
    // MARK: 两数之和
    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        var dic = [Int:Int]()
        for (index, value) in nums.enumerated() {
            let diffValue = target - value
            if let valueIndex = dic[diffValue] {
                return [valueIndex, index]
            }
            
            dic[value] = index
        }
        
        return []
    }
    
    // MARK: 两数相加
    func addTwoNumbers(_ l1: ListNode?, _ l2: ListNode?) -> ListNode? {
        let dummyHead: ListNode? = ListNode(0)
        var value = 0
        var curNode = dummyHead, node1 = l1, node2 = l2
        while (node1 != nil || node2 != nil) {
            let value1 = node1?.val ?? 0
            let value2 = node2?.val ?? 0
            let sum = value + value1 + value2
            value = sum / 10
            curNode?.next = ListNode(sum % 10)
            curNode = curNode?.next
            if node1 != nil {
                node1 = node1?.next
            }
            
            if node2 != nil {
                node2 = node2?.next
            }
        }
        if value > 0 {
            curNode?.next = ListNode(value)
        }
        
        return dummyHead?.next
    }
    // MARK: 只出现一次的数字 III    [1,2,1,3,2,5]
    func singleNumber(_ nums: [Int]) -> [Int] {
        var xor = 0
        var result = Array(repeating: 0, count: 2)
        for num in nums {
            xor ^= num
        }
        // 取异或值最后一个二进制位为1的数字作为mask，如果是1则表示两个数字在这一位上不同
        let mask = xor & (-xor)
        
        // 2.lowbit(s) = s & -s
        // 3.用lowbit(s)将数组分成两组. 一组中,元素A[i] & lowbit(s) == lowbit(s), 即包含lowbit(s)的bit 1。两个不同数也一定分在不同组. 因为异或值s中的bit1就是因为两个数字的不同
        // 4.同一组的元素再异或求出不同数字. 出现两次的数字, 肯定出现同一组, 异或后消除掉.
        for (index, value) in nums.enumerated() {
            print("value & mask = \(value & mask)")// 0,2,0,2,2,0
            if (value & mask) == mask {
                result[0] ^= value
            } else {
                result[1] ^= value
            }
        }
        
        return result
    }
    // MARK: 合并两个有序数组(双指针法,从后往前)
    /**
     初始化 nums1 和 nums2 的元素数量分别为 m 和 n。
     你可以假设 nums1 有足够的空间（空间大小大于或等于 m + n）来保存 nums2 中的元素。
     示例:

     输入:
     nums1 = [1,2,3,0,0,0], m = 3
     nums2 = [2,5,6],       n = 3

     输出: [1,2,2,3,5,6]
     
     时间复杂度 : O(n + m)
     空间复杂度 : O(1)
     */
    func merge(_ nums1: inout [Int], _ m: Int, _ nums2: [Int], _ n: Int) {
        var p1 = m - 1
        var p2 = n - 1
        var p = m + n - 1
        
        while (p1 >= 0 && p2 >= 0) {
            if nums1[p1] < nums2[p2] {
                nums1[p] = nums2[p2]
                p2 -= 1
            } else {
                nums1[p] = nums1[p1]
                p1 -= 1
            }
            
            p -= 1
        }
        // 当p1 < 0，需要下面的操作
        if p1 < 0 {
            nums1.replaceSubrange(0...p2, with: nums2[0...p2])
//            nums1.replaceSubrange(Range(0...p2), with: nums2[0...p2])
        }
    }
    
    // MARK: 数组拆分 I
    /**
     给定长度为 2n 的数组, 你的任务是将这些数分成 n 对, 例如 (a1, b1), (a2, b2), ..., (an, bn) ，使得从1 到 n 的 min(ai, bi) 总和最大

     输入: [1,4,3,2]

     输出: 4
     解释: n 等于 2, 最大总和为 4 = min(1, 2) + min(3, 4)
     
     我们可以对给定数组的元素进行排序，并直接按排序顺序形成元素的配对。这将导致元素的配对，它们之间的差异最小，从而导致所需总和的最大化
     */
    func arrayPairSum(_ nums: [Int]) -> Int {
        let sortedArray = nums.sorted()
        
        var sum = 0
        for index in 0..<sortedArray.count {
            if index % 2 == 0 {
                sum += sortedArray[index]
            }
        }
        
        return sum
    }
    
    // MARK: 删除排序数组中的重复项
    /**
     给定 nums = [0,0,1,1,1,2,2,3,3,4],

     函数应该返回新的长度 5, 并且原数组 nums 的前五个元素被修改为 0, 1, 2, 3, 4
     
     双指针法
     时间复杂度：O(n)
     空间复杂度：O(1)
     */
    func removeDuplicates(_ nums: inout [Int]) -> Int {
        if nums.count == 0 {
            return 0
        }
        
        var p1 = 0
        for index in 1..<nums.count {
            if nums[index] != nums[p1] {
                p1 += 1
                nums[p1] = nums[index]
            }
        }
        return p1 + 1
    }
    
    // MARK: 移除元素
    /**
     给定 nums = [0,1,2,2,3,0,4,2], val = 2,

     函数应该返回新的长度 5, 并且 nums 中的前五个元素为 0, 1, 3, 0, 4
     */
    func removeElement(_ nums: inout [Int], _ val: Int) -> Int {
        nums = nums.filter {
            $0 != val
        }
        return nums.count
    }
    
    // MARK: 时间复杂度： O(log2^n) 就要想到二分法
    
    // MARK: 斐波那契数
    /**
     斐波那契数，通常用 F(n) 表示，形成的序列称为斐波那契数列。该数列由 0 和 1 开始，后面的每一项数字都是前面两项数字的和。也就是：

     F(0) = 0,   F(1) = 1
     F(N) = F(N - 1) + F(N - 2), 其中 N > 1.
     给定 N，计算 F(N)
     */
    func fib(_ N: Int) -> Int {
        if N == 0 {
            return 0
        }

        if N == 1 {
            return 1
        }
        return fib(N - 1) + fib(N - 2)
    }
    
    // MARK: ==Test Nav==
    @IBAction func testNav(_ sender: Any) {
//        let vc = BaseNavigationController(rootViewController: TestNav1ViewController())
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
        
        self.present(TestDismiss1ViewController(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.cyan
        
        // MARK: 值类型相关
        var p1 = Person_NDL(name: "ndl")
        var p2 = p1
        // 0x7ffeeddef130
        // 0x7ffeeddef120
        print(address(of: &p1))
        print(address(of: &p2))
        print(Unmanaged<AnyObject>.passRetained(p1 as AnyObject).toOpaque())
        // 如果值类型实例是一个类的一部分，值会和类一起存在堆中
        var pp = Person_CC(person: p1)
        print(Unmanaged<AnyObject>.passRetained(pp).toOpaque())// 0x00006000002fc5a0
        print(pp) // <Person_CC: 0x00006000002fc5a0>
        print(Unmanaged<AnyObject>.passRetained(pp.person as AnyObject).toOpaque())// 0x0000600002e28900
        print(address(of: &pp))// 0x7ffeea469118
        print(address(of: &pp.person))// 0x7ffeea469108
        
        // MARK: test closure
//        var clo = TestClo()
//        clo.name = "123"
//        let blk = { [clo] in
//            print(clo.name)
//        }
//        clo.name = "234"
//        let newClo = TestClo()
//        newClo.name = "ndl"
//        clo = newClo
//        blk()
        
//        var clo = 1
//        let blk = { [clo] in
//            print(clo)
//        }
//        clo = 2
//        blk()
        
        var str: String = "ndl123will"
        var nss = str as NSString
        print(nss.character(at: 1))// 'd' = 100
        
        singleNumber([1,2,1,3,2,5])
        
        // MARK: 负数的二进制
        /**
         等于正数的二进制的反码加1
         
         5的二进制
         00000000 00000000 00000000 00000101
         --->反码
         11111111 11111111 11111111 1111010
         加1
         11111111 11111111 11111111 1111011
         */
        
        // 3: 011
        // 5: 101
        // 3 xor 5 = 110
        var nums = [1, 3, 1, 2, 5, 2]
        var xor = 0
        for num in nums {
            xor ^= num
        }
        print(xor)// 6 -> 二进制110
        // 取异或值最后一个二进制位为1的数字作为mask，如果是1则表示两个数字在这一位上不同
        print(xor & (-xor))// mask = 2 = (0110 & (1001 + 1 = 1010) = 0010)
        
        /**
         eg: 4, 8
         4 = 0100
         8 = 1000
         value = 4 xor 8 = 1100
         value & (-value) = 1100 & (0011 + 1 = 0100) = 0100 ##最后一个二进制位为1的数字作为mask
         */
        
        
        
        // !
//        self.testView?.frame = CGRect(x: 0, y: 200, width: 50, height: 50)
//        self.view.addSubview(self.testView)
        // 推荐
        self.testView.frame = CGRect(x: 0, y: 200, width: 50, height: 50)
        self.view.addSubview(self.testView)
        
        // MARK: ==指针UnsafePointer==
        /**
         官方将直接操作内存称为 “unsafe 特性”
         在操作指针之前，需要理解几个概念：size、alignment、stride
         MemoryLayout，可以检测某个类型的实际大小（size），内存对齐大小（alignment），以及实际占用的内存大小（步长：stride），其单位均为字节
         
         一般在移动指针的时候，对于特定类型，指针一次移动一个stride（步长），移动的范围，要在分配的内存范围内
         
         Pointer Name    Unsafe？    Write Access？    Collection    Strideable？    Typed？
         UnsafeMutablePointer<T>    yes    yes    no    yes    yes
         UnsafePointer<T>    yes    no    no    yes    yes
         UnsafeMutableBufferPointer<T>    yes    yes    yes    no    yes
         UnsafeBufferPointer<T>    yes    no    yes    no    yes
         UnsafeRawPointer    yes    no    no    yes    no
         UnsafeMutableRawPointer    yes    yes    no    yes    no
         UnsafeMutableRawBufferPointer    yes    yes    yes    no    no
         UnsafeRawBufferPointer    yes    no    yes    no    no

         unsafe：不安全的
         Write Access：可写入
         Collection：像一个容器，可添加数据
         Strideable：指针可使用 advanced 函数移动
         Typed：是否需要指定类型（范型）
         */
        print(MemoryLayout<Int>.size)// 8
        // 1.UnsafeMutableRawPointer
        let int_count = 2 // 整数的个数
        let stride = MemoryLayout<Int>.stride // 整数的步长
        let align = MemoryLayout<Int>.alignment // 整数的内存对齐大小
        let byteCount = stride * int_count // 实际需要的内存大小
        // 原生(Raw)指针
//        do {
//            // 该指针可以用来读取和存储（改变）原生的字节
//            let pointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: align)// 返回UnsafeMutableRawPointer
//
//            defer {
//                pointer.deallocate()
//            }
//
//            // 使用 storeBytes 和 load 方法存储和读取字节
//            // 要存储的值, 值的类型
//            pointer.storeBytes(of: 42, as: Int.self)
//            // 使用原生指针，存储下一个值的时候需要移动一个步长（stride），也可以直接使用 + 运算符
////            pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self)
//            (pointer + stride).storeBytes(of: 6, as: Int.self)
//            // 读取第一个值
//            let val1 = pointer.load(as: Int.self)
//            // 读取第二个值
//            let val2 = pointer.advanced(by: stride).load(as: Int.self)
//            print("val1 = \(val1) val2 = \(val2)")
//
//            // UnsafeRawBufferPointer 类型以字节流的形式来读取内存
//            // 缓冲类型指针使用了原生指针进行初始化
//            let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount)
//            for (index, value) in bufferPointer.enumerated() {
//                print("index = \(index) value = \(value)")
//            }
//        }
        // 类型指针
//        do {
//            // 返回UnsafeMutablePointer<Pointee>
//            // 因为通过给范型参数赋值，已经知道了要存储的数据类型，其alignment和stride就确定了，这时只需要再知道存储几个数据即可
//            let pointer = UnsafeMutablePointer<Int>.allocate(capacity: int_count)
//            // 这里还多了个初始化的过程，类型指针单单分配内存，还不能使用，还需要初始化
//            pointer.initialize(repeating: 0, count: int_count)
//
//            defer {
//                pointer.deinitialize(count: int_count)
//                pointer.deallocate()
//            }
//
//            // 类型指针的存储/读取值，不需要再使用storeBytes/load，Swift提供了一个以类型安全的方式读取和存储值--pointee
//            pointer.pointee = 42
////            pointer.advanced(by: 1).pointee = 6// 这里是按类型值的个数进行移动
//            (pointer + 1).pointee = 6
//            let val1 = pointer.pointee
//            let val2 = pointer.advanced(by: 1).pointee
//            print("val1 = \(val1) val2 = \(val2)")
//
//            let bufferPointer = UnsafeBufferPointer(start: pointer, count: int_count)
//            for (index, value) in bufferPointer.enumerated() {
//                print("index = \(index) value = \(value)")
//            }
//        }
        // 原生指针转换为类型指针
//        do {
//            // 创建原生指针
//            let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: align)
//            defer {
//                print("defer1")
//                rawPointer.deallocate()
//            }
//            // 原生指针转换为类型指针，是通过调用内存绑定到特定的类型来完成的
//            let typePointer = rawPointer.bindMemory(to: Int.self, capacity: int_count)
//            typePointer.initialize(repeating: 0, count: int_count)
//            defer {
//                print("defer2")
//                typePointer.deinitialize(count: int_count)
//            }
//            typePointer.pointee = 42
//            typePointer.advanced(by: 1).pointee = 9
//            let val1 = typePointer.pointee
//            let val2 = typePointer.advanced(by: 1).pointee
//
//            let bufferPointer = UnsafeBufferPointer(start: typePointer, count: int_count)
//            for (index, value) in bufferPointer.enumerated() {
//                print("index =  \(index) value = \(value)")
//            }
//            // defer2->defer1
//        }

        
        // MARK: copy on write
        // Swift针对标准库中的集合类型（Array、Dictionary、Set）进行优化。当变量指向的内存空间并没有发生改变，进行拷贝时，只会进行浅拷贝。只有当值发生改变时才会进行深拷贝
        // Array、Dictinary、Set每次进行修改前，都会通过类似isUniquelyReferencedNonObjC进行判断，判断是否是唯一的引用(即引用计数器为1)。若不为1，则创建新的类型值并返回。若是唯一的则直接赋值
        var array1: [Int] = [0, 1, 2, 3]
        var array2 = array1
        print(address(of: &array1))
        print(address(of: &array2))
        // array1 array2地址相同
        
//        array2.append(4)
        array2[0] = 100
        // array1 array2地址不同
        print(address(of: &array1))
        print(address(of: &array2))

        // UI for test rx
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.red
        self.view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
            make.size.equalTo(CGSize(width: 60, height: 40))
        }
        
        let eventView = UIView()
        eventView.isUserInteractionEnabled = false// 触摸相交部分，button能相应事件
        eventView.backgroundColor = .yellow
        self.view.addSubview(eventView)
        eventView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view).offset(-40.0)
            make.centerY.equalTo(self.view)
            make.size.equalTo(CGSize(width: 80, height: 80))
        }
        
        
        // MARK: 笔记
        /**
         希望Service是MVVM中的ViewModel的辅助, ViewModel调用Service提供的函数, 而Service应该帮ViewModel处理好与UI无关的业务逻辑. 所以Service的函数应该返回Observable类型
         */
        
        // MARK: ###错误相关###
        /**
         observer.onCompleted():
         不会走这边的onCompleted回调
         
         observer.onNext("==request1==")
         observer.onCompleted():
         走onNext回调，不走onCompleted回调
         
         observer.onError:
         没写catchErrorJustReturn，走onError回调
         写了catchErrorJustReturn，走onNext和onCompleted回调
         */
//        button.rx.tap.flatMapLatest{
//            self.request1()
//        }
//        .catchErrorJustReturn("NDL")
//        .subscribe(onNext: { (str) in
//            print("subscribe = \(str)")
//        }, onError: { (error) in
//            print("\(error)")
//        }, onCompleted: {
//            print("on completed")
//        }).disposed(by: disposeBag)
        
        // MARK: ###test serial request###
        // flatMapLatest: 没点击不执行闭包的方法
        /*
         observer.onNext:
         或者
         observer.onNext
         observer.onCompleted():
         ===start request1=== 过3秒到下一步
         onNext request1
         ===start request2 with: ==request1===== 过3秒到下一步
         onNext request2
         subscribe = ==request1==|==request2==
         
         observer.onCompleted():
         点击报下面的log，再次点击也报下面的log
         ===start request1===
         on event request1
         
         observer.onError没有catchErrorJustReturn:
         点击一次报下面的log，以后点击它再也不会发出 event 事件了
         ===start request1===
         on event request1
         ErrorA
         
         observer.onError有catchErrorJustReturn:
         点击一次报下面的log，以后点击它再也不会发出 event 事件了
         ===start request1===
         on event request1
         subscribe = NDL
         on completed
         
         observer.onError有catchError:
         点击一次报下面的log，以后点击它再也不会发出 event 事件了
         ===start request1===
         on event request1
         subscribe = ##ErrorA##
         on completed
         */
//        button.rx.tap.flatMapLatest{
//            self.request1()
//        }.flatMapLatest{ str in
//            self.request2(string: str)
//        }
////        .catchErrorJustReturn("NDL")
//            .catchError({ (error) -> Observable<String> in
//                return Observable.just("##\(error)##")
//            })
//        .subscribe(onNext: { (str) in
//            print("subscribe = \(str)")
//        }, onError: { (error) in
//            print("\(error)")
//        }, onCompleted: {
//            print("on completed")
//        }).disposed(by: disposeBag)
        
        // MARK: ###serial request 最终方案###
        /**
         observer.onNext:
         ===start request1===
         on event request1
         ===start request2 with: ==request1=====
         onNext request2
         subscribe.onNext = ==request1==|==request2==
         
         observer.onError 没有catchError:点击按钮不能触发事件
         ===start request1===
         on event request1
         subscribe.onError = ErrorA
         
         选用catchError. 而这样的话, subscribe函数的onError就永远都不会执行了, 等于是把Error的处理提前到了catchError
         observer.onError & catchError:点击按钮还能触发事件
         ===start request1===
         on event request1
         subscribe.onNext = ##ErrorA##
         */
        button.rx.tap
            .flatMap {
                self.serialRequest()
                    .catchError { (error) -> Observable<String> in
                        // 处理error，配合enum以及泛型更好地处理Error
                        return Observable.just("##\(error)##")
                    }
            }.subscribe(onNext: { (str) in
                print("subscribe.onNext = \(str)")
            }, onError: { (error) in
                print("subscribe.onError = \(error)")
            }, onCompleted: {
                print("subscribe.on completed")
            }).disposed(by: disposeBag)
        
        // MARK: ###参考###
        /**
         适用于通用的场景
         enum Result<T> {
             case value(T)
             case error(Error)
         }
         
         // 改进后的fetch函数把[Device]和Error转换成Result
         func rx_fetchTableViewData() -> Observable<Result> {
             return self.rx_updateLocation()
                        .flatMap({self.rx_fetchDevices(near: $0)})
                        .map({Result.value($0)})
                        .catchError({Observable.of(Result.error($0))})
         }
         // 统一处理Result
         func handleResult(_ result: Result) {
             switch result {
                 case .value(let value):
                     self.update(with: value)
                 case .error(let error):
                     self.handleError(error)
             }
         }
         
         self.tableView.rx_pullToRefresh
         .flatMap({[unowned self] in self.rx_fetchTableViewData()})
         .subscribe(onNext: {[weak self] in self?.handleResult($0)})
         .disposed(by: self.disposeBag)
         */
        
        // MARK: Delegate回调
        /**
         class ViewController: UIViewController {
             func performSelect() {
                 let modalViewController = ModalViewController()
                 
                 self.present(viewController: modalViewController, animated: true, completion: nil)
                 
                 modalViewController.rx_didSelect
                     .subscribe(onNext: { [weak self] index in
                         // 处理回调
                         ...
                     })
             }
         }
         
         class ModalViewController: UIViewController {
             // PublishSubject不适合对外公开, 避免外部调用入口函数.
             var rx_didSelect: Obsevable<Int> {
                 return self.rx_internal_didSelect.asObservable()
             }
             private let rx_internal_didSelect: PublishSubject<Int> = PublishSubject()
             ...
             private func internalSelect(at index: Int) {
                 self.rx_internal_didSelect.onNext(index)
             }
         }
         */
        
    
        
        // MARK: ###test concurrent request###
        // 没有subscribe(),这种样式他会执行方法,不执行方法返回中闭包的request
        /**
         ===start request1===
         ===start request11===
         */
//        Observable.zip(request1(), request11()) {
//            string1, string2 -> (String, String) in
//            print("======")
//            return (string1, string2)
//        }
        
        // 没有subscribe(),不点击和点击按钮都什么都不执行
//        button.rx.tap.flatMapLatest { _ in
//                Observable.zip(self.request1(), self.request11()) {
//                    string1, string2 -> (String, String) in
//                    print("======")
//                    return (string1, string2)
//                }
//        }
        
        
        // 有subscribe(),这种样式他会执行方法,并执行方法返回中闭包的request
        /**
         ===start request1===
         ===start request11===
         
         ##subscribe后才会有下面的打印##
         onNext request1  3秒后打印这行
         onNext request11 5秒后打印这行以及下面
         ======
         ==request1==###==request11==
         */
//        Observable.zip(request1(), request11()) {
//            string1, string2 -> (String, String) in // in后面不是1句代码，这边必须写返回类型
//            print("======")
//            return (string1, string2)
//        }.subscribe(onNext: { (tuple) in
//            print(tuple.0 + "###" + tuple.1)
//        }).disposed(by: disposeBag)
        
        // 有subscribe(),不点击按钮什么都不执行
        /**
         ##subscribe后才会有下面的打印##
         点击按钮:
        ===start request1===
        ===start request11===
        onNext request1  3秒后打印这行
        onNext request11 5秒后打印这行以及下面
        ======
        ==request1==###==request11==
        */
//        button.rx.tap.flatMapLatest { _ in
//                Observable.zip(self.request1(), self.request11()) {
//                    string1, string2 -> (String, String) in
//                    print("======")
//                    return (string1, string2)
//                }
//        }.subscribe(onNext: { (tuple) in
//                    print(tuple.0 + "###" + tuple.1)
//                }).disposed(by: disposeBag)
        
        
        // MARK: ###Observable###
//        Observable<String>.create { (observer) -> Disposable in
//            print("=======")// 被subscribe才会走这个闭包
//            return Disposables.create()
//        }.subscribe(onNext: { (str) in
//            print("str = \(str)")
//        }).disposed(by: disposeBag)
        
        
        // MARK: 区别###concatMap && concat###
//        let subject1 = BehaviorSubject(value: "1")
//        let subject2 = BehaviorSubject(value: "2")
//        let relay = BehaviorRelay(value: subject1)
//
//        relay.asObservable()
////            .concatMap { $0 }
//            .concat()
//            .subscribe(onNext: {// 1, 1
//            print($0)
//        }).disposed(by: disposeBag)
//        subject1.onNext("11")// 11, 11
//        subject2.onNext("22")// 无, 无
//        relay.accept(subject2)// 无, 无
//        subject2.onNext("222")// 无, 无
//        subject1.onNext("111")// 111, 111
//        subject1.onCompleted()// 222, 222
        
        
        // concat
//        let subject1 = BehaviorSubject(value: "1")
//        let subject2 = BehaviorSubject(value: "2")
//        let relay = BehaviorRelay(value: subject1)
//
//        relay.asObservable()
//            .concat()
//            .subscribe(onNext: {// 1
//                print($0)
//            }).disposed(by: disposeBag)
//
//        subject2.onNext("22")// 无
//        subject1.onNext("11")// 11
//        subject1.onNext("111")// 111
//        subject1.onCompleted()// 无
//        relay.accept(subject2)// 22 accept的类型必须一致
//        subject2.onNext("222")// 222
        
        
        // concat(second)
//        let subject1 = BehaviorSubject(value: "1")
//        let subject2 = BehaviorSubject(value: "2")

        // test1
//        subject1.asObservable()
//            .concat(subject2)
//            .subscribe(onNext: {// 1
//                print($0)
//            }).disposed(by: disposeBag)
//
//        subject2.onNext("2222")// 无
//        subject1.onNext("11")// 11
//        subject1.onNext("111")// 111
//        subject1.onCompleted()// 2222
//        subject2.onNext("222")// 222
        
        // test2
//        subject1.asObservable()
//            .concat(Observable<String>.of("123456"))// String类型必须一致
//            .subscribe(onNext: {// 1
//                print($0)
//            }).disposed(by: disposeBag)
//
//        subject1.onNext("11")// 11
//        subject1.onNext("111")// 111
//        subject1.onCompleted()// 123456

        
        // MARK: 区别###flatMap && flatMapLatest && flatMapFirst###
//        let subject1 = BehaviorSubject(value: "1")
//        let subject2 = BehaviorSubject(value: "2")
//        let subject3 = BehaviorSubject(value: "3")
//        let relay = BehaviorRelay(value: subject1)
//
//        relay.asObservable().flatMap {
//            $0
//        }.subscribe(onNext: {// 1, 1, 1
//            print($0)
//        }).disposed(by: disposeBag)
//
//        // flatMap, flatMapLatest, flatMapFirst
//        subject1.onNext("11")// 11, 11, 11
//        relay.accept(subject2)// 2, 2, 无
//        subject2.onNext("22")// 22, 22, 无
//        subject1.onNext("111")// 111, 无, 111
//        relay.accept(subject3)// 3, 3, 无
//        subject3.onNext("33")// 33, 33, 无
//        subject2.onNext("222")// 222, 无, 无
//        subject1.onNext("1111")// 1111, 无, 1111
        
        // MARK: 区别###withLatestFrom && flatMapLatest###
        /**
         withLatestFrom:
         按钮没有tap就执行后面的request，点击即发送后面的onNext,不再request
         不subscribe也会执行后面的request
         button.rx.tap.withLatestFrom(BUAPI.getRentalServiceContract()).subscribe
         
         flatMapLatest:
         按钮没有tap不执行request，点击一次就request一次
         contractButton.rx.tap.flatMapLatest {
             BUAPI.getRentalServiceContract()
         }.subscribe
         
         ================
         combineLatest:
         */
        
        // withLatestFrom: 没点击就执行了闭包的方法
//        button.rx.tap.withLatestFrom(self.request1()).subscribe(onNext: { (str) in
//            print("str = \(str)")
//        }, onError: { (error) in
//
//        }, onCompleted: {
//
//        }).disposed(by: disposeBag)
        
        // MARK: ==========###BehaviorRelay 相关操作 start###==========
        // switchLatest:
//        let subject1 = BehaviorSubject(value: "1")
//        let subject2 = BehaviorSubject(value: "2")
//        let relay = BehaviorRelay(value: subject1)
//
//        relay.asObservable()
//            .switchLatest()
//            .subscribe(onNext: {// 1
//                print($0)
//            }).disposed(by: disposeBag)
//        subject1.onNext("11")// 11
//        subject2.onNext("22")
//        relay.accept(subject2)// 22
//        subject1.onNext("111")
//        subject2.onNext("222")// 222
        
        // flatMapLatest 与 flatMap 的唯一区别是:flatMapLatest 只会接收最新的 value 事件
        
        // MARK: ==========###BehaviorRelay 相关操作 end###==========
        
        // MARK:====================================================================
        
        // MARK:观察者
        // 直接在 subscribe，bind 方法中创建观察者
        // bind(to: observer)观察者
        // 使用 Binder 创建观察者
        
        /*
         MRAK:原理
         打断点 查看调用堆栈
         
         // =====Observable=====
         class AnonymousObservable<Element> : Producer
         class Producer<Element> : Observable<Element>
         class Observable<Element> : ObservableType
         // ###
         public protocol ObservableConvertibleType {
         associatedtype E
         func asObservable() -> Observable<E>
         }
         
         public protocol ObservableType : ObservableConvertibleType {
         func subscribe<O: ObserverType>(_ observer: O) -> Disposable where O.E == E
         }
         // ###
         
         create: Create.swift
         返回AnonymousObservable(subscribe),将闭包保存在AnonymousObservable
         
         subscribe:
         // ObservableType+Extensions
         ObservableType.subscribe() return AnonymousObservable(subscribe) 创建了匿名AnonymousObserver: observer1保存eventHandler闭包 （onNext，onError等被捕获进了eventHandler闭包，为了后面这些被执行）
         Producer.subscribe(observer1)-> run(observer1)
         AnonymousObservable.run->创建AnonymousObservableSink(observer1)
         AnonymousObservableSink.run
         // typealias Parent = AnonymousObservable<E>
         parent._subscribeHandler(AnyObserver(self)) 执行前面保存的闭包 创建了AnyObserver(self):即用AnonymousObservableSink初始化AnyObserver AnyObserver(是遵守ObserverType协议) self即AnonymousObservableSink(是遵守ObserverType协议)
         
         // AnyObserver 保存了一个信息 AnonymousObservableSink.on 函数，不是 AnonymousObservableSink
         public struct AnyObserver<Element> : ObserverType {
         private let observer: EventHandler
         public init<O : ObserverType>(_ observer: O) where O.E == Element {
         self.observer = observer.on
         }
         public func on(_ event: Event<Element>) {
         return self.observer(event)
         }
         }
         
         // =====observer=====
         class AnonymousObserver<ElementType> : ObserverBase<ElementType>
         class ObserverBase<ElementType> : Disposable, ObserverType
         
         final fileprivate class AnonymousObservableSink<O: ObserverType> : Sink<O>, ObserverType
         class Sink<O : ObserverType> : Disposable
         
         public struct AnyObserver<Element> : ObserverType
         
         发送响应:
         observer.onNext 的本质是: AnyObserver(就是ObserverType).onNext->on(.next(element))
         AnyObserver.on->self.observer(event) self.observer即AnonymousObservableSink.on函数
         AnonymousObservableSink.on调用父类Sink的forwardOn(event)
         Sink.forwardOn->_observer.on(event)  _observer即AnonymousObservableSink保存的observer ###即上面的observer1,即AnonymousObserver###
         _observer没有实现on方法 就调用AnonymousObserver父类ObserverBase.on(Event)
         on方法中调用onCore(event) onCore是抽象方法 即调用子类AnonymousObserver.onCore->_eventHandler(event) 把event传给AnonymousObserver，执行AnonymousObserver的闭包
         （逻辑辗转回到了我们 订阅序列 时候创建的 AnonymousObserver 的参数闭包的调用）
         然后执行闭包内相应的subscribe方法传入的onNext，onError等
         
         
         // ###
         public protocol ObserverType {
         associatedtype E
         func on(_ event: Event<E>)
         }
         
         extension ObserverType {
         public func onNext(_ element: E) {
         on(.next(element))
         }

         public func onCompleted() {
         on(.completed)
         }
         
         public func onError(_ error: Swift.Error) {
         on(.error(error))
         }
         }
         
         public enum Event<Element> {
         case next(Element)
         case error(Swift.Error)
         case completed
         }

         // ###
         
         public protocol Disposable {
         func dispose()
         }
         
         // do nothing
         fileprivate struct NopDisposable : Disposable
         
         public struct Disposables {
         }
         
         public protocol Cancelable : Disposable {
         var isDisposed: Bool { get }
         }
         
         public final class DisposeBag: DisposeBase
         public class DisposeBase
         
         
RxSwift最典型的特色就是解决Swift这门静态语言的响应能力，利用随时间维度序列变化为轴线，用户订阅关心能随轴线一直保活，达到订阅一次，响应一直持续
         */
        
        
        let observable = Observable<String>.create({ (observer) -> Disposable in
            
            print("create: \(observer)")
            observer.onNext("hello")
            observer.onCompleted()
            return Disposables.create()
        })
        
        
            
//            .subscribe(onNext: { (text) in
//
//            print("text1 = \(text)")
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
        
        
//        observable.subscribe(onNext: { (text) in
//            print("text1 = \(text)")
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)

//        observable.subscribe(onNext: { (text) in
//            print("text2 = \(text)")
//        }, onError: nil, onCompleted: nil, onDisposed: nil).disposed(by: disposeBag)
        
//        let observer = AnyObserver<String> { event in
//
//            print("\(event)")
//        }
//        print("observer: \(observer)")
//        print(Unmanaged<AnyObject>.passUnretained(observer as AnyObject).toOpaque())
//        observable.subscribe(observer).disposed(by: disposeBag)
        // =============================
        
//        _ = Observable<String>.create({ (observer) -> Disposable in
//
//            observer.onNext("hello")
//            return Disposables.create()
//        }).subscribe({ (event) in
//
//            print("event = \(event)")
//        }).disposed(by: disposeBag)
        
        // MARK:test BehaviorRelay(是作为 Variable 的替代者)
//        let subject = BehaviorRelay<String>(value: "123")
//        subject.accept("234")
//        subject.asObservable().subscribe {
//            print("result =", $0) // next(234)
//        }.disposed(by: disposeBag)
        
        // MARK:TEST flatmap
//        let subject1 = BehaviorSubject(value: "111")
//        let subject2 = BehaviorSubject(value: "222")
//        let behaviorRelay = BehaviorRelay(value: subject1)
////        print(behaviorRelay.value)
////        behaviorRelay.asObservable().subscribe {
////            print($0)// next(RxSwift.BehaviorSubject<Swift.String>)
////        }.disposed(by: disposeBag)
//
//        behaviorRelay.asObservable().flatMap {
//            $0
//        }.subscribe {
//            print("flatMap =", $0)// next(111)
//        }.disposed(by: disposeBag)
//
//        behaviorRelay.accept(subject2)// next(222)
//        subject1.onNext("111_Next")// next(111_Next)
        
        
        // MARK:Test share
        /*
         订阅1: 0
         订阅1: 1
         订阅1: 2
         订阅1: 3
         订阅1: 4
         订阅2: 3
         订阅2: 4
         订阅1: 5
         订阅2: 5
         订阅1: 6
         订阅2: 6
         */
//        let interval1 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//            .share(replay: 2)
//
//        //第一个订阅者（立刻开始订阅）
//        _ = interval1
//            .subscribe(onNext: { print("订阅1: \($0)") })
//
//        //第二个订阅者（延迟5秒开始订阅）
//        delay(5) {
//            _ = interval1
//                .subscribe(onNext: { print("订阅2: \($0)") })
//        }
    
        
        // TODO:==Observable==
        /*
         Observable:可观察序列
         ###它的作用就是可以异步地产生一系列的 Event（事件），即一个 Observable<T> 对象会随着时间推移不定期地发出 event(element : T) 这样一个东西
         有了可观察序列，我们还需要有一个Observer（订阅者）来订阅它，这样这个订阅者才能收到 Observable<T> 不时发出的 Event###
         
         Observable 是可以发出 3 种不同类型的  Event 事件:next,error,completed
         next：next事件就是那个可以携带数据 <T> 的事件，可以说它就是一个“最正常”的事件
         error：error 事件表示一个错误，它可以携带具体的错误内容，一旦 Observable 发出了 error event，则这个 Observable 就等于终止了，以后它再也不会发出 event 事件了
         completed：completed 事件表示Observable 发出的事件正常地结束了，跟 error 一样，一旦 Observable 发出了 completed event，则这个 Observable 就等于终止了，以后它再也不会发出 event 事件了
         
         Observable 对象会在有任何 Event 时候，自动将 Event作为一个参数通过ObservableType.subscribe(_:)发出
         */
//        // 1.just() 方法: 该方法通过传入一个默认值来初始化
//        let observable0 = Observable<Int>.just(5)
//        // 2.of() 方法: 该方法可以接受可变数量的参数（必需要是同类型的）
//        let observable1 = Observable.of("A", "B", "C")
//        // 3.from() 方法: 该方法需要一个数组参数
//        let observable2 = Observable.from(["A", "B", "C"])
//        // 4.empty() 方法: 该方法创建一个空内容的 Observable 序列
//        let observable3 = Observable<Int>.empty()
//        // 5.never() 方法: 该方法创建一个永远不会发出 Event（也不会终止）的 Observable 序列。
//        let observable4 = Observable<Int>.never()
//        // 6.error() 方法: 该方法创建一个不做任何操作，而是直接发送一个错误的 Observable 序列。
//        enum MyError: Error {
//            case A
//            case B
//        }
//        let observable5 = Observable<Int>.error(MyError.A)
//        // 7.range() 方法: 该方法通过指定起始和结束数值，创建一个以这个范围内所有值作为初始值的Observable序列
//        let observable6 = Observable.range(start: 1, count: 5)
//        // 8.repeatElement() 方法: 该方法创建一个可以无限发出给定元素的 Event的 Observable 序列（永不终止）。
//        let observable7 = Observable.repeatElement(1)
//        // 9.generate() 方法: 该方法创建一个只有当提供的所有的判断条件都为 true 的时候，才会给出动作的  Observable 序列
//        let observable8 = Observable.generate(
//            initialState: 0,
//            condition: { $0 <= 10 },
//            iterate: { $0 + 2 }
//        )
//        // 10.create() 方法: 该方法接受一个 block 形式的参数，任务是对每一个过来的订阅进行处理
//        //这个block有一个回调参数observer就是订阅这个Observable对象的订阅者
//        //当一个订阅者订阅这个Observable对象的时候，就会将订阅者作为参数传入这个block来执行一些内容
//        let observable9 = Observable<String>.create{observer in
//            //对订阅者发出了.next事件，且携带了一个数据"hangge.com"
//            observer.onNext("hangge.com")
//            //对订阅者发出了.completed事件
//            observer.onCompleted()
//            //因为一个订阅行为会有一个Disposable类型的返回值，所以在结尾一定要returen一个Disposable
//            return Disposables.create()
//        }
//
//        //订阅测试
//        observable9.subscribe {
//            print($0)
//        }
//        // 11.deferred() 方法: 该个方法相当于是创建一个 Observable 工厂，通过传入一个 block 来执行延迟 Observable序列创建的行为，而这个 block 里就是真正的实例化序列对象的地方
//        //用于标记是奇数、还是偶数
//        var isOdd = true
//
//        // 使用deferred()方法延迟Observable序列的初始化，通过传入的block来实现Observable序列的初始化并且返回。
//        let factory : Observable<Int> = Observable.deferred {
//
//            //让每次执行这个block时候都会让奇、偶数进行交替
//            isOdd = !isOdd
//
//            //根据isOdd参数，决定创建并返回的是奇数Observable、还是偶数Observable
//            if isOdd {
//                return Observable.of(1, 3, 5 ,7)
//            }else {
//                return Observable.of(2, 4, 6, 8)
//            }
//        }
//
//        //第1次订阅测试
//        factory.subscribe { event in
//            print("\(isOdd)", event)
//        }
//
//        //第2次订阅测试
//        factory.subscribe { event in
//            print("\(isOdd)", event)
//        }
//
//        // 12.interval() 方法: 这个方法创建的 Observable 序列每隔一段设定的时间，会发出一个索引数的元素。而且它会一直发送下去
//        let observable10 = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
//        observable10.subscribe { event in
//            print(event)
//        }
//
//        // 13.timer() 方法:
//        // 在经过设定的一段时间后，产生唯一的一个元素
//        //5秒种后发出唯一的一个元素0
//        let observable11 = Observable<Int>.timer(5, scheduler: MainScheduler.instance)
//        observable11.subscribe { event in
//            print(event)
//        }
//        // 经过设定的一段时间后，每隔一段时间产生一个元素
//        //延时5秒种后，每隔1秒钟发出一个元素
//        let observable12 = Observable<Int>.timer(5, period: 1, scheduler: MainScheduler.instance)
//        observable12.subscribe { event in
//            print(event)
//        }
        
        /*
         TODO:===订阅 Observable:===
         有了 Observable，我们还要使用 subscribe() 方法来订阅它，接收它发出的 Event
         
         1.我们使用 subscribe() 订阅了一个Observable 对象
         let observable = Observable.of("A", "B", "C")
         
         observable.subscribe { event in
         print(event)// 如果想要获取到这个事件里的数据，可以通过 event.element 得到
         }
         初始化 Observable 序列时设置的默认值都按顺序通过 .next 事件发送出来。
         当 Observable 序列的初始数据都发送完毕，它还会自动发一个 .completed 事件出来
         
         2.RxSwift 还提供了另一个 subscribe方法，它可以把 event 进行分类
         通过不同的 block 回调处理不同类型的 event。（其中 onDisposed 表示订阅行为被 dispose 后的回调
         let observable = Observable.of("A", "B", "C")
         // 同时会把 event 携带的数据直接解包出来作为参数
         observable.subscribe(onNext: { element in
         print(element)
         }, onError: { error in
         print(error)
         }, onCompleted: {
         print("completed")
         }, onDisposed: {
         print("disposed")
         })
         
         监听事件的生命周期:
         我们可以使用 doOn 方法来监听事件的生命周期，它会在每一次事件发送前被调用[do(onNext:)方法就是在subscribe(onNext:) 前调用]
         let observable = Observable.of("A", "B", "C")
         
         observable
         .do(onNext: { element in
         print("Intercepted Next：", element)
         }, onError: { error in
         print("Intercepted Error：", error)
         }, onCompleted: {
         print("Intercepted Completed")
         }, onDispose: {
         print("Intercepted Disposed")
         })
         .subscribe(onNext: { element in
         print(element)
         }, onError: { error in
         print(error)
         }, onCompleted: {
         print("completed")
         }, onDisposed: {
         print("disposed")
         })
         
         Observable 的销毁（Dispose）:
         一个 Observable 序列被创建出来后它不会马上就开始被激活从而发出 Event，而是要等到它被某个人订阅了才会激活它
         而 Observable 序列激活之后要一直等到它发出了.error或者 .completed的 event 后，它才被终结
         
         dispose() 方法:使用该方法我们可以手动取消一个订阅行为
         如果我们觉得这个订阅结束了不再需要了，就可以调用 dispose()方法把这个订阅给销毁掉，防止内存泄漏
         当一个订阅行为被dispose 了，那么之后 observable 如果再发出 event，这个已经 dispose 的订阅就收不到消息了
         let observable = Observable.of("A", "B", "C")
         
         //使用subscription常量存储这个订阅方法
         let subscription = observable.subscribe { event in
         print(event)
         }
         
         //调用这个订阅的dispose()方法
         subscription.dispose()
         
         DisposeBag: 除了 dispose()方法之外，我们更经常用到的是一个叫 DisposeBag 的对象来管理多个订阅行为的销毁
         我们可以把一个 DisposeBag对象看成一个垃圾袋，把用过的订阅行为都放进去。
         而这个DisposeBag 就会在自己快要dealloc 的时候，对它里面的所有订阅行为都调用 dispose()方法
         let disposeBag = DisposeBag()
         
         //第1个Observable，及其订阅
         let observable1 = Observable.of("A", "B", "C")
         observable1.subscribe { event in
         print(event)
         }.disposed(by: disposeBag)
         
         //第2个Observable，及其订阅
         let observable2 = Observable.of(1, 2, 3)
         observable2.subscribe { event in
         print(event)
         }.disposed(by: disposeBag)
         */
        
        // TODO:==观察者（Observer）==
        /*
         观察者（Observer）的作用就是监听事件，然后对这个事件做出响应。或者说任何响应事件的行为都是观察者
         当我们点击按钮，弹出一个提示框。那么这个“弹出一个提示框”就是观察者Observer<Void>
         当我们请求一个远程的json 数据后，将其打印出来。那么这个“打印 json 数据”就是观察者 Observer<JSON>
         
         直接在 subscribe、bind 方法中创建观察者
         1.在 subscribe 方法中创建
         let observable = Observable.of("A", "B", "C")
         
         observable.subscribe(onNext: { element in
         print(element)
         }, onError: { error in
         print(error)
         }, onCompleted: {
         print("completed")
         })
         2.在 bind 方法中创建
         class ViewController: UIViewController {
         
         @IBOutlet weak var label: UILabel!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //Observable序列（每隔1秒钟发出一个索引数）
         let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         
         observable
         .map { "当前索引数：\($0 )"}
         .bind { [weak self](text) in
         //收到发出的索引数后显示到label上
         self?.label.text = text
         }
         .disposed(by: disposeBag)
         }
         }
         
         使用 AnyObserver 创建观察者:
         AnyObserver 可以用来描叙任意一种观察者
         //观察者
         let observer: AnyObserver<String> = AnyObserver { (event) in
         switch event {
         case .next(let data):
         print(data)
         case .error(let error):
         print(error)
         case .completed:
         print("completed")
         }
         }
         
         let observable = Observable.of("A", "B", "C")
         observable.subscribe(observer)
         
         也可配合 Observable 的数据绑定方法（bindTo）使用:
         class ViewController: UIViewController {
         
         @IBOutlet weak var label: UILabel!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //观察者
         let observer: AnyObserver<String> = AnyObserver { [weak self] (event) in
         switch event {
         case .next(let text):
         //收到发出的索引数后显示到label上
         self?.label.text = text
         default:
         break
         }
         }
         
         //Observable序列（每隔1秒钟发出一个索引数）
         let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         observable
         .map { "当前索引数：\($0 )"}
         .bind(to: observer)
         .disposed(by: disposeBag)
         }
         }
         
         使用 Binder 创建观察者:
         public struct Binder<Value>: ObserverType
         
         相较于AnyObserver 的大而全，Binder 更专注于特定的场景。Binder 主要有以下两个特征：
         不会处理错误事件
         确保绑定都是在给定 Scheduler 上执行（默认 MainScheduler）
         一旦产生错误事件，在调试环境下将执行 fatalError，在发布环境下将打印错误信息
         class ViewController: UIViewController {
         
         @IBOutlet weak var label: UILabel!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //观察者
         let observer: Binder<String> = Binder(label) { (view, text) in
         //收到发出的索引数后显示到label上
         view.text = text
         }
         
         //Observable序列（每隔1秒钟发出一个索引数）
         let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         observable
         .map { "当前索引数：\($0 )"}
         .bind(to: observer)
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===自定义可绑定属性===
        /*
         比如我们想要让所有的 UIlabel 都有个 fontSize 可绑定属性，它会根据事件值自动改变标签的字体大小
         1.通过对 UI 类进行扩展
         class ViewController: UIViewController {
         
         @IBOutlet weak var label: UILabel!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //Observable序列（每隔0.5秒钟发出一个索引数）
         let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
         observable
         .map { CGFloat($0) }
         .bind(to: label.fontSize) //根据索引数不断变放大字体
         .disposed(by: disposeBag)
         }
         }
         
         extension UILabel {
         public var fontSize: Binder<CGFloat> {
         return Binder(self) { label, fontSize in
         label.font = UIFont.systemFont(ofSize: fontSize)
         }
         }
         }
         2.通过对 Reactive 类进行扩展
         既然使用了 RxSwift，那么更规范的写法应该是对 Reactive 进行扩展
         class ViewController: UIViewController {
         
         @IBOutlet weak var label: UILabel!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //Observable序列（每隔0.5秒钟发出一个索引数）
         let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
         observable
         .map { CGFloat($0) }
         .bind(to: label.rx.fontSize) //根据索引数不断变放大字体
         .disposed(by: disposeBag)
         }
         }
         
         extension Reactive where Base: UILabel {
         public var fontSize: Binder<CGFloat> {
         return Binder(self.base) { label, fontSize in
         label.font = UIFont.systemFont(ofSize: fontSize)
         }
         }
         }
         
         RxSwift 自带的可绑定属性（UI 观察者）:
         比如 UILabel 就有 text 和 attributedText 这两个可绑定属性
         class ViewController: UIViewController {
         
         @IBOutlet weak var label: UILabel!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //Observable序列（每隔1秒钟发出一个索引数）
         let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         observable
         .map { "当前索引数：\($0 )"}
         .bind(to: label.rx.text) //收到发出的索引数后显示到label上
         .disposed(by: disposeBag)
         }
         }
        */
        
        // TODO:===Subjects、Variables===
        // 当我们创建一个 Observable 的时候就要预先将要发出的数据都准备好，等到有人订阅它时再将数据通过 Event 发出去
        /*
         Subjects 既是订阅者，也是 Observable
         说它是订阅者，是因为它能够动态地接收新的值。
         说它又是一个 Observable，是因为当 Subjects 有了新的值之后，就会通过 Event 将新值发出给他的所有订阅者
         
         一共有四种 Subjects，分别为：PublishSubject、BehaviorSubject、ReplaySubject、Variable
         相同之处:
         首先他们都是 Observable，他们的订阅者都能收到他们发出的新的 Event。
         直到 Subject 发出 .complete 或者 .error 的 Event 后，该 Subject 便终结了，同时它也就不会再发出.next事件。
         对于那些在 Subject 终结后再订阅他的订阅者，也能收到 subject发出的一条 .complete 或 .error的 event，告诉这个新的订阅者它已经终结了
         他们之间最大的区别只是在于：当一个新的订阅者刚订阅它的时候，能不能收到 Subject 以前发出过的旧 Event?
         
         Subject 常用的几个方法：
         onNext(:)：是 on(.next(:)) 的简便写法。该方法相当于 subject 接收到一个.next 事件。
         onError(:)：是 on(.error(:)) 的简便写法。该方法相当于 subject 接收到一个 .error 事件。
         onCompleted()：是 on(.completed)的简便写法。该方法相当于 subject 接收到一个 .completed 事件
         
         MARK:PublishSubject:
         ###当订阅者订阅PublishSubject 时，只会收到订阅后Subject发出的新Event，而不会收到订阅之前发出的旧Event###
         let disposeBag = DisposeBag()
         
         //创建一个PublishSubject
         let subject = PublishSubject<String>()
         
         //由于当前没有任何订阅者，所以这条信息不会输出到控制台
         subject.onNext("111")
         
         //第1次订阅subject
         subject.subscribe(onNext: { string in
         print("第1次订阅：", string)
         }, onCompleted:{
         print("第1次订阅：onCompleted")
         }).disposed(by: disposeBag)
         
         //当前有1个订阅，则该信息会输出到控制台
         subject.onNext("222")
         
         //第2次订阅subject
         subject.subscribe(onNext: { string in
         print("第2次订阅：", string)
         }, onCompleted:{
         print("第2次订阅：onCompleted")
         }).disposed(by: disposeBag)
         
         //当前有2个订阅，则该信息会输出到控制台
         subject.onNext("333")
         
         //让subject结束
         subject.onCompleted()// 所有的订阅都会收到
         
         //subject完成后会发出.next事件了。
         subject.onNext("444")
         
         //subject完成后它的所有订阅（包括结束后的订阅），都能收到subject的.completed事件，
         subject.subscribe(onNext: { string in
         print("第3次订阅：", string)
         }, onCompleted:{
         print("第3次订阅：onCompleted")
         }).disposed(by: disposeBag)
         
         BehaviorSubject:
         BehaviorSubject 需要通过一个默认初始值来创建。
         当订阅者订阅BehaviorSubject 时，会收到订阅后Subject##上一个发出的Event##，如果还没有收到任何数据，会发出一个默认值
         当一个订阅者来订阅它的时候，这个订阅者会立即收到 BehaviorSubjects 上一个发出的event。之后就跟正常的情况一样，它也会接收到 BehaviorSubject 之后发出的新的 event
         let disposeBag = DisposeBag()
         
         //创建一个BehaviorSubject
         let subject = BehaviorSubject(value: "111")
         
         //第1次订阅subject
         subject.subscribe { event in
         print("第1次订阅：", event)
         }.disposed(by: disposeBag)
         
         //发送next事件
         subject.onNext("222")
         
         //发送error事件
         subject.onError(NSError(domain: "local", code: 0, userInfo: nil))
         
         //第2次订阅subject
         subject.subscribe { event in
         print("第2次订阅：", event)
         }.disposed(by: disposeBag)
         
         ReplaySubject:
         ReplaySubject 在创建时候需要设置一个 bufferSize，表示它对于它发送过的 event 的缓存个数
         比如一个 ReplaySubject 的 bufferSize 设置为 2，它发出了 3 个 .next 的 event，那么它会将后两个（最近的两个）event 给缓存起来。此时如果有一个 subscriber 订阅了这个 ReplaySubject，那么这个 subscriber 就会立即收到前面缓存的两个.next 的 event
         如果一个 subscriber 订阅已经结束的 ReplaySubject，除了会收到缓存的 .next 的 event外，还会收到那个终结的 .error 或者 .complete 的event
         let disposeBag = DisposeBag()
         
         //创建一个bufferSize为2的ReplaySubject
         let subject = ReplaySubject<String>.create(bufferSize: 2)
         
         //连续发送3个next事件
         subject.onNext("111")
         subject.onNext("222")
         subject.onNext("333")
         
         //第1次订阅subject
         subject.subscribe { event in
         print("第1次订阅：", event)
         }.disposed(by: disposeBag)
         
         //再发送1个next事件
         subject.onNext("444")
         
         //第2次订阅subject
         subject.subscribe { event in
         print("第2次订阅：", event)
         }.disposed(by: disposeBag)
         
         //让subject结束
         subject.onCompleted()
         
         //第3次订阅subject
         subject.subscribe { event in
         print("第3次订阅：", event)
         }.disposed(by: disposeBag)
         
         TODO:Variable:
         Variable他不是观察者也不是序列，没有任何继承
         Variable 封装了 BehaviorSubject。使用 variable 的好处是 variable 将不会显式的发送 Error 或者 Completed。在 deallocated 的时候，Variable 会自动的发送 complete 事件
         
         Variable 具有 BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
         不同的是，Variable 还会把当前发出的值保存为自己的状态。同时它会在销毁时自动发送 .complete的 event，不需要也不能手动给 Variables 发送 completed或者 error 事件来结束它
         简单地说就是 Variable 有一个 value 属性，我们改变这个 value 属性的值就相当于调用一般 Subjects 的 onNext() 方法，而这个最新的 onNext() 的值就被保存在 value 属性里了，直到我们再次修改它
         
         Variables 本身没有 subscribe() 方法，但是所有 Subjects 都有一个 asObservable() 方法。我们可以使用这个方法返回这个 Variable 的 Observable 类型，拿到这个 Observable 类型我们就能订阅它了
         
         class ViewController: UIViewController {
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         let disposeBag = DisposeBag()
         
         //创建一个初始值为111的Variable
         let variable = Variable("111")
         
         //修改value值
         variable.value = "222"
         
         //第1次订阅
         variable.asObservable().subscribe {
         print("第1次订阅：", $0)
         }.disposed(by: disposeBag)
         
         //修改value值
         variable.value = "333"
         
         //第2次订阅
         variable.asObservable().subscribe {
         print("第2次订阅：", $0)
         }.disposed(by: disposeBag)
         
         //修改value值
         variable.value = "444"
         }
         }
         
         由于 Variable对象在viewDidLoad() 方法内初始化，所以它的生命周期就被限制在该方法内。当这个方法执行完毕后，这个 Variable 对象就会被销毁，同时它也就自动地向它的所有订阅者发出.completed 事件

         */
        
        // TODO:===变换操作（Transforming Observables）===
        // 变换操作指的是对原始的 Observable 序列进行一些转换
        /*
         buffer:
         buffer 方法作用是缓冲组合，第一个参数是缓冲时间，第二个参数是缓冲个数，第三个参数是线程。
         该方法简单来说就是缓存 Observable 中发出的新元素，当元素达到某个数量，或者经过了特定的时间，它就会将这个元素集合发送出来
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         let subject = PublishSubject<String>()
         
         //每缓存3个元素则组合起来一起发出。
         //如果1秒钟内不够3个也会发出（有几个发几个，一个都没有发空数组 []）
         subject
         .buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject.onNext("a")
         subject.onNext("b")
         subject.onNext("c")
         
         subject.onNext("1")
         subject.onNext("2")
         subject.onNext("3")
         }
         }
         
         window:
         window 操作符和 buffer 十分相似。不过 buffer 是周期性的将缓存的元素集合发送出来，而 window 周期性的将元素集合以 Observable 的形态发送出来。
         同时 buffer要等到元素搜集完毕后，才会发出元素序列。而 window 可以实时发出元素序列
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         let subject = PublishSubject<String>()
         
         //每3个元素作为一个子Observable发出。
         subject
         .window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
         .subscribe(onNext: { [weak self]  in
         print("subscribe: \($0)")
         $0.asObservable()
         .subscribe(onNext: { print($0) })
         .disposed(by: self!.disposeBag)
         })
         .disposed(by: disposeBag)
         
         subject.onNext("a")
         subject.onNext("b")
         subject.onNext("c")
         
         subject.onNext("1")
         subject.onNext("2")
         subject.onNext("3")
         }
         }
         
         // TODO:map:
         该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3)
         .map { $0 * 10}
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         // TODO:flatMap:
         map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列。
         而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
         这个操作符是非常有用的。比如当 Observable 的元素本生拥有其他的 Observable 时，我们可以将所有子 Observables 的元素发送出来
         
         let disposeBag = DisposeBag()
         
         let subject1 = BehaviorSubject(value: "A")
         let subject2 = BehaviorSubject(value: "1")
         
         let variable = Variable(subject1)
         
         variable.asObservable()
         .flatMap { $0 }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject1.onNext("B")
         variable.value = subject2
         subject2.onNext("2")
         subject1.onNext("C")
         
         
         
         Observable<Int>.of(1, 2, 3)
         .flatMap { Observable<String>.just(">>" + "\($0)") }
         .subscribe(onNext: { element in
         print("element:", element)
         })
         .disposed(by: bag)
         
         // TODO:flatMapLatest:
         flatMapLatest与flatMap 的唯一区别是：flatMapLatest只会接收最新的value 事件
         let disposeBag = DisposeBag()
         
         let subject1 = BehaviorSubject(value: "A")
         let subject2 = BehaviorSubject(value: "1")
         
         let variable = Variable(subject1)
         
         variable.asObservable()
         .flatMapLatest { $0 }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject1.onNext("B")
         variable.value = subject2
         subject2.onNext("2")
         subject1.onNext("C")
         
         // TODO:concatMap:
         concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅
         let disposeBag = DisposeBag()
         
         let subject1 = BehaviorSubject(value: "A")
         let subject2 = BehaviorSubject(value: "1")
         
         let variable = Variable(subject1)
         
         variable.asObservable()
         .concatMap { $0 }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject1.onNext("B")
         variable.value = subject2
         subject2.onNext("2")
         subject1.onNext("C")
         subject1.onCompleted() //只有前一个序列结束后，才能接收下一个序列
         
         TODO:scan:
         scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3, 4, 5)
         .scan(0) { acum, elem in
         acum + elem
         }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         TODO:groupBy:
         groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来。
         也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来
         let disposeBag = DisposeBag()
         
         //将奇数偶数分成两组
         Observable<Int>.of(0, 1, 2, 3, 4, 5)
         .groupBy(keySelector: { (element) -> String in
         return element % 2 == 0 ? "偶数" : "基数"
         })
         .subscribe { (event) in
         switch event {
         case .next(let group):
         group.asObservable().subscribe({ (event) in
         print("key：\(group.key)    event：\(event)")
         })
         .disposed(by: disposeBag)
         default:
         print("")
         }
         }
         .disposed(by: disposeBag)
         */
        
        // TODO:===过滤操作符（Filtering Observables）===
        // 过滤操作指的是从源 Observable 中选择特定的数据发送
        // TODO:filter:
        /*
         该操作符就是用来过滤掉某些不符合要求的事件
         let disposeBag = DisposeBag()
         
         Observable.of(2, 30, 22, 5, 60, 3, 40 ,9)
         .filter {
         $0 > 10
         }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:distinctUntilChanged:
        /*
         该操作符用于过滤掉连续重复的事件
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3, 1, 1, 4)
         .distinctUntilChanged()
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:single:
        /*
         限制只发送一次事件，或者满足条件的第一个事件。
         如果存在有多个事件或者没有事件都会发出一个 error 事件。
         如果只有一个事件，则不会发出 error事件
         
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3, 4)
         .single{ $0 == 2 }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         Observable.of("A", "B", "C", "D")
         .single()
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:elementAt:
        /*
         该方法实现只处理在指定位置的事件
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3, 4)
         .elementAt(2)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:ignoreElements:
        /*
         该操作符可以忽略掉所有的元素，只发出 error或completed 事件。
         如果我们并不关心 Observable 的任何元素，只想知道 Observable 在什么时候终止，那就可以使用 ignoreElements 操作符
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3, 4)
         .ignoreElements()
         .subscribe{
         print($0)
         }
         .disposed(by: disposeBag)
         */
        
        // TODO:take:
        /*
         该方法实现仅发送 Observable 序列中的前 n 个事件，在满足数量之后会自动 .completed
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3, 4)
         .take(2)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:takeLast:
        /*
         该方法实现仅发送 Observable序列中的后 n 个事件
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3, 4)
         .takeLast(1)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:skip:
        /*
         该方法用于跳过源 Observable 序列发出的前 n 个事件
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3, 4)
         .skip(2)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:Sample:
        /*
         Sample 除了订阅源Observable 外，还可以监视另外一个 Observable， 即 notifier 。
         每当收到 notifier 事件，就会从源序列取一个最新的事件并发送。而如果两次 notifier 事件之间没有源序列的事件，则不发送值
         let disposeBag = DisposeBag()
         
         let source = PublishSubject<Int>()
         let notifier = PublishSubject<String>()
         
         source
         .sample(notifier)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         source.onNext(1)
         
         //让源序列接收接收消息
         notifier.onNext("A")
         
         source.onNext(2)
         
         //让源序列接收接收消息
         notifier.onNext("B")
         notifier.onNext("C")
         
         source.onNext(3)
         source.onNext(4)
         
         //让源序列接收接收消息
         notifier.onNext("D")
         
         source.onNext(5)
         
         //让源序列接收接收消息
         notifier.onCompleted()
         */
        
        // TODO:debounce:
        /*
         debounce 操作符可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生。
         换句话说就是，队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。
         
         debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //定义好每个事件里的值以及发送的时间
         let times = [
         [ "value": 1, "time": 0.1 ],
         [ "value": 2, "time": 1.1 ],
         [ "value": 3, "time": 1.2 ],
         [ "value": 4, "time": 1.2 ],
         [ "value": 5, "time": 1.4 ],
         [ "value": 6, "time": 2.1 ]
         ]
         
         //生成对应的 Observable 序列并订阅
         Observable.from(times)
         .flatMap { item in
         return Observable.of(Int(item["value"]!))
         .delaySubscription(Double(item["time"]!),
         scheduler: MainScheduler.instance)
         }
         .debounce(0.5, scheduler: MainScheduler.instance) //只发出与下一个间隔超过0.5秒的元素
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===条件和布尔操作符（Conditional and Boolean Operators）===
        // 条件和布尔操作会根据条件发射或变换 Observables，或者对他们做布尔运算
        
        // TODO:amb:
        /*
         当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables
         let disposeBag = DisposeBag()
         
         let subject1 = PublishSubject<Int>()
         let subject2 = PublishSubject<Int>()
         let subject3 = PublishSubject<Int>()
         
         subject1
         .amb(subject2)
         .amb(subject3)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject2.onNext(1)
         subject1.onNext(20)
         subject2.onNext(2)
         subject1.onNext(40)
         subject3.onNext(0)
         subject2.onNext(3)
         subject1.onNext(60)
         subject3.onNext(0)
         subject3.onNext(0)
         */
        
        // TODO:takeWhile:
        /*
         该方法依次判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成
         let disposeBag = DisposeBag()
         
         Observable.of(2, 3, 4, 5, 6)
         .takeWhile { $0 < 4 }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:takeUntil:
        /*
         除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier。
         如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件
         let disposeBag = DisposeBag()
         
         let source = PublishSubject<String>()
         let notifier = PublishSubject<String>()
         
         source
         .takeUntil(notifier)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         source.onNext("a")
         source.onNext("b")
         source.onNext("c")
         source.onNext("d")
         
         //停止接收消息
         notifier.onNext("z")
         
         source.onNext("e")
         source.onNext("f")
         source.onNext("g")
         */
        
        // TODO:skipWhile:
        /*
         该方法用于跳过前面所有满足条件的事件。
         一旦遇到不满足条件的事件，之后就不会再跳过了
         let disposeBag = DisposeBag()
         
         Observable.of(2, 3, 4, 5, 6)
         .skipWhile { $0 < 4 }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:skipUntil:
        /*
         skipUntil 除了订阅源 Observable 外，通过 skipUntil方法我们还可以监视另外一个 Observable， 即 notifier 。
         与 takeUntil 相反的是。源 Observable 序列事件默认会一直跳过，直到 notifier 发出值或 complete 通知
         let disposeBag = DisposeBag()
         
         let source = PublishSubject<Int>()
         let notifier = PublishSubject<Int>()
         
         source
         .skipUntil(notifier)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         source.onNext(1)
         source.onNext(2)
         source.onNext(3)
         source.onNext(4)
         source.onNext(5)
         
         //开始接收消息
         notifier.onNext(0)
         
         source.onNext(6)
         source.onNext(7)
         source.onNext(8)
         
         //仍然接收消息
         notifier.onNext(0)
         
         source.onNext(9)
         */
        
        // TODO:===特征序列：ControlProperty、 ControlEvent===
        // ControlProperty 是专门用来描述 UI 控件属性，拥有该类型的属性都是被观察者（Observable）
        /*
         ControlProperty 具有以下特征：
         
         不会产生 error 事件
         一定在 MainScheduler 订阅（主线程订阅）
         一定在 MainScheduler 监听（主线程监听）
         共享状态变化
         
         UITextField 的 rx.text 属性类型便是 ControlProperty<String?>
         那么我们如果想让一个 textField 里输入内容实时地显示在另一个 label 上，即前者作为被观察者，后者作为观察者
         class ViewController: UIViewController {
         
         @IBOutlet weak var textField: UITextField!
         
         @IBOutlet weak var label: UILabel!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //将textField输入的文字绑定到label上
         textField.rx.text
         .bind(to: label.rx.text)
         .disposed(by: disposeBag)
         }
         }
         
         ControlEvent:
         ControlEvent 是专门用于描述 UI 所产生的事件，拥有该类型的属性都是被观察者（Observable）
         不会产生 error 事件
         一定在 MainScheduler 订阅（主线程订阅）
         一定在 MainScheduler 监听（主线程监听）
         共享状态变化

         在 RxCocoa 下许多 UI 控件的事件方法都是被观察者（可观察序列）
         UIButton 的 rx.tap 方法类型便是 ControlEvent<Void>
         那么我们如果想实现当一个 button 被点击时，在控制台输出一段文字。即前者作为被观察者，后者作为观察者。可以这么写：
         import UIKit
         import RxSwift
         import RxCocoa
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         @IBOutlet weak var button: UIButton!
         
         override func viewDidLoad() {
         
         //订阅按钮点击事件
         button.rx.tap
         .subscribe(onNext: {
         print("欢迎访问hangge.com")
         }).disposed(by: disposeBag)
         }
         }
         
         */
        
        // TODO:===调度器（Schedulers）===
        // 调度器（Schedulers）是 RxSwift 实现多线程的核心模块，它主要用于控制任务在哪个线程或队列运行
        /*
         内置了如下几种 Scheduler：
         
         
         CurrentThreadScheduler：表示当前线程 Scheduler。（默认使用这个）
         
         MainScheduler：表示主线程。如果我们需要执行一些和 UI 相关的任务，就需要切换到该 Scheduler运行。
         
         SerialDispatchQueueScheduler：封装了 GCD 的串行队列。如果我们需要执行一些串行任务，可以切换到这个 Scheduler 运行。
         
         ConcurrentDispatchQueueScheduler：封装了 GCD 的并行队列。如果我们需要执行一些并发任务，可以切换到这个 Scheduler 运行。
         
         OperationQueueScheduler：封装了 NSOperationQueue
         
         let rxData: Observable<Data> = ...
         
         rxData
         .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated)) //后台构建序列
         .observeOn(MainScheduler.instance)  //主线程监听并处理序列结果
         .subscribe(onNext: { [weak self] data in
         self?.data = data
         })
         .disposed(by: disposeBag)
         
         subscribeOn 与 observeOn 区别:
         （1）subscribeOn()
         
         该方法决定数据序列的构建函数在哪个 Scheduler 上运行。
         比如上面样例，由于获取数据、解析数据需要花费一段时间的时间，所以通过 subscribeOn 将其切换到后台 Scheduler 来执行。这样可以避免主线程被阻塞。
         
         （2）observeOn()
         
         该方法决定在哪个 Scheduler 上监听这个数据序列。
         比如上面样例，我们获取并解析完毕数据后又通过 observeOn 方法切换到主线程来监听并且处理结果。
         */
        
        // TODO:===结合操作（Combining Observables）===
        // 结合操作（或者称合并操作）指的是将多个 Observable 序列进行组合，拼装成一个新的 Observable 序列
        // TODO:startWith:
        /*
         该方法会在 Observable 序列开始之前插入一些事件元素。即发出事件消息之前，会先发出这些预先插入的事件消息
         let disposeBag = DisposeBag()
         
         Observable.of("2", "3")
         .startWith("1")
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         插入多个数据也是可以的:
         let disposeBag = DisposeBag()
         
         Observable.of("2", "3")
         .startWith("a")
         .startWith("b")
         .startWith("c")
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:merge:
        /*
         该方法可以将多个（两个或两个以上的）Observable 序列合并成一个 Observable序列
         let disposeBag = DisposeBag()
         
         let subject1 = PublishSubject<Int>()
         let subject2 = PublishSubject<Int>()
         
         Observable.of(subject1, subject2)
         .merge()
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject1.onNext(20)
         subject1.onNext(40)
         subject1.onNext(60)
         subject2.onNext(1)
         subject1.onNext(80)
         subject1.onNext(100)
         subject2.onNext(1)
         */
        
        // TODO:zip:
        /*
         该方法可以将多个（两个或两个以上的）Observable 序列压缩成一个 Observable 序列。
         而且它会等到每个 Observable 事件一一对应地凑齐之后再合并
         let disposeBag = DisposeBag()
         
         let subject1 = PublishSubject<Int>()
         let subject2 = PublishSubject<String>()
         
         Observable.zip(subject1, subject2) {
         "\($0)\($1)"
         }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject1.onNext(1)
         subject2.onNext("A")
         subject1.onNext(2)
         subject2.onNext("B")
         subject2.onNext("C")
         subject2.onNext("D")
         subject1.onNext(3)
         subject1.onNext(4)
         subject1.onNext(5)
         */
        
        // TODO:combineLatest:
        /*
         该方法同样是将多个（两个或两个以上的）Observable 序列元素进行合并。
         但与 zip 不同的是，每当任意一个 Observable 有新的事件发出时，它会将每个 Observable 序列的最新的一个事件元素进行合并。
         let disposeBag = DisposeBag()
         
         let subject1 = PublishSubject<Int>()
         let subject2 = PublishSubject<String>()
         
         Observable.combineLatest(subject1, subject2) {
         "\($0)\($1)"
         }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject1.onNext(1)
         subject2.onNext("A")
         subject1.onNext(2)
         subject2.onNext("B")
         subject2.onNext("C")
         subject2.onNext("D")
         subject1.onNext(3)
         subject1.onNext(4)
         subject1.onNext(5)
         */
        
        // TODO:withLatestFrom:
        /*
         该方法将两个 Observable 序列合并为一个。每当 self 队列发射一个元素时，便从第二个序列中取出最新的一个值
         let disposeBag = DisposeBag()
         
         let subject1 = PublishSubject<String>()
         let subject2 = PublishSubject<String>()
         
         subject1.withLatestFrom(subject2)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject1.onNext("A")
         subject2.onNext("1")
         subject1.onNext("B")
         subject1.onNext("C")
         subject2.onNext("2")
         subject1.onNext("D")
         */
        
        // TODO:switchLatest:
        /*
         switchLatest 有点像其他语言的switch 方法，可以对事件流进行转换。
         比如本来监听的 subject1，我可以通过更改 variable 里面的 value 更换事件源。变成监听 subject2
         let disposeBag = DisposeBag()
         
         let subject1 = BehaviorSubject(value: "A")
         let subject2 = BehaviorSubject(value: "1")
         
         let variable = Variable(subject1)
         
         variable.asObservable()
         .switchLatest()
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject1.onNext("B")
         subject1.onNext("C")
         
         //改变事件源
         variable.value = subject2
         subject1.onNext("D")
         subject2.onNext("2")
         
         //改变事件源
         variable.value = subject1
         subject2.onNext("3")
         subject1.onNext("E")
         */
        
        // TODO:===算数、以及聚合操作（Mathematical and Aggregate Operators）===
        // TODO:toArray:
        /*
         该操作符先把一个序列转成一个数组，并作为一个单一的事件发送，然后结束
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3)
         .toArray()
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:reduce:
        /*
         reduce 接受一个初始值，和一个操作符号。
         reduce 将给定的初始值，与序列里的每个值进行累计运算。得到一个最终结果，并将其作为单个值发送出去
         let disposeBag = DisposeBag()
         
         Observable.of(1, 2, 3, 4, 5)
         .reduce(0, accumulator: +)
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:concat:
        /*
         concat 会把多个 Observable 序列合并（串联）为一个 Observable 序列。
         并且只有当前面一个 Observable 序列发出了 completed 事件，才会开始发送下一个  Observable 序列事件
         let disposeBag = DisposeBag()
         
         let subject1 = BehaviorSubject(value: 1)
         let subject2 = BehaviorSubject(value: 2)
         
         let variable = Variable(subject1)
         variable.asObservable()
         .concat()
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         subject2.onNext(2)
         subject1.onNext(1)
         subject1.onNext(1)
         subject1.onCompleted()
         
         variable.value = subject2
         subject2.onNext(2)
         */
        
        // TODO:===连接操作（Connectable Observable Operators）===
        /*
         可连接的序列（Connectable Observable）：
         （1）可连接的序列和一般序列不同在于：有订阅时不会立刻开始发送事件消息，只有当调用 connect()之后才会开始发送值。
         （2）##可连接的序列可以让所有的订阅者订阅后，才开始发出事件消息，从而保证我们想要的所有订阅者都能接收到事件消息##
         */
        
        // TODO:publish:
        /*
         publish 方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始
         //每隔1秒钟发送1个事件
         let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         .publish()
         
         //第一个订阅者（立刻开始订阅）
         _ = interval
         .subscribe(onNext: { print("订阅1: \($0)") })
         
         //相当于把事件消息推迟了两秒
         delay(2) {
         _ = interval.connect()
         }
         
         //第二个订阅者（延迟5秒开始订阅）
         delay(5) {
         _ = interval
         .subscribe(onNext: { print("订阅2: \($0)") })
         }
         */
        
        // TODO:replay:
        /*
         replay 同上面的 publish 方法相同之处在于：会将将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
         
         replay 与 publish 不同在于：新的订阅者还能接收到订阅之前的事件消息（数量由设置的 bufferSize 决定）
         
         //每隔1秒钟发送1个事件
         let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         .replay(5)
         
         //第一个订阅者（立刻开始订阅）
         _ = interval
         .subscribe(onNext: { print("订阅1: \($0)") })
         
         //相当于把事件消息推迟了两秒
         delay(2) {
         _ = interval.connect()
         }
         
         //第二个订阅者（延迟5秒开始订阅）
         delay(5) {
         _ = interval
         .subscribe(onNext: { print("订阅2: \($0)") })
         }
         */
        
        // TODO:multicast:
        /*
         multicast 方法同样是将一个正常的序列转换成一个可连接的序列。
         同时 multicast 方法还可以传入一个 Subject，每当序列发送事件时都会触发这个 Subject 的发送
         //创建一个Subject（后面的multicast()方法中传入）
         let subject = PublishSubject<Int>()
         
         //这个Subject的订阅
         _ = subject
         .subscribe(onNext: { print("Subject: \($0)") })
         
         //每隔1秒钟发送1个事件
         let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         .multicast(subject)
         
         //第一个订阅者（立刻开始订阅）
         _ = interval
         .subscribe(onNext: { print("订阅1: \($0)") })
         
         //相当于把事件消息推迟了两秒
         delay(2) {
         _ = interval.connect()
         }
         
         //第二个订阅者（延迟5秒开始订阅）
         delay(5) {
         _ = interval
         .subscribe(onNext: { print("订阅2: \($0)") })
         }
         */
        
        // TODO:refCount:
        /*
         refCount 操作符可以将可被连接的 Observable 转换为普通 Observable
         
         即该操作符可以自动连接和断开可连接的 Observable。当第一个观察者对可连接的Observable 订阅时，那么底层的 Observable 将被自动连接。当最后一个观察者离开时，那么底层的 Observable 将被自动断开连接
         //每隔1秒钟发送1个事件
         let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         .publish()
         .refCount()
         
         //第一个订阅者（立刻开始订阅）
         _ = interval
         .subscribe(onNext: { print("订阅1: \($0)") })
         
         //第二个订阅者（延迟5秒开始订阅）
         delay(5) {
         _ = interval
         .subscribe(onNext: { print("订阅2: \($0)") })
         }
         */
        
        // TODO:share(relay:):
        /*
         shareReplay 会返回一个新的事件序列，它监听底层序列的事件
         该操作符将使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者。
         简单来说 shareReplay 就是 replay 和 refCount 的组合
         class ViewController: UIViewController {
         override func viewDidLoad() {
         
         //每隔1秒钟发送1个事件
         let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         .share(replay: 5)
         
         //第一个订阅者（立刻开始订阅）
         _ = interval
         .subscribe(onNext: { print("订阅1: \($0)") })
         
         //第二个订阅者（延迟5秒开始订阅）
         delay(5) {
         _ = interval
         .subscribe(onNext: { print("订阅2: \($0)") })
         }
         }
         }
         */
        
        // TODO:===特征序列：Single、Completable、Maybe===
        // 特征序列（Traits）：Single、Completable、Maybe、Driver、ControlEvent
        // TODO:Single:
        /*
         Single 是 Observable 的另外一个版本
         
         它要么只能发出一个元素，要么产生一个 error 事件
         Single 比较常见的例子就是执行 HTTP 请求，然后返回一个应答或错误
         不过我们也可以用 Single 来描述任何只有一个元素的序列
         RxSwift 还为 Single 订阅提供了一个枚举（SingleEvent）：
         .success：里面包含该Single的一个元素值
         .error：用于包含错误
         
         //获取豆瓣某频道下的歌曲信息
         func getPlaylist(_ channel: String) -> Single<[String: Any]> {
         return Single<[String: Any]>.create { single in
         let url = "https://douban.fm/j/mine/playlist?"
         + "type=n&channel=\(channel)&from=mainsite"
         let task = URLSession.shared.dataTask(with: URL(string: url)!) { data, _, error in
         if let error = error {
         single(.error(error))
         return
         }
         
         guard let data = data,
         let json = try? JSONSerialization.jsonObject(with: data,
         options: .mutableLeaves),
         let result = json as? [String: Any] else {
         single(.error(DataError.cantParseJSON))
         return
         }
         
         single(.success(result))
         }
         
         task.resume()
         
         return Disposables.create { task.cancel() }
         }
         }
         
         //与数据相关的错误类型
         enum DataError: Error {
         case cantParseJSON
         }
         
         class ViewController: UIViewController {
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         //获取第0个频道的歌曲信息
         getPlaylist("0")
         .subscribe { event in
         switch event {
         case .success(let json):
         print("JSON结果: ", json)
         case .error(let error):
         print("发生错误: ", error)
         }
         }
         .disposed(by: disposeBag)
         }
         }
         
         或者:
         
         class ViewController: UIViewController {
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         //获取第0个频道的歌曲信息
         getPlaylist("0")
         .subscribe(onSuccess: { json in
         print("JSON结果: ", json)
         }, onError: { error in
         print("发生错误: ", error)
         })
         .disposed(by: disposeBag)
         }
         }
         
         */
        
        // TODO:asSingle():
        /*
         通过调用 Observable 序列的.asSingle()方法，将它转换为 Single
         let disposeBag = DisposeBag()
         
         Observable.of("1")
         .asSingle()
         .subscribe({ print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:Completable:
        /*
         Completable 是 Observable 的另外一个版本。不像 Observable 可以发出多个元素，它要么只能产生一个 completed 事件，要么产生一个 error 事件
         
         Completable 和 Observable<Void> 有点类似。适用于那些只关心任务是否完成，而不需要在意任务返回值的情况。比如：在程序退出时将一些数据缓存到本地文件，供下次启动时加载。像这种情况我们只关心缓存是否成功
         
         RxSwift 为 Completable 订阅提供了一个枚举（CompletableEvent）：
         
         .completed：用于产生完成事件
         .error：用于产生一个错误
         
         //将数据缓存到本地
         func cacheLocally() -> Completable {
         return Completable.create { completable in
         //将数据缓存到本地（这里掠过具体的业务代码，随机成功或失败）
         let success = (arc4random() % 2 == 0)
         
         guard success else {
         completable(.error(CacheError.failedCaching))
         return Disposables.create {}
         }
         
         completable(.completed)
         return Disposables.create {}
         }
         }
         
         //与缓存相关的错误类型
         enum CacheError: Error {
         case failedCaching
         }
         
         
         cacheLocally()
         .subscribe { completable in
         switch completable {
         case .completed:
         print("保存成功!")
         case .error(let error):
         print("保存失败: \(error.localizedDescription)")
         }
         }
         .disposed(by: disposeBag)
         
         或者
         
         cacheLocally()
         .subscribe(onCompleted: {
         print("保存成功!")
         }, onError: { error in
         print("保存失败: \(error.localizedDescription)")
         })
         .disposed(by: disposeBag)
         */
        
        // TODO:Maybe:
        /*
         Maybe 同样是 Observable 的另外一个版本。它介于 Single 和 Completable 之间，它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件
         Maybe 适合那种可能需要发出一个元素，又可能不需要发出的情况。
         .success：里包含该 Maybe 的一个元素值
         .completed：用于产生完成事件
         .error：用于产生一个错误
         
         func generateString() -> Maybe<String> {
         return Maybe<String>.create { maybe in
         
         //成功并发出一个元素
         maybe(.success("hangge.com"))
         
         //成功但不发出任何元素
         maybe(.completed)
         
         //失败
         //maybe(.error(StringError.failedGenerate))
         
         return Disposables.create {}
         }
         }
         
         //与缓存相关的错误类型
         enum StringError: Error {
         case failedGenerate
         }
         
         generateString()
         .subscribe { maybe in
         switch maybe {
         case .success(let element):
         print("执行完毕，并获得元素：\(element)")
         case .completed:
         print("执行完毕，且没有任何元素。")
         case .error(let error):
         print("执行失败: \(error.localizedDescription)")
         
         }
         }
         .disposed(by: disposeBag)
         
         或者
         
         generateString()
         .subscribe(onSuccess: { element in
         print("执行完毕，并获得元素：\(element)")
         },
         onError: { error in
         print("执行失败: \(error.localizedDescription)")
         },
         onCompleted: {
         print("执行完毕，且没有任何元素。")
         })
         .disposed(by: disposeBag)
         */
        
        // TODO:asMaybe():
        /*
         我们可以通过调用 Observable 序列的 .asMaybe()方法，将它转换为 Maybe。
         let disposeBag = DisposeBag()
         
         Observable.of("1")
         .asMaybe()
         .subscribe({ print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:===特征序列：Driver===
        // Driver、ControlEvent。更准确说，这两个应该算是 RxCocoa traits，因为它们是专门服务于 RxCocoa工程的
        
        // TODO:Driver:
        // Driver 可以说是最复杂的 trait，它的目标是提供一种简便的方式在 UI 层编写响应式代码
        /*
         如果我们的序列满足如下特征，就可以使用它：
         
         不会产生 error 事件
         一定在主线程监听（MainScheduler）
         共享状态变化（shareReplayLatestWhileConnected）
         
         通过 CoreData 模型驱动 UI
         使用一个 UI 元素值（绑定）来驱动另一个 UI 元素值
         
         根据一个输入框的关键字，来请求数据，然后将获取到的结果绑定到另一个 Label 和 TableView 中:
         初学者使用 Observable 序列加 bindTo 绑定来实现这个功能的话可能会这么写：
         let results = query.rx.text
         .throttle(0.3, scheduler: MainScheduler.instance) //在主线程中操作，0.3秒内值若多次改变，取最后一次
         .flatMapLatest { query in //筛选出空值, 拍平序列
         fetchAutoCompleteItems(query) //向服务器请求一组结果
         }
         
         //将返回的结果绑定到用于显示结果数量的label上
         results
         .map { "\($0.count)" }
         .bind(to: resultCount.rx.text)
         .disposed(by: disposeBag)
         
         //将返回的结果绑定到tableView上
         results
         .bind(to: resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
         cell.textLabel?.text = "\(result)"
         }
         .disposed(by: disposeBag)
         
         但这个代码存在如下 3 个问题：
         1.如果 fetchAutoCompleteItems 的序列产生了一个错误（网络请求失败），这个错误将取消所有绑定。此后用户再输入一个新的关键字时，是无法发起新的网络请求
         2.如果 fetchAutoCompleteItems 在后台返回序列，那么刷新页面也会在后台进行，这样就会出现异常崩溃
         3.返回的结果被绑定到两个 UI 元素上。那就意味着，每次用户输入一个新的关键字时，就会分别为两个 UI元素发起 HTTP请求，这并不是我们想要的结果
         
         把上面几个问题修改后的代码是这样的：
         let results = query.rx.text
         .throttle(0.3, scheduler: MainScheduler.instance)//在主线程中操作，0.3秒内值若多次改变，取最后一次
         .flatMapLatest { query in //筛选出空值, 拍平序列
         fetchAutoCompleteItems(query)   //向服务器请求一组结果
         .observeOn(MainScheduler.instance)  //将返回结果切换到到主线程上
         .catchErrorJustReturn([])       //错误被处理了，这样至少不会终止整个序列
         }
         .shareReplay(1)                //HTTP 请求是被共享的
         
         //将返回的结果绑定到显示结果数量的label上
         results
         .map { "\($0.count)" }
         .bind(to: resultCount.rx.text)
         .disposed(by: disposeBag)
         
         //将返回的结果绑定到tableView上
         results
         .bind(to: resultsTableView.rx.items(cellIdentifier: "Cell")) { (_, result, cell) in
         cell.textLabel?.text = "\(result)"
         }
         .disposed(by: disposeBag)
         
         由于 drive 方法只能被 Driver 调用。这意味着，如果代码存在 drive，那么这个序列不会产生错误事件并且一定在主线程监听。这样我们就可以安全的绑定 UI元素
         而如果我们使用 Driver 来实现的话就简单了，代码如下：
         let results = query.rx.text.asDriver()        // 将普通序列转换为 Driver
         .throttle(0.3, scheduler: MainScheduler.instance)
         .flatMapLatest { query in
         fetchAutoCompleteItems(query)
         .asDriver(onErrorJustReturn: [])  // 仅仅提供发生错误时的备选返回值
         }
         
         //将返回的结果绑定到显示结果数量的label上
         results
         .map { "\($0.count)" }
         .drive(resultCount.rx.text) // 这里使用 drive 而不是 bindTo
         .disposed(by: disposeBag)
         
         //将返回的结果绑定到tableView上
         results
         .drive(resultsTableView.rx.items(cellIdentifier: "Cell")) { //  同样使用 drive 而不是 bindTo
         (_, result, cell) in
         cell.textLabel?.text = "\(result)"
         }
         .disposed(by: disposeBag)
         
         
         代码讲解：
         （1）首先我们使用 asDriver 方法将 ControlProperty 转换为 Driver。
         （2）接着我们可以用 .asDriver(onErrorJustReturn: []) 方法将任何 Observable 序列都转成 Driver，因为我们知道序列转换为 Driver 要他满足 3 个条件：
         
         *   不会产生 error 事件
         *   一定在主线程监听（MainScheduler）
         *   共享状态变化（shareReplayLatestWhileConnected）
         
         而 asDriver(onErrorJustReturn: []) 相当于以下代码：
         let safeSequence = xs
         .observeOn(MainScheduler.instance) // 主线程监听
         .catchErrorJustReturn(onErrorJustReturn) // 无法产生错误
         .share(replay: 1, scope: .whileConnected)// 共享状态变化
         return Driver(raw: safeSequence) // 封装
         （3）同时在 Driver 中，框架已经默认帮我们加上了 shareReplayLatestWhileConnected，所以我们也没必要再加上"replay"相关的语句了。
         （4）最后记得使用 drive 而不是 bindTo
         */
        
        // TODO:===其他一些实用的操作符（Observable Utility Operators）===
        // TODO:delay:
        /*
         该操作符会将 Observable 的所有元素都先拖延一段设定好的时间，然后才将它们发送出来
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         Observable.of(1, 2, 1)
         .delay(3, scheduler: MainScheduler.instance) //元素延迟3秒才发出
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:delaySubscription:
        /*
         使用该操作符可以进行延时订阅。即经过所设定的时间后，才对 Observable 进行订阅操作
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         Observable.of(1, 2, 1)
         .delaySubscription(3, scheduler: MainScheduler.instance) //延迟3秒才开始订阅
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:materialize:
        /*
         该操作符可以将序列产生的事件，转换成元素。
         通常一个有限的 Observable 将产生零个或者多个 onNext 事件，最后产生一个 onCompleted 或者onError事件。而 materialize 操作符会将 Observable 产生的这些事件全部转换成元素，然后发送出来
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         Observable.of(1, 2, 1)
         .materialize()
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:dematerialize:
        /*
         该操作符的作用和 materialize 正好相反，它可以将 materialize 转换后的元素还原
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         Observable.of(1, 2, 1)
         .materialize()
         .dematerialize()
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:timeout:
        /*
         使用该操作符可以设置一个超时时间。如果源 Observable 在规定时间内没有发任何出元素，就产生一个超时的 error 事件
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //定义好每个事件里的值以及发送的时间
         let times = [
         [ "value": 1, "time": 0 ],
         [ "value": 2, "time": 0.5 ],
         [ "value": 3, "time": 1.5 ],
         [ "value": 4, "time": 4 ],
         [ "value": 5, "time": 5 ]
         ]
         
         //生成对应的 Observable 序列并订阅
         Observable.from(times)
         .flatMap { item in
         return Observable.of(Int(item["value"]!))
         .delaySubscription(Double(item["time"]!),
         scheduler: MainScheduler.instance)
         }
         .timeout(2, scheduler: MainScheduler.instance) //超过两秒没发出元素，则产生error事件
         .subscribe(onNext: { element in
         print(element)
         }, onError: { error in
         print(error)
         })
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:using:
        /*
         使用 using 操作符创建 Observable 时，同时会创建一个可被清除的资源，一旦 Observable终止了，那么这个资源就会被清除掉了
         class ViewController: UIViewController {
         
         override func viewDidLoad() {
         
         //一个无限序列（每隔0.1秒创建一个序列数 ）
         let infiniteInterval$ = Observable<Int>
         .interval(0.1, scheduler: MainScheduler.instance)
         .do(
         onNext: { print("infinite$: \($0)") },
         onSubscribe: { print("开始订阅 infinite$")},
         onDispose: { print("销毁 infinite$")}
         )
         
         //一个有限序列（每隔0.5秒创建一个序列数，共创建三个 ）
         let limited$ = Observable<Int>
         .interval(0.5, scheduler: MainScheduler.instance)
         .take(2)
         .do(
         onNext: { print("limited$: \($0)") },
         onSubscribe: { print("开始订阅 limited$")},
         onDispose: { print("销毁 limited$")}
         )
         
         //使用using操作符创建序列
         let o: Observable<Int> = Observable.using({ () -> AnyDisposable in
         return AnyDisposable(infiniteInterval$.subscribe())
         }, observableFactory: { _ in return limited$ }
         )
         o.subscribe()
         }
         }
         
         class AnyDisposable: Disposable {
         let _dispose: () -> Void
         
         init(_ disposable: Disposable) {
         _dispose = disposable.dispose
         }
         
         func dispose() {
         _dispose()
         }
         }
         */
        
        // TODO:===错误处理操作（Error Handling Operators）===
        // 错误处理操作符可以用来帮助我们对 Observable 发出的 error 事件做出响应，或者从错误中恢复
        /*
         enum MyError: Error {
         case A
         case B
         }
         */
        
        // TODO:catchErrorJustReturn:
        /*
         当遇到 error 事件的时候，就返回指定的值，然后结束
         let disposeBag = DisposeBag()
         
         let sequenceThatFails = PublishSubject<String>()
         
         sequenceThatFails
         .catchErrorJustReturn("错误")
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         sequenceThatFails.onNext("a")
         sequenceThatFails.onNext("b")
         sequenceThatFails.onNext("c")
         sequenceThatFails.onError(MyError.A)
         sequenceThatFails.onNext("d") // 不执行
         */
        
        // TODO:catchError:
        /*
         该方法可以捕获 error，并对其进行处理。
         同时还能返回另一个 Observable 序列进行订阅（切换到新的序列）
         
         let disposeBag = DisposeBag()
         
         let sequenceThatFails = PublishSubject<String>()
         let recoverySequence = Observable.of("1", "2", "3")
         
         sequenceThatFails
         .catchError {
         print("Error:", $0)
         return recoverySequence
         }
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         sequenceThatFails.onNext("a")
         sequenceThatFails.onNext("b")
         sequenceThatFails.onNext("c")
         sequenceThatFails.onError(MyError.A)
         sequenceThatFails.onNext("d")
         */
        
        // TODO:retry:
        /*
         使用该方法当遇到错误的时候，会重新订阅该序列。比如遇到网络请求失败时，可以进行重新连接
         retry() 方法可以传入数字表示重试次数。不传的话只会重试一次
         
         let disposeBag = DisposeBag()
         var count = 1
         
         let sequenceThatErrors = Observable<String>.create { observer in
         observer.onNext("a")
         observer.onNext("b")
         
         //让第一个订阅时发生错误
         if count == 1 {
         observer.onError(MyError.A)
         print("Error encountered")
         count += 1
         }
         
         observer.onNext("c")
         observer.onNext("d")
         observer.onCompleted()
         
         return Disposables.create()
         }
         
         sequenceThatErrors
         .retry(2)  //重试2次（参数为空则只重试一次）
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:===调试操作===
        // TODO:debug:
        /*
         我们可以将 debug 调试操作符添加到一个链式步骤当中，这样系统就能将所有的订阅者、事件、和处理等详细信息打印出来，方便我们开发调试
         let disposeBag = DisposeBag()
         
         Observable.of("2", "3")
         .startWith("1")
         .debug()
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         
         debug() 方法还可以传入标记参数，这样当项目中存在多个 debug 时可以很方便地区分出来。
         let disposeBag = DisposeBag()
         
         Observable.of("2", "3")
         .startWith("1")
         .debug("调试1")
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         */
        
        // TODO:RxSwift.Resources.total:
        /*
         通过将 RxSwift.Resources.total 打印出来，我们可以查看当前 RxSwift 申请的所有资源数量。这个在检查内存泄露的时候非常有用
         print(RxSwift.Resources.total)
         
         let disposeBag = DisposeBag()
         
         print(RxSwift.Resources.total)
         
         Observable.of("BBB", "CCC")
         .startWith("AAA")
         .subscribe(onNext: { print($0) })
         .disposed(by: disposeBag)
         
         print(RxSwift.Resources.total)
         */
        
        // TODO:==============================UI==============================
        // TODO:===UI控件扩展：UILabel===
        /*
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //创建文本标签
         let label = UILabel(frame:CGRect(x:20, y:40, width:300, height:100))
         self.view.addSubview(label)
         
         //创建一个计时器（每0.1秒发送一个索引数）
         let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
         
         //将已过去的时间格式化成想要的字符串，并绑定到label上
         timer.map{ String(format: "%0.2d:%0.2d.%0.1d",
         arguments: [($0 / 600) % 600, ($0 % 600 ) / 10, $0 % 10]) }
         .bind(to: label.rx.text)
         .disposed(by: disposeBag)
         }
         }
         
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //创建文本标签
         let label = UILabel(frame:CGRect(x:20, y:40, width:300, height:100))
         self.view.addSubview(label)
         
         //创建一个计时器（每0.1秒发送一个索引数）
         let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
         
         //将已过去的时间格式化成想要的字符串，并绑定到label上
         timer.map(formatTimeInterval)
         .bind(to: label.rx.attributedText)
         .disposed(by: disposeBag)
         }
         
         //将数字转成对应的富文本
         func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
         let string = String(format: "%0.2d:%0.2d.%0.1d",
         arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
         //富文本设置
         let attributeString = NSMutableAttributedString(string: string)
         //从文本0开始6个字符字体HelveticaNeue-Bold,16号
         attributeString.addAttribute(NSAttributedStringKey.font,
         value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
         range: NSMakeRange(0, 5))
         //设置字体颜色
         attributeString.addAttribute(NSAttributedStringKey.foregroundColor,
         value: UIColor.white, range: NSMakeRange(0, 5))
         //设置文字背景颜色
         attributeString.addAttribute(NSAttributedStringKey.backgroundColor,
         value: UIColor.orange, range: NSMakeRange(0, 5))
         return attributeString
         }
         }
         */
        
        // TODO:===UI控件扩展：UITextField、UITextView===
        /*
         监听单个 textField 内容的变化:
         .orEmpty 可以将 String? 类型的 ControlProperty 转成 String，省得我们再去解包
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         
         //创建文本输入框
         let textField = UITextField(frame: CGRect(x:10, y:80, width:200, height:30))
         textField.borderStyle = UITextBorderStyle.roundedRect
         self.view.addSubview(textField)
         
         //当文本框内容改变时，将内容输出到控制台上
         textField.rx.text.orEmpty.asObservable()
         .subscribe(onNext: {
         print("您输入的是：\($0)")
         })
         .disposed(by: disposeBag)
         }
         }
         
         当然我们直接使用 change 事件效果也是一样的。
         //当文本框内容改变时，将内容输出到控制台上
         textField.rx.text.orEmpty.changed
         .subscribe(onNext: {
         print("您输入的是：\($0)")
         })
         .disposed(by: disposeBag)
         
         将内容绑定到其他控件上:
         Throttling 是 RxSwift 的一个特性。因为有时当一些东西改变时，通常会做大量的逻辑操作。而使用 Throttling 特性，不会产生大量的逻辑操作，而是以一个小的合理的幅度去执行。比如做一些实时搜索功能时，这个特性很有用
         
         //当文本框内容改变
         let input = inputField.rx.text.orEmpty.asDriver() // 将普通序列转换为 Driver
         .throttle(0.3) //在主线程中操作，0.3秒内值若多次改变，取最后一次
         
         //内容绑定到另一个输入框中
         input.drive(outputField.rx.text)
         .disposed(by: disposeBag)
         
         //内容绑定到文本标签中
         input.map{ "当前字数：\($0.count)" }
         .drive(label.rx.text)
         .disposed(by: disposeBag)
         
         //根据内容字数决定按钮是否可用
         input.map{ $0.count > 5 }
         .drive(button.rx.isEnabled)
         .disposed(by: disposeBag)
         
         同时监听多个 textField 内容的变化:
         Observable.combineLatest(textField1.rx.text.orEmpty, textField2.rx.text.orEmpty) {
         textValue1, textValue2 -> String in
         return "你输入的号码是：\(textValue1)-\(textValue2)"
         }
         .map { $0 }
         .bind(to: label.rx.text)
         .disposed(by: disposeBag)
         
         事件监听:
         通过 rx.controlEvent 可以监听输入框的各种事件，且多个事件状态可以自由组合。除了各种 UI 控件都有的 touch 事件外，输入框还有如下几个独有的事件：
         
         editingDidBegin：开始编辑（开始输入内容）
         editingChanged：输入内容发生改变
         editingDidEnd：结束编辑
         editingDidEndOnExit：按下 return 键结束编辑
         allEditingEvents：包含前面的所有编辑相关事件
         
         textField.rx.controlEvent([.editingDidBegin]) //状态可以组合
         .asObservable()
         .subscribe(onNext: { _ in
         print("开始编辑内容!")
         }).disposed(by: disposeBag)
         
         
         
         class ViewController: UIViewController {
         
         //用户名输入框
         @IBOutlet weak var username: UITextField!
         
         //密码输入框
         @IBOutlet weak var password: UITextField!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //在用户名输入框中按下 return 键
         username.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
         [weak self] (_) in
         self?.password.becomeFirstResponder()
         }).disposed(by: disposeBag)
         
         //在密码输入框中按下 return 键
         password.rx.controlEvent(.editingDidEndOnExit).subscribe(onNext: {
         [weak self] (_) in
         self?.password.resignFirstResponder()
         }).disposed(by: disposeBag)
         }
         }
        */
        
        // TODO:UITextView 独有的方法:
        /*
         didBeginEditing：开始编辑
         didEndEditing：结束编辑
         didChange：编辑内容发生改变
         didChangeSelection：选中部分发生变化
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         @IBOutlet weak var textView: UITextView!
         
         override func viewDidLoad() {
         
         //开始编辑响应
         textView.rx.didBeginEditing
         .subscribe(onNext: {
         print("开始编辑")
         })
         .disposed(by: disposeBag)
         
         //结束编辑响应
         textView.rx.didEndEditing
         .subscribe(onNext: {
         print("结束编辑")
         })
         .disposed(by: disposeBag)
         
         //内容发生变化响应
         textView.rx.didChange
         .subscribe(onNext: {
         print("内容发生改变")
         })
         .disposed(by: disposeBag)
         
         //选中部分变化响应
         textView.rx.didChangeSelection
         .subscribe(onNext: {
         print("选中部分发生变化")
         })
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===UIButton、UIBarButtonItem===
        // TODO:按钮点击响应:
        /*
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         @IBOutlet weak var button: UIButton!
         
         override func viewDidLoad() {
         //按钮点击响应
         button.rx.tap
         .subscribe(onNext: { [weak self] in
         self?.showMessage("按钮被点击")
         })
         .disposed(by: disposeBag)
         }
         
         //显示消息提示框
         func showMessage(_ text: String) {
         let alertController = UIAlertController(title: text, message: nil, preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
         }
         }
         
         或者
         
         button.rx.tap
         .bind { [weak self] in
         self?.showMessage("按钮被点击")
         }
         .disposed(by: disposeBag)
         */
        
        // TODO:按钮标题（title）的绑定:
        /*
         //创建一个计时器（每1秒发送一个索引数）
         let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         
         //根据索引数拼接最新的标题，并绑定到button上
         timer.map{"计数\($0)"}
         .bind(to: button.rx.title(for: .normal))
         .disposed(by: disposeBag)
         */
        
        // TODO:按钮富文本标题（attributedTitle）的绑定:
        /*
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         @IBOutlet weak var button: UIButton!
         
         override func viewDidLoad() {
         //创建一个计时器（每1秒发送一个索引数）
         let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         
         //将已过去的时间格式化成想要的字符串，并绑定到button上
         timer.map(formatTimeInterval)
         .bind(to: button.rx.attributedTitle())
         .disposed(by: disposeBag)
         }
         
         //将数字转成对应的富文本
         func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
         let string = String(format: "%0.2d:%0.2d.%0.1d",
         arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
         //富文本设置
         let attributeString = NSMutableAttributedString(string: string)
         //从文本0开始6个字符字体HelveticaNeue-Bold,16号
         attributeString.addAttribute(NSAttributedStringKey.font,
         value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
         range: NSMakeRange(0, 5))
         //设置字体颜色
         attributeString.addAttribute(NSAttributedStringKey.foregroundColor,
         value: UIColor.white, range: NSMakeRange(0, 5))
         //设置文字背景颜色
         attributeString.addAttribute(NSAttributedStringKey.backgroundColor,
         value: UIColor.orange, range: NSMakeRange(0, 5))
         return attributeString
         }
         }
         */
        
        // TODO:按钮图标（image）的绑定:
        /*
         let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         
         //根据索引数选择对应的按钮图标，并绑定到button上
         timer.map({
         let name = $0%2 == 0 ? "back" : "forward"
         return UIImage(named: name)!
         })
         .bind(to: button.rx.image())
         .disposed(by: disposeBag)
         */
        
        // TODO:按钮背景图片（backgroundImage）的绑定:
        /*
         //创建一个计时器（每1秒发送一个索引数）
         let timer = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         
         //根据索引数选择对应的按钮背景图，并绑定到button上
         timer.map{ UIImage(named: "\($0%2)")! }
         .bind(to: button.rx.backgroundImage())
         .disposed(by: disposeBag)
         */
        
        // TODO:按钮是否可用（isEnabled）的绑定:
        /*
         switch1.rx.isOn
         .bind(to: button1.rx.isEnabled)
         .disposed(by: disposeBag)
         */
        
        // TODO:按钮是否选中（isSelected）的绑定:
        /*
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         @IBOutlet weak var button1: UIButton!
         
         @IBOutlet weak var button2: UIButton!
         
         @IBOutlet weak var button3: UIButton!
         
         override func viewDidLoad() {
         //默认选中第一个按钮
         button1.isSelected = true
         
         //强制解包，避免后面还需要处理可选类型
         let buttons = [button1, button2, button3].map { $0! }
         
         //创建一个可观察序列，它可以发送最后一次点击的按钮（也就是我们需要选中的按钮）
         let selectedButton = Observable.from(
         buttons.map { button in button.rx.tap.map { button } }
         ).merge()
         
         //对于每一个按钮都对selectedButton进行订阅，根据它是否是当前选中的按钮绑定isSelected属性
         for button in buttons {
         selectedButton.map { $0 == button }
         .bind(to: button.rx.isSelected)
         .disposed(by: disposeBag)
         }
         }
         }
         */
        
        // TODO:===UISwitch、UISegmentedControl===
        /*
         switch1.rx.isOn.asObservable()
         .subscribe(onNext: {
         print("当前开关状态：\($0)")
         })
         .disposed(by: disposeBag)
         
         switch1.rx.isOn
         .bind(to: button1.rx.isEnabled)
         .disposed(by: disposeBag)
         
         segmented.rx.selectedSegmentIndex.asObservable()
         .subscribe(onNext: {
         print("当前项：\($0)")
         })
         .disposed(by: disposeBag)
         
         
         class ViewController: UIViewController {
         
         //分段选择控件
         @IBOutlet weak var segmented: UISegmentedControl!
         //图片显示控件
         @IBOutlet weak var imageView: UIImageView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         //创建一个当前需要显示的图片的可观察序列
         let showImageObservable: Observable<UIImage> =
         segmented.rx.selectedSegmentIndex.asObservable().map {
         let images = ["js.png", "php.png", "react.png"]
         return UIImage(named: images[$0])!
         }
         
         //把需要显示的图片绑定到 imageView 上
         showImageObservable.bind(to: imageView.rx.image)
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===UIActivityIndicatorView、UIApplication===
        /*
         mySwitch.rx.value
         .bind(to: activityIndicator.rx.isAnimating)
         .disposed(by: disposeBag)
         
         mySwitch.rx.value
         .bind(to: UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
         .disposed(by: disposeBag)
         */
        
        // TODO:===UISlider、UIStepper===
        // TODO:UISlider（滑块）:
        /*
         class ViewController: UIViewController {
         
         @IBOutlet weak var slider: UISlider!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         slider.rx.value.asObservable()
         .subscribe(onNext: {
         print("当前值为：\($0)")
         })
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:UIStepper（步进器）:
        /*
         stepper.rx.value.asObservable()
         .subscribe(onNext: {
         print("当前值为：\($0)")
         })
         .disposed(by: disposeBag)
         */
        
        /*
         slider.rx.value
         .map{ Double($0) }  //由于slider值为Float类型，而stepper的stepValue为Double类型，因此需要转换
         .bind(to: stepper.rx.stepValue)
         .disposed(by: disposeBag)
         */
        
        // TODO:===双向绑定：<->===
        /*
         比如将控件的某个属性值与 ViewModel 里的某个 Subject 属性进行双向绑定：
         
         这样当 ViewModel 里的值发生改变时，可以同步反映到控件上。
         而如果对控件值做修改，ViewModel 那边值同时也会发生变化
         
         struct UserViewModel {
         //用户名
         let username = Variable("guest")
         
         //用户信息
         lazy var userinfo = {
         return self.username.asObservable()
         .map{ $0 == "hangge" ? "您是管理员" : "您是普通访客" }
         .share(replay: 1)
         }()
         }
         
         
         class ViewController: UIViewController {
         
         @IBOutlet weak var textField: UITextField!
         
         @IBOutlet weak var label: UILabel!
         
         var userVM = UserViewModel()
         
         let disposeBag = DisposeBag()
         
         
         override func viewDidLoad() {
         //将用户名与textField做双向绑定
         userVM.username.asObservable().bind(to: textField.rx.text).disposed(by: disposeBag)
         textField.rx.text.orEmpty.bind(to: userVM.username).disposed(by: disposeBag)
         
         //将用户信息绑定到label上
         userVM.userinfo.bind(to: label.rx.text).disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:自定义双向绑定操作符（operator）:
        /*
         RxSwift 自带的双向绑定操作符
         
         好在 RxSwift 项目文件夹中已经有个现成的（Operators.swift），我们将它复制到我们项目中即可使用。当然如我们想自己写一些其它的双向绑定 operator 也可以参考它
         
         class ViewController: UIViewController {
         
         @IBOutlet weak var textField: UITextField!
         
         @IBOutlet weak var label: UILabel!
         
         var userVM = UserViewModel()
         
         let disposeBag = DisposeBag()
         
         
         override func viewDidLoad() {
         //将用户名与textField做双向绑定
         _ =  self.textField.rx.textInput <->  self.userVM.username
         
         //将用户信息绑定到label上
         userVM.userinfo.bind(to: label.rx.text).disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===UIGestureRecognizer==
        /*
         class ViewController: UIViewController {
         
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //添加一个上滑手势
         let swipe = UISwipeGestureRecognizer()
         swipe.direction = .up
         self.view.addGestureRecognizer(swipe)
         
         //手势响应
         swipe.rx.event
         .subscribe(onNext: { [weak self] recognizer in
         //这个点是滑动的起点
         let point = recognizer.location(in: recognizer.view)
         self?.showAlert(title: "向上划动", message: "\(point.x) \(point.y)")
         })
         .disposed(by: disposeBag)
         }
         
         //显示消息提示框
         func showAlert(title: String, message: String) {
         let alert = UIAlertController(title: title, message: message,
         preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "确定", style: .cancel))
         self.present(alert, animated: true)
         }
         }
         
         或者
         
         class ViewController: UIViewController {
         
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //添加一个上滑手势
         let swipe = UISwipeGestureRecognizer()
         swipe.direction = .up
         self.view.addGestureRecognizer(swipe)
         
         //手势响应
         swipe.rx.event
         .bind { [weak self] recognizer in
         //这个点是滑动的起点
         let point = recognizer.location(in: recognizer.view)
         self?.showAlert(title: "向上划动", message: "\(point.x) \(point.y)")
         }
         .disposed(by: disposeBag)
         }
         
         //显示消息提示框
         func showAlert(title: String, message: String) {
         let alert = UIAlertController(title: title, message: message,
         preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "确定", style: .cancel))
         self.present(alert, animated: true)
         }
         }
         */
        
        // TODO:===UIDatePicker===
        /*
         class ViewController: UIViewController {
         
         @IBOutlet weak var datePicker: UIDatePicker!
         
         @IBOutlet weak var label: UILabel!
         
         //日期格式化器
         lazy var dateFormatter: DateFormatter = {
         let formatter = DateFormatter()
         formatter.dateFormat = "yyyy年MM月dd日 HH:mm"
         return formatter
         }()
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         datePicker.rx.date
         .map { [weak self] in
         "当前选择时间: " + self!.dateFormatter.string(from: $0)
         }
         .bind(to: label.rx.text)
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===UITableView===
        /*
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //初始化数据
         let items = Observable.just([
         "文本输入框的用法",
         "开关按钮的用法",
         "进度条的用法",
         "文本标签的用法",
         ])
         
         //设置单元格数据（其实就是对 cellForRowAt 的封装）
         items
         .bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(row)：\(element)"
         return cell
         }
         .disposed(by: disposeBag)
         }
         }
         
         单元格选中事件响应:
         //获取选中项的索引
         tableView.rx.itemSelected.subscribe(onNext: { indexPath in
         print("选中项的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         
         //获取选中项的内容
         tableView.rx.modelSelected(String.self).subscribe(onNext: { item in
         print("选中项的标题为：\(item)")
         }).disposed(by: disposeBag)
         
         //获取选中项的索引
         tableView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
         self?.showMessage("选中项的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         
         //获取选中项的内容
         tableView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] item in
         self?.showMessage("选中项的标题为：\(item)")
         }).disposed(by: disposeBag)
         
         单元格取消选中事件响应:
         //获取被取消选中项的索引
         tableView.rx.itemDeselected.subscribe(onNext: { [weak self] indexPath in
         self?.showMessage("被取消选中项的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         
         //获取被取消选中项的内容
         tableView.rx.modelDeselected(String.self).subscribe(onNext: {[weak self] item in
         self?.showMessage("被取消选中项的的标题为：\(item)")
         }).disposed(by: disposeBag)
         
         单元格删除事件响应:
         //获取删除项的索引
         tableView.rx.itemDeleted.subscribe(onNext: { [weak self] indexPath in
         self?.showMessage("删除项的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         
         //获取删除项的内容
         tableView.rx.modelDeleted(String.self).subscribe(onNext: {[weak self] item in
         self?.showMessage("删除项的的标题为：\(item)")
         }).disposed(by: disposeBag)
         
         单元格移动事件响应:
         //获取移动项的索引
         tableView.rx.itemMoved.subscribe(onNext: { [weak self]
         sourceIndexPath, destinationIndexPath in
         self?.showMessage("移动项原来的indexPath为：\(sourceIndexPath)")
         self?.showMessage("移动项现在的indexPath为：\(destinationIndexPath)")
         }).disposed(by: disposeBag)
         
         单元格插入事件响应:
         //获取插入项的索引
         tableView.rx.itemInserted.subscribe(onNext: { [weak self] indexPath in
         self?.showMessage("插入项的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         
         单元格尾部附件（图标）点击事件响应:
         //获取点击的尾部图标的索引
         tableView.rx.itemAccessoryButtonTapped.subscribe(onNext: { [weak self] indexPath in
         self?.showMessage("尾部项的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         
         单元格将要显示出来的事件响应:
         //获取选中项的索引
         tableView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
         print("将要显示单元格indexPath为：\(indexPath)")
         print("将要显示单元格cell为：\(cell)\n")
         
         }).disposed(by: disposeBag)
         */
        
        // TODO:===RxDataSources===
        /*
         RxDataSources 是以 section 来做为数据结构的。所以不管我们的 tableView 是单分区还是多分区，在使用 RxDataSources 的过程中，都需要返回一个 section 的数组
         
         使用自带的Section:
         import UIKit
         import RxSwift
         import RxCocoa
         import RxDataSources
         
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //初始化数据
         let items = Observable.just([
         SectionModel(model: "", items: [
         "UILable的用法",
         "UIText的用法",
         "UIButton的用法"
         ])
         ])
         
         //创建数据源
         let dataSource = RxTableViewSectionedReloadDataSource
         <SectionModel<String, String>>(configureCell: {
         (dataSource, tv, indexPath, element) in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(indexPath.row)：\(element)"
         return cell
         })
         
         //绑定单元格数据
         items
         .bind(to: tableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         }
         
         使用自定义的Section:
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //初始化数据
         let sections = Observable.just([
         MySection(header: "", items: [
         "UILable的用法",
         "UIText的用法",
         "UIButton的用法"
         ])
         ])
         
         //创建数据源
         let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
         //设置单元格
         configureCell: { ds, tv, ip, item in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")
         ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
         cell.textLabel?.text = "\(ip.row)：\(item)"
         
         return cell
         })
         
         //绑定单元格数据
         sections
         .bind(to: tableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         }
         
         //自定义Section
         struct MySection {
         var header: String
         var items: [Item]
         }
         
         extension MySection : AnimatableSectionModelType {
         typealias Item = String
         
         var identity: String {
         return header
         }
         
         init(original: MySection, items: [Item]) {
         self = original
         self.items = items
         }
         }
         
         多分区的 UITableView:
         使用自带的Section:
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //初始化数据
         let items = Observable.just([
         SectionModel(model: "基本控件", items: [
         "UILable的用法",
         "UIText的用法",
         "UIButton的用法"
         ]),
         SectionModel(model: "高级控件", items: [
         "UITableView的用法",
         "UICollectionViews的用法"
         ])
         ])
         
         //创建数据源
         let dataSource = RxTableViewSectionedReloadDataSource
         <SectionModel<String, String>>(configureCell: {
         (dataSource, tv, indexPath, element) in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(indexPath.row)：\(element)"
         return cell
         })
         
         //设置分区头标题
         dataSource.titleForHeaderInSection = { ds, index in
         return ds.sectionModels[index].model
         }
         
         //设置分区尾标题
         //dataSource.titleForFooterInSection = { ds, index in
         //    return "footer"
         //}
         
         //绑定单元格数据
         items
         .bind(to: tableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         }
         
         使用自定义的Section:
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //初始化数据
         let sections = Observable.just([
         MySection(header: "基本控件", items: [
         "UILable的用法",
         "UIText的用法",
         "UIButton的用法"
         ]),
         MySection(header: "高级控件", items: [
         "UITableView的用法",
         "UICollectionViews的用法"
         ])
         ])
         
         //创建数据源
         let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
         //设置单元格
         configureCell: { ds, tv, ip, item in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")
         ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
         cell.textLabel?.text = "\(ip.row)：\(item)"
         
         return cell
         },
         //设置分区头标题
         titleForHeaderInSection: { ds, index in
         return ds.sectionModels[index].header
         }
         )
         
         //绑定单元格数据
         sections
         .bind(to: tableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         }
         
         //自定义Section
         struct MySection {
         var header: String
         var items: [Item]
         }
         
         extension MySection : AnimatableSectionModelType {
         typealias Item = String
         
         var identity: String {
         return header
         }
         
         init(original: MySection, items: [Item]) {
         self = original
         self.items = items
         }
         }
         
         数据刷新:
         class ViewController: UIViewController {
         
         //刷新按钮
         @IBOutlet weak var refreshButton: UIBarButtonItem!
         
         //表格
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self,
         forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
         .startWith(()) //加这个为了让一开始就能自动请求一次数据
         .flatMapLatest(getRandomResult)// flatMapLatest 的作用是当在短时间内（上一个请求还没回来）连续点击多次“刷新”按钮，虽然仍会发起多次请求，但表格只会接收并显示最后一次请求。避免表格出现连续刷新的现象
         .share(replay: 1)
         
         //创建数据源
         let dataSource = RxTableViewSectionedReloadDataSource
         <SectionModel<String, Int>>(configureCell: {
         (dataSource, tv, indexPath, element) in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
         return cell
         })
         
         //绑定单元格数据
         randomResult
         .bind(to: tableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         
         //获取随机数据
         func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
         print("正在请求数据......")
         let items = (0 ..< 5).map {_ in
         Int(arc4random())
         }
         let observable = Observable.just([SectionModel(model: "S", items: items)])
         return observable.delay(2, scheduler: MainScheduler.instance)
         }
         }
         
         防止表格多次刷新:
         即通过 throttle 设置个阀值（比如 1 秒），如果在1秒内有多次点击则只取最后一次，那么自然也就只发送一次数据请求。
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
         .throttle(1, scheduler: MainScheduler.instance) //在主线程中操作，1秒内值若多次改变，取最后一次
         .startWith(()) //加这个为了让一开始就能自动请求一次数据
         .flatMapLatest(getRandomResult)
         .share(replay: 1)
         
         停止数据请求:
         这里我们在前面样例的基础上增加了个“停止”按钮。当发起请求且数据还未返回时（2 秒内），按下该按钮后便会停止对结果的接收处理，即表格不加载显示这次的请求数据
         该功能简单说就是通过 takeUntil 操作符实现。当 takeUntil 中的 Observable 发送一个值时，便会结束对应的 Observable
         class ViewController: UIViewController {
         
         //刷新按钮
         @IBOutlet weak var refreshButton: UIBarButtonItem!
         
         //停止按钮
         @IBOutlet weak var cancelButton: UIBarButtonItem!
         
         //表格
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self,
         forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
         .startWith(()) //加这个为了让一开始就能自动请求一次数据
         .flatMapLatest{
         self.getRandomResult().takeUntil(self.cancelButton.rx.tap)
         }
         .share(replay: 1)
         
         //创建数据源
         let dataSource = RxTableViewSectionedReloadDataSource
         <SectionModel<String, Int>>(configureCell: {
         (dataSource, tv, indexPath, element) in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
         return cell
         })
         
         //绑定单元格数据
         randomResult
         .bind(to: tableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         
         //获取随机数据
         func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
         print("正在请求数据......")
         let items = (0 ..< 5).map {_ in
         Int(arc4random())
         }
         let observable = Observable.just([SectionModel(model: "S", items: items)])
         return observable.delay(2, scheduler: MainScheduler.instance)
         }
         }
         */
        
        // TODO:表格数据的搜索过滤:
        /*
         数据搜索过滤:
         这个实时搜索是对已获取到的数据进行过滤，即每次输入文字时不会重新发起请求
         
         class ViewController: UIViewController {
         
         //刷新按钮
         @IBOutlet weak var refreshButton: UIBarButtonItem!
         
         //表格
         var tableView:UITableView!
         
         //搜索栏
         var searchBar:UISearchBar!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self,
         forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //创建表头的搜索栏
         self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0,
         width: self.view.bounds.size.width, height: 56))
         self.tableView.tableHeaderView =  self.searchBar
         
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
         .startWith(()) //加这个为了让一开始就能自动请求一次数据
         .flatMapLatest(getRandomResult) //获取数据
         .flatMap(filterResult) //筛选数据
         .share(replay: 1)
         
         //创建数据源
         let dataSource = RxTableViewSectionedReloadDataSource
         <SectionModel<String, Int>>(configureCell: {
         (dataSource, tv, indexPath, element) in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
         return cell
         })
         
         //绑定单元格数据
         randomResult
         .bind(to: tableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         
         //获取随机数据
         func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
         print("正在请求数据......")
         let items = (0 ..< 5).map {_ in
         Int(arc4random())
         }
         let observable = Observable.just([SectionModel(model: "S", items: items)])
         return observable.delay(2, scheduler: MainScheduler.instance)
         }
         
         //过滤数据
         func filterResult(data:[SectionModel<String, Int>])
         -> Observable<[SectionModel<String, Int>]> {
         return self.searchBar.rx.text.orEmpty
         //.debounce(0.5, scheduler: MainScheduler.instance) //只有间隔超过0.5秒才发送
         .flatMapLatest{
         query -> Observable<[SectionModel<String, Int>]> in
         print("正在筛选数据（条件为：\(query)）")
         //输入条件为空，则直接返回原始数据
         if query.isEmpty{
         return Observable.just(data)
         }
         //输入条件为不空，则只返回包含有该文字的数据
         else{
         var newData:[SectionModel<String, Int>] = []
         for sectionModel in data {
         let items = sectionModel.items.filter{ "\($0)".contains(query) }
         newData.append(SectionModel(model: sectionModel.model, items: items))
         }
         return Observable.just(newData)
         }
         }
         }
         }
         */
        
        // TODO:可编辑表格:
        /*
         //定义各种操作命令
         enum TableEditingCommand {
         case setItems(items: [String])  //设置表格数据
         case addItem(item: String)  //新增数据
         case moveItem(from: IndexPath, to: IndexPath) //移动数据
         case deleteItem(IndexPath) //删除数据
         }
         
         //定义表格对应的ViewModel
         struct TableViewModel {
         //表格数据项
         fileprivate var items:[String]
         
         init(items: [String] = []) {
         self.items = items
         }
         
         //执行相应的命令，并返回最终的结果
         func execute(command: TableEditingCommand) -> TableViewModel {
         switch command {
         case .setItems(let items):
         print("设置表格数据。")
         return TableViewModel(items: items)
         case .addItem(let item):
         print("新增数据项。")
         var items = self.items
         items.append(item)
         return TableViewModel(items: items)
         case .moveItem(let from, let to):
         print("移动数据项。")
         var items = self.items
         items.insert(items.remove(at: from.row), at: to.row)
         return TableViewModel(items: items)
         case .deleteItem(let indexPath):
         print("删除数据项。")
         var items = self.items
         items.remove(at: indexPath.row)
         return TableViewModel(items: items)
         }
         }
         }
         
         class ViewController: UIViewController {
         
         //刷新按钮
         @IBOutlet weak var refreshButton: UIBarButtonItem!
         
         //新增按钮
         @IBOutlet weak var addButton: UIBarButtonItem!
         
         //表格
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self,
         forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //表格模型
         let initialVM = TableViewModel()
         
         //刷新数据命令
         let refreshCommand = refreshButton.rx.tap.asObservable()
         .startWith(()) //加这个为了页面初始化时会自动加载一次数据
         .flatMapLatest(getRandomResult)
         .map(TableEditingCommand.setItems)
         
         //新增条目命令
         let addCommand = addButton.rx.tap.asObservable()
         .map{ "\(arc4random())" }
         .map(TableEditingCommand.addItem)
         
         //移动位置命令
         let movedCommand = tableView.rx.itemMoved
         .map(TableEditingCommand.moveItem)
         
         //删除条目命令
         let deleteCommand = tableView.rx.itemDeleted.asObservable()
         .map(TableEditingCommand.deleteItem)
         
         //绑定单元格数据
         Observable.of(refreshCommand, addCommand, movedCommand, deleteCommand)
         .merge()
         .scan(initialVM) { (vm: TableViewModel, command: TableEditingCommand)
         -> TableViewModel in
         return vm.execute(command: command)
         }
         .startWith(initialVM)
         .map {
         [AnimatableSectionModel(model: "", items: $0.items)]
         }
         .share(replay: 1)
         .bind(to: tableView.rx.items(dataSource: ViewController.dataSource()))
         .disposed(by: disposeBag)
         }
         
         override func viewDidAppear(_ animated: Bool) {
         super.viewDidAppear(animated)
         tableView.setEditing(true, animated: true)
         }
         
         //获取随机数据
         func getRandomResult() -> Observable<[String]> {
         print("生成随机数据。")
         let items = (0 ..< 5).map {_ in
         "\(arc4random())"
         }
         return Observable.just(items)
         }
         }
         
         extension ViewController {
         //创建表格数据源
         static func dataSource() -> RxTableViewSectionedAnimatedDataSource
         <AnimatableSectionModel<String, String>> {
         return RxTableViewSectionedAnimatedDataSource(
         //设置插入、删除、移动单元格的动画效果
         animationConfiguration: AnimationConfiguration(insertAnimation: .top,
         reloadAnimation: .fade,
         deleteAnimation: .left),
         configureCell: {
         (dataSource, tv, indexPath, element) in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
         return cell
         },
         canEditRowAtIndexPath: { _, _ in
         return true //单元格可删除
         },
         canMoveRowAtIndexPath: { _, _ in
         return true //单元格可移动
         }
         )
         }
         }
         */
        
        // TODO:不同类型的单元格混用:
        /*
         class ViewController: UIViewController {
         
         @IBOutlet weak var tableView: UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //初始化数据
         let sections = Observable.just([
         MySection(header: "我是第一个分区", items: [
         .TitleImageSectionItem(title: "图片数据1", image: UIImage(named: "php")!),
         .TitleImageSectionItem(title: "图片数据2", image: UIImage(named: "react")!),
         .TitleSwitchSectionItem(title: "开关数据1", enabled: true)
         ]),
         MySection(header: "我是第二个分区", items: [
         .TitleSwitchSectionItem(title: "开关数据2", enabled: false),
         .TitleSwitchSectionItem(title: "开关数据3", enabled: false),
         .TitleImageSectionItem(title: "图片数据3", image: UIImage(named: "swift")!)
         ])
         ])
         
         //创建数据源
         let dataSource = RxTableViewSectionedReloadDataSource<MySection>(
         //设置单元格
         configureCell: { dataSource, tableView, indexPath, item in
         switch dataSource[indexPath] {
         case let .TitleImageSectionItem(title, image):
         let cell = tableView.dequeueReusableCell(withIdentifier: "titleImageCell",
         for: indexPath)
         (cell.viewWithTag(1) as! UILabel).text = title
         (cell.viewWithTag(2) as! UIImageView).image = image
         return cell
         
         case let .TitleSwitchSectionItem(title, enabled):
         let cell = tableView.dequeueReusableCell(withIdentifier: "titleSwitchCell",
         for: indexPath)
         (cell.viewWithTag(1) as! UILabel).text = title
         (cell.viewWithTag(2) as! UISwitch).isOn = enabled
         return cell
         }
         },
         //设置分区头标题
         titleForHeaderInSection: { ds, index in
         return ds.sectionModels[index].header
         }
         )
         
         //绑定单元格数据
         sections
         .bind(to: tableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         }
         
         //单元格类型
         enum SectionItem {
         case TitleImageSectionItem(title: String, image: UIImage)
         case TitleSwitchSectionItem(title: String, enabled: Bool)
         }
         
         //自定义Section
         struct MySection {
         var header: String
         var items: [SectionItem]
         }
         
         extension MySection : SectionModelType {
         typealias Item = SectionItem
         
         init(original: MySection, items: [Item]) {
         self = original
         self.items = items
         }
         }
         */
        
        // TODO:样式修改:
        /*
         需要调整 tableView 单元格的高度、或者修改 section 头尾视图样式
         虽然 RxSwift 没有封装相关的方法，但我们仍然可以通过相关的代理方法来设置
         
         修改单元格高度:
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         var dataSource:RxTableViewSectionedAnimatedDataSource<MySection>?
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //初始化数据
         let sections = Observable.just([
         MySection(header: "基本控件", items: [
         "UILable的用法",
         "UIText的用法",
         "UIButton的用法"
         ]),
         MySection(header: "高级控件", items: [
         "UITableView的用法",
         "UICollectionViews的用法"
         ])
         ])
         
         //创建数据源
         let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
         //设置单元格
         configureCell: { ds, tv, ip, item in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")
         ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
         cell.textLabel?.text = "\(ip.row)：\(item)"
         
         return cell
         },
         //设置分区头标题
         titleForHeaderInSection: { ds, index in
         return ds.sectionModels[index].header
         }
         )
         
         self.dataSource = dataSource
         
         //绑定单元格数据
         sections
         .bind(to: tableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         
         //设置代理
         tableView.rx.setDelegate(self)
         .disposed(by: disposeBag)
         }
         }
         
         //tableView代理实现
         extension ViewController : UITableViewDelegate {
         //设置单元格高度
         func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath)
         -> CGFloat {
         guard let _ = dataSource?[indexPath],
         let _ = dataSource?[indexPath.section]
         else {
         return 0.0
         }
         
         return 60
         }
         }
         
         //自定义Section
         struct MySection {
         var header: String
         var items: [Item]
         }
         
         extension MySection : AnimatableSectionModelType {
         typealias Item = String
         
         var identity: String {
         return header
         }
         
         init(original: MySection, items: [Item]) {
         self = original
         self.items = items
         }
         }
         
         修改分组的头部和尾部:
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         var dataSource:RxTableViewSectionedAnimatedDataSource<MySection>?
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //初始化数据
         let sections = Observable.just([
         MySection(header: "基本控件", items: [
         "UILable的用法",
         "UIText的用法",
         "UIButton的用法"
         ]),
         MySection(header: "高级控件", items: [
         "UITableView的用法",
         "UICollectionViews的用法"
         ])
         ])
         
         //创建数据源
         let dataSource = RxTableViewSectionedAnimatedDataSource<MySection>(
         //设置单元格
         configureCell: { ds, tv, ip, item in
         let cell = tv.dequeueReusableCell(withIdentifier: "Cell")
         ?? UITableViewCell(style: .default, reuseIdentifier: "Cell")
         cell.textLabel?.text = "\(ip.row)：\(item)"
         
         return cell
         },
         //设置分区尾部标题
         titleForFooterInSection: { ds, index in
         return "共有\(ds.sectionModels[index].items.count)个控件"
         }
         )
         
         self.dataSource = dataSource
         
         //绑定单元格数据
         sections
         .bind(to: tableView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         
         //设置代理
         tableView.rx.setDelegate(self)
         .disposed(by: disposeBag)
         }
         }
         
         //tableView代理实现
         extension ViewController : UITableViewDelegate {
         //返回分区头部视图
         func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int)
         -> UIView? {
         let headerView = UIView()
         headerView.backgroundColor = UIColor.black
         let titleLabel = UILabel()
         titleLabel.text = self.dataSource?[section].header
         titleLabel.textColor = UIColor.white
         titleLabel.sizeToFit()
         titleLabel.center = CGPoint(x: self.view.frame.width/2, y: 20)
         headerView.addSubview(titleLabel)
         return headerView
         }
         
         //返回分区头部高度
         func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int)
         -> CGFloat {
         return 40
         }
         }
         
         //自定义Section
         struct MySection {
         var header: String
         var items: [Item]
         }
         
         extension MySection : AnimatableSectionModelType {
         typealias Item = String
         
         var identity: String {
         return header
         }
         
         init(original: MySection, items: [Item]) {
         self = original
         self.items = items
         }
         }
         */
        
        // TODO:===UICollectionView===
        /*
         自定义一个单元格类：
         class MyCollectionViewCell: UICollectionViewCell {
         
         var label:UILabel!
         
         override init(frame: CGRect) {
         super.init(frame: frame)
         
         //背景设为橙色
         self.backgroundColor = UIColor.orange
         
         //创建文本标签
         label = UILabel(frame: frame)
         label.textColor = UIColor.white
         label.textAlignment = .center
         self.contentView.addSubview(label)
         }
         
         override func layoutSubviews() {
         super.layoutSubviews()
         label.frame = bounds
         }
         
         required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
         }
         }
         
         class ViewController: UIViewController {
         
         var collectionView:UICollectionView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //定义布局方式以及单元格大小
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.itemSize = CGSize(width: 100, height: 70)
         
         //创建集合视图
         self.collectionView = UICollectionView(frame: self.view.frame,
         collectionViewLayout: flowLayout)
         self.collectionView.backgroundColor = UIColor.white
         
         //创建一个重用的单元格
         self.collectionView.register(MyCollectionViewCell.self,
         forCellWithReuseIdentifier: "Cell")
         self.view.addSubview(self.collectionView!)
         
         //初始化数据
         let items = Observable.just([
         "Swift",
         "PHP",
         "Ruby",
         "Java",
         "C++",
         ])
         
         //设置单元格数据（其实就是对 cellForItemAt 的封装）
         items
         .bind(to: collectionView.rx.items) { (collectionView, row, element) in
         let indexPath = IndexPath(row: row, section: 0)
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
         for: indexPath) as! MyCollectionViewCell
         cell.label.text = "\(row)：\(element)"
         return cell
         }
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:单元格选中事件响应:
        /*
         //获取选中项的索引
         collectionView.rx.itemSelected.subscribe(onNext: { indexPath in
         print("选中项的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         
         
         //获取选中项的内容
         collectionView.rx.modelSelected(String.self).subscribe(onNext: { item in
         print("选中项的标题为：\(item)")
         }).disposed(by: disposeBag)
         
         //获取选中项的索引
         collectionView.rx.itemSelected.subscribe(onNext: { [weak self] indexPath in
         self?.showMessage("选中项的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         
         //获取选中项的内容
         collectionView.rx.modelSelected(String.self).subscribe(onNext: {[weak self] item in
         self?.showMessage("选中项的标题为：\(item)")
         }).disposed(by: disposeBag)
         
         
         如果想要同时获取选中项的索引，以及内容可以这么写：
         Observable.zip(collectionView.rx.itemSelected, collectionView.rx.modelSelected(String.self))
         .bind { [weak self] indexPath, item in
         self?.showMessage("选中项的indexPath为：\(indexPath)")
         self?.showMessage("选中项的标题为：\(item)")
         }
         .disposed(by: disposeBag)
         */
        
        // TODO:单元格取消选中事件响应:
        /*
         //获取被取消选中项的索引
         collectionView.rx.itemDeselected.subscribe(onNext: { [weak self] indexPath in
         self?.showMessage("被取消选中项的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         
         //获取被取消选中项的内容
         collectionView.rx.modelDeselected(String.self).subscribe(onNext: {[weak self] item in
         self?.showMessage("被取消选中项的的标题为：\(item)")
         }).disposed(by: disposeBag)
         
         也可以同时获取：
         Observable
         .zip(collectionView.rx.itemDeselected, collectionView.rx.modelDeselected(String.self))
         .bind { [weak self] indexPath, item in
         self?.showMessage("被取消选中项的indexPath为：\(indexPath)")
         self?.showMessage("被取消选中项的的标题为：\(item)")
         }
         .disposed(by: disposeBag)
         */
        
        // TODO:单元格高亮完成后的事件响应:
        /*
         //获取选中并高亮完成后的索引
         collectionView.rx.itemHighlighted.subscribe(onNext: { indexPath in
         print("高亮单元格的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         */
        
        // TODO:高亮转成非高亮完成的事件响应:
        /*
         //获取高亮转成非高亮完成后的索引
         collectionView.rx.itemUnhighlighted.subscribe(onNext: { indexPath in
         print("失去高亮的单元格的indexPath为：\(indexPath)")
         }).disposed(by: disposeBag)
         */
        
        // TODO:单元格将要显示出来的事件响应:
        /*
         //单元格将要显示出来的事件响应
         collectionView.rx.willDisplayCell.subscribe(onNext: { cell, indexPath in
         print("将要显示单元格indexPath为：\(indexPath)")
         print("将要显示单元格cell为：\(cell)\n")
         }).disposed(by: disposeBag)
         */
        
        // TODO:分区头部或尾部将要显示出来的事件响应:
        /*
         //分区头部、尾部将要显示出来的事件响应
         collectionView.rx.willDisplaySupplementaryView.subscribe(onNext: { view, kind, indexPath in
         print("将要显示分区indexPath为：\(indexPath)")
         print("将要显示的是头部还是尾部：\(kind)")
         print("将要显示头部或尾部视图：\(view)\n")
         }).disposed(by: disposeBag)
         */
        
        // TODO:===UICollectionView的使用：RxDataSources===
        /*
         RxDataSources 是以 section 来做为数据结构的。所以不管我们的 collectionView 是单分区还是多分区，在使用 RxDataSources 的过程中，都需要返回一个 section 的数组
         使用自带的 Section:
         class ViewController: UIViewController {
         
         var collectionView:UICollectionView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //定义布局方式以及单元格大小
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.itemSize = CGSize(width: 100, height: 70)
         
         //创建集合视图
         self.collectionView = UICollectionView(frame: self.view.frame,
         collectionViewLayout: flowLayout)
         self.collectionView.backgroundColor = UIColor.white
         
         //创建一个重用的单元格
         self.collectionView.register(MyCollectionViewCell.self,
         forCellWithReuseIdentifier: "Cell")
         self.view.addSubview(self.collectionView!)
         
         //初始化数据
         let items = Observable.just([
         SectionModel(model: "", items: [
         "Swift",
         "PHP",
         "Python",
         "Java",
         "javascript",
         "C#"
         ])
         ])
         
         //创建数据源
         let dataSource = RxCollectionViewSectionedReloadDataSource
         <SectionModel<String, String>>(
         configureCell: { (dataSource, collectionView, indexPath, element) in
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
         for: indexPath) as! MyCollectionViewCell
         cell.label.text = "\(element)"
         return cell}
         )
         
         //绑定单元格数据
         items
         .bind(to: collectionView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         }
         
         
         使用自定义的 Section:
         class ViewController: UIViewController {
         
         var collectionView:UICollectionView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //定义布局方式以及单元格大小
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.itemSize = CGSize(width: 100, height: 70)
         
         //创建集合视图
         self.collectionView = UICollectionView(frame: self.view.frame,
         collectionViewLayout: flowLayout)
         self.collectionView.backgroundColor = UIColor.white
         
         //创建一个重用的单元格
         self.collectionView.register(MyCollectionViewCell.self,
         forCellWithReuseIdentifier: "Cell")
         self.view.addSubview(self.collectionView!)
         
         //初始化数据
         let sections = Observable.just([
         MySection(header: "", items: [
         "Swift",
         "PHP",
         "Python",
         "Java",
         "javascript",
         "C#"
         ])
         ])
         
         //创建数据源
         let dataSource = RxCollectionViewSectionedReloadDataSource<MySection>(
         configureCell: { (dataSource, collectionView, indexPath, element) in
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
         for: indexPath) as! MyCollectionViewCell
         cell.label.text = "\(element)"
         return cell}
         )
         
         //绑定单元格数据
         sections
         .bind(to: collectionView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         }
         
         //自定义Section
         struct MySection {
         var header: String
         var items: [Item]
         }
         
         extension MySection : AnimatableSectionModelType {
         typealias Item = String
         
         var identity: String {
         return header
         }
         
         init(original: MySection, items: [Item]) {
         self = original
         self.items = items
         }
         }
         */
        
        // TODO:多分区的 CollectionView:
        /*
         除了上面的自定义单元格类（MyCollectionViewCell）外，还需要自定义一个分区头类（MySectionHeader），供后面使用
         class MySectionHeader: UICollectionReusableView {
         var label:UILabel!
         
         override init(frame: CGRect) {
         super.init(frame: frame)
         
         //背景设为黑色
         self.backgroundColor = UIColor.black
         
         //创建文本标签
         label = UILabel(frame: frame)
         label.textColor = UIColor.white
         label.textAlignment = .center
         self.addSubview(label)
         }
         
         override func layoutSubviews() {
         super.layoutSubviews()
         label.frame = bounds
         }
         
         required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
         }
         }
         
         使用自带的 Section:
         class ViewController: UIViewController {
         
         var collectionView:UICollectionView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //定义布局方式以及单元格大小
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.itemSize = CGSize(width: 100, height: 70)
         flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 40)
         
         //创建集合视图
         self.collectionView = UICollectionView(frame: self.view.frame,
         collectionViewLayout: flowLayout)
         self.collectionView.backgroundColor = UIColor.white
         
         //创建一个重用的单元格
         self.collectionView.register(MyCollectionViewCell.self,
         forCellWithReuseIdentifier: "Cell")
         //创建一个重用的分区头
         self.collectionView.register(MySectionHeader.self,
         forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
         withReuseIdentifier: "Section")
         self.view.addSubview(self.collectionView!)
         
         
         //初始化数据
         let items = Observable.just([
         SectionModel(model: "脚本语言", items: [
         "Python",
         "javascript",
         "PHP",
         ]),
         SectionModel(model: "高级语言", items: [
         "Swift",
         "C++",
         "Java",
         "C#"
         ])
         ])
         
         //创建数据源
         let dataSource = RxCollectionViewSectionedReloadDataSource
         <SectionModel<String, String>>(
         configureCell: { (dataSource, collectionView, indexPath, element) in
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
         for: indexPath) as! MyCollectionViewCell
         cell.label.text = "\(element)"
         return cell},
         configureSupplementaryView: {
         (ds ,cv, kind, ip) in
         let section = cv.dequeueReusableSupplementaryView(ofKind: kind,
         withReuseIdentifier: "Section", for: ip) as! MySectionHeader
         section.label.text = "\(ds[ip.section].model)"
         return section
         })
         
         //绑定单元格数据
         items
         .bind(to: collectionView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         }
         
         使用自定义的 Section:
         class ViewController: UIViewController {
         
         var collectionView:UICollectionView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //定义布局方式以及单元格大小
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.itemSize = CGSize(width: 100, height: 70)
         flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 40)
         
         //创建集合视图
         self.collectionView = UICollectionView(frame: self.view.frame,
         collectionViewLayout: flowLayout)
         self.collectionView.backgroundColor = UIColor.white
         
         //创建一个重用的单元格
         self.collectionView.register(MyCollectionViewCell.self,
         forCellWithReuseIdentifier: "Cell")
         //创建一个重用的分区头
         self.collectionView.register(MySectionHeader.self,
         forSupplementaryViewOfKind: UICollectionElementKindSectionHeader,
         withReuseIdentifier: "Section")
         self.view.addSubview(self.collectionView!)
         
         
         //初始化数据
         let sections = Observable.just([
         MySection(header: "脚本语言", items: [
         "Python",
         "javascript",
         "PHP",
         ]),
         MySection(header: "高级语言", items: [
         "Swift",
         "C++",
         "Java",
         "C#"
         ])
         ])
         
         //创建数据源
         let dataSource = RxCollectionViewSectionedReloadDataSource<MySection>(
         configureCell: { (dataSource, collectionView, indexPath, element) in
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
         for: indexPath) as! MyCollectionViewCell
         cell.label.text = "\(element)"
         return cell},
         configureSupplementaryView: {
         (ds ,cv, kind, ip) in
         let section = cv.dequeueReusableSupplementaryView(ofKind: kind,
         withReuseIdentifier: "Section", for: ip) as! MySectionHeader
         section.label.text = "\(ds[ip.section].header)"
         return section
         })
         
         //绑定单元格数据
         sections
         .bind(to: collectionView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         }
         
         //自定义Section
         struct MySection {
         var header: String
         var items: [Item]
         }
         
         extension MySection : AnimatableSectionModelType {
         typealias Item = String
         
         var identity: String {
         return header
         }
         
         init(original: MySection, items: [Item]) {
         self = original
         self.items = items
         }
         }
         */
        
        // TODO:数据刷新:
        /*
         class ViewController: UIViewController {
         
         //刷新按钮
         @IBOutlet weak var refreshButton: UIBarButtonItem!
         
         //集合视图
         var collectionView:UICollectionView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //定义布局方式以及单元格大小
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.itemSize = CGSize(width: 100, height: 70)
         
         //创建集合视图
         self.collectionView = UICollectionView(frame: self.view.frame,
         collectionViewLayout: flowLayout)
         self.collectionView.backgroundColor = UIColor.white
         
         //创建一个重用的单元格
         self.collectionView.register(MyCollectionViewCell.self,
         forCellWithReuseIdentifier: "Cell")
         self.view.addSubview(self.collectionView!)
         
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
         .startWith(()) //加这个为了让一开始就能自动请求一次数据
         .flatMapLatest(getRandomResult)
         .share(replay: 1)
         
         //创建数据源
         let dataSource = RxCollectionViewSectionedReloadDataSource
         <SectionModel<String, Int>>(
         configureCell: { (dataSource, collectionView, indexPath, element) in
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
         for: indexPath) as! MyCollectionViewCell
         cell.label.text = "\(element)"
         return cell}
         )
         
         //绑定单元格数据
         randomResult
         .bind(to: collectionView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         
         //获取随机数据
         func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
         print("正在请求数据......")
         let items = (0 ..< 5).map {_ in
         Int(arc4random_uniform(100000))
         }
         let observable = Observable.just([SectionModel(model: "S", items: items)])
         return observable.delay(2, scheduler: MainScheduler.instance)
         }
         }
         */
        
        // TODO:停止数据请求:
        /*
         class ViewController: UIViewController {
         
         //刷新按钮
         @IBOutlet weak var refreshButton: UIBarButtonItem!
         
         //停止按钮
         @IBOutlet weak var cancelButton: UIBarButtonItem!
         
         //集合视图
         var collectionView:UICollectionView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //定义布局方式以及单元格大小
         let flowLayout = UICollectionViewFlowLayout()
         flowLayout.itemSize = CGSize(width: 100, height: 70)
         
         //创建集合视图
         self.collectionView = UICollectionView(frame: self.view.frame,
         collectionViewLayout: flowLayout)
         self.collectionView.backgroundColor = UIColor.white
         
         //创建一个重用的单元格
         self.collectionView.register(MyCollectionViewCell.self,
         forCellWithReuseIdentifier: "Cell")
         self.view.addSubview(self.collectionView!)
         
         //随机的表格数据
         let randomResult = refreshButton.rx.tap.asObservable()
         .startWith(()) //加这个为了让一开始就能自动请求一次数据
         .flatMapLatest{
         self.getRandomResult().takeUntil(self.cancelButton.rx.tap)
         }
         .share(replay: 1)
         
         //创建数据源
         let dataSource = RxCollectionViewSectionedReloadDataSource
         <SectionModel<String, Int>>(
         configureCell: { (dataSource, collectionView, indexPath, element) in
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
         for: indexPath) as! MyCollectionViewCell
         cell.label.text = "\(element)"
         return cell}
         )
         
         //绑定单元格数据
         randomResult
         .bind(to: collectionView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         }
         
         //获取随机数据
         func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
         print("正在请求数据......")
         let items = (0 ..< 5).map {_ in
         Int(arc4random_uniform(100000))
         }
         let observable = Observable.just([SectionModel(model: "S", items: items)])
         return observable.delay(2, scheduler: MainScheduler.instance)
         }
         }
         
         //自定义单元格
         class MyCollectionViewCell: UICollectionViewCell {
         
         var label:UILabel!
         
         override init(frame: CGRect) {
         super.init(frame: frame)
         
         //背景设为橙色
         self.backgroundColor = UIColor.orange
         
         //创建文本标签
         label = UILabel(frame: frame)
         label.textColor = UIColor.white
         label.textAlignment = .center
         self.contentView.addSubview(label)
         }
         
         override func layoutSubviews() {
         super.layoutSubviews()
         label.frame = bounds
         }
         
         required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
         }
         }
         */
        
        // TODO:样式修改:
        /*
         有时我们可能需要调整 collectionView 单元格尺寸、间距，或者修改 section 头尾视图尺寸等等。虽然 RxSwift 没有封装相关的方法，但我们仍然可以通过相关的代理方法来设置
         class ViewController: UIViewController {
         
         var collectionView:UICollectionView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //定义布局方式
         let flowLayout = UICollectionViewFlowLayout()
         
         //创建集合视图
         self.collectionView = UICollectionView(frame: self.view.frame,
         collectionViewLayout: flowLayout)
         self.collectionView.backgroundColor = UIColor.white
         
         //创建一个重用的单元格
         self.collectionView.register(MyCollectionViewCell.self,
         forCellWithReuseIdentifier: "Cell")
         self.view.addSubview(self.collectionView!)
         
         //初始化数据
         let items = Observable.just([
         SectionModel(model: "", items: [
         "Swift",
         "PHP",
         "Python",
         "Java",
         "C++",
         "C#"
         ])
         ])
         
         //创建数据源
         let dataSource = RxCollectionViewSectionedReloadDataSource
         <SectionModel<String, String>>(
         configureCell: { (dataSource, collectionView, indexPath, element) in
         let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell",
         for: indexPath) as! MyCollectionViewCell
         cell.label.text = "\(element)"
         return cell}
         )
         
         //绑定单元格数据
         items
         .bind(to: collectionView.rx.items(dataSource: dataSource))
         .disposed(by: disposeBag)
         
         //设置代理
         collectionView.rx.setDelegate(self)
         .disposed(by: disposeBag)
         }
         }
         
         //collectionView代理实现
         extension ViewController : UICollectionViewDelegateFlowLayout {
         //设置单元格尺寸
         func collectionView(_ collectionView: UICollectionView,
         layout collectionViewLayout: UICollectionViewLayout,
         sizeForItemAt indexPath: IndexPath) -> CGSize {
         let width = collectionView.bounds.width
         let cellWidth = (width - 30) / 4 //每行显示4个单元格
         return CGSize(width: cellWidth, height: cellWidth * 1.5) //单元格宽度为高度1.5倍
         }
         }
         
         //自定义单元格
         class MyCollectionViewCell: UICollectionViewCell {
         
         var label:UILabel!
         
         override init(frame: CGRect) {
         super.init(frame: frame)
         
         //背景设为橙色
         self.backgroundColor = UIColor.orange
         
         //创建文本标签
         label = UILabel(frame: frame)
         label.textColor = UIColor.white
         label.textAlignment = .center
         self.contentView.addSubview(label)
         }
         
         override func layoutSubviews() {
         super.layoutSubviews()
         label.frame = bounds
         }
         
         required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
         }
         }
         */
        
        // TODO:===UIPickerView===
        /*
         需要引入 RxDataSources 这个第三方库。因为它提供了许多pickerView适配器可以方便我们的开发工作
         单列的情况:
         class ViewController:UIViewController {
         
         var pickerView:UIPickerView!
         
         //最简单的pickerView适配器（显示普通文本）
         private let stringPickerAdapter = RxPickerViewStringAdapter<[String]>(
         components: [],
         numberOfComponents: { _,_,_  in 1 },
         numberOfRowsInComponent: { (_, _, items, _) -> Int in
         return items.count},
         titleForRow: { (_, _, items, row, _) -> String? in
         return items[row]}
         )
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建pickerView
         pickerView = UIPickerView()
         self.view.addSubview(pickerView)
         
         //绑定pickerView数据
         Observable.just(["One", "Two", "Tree"])
         .bind(to: pickerView.rx.items(adapter: stringPickerAdapter))
         .disposed(by: disposeBag)
         
         //建立一个按钮，触摸按钮时获得选择框被选择的索引
         let button = UIButton(frame:CGRect(x:0, y:0, width:100, height:30))
         button.center = self.view.center
         button.backgroundColor = UIColor.blue
         button.setTitle("获取信息",for:.normal)
         //按钮点击响应
         button.rx.tap
         .bind { [weak self] in
         self?.getPickerViewValue()
         }
         .disposed(by: disposeBag)
         self.view.addSubview(button)
         }
         
         //触摸按钮时，获得被选中的索引
         @objc func getPickerViewValue(){
         let message = String(pickerView.selectedRow(inComponent: 0))
         let alertController = UIAlertController(title: "被选中的索引为",
         message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
         }
         }
         
         多列的情况:
         class ViewController:UIViewController {
         
         var pickerView:UIPickerView!
         
         //最简单的pickerView适配器（显示普通文本）
         private let stringPickerAdapter = RxPickerViewStringAdapter<[[String]]>(
         components: [],
         numberOfComponents: { dataSource,pickerView,components  in components.count },
         numberOfRowsInComponent: { (_, _, components, component) -> Int in
         return components[component].count},
         titleForRow: { (_, _, components, row, component) -> String? in
         return components[component][row]}
         )
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建pickerView
         pickerView = UIPickerView()
         self.view.addSubview(pickerView)
         
         //绑定pickerView数据
         Observable.just([["One", "Two", "Tree"],
         ["A", "B", "C", "D"]])
         .bind(to: pickerView.rx.items(adapter: stringPickerAdapter))
         .disposed(by: disposeBag)
         
         //建立一个按钮，触摸按钮时获得选择框被选择的索引
         let button = UIButton(frame:CGRect(x:0, y:0, width:100, height:30))
         button.center = self.view.center
         button.backgroundColor = UIColor.blue
         button.setTitle("获取信息",for:.normal)
         //按钮点击响应
         button.rx.tap
         .bind { [weak self] in
         self?.getPickerViewValue()
         }
         .disposed(by: disposeBag)
         self.view.addSubview(button)
         }
         
         //触摸按钮时，获得被选中的索引
         @objc func getPickerViewValue(){
         let message = String(pickerView.selectedRow(inComponent: 0)) + "-"
         + String(pickerView!.selectedRow(inComponent: 1))
         let alertController = UIAlertController(title: "被选中的索引为",
         message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
         }
         }
         */
        
        // TODO:修改默认的样式:
        /*
         我们将选项的文字修改成橙色，同时在文字下方加上双下划线
         改用 RxPickerViewAttributedStringAdapter 这个可以设置文字属性的适配器即可
         class ViewController:UIViewController {
         
         var pickerView:UIPickerView!
         
         //设置文字属性的pickerView适配器
         private let attrStringPickerAdapter = RxPickerViewAttributedStringAdapter<[String]>(
         components: [],
         numberOfComponents: { _,_,_  in 1 },
         numberOfRowsInComponent: { (_, _, items, _) -> Int in
         return items.count}
         ){ (_, _, items, row, _) -> NSAttributedString? in
         return NSAttributedString(string: items[row],
         attributes: [
         NSAttributedStringKey.foregroundColor: UIColor.orange, //橙色文字
         NSAttributedStringKey.underlineStyle:
         NSUnderlineStyle.styleDouble.rawValue, //双下划线
         NSAttributedStringKey.textEffect:
         NSAttributedString.TextEffectStyle.letterpressStyle
         ])
         }
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建pickerView
         pickerView = UIPickerView()
         self.view.addSubview(pickerView)
         
         //绑定pickerView数据
         Observable.just(["One", "Two", "Tree"])
         .bind(to: pickerView.rx.items(adapter: attrStringPickerAdapter))
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:使用自定义视图:
        /*
         我们将选项视图改成单纯显示颜色色块的 view，其颜色由传入的值决定
         改用 RxPickerViewViewAdapter 这个可以返回自定义视图的适配器即可
         class ViewController:UIViewController {
         
         var pickerView:UIPickerView!
         
         //设置自定义视图的pickerView适配器
         private let viewPickerAdapter = RxPickerViewViewAdapter<[UIColor]>(
         components: [],
         numberOfComponents: { _,_,_  in 1 },
         numberOfRowsInComponent: { (_, _, items, _) -> Int in
         return items.count}
         ){ (_, _, items, row, _, view) -> UIView in
         let componentView = view ?? UIView()
         componentView.backgroundColor = items[row]
         return componentView
         }
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建pickerView
         pickerView = UIPickerView()
         self.view.addSubview(pickerView)
         
         //绑定pickerView数据
         Observable.just([UIColor.red, UIColor.orange, UIColor.yellow])
         .bind(to: pickerView.rx.items(adapter: viewPickerAdapter))
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===[unowned self] 与 [weak self]===
        /*
         class DetailViewController: UIViewController {
         
         @IBOutlet weak var textField: UITextField!
         
         @IBOutlet weak var label: UILabel!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         textField.rx.text.orEmpty.asDriver().drive(onNext: {
         [weak self] text in
         DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
         print("当前输入内容：\(String(describing: text))")
         self?.label.text = text
         }
         
         }).disposed(by: disposeBag)
         }
         
         override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         }
         
         deinit {
         print(#file, #function)
         }
         }
         
         如果我们不用 [weak self] 而改用 [unowned self]，返回主页面　4　秒钟后由于详情页早已被销毁，这时访问 label 将会导致异常抛出
         当然如果我们把延时去掉的话，使用 [unowned self] 是完全没有问题的
         */
        
        // TODO:===URLSession的使用：请求数据===
        /*
         RxSwift（或者说 RxCocoa）除了对系统原生的 UI 控件提供了 rx 扩展外，对 URLSession 也进行了扩展，从而让我们可以很方便地发送 HTTP 请求
         */
        // TODO:请求网络数据:
        /*
         通过 rx.response 请求数据:
         
         //创建URL对象
         let urlString = "https://www.douban.com/xxxxxxxxxx/app/radio/channels"
         let url = URL(string:urlString)
         //创建请求对象
         let request = URLRequest(url: url!)
         
         //创建并发起请求
         URLSession.shared.rx.response(request: request).subscribe(onNext: {
         (response, data) in
         //判断响应结果状态码
         if 200 ..< 300 ~= response.statusCode {
         let str = String(data: data, encoding: String.Encoding.utf8)
         print("请求成功！返回的数据是：", str ?? "")
         }else{
         print("请求失败！")
         }
         }).disposed(by: disposeBag)
         
         不管请求成功与否都会进入到 onNext 这个回调中。如果我们需要根据响应状态进行一些相应操作，比如：
         
         状态码在 200 ~ 300 则正常显示数据。
         如果是异常状态码（比如：404）则弹出告警提示框
         
         通过 rx.data 请求数据:
         rx.data 与 rx.response 的区别：
         
         如果不需要获取底层的 response，只需知道请求是否成功，以及成功时返回的结果，那么建议使用 rx.data。
         因为 rx.data 会自动对响应状态码进行判断，只有成功的响应（状态码为 200~300）才会进入到 onNext 这个回调，否则进入 onError 这个回调
         
         如果不需要考虑请求失败的情况，只对成功返回的结果做处理可以在 onNext 回调中进行相关操作
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)
         //创建请求对象
         let request = URLRequest(url: url!)
         
         //创建并发起请求
         URLSession.shared.rx.data(request: request).subscribe(onNext: {
         data in
         let str = String(data: data, encoding: String.Encoding.utf8)
         print("请求成功！返回的数据是：", str ?? "")
         }).disposed(by: disposeBag)
         
         如果还要处理失败的情况，可以在 onError 回调中操作
         //创建URL对象
         let urlString = "https://www.douban.com/xxxxxx/app/radio/channels"
         let url = URL(string:urlString)
         //创建请求对象
         let request = URLRequest(url: url!)
         
         //创建并发起请求
         URLSession.shared.rx.data(request: request).subscribe(onNext: {
         data in
         let str = String(data: data, encoding: String.Encoding.utf8)
         print("请求成功！返回的数据是：", str ?? "")
         }, onError: { error in
         print("请求失败！错误原因：", error)
         }).disposed(by: disposeBag)
         */
        
        // TODO:手动发起请求、取消请求:
        /*
         如果请求没返回时，点击“取消请求”则可将其取消（取消后即使返回数据也不处理了）
         class ViewController: UIViewController {
         
         //“发起请求”按钮
         @IBOutlet weak var startBtn: UIButton!
         
         //“取消请求”按钮
         @IBOutlet weak var cancelBtn: UIButton!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)
         //创建请求对象
         let request = URLRequest(url: url!)
         
         //发起请求按钮点击
         startBtn.rx.tap.asObservable()
         .flatMap {
         URLSession.shared.rx.data(request: request)
         .takeUntil(self.cancelBtn.rx.tap) //如果“取消按钮”点击则停止请求
         }
         .subscribe(onNext: {
         data in
         let str = String(data: data, encoding: String.Encoding.utf8)
         print("请求成功！返回的数据是：", str ?? "")
         }, onError: { error in
         print("请求失败！错误原因：", error)
         }).disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===URLSession的使用：结果处理、模型转换===
        /*
         将结果转为 JSON 对象:
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)
         //创建请求对象
         let request = URLRequest(url: url!)
         
         //创建并发起请求
         URLSession.shared.rx.data(request: request).subscribe(onNext: {
         data in
         let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
         as! [String: Any]
         print("--- 请求成功！返回的如下数据 ---")
         print(json!)
         }).disposed(by: disposeBag)
         
         在订阅前就进行转换也是可以的：
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)
         //创建请求对象
         let request = URLRequest(url: url!)
         
         //创建并发起请求
         URLSession.shared.rx.data(request: request)
         .map {
         try JSONSerialization.jsonObject(with: $0, options: .allowFragments)
         as! [String: Any]
         }
         .subscribe(onNext: {
         data in
         print("--- 请求成功！返回的如下数据 ---")
         print(data)
         }).disposed(by: disposeBag)
         
         直接使用 RxSwift 提供的 rx.json 方法去获取数据，它会直接将结果转成 JSON 对象:
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)
         //创建请求对象
         let request = URLRequest(url: url!)
         
         //创建并发起请求
         URLSession.shared.rx.json(request: request).subscribe(onNext: {
         data in
         let json = data as! [String: Any]
         print("--- 请求成功！返回的如下数据 ---")
         print(json )
         }).disposed(by: disposeBag)
         
         */
        
        /*
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)
         //创建请求对象
         let request = URLRequest(url: url!)
         
         //获取列表数据
         let data = URLSession.shared.rx.json(request: request)
         .map{ result -> [[String: Any]] in
         if let data = result as? [String: Any],
         let channels = data["channels"] as? [[String: Any]] {
         return channels
         }else{
         return []
         }
         }
         
         //将数据绑定到表格
         data.bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(row)：\(element["name"]!)"
         return cell
         }.disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:将结果映射成自定义对象:
        /*
         要实现数据到模型（model）的转换，我们首先需要引入一个第三方的数据模型转换框架：ObjectMapper
         https://www.hangge.com/blog/cache/detail_1673.html
         
         为了让 ObjectMapper 能够更好地与 RxSwift 配合使用，我们对 Observable 进行扩展（RxObjectMapper.swift），增加数据转模型对象、以及数据转模型对象数组这两个方法
         
         import ObjectMapper
         import RxSwift
         
         //数据映射错误
         public enum RxObjectMapperError: Error {
         case parsingError
         }
         
         //扩展Observable：增加模型映射方法
         public extension Observable where Element:Any {
         
         //将JSON数据转成对象
         public func mapObject< T>(type:T.Type) -> Observable<T> where T:Mappable {
         let mapper = Mapper<T>()
         
         return self.map { (element) -> T in
         guard let parsedElement = mapper.map(JSONObject: element) else {
         throw RxObjectMapperError.parsingError
         }
         
         return parsedElement
         }
         }
         
         //将JSON数据转成数组
         public func mapArray< T>(type:T.Type) -> Observable<[T]> where T:Mappable {
         let mapper = Mapper<T>()
         
         return self.map { (element) -> [T] in
         guard let parsedArray = mapper.mapArray(JSONObject: element) else {
         throw RxObjectMapperError.parsingError
         }
         
         return parsedArray
         }
         }
         }
         
         首先我定义好相关模型（需要实现 ObjectMapper 的 Mappable 协议，并设置好成员对象与 JSON 属性的相互映射关系
         //豆瓣接口模型
         class Douban: Mappable {
         //频道列表
         var channels: [Channel]?
         
         init(){
         }
         
         required init?(map: Map) {
         }
         
         // Mappable
         func mapping(map: Map) {
         channels <- map["channels"]
         }
         }
         
         //频道模型
         class Channel: Mappable {
         var name: String?
         var nameEn:String?
         var channelId: String?
         var seqId: Int?
         var abbrEn: String?
         
         init(){
         }
         
         required init?(map: Map) {
         }
         
         // Mappable
         func mapping(map: Map) {
         name <- map["name"]
         nameEn <- map["name_en"]
         channelId <- map["channel_id"]
         seqId <- map["seq_id"]
         abbrEn <- map["abbr_en"]
         }
         }
         
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)
         //创建请求对象
         let request = URLRequest(url: url!)
         
         //创建并发起请求
         URLSession.shared.rx.json(request: request)
         .mapObject(type: Douban.self)
         .subscribe(onNext: { (douban: Douban) in
         if let channels = douban.channels {
         print("--- 共\(channels.count)个频道 ---")
         for channel in channels {
         if let name = channel.name, let channelId = channel.channelId {
         print("\(name) （id:\(channelId)）")
         }
         }
         }
         }).disposed(by: disposeBag)
         
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)
         //创建请求对象
         let request = URLRequest(url: url!)
         
         //获取列表数据
         let data = URLSession.shared.rx.json(request: request)
         .mapObject(type: Douban.self)
         .map{ $0.channels ?? []}
         
         //将数据绑定到表格
         data.bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(row)：\(element.name!)"
         return cell
         }.disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===RxAlamofire使用：数据请求===
        /*
         RxAlamofire 是对 Alamofire 的封装
         
         使用 request 请求数据:
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //创建并发起请求
         request(.get, url)
         .data()
         .subscribe(onNext: {
         data in
         //数据处理
         let str = String(data: data, encoding: String.Encoding.utf8)
         print("返回的数据是：", str ?? "")
         }).disposed(by: disposeBag)
         如果还要处理失败的情况，可以在 onError 回调中操作
         //创建URL对象
         let urlString = "https://www.douban.com/jxxxxxxxx/app/radio/channels"
         let url = URL(string:urlString)!
         
         //创建并发起请求
         request(.get, url)
         .data()
         .subscribe(onNext: {
         data in
         //数据处理
         let str = String(data: data, encoding: String.Encoding.utf8)
         print("返回的数据是：", str ?? "")
         }, onError: { error in
         print("请求失败！错误原因：", error)
         }).disposed(by: disposeBag)
         
         
         使用 requestData 请求数据:
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //创建并发起请求
         requestData(.get, url).subscribe(onNext: {
         response, data in
         //数据处理
         let str = String(data: data, encoding: String.Encoding.utf8)
         print("返回的数据是：", str ?? "")
         }).disposed(by: disposeBag)
         使用 requestData 的话，不管请求成功与否都会进入到 onNext 这个回调中。如果我们想要根据响应状态进行一些相应操作，通过 response 参数即可实现
         //创建URL对象
         let urlString = "https://www.douban.com/jxxxxxxx/app/radio/channels"
         let url = URL(string:urlString)!
         
         //创建并发起请求
         requestData(.get, url).subscribe(onNext: {
         response, data in
         //判断响应结果状态码
         if 200 ..< 300 ~= response.statusCode {
         let str = String(data: data, encoding: String.Encoding.utf8)
         print("请求成功！返回的数据是：", str ?? "")
         }else{
         print("请求失败！")
         }
         }).disposed(by: disposeBag)
         
         
         获取 String 类型数据:
         如果请求的数据是字符串类型的，我们可以在 request 请求时直接通过 responseString()方法实现自动转换，省的在回调中还要手动将 data 转为 string
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //创建并发起请求
         request(.get, url)
         .responseString()
         .subscribe(onNext: {
         response, data in
         //数据处理
         print("返回的数据是：", data)
         }).disposed(by: disposeBag)
         
         更简单的方法就是直接使用 requestString 去获取数据:
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //创建并发起请求
         requestString(.get, url)
         .subscribe(onNext: {
         response, data in
         //数据处理
         print("返回的数据是：", data)
         }).disposed(by: disposeBag)
         
         手动发起请求、取消请求:
         class ViewController: UIViewController {
         
         //“发起请求”按钮
         @IBOutlet weak var startBtn: UIButton!
         
         //“取消请求”按钮
         @IBOutlet weak var cancelBtn: UIButton!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //发起请求按钮点击
         startBtn.rx.tap.asObservable()
         .flatMap {
         request(.get, url).responseString()
         .takeUntil(self.cancelBtn.rx.tap) //如果“取消按钮”点击则停止请求
         }
         .subscribe(onNext: {
         response, data in
         print("请求成功！返回的数据是：", data)
         }, onError: { error in
         print("请求失败！错误原因：", error)
         }).disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===RxAlamofire使用：结果处理、模型转换===
        // TODO:将结果转为 JSON 对象:
        /*
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //创建并发起请求
         request(.get, url)
         .data()
         .subscribe(onNext: {
         data in
         let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
         as! [String: Any]
         print("--- 请求成功！返回的如下数据 ---")
         print(json!)
         }).disposed(by: disposeBag)
         
         在订阅前使用 responseJSON() 进行转换也是可以的：
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //创建并发起请求
         request(.get, url)
         .responseJSON()
         .subscribe(onNext: {
         dataResponse in
         let json = dataResponse.value as! [String: Any]
         print("--- 请求成功！返回的如下数据 ---")
         print(json)
         }).disposed(by: disposeBag)
         
         最简单的还是直接使用 requestJSON 方法去获取 JSON 数据：
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //创建并发起请求
         requestJSON(.get, url)
         .subscribe(onNext: {
         response, data in
         let json = data as! [String: Any]
         print("--- 请求成功！返回的如下数据 ---")
         print(json)
         }).disposed(by: disposeBag)
         
         
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //获取列表数据
         let data = requestJSON(.get, url)
         .map{ response, data -> [[String: Any]] in
         if let json = data as? [String: Any],
         let channels = json["channels"] as? [[String: Any]] {
         return channels
         }else{
         return []
         }
         }
         
         //将数据绑定到表格
         data.bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(row)：\(element["name"]!)"
         return cell
         }.disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:将结果映射成自定义对象:
        /*
         //数据映射错误
         public enum RxObjectMapperError: Error {
         case parsingError
         }
         
         //扩展Observable：增加模型映射方法
         public extension Observable where Element:Any {
         
         //将JSON数据转成对象
         public func mapObject< T>(type:T.Type) -> Observable<T> where T:Mappable {
         let mapper = Mapper<T>()
         
         return self.map { (element) -> T in
         guard let parsedElement = mapper.map(JSONObject: element) else {
         throw RxObjectMapperError.parsingError
         }
         
         return parsedElement
         }
         }
         
         //将JSON数据转成数组
         public func mapArray< T>(type:T.Type) -> Observable<[T]> where T:Mappable {
         let mapper = Mapper<T>()
         
         return self.map { (element) -> [T] in
         guard let parsedArray = mapper.mapArray(JSONObject: element) else {
         throw RxObjectMapperError.parsingError
         }
         
         return parsedArray
         }
         }
         }
         
         
         
         //豆瓣接口模型
         class Douban: Mappable {
         //频道列表
         var channels: [Channel]?
         
         init(){
         }
         
         required init?(map: Map) {
         }
         
         // Mappable
         func mapping(map: Map) {
         channels <- map["channels"]
         }
         }
         
         //频道模型
         class Channel: Mappable {
         var name: String?
         var nameEn:String?
         var channelId: String?
         var seqId: Int?
         var abbrEn: String?
         
         init(){
         }
         
         required init?(map: Map) {
         }
         
         // Mappable
         func mapping(map: Map) {
         name <- map["name"]
         nameEn <- map["name_en"]
         channelId <- map["channel_id"]
         seqId <- map["seq_id"]
         abbrEn <- map["abbr_en"]
         }
         }
         
         
         
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //创建并发起请求
         requestJSON(.get, url)
         .map{$1}
         .mapObject(type: Douban.self)
         .subscribe(onNext: { (douban: Douban) in
         if let channels = douban.channels {
         print("--- 共\(channels.count)个频道 ---")
         for channel in channels {
         if let name = channel.name, let channelId = channel.channelId {
         print("\(name) （id:\(channelId)）")
         }
         }
         }
         }).disposed(by: disposeBag)
         
         
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //创建URL对象
         let urlString = "https://www.douban.com/j/app/radio/channels"
         let url = URL(string:urlString)!
         
         //获取列表数据
         let data = requestJSON(.get, url)
         .map{$1}
         .mapObject(type: Douban.self)
         .map{ $0.channels ?? []}
         
         //将数据绑定到表格
         data.bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(row)：\(element.name!)"
         return cell
         }.disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===RxAlamofire使用：文件上传===
        /*
         Alamofire 支持如下上传类型：
         
         File
         Data
         Stream
         MultipartFormData
         */
        // TODO:使用文件流的形式上传文件:
        /*
         //需要上传的文件路径
         let fileURL = Bundle.main.url(forResource: "hangge", withExtension: "zip")
         //服务器路径
         let uploadURL = URL(string: "http://www.hangge.com/upload.php")!
         
         //将文件上传到服务器
         upload(fileURL!, urlRequest: try! urlRequest(.post, uploadURL))
         .subscribe(onCompleted: {
         print("上传完毕!")
         })
         .disposed(by: disposeBag)
         
         在上传时附带上文件名:
         将文件名以参数的形式跟在链接后面。比如：http://hangge.com/upload.php?fileName=image1.png
         */
        
        // TODO:获得上传进度:
        /*
         不断地打印当前进度、已上传部分的大小、以及文件总大小（单位都是字节）
         
         //需要上传的文件路径
         let fileURL = Bundle.main.url(forResource: "hangge", withExtension: "zip")
         //服务器路径
         let uploadURL = URL(string: "http://www.hangge.com/upload.php")!
         
         //将文件上传到服务器
         upload(fileURL!, urlRequest: try! urlRequest(.post, uploadURL))
         .subscribe(onNext: { element in
         print("--- 开始上传 ---")
         element.uploadProgress(closure: { (progress) in
         print("当前进度：\(progress.fractionCompleted)")
         print("  已上传载：\(progress.completedUnitCount/1024)KB")
         print("  总大小：\(progress.totalUnitCount/1024)KB")
         })
         }, onError: { error in
         print("上传失败! 失败原因：\(error)")
         }, onCompleted: {
         print("上传完毕!")
         })
         .disposed(by: disposeBag)
         
         
         将进度转成可观察序列，并绑定到进度条上显示:
         //需要上传的文件路径
         let fileURL = Bundle.main.url(forResource: "hangge", withExtension: "zip")
         //服务器路径
         let uploadURL = URL(string: "http://www.hangge.com/upload.php")!
         
         //将文件上传到服务器
         upload(fileURL!, urlRequest: try! urlRequest(.post, uploadURL))
         .map{request in
         //返回一个关于进度的可观察序列
         Observable<Float>.create{observer in
         request.uploadProgress(closure: { (progress) in
         observer.onNext(Float(progress.fractionCompleted))
         if progress.isFinished{
         observer.onCompleted()
         }
         })
         return Disposables.create()
         }
         }
         .flatMap{$0}
         .bind(to: progressView.rx.progress) //将进度绑定UIProgressView上
         .disposed(by: disposeBag)
         */
        
        // TODO:上传 MultipartFormData 类型的文件数据（类似于网页上 Form 表单里的文件提交）:
        /*
         上传两个文件:
         //需要上传的文件
         let fileURL1 = Bundle.main.url(forResource: "0", withExtension: "png")
         let fileURL2 = Bundle.main.url(forResource: "1", withExtension: "png")
         
         //服务器路径
         let uploadURL = URL(string: "http://www.hangge.com/upload2.php")!
         
         //将文件上传到服务器
         upload(
         multipartFormData: { multipartFormData in
         multipartFormData.append(fileURL1!, withName: "file1")
         multipartFormData.append(fileURL2!, withName: "file2")
         },
         to: uploadURL,
         encodingCompletion: { encodingResult in
         switch encodingResult {
         case .success(let upload, _, _):
         upload.responseJSON { response in
         debugPrint(response)
         }
         case .failure(let encodingError):
         print(encodingError)
         }
         })
         
         
         文本参数与文件一起提交（文件除了可以使用 fileURL，还可以上传 Data 类型的文件数据:
         //字符串
         let strData = "hangge.com".data(using: String.Encoding.utf8)
         //数字
         let intData = String(10).data(using: String.Encoding.utf8)
         //文件1
         let path = Bundle.main.url(forResource: "0", withExtension: "png")!
         let file1Data = try! Data(contentsOf: path)
         //文件2
         let file2URL = Bundle.main.url(forResource: "1", withExtension: "png")
         
         //服务器路径
         let uploadURL = URL(string: "http://www.hangge.com/upload2.php")!
         
         //将文件上传到服务器
         upload(
         multipartFormData: { multipartFormData in
         multipartFormData.append(strData!, withName: "value1")
         multipartFormData.append(intData!, withName: "value2")
         multipartFormData.append(file1Data, withName: "file1",
         fileName: "php.png", mimeType: "image/png")
         multipartFormData.append(file2URL!, withName: "file2")
         },
         to: uploadURL,
         encodingCompletion: { encodingResult in
         switch encodingResult {
         case .success(let upload, _, _):
         upload.responseJSON { response in
         debugPrint(response)
         }
         case .failure(let encodingError):
         print(encodingError)
         }
         })
         */
        
        // TODO:===RxAlamofire使用：文件下载===
        // TODO:自定义下载文件的保存目录:
        /*
         下面代码将 logo 图片下载下来，并保存到用户文档目录下（Documnets 目录），文件名不变：
         //指定下载路径（文件名不变）
         let destination: DownloadRequest.DownloadFileDestination = { _, response in
         let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
         let fileURL = documentsURL.appendingPathComponent(response.suggestedFilename!)
         //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
         return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
         }
         
         //需要下载的文件
         let fileURL = URL(string: "http://www.hangge.com/blog/images/logo.png")!
         
         //开始下载
         download(URLRequest(url: fileURL), to: destination)
         .subscribe(onNext: { element in
         print("开始下载。")
         }, onError: { error in
         print("下载失败! 失败原因：\(error)")
         }, onCompleted: {
         print("下载完毕!")
         })
         .disposed(by: disposeBag)
         
         
         将 logo 图片下载下来，并保存到用户文档目录下的 file1 子目录（ Documnets/file1 目录），文件名改成 myLogo.png:
         //指定下载路径和保存文件名
         let destination: DownloadRequest.DownloadFileDestination = { _, _ in
         let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
         let fileURL = documentsURL.appendingPathComponent("file1/myLogo.png")
         //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
         return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
         }
         
         //需要下载的文件
         let fileURL = URL(string: "http://www.hangge.com/blog/images/logo.png")!
         
         //开始下载
         download(URLRequest(url: fileURL), to: destination)
         .subscribe(onNext: { element in
         print("开始下载。")
         }, onError: { error in
         print("下载失败! 失败原因：\(error)")
         }, onCompleted: {
         print("下载完毕!")
         })
         .disposed(by: disposeBag)
         */
        
        // TODO:使用默认提供的下载路径:
        /*
         使用这种方式如果下载路径下有同名文件，不会覆盖原来的文件
         let destination = DownloadRequest.suggestedDownloadDestination(for: .documentDirectory)
         
         下载进度:
         //开始下载
         download(URLRequest(url: fileURL), to: destination)
         .subscribe(onNext: { element in
         print("开始下载。")
         element.downloadProgress(closure: { progress in
         print("当前进度: \(progress.fractionCompleted)")
         print("  已下载：\(progress.completedUnitCount/1024)KB")
         print("  总大小：\(progress.totalUnitCount/1024)KB")
         })
         }, onError: { error in
         print("下载失败! 失败原因：\(error)")
         }, onCompleted: {
         print("下载完毕!")
         }).disposed(by: disposeBag)
         
         将进度转成可观察序列，并绑定到进度条上显示:
         download(URLRequest(url: fileURL), to: destination)
         .map{request in
         //返回一个关于进度的可观察序列
         Observable<Float>.create{observer in
         request.downloadProgress(closure: { (progress) in
         observer.onNext(Float(progress.fractionCompleted))
         if progress.isFinished{
         observer.onCompleted()
         }
         })
         return Disposables.create()
         }
         }
         .flatMap{$0}
         .bind(to: progressView.rx.progress) //将进度绑定UIProgressView上
         .disposed(by: disposeBag)
         */
        
        // TODO:===Moya使用：数据请求===
        /*
         Moya 是一个基于 Alamofire 的更高层网络请求封装抽象层。它可以对我们项目中的所有请求进行集中管理
         */
        // TODO:网络请求层:
        /*
         我们先创建一个 DouBanAPI.swift 文件作为网络请求层，里面的内容如下：
         
         首先定义一个 provider，即请求发起对象。往后我们如果要发起网络请求就使用这个 provider。
         接着声明一个 enum 来对请求进行明确分类，这里我们定义两个枚举值分别表示获取频道列表、获取歌曲信息。
         最后让这个 enum 实现 TargetType 协议，在这里面定义我们各个请求的 url、参数、header 等信息
         
         import Foundation
         import Moya
         import RxMoya
         
         //初始化豆瓣FM请求的provider
         let DouBanProvider = MoyaProvider<DouBanAPI>()
         
         /** 下面定义豆瓣FM请求的endpoints（供provider使用）**/
         //请求分类
         public enum DouBanAPI {
         case channels  //获取频道列表
         case playlist(String) //获取歌曲
         }
         
         //请求配置
         extension DouBanAPI: TargetType {
         //服务器地址
         public var baseURL: URL {
         switch self {
         case .channels:
         return URL(string: "https://www.douban.com")!
         case .playlist(_):
         return URL(string: "https://douban.fm")!
         }
         }
         
         //各个请求的具体路径
         public var path: String {
         switch self {
         case .channels:
         return "/j/app/radio/channels"
         case .playlist(_):
         return "/j/mine/playlist"
         }
         }
         
         //请求类型
         public var method: Moya.Method {
         return .get
         }
         
         //请求任务事件（这里附带上参数）
         public var task: Task {
         switch self {
         case .playlist(let channel):
         var params: [String: Any] = [:]
         params["channel"] = channel
         params["type"] = "n"
         params["from"] = "mainsite"
         return .requestParameters(parameters: params,
         encoding: URLEncoding.default)
         default:
         return .requestPlain
         }
         }
         
         //是否执行Alamofire验证
         public var validate: Bool {
         return false
         }
         
         //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
         public var sampleData: Data {
         return "{}".data(using: String.Encoding.utf8)!
         }
         
         //请求头
         public var headers: [String: String]? {
         return nil
         }
         }
         
         
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //获取数据
         DouBanProvider.rx.request(.channels)
         .subscribe { event in
         switch event {
         case let .success(response):
         //数据处理
         let str = String(data: response.data, encoding: String.Encoding.utf8)
         print("返回的数据是：", str ?? "")
         case let .error(error):
         print("数据请求失败!错误原因：", error)
         }
         }.disposed(by: disposeBag)
         }
         }
         
         还可以换种方式写：
         import UIKit
         import RxSwift
         import RxCocoa
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //获取数据
         DouBanProvider.rx.request(.channels)
         .subscribe(onSuccess: { response in
         //数据处理
         let str = String(data: response.data, encoding: String.Encoding.utf8)
         print("返回的数据是：", str ?? "")
         },onError: { error in
         print("数据请求失败!错误原因：", error)
         }).disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===Moya使用：结果处理、模型转换===
        // TODO:将结果转为 JSON 对象:
        /*
         如果服务器返回的数据是 json 格式的话，直接通过 Moya 提供的 mapJSON 方法即可将其转成 JSON 对象
         //获取数据
         DouBanProvider.rx.request(.channels)
         .subscribe(onSuccess: { response in
         //数据处理
         let json = try? response.mapJSON() as! [String: Any]
         print("--- 请求成功！返回的如下数据 ---")
         print(json!)
         },onError: { error in
         print("数据请求失败!错误原因：", error)
         
         }).disposed(by: disposeBag)
         
         种写法也是可以的:
         //获取数据
         DouBanProvider.rx.request(.channels)
         .mapJSON()
         .subscribe(onSuccess: { data in
         //数据处理
         let json = data as! [String: Any]
         print("--- 请求成功！返回的如下数据 ---")
         print(json)
         },onError: { error in
         print("数据请求失败!错误原因：", error)
         
         }).disposed(by: disposeBag)
         
         */
        
        /*
         class ViewController: UIViewController {
         
         //显示频道列表的tableView
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表视图
         self.tableView = UITableView(frame:self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //获取列表数据
         let data = DouBanProvider.rx.request(.channels)
         .mapJSON()
         .map{ data -> [[String: Any]] in
         if let json = data as? [String: Any],
         let channels = json["channels"] as? [[String: Any]] {
         return channels
         }else{
         return []
         }
         }.asObservable()
         
         //将数据绑定到表格
         data.bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(element["name"]!)"
         cell.accessoryType = .disclosureIndicator
         return cell
         }.disposed(by: disposeBag)
         
         //单元格点击
         tableView.rx.modelSelected([String: Any].self)
         .map{ $0["channel_id"] as! String }
         .flatMap{ DouBanProvider.rx.request(.playlist($0)) }
         .mapJSON()
         .subscribe(onNext: {[weak self] data in
         //解析数据，获取歌曲信息
         if let json = data as? [String: Any],
         let musics = json["song"] as? [[String: Any]]{
         let artist = musics[0]["artist"]!
         let title = musics[0]["title"]!
         let message = "歌手：\(artist)\n歌曲：\(title)"
         //将歌曲信息弹出显示
         self?.showAlert(title: "歌曲信息", message: message)
         }
         }).disposed(by: disposeBag)
         }
         
         //显示消息
         func showAlert(title:String, message:String){
         let alertController = UIAlertController(title: title,
         message: message, preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
         }
         
         }
         */
        
        // TODO:将结果映射成自定义对象:
        /*
         为了让 ObjectMapper 能够更好地与 Moya 配合使用，我们需要使用 Moya-ObjectMapper 这个 Observable 扩展库。它的作用是增加数据转模型对象、以及数据转模型对象数组这两个方法
         
         //豆瓣接口模型
         struct Douban: Mappable {
         //频道列表
         var channels: [Channel]?
         
         init?(map: Map) { }
         
         // Mappable
         mutating func mapping(map: Map) {
         channels <- map["channels"]
         }
         }
         
         //频道模型
         struct Channel: Mappable {
         var name: String?
         var nameEn:String?
         var channelId: String?
         var seqId: Int?
         var abbrEn: String?
         
         init?(map: Map) { }
         
         // Mappable
         mutating func mapping(map: Map) {
         name <- map["name"]
         nameEn <- map["name_en"]
         channelId <- map["channel_id"]
         seqId <- map["seq_id"]
         abbrEn <- map["abbr_en"]
         }
         }
         
         //歌曲列表模型
         struct Playlist: Mappable {
         var r: Int!
         var isShowQuickStart: Int!
         var song:[Song]!
         
         init?(map: Map) { }
         
         // Mappable
         mutating func mapping(map: Map) {
         r <- map["r"]
         isShowQuickStart <- map["is_show_quick_start"]
         song <- map["song"]
         }
         }
         
         //歌曲模型
         struct Song: Mappable {
         var title: String!
         var artist: String!
         
         init?(map: Map) { }
         
         // Mappable
         mutating func mapping(map: Map) {
         title <- map["title"]
         artist <- map["artist"]
         }
         }
         
         
         //获取数据
         DouBanProvider.rx.request(.channels)
         .mapObject(Douban.self)
         .subscribe(onSuccess: { douban in
         if let channels = douban.channels {
         print("--- 共\(channels.count)个频道 ---")
         for channel in channels {
         if let name = channel.name, let channelId = channel.channelId {
         print("\(name) （id:\(channelId)）")
         }
         }
         }
         }, onError: { error in
         print("数据请求失败!错误原因：", error)
         })
         .disposed(by: disposeBag)
         
         
         
         class ViewController: UIViewController {
         
         //显示频道列表的tableView
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表视图
         self.tableView = UITableView(frame:self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //获取列表数据
         let data = DouBanProvider.rx.request(.channels)
         .mapObject(Douban.self)
         .map{ $0.channels ?? [] }
         .asObservable()
         
         //将数据绑定到表格
         data.bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(element.name!)"
         cell.accessoryType = .disclosureIndicator
         return cell
         }.disposed(by: disposeBag)
         
         //单元格点击
         tableView.rx.modelSelected(Channel.self)
         .map{ $0.channelId! }
         .flatMap{ DouBanProvider.rx.request(.playlist($0)) }
         .mapObject(Playlist.self)
         .subscribe(onNext: {[weak self] playlist in
         //解析数据，获取歌曲信息
         if playlist.song.count > 0 {
         let artist = playlist.song[0].artist!
         let title = playlist.song[0].title!
         let message = "歌手：\(artist)\n歌曲：\(title)"
         //将歌曲信息弹出显示
         self?.showAlert(title: "歌曲信息", message: message)
         }
         }).disposed(by: disposeBag)
         }
         
         //显示消息
         func showAlert(title:String, message:String){
         let alertController = UIAlertController(title: title,
         message: message, preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
         }
         }
         */
        
        // TODO:功能改进：将网络请求服务提取出来:
        /*
         上面的样例中我们是在 VC 里是直接调用 Moya 的 Provider 进行数据请求，并进行模型转换。
         我们也可以把网络请求和数据转换相关代码提取出来，作为一个专门的 Service。比如 DouBanNetworkService
         
         class DouBanNetworkService {
         
         //获取频道数据
         func loadChannels() -> Observable<[Channel]> {
         return DouBanProvider.rx.request(.channels)
         .mapObject(Douban.self)
         .map{ $0.channels ?? [] }
         .asObservable()
         }
         
         //获取歌曲列表数据
         func loadPlaylist(channelId:String) -> Observable<Playlist> {
         return DouBanProvider.rx.request(.playlist(channelId))
         .mapObject(Playlist.self)
         .asObservable()
         }
         
         //获取频道下第一首歌曲
         func loadFirstSong(channelId:String) -> Observable<Song> {
         return loadPlaylist(channelId: channelId)
         .filter{ $0.song.count > 0}
         .map{ $0.song[0] }
         }
         }
         
         
         
         class ViewController: UIViewController {
         
         //显示频道列表的tableView
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表视图
         self.tableView = UITableView(frame:self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //豆瓣网络请求服务
         let networkService = DouBanNetworkService()
         
         //获取列表数据
         let data = networkService.loadChannels()
         
         //将数据绑定到表格
         data.bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(element.name!)"
         cell.accessoryType = .disclosureIndicator
         return cell
         }.disposed(by: disposeBag)
         
         //单元格点击
         tableView.rx.modelSelected(Channel.self)
         .map{ $0.channelId! }
         .flatMap(networkService.loadFirstSong)
         .subscribe(onNext: {[weak self] song in
         //将歌曲信息弹出显示
         let message = "歌手：\(song.artist!)\n歌曲：\(song.title!)"
         self?.showAlert(title: "歌曲信息", message: message)
         }).disposed(by: disposeBag)
         }
         
         //显示消息
         func showAlert(title:String, message:String){
         let alertController = UIAlertController(title: title,
         message: message, preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
         }
         }
         */
        
        // TODO:===MVVM架构演示：使用Observable样例===
        /*
         首先定义一个 provider，即请求发起对象。往后我们如果要发起网络请求就使用这个 provider。
         接着声明一个 enum 来对请求进行明确分类，这里我们只有一个枚举值表示查询资源。
         最后让这个 enum 实现 TargetType 协议，在这里面定义我们各个请求的 url、参数、header 等信息
         
         //初始化GitHub请求的provider
         let GitHubProvider = MoyaProvider<GitHubAPI>()
         
         /** 下面定义GitHub请求的endpoints（供provider使用）**/
         //请求分类
         public enum GitHubAPI {
         case repositories(String)  //查询资源库
         }
         
         //请求配置
         extension GitHubAPI: TargetType {
         //服务器地址
         public var baseURL: URL {
         return URL(string: "https://api.github.com")!
         }
         
         //各个请求的具体路径
         public var path: String {
         switch self {
         case .repositories:
         return "/search/repositories"
         }
         }
         
         //请求类型
         public var method: Moya.Method {
         return .get
         }
         
         //请求任务事件（这里附带上参数）
         public var task: Task {
         print("发起请求。")
         switch self {
         case .repositories(let query):
         var params: [String: Any] = [:]
         params["q"] = query
         params["sort"] = "stars"
         params["order"] = "desc"
         return .requestParameters(parameters: params,
         encoding: URLEncoding.default)
         default:
         return .requestPlain
         }
         }
         
         //是否执行Alamofire验证
         public var validate: Bool {
         return false
         }
         
         //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
         public var sampleData: Data {
         return "{}".data(using: String.Encoding.utf8)!
         }
         
         //请求头
         public var headers: [String: String]? {
         return nil
         }
         }
         
         
         //包含查询返回的所有库模型
         struct GitHubRepositories: Mappable {
         var totalCount: Int!
         var incompleteResults: Bool!
         var items: [GitHubRepository]! //本次查询返回的所有仓库集合
         
         init() {
         print("init()")
         totalCount = 0
         incompleteResults = false
         items = []
         }
         
         init?(map: Map) { }
         
         // Mappable
         mutating func mapping(map: Map) {
         totalCount <- map["total_count"]
         incompleteResults <- map["incomplete_results"]
         items <- map["items"]
         }
         }
         
         //单个仓库模型
         struct GitHubRepository: Mappable {
         var id: Int!
         var name: String!
         var fullName:String!
         var htmlUrl:String!
         var description:String!
         
         init?(map: Map) { }
         
         // Mappable
         mutating func mapping(map: Map) {
         id <- map["id"]
         name <- map["name"]
         fullName <- map["full_name"]
         htmlUrl <- map["html_url"]
         description <- map["description"]
         }
         }
         
         
         我们创建一个 ViewModel，它的作用就是将用户各种输入行为，转换成输出状态。本样例中，不管输入还是输出都是 Observable 类型:
         class ViewModel {
         /**** 输入部分 ***/
         //查询行为
         fileprivate let searchAction:Observable<String>
         
         /**** 输出部分 ***/
         //所有的查询结果
         let searchResult: Observable<GitHubRepositories>
         
         //查询结果里的资源列表
         let repositories: Observable<[GitHubRepository]>
         
         //清空结果动作
         let cleanResult: Observable<Void>
         
         //导航栏标题
         let navigationTitle: Observable<String>
         
         //ViewModel初始化（根据输入实现对应的输出）
         init(searchAction:Observable<String>) {
         self.searchAction = searchAction
         
         //生成查询结果序列
         self.searchResult = searchAction
         .filter { !$0.isEmpty } //如果输入为空则不发送请求了
         .flatMapLatest{
         GitHubProvider.rx.request(.repositories($0))
         .filterSuccessfulStatusCodes()
         .mapObject(GitHubRepositories.self)
         .asObservable()
         .catchError({ error in
         print("发生错误：",error.localizedDescription)
         return Observable<GitHubRepositories>.empty()
         })
         }.share(replay: 1) //让HTTP请求是被共享的
         
         //生成清空结果动作序列
         self.cleanResult = searchAction.filter{ $0.isEmpty }.map{ _ in Void() }
         
         //生成查询结果里的资源列表序列（如果查询到结果则返回结果，如果是清空数据则返回空数组）
         self.repositories = Observable.of(searchResult.map{ $0.items },
         cleanResult.map{[]}).merge()
         
         //生成导航栏标题序列（如果查询到结果则返回数量，如果是清空数据则返回默认标题）
         self.navigationTitle = Observable.of(
         searchResult.map{ "共有 \($0.totalCount!) 个结果" },
         cleanResult.map{ "hangge.com" })
         .merge()
         }
         }
         
         
         最后我们视图控制器（ViewController）只需要调用 ViewModel 进行数据绑定就可以了。可以看到由于网络请求、数据处理等逻辑已经被剥离到 ViewModel 中，VC 这边的负担大大减轻了。
         import UIKit
         import RxSwift
         import RxCocoa
         
         class ViewController: UIViewController {
         
         //显示资源列表的tableView
         var tableView:UITableView!
         
         //搜索栏
         var searchBar:UISearchBar!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表视图
         self.tableView = UITableView(frame:self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //创建表头的搜索栏
         self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0,
         width: self.view.bounds.size.width, height: 56))
         self.tableView.tableHeaderView =  self.searchBar
         
         //查询条件输入
         let searchAction = searchBar.rx.text.orEmpty
         .throttle(0.5, scheduler: MainScheduler.instance) //只有间隔超过0.5k秒才发送
         .distinctUntilChanged()
         .asObservable()
         
         //初始化ViewModel
         let viewModel = ViewModel(searchAction: searchAction)
         
         //绑定导航栏标题数据
         viewModel.navigationTitle.bind(to: self.navigationItem.rx.title).disposed(by: disposeBag)
         
         //将数据绑定到表格
         viewModel.repositories.bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
         cell.textLabel?.text = element.name
         cell.detailTextLabel?.text = element.htmlUrl
         return cell
         }.disposed(by: disposeBag)
         
         //单元格点击
         tableView.rx.modelSelected(GitHubRepository.self)
         .subscribe(onNext: {[weak self] item in
         //显示资源信息（完整名称和描述信息）
         self?.showAlert(title: item.fullName, message: item.description)
         }).disposed(by: disposeBag)
         }
         
         //显示消息
         func showAlert(title:String, message:String){
         let alertController = UIAlertController(title: title,
         message: message, preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
         }

         }
         */
        
        // TODO:功能改进：将网络请求服务提取出来:
        /*
         我们也可以把网络请求和数据转换相关代码提取出来，作为一个专门的 Service
         class GitHubNetworkService {
         
         //搜索资源数据
         func searchRepositories(query:String) -> Observable<GitHubRepositories> {
         return GitHubProvider.rx.request(.repositories(query))
         .filterSuccessfulStatusCodes()
         .mapObject(GitHubRepositories.self)
         .asObservable()
         .catchError({ error in
         print("发生错误：",error.localizedDescription)
         return Observable<GitHubRepositories>.empty()
         })
         }
         }
         
         
         class ViewModel {
         /**** 数据请求服务 ***/
         let networkService = GitHubNetworkService()
         
         /**** 输入部分 ***/
         //查询行为
         fileprivate let searchAction:Observable<String>
         
         /**** 输出部分 ***/
         //所有的查询结果
         let searchResult: Observable<GitHubRepositories>
         
         //查询结果里的资源列表
         let repositories: Observable<[GitHubRepository]>
         
         //清空结果动作
         let cleanResult: Observable<Void>
         
         //导航栏标题
         let navigationTitle: Observable<String>
         
         //ViewModel初始化（根据输入实现对应的输出）
         init(searchAction:Observable<String>) {
         self.searchAction = searchAction
         
         //生成查询结果序列
         self.searchResult = searchAction
         .filter { !$0.isEmpty } //如果输入为空则不发送请求了
         .flatMapLatest(networkService.searchRepositories)
         .share(replay: 1) //让HTTP请求是被共享的
         
         //生成清空结果动作序列
         self.cleanResult = searchAction.filter{ $0.isEmpty }.map{ _ in Void() }
         
         //生成查询结果里的资源列表序列（如果查询到结果则返回结果，如果是清空数据则返回空数组）
         self.repositories = Observable.of(searchResult.map{ $0.items },
         cleanResult.map{[]}).merge()
         
         //生成导航栏标题序列（如果查询到结果则返回数量，如果是清空数据则返回默认标题）
         self.navigationTitle = Observable.of(
         searchResult.map{ "共有 \($0.totalCount!) 个结果" },
         cleanResult.map{"hangge.com"})
         .merge()
         }
         }
         */
        
        // TODO:===MVVM架构演示：使用Driver样例===
        /*
         //初始化GitHub请求的provider
         let GitHubProvider = MoyaProvider<GitHubAPI>()
         
         /** 下面定义GitHub请求的endpoints（供provider使用）**/
         //请求分类
         public enum GitHubAPI {
         case repositories(String)  //查询资源库
         }
         
         //请求配置
         extension GitHubAPI: TargetType {
         //服务器地址
         public var baseURL: URL {
         return URL(string: "https://api.github.com")!
         }
         
         //各个请求的具体路径
         public var path: String {
         switch self {
         case .repositories:
         return "/search/repositories"
         }
         }
         
         //请求类型
         public var method: Moya.Method {
         return .get
         }
         
         //请求任务事件（这里附带上参数）
         public var task: Task {
         print("发起请求。")
         switch self {
         case .repositories(let query):
         var params: [String: Any] = [:]
         params["q"] = query
         params["sort"] = "stars"
         params["order"] = "desc"
         return .requestParameters(parameters: params,
         encoding: URLEncoding.default)
         default:
         return .requestPlain
         }
         }
         
         //是否执行Alamofire验证
         public var validate: Bool {
         return false
         }
         
         //这个就是做单元测试模拟的数据，只会在单元测试文件中有作用
         public var sampleData: Data {
         return "{}".data(using: String.Encoding.utf8)!
         }
         
         //请求头
         public var headers: [String: String]? {
         return nil
         }
         }
         
         
         //包含查询返回的所有库模型
         struct GitHubRepositories: Mappable {
         var totalCount: Int!
         var incompleteResults: Bool!
         var items: [GitHubRepository]! //本次查询返回的所有仓库集合
         
         init() {
         print("init()")
         totalCount = 0
         incompleteResults = false
         items = []
         }
         
         init?(map: Map) { }
         
         // Mappable
         mutating func mapping(map: Map) {
         totalCount <- map["total_count"]
         incompleteResults <- map["incomplete_results"]
         items <- map["items"]
         }
         }
         
         //单个仓库模型
         struct GitHubRepository: Mappable {
         var id: Int!
         var name: String!
         var fullName:String!
         var htmlUrl:String!
         var description:String!
         
         init?(map: Map) { }
         
         // Mappable
         mutating func mapping(map: Map) {
         id <- map["id"]
         name <- map["name"]
         fullName <- map["full_name"]
         htmlUrl <- map["html_url"]
         description <- map["description"]
         }
         }
         
         
         class ViewModel {
         /**** 输入部分 ***/
         //查询行为
         fileprivate let searchAction:Driver<String>
         
         /**** 输出部分 ***/
         //所有的查询结果
         let searchResult: Driver<GitHubRepositories>
         
         //查询结果里的资源列表
         let repositories: Driver<[GitHubRepository]>
         
         //清空结果动作
         let cleanResult: Driver<Void>
         
         //导航栏标题
         let navigationTitle: Driver<String>
         
         //ViewModel初始化（根据输入实现对应的输出）
         init(searchAction:Driver<String>) {
         self.searchAction = searchAction
         
         //生成查询结果序列
         self.searchResult = searchAction
         .filter { !$0.isEmpty } //如果输入为空则不发送请求了
         .flatMapLatest{
         GitHubProvider.rx.request(.repositories($0))
         .filterSuccessfulStatusCodes()
         .mapObject(GitHubRepositories.self)
         .asDriver(onErrorDriveWith: Driver.empty())
         }
         
         //生成清空结果动作序列
         self.cleanResult = searchAction.filter{ $0.isEmpty }.map{ _ in Void() }
         
         //生成查询结果里的资源列表序列（如果查询到结果则返回结果，如果是清空数据则返回空数组）
         self.repositories = Driver.merge(
         searchResult.map{ $0.items },
         cleanResult.map{[]}
         )
         
         //生成导航栏标题序列（如果查询到结果则返回数量，如果是清空数据则返回默认标题）
         self.navigationTitle = Driver.merge(
         searchResult.map{ "共有 \($0.totalCount!) 个结果" },
         cleanResult.map{ "hangge.com" }
         )
         }
         }
         
         
         class ViewController: UIViewController {
         
         //显示资源列表的tableView
         var tableView:UITableView!
         
         //搜索栏
         var searchBar:UISearchBar!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表视图
         self.tableView = UITableView(frame:self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //创建表头的搜索栏
         self.searchBar = UISearchBar(frame: CGRect(x: 0, y: 0,
         width: self.view.bounds.size.width, height: 56))
         self.tableView.tableHeaderView =  self.searchBar
         
         //查询条件输入
         let searchAction = searchBar.rx.text.orEmpty.asDriver()
         .throttle(0.5) //只有间隔超过0.5k秒才发送
         .distinctUntilChanged()
         
         //初始化ViewModel
         let viewModel = ViewModel(searchAction: searchAction)
         
         //绑定导航栏标题数据
         viewModel.navigationTitle.drive(self.navigationItem.rx.title).disposed(by: disposeBag)
         
         //将数据绑定到表格
         viewModel.repositories.drive(tableView.rx.items) { (tableView, row, element) in
         let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
         cell.textLabel?.text = element.name
         cell.detailTextLabel?.text = element.htmlUrl
         return cell
         }.disposed(by: disposeBag)
         
         //单元格点击
         tableView.rx.modelSelected(GitHubRepository.self)
         .subscribe(onNext: {[weak self] item in
         //显示资源信息（完整名称和描述信息）
         self?.showAlert(title: item.fullName, message: item.description)
         }).disposed(by: disposeBag)
         }
         
         //显示消息
         func showAlert(title:String, message:String){
         let alertController = UIAlertController(title: title,
         message: message, preferredStyle: .alert)
         let cancelAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
         alertController.addAction(cancelAction)
         self.present(alertController, animated: true, completion: nil)
         }
         
         override func didReceiveMemoryWarning() {
         super.didReceiveMemoryWarning()
         }
         }
         
         将网络请求服务提取出来:
         class GitHubNetworkService {
         
         //搜索资源数据
         func searchRepositories(query:String) -> Driver<GitHubRepositories> {
         return GitHubProvider.rx.request(.repositories(query))
         .filterSuccessfulStatusCodes()
         .mapObject(GitHubRepositories.self)
         .asDriver(onErrorDriveWith: Driver.empty())
         }
         }
         
         class ViewModel {
         /**** 数据请求服务 ***/
         let networkService = GitHubNetworkService()
         
         /**** 输入部分 ***/
         //查询行为
         fileprivate let searchAction:Driver<String>
         
         /**** 输出部分 ***/
         //所有的查询结果
         let searchResult: Driver<GitHubRepositories>
         
         //查询结果里的资源列表
         let repositories: Driver<[GitHubRepository]>
         
         //清空结果动作
         let cleanResult: Driver<Void>
         
         //导航栏标题
         let navigationTitle: Driver<String>
         
         //ViewModel初始化（根据输入实现对应的输出）
         init(searchAction:Driver<String>) {
         self.searchAction = searchAction
         
         //生成查询结果序列
         self.searchResult = searchAction
         .filter { !$0.isEmpty } //如果输入为空则不发送请求了
         .flatMapLatest(networkService.searchRepositories)
         
         //生成清空结果动作序列
         self.cleanResult = searchAction.filter{ $0.isEmpty }.map{ _ in Void() }
         
         //生成查询结果里的资源列表序列（如果查询到结果则返回结果，如果是清空数据则返回空数组）
         self.repositories = Driver.merge(
         searchResult.map{ $0.items },
         cleanResult.map{[]}
         )
         
         //生成导航栏标题序列（如果查询到结果则返回数量，如果是清空数据则返回默认标题）
         self.navigationTitle = Driver.merge(
         searchResult.map{ "共有 \($0.totalCount!) 个结果" },
         cleanResult.map{ "hangge.com" }
         )
         }
         }
         */
    
        // TODO:===用户注册===
        /*
         class GitHubNetworkService {
         
         //验证用户是否存在
         func usernameAvailable(_ username: String) -> Observable<Bool> {
         //通过检查这个用户的GitHub主页是否存在来判断用户是否存在
         let url = URL(string: "https://github.com/\(username.URLEscaped)")!
         let request = URLRequest(url: url)
         return URLSession.shared.rx.response(request: request)
         .map { pair in
         //如果不存在该用户主页，则说明这个用户名可用
         return pair.response.statusCode == 404
         }
         .catchErrorJustReturn(false)
         }
         
         //注册用户
         func signup(_ username: String, password: String) -> Observable<Bool> {
         //这里我们没有真正去发起请求，而是模拟这个操作（平均每3次有1次失败）
         let signupResult = arc4random() % 3 == 0 ? false : true
         return Observable.just(signupResult)
         .delay(1.5, scheduler: MainScheduler.instance) //结果延迟1.5秒返回
         }
         }
         
         //扩展String
         extension String {
         //字符串的url地址转义
         var URLEscaped: String {
         return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) ?? ""
         }
         }
         
         
         用户注册验证服务:
         首先定义一个用于表示验证结果和信息的枚举（ValidationResult），后面我们会将它作为验证结果绑定到界面上。
         import UIKit
         
         //验证结果和信息的枚举
         enum ValidationResult {
         case validating  //正在验证中s
         case empty  //输入为空
         case ok(message: String) //验证通过
         case failed(message: String)  //验证失败
         }
         
         //扩展ValidationResult，对应不同的验证结果返回验证是成功还是失败
         extension ValidationResult {
         var isValid: Bool {
         switch self {
         case .ok:
         return true
         default:
         return false
         }
         }
         }
         
         //扩展ValidationResult，对应不同的验证结果返回不同的文字描述
         extension ValidationResult: CustomStringConvertible {
         var description: String {
         switch self {
         case .validating:
         return "正在验证..."
         case .empty:
         return ""
         case let .ok(message):
         return message
         case let .failed(message):
         return message
         }
         }
         }
         
         //扩展ValidationResult，对应不同的验证结果返回不同的文字颜色
         extension ValidationResult {
         var textColor: UIColor {
         switch self {
         case .validating:
         return UIColor.gray
         case .empty:
         return UIColor.black
         case .ok:
         return UIColor(red: 0/255, green: 130/255, blue: 0/255, alpha: 1)
         case .failed:
         return UIColor.red
         }
         }
         }
         
         
         
         接着将用户名、密码等各种需要用到的验证封装起来（GitHubSignupService.swift），方便后面使用。（返回的就是上面定义的 ValidationResult）
         //用户注册服务
         class GitHubSignupService {
         
         //密码最少位数
         let minPasswordCount = 5
         
         //网络请求服务
         lazy var networkService = {
         return GitHubNetworkService()
         }()
         
         //验证用户名
         func validateUsername(_ username: String) -> Observable<ValidationResult> {
         //判断用户名是否为空
         if username.isEmpty {
         return .just(.empty)
         }
         
         //判断用户名是否只有数字和字母
         if username.rangeOfCharacter(from: CharacterSet.alphanumerics.inverted) != nil {
         return .just(.failed(message: "用户名只能包含数字和字母"))
         }
         
         //发起网络请求检查用户名是否已存在
         return networkService
         .usernameAvailable(username)
         .map { available in
         //根据查询情况返回不同的验证结果
         if available {
         return .ok(message: "用户名可用")
         } else {
         return .failed(message: "用户名已存在")
         }
         }
         .startWith(.validating) //在发起网络请求前，先返回一个“正在检查”的验证结果
         }
         
         //验证密码
         func validatePassword(_ password: String) -> ValidationResult {
         let numberOfCharacters = password.count
         
         //判断密码是否为空
         if numberOfCharacters == 0 {
         return .empty
         }
         
         //判断密码位数
         if numberOfCharacters < minPasswordCount {
         return .failed(message: "密码至少需要 \(minPasswordCount) 个字符")
         }
         
         //返回验证成功的结果
         return .ok(message: "密码有效")
         }
         
         //验证二次输入的密码
         func validateRepeatedPassword(_ password: String, repeatedPassword: String)
         -> ValidationResult {
         //判断密码是否为空
         if repeatedPassword.count == 0 {
         return .empty
         }
         
         //判断两次输入的密码是否一致
         if repeatedPassword == password {
         return .ok(message: "密码有效")
         } else {
         return .failed(message: "两次输入的密码不一致")
         }
         }
         }
         
         
         ViewModel（GitHubSignupViewModel.swift），它的作用就是将用户各种输入行为，转换成输出状态:
         class GitHubSignupViewModel {
         
         //用户名验证结果
         let validatedUsername: Driver<ValidationResult>
         
         //密码验证结果
         let validatedPassword: Driver<ValidationResult>
         
         //再次输入密码验证结果
         let validatedPasswordRepeated: Driver<ValidationResult>
         
         //注册按钮是否可用
         let signupEnabled: Driver<Bool>
         
         //注册结果
         let signupResult: Driver<Bool>
         
         //ViewModel初始化（根据输入实现对应的输出）
         init(
         input: (
         username: Driver<String>,
         password: Driver<String>,
         repeatedPassword: Driver<String>,
         loginTaps: Signal<Void>
         ),
         dependency: (
         networkService: GitHubNetworkService,
         signupService: GitHubSignupService
         )) {
         
         //用户名验证
         validatedUsername = input.username
         .flatMapLatest { username in
         return dependency.signupService.validateUsername(username)
         .asDriver(onErrorJustReturn: .failed(message: "服务器发生错误!"))
         }
         
         //用户名密码验证
         validatedPassword = input.password
         .map { password in
         return dependency.signupService.validatePassword(password)
         }
         
         //重复输入密码验证
         validatedPasswordRepeated = Driver.combineLatest(
         input.password,
         input.repeatedPassword,
         resultSelector: dependency.signupService.validateRepeatedPassword)
         
         //注册按钮是否可用
         signupEnabled = Driver.combineLatest(
         validatedUsername,
         validatedPassword,
         validatedPasswordRepeated
         ) { username, password, repeatPassword in
         username.isValid && password.isValid && repeatPassword.isValid
         }
         .distinctUntilChanged()
         
         //获取最新的用户名和密码
         let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
         (username: $0, password: $1) }
         
         //注册按钮点击结果
         signupResult = input.loginTaps.withLatestFrom(usernameAndPassword)
         .flatMapLatest { pair in
         return dependency.networkService.signup(pair.username,
         password: pair.password)
         .asDriver(onErrorJustReturn: false)
         }
         }
         }
         
         ViewModel 与视图的绑定:
         首先为了让 ValidationResult 能绑定到 label 上，我们要对 UILabel 进行扩展（BindingExtensions.swift）
         import UIKit
         import RxSwift
         import RxCocoa
         
         //扩展UILabel
         extension Reactive where Base: UILabel {
         //让验证结果（ValidationResult类型）可以绑定到label上
         var validationResult: Binder<ValidationResult> {
         return Binder(base) { label, result in
         label.textColor = result.textColor
         label.text = result.description
         }
         }
         }
         
         
         class ViewController: UIViewController {
         //用户名输入框、以及验证结果显示标签
         @IBOutlet weak var usernameOutlet: UITextField!
         @IBOutlet weak var usernameValidationOutlet: UILabel!
         
         //密码输入框、以及验证结果显示标签
         @IBOutlet weak var passwordOutlet: UITextField!
         @IBOutlet weak var passwordValidationOutlet: UILabel!
         
         //重复密码输入框、以及验证结果显示标签
         @IBOutlet weak var repeatedPasswordOutlet: UITextField!
         @IBOutlet weak var repeatedPasswordValidationOutlet: UILabel!
         
         //注册按钮
         @IBOutlet weak var signupOutlet: UIButton!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //初始化ViewModel
         let viewModel = GitHubSignupViewModel(
         input: (
         username: usernameOutlet.rx.text.orEmpty.asDriver(),
         password: passwordOutlet.rx.text.orEmpty.asDriver(),
         repeatedPassword: repeatedPasswordOutlet.rx.text.orEmpty.asDriver(),
         loginTaps: signupOutlet.rx.tap.asSignal()
         ),
         dependency: (
         networkService: GitHubNetworkService(),
         signupService: GitHubSignupService()
         )
         )
         
         //用户名验证结果绑定
         viewModel.validatedUsername
         .drive(usernameValidationOutlet.rx.validationResult)
         .disposed(by: disposeBag)
         
         //密码验证结果绑定
         viewModel.validatedPassword
         .drive(passwordValidationOutlet.rx.validationResult)
         .disposed(by: disposeBag)
         
         //再次输入密码验证结果绑定
         viewModel.validatedPasswordRepeated
         .drive(repeatedPasswordValidationOutlet.rx.validationResult)
         .disposed(by: disposeBag)
         
         //注册按钮是否可用
         viewModel.signupEnabled
         .drive(onNext: { [weak self] valid  in
         self?.signupOutlet.isEnabled = valid
         self?.signupOutlet.alpha = valid ? 1.0 : 0.3
         })
         .disposed(by: disposeBag)
         
         //注册结果绑定
         viewModel.signupResult
         .drive(onNext: { [unowned self] result in
         self.showMessage("注册" + (result ? "成功" : "失败") + "!")
         })
         .disposed(by: disposeBag)
         }
         
         //详细提示框
         func showMessage(_ message: String) {
         let alertController = UIAlertController(title: nil,
         message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "确定", style: .cancel, handler: nil)
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
         }
         }
         */

        // TODO:===一个用户注册样例：显示网络请求活动指示器===
        /*
         ActivityIndicator 类可不是苹果自带的 UIActivityIndicator，它是一个用来监测是否有序列正在发送元素的类：
         
         如果至少还有一个序列正在工作，那么它会返回一个 true。
         如果没有序列在工作了，那么它会返回一个 false 值
         默认情况下项目引入的 RxSwift 和 RxCocoa 库中是不会有个类的，我们需要手动将 RxSwift 源码包中的 RxExample/Services/ActivityIndicator.swift 这个文件添加到我们项目中来
         
         class GitHubSignupViewModel {
         
         //用户名验证结果
         let validatedUsername: Driver<ValidationResult>
         
         //密码验证结果
         let validatedPassword: Driver<ValidationResult>
         
         //再次输入密码验证结果
         let validatedPasswordRepeated: Driver<ValidationResult>
         
         //注册按钮是否可用
         let signupEnabled: Driver<Bool>
         
         //正在注册中
         let signingIn: Driver<Bool>
         
         //注册结果
         let signupResult: Driver<Bool>
         
         //ViewModel初始化（根据输入实现对应的输出）
         init(
         input: (
         username: Driver<String>,
         password: Driver<String>,
         repeatedPassword: Driver<String>,
         loginTaps: Signal<Void>
         ),
         dependency: (
         networkService: GitHubNetworkService,
         signupService: GitHubSignupService
         )) {
         
         //用户名验证
         validatedUsername = input.username
         .flatMapLatest { username in
         return dependency.signupService.validateUsername(username)
         .asDriver(onErrorJustReturn: .failed(message: "服务器发生错误!"))
         }
         
         //用户名密码验证
         validatedPassword = input.password
         .map { password in
         return dependency.signupService.validatePassword(password)
         }
         
         //重复输入密码验证
         validatedPasswordRepeated = Driver.combineLatest(
         input.password,
         input.repeatedPassword,
         resultSelector: dependency.signupService.validateRepeatedPassword)
         
         //注册按钮是否可用
         signupEnabled = Driver.combineLatest(
         validatedUsername,
         validatedPassword,
         validatedPasswordRepeated
         ) { username, password, repeatPassword in
         username.isValid && password.isValid && repeatPassword.isValid
         }
         .distinctUntilChanged()
         
         //获取最新的用户名和密码
         let usernameAndPassword = Driver.combineLatest(input.username, input.password) {
         (username: $0, password: $1) }
         
         //用于检测是否正在请求数据
         let activityIndicator = ActivityIndicator()
         self.signingIn = activityIndicator.asDriver()
         
         //注册按钮点击结果
         signupResult = input.loginTaps.withLatestFrom(usernameAndPassword)
         .flatMapLatest { pair in
         return dependency.networkService.signup(pair.username,
         password: pair.password)
         .trackActivity(activityIndicator) //把当前序列放入signing序列中进行检测
         .asDriver(onErrorJustReturn: false)
         }
         }
         }
         
         
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //初始化ViewModel
         let viewModel = GitHubSignupViewModel(
         input: (
         username: usernameOutlet.rx.text.orEmpty.asDriver(),
         password: passwordOutlet.rx.text.orEmpty.asDriver(),
         repeatedPassword: repeatedPasswordOutlet.rx.text.orEmpty.asDriver(),
         loginTaps: signupOutlet.rx.tap.asSignal()
         ),
         dependency: (
         networkService: GitHubNetworkService(),
         signupService: GitHubSignupService()
         )
         )
         
         //用户名验证结果绑定
         viewModel.validatedUsername
         .drive(usernameValidationOutlet.rx.validationResult)
         .disposed(by: disposeBag)
         
         //密码验证结果绑定
         viewModel.validatedPassword
         .drive(passwordValidationOutlet.rx.validationResult)
         .disposed(by: disposeBag)
         
         //再次输入密码验证结果绑定
         viewModel.validatedPasswordRepeated
         .drive(repeatedPasswordValidationOutlet.rx.validationResult)
         .disposed(by: disposeBag)
         
         //注册按钮是否可用
         viewModel.signupEnabled
         .drive(onNext: { [weak self] valid  in
         self?.signupOutlet.isEnabled = valid
         self?.signupOutlet.alpha = valid ? 1.0 : 0.3
         })
         .disposed(by: disposeBag)
         
         //当前是否正在注册
         viewModel.signingIn
         .drive(UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
         .disposed(by: disposeBag)
         
         //注册结果绑定
         viewModel.signupResult
         .drive(onNext: { [unowned self] result in
         self.showMessage("注册" + (result ? "成功" : "失败") + "!")
         })
         .disposed(by: disposeBag)
         }
         
         
         
         第三方指示器的绑定:
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //初始化ViewModel
         let viewModel = GitHubSignupViewModel(
         input: (
         username: usernameOutlet.rx.text.orEmpty.asDriver(),
         password: passwordOutlet.rx.text.orEmpty.asDriver(),
         repeatedPassword: repeatedPasswordOutlet.rx.text.orEmpty.asDriver(),
         loginTaps: signupOutlet.rx.tap.asSignal()
         ),
         dependency: (
         networkService: GitHubNetworkService(),
         signupService: GitHubSignupService()
         )
         )
         
         //用户名验证结果绑定
         viewModel.validatedUsername
         .drive(usernameValidationOutlet.rx.validationResult)
         .disposed(by: disposeBag)
         
         //密码验证结果绑定
         viewModel.validatedPassword
         .drive(passwordValidationOutlet.rx.validationResult)
         .disposed(by: disposeBag)
         
         //再次输入密码验证结果绑定
         viewModel.validatedPasswordRepeated
         .drive(repeatedPasswordValidationOutlet.rx.validationResult)
         .disposed(by: disposeBag)
         
         //注册按钮是否可用
         viewModel.signupEnabled
         .drive(onNext: { [weak self] valid  in
         self?.signupOutlet.isEnabled = valid
         self?.signupOutlet.alpha = valid ? 1.0 : 0.3
         })
         .disposed(by: disposeBag)
         
         //创建一个指示器
         let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
         
         //当前是否正在注册，决定指示器是否显示
         viewModel.signingIn
         .map{ !$0 }
         .drive(hud.rx.isHidden)
         .disposed(by: disposeBag)
         
         //注册结果绑定
         viewModel.signupResult
         .drive(onNext: { [unowned self] result in
         self.showMessage("注册" + (result ? "成功" : "失败") + "!")
         })
         .disposed(by: disposeBag)
         }
         */
        
        // TODO:===MJRefresh使用：下拉刷新===
        /*
         为了让 MJRefresh 可以更好地与 RxSwift 配合使用，我这里对它进行扩展（MJRefresh+Rx.swift）
         将下拉、上拉的刷新事件转为 ControlEvent 类型的可观察序列。
         增加一个用于停止刷新的绑定属性
         
         import RxSwift
         import RxCocoa
         
         //对MJRefreshComponent增加rx扩展
         extension Reactive where Base: MJRefreshComponent {
         
         //正在刷新事件
         var refreshing: ControlEvent<Void> {
         let source: Observable<Void> = Observable.create {
         [weak control = self.base] observer  in
         if let control = control {
         control.refreshingBlock = {
         observer.on(.next(()))
         }
         }
         return Disposables.create()
         }
         return ControlEvent(events: source)
         }
         
         //停止刷新
         var endRefreshing: Binder<Bool> {
         return Binder(base) { refresh, isEnd in
         if isEnd {
         refresh.endRefreshing()
         }
         }
         }
         }
         
         
         //网络请求服务
         class NetworkService {
         
         //获取随机数据
         func getRandomResult() -> Driver<[String]> {
         print("正在请求数据......")
         let items = (0 ..< 15).map {_ in
         "随机数据\(Int(arc4random()))"
         }
         let observable = Observable.just(items)
         return observable
         .delay(1, scheduler: MainScheduler.instance)
         .asDriver(onErrorDriveWith: Driver.empty())
         }
         }
         
         
         class ViewModel {
         
         //表格数据序列
         let tableData:Driver<[String]>
         
         //停止刷新状态序列
         let endHeaderRefreshing: Driver<Bool>
         
         //ViewModel初始化（根据输入实现对应的输出）
         init(headerRefresh: Driver<Void>) {
         
         //网络请求服务
         let networkService = NetworkService()
         
         //生成查询结果序列
         self.tableData = headerRefresh
         .startWith(()) //初始化完毕时会自动加载一次数据
         .flatMapLatest{ _ in networkService.getRandomResult() }
         
         //生成停止刷新状态序列
         self.endHeaderRefreshing = self.tableData.map{ _ in true }
         }
         }
         
         
         class ViewController: UIViewController {
         
         //表格
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self,
         forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //设置头部刷新控件
         self.tableView.mj_header = MJRefreshNormalHeader()
         
         //初始化ViewModel
         let viewModel = ViewModel(headerRefresh:
         self.tableView.mj_header.rx.refreshing.asDriver())
         
         //单元格数据的绑定
         viewModel.tableData.asDriver()
         .drive(tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(row+1)、\(element)"
         return cell
         }
         .disposed(by: disposeBag)
         
         //下拉刷新状态结束的绑定
         viewModel.endHeaderRefreshing
         .drive(self.tableView.mj_header.rx.endRefreshing)
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===BehaviorRelay===
        /*
         由
         let myVariable = Variable<Bool>(true)
         myVariable.value = false
         
         改为
         let myBehaviorRelay = BehaviorRelay<Bool>(value: true)
         myBehaviorRelay.accept(false)
         
         // BehaviorRelay 只遵守 ObservableType协议，所以它其实是一个序列
         let subject = BehaviorRelay(value: "A")
         subject.asObservable().subscribe(onNext: { element in
         print("第1次订阅：", element)
         }, onCompleted: {
         print("第1次订阅：completed")
         }).disposed(by: bag)
         
         subject.accept("B")
         subject.asObservable().subscribe(onNext: { element in
         print("第2次订阅：", element)
         }, onCompleted: {
         print("第2次订阅：completed")
         }).disposed(by: bag)
         
         subject.accept("C")
         */
        
        // TODO:===MJRefresh使用：上拉加载、以及上下拉组合===
        /*
         上拉加载:
         class ViewModel {
         
         //表格数据序列
         let tableData = BehaviorRelay<[String]>(value: [])
         
         //停止上拉加载刷新状态序列
         let endFooterRefreshing: Driver<Bool>
         
         //ViewModel初始化（根据输入实现对应的输出）
         init(footerRefresh: Driver<Void>,
         dependency: (
         disposeBag:DisposeBag,
         networkService: NetworkService )) {
         
         //上拉结果序列
         let footerRefreshData = footerRefresh
         .startWith(()) //初始化完毕时会自动加载一次数据
         .flatMapLatest{ return dependency.networkService.getRandomResult() }
         
         //生成停止上拉加载刷新状态序列
         self.endFooterRefreshing = footerRefreshData.map{ _ in true }
         
         //上拉加载时，将查询到的结果拼接到原数据底部
         footerRefreshData.drive(onNext: { items in
         self.tableData.accept(self.tableData.value + items )
         }).disposed(by: dependency.disposeBag)
         }
         }
         
         
         class ViewController: UIViewController {
         
         //表格
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self,
         forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //设置尾部刷新控件
         self.tableView.mj_footer = MJRefreshBackNormalFooter()
         
         //初始化ViewModel
         let viewModel = ViewModel(
         footerRefresh: self.tableView.mj_footer.rx.refreshing.asDriver(),
         dependency: (
         disposeBag: self.disposeBag,
         networkService: NetworkService()))
         
         //单元格数据的绑定
         viewModel.tableData.asDriver()
         .drive(tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(row+1)、\(element)"
         return cell
         }
         .disposed(by: disposeBag)
         
         //上拉刷新状态结束的绑定
         viewModel.endFooterRefreshing
         .drive(self.tableView.mj_footer.rx.endRefreshing)
         .disposed(by: disposeBag)
         }
         }
         
         
         下拉刷新 + 上拉加载:
         class ViewModel {
         
         //表格数据序列
         let tableData = BehaviorRelay<[String]>(value: [])
         
         //停止头部刷新状态
         let endHeaderRefreshing: Driver<Bool>
         
         //停止尾部刷新状态
         let endFooterRefreshing: Driver<Bool>
         
         //ViewModel初始化（根据输入实现对应的输出）
         init(input: (
         headerRefresh: Driver<Void>,
         footerRefresh: Driver<Void> ),
         dependency: (
         disposeBag:DisposeBag,
         networkService: NetworkService )) {
         
         //下拉结果序列
         let headerRefreshData = input.headerRefresh
         .startWith(()) //初始化时会先自动加载一次数据
         .flatMapLatest{ return dependency.networkService.getRandomResult() }
         
         //上拉结果序列
         let footerRefreshData = input.footerRefresh
         .flatMapLatest{ return dependency.networkService.getRandomResult() }
         
         //生成停止头部刷新状态序列
         self.endHeaderRefreshing = headerRefreshData.map{ _ in true }
         
         //生成停止尾部刷新状态序列
         self.endFooterRefreshing = footerRefreshData.map{ _ in true }
         
         //下拉刷新时，直接将查询到的结果替换原数据
         headerRefreshData.drive(onNext: { items in
         self.tableData.accept(items)
         }).disposed(by: dependency.disposeBag)
         
         //上拉加载时，将查询到的结果拼接到原数据底部
         footerRefreshData.drive(onNext: { items in
         self.tableData.accept(self.tableData.value + items )
         }).disposed(by: dependency.disposeBag)
         }
         }
         
         
         class ViewController: UIViewController {
         
         //表格
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self,
         forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //设置头部刷新控件
         self.tableView.mj_header = MJRefreshNormalHeader()
         //设置尾部刷新控件
         self.tableView.mj_footer = MJRefreshBackNormalFooter()
         
         //初始化ViewModel
         let viewModel = ViewModel(
         input: (
         headerRefresh: self.tableView.mj_header.rx.refreshing.asDriver(),
         footerRefresh: self.tableView.mj_footer.rx.refreshing.asDriver()),
         dependency: (
         disposeBag: self.disposeBag,
         networkService: NetworkService()))
         
         //单元格数据的绑定
         viewModel.tableData.asDriver()
         .drive(tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(row+1)、\(element)"
         return cell
         }
         .disposed(by: disposeBag)
         
         //下拉刷新状态结束的绑定
         viewModel.endHeaderRefreshing
         .drive(self.tableView.mj_header.rx.endRefreshing)
         .disposed(by: disposeBag)
         
         //上拉刷新状态结束的绑定
         viewModel.endFooterRefreshing
         .drive(self.tableView.mj_footer.rx.endRefreshing)
         .disposed(by: disposeBag)
         }
         }
         
         “下拉刷新 + 上拉加载”的功能改进:
         在前面的样例中下拉刷新和上拉加载这两个行为是独立的，互不影响。也就是说当我们下拉刷新后，在数据返回前又进行了次上拉操作，那么之后表格便会连续刷新两次，影响体验。这里对功能做个改进：
         
         当下拉刷新时，如果数据还未返回。这时进行上拉加载会取消前面的下拉刷新操作（包括下拉刷新的数据），只进行上拉数据的加载。
         同样的，当上拉加载时，如果数据还未放回。这时进行下拉刷新会取消上拉加载操作（包括上拉加载的数据），只进行下拉数据的加载
         
         这次我们不使用 Driver 这个特征序列，而是用普通的 Observable 序列
         
         class ViewModel {
         
         //表格数据序列
         let tableData = BehaviorRelay<[String]>(value: [])
         
         //停止头部刷新状态
         let endHeaderRefreshing: Observable<Bool>
         
         //停止尾部刷新状态
         let endFooterRefreshing: Observable<Bool>
         
         //ViewModel初始化（根据输入实现对应的输出）
         init(input: (
         headerRefresh: Observable<Void>,
         footerRefresh: Observable<Void> ),
         dependency: (
         disposeBag:DisposeBag,
         networkService: NetworkService )) {
         
         //下拉结果序列
         let headerRefreshData = input.headerRefresh
         .startWith(()) //初始化时会先自动加载一次数据
         .flatMapLatest{ _ in
         dependency.networkService.getRandomResult()
         .takeUntil(input.footerRefresh)
         }.share(replay: 1) //让HTTP请求是被共享的
         
         
         //上拉结果序列
         let footerRefreshData = input.footerRefresh
         .flatMapLatest{ _ in
         dependency.networkService.getRandomResult()
         .takeUntil(input.headerRefresh)
         }.share(replay: 1) //让HTTP请求是被共享的
         
         //生成停止头部刷新状态序列
         self.endHeaderRefreshing = Observable.merge(
         headerRefreshData.map{ _ in true },
         input.footerRefresh.map{ _ in true }
         )
         
         //生成停止尾部刷新状态序列
         self.endFooterRefreshing = Observable.merge(
         footerRefreshData.map{ _ in true },
         input.headerRefresh.map{ _ in true }
         )
         
         //下拉刷新时，直接将查询到的结果替换原数据
         headerRefreshData.subscribe(onNext: { items in
         self.tableData.accept(items)
         }).disposed(by: dependency.disposeBag)
         
         //上拉加载时，将查询到的结果拼接到原数据底部
         footerRefreshData.subscribe(onNext: { items in
         self.tableData.accept(self.tableData.value + items )
         }).disposed(by: dependency.disposeBag)
         }
         }
         
         
         
         class ViewController: UIViewController {
         
         //表格
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self,
         forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //设置头部刷新控件
         self.tableView.mj_header = MJRefreshNormalHeader()
         //设置尾部刷新控件
         self.tableView.mj_footer = MJRefreshBackNormalFooter()
         
         //初始化ViewModel
         let viewModel = ViewModel(
         input: (
         headerRefresh: self.tableView.mj_header.rx.refreshing.asObservable() ,
         footerRefresh: self.tableView.mj_footer.rx.refreshing.asObservable()),
         dependency: (
         disposeBag: self.disposeBag,
         networkService: NetworkService()))
         
         //单元格数据的绑定
         viewModel.tableData
         .bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(row+1)、\(element)"
         return cell
         }
         .disposed(by: disposeBag)
         
         //下拉刷新状态结束的绑定
         viewModel.endHeaderRefreshing
         .bind(to: self.tableView.mj_header.rx.endRefreshing)
         .disposed(by: disposeBag)
         
         //上拉刷新状态结束的绑定
         viewModel.endFooterRefreshing
         .bind(to: self.tableView.mj_footer.rx.endRefreshing)
         .disposed(by: disposeBag)
         }
         }
         */
        
        // TODO:===DelegateProxy样例：获取地理定位信息===
        /*
         将代理方法进行一层 Rx 封装，这样做不仅会减少许多不必要的工作（比如原先需要遵守不同的代理，并且要实现相应的代理方法），还会使得代码的聚合度更高，更加符合响应式编程的规范
         如何将代理方法进行 Rx 化:
         DelegateProxy
         （1）DelegateProxy 是代理委托，我们可以将它看作是代理的代理。
         （2）DelegateProxy 的作用是做为一个中间代理，他会先把系统的 delegate 对象保存一份，然后拦截 delegate 的方法。也就是说在每次触发 delegate 方法之前，会先调用 DelegateProxy 这边对应的方法，我们可以在这里发射序列给多个订阅者
         
         
         这个是 RxSwift 的一个官方样例，演示的是如何对 CLLocationManagerDelegate 进行 Rx 封装:
         RxCLLocationManagerDelegateProxy.swift
         首先我们继承 DelegateProxy 创建一个关于定位服务的代理委托，同时它还要遵守 DelegateProxyType 和 CLLocationManagerDelegate 协议。
         import CoreLocation
         import RxSwift
         import RxCocoa
         
         extension CLLocationManager: HasDelegate {
         public typealias Delegate = CLLocationManagerDelegate
         }
         
         public class RxCLLocationManagerDelegateProxy
         : DelegateProxy<CLLocationManager, CLLocationManagerDelegate>
         , DelegateProxyType , CLLocationManagerDelegate {
         
         public init(locationManager: CLLocationManager) {
         super.init(parentObject: locationManager,
         delegateProxy: RxCLLocationManagerDelegateProxy.self)
         }
         
         public static func registerKnownImplementations() {
         self.register { RxCLLocationManagerDelegateProxy(locationManager: $0) }
         }
         
         internal lazy var didUpdateLocationsSubject = PublishSubject<[CLLocation]>()
         internal lazy var didFailWithErrorSubject = PublishSubject<Error>()
         
         public func locationManager(_ manager: CLLocationManager,
         didUpdateLocations locations: [CLLocation]) {
         _forwardToDelegate?.locationManager?(manager, didUpdateLocations: locations)
         didUpdateLocationsSubject.onNext(locations)
         }
         
         public func locationManager(_ manager: CLLocationManager,
         didFailWithError error: Error) {
         _forwardToDelegate?.locationManager?(manager, didFailWithError: error)
         didFailWithErrorSubject.onNext(error)
         }
         
         deinit {
         self.didUpdateLocationsSubject.on(.completed)
         self.didFailWithErrorSubject.on(.completed)
         }
         }
         
         CLLocationManager+Rx.swift
         接着我们对 CLLocationManager 进行Rx 扩展，作用是将CLLocationManager与前面创建的代理委托关联起来，将定位相关的 delegate 方法转为可观察序列:
         import CoreLocation
         import RxSwift
         import RxCocoa
         
         extension Reactive where Base: CLLocationManager {
         
         /**
         Reactive wrapper for `delegate`.
         
         For more information take a look at `DelegateProxyType` protocol documentation.
         */
         public var delegate: DelegateProxy<CLLocationManager, CLLocationManagerDelegate> {
         return RxCLLocationManagerDelegateProxy.proxy(for: base)
         }
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didUpdateLocations: Observable<[CLLocation]> {
         return RxCLLocationManagerDelegateProxy.proxy(for: base)
         .didUpdateLocationsSubject.asObservable()
         }
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didFailWithError: Observable<Error> {
         return RxCLLocationManagerDelegateProxy.proxy(for: base)
         .didFailWithErrorSubject.asObservable()
         }
         
         #if os(iOS) || os(macOS)
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didFinishDeferredUpdatesWithError: Observable<Error?> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:didFinishDeferredUpdatesWithError:)))
         .map { a in
         return try castOptionalOrThrow(Error.self, a[1])
         }
         }
         #endif
         
         #if os(iOS)
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didPauseLocationUpdates: Observable<Void> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManagerDidPauseLocationUpdates(_:)))
         .map { _ in
         return ()
         }
         }
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didResumeLocationUpdates: Observable<Void> {
         return delegate.methodInvoked( #selector(CLLocationManagerDelegate
         .locationManagerDidResumeLocationUpdates(_:)))
         .map { _ in
         return ()
         }
         }
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didUpdateHeading: Observable<CLHeading> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:didUpdateHeading:)))
         .map { a in
         return try castOrThrow(CLHeading.self, a[1])
         }
         }
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didEnterRegion: Observable<CLRegion> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:didEnterRegion:)))
         .map { a in
         return try castOrThrow(CLRegion.self, a[1])
         }
         }
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didExitRegion: Observable<CLRegion> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:didExitRegion:)))
         .map { a in
         return try castOrThrow(CLRegion.self, a[1])
         }
         }
         
         #endif
         
         #if os(iOS) || os(macOS)
         
         /**
         Reactive wrapper for `delegate` message.
         */
         @available(OSX 10.10, *)
         public var didDetermineStateForRegion: Observable<(state: CLRegionState,
         region: CLRegion)> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:didDetermineState:for:)))
         .map { a in
         let stateNumber = try castOrThrow(NSNumber.self, a[1])
         let state = CLRegionState(rawValue: stateNumber.intValue)
         ?? CLRegionState.unknown
         let region = try castOrThrow(CLRegion.self, a[2])
         return (state: state, region: region)
         }
         }
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var monitoringDidFailForRegionWithError:
         Observable<(region: CLRegion?, error: Error)> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:monitoringDidFailFor:withError:)))
         .map { a in
         let region = try castOptionalOrThrow(CLRegion.self, a[1])
         let error = try castOrThrow(Error.self, a[2])
         return (region: region, error: error)
         }
         }
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didStartMonitoringForRegion: Observable<CLRegion> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:didStartMonitoringFor:)))
         .map { a in
         return try castOrThrow(CLRegion.self, a[1])
         }
         }
         
         #endif
         
         #if os(iOS)
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didRangeBeaconsInRegion: Observable<(beacons: [CLBeacon],
         region: CLBeaconRegion)> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:didRangeBeacons:in:)))
         .map { a in
         let beacons = try castOrThrow([CLBeacon].self, a[1])
         let region = try castOrThrow(CLBeaconRegion.self, a[2])
         return (beacons: beacons, region: region)
         }
         }
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var rangingBeaconsDidFailForRegionWithError:
         Observable<(region: CLBeaconRegion, error: Error)> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:rangingBeaconsDidFailFor:withError:)))
         .map { a in
         let region = try castOrThrow(CLBeaconRegion.self, a[1])
         let error = try castOrThrow(Error.self, a[2])
         return (region: region, error: error)
         }
         }
         
         /**
         Reactive wrapper for `delegate` message.
         */
         @available(iOS 8.0, *)
         public var didVisit: Observable<CLVisit> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:didVisit:)))
         .map { a in
         return try castOrThrow(CLVisit.self, a[1])
         }
         }
         
         #endif
         
         /**
         Reactive wrapper for `delegate` message.
         */
         public var didChangeAuthorizationStatus: Observable<CLAuthorizationStatus> {
         return delegate.methodInvoked(#selector(CLLocationManagerDelegate
         .locationManager(_:didChangeAuthorization:)))
         .map { a in
         let number = try castOrThrow(NSNumber.self, a[1])
         return CLAuthorizationStatus(rawValue: Int32(number.intValue))
         ?? .notDetermined
         }
         }
         }
         
         
         fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
         guard let returnValue = object as? T else {
         throw RxCocoaError.castingError(object: object, targetType: resultType)
         }
         
         return returnValue
         }
         
         fileprivate func castOptionalOrThrow<T>(_ resultType: T.Type,
         _ object: Any) throws -> T? {
         if NSNull().isEqual(object) {
         return nil
         }
         
         guard let returnValue = object as? T else {
         throw RxCocoaError.castingError(object: object, targetType: resultType)
         }
         
         return returnValue
         }
         
         
         GeolocationService.swift
         虽然现在我们已经可以直接 CLLocationManager 的 rx 扩展方法获取位置信息了。但为了更加方便使用，我们这里对 CLLocationManager 再次进行封装，定义一个地理定位的 service 层，作用如下：
         
         自动申请定位权限，以及授权判断。
         自动开启定位服务更新。
         自动实现经纬度数据的转换。
         
         import CoreLocation
         import RxSwift
         import RxCocoa
         
         //地理定位服务层
         class GeolocationService {
         //单例模式
         static let instance = GeolocationService()
         
         //定位权限序列
         private (set) var authorized: Driver<Bool>
         
         //经纬度信息序列
         private (set) var location: Driver<CLLocationCoordinate2D>
         
         //定位管理器
         private let locationManager = CLLocationManager()
         
         private init() {
         
         //更新距离
         locationManager.distanceFilter = kCLDistanceFilterNone
         //设置定位精度
         locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
         
         //获取定位权限序列
         authorized = Observable.deferred { [weak locationManager] in
         let status = CLLocationManager.authorizationStatus()
         guard let locationManager = locationManager else {
         return Observable.just(status)
         }
         return locationManager
         .rx.didChangeAuthorizationStatus
         .startWith(status)
         }
         .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
         .map {
         switch $0 {
         case .authorizedAlways:
         return true
         default:
         return false
         }
         }
         
         //获取经纬度信息序列
         location = locationManager.rx.didUpdateLocations
         .asDriver(onErrorJustReturn: [])
         .flatMap {
         return $0.last.map(Driver.just) ?? Driver.empty()
         }
         .map { $0.coordinate }
         
         //发送授权申请
         locationManager.requestAlwaysAuthorization()
         //允许使用定位服务的话，开启定位服务更新
         locationManager.startUpdatingLocation()
         }
         }
         
         
         //UILabel的Rx扩展
         extension Reactive where Base: UILabel {
         //实现CLLocationCoordinate2D经纬度信息的绑定显示
         var coordinates: Binder<CLLocationCoordinate2D> {
         return Binder(base) { label, location in
         label.text = "经度: \(location.longitude)\n纬度: \(location.latitude)"
         }
         }
         }
         
         
         class ViewController: UIViewController {
         
         @IBOutlet weak private var button: UIButton!
         @IBOutlet weak var label: UILabel!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //获取地理定位服务
         let geolocationService = GeolocationService.instance
         
         //定位权限绑定到按钮上(是否可见)
         geolocationService.authorized
         .drive(button.rx.isHidden)
         .disposed(by: disposeBag)
         
         //经纬度信息绑定到label上显示
         geolocationService.location
         .drive(label.rx.coordinates)
         .disposed(by: disposeBag)
         
         //按钮点击
         button.rx.tap
         .bind { [weak self] _ -> Void in
         self?.openAppPreferences()
         }
         .disposed(by: disposeBag)
         }
         
         //跳转到应有偏好的设置页面
         private func openAppPreferences() {
         UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!)
         }
         }
         */
        
        // TODO:===DelegateProxy样例：图片选择功能===
        /*
         对 UIImagePickerControllerDelegate 进行 Rx 封装:
         
         RxImagePickerDelegateProxy.swift
         首先我们继承 DelegateProxy 创建一个关于图片选择的代理委托，同时它还要遵守 DelegateProxyType、UIImagePickerControllerDelegate、UINavigationControllerDelegate 协议
         
         //图片选择控制器（UIImagePickerController）代理委托
         public class RxImagePickerDelegateProxy :
         DelegateProxy<UIImagePickerController,
         UIImagePickerControllerDelegate & UINavigationControllerDelegate>,
         DelegateProxyType,
         UIImagePickerControllerDelegate,
         UINavigationControllerDelegate {
         
         public init(imagePicker: UIImagePickerController) {
         super.init(parentObject: imagePicker,
         delegateProxy: RxImagePickerDelegateProxy.self)
         }
         
         public static func registerKnownImplementations() {
         self.register { RxImagePickerDelegateProxy(imagePicker: $0) }
         }
         
         public static func currentDelegate(for object: UIImagePickerController)
         -> (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? {
         return object.delegate
         }
         
         public static func setCurrentDelegate(_ delegate: (UIImagePickerControllerDelegate
         & UINavigationControllerDelegate)?, to object: UIImagePickerController) {
         object.delegate = delegate
         }
         }
         
         UIImagePickerController+Rx.swift
         //图片选择控制器（UIImagePickerController）的Rx扩展
         extension Reactive where Base: UIImagePickerController {
         
         //代理委托
         public var pickerDelegate: DelegateProxy<UIImagePickerController,
         UIImagePickerControllerDelegate & UINavigationControllerDelegate > {
         return RxImagePickerDelegateProxy.proxy(for: base)
         }
         
         //图片选择完毕代理方法的封装
         public var didFinishPickingMediaWithInfo: Observable<[String : AnyObject]> {
         
         return pickerDelegate
         .methodInvoked(#selector(UIImagePickerControllerDelegate
         .imagePickerController(_:didFinishPickingMediaWithInfo:)))
         .map({ (a) in
         return try castOrThrow(Dictionary<String, AnyObject>.self, a[1])
         })
         }
         
         //图片取消选择代理方法的封装
         public var didCancel: Observable<()> {
         return pickerDelegate
         .methodInvoked(#selector(UIImagePickerControllerDelegate
         .imagePickerControllerDidCancel(_:)))
         .map {_ in () }
         }
         }
         
         //转类型的函数（转换失败后，会发出Error）
         fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
         guard let returnValue = object as? T else {
         throw RxCocoaError.castingError(object: object, targetType: resultType)
         }
         return returnValue
         }
         
         class ViewController: UIViewController {
         
         //拍照按钮
         @IBOutlet weak var cameraButton: UIButton!
         
         //选择照片按钮
         @IBOutlet weak var galleryButton: UIButton!
         
         //选择照片并裁剪按钮
         @IBOutlet weak var cropButton: UIButton!
         
         //显示照片的imageView
         @IBOutlet weak var imageView: UIImageView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //初始化图片控制器
         let imagePicker = UIImagePickerController()
         
         //判断并决定"拍照"按钮是否可用
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
         
         //“拍照”按钮点击
         cameraButton.rx.tap
         .bind { [weak self] _ -> Void in
         imagePicker.sourceType = .camera //来源为相机
         imagePicker.allowsEditing = false //不可编辑
         //弹出控制器，显示界面
         self?.present(imagePicker, animated: true)
         }
         .disposed(by: disposeBag)
         
         //“选择照片”按钮点击
         galleryButton.rx.tap
         .bind { [weak self] _ -> Void in
         imagePicker.sourceType = .photoLibrary //来源为相册
         imagePicker.allowsEditing = false //不可编辑
         //弹出控制器，显示界面
         self?.present(imagePicker, animated: true)
         }
         .disposed(by: disposeBag)
         
         //“选择照片并裁剪”按钮点击
         cropButton.rx.tap
         .bind { [weak self] _ -> Void in
         imagePicker.sourceType = .photoLibrary //来源为相册
         imagePicker.allowsEditing = true //不可编辑
         //弹出控制器，显示界面
         self?.present(imagePicker, animated: true)
         }
         .disposed(by: disposeBag)
         
         //图片选择完毕后，将其绑定到imageView上显示
         imagePicker.rx.didFinishPickingMediaWithInfo
         .map { info in
         //根据情况选择是使用原始图片还是编辑后的图片
         if imagePicker.allowsEditing {
         return info[UIImagePickerControllerEditedImage] as! UIImage
         } else {
         return info[UIImagePickerControllerOriginalImage] as! UIImage
         }
         }
         .bind(to: imageView.rx.image)
         .disposed(by: disposeBag)
         
         //图片选择完毕后，退出图片控制器
         imagePicker.rx.didFinishPickingMediaWithInfo
         .subscribe(onNext: { _ in
         imagePicker.dismiss(animated: true)
         })
         .disposed(by: disposeBag)
         }
         }
         
         
         比如图片选择完毕后还需要在代码中手动退出选择器。下面对它做个功能改进，让其可以自动关闭退出：
         UIImagePickerController+RxCreate.swift
         import UIKit
         import RxSwift
         import RxCocoa
         
         //取消指定视图控制器函数
         func dismissViewController(_ viewController: UIViewController, animated: Bool) {
         if viewController.isBeingDismissed || viewController.isBeingPresented {
         DispatchQueue.main.async {
         dismissViewController(viewController, animated: animated)
         }
         return
         }
         
         if viewController.presentingViewController != nil {
         viewController.dismiss(animated: animated, completion: nil)
         }
         }
         
         //对UIImagePickerController进行Rx扩展
         extension Reactive where Base: UIImagePickerController {
         //用于创建并自动显示图片选择控制器的静态方法
         static func createWithParent(_ parent: UIViewController?,
         animated: Bool = true,
         configureImagePicker: @escaping (UIImagePickerController) throws -> () = { x in })
         -> Observable<UIImagePickerController> {
         
         //返回可观察序列
         return Observable.create { [weak parent] observer in
         
         //初始化一个图片选择控制器
         let imagePicker = UIImagePickerController()
         
         //不管图片选择完毕还是取消选择，都会发出.completed事件
         let dismissDisposable = Observable.merge(
         imagePicker.rx.didFinishPickingMediaWithInfo.map{_ in ()},
         imagePicker.rx.didCancel
         )
         .subscribe(onNext: {  _ in
         observer.on(.completed)
         })
         
         //设置图片选择控制器初始参数，参数不正确则发出.error事件
         do {
         try configureImagePicker(imagePicker)
         }
         catch let error {
         observer.on(.error(error))
         return Disposables.create()
         }
         
         //判断parent是否存在，不存在则发出.completed事件
         guard let parent = parent else {
         observer.on(.completed)
         return Disposables.create()
         }
         
         //弹出控制器，显示界面
         parent.present(imagePicker, animated: animated, completion: nil)
         //发出.next事件（携带的是控制器对象）
         observer.on(.next(imagePicker))
         
         //销毁时自动退出图片控制器
         return Disposables.create(dismissDisposable, Disposables.create {
         dismissViewController(imagePicker, animated: animated)
         })
         }
         }
         }
         
         
         
         class ViewController: UIViewController {
         
         //拍照按钮
         @IBOutlet weak var cameraButton: UIButton!
         
         //选择照片按钮
         @IBOutlet weak var galleryButton: UIButton!
         
         //选择照片并裁剪按钮
         @IBOutlet weak var cropButton: UIButton!
         
         //显示照片的imageView
         @IBOutlet weak var imageView: UIImageView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //判断并决定"拍照"按钮是否可用
         cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
         
         //“拍照”按钮点击
         cameraButton.rx.tap
         .flatMapLatest { [weak self] _ in
         return UIImagePickerController.rx.createWithParent(self) { picker in
         picker.sourceType = .camera
         picker.allowsEditing = false
         }
         .flatMap { $0.rx.didFinishPickingMediaWithInfo }
         }
         .map { info in
         return info[UIImagePickerControllerOriginalImage] as? UIImage
         }
         .bind(to: imageView.rx.image)
         .disposed(by: disposeBag)
         
         //“选择照片”按钮点击
         galleryButton.rx.tap
         .flatMapLatest { [weak self] _ in
         return UIImagePickerController.rx.createWithParent(self) { picker in
         picker.sourceType = .photoLibrary
         picker.allowsEditing = false
         }
         .flatMap { $0.rx.didFinishPickingMediaWithInfo }
         }
         .map { info in
         return info[UIImagePickerControllerOriginalImage] as? UIImage
         }
         .bind(to: imageView.rx.image)
         .disposed(by: disposeBag)
         
         //“选择照片并裁剪”按钮点击
         cropButton.rx.tap
         .flatMapLatest { [weak self] _ in
         return UIImagePickerController.rx.createWithParent(self) { picker in
         picker.sourceType = .photoLibrary
         picker.allowsEditing = true
         }
         .flatMap { $0.rx.didFinishPickingMediaWithInfo }
         }
         .map { info in
         return info[UIImagePickerControllerEditedImage] as? UIImage
         }
         .bind(to: imageView.rx.image)
         .disposed(by: disposeBag)
         }
         }
         */
        
        // MARK:===DelegateProxy样例：应用生命周期的状态变化===
        /*
         利用 RxSwift 的 DelegateProxy 实现 UIApplicationDelegate 相关回调方法的封装。从而让 UIApplicationDelegate 回调可以在任何模块中都可随时调用
         
         RxUIApplicationDelegateProxy.swift
         
         首先我们继承 DelegateProxy 创建一个关于应用生命周期变化的代理委托，同时它还要遵守 DelegateProxyType、UIApplicationDelegate 协议
         //UIApplicationDelegate 代理委托
         public class RxUIApplicationDelegateProxy :
         DelegateProxy<UIApplication, UIApplicationDelegate>,
         UIApplicationDelegate, DelegateProxyType {
         
         public weak private(set) var application: UIApplication?
         
         init(application: ParentObject) {
         self.application = application
         super.init(parentObject: application, delegateProxy: RxUIApplicationDelegateProxy.self)
         }
         
         public static func registerKnownImplementations() {
         self.register { RxUIApplicationDelegateProxy(application: $0) }
         }
         
         public static func currentDelegate(for object: UIApplication) -> UIApplicationDelegate? {
         return object.delegate
         }
         
         public static func setCurrentDelegate(_ delegate: UIApplicationDelegate?,
         to object: UIApplication) {
         object.delegate = delegate
         }
         
         override open func setForwardToDelegate(_ forwardToDelegate: UIApplicationDelegate?,
         retainDelegate: Bool) {
         super.setForwardToDelegate(forwardToDelegate, retainDelegate: true)
         }
         }
         
         
         import RxSwift
         import RxCocoa
         import UIKit
         
         //自定义应用状态枚举
         public enum AppState {
         case active
         case inactive
         case background
         case terminated
         }
         
         //扩展
         extension UIApplicationState {
         //将其转为我们自定义的应用状态枚举
         func toAppState() -> AppState{
         switch self {
         case .active:
         return .active
         case .inactive:
         return .inactive
         case .background:
         return .background
         }
         }
         }
         
         //UIApplication的Rx扩展
         extension Reactive where Base: UIApplication {
         
         //代理委托
         var delegate: DelegateProxy<UIApplication, UIApplicationDelegate> {
         return RxUIApplicationDelegateProxy.proxy(for: base)
         }
         
         //应用重新回到活动状态
         var didBecomeActive: Observable<AppState> {
         return delegate
         .methodInvoked(#selector(UIApplicationDelegate.applicationDidBecomeActive(_:)))
         .map{ _ in return .active}
         }
         
         //应用从活动状态进入非活动状态
         var willResignActive: Observable<AppState> {
         return delegate
         .methodInvoked(#selector(UIApplicationDelegate.applicationWillResignActive(_:)))
         .map{ _ in return .inactive}
         }
         
         //应用从后台恢复至前台（还不是活动状态）
         var willEnterForeground: Observable<AppState> {
         return delegate
         .methodInvoked(#selector(UIApplicationDelegate.applicationWillEnterForeground(_:)))
         .map{ _ in return .inactive}
         }
         
         //应用进入到后台
         var didEnterBackground: Observable<AppState> {
         return delegate
         .methodInvoked(#selector(UIApplicationDelegate.applicationDidEnterBackground(_:)))
         .map{ _ in return .background}
         }
         
         //应用终止
         var willTerminate: Observable<AppState> {
         return delegate
         .methodInvoked(#selector(UIApplicationDelegate.applicationWillTerminate(_:)))
         .map{ _ in return .terminated}
         }
         
         //应用各状态变换序列
         var state: Observable<AppState> {
         return Observable.of(
         didBecomeActive,
         willResignActive,
         willEnterForeground,
         didEnterBackground,
         willTerminate
         )
         .merge()
         .startWith(base.applicationState.toAppState()) //为了让开始订阅时就能获取到当前状态
         }
         }
         
         
         
         对各个状态变化行为分别进行订阅：
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //应用重新回到活动状态
         UIApplication.shared.rx
         .didBecomeActive
         .subscribe(onNext: { _ in
         print("应用进入活动状态。")
         })
         .disposed(by: disposeBag)
         
         //应用从活动状态进入非活动状态
         UIApplication.shared.rx
         .willResignActive
         .subscribe(onNext: { _ in
         print("应用从活动状态进入非活动状态。")
         })
         .disposed(by: disposeBag)
         
         //应用从后台恢复至前台（还不是活动状态）
         UIApplication.shared.rx
         .willEnterForeground
         .subscribe(onNext: { _ in
         print("应用从后台恢复至前台（还不是活动状态）。")
         })
         .disposed(by: disposeBag)
         
         //应用进入到后台
         UIApplication.shared.rx
         .didEnterBackground
         .subscribe(onNext: { _ in
         print("应用进入到后台。")
         })
         .disposed(by: disposeBag)
         
         //应用终止
         UIApplication.shared.rx
         .willTerminate
         .subscribe(onNext: { _ in
         print("应用终止。")
         })
         .disposed(by: disposeBag)
         }
         }
         
         
         对状态变化序列进行订阅：
         import UIKit
         import RxSwift
         import RxCocoa
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //应用重新回到活动状态
         UIApplication.shared.rx
         .state
         .subscribe(onNext: { state in
         switch state {
         case .active:
         print("应用进入活动状态。")
         case .inactive:
         print("应用进入非活动状态。")
         case .background:
         print("应用进入到后台。")
         case .terminated:
         print("应用终止。")
         }
         })
         .disposed(by: disposeBag)
         }
         }
         
         */
        
        // TODO:===sendMessage和methodInvoked===
        /*
         它们间只有一个区别：
         sentMessage 会在调用方法前发送值。
         methodInvoked 会在调用方法后发送值
         
         实现原理
         （1）其原理简单说就是利用 Runtime 消息转发机制来转发代理方法。同时在调用返回值为空的代理方法的前后分别产生两种数据流。
         （2）比如最开始的代理为 A，然后我们把代理改为 AProxy，并把 A 设置为 AProxy 的_forwardToDelegate。这样所有的代理方法将会变成到达 AProxy，接着 AProxy对这些方法进行如下操作：
         
         首先调用 sentMessage 方法
         接着调用原代理方法
         最后调用 methodInvoked 方法
         
         拦截 VC 的 viewWillAppear 方法:
         import UIKit
         import RxSwift
         import RxCocoa
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //使用sentMessage方法获取Observable
         self.rx.sentMessage(#selector(ViewController.viewWillAppear(_:)))
         .subscribe(onNext: { value in
         print("1")
         })
         .disposed(by: disposeBag)
         
         //使用methodInvoked方法获取Observable
         self.rx.methodInvoked(#selector(ViewController.viewWillAppear(_:)))
         .subscribe(onNext: { value in
         print("3")
         })
         .disposed(by: disposeBag)
         }
         
         //默认的viewWillAppear方法
         override func viewWillAppear(_ animated: Bool) {
         super.viewWillAppear(animated)
         print("2")
         }
         }
         
         
         拦截自定义方法:
         import UIKit
         import RxSwift
         import RxCocoa
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //使用sentMessage获取方法执行前的序列
         self.rx.sentMessage(#selector(ViewController.test))
         .subscribe(onNext: { value in
         print("1：\(value[0])")
         })
         .disposed(by: disposeBag)
         
         //使用methodInvoked获取方法执行后的序列
         self.rx.methodInvoked(#selector(ViewController.test))
         .map({ (a) in
         return try castOrThrow(String.self, a[0])
         })
         .subscribe(onNext: { value in
         print("3：\(value)")
         })
         .disposed(by: disposeBag)
         
         //调用自定义方法
         test("hangge.com")
         }
         
         //自定义方法
         @objc dynamic func test(_ value:String) {
         print("2：\(value)")
         }
         }
         
         //转类型的函数（转换失败后，会发出Error）
         fileprivate func castOrThrow<T>(_ resultType: T.Type, _ object: Any) throws -> T {
         guard let returnValue = object as? T else {
         throw RxCocoaError.castingError(object: object, targetType: resultType)
         }
         return returnValue
         }
         */
        
        // TODO:===订阅UITableViewCell里的按钮点击事件===
        /*
         MyTableCell.swift（自定义单元格类）
         注意 prepareForReuse() 方法里的 disposeBag = DisposeBag()
         每次 prepareForReuse() 方法执行时都会初始化一个新的 disposeBag。这是因为 cell 是可以复用的，这样当 cell 每次重用的时候，便会自动释放之前的 disposeBag，从而保证 cell 被重用的时候不会被多次订阅，避免错误发生
         
         //单元格类
         class MyTableCell: UITableViewCell {
         
         var button:UIButton!
         
         var disposeBag = DisposeBag()
         
         //单元格重用时调用
         override func prepareForReuse() {
         super.prepareForReuse()
         disposeBag = DisposeBag()
         }
         
         //初始化
         override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
         super.init(style: style, reuseIdentifier: reuseIdentifier)
         
         //添加按钮
         button = UIButton(frame:CGRect(x:0, y:0, width:40, height:25))
         button.setTitle("点击", for:.normal) //普通状态下的文字
         button.backgroundColor = UIColor.orange
         button.layer.cornerRadius = 5
         button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
         self.addSubview(button)
         }
         
         //布局
         override func layoutSubviews() {
         super.layoutSubviews()
         button.center = CGPoint(x: bounds.size.width - 35, y: bounds.midY)
         }
         
         required init?(coder aDecoder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
         }
         }
         
         
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(MyTableCell.self, forCellReuseIdentifier: "Cell")
         //单元格无法选中
         self.tableView.allowsSelection = false
         self.view.addSubview(self.tableView!)
         
         //初始化数据
         let items = Observable.just([
         "文本输入框的用法",
         "开关按钮的用法",
         "进度条的用法",
         "文本标签的用法",
         ])
         
         //设置单元格数据（其实就是对 cellForRowAt 的封装）
         items
         .bind(to: tableView.rx.items) { (tableView, row, element) in
         //初始化cell
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
         as! MyTableCell
         cell.textLabel?.text = "\(element)"
         
         //cell中按钮点击事件订阅
         cell.button.rx.tap.asDriver()
         .drive(onNext: { [weak self] in
         self?.showAlert(title: "\(row)", message: element)
         }).disposed(by: cell.disposeBag)
         
         return cell
         }
         .disposed(by: disposeBag)
         }
         
         //显示弹出框信息
         func showAlert(title: String, message: String) {
         let alert = UIAlertController(title: title, message: message,
         preferredStyle: .alert)
         alert.addAction(UIAlertAction(title: "确定", style: .cancel))
         self.present(alert, animated: true)
         }
         }
         */
        
        // TODO:===通知NotificationCenter===
        /*
         监听应用进入后台的通知:
         .takeUntil(self.rx.deallocated)：
         它的作用是保证页面销毁的时候自动移除通知注册，避免内存浪费或奔溃
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         // 监听应用进入后台通知
         _ = NotificationCenter.default.rx
         .notification(NSNotification.Name.UIApplicationDidEnterBackground)
         .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
         .subscribe(onNext: { _ in
         print("程序进入到后台了")
         })
         }
         }
         
         监听键盘的通知:
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //添加文本输入框
         let textField = UITextField(frame: CGRect(x:20, y:100, width:200, height:30))
         textField.borderStyle = UITextBorderStyle.roundedRect
         textField.returnKeyType = .done
         self.view.addSubview(textField)
         
         //点击键盘上的完成按钮后，收起键盘
         textField.rx.controlEvent(.editingDidEndOnExit)
         .subscribe(onNext: {  _ in
         //收起键盘
         textField.resignFirstResponder()
         })
         .disposed(by: disposeBag)
         
         //监听键盘弹出通知
         _ = NotificationCenter.default.rx
         .notification(NSNotification.Name.UIKeyboardWillShow)
         .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
         .subscribe(onNext: { _ in
         print("键盘出现了")
         })
         
         //监听键盘隐藏通知
         _ = NotificationCenter.default.rx
         .notification(NSNotification.Name.UIKeyboardWillHide)
         .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
         .subscribe(onNext: { _ in
         print("键盘消失了")
         })
         }
         }
         
         自定义通知的发送与接收:
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         let observers = [MyObserver(name: "观察器1"),MyObserver(name: "观察器2")]
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         print("发送通知")
         let notificationName = Notification.Name(rawValue: "DownloadImageNotification")
         NotificationCenter.default.post(name: notificationName, object: self,
         userInfo: ["value1":"hangge.com", "value2" : 12345])
         print("通知完毕")
         }
         }
         
         
         class MyObserver: NSObject {
         
         var name:String = ""
         
         init(name:String){
         super.init()
         
         self.name = name
         
         // 接收通知：
         let notificationName = Notification.Name(rawValue: "DownloadImageNotification")
         _ = NotificationCenter.default.rx
         .notification(notificationName)
         .takeUntil(self.rx.deallocated) //页面销毁自动移除通知监听
         .subscribe(onNext: { notification in
         //获取通知数据
         let userInfo = notification.userInfo as! [String: AnyObject]
         let value1 = userInfo["value1"] as! String
         let value2 = userInfo["value2"] as! Int
         print("\(name) 获取到通知，用户数据是［\(value1),\(value2)］")
         //等待3秒
         sleep(3)
         print("\(name) 执行完毕")
         })
         }
         }
         */
        
        // MARK:===键值观察KVO===
        /*
         RxCocoa 提供了 2 个可观察序列 rx.observe 和 rx.observeWeakly，它们都是对 KVO 机制的封装，二者的区别如下。
         （1）性能比较
         
         
         rx.observe 更加高效，因为它是一个 KVO 机制的简单封装。
         
         rx.observeWeakly 执行效率要低一些，因为它要处理对象的释放防止弱引用（对象的 dealloc 关系）。
         
         （2）使用场景比较
         
         在可以使用 rx.observe 的地方都可以使用 rx.observeWeakly。
         使用 rx.observe 时路径只能包括 strong 属性，否则就会有系统崩溃的风险。而 rx.observeWeakly 可以用在 weak 属性上
         
         监听基本类型的属性:
         监听的属性需要有 dynamic 修饰符
         本样例需要使用 rx.observeWeakly，不能用 rx.observe，否则会造成循环引用，引起内存泄露
         
         class ViewController: UIViewController {
         
         let disposeBag = DisposeBag()
         
         @objc dynamic var message = "hangge.com"
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //定时器（1秒执行一次）
         Observable<Int>.interval(1, scheduler: MainScheduler.instance)
         .subscribe(onNext: { [unowned self] _ in
         //每次给字符串尾部添加一个感叹号
         self.message.append("!")
         }).disposed(by: disposeBag)
         
         //监听message变量的变化
         _ = self.rx.observeWeakly(String.self, "message")
         .subscribe(onNext: { (value) in
         print(value ?? "")
         })
         }
         }
         
         
         class ViewController: UIViewController {
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //监听视图frame的变化
         _ = self.rx.observe(CGRect.self, "view.frame")
         .subscribe(onNext: { frame in
         print("--- 视图尺寸发生变化 ---")
         print(frame!)
         print("\n")
         })
         }
         }
         
         // 渐变导航栏效果:
         class ViewController: UIViewController {
         
         var tableView:UITableView!
         
         ////导航栏背景视图
         var barImageView:UIView?
         
         let disposeBag = DisposeBag()
         
         override func viewDidLoad() {
         super.viewDidLoad()
         
         //导航栏背景色为橙色
         self.navigationController?.navigationBar.barTintColor = .orange
         
         //获取导航栏背景视图
         self.barImageView = self.navigationController?.navigationBar.subviews.first
         
         //创建表格视图
         self.tableView = UITableView(frame: self.view.frame, style:.plain)
         //创建一个重用的单元格
         self.tableView!.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
         self.view.addSubview(self.tableView!)
         
         //初始化数据
         let items = Observable.just(Array(0...100).map{ "这个是条目\($0)"})
         
         //设置单元格数据（其实就是对 cellForRowAt 的封装）
         items.bind(to: tableView.rx.items) { (tableView, row, element) in
         let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
         cell.textLabel?.text = "\(element)"
         return cell
         }
         .disposed(by: disposeBag)
         
         //使用kvo来监听视图偏移量变化
         _ = self.tableView.rx.observe(CGPoint.self, "contentOffset")
         .subscribe(onNext: {[weak self] offset in
         var delta = offset!.y / CGFloat(64) + 1
         delta = CGFloat.maximum(delta, 0)
         self?.barImageView?.alpha = CGFloat.minimum(delta, 1)
         })
         }
         }
         */
        
        
    }


    public func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    @IBAction func test111DidClicked(_ sender: Any) {
        self.test111VC = Test111ViewController()
        self.test111VC?.count = 100
    }
    
}

// callback hell: 回调地狱

/*
 Swift 中的元类型用 .Type 表示。比如 Int.Type 就是 Int 的元类型
 .Type 是类型，类型的 .self 是元类型的值
 let intMetatype: Int.Type = Int.self
 
 let instanceMetaType: String.Type = type(of: "string")
 let staicMetaType: String.Type = String.self
 .self 取到的是静态的元类型，声明的时候是什么类型就是什么类型。type(of:) 取的是运行时候的元类型，也就是这个实例 的类型
 */
