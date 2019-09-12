//
//  TestSwiftViewController.swift
//  NDL_Category
//
//  Created by dzcx on 2019/6/26.
//  Copyright © 2019 ndl. All rights reserved.
//

import Foundation
import UIKit

// 你可以通过一条语句同时创建Country和City的实例，而不产生循环强引用，并且capitalCity的属性能被直接访问，而不需要通过感叹号来展开它的可选值
// 每个国家必须有首都，每个城市必须属于一个国家
class Country {
    let name: String
    // 隐式解析可选类型的属性.这意味着像其他可选类型一样，capitalCity属性的默认值为nil，但是不需要展开它的值就能访问它
    /*
     由于capitalCity默认值为nil，一旦Country的实例在构造函数中给name属性赋值后，整个初始化过程就完成了。这意味着一旦name属性被赋值后，Country的构造函数就能引用并传递隐式的self。Country的构造函数在赋值capitalCity时，就能将self作为参数传递给City的构造函数
     */
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

// =======

//class SomeClass11 {
//    // 用闭包为属性提供默认值
//    let someProperty: SomeType = {
//        // 在这个闭包中给 someProperty 创建一个默认值
//        // someValue 必须和 SomeType 类型相同
//        return someValue
//    }()
//}
// 闭包结尾的大括号后面接了一对空的小括号。这用来告诉 Swift 立即执行此闭包。如果你忽略了这对括号，相当于将闭包本身作为值赋值给了属性，而不是将闭包的返回值赋值给属性
// 如果你使用闭包来初始化属性，请记住在闭包执行时，实例的其它部分都还没有初始化。这意味着你不能在闭包里访问其它属性，即使这些属性有默认值。同样，你也不能使用隐式的self属性，或者调用任何实例方法

class Document {
    var name: String?
    
    // 该构造器创建了一个 name 属性的值为 nil 的 document 实例
    init() {}
    // 该构造器创建了一个 name 属性的值为非空字符串的 document 实例
    init?(name: String) {
        self.name = name
        if name.isEmpty { return nil }
    }
}

// 这个子类重写了父类的两个指定构造器
class AutomaticallyNamedDocument: Document {
    override init() {
        super.init()
        self.name = "[Untitled]"
    }
    // 子类用一个非可失败构造器代替了父类的可失败构造器.
    override init(name: String) {
        super.init()
        if name.isEmpty {
            self.name = "[Untitled]"
        } else {
            self.name = name
        }
    }
}

class UntitledDocument: Document {
    override init() {
        // 你可以在子类的非可失败构造器中使用强制解包来调用父类的可失败构造器
        // 如果在调用父类的可失败构造器init?(name:)时传入的是空字符串，那么强制解包操作会引发运行时错误。不过，因为这里是通过非空的字符串常量来调用它，所以并不会发生运行时错误
        super.init(name: "[Untitled]")!
    }
}

// ======

class Product1 {
    let name: String
    init?(name: String) {
        if name.isEmpty { return nil }
        self.name = name
    }
}

class CartItem: Product1 {
    let quantity: Int
    
    init?(name: String, quantity: Int) {
        if quantity < 1 { return nil }
        self.quantity = quantity
        // 构造失败的传递
        super.init(name: name)
    }
}

enum TemperatureUnit {
    case Kelvin, Celsius, Fahrenheit
    init?(symbol: Character) {
        switch symbol {
        case "K":
            self = .Kelvin
        case "C":
            self = .Celsius
        case "F":
            self = .Fahrenheit
        default:
            return nil
        }
    }
}

// 自带一个可失败构造器init?(rawValue:)
enum TemperatureUnit1: Character {
    case Kelvin = "K", Celsius = "C", Fahrenheit = "F"
}

struct Animal {
    let species: String
    // 可失败构造器
    init?(species: String) {
        if species.isEmpty { return nil }
        self.species = species
    }
}

class Food {
    var name: String
    init(name: String) {
        self.name = name
    }
    convenience init() {
        self.init(name: "[Unnamed]")
    }
}

// ##尽管RecipeIngredient将父类的指定构造器重写为了便利构造器，它依然提供了父类的所有指定构造器的实现。RecipeIngredient会自动继承父类的所有便利构造器##
class RecipeIngredient: Food {
    var quantity: Int
    // 安全检查 1
    // 指定构造器必须保证它所在类引入的所有属性都必须先初始化完成，之后才能将其它构造任务向上代理给父类中的构造器
    init(name: String, quantity: Int) {
        self.quantity = quantity
        super.init(name: name)
    }
    // 这个便利构造器重写了父类的指定构造器init(name: String)，因此必须在前面使用override修饰符
    override convenience init(name: String) {
        self.init(name: name, quantity: 1)
    }
}

// 由于它为自己引入的所有属性都提供了默认值，并且自己没有定义任何构造器，ShoppingListItem将自动继承所有父类中的指定构造器和便利构造器
class ShoppingListItem: RecipeIngredient {
    var purchased = false
    var description: String {
        var output = "\(quantity) x \(name)"
        output += purchased ? " ✔" : " ✘"
        return output
    }
}

enum TriStateSwitch {
    case Off, Low, High
    mutating func next() {
        switch self {
        case .Off:
            self = .Low
        case .Low:
            self = .High
        case .High:
            self = .Off
        }
    }
}

struct Resolution {
    var width = 0
    var height = 0
}

struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}

// 值类型的构造器代理
struct Rect1 {
    var origin = Point()
    var size = Size()
    init() {}
    init(origin: Point, size: Size) {
        self.origin = origin
        self.size = size
    }
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        // 引用相同类型中的其它构造器
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
        
        // 简化 setter 声明
        // 如果计算属性的 setter 没有定义表示新值的参数名，则可以使用默认名称 newValue
        /*
        set {
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
        */
    }
}

class SomeClass {
    // 构造器
    init() {
        // 在此处执行构造过程
    }
    
    class func someTypeMethod() {
        // 在这里实现类型方法 调用: SomeClass.someTypeMethod
    }
}

// 属性观察器
class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) {
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}

struct Point1 {
    var x = 0.0, y = 0.0
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
    }
}

// 在可变方法中给 self 赋值
struct Point2 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        self = Point2(x: x + deltaX, y: y + deltaY)
    }
}

// 只读计算属性的声明可以去掉 get 关键字和花括号：
struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    var volume: Double {
        return width * height * depth
    }
}

struct Matrix {
    let rows: Int, columns: Int
    var grid: [Double]
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(repeating: 0.0, count: rows * columns)
    }
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows && column >= 0 && column < columns
    }
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row: row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
}

class TestSwiftViewController: UIViewController {
    var count = 0
    var completionHandlers: [() -> Void] = []
    
    // 下表语法
    subscript(index: Int) -> Int {
        get {
            // 返回一个适当的 Int 类型的值
            return 0
        }
        
        // newValue的类型和下标的返回类型相同
        set(newValue) {
            // 执行适当的赋值操作
        }
    }
    
    // 只读下标的get关键字：
//    subscript(index: Int) -> Int {
//        // 返回一个适当的 Int 类型的值
//    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.red
        
        let minValue = UInt8.min
        let maxValue = UInt8.max
        print(minValue)
        
        let twoThousand: UInt16 = 2_000
        let one: UInt8 = 1
        let twoThousandAndOne = twoThousand + UInt16(one)
        
        // 可选的句法类型和字面值用尾标 opt 来标记
        
        // Double精确度很高，至少有15位数字，而Float只有6位数字
        
        // 一个二进制数，前缀是0b
        // 一个八进制数，前缀是0o
        // 一个十六进制数，前缀是0x
        
        // 1.25e2 表示 1.25 × 10^2
        // 0xFp2 表示 15 × 2^2，等于 60.0
        
        // Int8类型的常量或者变量可以存储的数字范围是-128~127，而UInt8类型的常量或者变量能存储的数字范围是0~255
        
        // Swift 中，nil 不是指针——它是一个确定的值，用来表示值缺失
        // 任何类型的可选状态都可以被设置为 nil，不只是对象类型
        
        // 强制解析（forced unwrapping）
        // 可选绑定（optional binding）
        
        // 隐式解析可选类型（implicitly unwrapped optionals）
        // 可以把隐式解析可选类型当做一个可以自动解析的可选类型
        // 第一次被赋值之后，可以确定一个可选类型总会有值。在这种情况下，每次都要判断和解析可选值是非常低效的，因为可以确定它总会有值
        // 把想要用作可选的类型的后面的问号（String?）改成感叹号（String!）来声明一个隐式解析可选类型
        let possibleString: String? = "An optional string."
        let forcedString: String = possibleString! // 需要感叹号来获取值
        let assumedString: String! = "An implicitly unwrapped optional string."
        let implicitString: String = assumedString
        
        // typealias关键字来定义类型别名
        typealias AudioSample = UInt16
        var maxAmplitudeFound = AudioSample.min
        
        let possibleNumber = "123"
        let convertedNumber = Int(possibleNumber)
        // convertedNumber 被推测为类型 "Int?"， 或者类型 "optional Int"
        
        if let firstNumber = Int("4"), let secondNumber = Int("42"), firstNumber < secondNumber && secondNumber < 100 {
            print("\(firstNumber) < \(secondNumber) < 100")
        }
        // 在 if 条件语句中使用常量和变量来创建一个可选绑定，仅在 if 语句的句中(body)中才能获取到值。相反，在 guard 语句中使用常量和变量来创建一个可选绑定，仅在 guard 语句外且在语句后才能获取到值
        // guard的执行取决于一个表达式的布尔值。我们可以使用guard语句来要求条件必须为真时，以执行guard语句后的代码。不同于if语句，一个guard语句总是有一个else从句，如果条件不为真则执行else从句中的代码
        
        
        let age = -3
        assert(age >= 0, "A person's age cannot be less than zero")
        // 如果代码已经检查了条件，你可以使用 assertionFailure(_:file:line:)函数来表明断言失败了
        // assertionFailure("A person's age can't be less than zero.")
        
        // 先决条件
//        let index = 1 // 当表达式的结果为 false 的时候这条信息会被显示
//        precondition(index > 0, "Index must be greater than zero.")
        
//        fatalError("Unimplemented")
        
        
        // 提供恒等（===）和不恒等（!==）这两个比较符来判断两个对象是否引用同一个对象实例
        
//        (1, "zebra") < (2, "apple")   // true，因为 1 小于 2
//        (3, "apple") < (3, "bird")    // true，因为 3 等于 3，但是 apple 小于 bird
        
//        空合运算符（Nil Coalescing Operator）
//        空合运算符（a ?? b）将对可选类型 a 进行空判断，如果 a 包含一个值就进行解封，否则就返回一个默认值 b
        
        // 区间运算符（Range Operators）
        
        // 单侧区间
        let names = ["Anna", "Alex", "Brian", "Jack"]
        for name in names[2...] {
            print(name)
        }
        for name in names[...2] {
            print(name)
        }
        for name in names[..<2] {
            print(name)
        }
        
        let range = ...5
        range.contains(7)   // false
        range.contains(4)   // true
        range.contains(-1)  // true
        
//        逻辑运算符（Logical Operators）
        // 短路计算（short-circuit evaluation）
        
        // TODO:3.字符串和字符（Strings and Characters）
        // Swift 的String类型与 Foundation NSString类进行了无缝桥接
        let quotation = """
The White Rabbit put on his spectacles.  "Where shall I begin,
please your Majesty?" he asked.

"Begin at the beginning," the King said gravely, "and go on
till you come to the end; then stop."
"""
//        Unicode 标量，写成\u{n}(u为小写)，其中n为任意一到八位十六进制数且可用的 Unicode 位码
        let dollarSign = "\u{24}"             // $, Unicode 标量 U+0024
        let blackHeart = "\u{2665}"           // ♥, Unicode 标量 U+2665
        let sparklingHeart = "\u{1F496}"      // 💖, Unicode 标量 U+1F496
        
        var emptyString = ""               // 空字符串字面量
        var anotherEmptyString = String()  // 初始化方法
        // 两个字符串均为空并等价。
        
        // Swift 的String类型是值类型
        // Unicode 码位(code poing) 的范围是U+0000到U+D7FF或者U+E000到U+10FFFF。Unicode 标量不包括 Unicode 代理项(surrogate pair) 码位，其码位范围是U+D800到U+DFFF
        let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}" // 字形群
        // regionalIndicatorForUS 是 🇺🇸
        
        // 字符群集可以组成一个或者多个 Unicode 标量
        var word = "cafe"
        print("the number of characters in \(word) is \(word.count)")
        // 打印输出 "the number of characters in cafe is 4"
        
        word += "\u{301}"    // 拼接一个重音, U+0301
        print("the number of characters in \(word) is \(word.count)")
        // 打印输出 "the number of characters in café is 4"
        // 通过count属性返回的字符数量并不总是与包含相同字符的NSString的length属性相同。NSString的length属性是利用 UTF-16 表示的十六位代码单元数字，而不是 Unicode 可扩展的字符群集
        // Swift 的String类型是基于 Unicode 标量 建立的
        // 每一个 Swift 的Character类型代表一个可扩展的字形群。一个可扩展的字形群是一个或多个可生成人类可读的字符 Unicode 标量的有序排列
//        每一个String值都有一个关联的索引(index)类型，String.Index，它对应着字符串中的每一个Character的位置
        
        // TODO:4.集合类型 (Collection Types)
//        空数组
        var someInts = [Int]() // []
        // 空字典
        var namesOfIntegers = [Int: String]() // [:]
        // 可以使用下标语法来通过给某个键的对应值赋值为nil来从字典里移除一个键值对
        
        // 加法操作符（+）来组合两种已存在的相同类型数组
        // 可以利用下标来一次改变一系列数据值，即使新数据和原有数据的数量是不一样的 shoppingList[4...6] = ["Bananas", "Apples"]
        // 如果我们同时需要每个数据项的值和索引值，可以使用enumerated()方法来进行数组遍历。enumerated()返回一个由每一个数据项索引值和数据值组成的元组
//        for (index, value) in shoppingList.enumerated() {
//            print("Item \(String(index + 1)): \(value)")
//        }
        
        // TODO:5.控制流（Control Flow）
        for tickMark in stride(from: 0, to: 60, by: 5) {
            // (0, 5, 10, 15 ... 45, 50, 55)
        }
        
        // switch: 每一个 case XX : 分支都必须包含至少一条语句
        let anotherCharacter: Character = "a"
        switch anotherCharacter {
        case "a", "A":// 可以将这个两个值组合成一个复合匹配，并且用逗号分开
            print("The letter A")
        default:
            print("Not the letter A")
        }
        // case 分支的模式也可以是一个值的区间
        
        // case匹配元组: 使用下划线（_）来匹配所有可能的值
        let somePoint = (1, 1)
        switch somePoint {
        case (0, 0):
            print("\(somePoint) is at the origin")
        case (_, 0):
            print("\(somePoint) is on the x-axis")
        case (0, _):
            print("\(somePoint) is on the y-axis")
        case (-2...2, -2...2):
            print("\(somePoint) is inside the box")
        default:
            print("\(somePoint) is outside of the box")
        }
        
        // switch: 值绑定（Value Bindings）
        let anotherPoint = (2, 0)
        switch anotherPoint {
        case (let x, 0):
            print("on the x-axis with an x value of \(x)")
        case (0, let y):
            print("on the y-axis with a y value of \(y)")
        case let (x, y):
            print("somewhere else at (\(x), \(y))")
        }
        
        // where
        let yetAnotherPoint = (1, -1)
        switch yetAnotherPoint {
        case let (x, y) where x == y:
            print("(\(x), \(y)) is on the line x == y")
        case let (x, y) where x == -y:
            print("(\(x), \(y)) is on the line x == -y")
        case let (x, y):
            print("(\(x), \(y)) is just some arbitrary point")
        }
        
        // 复合匹配: 当多个条件可以使用同一种方法来处理时，可以将这几种可能放在同一个case后面，并且用逗号隔开
        let someCharacter: Character = "e"
        switch someCharacter {
        case "a", "e", "i", "o", "u":
            print("\(someCharacter) is a vowel")
        case "b", "c", "d", "f", "g", "h", "j", "k", "l", "m",
             "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z":
            print("\(someCharacter) is a consonant")
        default:
            print("\(someCharacter) is not a vowel or a consonant")
        }
        
        // 控制转移语句
//        continue
//        break
//        fallthrough
//        return
//        throw
        
        // 标签:
//        gameLoop: while square != finalSquare {
//            diceRoll += 1
//            if diceRoll == 7 { diceRoll = 1 }
//            switch square + diceRoll {
//            case finalSquare:
//                // 骰子数刚好使玩家移动到最终的方格里，游戏结束。
//                break gameLoop
//            case let newSquare where newSquare > finalSquare:
//                // 骰子数将会使玩家的移动超出最后的方格，那么这种移动是不合法的，玩家需要重新掷骰子
//                continue gameLoop
//            default:
//                // 合法移动，做正常的处理
//                square += diceRoll
//                square += board[square]
//            }
//        }
        
        // 提前退出: guard 一个guard语句总是有一个else从句，如果条件不为真则执行else从句中的代码
        // 如果guard语句的条件被满足，则继续执行guard语句大括号后的代码。将变量或者常量的可选绑定作为guard语句的条件，都可以保护guard语句后面的代码
        
        // TODO:===6.函数（Functions）
        // 无参数函数, 多参数函数, 无返回值函数, 多重返回值函数, 可选元组返回类型
        // 可选元组类型如 (Int, Int)? 与元组包含可选类型如 (Int?, Int?) 是不同的
        // 函数参数标签: 参数标签在调用函数的时候使用；调用的时候需要将函数的参数标签写在对应的参数前面.默认情况下，函数参数使用参数名称来作为它们的参数标签
        // 可变参数（variadic parameter）
        
        var someInt = 3
        var anotherInt = 107
        swapTwoInts(&someInt, &anotherInt)
        
        // 函数类型
        var mathFunction: (Int, Int) -> Int = addTwoInts
        
        // TODO:===7.闭包（Closures） 闭包的函数体部分由关键字in引入
        let names1 = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        // 内联闭包表达式
        names1.sorted(by: { (s1: String, s2: String) -> Bool in
            return s1 > s2
        })
        
        names1.sorted(by: backward)
        
        // 根据上下文推断类型
        names1.sorted(by: { s1, s2 in return s1 > s2 } )
        
        // 单表达式闭包隐式返回
        names1.sorted(by: { s1, s2 in s1 > s2 } )
        
        // 参数名称缩写
        // Swift 自动为内联闭包提供了参数名称缩写功能，你可以直接通过 $0，$1，$2 来顺序调用闭包的参数
        names1.sorted(by: { $0 > $1 } )
        
        // 运算符方法
        // Swift 的 String 类型定义了关于大于号（>）的字符串实现
        names1.sorted(by: >)
        
        
        /*
         闭包表达式语法
         { (parameters) -> returnType in
         statements
         }
         */
        
        // ===尾随闭包===
        // 如果你需要将一个很长的闭包表达式作为最后一个参数传递给函数，可以使用尾随闭包来增强函数的可读性
        // 不使用尾随闭包进行函数调用
        someFunctionThatTakesAClosure(closure: {
            
        })
        
        // 使用尾随闭包进行函数调用
        someFunctionThatTakesAClosure() {
            // 闭包主体部分
        }
        // 如果闭包表达式是函数或方法的唯一参数，则当你使用尾随闭包时，你甚至可以把 () 省略掉
        someFunctionThatTakesAClosure {
            
        }
        
        let incrementByTen = makeIncrementer(forIncrement: 10)
        incrementByTen() // 返回的值为10
        incrementByTen() // 返回的值为20
        let alsoIncrementByTen = incrementByTen
        alsoIncrementByTen()// 返回的值为30
        // 闭包是引用类型
        
        // 逃逸闭包
        // 当一个闭包作为参数传到一个函数中，但是这个闭包在函数返回之后才被执行，我们称该闭包从函数中逃逸
        // 将一个闭包标记为 @escaping 意味着你必须在闭包中显式地引用 self
        
        // 副作用（Side Effect）
        // 自动闭包
        var customersInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
        print(customersInLine.count) // 打印出 "5"
        // customerProvider 的类型是 () -> String
        let customerProvider = { customersInLine.remove(at: 0) }
        print(customersInLine.count) // 打印出 "5"
        
        print("Now serving \(customerProvider())!")
        // Prints "Now serving Chris!"
        print(customersInLine.count)
        // 打印出 "4"
        
        serve(customer: { customersInLine.remove(at: 0) } )
        // 通过将参数标记为 @autoclosure 来接收一个自动闭包. 现在你可以将该函数当作接受 String 类型参数（而非闭包）的函数来调用
        serve1(customer: customersInLine.remove(at: 0))
        
        // TODO:===8.枚举（Enumerations）
        // 枚举类型是一等（first-class）类型.它们采用了很多在传统上只被类（class）所支持的特性，例如计算属性（computed properties），用于提供枚举值的附加信息，实例方法（instance methods），用于提供和枚举值相关联的功能。枚举也可以定义构造函数（initializers）来提供一个初始值；可以在原始实现的基础上扩展它们的功能；还可以遵循协议（protocols）来提供标准的功能
        
        var directionToHead = CompassPoint.west
        // 一旦directionToHead被声明为CompassPoint类型，你可以使用更简短的点语法将其设置为另一个CompassPoint的值
        directionToHead = .east
        
        // 在判断一个枚举类型的值时，switch语句必须穷举所有情况
        // 当不需要匹配每个枚举成员的时候，你可以提供一个default分支来涵盖所有未明确处理的枚举成员
        switch directionToHead {
        case .north:
            print("Lots of planets have a north")
        case .south:
            print("Watch out for penguins")
        case .east:
            print("Where the sun rises")
        case .west:
            print("Where the skies are blue")
        }
        
        var productBarcode = Barcode.upc(8, 85909, 51226, 3)
        switch productBarcode {
        case .upc(let numberSystem, let manufacturer, let product, let check):
            print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
        case .qrCode(let productCode):
            print("QR code: \(productCode).")
        }
        
        switch productBarcode {
        case let .upc(numberSystem, manufacturer, product, check):
            print("UPC: \(numberSystem), \(manufacturer), \(product), \(check).")
        case let .qrCode(productCode):
            print("QR code: \(productCode).")
        }
        
        let earthsOrder = Planet.earth.rawValue
        
        // 使用原始值初始化枚举实例
        // 如果在定义枚举类型的时候使用了原始值，那么将会自动获得一个初始化方法，这个方法接收一个叫做rawValue的参数，参数类型即为原始值类型，返回值则是枚举成员或nil
        let possiblePlanet = Planet(rawValue: 7)
        // possiblePlanet 类型为 Planet? 值为 Planet.uranus
        // 原始值构造器是一个可失败构造器，因为并不是每一个原始值都有与之对应的枚举成员
        
        // 递归枚举 你可以在枚举成员前加上indirect来表示该成员可递归
        let five = ArithmeticExpression.number(5)
        let four = ArithmeticExpression.number(4)
        let sum = ArithmeticExpression.addition(five, four)
        let product = ArithmeticExpression.multiplication(sum, ArithmeticExpression.number(2))
        
        print(evaluate(product))
        
        // TODO:===9.类和结构体
        /*
         Swift 中类和结构体有很多共同点。共同处在于:
         定义属性用于存储值
         定义方法用于提供功能
         定义下标操作使得可以通过下标语法来访问实例所包含的值
         定义构造器用于生成初始化值
         通过扩展以增加默认实现的功能
         实现协议以提供某种标准功能
         
         与结构体相比，类还有如下的附加功能:
         继承允许一个类继承另一个类的特征
         类型转换允许在运行时检查和解释一个类实例的类型
         析构器允许一个类实例释放任何其所被分配的资源
         引用计数允许对一个类的多次引用
         */
        // 结构体总是通过被复制的方式在代码中传递，不使用引用计数
        // 结构体和类都使用构造器语法来生成新的实例
        // 所有结构体都有一个自动生成的成员逐一构造器，用于初始化新结构体实例中成员的属性。新实例中各个属性的初始值可以通过属性的名称传递到成员逐一构造器之中.类实例没有默认的成员逐一构造器
        let vga = Resolution(width:640, height: 480)
        // 结构体和枚举是值类型,值类型被赋予给一个变量、常量或者被传递给一个函数的时候，其值会被拷贝.这意味着它们的实例，以及实例中所包含的任何值类型属性，在代码中传递的时候都会被复制
        // 所有的基本类型：整数（Integer）、浮点数（floating-point）、布尔值（Boolean）、字符串（string)、数组（array）和字典（dictionary），都是值类型
        // 类是引用类型
        
        // 恒等运算符: 如果能够判定两个常量或者变量是否引用同一个类实例将会很有帮助。为了达到这个目的，Swift 内建了两个恒等运算符：
        // 等价于（===）
        // 不等价于（!==）
        
        /*
         “等价于”（用三个等号表示，===）与“等于”（用两个等号表示，==）的不同:
         “等价于”表示两个类类型（class type）的常量或者变量引用同一个类实例。
         “等于”表示两个实例的值“相等”或“相同”，判定时要遵照设计者定义的评判标准，因此相对于“相等”来说，这是一种更加合适的叫法
         */
        
        /*
         请考虑构建结构体:
         该数据结构的主要目的是用来封装少量相关简单数据值。
         有理由预计该数据结构的实例在被赋值或传递时，封装的数据将会被拷贝而不是被引用。
         该数据结构中储存的值类型属性，也应该被拷贝，而不是被引用。
         该数据结构不需要去继承另一个既有类型的属性或者行为
         */
        
        // TODO:===10.属性 (Properties)
        // 存储属性存储常量或变量作为实例的一部分，而计算属性计算（不是存储）一个值。计算属性可以用于类、结构体和枚举，存储属性只能用于类和结构体
        
        // 存储属性
       
        // 常量结构体的存储属性: //由于结构体（struct）属于值类型。当值类型的实例被声明为常量的时候，它的所有属性也就成了常量。属于引用类型的类（class）则不一样。把一个引用类型的实例赋给一个常量后，仍然可以修改该实例的变量属性
        
        // 延迟存储属性:
        // 延迟存储属性是指当第一次被调用的时候才会计算其初始值的属性。在属性声明前使用 lazy 来标示一个延迟存储属性.必须将延迟存储属性声明成变量（使用 var 关键字）.因为属性的初始值可能在实例构造完成之后才会得到。而常量属性在构造过程完成之前必须要有初始值，因此无法声明成延迟属性
        
        // 存储属性和实例变量: Swift 中的属性没有对应的实例变量
        
        // 计算属性: 计算属性不直接存储值，而是提供一个 getter 和一个可选的 setter，来间接获取和设置其他属性或变量的值
        
        // 只读计算属性: 只有 getter 没有 setter 的计算属性就是只读计算属性。只读计算属性总是返回一个值，可以通过点运算符访问，但不能设置新的值
        
        // 必须使用 var 关键字定义计算属性，包括只读计算属性，因为它们的值不是固定的。let 关键字只用来声明常量属性，表示初始化后再也无法修改的值
        
        // 属性观察器: 属性观察器监控和响应属性值的变化，每次属性被设置值的时候都会调用属性观察器，即使新值和当前值相同的时候也不例外
        // 可以为除了延迟存储属性之外的其他存储属性添加属性观察器.也可以通过重写属性的方式为继承的属性（包括存储属性和计算属性）添加属性观察器。你不必为非重写的计算属性添加属性观察器，因为可以通过它的 setter 直接监控和响应值的变化
        /*
         willSet 在新的值被设置之前调用
         willSet 观察器会将新的属性值作为常量参数传入，在 willSet 的实现代码中可以为这个参数指定一个名称，如果不指定则参数仍然可用，这时使用默认名称 newValue 表示
         didSet 在新的值被设置之后立即调用
         didSet 观察器会将旧的属性值作为参数传入，可以为该参数命名或者使用默认参数名 oldValue。如果在  didSet 方法中再次对该属性赋值，那么新值会覆盖旧的值
         */
        // 父类的属性在子类的构造器中被赋值时，它在父类中的 willSet 和 didSet 观察器会被调用，随后才会调用子类的观察器。在父类初始化方法调用之前，子类给属性赋值时，观察器不会被调用
        // 如果将属性通过 in-out 方式传入函数，willSet 和 didSet 也会调用。这是因为 in-out 参数采用了拷入拷出模式：即在函数内部使用的是参数的 copy，函数结束后，又对参数重新赋值
        
        // 全局变量和局部变量: 计算属性和属性观察器所描述的功能也可以用于全局变量和局部变量
        // 全局变量是在函数、方法、闭包或任何类型之外定义的变量。局部变量是在函数、方法或闭包内部定义的变量
        // 全局的常量或变量都是延迟计算的，跟延迟存储属性相似，不同的地方在于，全局的常量或变量不需要标记lazy修饰符。局部范围的常量或变量从不延迟计算
        
        // 使用关键字 static 来定义类型属性.无论创建了多少个该类型的实例，这些属性都只有唯一一份。这种属性就是类型属性
        // 类型属性是通过类型本身来访问
        
        // TODO:===11.方法（Methods）
        // 实例方法 (Instance Methods)
        // 因为方法就是函数，只是这个函数与某个类型相关联了
        // 结构体和枚举是值类型。默认情况下，值类型的属性不能在它的实例方法中被修改。 可以为这个方法选择可变(mutating)行为。然后就可以从其方法内部改变它的属性。并且这个方法做的任何改变都会在方法执行结束时写回到原始结构中
        // 类型方法: 在方法的func关键字之前加上关键字static，来指定类型方法。类还可以用关键字class来允许子类重写父类的方法实现
        // 在 Swift 中，你可以为所有的类、结构体和枚举定义类型方法
        
        // @discardableResult 允许在调用方法时忽略返回值，不会产生编译警告
        
        // TODO:===12.下标
        // 一个类型可以定义多个下标，通过不同索引类型进行重载
        // 下标语法: 下标可以设定为读写或只读。这种行为由 getter 和 setter 实现。下标可以接受任意数量的入参
        // 下标通常作为访问集合，列表或序列中元素的快捷方式。你可以针对自己特定的类或结构体的功能来自由地以最恰当的方式实现下标
        // Swift 的Dictionary类型的下标接受并返回可选类型的值。同时这也提供了一种通过键删除对应值的方式，只需将键对应的值赋值为nil即可
        
        // TODO:===13.继承
        // 在 Swift 中，继承是区分「类」与其它类型的一个基本特征
        // 重写: 子类可以为继承来的实例方法，类方法，实例属性，或下标提供自己定制的实现。我们把这种行为叫重写
        // 你需要在重写定义的前面加上override关键字.在下标的重写实现中，可以通过super[someIndex]来访问超类版本中的相同下标
        // 重写属性的 Getters 和 Setters:
        // 你可以将一个继承来的只读属性重写为一个读写属性，只需要在重写版本的属性里提供 getter 和 setter 即可.但是，你不可以将一个继承来的读写属性重写为一个只读属性
        // 如果你在重写属性中提供了 setter，那么你也一定要提供 getter。如果你不想在重写版本中的 getter 里修改继承来的属性值，你可以直接通过super.someProperty来返回继承来的值，其中someProperty是你要重写的属性的名字
        // 重写属性观察器:
        // 你不可以为继承来的常量存储型属性或继承来的只读计算型属性添加属性观察器
        // 你不可以同时提供重写的 setter 和重写的属性观察器。如果你想观察属性值的变化，并且你已经为那个属性提供了定制的 setter，那么你在 setter 中就可以观察到任何值变化了
        
        // 防止重写:
        // 你可以通过把方法，属性或下标标记为final来防止它们被重写，只需要在声明关键字前加上final修饰符即可（例如：final var，final func，final class func，以及final subscript）
        // 可以通过在关键字class前添加final修饰符（final class）来将整个类标记为 final 的。这样的类是不可被继承的
        
        // TODO:===14.构造过程
        // 类和结构体在创建实例时，必须为所有存储型属性设置合适的初始值。存储型属性的值不能处于一个未知的状态
        // 你可以在构造器中为存储型属性赋初值，也可以在定义属性时为其设置默认值
        // 当你为存储型属性设置默认值或者在构造器中为其赋值时，它们的值是被直接设置的，不会触发任何属性观察者
        // 如果你不希望为构造器的某个参数提供外部名字，你可以使用下划线(_)来显式描述它的外部名
        
        // 构造过程中常量属性的修改:
        // 你可以在构造过程中的任意时间点给常量属性指定一个值，只要在构造过程结束时是一个确定的值。一旦常量属性被赋值，它将永远不可更改
        // 对于类的实例来说，它的常量属性只能在定义它的类的构造过程中修改；不能在子类中修改
        
        // 默认构造器:
        // 如果结构体或类的所有属性都有默认值，同时没有自定义的构造器，那么 Swift 会给这些结构体或类提供一个默认构造器（default initializers）。这个默认构造器将简单地创建一个所有属性值都设置为默认值的实例
        
        // 结构体的逐一成员构造器:
        
        // 值类型的构造器代理:
        // 构造器可以通过调用其它构造器来完成实例的部分构造过程。这一过程称为构造器代理，它能减少多个构造器间的代码重复
        // 对于值类型，你可以使用self.init在自定义的构造器中引用相同类型中的其它构造器。并且你只能在构造器内部调用self.init
        
        // 里面的所有存储型属性——包括所有继承自父类的属性——都必须在构造过程中设置初始值
        // Swift 为类类型提供了两种构造器来确保实例中所有存储型属性都能获得初始值，它们分别是指定构造器和便利构造器。
        // 指定构造器和便利构造器:
        // 指定构造器是类中最主要的构造器。一个指定构造器将初始化类中提供的所有属性，并根据父类链往上调用父类的构造器来实现父类的初始化
        // ###每一个类都必须拥有至少一个指定构造器###
        // 便利构造器是类中比较次要的、辅助型的构造器。你可以定义便利构造器来调用同一个类中的指定构造器，并为其参数提供默认值。你也可以定义便利构造器来创建一个特殊用途或特定输入值的实例
        /*
         指定构造器:
         init(parameters) {
         statements
         }
         
         便利构造器:
         convenience init(parameters) {
         statements
         }
         */
        // 类的构造器代理规则:
        /*
         规则 1
         指定构造器必须调用其直接父类的的指定构造器。
         
         规则 2
         便利构造器必须调用同类中定义的其它构造器。
         
         规则 3
         便利构造器必须最终导致一个指定构造器被调用
         
         指定构造器必须总是向上代理
         便利构造器必须总是横向代理
         */
        
        // 两段式构造过程
        // Swift 中类的构造过程包含两个阶段。第一个阶段，每个存储型属性被引入它们的类指定一个初始值。当每个存储型属性的初始值被确定后，第二阶段开始，它给每个类一次机会，在新实例准备使用之前进一步定制它们的存储型属性
        
        // Swift 编译器将执行 4 种有效的安全检查:
        /*
         安全检查 1
         指定构造器必须保证它所在类引入的所有属性都必须先初始化完成，之后才能将其它构造任务向上代理给父类中的构造器
         安全检查 2
         指定构造器必须先向上代理调用父类构造器，然后再为继承的属性设置新值。如果没这么做，指定构造器赋予的新值将被父类中的构造器所覆盖
         安全检查 3
         便利构造器必须先代理调用同一类中的其它构造器，然后再为任意属性赋新值。如果没这么做，便利构造器赋予的新值将被同一类中其它指定构造器所覆盖
         安全检查 4
         构造器在第一阶段构造完成之前，不能调用任何实例方法，不能读取任何实例属性的值，不能引用self作为一个值
         类实例在第一阶段结束以前并不是完全有效的。只有第一阶段完成后，该实例才会成为有效实例，才能访问属性和调用方法
         */
        
        /*
         两段式构造过程中基于上述安全检查的构造流程展示：
         
         阶段 1
         某个指定构造器或便利构造器被调用。
         完成新实例内存的分配，但此时内存还没有被初始化。
         指定构造器确保其所在类引入的所有存储型属性都已赋初值。存储型属性所属的内存完成初始化。
         指定构造器将调用父类的构造器，完成父类属性的初始化。
         这个调用父类构造器的过程沿着构造器链一直往上执行，直到到达构造器链的最顶部。
         当到达了构造器链最顶部，且已确保所有实例包含的存储型属性都已经赋值，这个实例的内存被认为已经完全初始化。此时阶段 1 完成。
         阶段 2
         从顶部构造器链一直往下，每个构造器链中类的指定构造器都有机会进一步定制实例。构造器此时可以访问self、修改它的属性并调用实例方法等等。
         最终，任意构造器链中的便利构造器可以有机会定制实例和使用self
         */
        
        // 构造器的继承和重写:
        // Swift 中的子类默认情况下不会继承父类的构造器.父类的构造器仅会在安全和适当的情况下被继承
        // 当你在编写一个和父类中指定构造器相匹配的子类构造器时，你实际上是在重写父类的这个指定构造器。因此，你必须在定义子类构造器时带上override修饰符。即使你重写的是系统自动提供的默认构造器，也需要带上override修饰符
        // 当你重写一个父类的指定构造器时，你总是需要写override修饰符，即使你的子类将父类的指定构造器重写为了便利构造器
        // 如果你编写了一个和父类便利构造器相匹配的子类构造器，由于子类不能直接调用父类的便利构造器.你的子类并未对一个父类构造器提供重写。最后的结果就是，你在子类中“重写”一个父类便利构造器时，不需要加override前缀
        // ###子类可以在初始化时修改继承来的变量属性，但是不能修改继承来的常量属性###
        
        // 构造器的自动继承:
        // 子类在默认情况下不会继承父类的构造器。但是如果满足特定条件，父类构造器是可以被自动继承的
        /*
         假设你为子类中引入的所有新属性都提供了默认值，以下 2 个规则适用：
         
         规则 1
         如果子类没有定义任何指定构造器，它将自动继承所有父类的指定构造器。
         
         规则 2
         如果子类提供了所有父类指定构造器的实现——无论是通过规则 1 继承过来的，还是提供了自定义实现——它将自动继承所有父类的便利构造器。
         
         即使你在子类中添加了更多的便利构造器，这两条规则仍然适用
         对于规则 2，子类可以将父类的指定构造器实现为便利构造器
         */
        
        // 可失败构造器: 其语法为在init关键字后面添加问号(init?)
        // 如果一个类、结构体或枚举类型的对象，在构造过程中有可能失败，则为其定义一个可失败构造器。这里所指的“失败”是指，如给构造器传入无效的参数值，或缺少某种所需的外部资源，又或是不满足某种必要的条件等
        // 可失败构造器的参数名和参数类型，不能与其它非可失败构造器的参数名，及其参数类型相同
        // 可失败构造器会创建一个类型为自身类型的可选类型的对象。你通过return nil语句来表明可失败构造器在何种情况下应该“失败”
        
        // 枚举类型的可失败构造器:
        // 带原始值的枚举类型的可失败构造器: 带原始值的枚举类型会自带一个可失败构造器init?(rawValue:),该可失败构造器有一个名为rawValue的参数，其类型和枚举类型的原始值类型一致，如果该参数的值能够和某个枚举成员的原始值匹配，则该构造器会构造相应的枚举成员，否则构造失败
        
        // 构造失败的传递:
        // 类，结构体，枚举的可失败构造器可以横向代理到类型中的其他可失败构造器。类似的，子类的可失败构造器也能向上代理到父类的可失败构造器.无论是向上代理还是横向代理，如果你代理到的其他可失败构造器触发构造失败，整个构造过程将立即终止，接下来的任何构造代码不会再被执行
        // 可失败构造器也可以代理到其它的非可失败构造器。通过这种方式，你可以增加一个可能的失败状态到现有的构造过程中
        // 重写一个可失败构造器:
        // 如同其它的构造器，你可以在子类中重写父类的可失败构造器。或者你也可以用子类的非可失败构造器重写一个父类的可失败构造器。这使你可以定义一个不会构造失败的子类，即使父类的构造器允许构造失败
        // ##当你用子类的非可失败构造器重写父类的可失败构造器时，向上代理到父类的可失败构造器的唯一方式是对父类的可失败构造器的返回值进行强制解包##
        // 你可以用非可失败构造器重写可失败构造器，但反过来却不行
        
        // 可失败构造器 init!:
        // 通常来说我们通过在init关键字后添加问号的方式（init?）来定义一个可失败构造器，但你也可以通过在init后面添加惊叹号的方式来定义一个可失败构造器（init!），该可失败构造器将会构建一个对应类型的隐式解包可选类型的对象
        // 你可以在init?中代理到init!，反之亦然。你也可以用init?重写init!，反之亦然。你还可以用init代理到init!，不过，一旦init!构造失败，则会触发一个断言
        
        // 必要构造器: 在类的构造器前添加required修饰符表明所有该类的子类都必须实现该构造器
        // 在子类重写父类的必要构造器时，必须在子类的构造器前也添加required修饰符，表明该构造器要求也应用于继承链后面的子类。在重写父类中必要的指定构造器时，不需要添加override修饰符
        // 如果子类继承的构造器能满足必要构造器的要求，则无须在子类中显式提供必要构造器的实现
        /*
         class SomeClass {
         required init() {
         // 构造器的实现代码
         }
         }
         
         class SomeSubclass: SomeClass {
         required init() {
         // 构造器的实现代码
         }
         }
         */
        
        // 通过闭包或函数设置属性的默认值:
        // 如果某个存储型属性的默认值需要一些定制或设置，你可以使用闭包或全局函数为其提供定制的默认值。每当某个属性所在类型的新实例被创建时，对应的闭包或函数会被调用，而它们的返回值会当做默认值赋值给这个属性
        
        // TODO:===15.析构过程
        // 析构器只适用于类类型，当一个类的实例被释放之前，析构器会被立即调用。析构器用关键字deinit来标示
        // 析构器是在实例释放发生前被自动调用。你不能主动调用析构器。子类继承了父类的析构器，并且在子类析构器实现的最后，父类的析构器会被自动调用。即使子类没有提供自己的析构器，父类的析构器也同样会被调用
        /*
         deinit {
         // 执行析构过程
         }
         */
        // 因为直到实例的析构器被调用后，实例才会被释放，所以析构器可以访问实例的所有属性，并且可以根据那些属性可以修改它的行为（比如查找一个需要被关闭的文件）
        
        // TODO:===16.自动引用计数
        // Swift 使用自动引用计数（ARC）机制来跟踪和管理你的应用程序的内存
        // 为了确保使用中的实例不会被销毁，ARC 会跟踪和计算每一个实例正在被多少属性，常量和变量所引用。哪怕实例的引用数为1，ARC都不会销毁这个实例
        // 解决实例之间的循环强引用:
        // Swift 提供了两种办法用来解决你在使用类的属性时所遇到的循环强引用问题：弱引用（weak reference）和无主引用（unowned reference）
        // 当其他的实例有更短的生命周期时，使用弱引用，也就是说，当其他实例析构在先时。在上面公寓的例子中，很显然一个公寓在它的生命周期内会在某个时间段没有它的主人，所以一个弱引用就加在公寓类里面，避免循环引用。相比之下，当其他实例有相同的或者更长生命周期时，请使用无主引用
        
        // 弱引用:
        // 声明属性或者变量时，在前面加上weak关键字表明这是一个弱引用
        // ARC 会在引用的实例被销毁后自动将其赋值为nil。并且因为弱引用可以允许它们的值在运行时被赋值为nil，所以它们会被定义为可选类型变量，而不是常量
        // 当 ARC 设置弱引用为nil时，属性观察不会被触发
        
        // 无主引用:
        // 你可以在声明属性或者变量时，在前面加上关键字unowned表示这是一个无主引用
        // 无主引用通常都被期望拥有值。不过 ARC 无法在实例被销毁后将无主引用设为nil，因为非可选类型的变量不允许被赋值为nil
        // 对于需要禁用运行时的安全检查的情况（例如，出于性能方面的原因），Swift还提供了不安全的无主引用。与所有不安全的操作一样，你需要负责检查代码以确保其安全性。 你可以通过unowned(unsafe)来声明不安全无主引用
        
        /*
         Person和Apartment的例子展示了两个属性的值都允许为nil，并会潜在的产生循环强引用。这种场景最适合用弱引用来解决。
         
         Customer和CreditCard的例子展示了一个属性的值允许为nil，而另一个属性的值不允许为nil，这也可能会产生循环强引用。这种场景最适合通过无主引用来解决。
         
         然而，存在着第三种场景，在这种场景中，两个属性都必须有值，并且初始化完成后永远不会为nil。在这种场景中，需要一个类使用无主属性，而另外一个类使用隐式解析可选属性
         */
        
        // 闭包引起的循环强引用: 循环强引用还会发生在当你将一个闭包赋值给类实例的某个属性，并且这个闭包体中又使用了这个类实例时.导致了闭包“捕获”self，从而产生了循环强引用
        // Swift 提供了一种优雅的方法来解决这个问题，称之为闭包捕获列表（closure capture list）
        // ###因为只有当初始化完成以及self确实存在后，才能访问lazy属性###
        
        // 解决闭包引起的循环强引用:
        // 在定义闭包时同时定义捕获列表作为闭包的一部分，通过这种方式可以解决闭包和类实例之间的循环强引用。捕获列表定义了闭包体内捕获一个或者多个引用类型的规则
        // Swift 有如下要求：只要在闭包内使用self的成员，就要用self.someProperty或者self.someMethod()（而不只是someProperty或someMethod()）.这提醒你可能会一不小心就捕获了self
        /*
         如果闭包有参数列表和返回类型，把捕获列表放在它们前面：
         
         lazy var someClosure: (Int, String) -> String = {
         [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
         // 这里是闭包的函数体
         }
         
         如果闭包没有指明参数列表或者返回类型，即它们会通过上下文推断，那么可以把捕获列表和关键字in放在闭包最开始的地方：
         
         lazy var someClosure: Void -> String = {
         [unowned self, weak delegate = self.delegate!] in
         // 这里是闭包的函数体
         }
         */
        
        // 在闭包和捕获的实例总是互相引用并且总是同时销毁时，将闭包内的捕获定义为无主引用
        // 相反的，在被捕获的引用可能会变为nil时，将闭包内的捕获定义为弱引用。弱引用总是可选类型，并且当引用的实例被销毁后，弱引用的值会自动置为nil
        // 如果被捕获的引用绝对不会变为nil，应该用无主引用，而不是弱引用
        
        // TODO:===17.可选链式调用
        // 通过在想调用的属性、方法、或下标的可选值后面放一个问号（?），可以定义一个可选链。这一点很像在可选值后面放一个叹号（!）来强制展开它的值。它们的主要区别在于当可选值为空时可选链式调用只会调用失败，然而强制展开将会触发运行时错误
        // 可选链式调用是一种可以在当前值可能为nil的可选值上请求和调用属性、方法及下标的方法。如果可选值有值，那么调用就会成功；如果可选值是nil，那么调用将返回nil。多个调用可以连接在一起形成一个调用链，如果其中任何一个节点为nil，整个调用链都会失败，即返回nil
        // 不论这个调用的属性、方法及下标返回的值是不是可选值，它的返回结果都是一个可选值。你可以利用这个返回值来判断你的可选链式调用是否调用成功，如果调用有返回值则说明调用成功，返回nil则说明调用失败
        // 可选链式调用的返回结果与原本的返回结果具有相同的类型，但是被包装成了一个可选值
        /*
         class Person {
         var residence: Residence?
         }
         
         class Residence {
         var numberOfRooms = 1
         }
         
         let john = Person()
         // 这会引发运行时错误
         // let roomCount = john.residence!.numberOfRooms
         john.residence为非nil值的时候，上面的调用会成功,当residence为nil的时候上面这段代码会触发运行时错误
         
         可选链式调用提供了另一种访问numberOfRooms的方式，使用问号（?）来替代原来的叹号（!）
         if let roomCount = john.residence?.numberOfRooms {
         print("John's residence has \(roomCount) room(s).")
         } else {
         print("Unable to retrieve the number of rooms.")
         }
         在residence后面添加问号之后，Swift 就会在residence不为nil的情况下访问numberOfRooms
         只要使用可选链式调用就意味着numberOfRooms会返回一个Int?而不是Int
         */
        
        /*
         可以通过可选链式调用来设置属性值:
         let someAddress = Address()
         someAddress.buildingNumber = "29"
         someAddress.street = "Acacia Road"
         john.residence?.address = someAddress // 可选链式调用失败时，等号右侧的代码不会被执行
         
         通过john.residence来设定address属性也会失败，因为john.residence当前为nil
         
         */
        
        // 通过可选链式调用调用方法:
        // 没有返回值的方法具有隐式的返回类型Void.这意味着没有返回值的方法也会返回()，或者说空的元组
        // 通过可选链式调用来调用这个方法，该方法的返回类型会是Void?，而不是Void，因为通过可选链式调用得到的返回值都是可选的
        /*
         我们就可以使用if语句来判断能否成功调用printNumberOfRooms()方法，即使方法本身没有定义返回值。通过判断返回值是否为nil可以判断调用是否成功
         
         if john.residence?.printNumberOfRooms() != nil {
         print("It was possible to print the number of rooms.")
         } else {
         print("It was not possible to print the number of rooms.")
         }
         
         if (john.residence?.address = someAddress) != nil {
         print("It was possible to set the address.")
         } else {
         print("It was not possible to set the address.")
         }
         // 打印 “It was not possible to set the address.”
         */
        
        // 通过可选链式调用访问下标:
        // 通过可选链式调用访问可选值的下标时，应该将问号放在下标方括号的前面而不是后面。可选链式调用的问号一般直接跟在可选表达式的后面
        /*
         if let firstRoomName = john.residence?[0].name {
         print("The first room name is \(firstRoomName).")
         } else {
         print("Unable to retrieve the first room name.")
         }
         // 打印 “Unable to retrieve the first room name.”
         */
        
        // 访问可选类型的下标:
        /*
         比如 Swift 中Dictionary类型的键的下标，可以在下标的结尾括号后面放一个问号来在其可选返回值上进行可选链式调用：
         
         var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
         testScores["Dave"]?[0] = 91
         testScores["Bev"]?[0] += 1
         testScores["Brian"]?[0] = 72
         // "Dave" 数组现在是 [91, 82, 84]，"Bev" 数组现在是 [80, 94, 81]
         */
        
        // 连接多层可选链式调用:
        /*
         如果你访问的值不是可选的，可选链式调用将会返回可选值。
         如果你访问的值就是可选的，可选链式调用不会让可选返回值变得“更可选”
         
         通过可选链式调用访问一个Int值，将会返回Int?，无论使用了多少层可选链式调用。
         类似的，通过可选链式调用访问Int?值，依旧会返回Int?值，并不会返回Int??
         
         访问john中的residence属性中的address属性中的street属性。这里使用了两层可选链式调用，residence以及address都是可选值：
         if let johnsStreet = john.residence?.address?.street {
         print("John's street name is \(johnsStreet).")
         } else {
         print("Unable to retrieve the address.")
         }
         // 打印 “Unable to retrieve the address.”
         
         john.residence现在包含一个有效的Residence实例。然而，john.residence.address的值当前为nil。因此，调用john.residence?.address?.street会失败
         */
        
        
        // 在方法的可选返回值上进行可选链式调用:
        /*
         if let buildingIdentifier = john.residence?.address?.buildingIdentifier() {
         print("John's building identifier is \(buildingIdentifier).")
         }
         
         如果要在该方法的返回值上进行可选链式调用，在方法的圆括号后面加上问号即可：
         
         if let beginsWithThe =
         john.residence?.address?.buildingIdentifier()?.hasPrefix("The") {
         if beginsWithThe {
         print("John's building identifier begins with \"The\".")
         } else {
         print("John's building identifier does not begin with \"The\".")
         }
         }
         在方法的圆括号后面加上问号是因为你要在buildingIdentifier()方法的可选返回值上进行可选链式调用，而不是方法本身
         */
        
        // TODO:===18.错误处理
        // 错误处理（Error handling）是响应错误以及从错误中恢复的过程。Swift 提供了在运行时对可恢复错误的抛出、捕获、传递和操作的一等公民支持
        /*
         Swift 的枚举类型尤为适合构建一组相关的错误状态，枚举的关联值还可以提供错误状态的额外信息
         enum VendingMachineError: Error {
         case invalidSelection                     //选择无效
         case insufficientFunds(coinsNeeded: Int) //金额不足
         case outOfStock                             //缺货
         }
         
         throw VendingMachineError. insufficientFunds(coinsNeeded: 5)
         */
        
        // 用 throwing 函数传递错误:
        // 在函数声明的参数列表之后加上throws关键字。一个标有throws关键字的函数被称作throwing 函数.如果这个函数指明了返回值类型，throws关键词需要写在箭头（->）的前面
        // func canThrowErrors() throws -> String
        // func cannotThrowErrors() -> String
        // 一个 throwing 函数可以在其内部抛出错误，并将错误传递到函数被调用时的作用域
        // 只有 throwing 函数可以传递错误。任何在某个非 throwing 函数内部抛出的错误只能在函数内部处理
        
        /*
         func vend(itemNamed name: String) throws {
         guard let item = inventory[name] else {
         throw VendingMachineError.invalidSelection
         }
         
         guard item.count > 0 else {
         throw VendingMachineError.outOfStock
         }
         
         guard item.price <= coinsDeposited else {
         throw VendingMachineError.insufficientFunds(coinsNeeded: item.price - coinsDeposited)
         }
         
         coinsDeposited -= item.price
         
         var newItem = item
         newItem.count -= 1
         inventory[name] = newItem
         
         print("Dispensing \(name)")
         }
         
         因为vend(itemNamed:)方法会传递出它抛出的任何错误，在你的代码中调用此方法的地方，必须要么直接处理这些错误——使用do-catch语句，try?或try!；要么继续将这些错误传递下去
         
         func buyFavoriteSnack(person: String, vendingMachine: VendingMachine) throws {
         let snackName = favoriteSnacks[person] ?? "Candy Bar"
         try vendingMachine.vend(itemNamed: snackName)
         }
         */
        
        // Do-Catch 处理错误:
        /*
         do {
         try expression
         statements
         } catch pattern 1 {
         statements
         } catch pattern 2 where condition {
         statements
         }
         
         var vendingMachine = VendingMachine()
         vendingMachine.coinsDeposited = 8
         do {
         try buyFavoriteSnack(person: "Alice", vendingMachine: vendingMachine)
         } catch VendingMachineError.invalidSelection {
         print("Invalid Selection.")
         } catch VendingMachineError.outOfStock {
         print("Out of Stock.")
         } catch VendingMachineError.insufficientFunds(let coinsNeeded) {
         print("Insufficient funds. Please insert an additional \(coinsNeeded) coins.")
         }
         
         如果错误被抛出，相应的执行会马上转移到catch子句中，并判断这个错误是否要被继续传递下去。如果没有错误抛出，do子句中余下的语句就会被执行
         */
        
        // 将错误转换成可选值:
        // 可以使用try?通过将错误转换成一个可选值来处理错误。如果在评估try?表达式时一个错误被抛出，那么表达式的值就是nil
        /*
         func someThrowingFunction() throws -> Int {
         // ...
         }
         
         let x = try? someThrowingFunction()
         
         let y: Int?
         do {
         y = try someThrowingFunction()
         } catch {
         y = nil
         }
         如果someThrowingFunction()抛出一个错误，x和y的值是nil。否则x和y的值就是该函数的返回值。注意，无论someThrowingFunction()的返回值类型是什么类型，x和y都是这个类型的可选类型
         */
        
        // 禁用错误传递:
        // 某个throwing函数实际上在运行时是不会抛出错误的，在这种情况下，你可以在表达式前面写try!来禁用错误传递，这会把调用包装在一个不会有错误抛出的运行时断言中。如果真的抛出了错误，你会得到一个运行时错误
        // 该函数从给定的路径加载图片资源，如果图片无法载入则抛出一个错误。在这种情况下，因为图片是和应用绑定的，运行时不会有错误抛出，所以适合禁用错误传递
        // let photo = try! loadImage(atPath: "./Resources/John Appleseed.jpg")
        
        // 指定清理操作:
        // 可以使用defer语句在即将离开当前代码块时执行一系列语句。该语句让你能执行一些必要的清理工作，不管是以何种方式离开当前代码块的——无论是由于抛出错误而离开，或是由于诸如return、break的语句
        // defer语句将代码的执行延迟到当前的作用域退出之前。该语句由defer关键字和要被延迟执行的语句组成。延迟执行的语句不能包含任何控制转移语句，例如break、return语句，或是抛出一个错误
        // 延迟执行的操作会按照它们声明的顺序从后往前执行——也就是说，第一条defer语句中的代码最后才执行，第二条defer语句中的代码倒数第二个执行，以此类推。最后一条语句会第一个执行
        /*
         func processFile(filename: String) throws {
         if exists(filename) {
         let file = open(filename)
         defer {
         close(file)
         }
         while let line = try file.readline() {
         // 处理文件。
         }
         // close(file) 会在这里被调用，即作用域的最后。
         }
         }
         */
        
        // TODO:===19.类型转换
        // 类型转换在 Swift 中使用 is 和 as 操作符实现
        
        // 检查类型: 用类型检查操作符（is）来检查一个实例是否属于特定子类型
        /*
         for item in library {
         if item is Movie {
         movieCount += 1
         } else if item is Song {
         songCount += 1
         }
         }
         */
        
        // 向下转型:
        // 某类型的一个常量或变量可能在幕后实际上属于一个子类。当确定是这种情况时，你可以尝试向下转到它的子类型，用类型转换操作符（as? 或 as!）
        // 因为向下转型可能会失败，类型转型操作符带有两种不同形式。条件形式as? 返回一个你试图向下转成的类型的可选值。强制形式 as! 把试图向下转型和强制解包转换结果结合为一个操作
        /*
         for item in library {
         if let movie = item as? Movie { // 父->子
         print("Movie: '\(movie.name)', dir. \(movie.director)")
         } else if let song = item as? Song {
         print("Song: '\(song.name)', by \(song.artist)")
         }
         }
         */
        
        // Any 和 AnyObject 的类型转换:
        /*
        Swift 为不确定类型提供了两种特殊的类型别名：
        
        Any 可以表示任何类型，包括函数类型。
        AnyObject 可以表示任何类类型的实例
        */
        
        /*
         var things = [Any]()
         
         things.append(0)
         things.append(0.0)
         things.append(42)
         things.append(3.14159)
         things.append("hello")
         things.append((3.0, 5.0))
         things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
         things.append({ (name: String) -> String in "Hello, \(name)" })
         
         for thing in things {
         switch thing {
         case 0 as Int:
         print("zero as an Int")
         case 0 as Double:
         print("zero as a Double")
         case let someInt as Int:
         print("an integer value of \(someInt)")
         case let someDouble as Double where someDouble > 0:
         print("a positive double value of \(someDouble)")
         case is Double:
         print("some other double value that I don't want to print")
         case let someString as String:
         print("a string value of \"\(someString)\"")
         case let (x, y) as (Double, Double):
         print("an (x, y) point at \(x), \(y)")
         case let movie as Movie:
         print("a movie called '\(movie.name)', dir. \(movie.director)")
         case let stringConverter as (String) -> String:
         print(stringConverter("Michael"))
         default:
         print("something else")
         }
         }
         
         // zero as an Int
         // zero as a Double
         // an integer value of 42
         // a positive double value of 3.14159
         // a string value of "hello"
         // an (x, y) point at 3.0, 5.0
         // a movie called 'Ghostbusters', dir. Ivan Reitman
         // Hello, Michael
         
         Any类型可以表示所有类型的值，包括可选类型。Swift 会在你用Any类型来表示一个可选值的时候，给你一个警告。如果你确实想使用Any类型来承载可选值，你可以使用as操作符显式转换为Any，如下所示：
         
         let optionalNumber: Int? = 3
         things.append(optionalNumber)        // 警告
         things.append(optionalNumber as Any) // 没有警告
         */
        
        // TODO:===20.嵌套类型
        // Swift 允许你定义嵌套类型，可以在支持的类型中定义嵌套的枚举、类和结构体
        /*
         // BlackjackCard（二十一点）
         struct BlackjackCard {
         
         // 嵌套的 Suit 枚举
         enum Suit: Character {
         case spades = "♠", hearts = "♡", diamonds = "♢", clubs = "♣"
         }
         
         // 嵌套的 Rank 枚举
         enum Rank: Int {
         case two = 2, three, four, five, six, seven, eight, nine, ten
         case jack, queen, king, ace
         struct Values {
         let first: Int, second: Int?
         }
         var values: Values {
         switch self {
         case .ace:
         return Values(first: 1, second: 11)
         case .jack, .queen, .king:
         return Values(first: 10, second: nil)
         default:
         return Values(first: self.rawValue, second: nil)
         }
         }
         }
         
         // BlackjackCard 的属性和方法
         let rank: Rank, suit: Suit
         var description: String {
         var output = "suit is \(suit.rawValue),"
         output += " value is \(rank.values.first)"
         if let second = rank.values.second {
         output += " or \(second)"
         }
         return output
         }
         }
         
         引用嵌套类型
         在外部引用嵌套类型时，在嵌套类型的类型名前加上其外部类型的类型名作为前缀：
         let heartsSymbol = BlackjackCard.Suit.hearts.rawValue
         */
        
        // TODO:===21.扩展（Extensions）
        // 扩展 就是为一个已有的类、结构体、枚举类型或者协议类型添加新功能。扩展和 Objective-C 中的分类类似
        /*
         Swift 中的扩展可以：
         
         添加计算型属性和计算型类型属性
         定义实例方法和类型方法
         提供新的构造器
         定义下标
         定义和使用新的嵌套类型
         使一个已有类型符合某个协议
         
         在 Swift 中，你甚至可以对协议进行扩展，提供协议要求的实现，或者添加额外的功能，从而可以让符合协议的类型拥有这些功能
         ##扩展可以为一个类型添加新的功能，但是不能重写已有的功能##
         
         extension SomeType {
         // 为 SomeType 添加的新功能写到这里
         }
         
         可以通过扩展来扩展一个已有类型，使其采纳一个或多个协议。在这种情况下，无论是类还是结构体，协议名字的书写方式完全一样：
         extension SomeType: SomeProtocol, AnotherProctocol {
         // 协议实现写到这里
         }
         
         计算型属性：
         扩展可以为已有类型添加计算型实例属性和计算型类型属性
         extension Double {
         var km: Double { return self * 1_000.0 }
         var m : Double { return self }
         var cm: Double { return self / 100.0 }
         var mm: Double { return self / 1_000.0 }
         var ft: Double { return self / 3.28084 }
         }
         let oneInch = 25.4.mm
         print("One inch is \(oneInch) meters")
         // 打印 “One inch is 0.0254 meters”
         
         扩展可以添加新的计算型属性，但是不可以添加存储型属性，也不可以为已有属性添加属性观察器
         
         构造器:
         扩展可以为已有类型添加新的构造器
         扩展能为类添加新的便利构造器，但是它们不能为类添加新的指定构造器或析构器。指定构造器和析构器必须总是由原始的类实现来提供
         如果你使用扩展为一个值类型添加构造器，同时该值类型的原始实现中未定义任何定制的构造器且所有存储属性提供了默认值，那么我们就可以在扩展中的构造器里调用默认构造器和逐一成员构造器
         struct Size {
         var width = 0.0, height = 0.0
         }
         struct Point {
         var x = 0.0, y = 0.0
         }
         struct Rect {
         var origin = Point()
         var size = Size()
         }
         
         let defaultRect = Rect() // 默认构造器
         // 逐一成员构造器
         let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
         size: Size(width: 5.0, height: 5.0))
         
         extension Rect {
         init(center: Point, size: Size) {
         let originX = center.x - (size.width / 2)
         let originY = center.y - (size.height / 2)
         self.init(origin: Point(x: originX, y: originY), size: size)
         }
         }
         
         方法:
         扩展可以为已有类型添加新的实例方法和类型方法。下面的例子为 Int 类型添加了一个名为 repetitions 的实例方法：
         
         extension Int {
         func repetitions(task: () -> Void) {
         for _ in 0..<self {
         task()
         }
         }
         }
         
         可变实例方法:
         extension Int {
         mutating func square() {
         self = self * self
         }
         }
         
         下标:
         extension Int {
         subscript(digitIndex: Int) -> Int {
         var decimalBase = 1
         for _ in 0..<digitIndex {
         decimalBase *= 10
         }
         return (self / decimalBase) % 10
         }
         }
         746381295[0]
         // 返回 5
         746381295[1]
         // 返回 9
         
         嵌套类型:
         扩展可以为已有的类、结构体和枚举添加新的嵌套类型
         extension Int {
         enum Kind {
         case Negative, Zero, Positive
         }
         var kind: Kind {
         switch self {
         case 0:
         return .Zero
         case let x where x > 0:
         return .Positive
         default:
         return .Negative
         }
         }
         }
         
         func printIntegerKinds(_ numbers: [Int]) {
         for number in numbers {
         switch number.kind {
         case .Negative:
         print("- ", terminator: "")
         case .Zero:
         print("0 ", terminator: "")
         case .Positive:
         print("+ ", terminator: "")
         }
         }
         print("")
         }
         由于已知 number.kind 是 Int.Kind 类型，因此在 switch 语句中，Int.Kind 中的所有成员值都可以使用简写形式，例如使用 . Negative 而不是 Int.Kind.Negative
         */

        // TODO:===22.协议
        // 规定了用来实现某一特定任务或者功能的方法、属性，以及其他需要的东西。类、结构体或枚举都可以遵循协议，并为协议定义的这些要求提供具体实现。某个类型能够满足某个协议的要求，就可以说该类型遵循这个协议
        /*
         protocol SomeProtocol {
         // 这里是协议的定义部分
         }
         
         struct SomeStructure: FirstProtocol, AnotherProtocol {
         // 这里是结构体的定义部分
         }
         
         class SomeClass: SomeSuperClass, FirstProtocol, AnotherProtocol {
         // 这里是类的定义部分
         }
         
         属性要求:
         协议可以要求遵循协议的类型提供特定名称和类型的实例属性或类型属性。协议不指定属性是存储型属性还是计算型属性，它只指定属性的名称和类型。此外，协议还指定属性是可读的还是可读可写的
         如果协议要求属性是可读可写的，那么该属性不能是常量属性或只读的计算型属性。如果协议只要求属性是可读的，那么该属性不仅可以是可读的，如果代码需要的话，还可以是可写的。
         协议总是用 var 关键字来声明变量属性，在类型声明后加上 { set get } 来表示属性是可读可写的，可读属性则用 { get } 来表示：
         
         protocol SomeProtocol {
         var mustBeSettable: Int { get set }
         var doesNotNeedToBeSettable: Int { get }
         }
         
         在协议中定义类型属性时，总是使用 static 关键字作为前缀。当类类型遵循协议时，除了 static 关键字，还可以使用 class 关键字来声明类型属性：
         
         protocol AnotherProtocol {
         static var someTypeProperty: Int { get set }
         }
         
         protocol FullyNamed {
         var fullName: String { get }
         }
         struct Person: FullyNamed {
         var fullName: String
         }
         let john = Person(fullName: "John Appleseed")
         // john.fullName 为 "John Appleseed"
         
         方法要求:
         协议可以要求遵循协议的类型实现某些指定的实例方法或类方法
         不支持为协议中的方法的参数提供默认值
         在协议中定义类方法的时候，总是使用 static 关键字作为前缀。当类类型遵循协议时，除了 static 关键字，还可以使用 class 关键字作为前缀：
         
         protocol SomeProtocol {
         static func someTypeMethod()
         }
         下面的例子定义了一个只含有一个实例方法的协议：
         
         protocol RandomNumberGenerator {
         func random() -> Double
         }
         
         Mutating 方法要求:
         实现协议中的 mutating 方法时，若是类类型，则不用写 mutating 关键字。而对于结构体和枚举，则必须写  mutating 关键字
         
         构造器要求:
         协议可以要求遵循协议的类型实现指定的构造器。你可以像编写普通构造器那样，在协议的定义里写下构造器的声明，但不需要写花括号和构造器的实体：
         
         protocol SomeProtocol {
         init(someParameter: Int)
         }
         
         你可以在遵循协议的类中实现构造器，无论是作为指定构造器，还是作为便利构造器。无论哪种情况，你都必须为构造器实现标上 required 修饰符：
         
         class SomeClass: SomeProtocol {
         // 必要构造器
         required init(someParameter: Int) {
         // 这里是构造器的实现部分
         }
         }
         使用 required 修饰符可以确保所有子类也必须提供此构造器实现，从而也能符合协议
         如果类已经被标记为 final，那么不需要在协议构造器的实现中使用 required 修饰符，因为 final 类不能有子类
         
         如果一个子类重写了父类的指定构造器，并且该构造器满足了某个协议的要求，那么该构造器的实现需要同时标注  required 和 override 修饰符
         protocol SomeProtocol {
         init()
         }
         
         class SomeSuperClass {
         init() {
         // 这里是构造器的实现部分
         }
         }
         
         class SomeSubClass: SomeSuperClass, SomeProtocol {
         // 因为遵循协议，需要加上 required
         // 因为继承自父类，需要加上 override
         required override init() {
         // 这里是构造器的实现部分
         }
         }
         
         可失败构造器要求:
         遵循协议的类型可以通过可失败构造器（init?）或非可失败构造器（init）来满足协议中定义的可失败构造器要求。协议中定义的非可失败构造器要求可以通过非可失败构造器（init）或隐式解包可失败构造器（init!）来满足
         
         协议作为类型:
         作为函数、方法或构造器中的参数类型或返回值类型
         作为常量、变量或属性的类型
         作为数组、字典或其他容器中的元素类型
         协议是一种类型，因此协议类型的名称应与其他类型（例如 Int，Double，String）的写法相同，使用大写字母开头的驼峰式写法
         class Dice {
         let sides: Int
         let generator: RandomNumberGenerator// 协议作为类型
         init(sides: Int, generator: RandomNumberGenerator) {
         self.sides = sides
         self.generator = generator
         }
         func roll() -> Int {
         return Int(generator.random() * Double(sides)) + 1
         }
         }
         
         委托（代理）模式:
         委托模式的实现很简单：定义协议来封装那些需要被委托的功能，这样就能确保遵循协议的类型能提供这些功能。委托模式可以用来响应特定的动作，或者接收外部数据源提供的数据，而无需关心外部数据源的类型
         
         protocol TextRepresentable {
         var textualDescription: String { get }
         }
         可以通过扩展，令先前提到的 Dice 类遵循并符合 TextRepresentable 协议：
         extension Dice: TextRepresentable {
         var textualDescription: String {
         return "A \(sides)-sided dice"
         }
         }
         
         
         当一个类型已经符合了某个协议中的所有要求，却还没有声明遵循该协议时，可以通过空扩展体的扩展来遵循该协议：
         struct Hamster {
         var name: String
         var textualDescription: String {
         return "A hamster named \(name)"
         }
         }
         extension Hamster: TextRepresentable {}
         
         协议类型的集合:
         let things: [TextRepresentable] = [game, d12, simonTheHamster]
         for thing in things {
         print(thing.textualDescription)
         }
         thing 是 TextRepresentable 类型而不是 Dice，DiceGame，Hamster 等类型
         
         协议的继承:
         协议能够继承一个或多个其他协议，可以在继承的协议的基础上增加新的要求。协议的继承语法与类的继承相似，多个被继承的协议间用逗号分隔：
         
         protocol InheritingProtocol: SomeProtocol, AnotherProtocol {
         // 这里是协议的定义部分
         }
         
         类类型专属协议:
         你可以在协议的继承列表中，通过添加 class 关键字来限制协议只能被类类型遵循，而结构体或枚举不能遵循该协议。class 关键字必须第一个出现在协议的继承列表中，在其他继承的协议之前：
         
         protocol SomeClassOnlyProtocol: class, SomeInheritedProtocol {
         // 这里是类类型专属协议的定义部分
         }
         
         协议合成:
         有时候需要同时遵循多个协议，你可以将多个协议采用 SomeProtocol & AnotherProtocol 这样的格式进行组合，称为 协议合成（protocol composition）。你可以罗列任意多个你想要遵循的协议，以与符号(&)分隔
         protocol Named {
         var name: String { get }
         }
         protocol Aged {
         var age: Int { get }
         }
         struct Person: Named, Aged {
         var name: String
         var age: Int
         }
         func wishHappyBirthday(to celebrator: Named & Aged) {
         print("Happy birthday, \(celebrator.name), you're \(celebrator.age)!")
         }
         let birthdayPerson = Person(name: "Malcolm", age: 21)
         wishHappyBirthday(to: birthdayPerson)
         // 打印 “Happy birthday Malcolm - you're 21!”
         
         将Location类和前面的Named协议进行组合：
         class Location {
         var latitude: Double
         var longitude: Double
         init(latitude: Double, longitude: Double) {
         self.latitude = latitude
         self.longitude = longitude
         }
         }
         class City: Location, Named {
         var name: String
         init(name: String, latitude: Double, longitude: Double) {
         self.name = name
         super.init(latitude: latitude, longitude: longitude)
         }
         }
         func beginConcert(in location: Location & Named) {
         print("Hello, \(location.name)!")
         }
         
         let seattle = City(name: "Seattle", latitude: 47.6, longitude: -122.3)
         beginConcert(in: seattle)
         // Prints "Hello, Seattle!"
         
         检查协议一致性:
         is 和 as 操作符来检查协议一致性，即是否符合某协议，并且可以转换到指定的协议类型
         is 用来检查实例是否符合某个协议，若符合则返回 true，否则返回 false。
         as? 返回一个可选值，当实例符合某个协议时，返回类型为协议类型的可选值，否则返回 nil。
         as! 将实例强制向下转换到某个协议类型，如果强转失败，会引发运行时错误。
         
         // Circle，Country，Animal 并没有一个共同的基类，尽管如此，它们都是类，它们的实例都可以作为  AnyObject 类型的值
         let objects: [AnyObject] = [
         Circle(radius: 2.0),
         Country(area: 243_610),
         Animal(legs: 4)
         ]
         
         for object in objects {
         if let objectWithArea = object as? HasArea {
         print("Area is \(objectWithArea.area)")
         } else {
         print("Something that doesn't have an area")
         }
         }
         objects 数组中的元素的类型并不会因为强转而丢失类型信息，它们仍然是 Circle，Country，Animal 类型。然而，当它们被赋值给 objectWithArea 常量时，只被视为 HasArea 类型，因此只有 area 属性能够被访问
         
         可选的协议要求:
         协议可以定义可选要求，遵循协议的类型可以选择是否实现这些要求
         在协议中使用 optional 关键字作为前缀来定义可选要求。可选要求用在你需要和 Objective-C 打交道的代码中。协议和可选要求都必须带上@objc属性
         标记 @objc 特性的协议只能被继承自 Objective-C 类的类或者 @objc 类遵循，其他类以及结构体和枚举均不能遵循这种协议
         使用可选要求时（例如，可选的方法或者属性），它们的类型会自动变成可选的。比如，一个类型为  (Int) -> String 的方法会变成 ((Int) -> String)?。需要注意的是整个函数类型是可选的，而不是函数的返回值
         协议中的可选要求可通过可选链式调用来使用，因为遵循协议的类型可能没有实现这些可选要求。类似  someOptionalMethod?(someArgument) 这样，你可以在可选方法名称后加上 ? 来调用可选方法
         
         @objc protocol CounterDataSource {
         @objc optional func incrementForCount(count: Int) -> Int
         @objc optional var fixedIncrement: Int { get }
         }
         CounterDataSource 协议中的方法和属性都是可选的，因此遵循协议的类可以不实现这些要求，尽管技术上允许这样做，不过最好不要这样写
         class Counter {
         var count = 0
         var dataSource: CounterDataSource?
         func increment() {
         // 这里使用了两层可选链式调用。首先，由于 dataSource 可能为 nil，因此在 dataSource 后边加上了 ?，以此表明只在 dataSource 非空时才去调用 increment(forCount:) 方法。其次，即使 dataSource 存在，也无法保证其是否实现了 increment(forCount:) 方法，因为这个方法是可选的。因此，increment(forCount:) 方法同样使用可选链式调用进行调用，只有在该方法被实现的情况下才能调用它，所以在 increment(forCount:) 方法后边也加上了 ?
         // 调用 increment(forCount:) 方法在上述两种情形下都有可能失败，所以返回值为 Int? 类型。虽然在  CounterDataSource 协议中，increment(forCount:) 的返回值类型是非可选 Int
         if let amount = dataSource?.incrementForCount?(count) {
         count += amount
         } else if let amount = dataSource?.fixedIncrement {
         count += amount
         }
         }
         }
         
         class ThreeSource: NSObject, CounterDataSource {
         let fixedIncrement = 3
         }
         
         @objc class TowardsZeroSource: NSObject, CounterDataSource {
         func increment(forCount count: Int) -> Int {
         if count == 0 {
         return 0
         } else if count < 0 {
         return 1
         } else {
         return -1
         }
         }
         }
         
         协议扩展:
         协议可以通过扩展来为遵循协议的类型提供属性、方法以及下标的实现。通过这种方式，你可以基于协议本身来实现这些功能，而无需在每个遵循协议的类型中都重复同样的实现，也无需使用全局函数
         可以扩展 RandomNumberGenerator 协议来提供 randomBool() 方法。该方法使用协议中定义的  random() 方法来返回一个随机的 Bool 值：
         
         extension RandomNumberGenerator {
         func randomBool() -> Bool {
         return random() > 0.5
         }
         }
         
         提供默认实现:
         可以通过协议扩展来为协议要求的属性、方法以及下标提供默认的实现。如果遵循协议的类型为这些要求提供了自己的实现，那么这些自定义实现将会替代扩展中的默认实现被使用
         通过协议扩展为协议要求提供的默认实现和可选的协议要求不同。虽然在这两种情况下，遵循协议的类型都无需自己实现这些要求，但是通过扩展提供的默认实现可以直接调用，而无需使用可选链式调用
         
         PrettyTextRepresentable 协议继承自 TextRepresentable 协议，可以为其提供一个默认的  prettyTextualDescription 属性，只是简单地返回 textualDescription 属性的值：
         extension PrettyTextRepresentable {
         var prettyTextualDescription: String {
         return textualDescription
         }
         }
         
         为协议扩展添加限制条件:
         在扩展协议的时候，可以指定一些限制条件，只有遵循协议的类型满足这些限制条件时，才能获得协议扩展提供的默认实现。这些限制条件写在协议名之后，使用 where 子句来描述
         
         你可以扩展 CollectionType 协议，但是只适用于集合中的元素遵循了 TextRepresentable 协议的情况：
         extension Collection where Iterator.Element: TextRepresentable {
         var textualDescription: String {
         let itemsAsText = self.map { $0.textualDescription }
         return "[" + itemsAsText.joined(separator: ", ") + "]"
         }
         }
         
         如果多个协议扩展都为同一个协议要求提供了默认实现，而遵循协议的类型又同时满足这些协议扩展的限制条件，那么将会使用限制条件最多的那个协议扩展提供的默认实现
         
         */
        
        // TODO:===23.泛型
        // 泛型代码让你能够根据自定义的需求，编写出适用于任意类型、灵活可重用的函数及类型。它能让你避免代码的重复，用一种清晰和抽象的方式来表达代码的意图
    
        
        /*
         泛型函数:
         占位类型名（T），并用尖括号括起来（<T>）
         func swapTwoValues<T>(_ a: inout T, _ b: inout T) {
         let temporaryA = a
         a = b
         b = temporaryA
         }
         
         类型参数:
         你可提供多个类型参数，将它们都写在尖括号中，用逗号分开
         
         命名类型参数:
         请始终使用大写字母开头的驼峰命名法（例如 T 和 MyTypeParameter）来为类型参数命名，以表明它们是占位类型
         
         MARK:泛型类型:
         Swift 还允许你定义泛型类型。这些自定义类、结构体和枚举可以适用于任何类型
         struct Stack<Element> {
         var items = [Element]()
         mutating func push(_ item: Element) {
         items.append(item)
         }
         mutating func pop() -> Element {
         return items.removeLast()
         }
         }
         
         var stackOfStrings = Stack<String>()
         stackOfStrings.push("uno")
         stackOfStrings.push("dos")
         
         MARK:扩展一个泛型类型:
         当你扩展一个泛型类型的时候，你并不需要在扩展的定义中提供类型参数列表。原始类型定义中声明的类型参数列表在扩展中可以直接使用，并且这些来自原始类型中的参数名称会被用作原始定义中类型参数的引用
         extension Stack {
         var topItem: Element? {
         return items.isEmpty ? nil : items[items.count - 1]
         }
         }
         
         MARK:类型约束:
         字典的键的类型必须是可哈希（hashable）
         ##类型约束可以指定一个类型参数必须继承自指定类，或者符合一个特定的协议或协议组合##
         所有的 Swift 基本类型（例如 String、Int、Double 和 Bool）默认都是可哈希的,符合 Hashable 协议
         
         类型约束语法:
         你可以在一个类型参数名后面放置一个类名或者协议名，并用冒号进行分隔，来定义类型约束，它们将成为类型参数列表的一部分
         func someFunction<T: SomeClass, U: SomeProtocol>(someT: T, someU: U) {
         // 这里是泛型函数的函数体部分
         }
         Swift 标准库中定义了一个 Equatable 协议，该协议要求任何遵循该协议的类型必须实现等式符（==）及不等符(!=)，从而能对该类型的任意两个值进行比较。所有的 Swift 标准类型自动支持 Equatable 协议
         func findIndex<T: Equatable>(of valueToFind: T, in array:[T]) -> Int? {
         for (index, value) in array.enumerated() {
         if value == valueToFind {
         return index
         }
         }
         return nil
         }
         
         MARK:关联类型:
         关联类型为##协议中的某个类型##提供了一个占位名（或者说别名），其代表的实际类型在协议被采纳时才会被指定。你可以通过  associatedtype 关键字来指定关联类型
         protocol Container {
         associatedtype ItemType
         mutating func append(_ item: ItemType)
         var count: Int { get }
         subscript(i: Int) -> ItemType { get }
         }
         必须可以通过 append(_:) 方法添加一个新元素到容器里。
         必须可以通过 count 属性获取容器中元素的数量，并返回一个 Int 值。
         必须可以通过索引值类型为 Int 的下标检索到容器中的每一个元素
         struct IntStack: Container {
         // IntStack 的原始实现部分
         var items = [Int]()
         mutating func push(_ item: Int) {
         items.append(item)
         }
         mutating func pop() -> Int {
         return items.removeLast()
         }
         // Container 协议的实现部分
         typealias ItemType = Int
         mutating func append(_ item: Int) {
         self.push(item)
         }
         var count: Int {
         return items.count
         }
         subscript(i: Int) -> Int {
         return items[i]
         }
         }
         
         struct Stack<Element>: Container {
         // Stack<Element> 的原始实现部分
         var items = [Element]()
         mutating func push(_ item: Element) {
         items.append(item)
         }
         mutating func pop() -> Element {
         return items.removeLast()
         }
         // Swift可以推断出 ItemType 的具体类型,所以省略typealias
         // Container 协议的实现部分
         mutating func append(_ item: Element) {
         self.push(item)
         }
         var count: Int {
         return items.count
         }
         subscript(i: Int) -> Element {
         return items[i]
         }
         }
         
         通过扩展一个存在的类型来指定关联类型：
         让一个已存在的类型符合一个协议，这包括使用了关联类型的协议
         Swift 的 Array 类型已经提供 append(_:) 方法，一个 count 属性，以及一个接受 Int 类型索引值的下标用以检索其元素。这三个功能都符合 Container 协议的要求，也就意味着你只需简单地声明 Array 采纳该协议就可以扩展 Array，使其遵从 Container 协议。你可以通过一个空扩展来实现这点
         extension Array: Container {}
         
         约束关联类型:
         protocol Container {
         associatedtype Item: Equatable
         mutating func append(_ item: Item)
         var count: Int { get }
         subscript(i: Int) -> Item { get }
         }
         
         ###泛型 where 语句：###
         为关联类型定义约束也是非常有用的。你可以在参数列表中通过 where 子句为关联类型定义约束。你能通过  where 子句要求一个关联类型遵从某个特定的协议，以及某个特定的类型参数和关联类型必须类型相同
         
         where 语句:
         可以在参数列表中通过 where 子句为关联类型定义约束
         func allItemsMatch<C1: Container, C2: Container> (_ someContainer: C1, _ anotherContainer: C2) -> Bool
         where C1.ItemType == C2.ItemType, C1.ItemType: Equatable {
         
         // 检查两个容器含有相同数量的元素
         if someContainer.count != anotherContainer.count {
         return false
         }
         
         // 检查每一对元素是否相等
         for i in 0..<someContainer.count {
         if someContainer[i] != anotherContainer[i] {
         return false
         }
         }
         
         // 所有元素都匹配，返回 true
         return true
         }
         
         
         ##具有泛型 where 子句的扩展:##
         // 泛型 Stack 结构体
         extension Stack where Element: Equatable {
         func isTop(_ item: Element) -> Bool {
         guard let topItem = items.last else {
         return false
         }
         return topItem == item
         }
         }
         
         // Container 协议，泛型 where 子句去扩展一个协议
         extension Container where Item: Equatable {
         func startsWith(_ item: Item) -> Bool {
         return count >= 1 && self[0] == item
         }
         }
         
         // 泛型 where 子句去要求 Item 为特定类型
         extension Container where Item == Double {
         func average() -> Double {
         var sum = 0.0
         for index in 0..<count {
         sum += self[index]
         }
         return sum / Double(count)
         }
         }
         
         // 在关联类型后面加上具有泛型 where 的字句
         protocol Container {
         associatedtype Item
         mutating func append(_ item: Item)
         var count: Int { get }
         subscript(i: Int) -> Item { get }
         
         associatedtype Iterator: IteratorProtocol where Iterator.Element == Item
         func makeIterator() -> Iterator
         }
         
         // 一个协议继承了另一个协议，你通过在协议声明的时候，包含泛型 where 子句，来添加了一个约束到被继承协议的关联类型。声明了一个 ComparableContainer 协议，它要求所有的 Item 必须是  Comparable 的
         protocol ComparableContainer: Container where Item: Comparable { }
         
         泛型下标:
         extension Container {
         subscript<Indices: Sequence>(indices: Indices) -> [Item]
         where Indices.Iterator.Element == Int {
         var result = [Item]()
         for index in indices {
         result.append(self[index])
         }
         return result
         }
         }
         
         */
        
        // TODO:===24.内存安全
        // Swift 会阻止你代码里不安全的行为。例如，Swift 会保证变量在使用之前就完成初始化，在内存被回收之后就无法被访问，并且数组的索引会做越界检查
        
        /*
         // In-Out 参数的访问冲突
        var stepSize = 1
        
        func increment(_ number: inout Int) {
            number += stepSize
        }
        
        increment(&stepSize)
        // 错误：stepSize 访问冲突
         stepSize 是一个全局变量，并且它可以在 increment(_:) 里正常访问.对于  stepSize 的读访问与 number 的写访问重叠了
         
         解决这个冲突的一种方式，是复制一份 stepSize 的副本：
         
         // 复制一份副本
         var copyOfStepSize = stepSize
         increment(&copyOfStepSize)
         
         // 更新原来的值
         stepSize = copyOfStepSize
         // 读访问在写操作之前就已经结束了，所以不会有冲突
         // stepSize 现在的值是 2
        */
        
        /*
         属性的访问冲突:
         对于一个存储在全局变量里的结构体属性的写访问重叠了
        var holly = Player(name: "Holly", health: 10, energy: 10)
        balance(&holly.health, &holly.energy)  // 错误
        
         // 改为本地变量而非全局变量
        func someFunction() {
            var oscar = Player(name: "Oscar", health: 10, energy: 10)
            balance(&oscar.health, &oscar.energy)  // 正常
        }
         
         特别是当你遵循下面的原则时，它可以保证结构体属性的重叠访问是安全的：
         
         你访问的是实例的存储属性，而不是计算属性或类的属性
         结构体是本地变量的值，而非全局变量
         结构体要么没有被闭包捕获，要么只被非逃逸闭包捕获了
        */
        
        // TODO:===25.访问控制
        // 访问控制可以限定其它源文件或模块中的代码对你的代码的访问级别
        
        /*
        模块和源文件:
         源文件就是 Swift 中的源代码文件，它通常属于一个模块，即一个应用程序或者框架
        
         访问级别:五种不同的访问级别
         Open 和 Public 级别可以让实体被同一模块源文件中的所有实体访问，在模块外也可以通过导入该模块来访问源文件里的所有实体。通常情况下，你会使用 Open 或 Public 级别来指定框架的外部接口。Open 和 Public 的区别在后面会提到。
         Internal 级别让实体被同一模块源文件中的任何实体访问，但是不能被模块外的实体访问。通常情况下，如果某个接口只在应用程序或框架内部使用，就可以将其设置为 Internal 级别。
         File-private 限制实体只能在其定义的文件内部访问。如果功能的部分细节只需要在文件内使用时，可以使用 File-private 来将其隐藏。
         Private 限制实体只能在其定义的作用域，以及同一文件内的 extension 访问。如果功能的部分细节只需要在当前作用域内使用时，可以使用 Private 来将其隐藏。
         Open 为最高访问级别（限制最少），Private 为最低访问级别（限制最多）
         
         Open 只能作用于类和类的成员，它和 Public 的区别如下：
         
         Public 或者其它更严访问级别的类，只能在其定义的模块内部被继承。
         Public 或者其它更严访问级别的类成员，只能在其定义的模块内部的子类中重写。
         Open 的类，可以在其定义的模块中被继承，也可以在引用它的模块中被继承。
         Open 的类成员，可以在其定义的模块中子类中重写，也可以在引用它的模块中的子类重写
         
         把一个类标记为 open，明确的表示你已经充分考虑过外部模块使用此类作为父类的影响
         
         
         不可以在某个实体中定义访问级别更低（更严格）的实体:
         一个 Public 的变量，其类型的访问级别不能是 Internal，File-private 或是 Private
         函数的访问级别不能高于它的参数类型和返回类型的访问级别
         
         默认访问级别:
         如果你没有为代码中的实体显式指定访问级别，那么它们默认为 internal 级别
         
         单 target 应用程序的访问级别:
         当你编写一个单目标应用程序时，应用的所有功能都是为该应用服务，而不需要提供给其他应用或者模块使用，所以我们不需要明确设置访问级别，使用默认的访问级别 Internal 即可
         
         框架的访问级别:
         当你开发框架时，就需要把一些对外的接口定义为 Open 或 Public，以便使用者导入该框架后可以正常使用其功能。这些被你定义为对外的接口，就是这个框架的 API
         
         通过修饰符 open，public，internal，fileprivate，private 来声明实体的访问级别
         
         自定义类型:
         一个类型的访问级别也会影响到类型成员（属性、方法、构造器、下标）的默认访问级别。如果你将类型指定为  private 或者 fileprivate 级别，那么该类型的所有成员的默认访问级别也会变成 private 或者  fileprivate 级别
         
         如果你将类型指定为公开或者 internal （或者不明确指定访问级别，而使用默认的  internal ），那么该类型的所有成员的默认访问级别将是内部访问
         
         一个 public 类型的所有成员的访问级别默认为 internal 级别，而不是 public 级别。如果你想将某个成员指定为 public 级别，那么你必须显式指定。这样做的好处是，在你定义公共接口的时候，可以明确地选择哪些接口是需要公开的，哪些是内部使用的，避免不小心将内部使用的接口公开
         
         public class SomePublicClass {                  // 显式 public 类
         public var somePublicProperty = 0            // 显式 public 类成员
         var someInternalProperty = 0                 // 隐式 internal 类成员
         fileprivate func someFilePrivateMethod() {}  // 显式 fileprivate 类成员
         private func somePrivateMethod() {}          // 显式 private 类成员
         }
         
         class SomeInternalClass {                       // 隐式 internal 类
         var someInternalProperty = 0                 // 隐式 internal 类成员
         fileprivate func someFilePrivateMethod() {}  // 显式 fileprivate 类成员
         private func somePrivateMethod() {}          // 显式 private 类成员
         }
         
         fileprivate class SomeFilePrivateClass {        // 显式 fileprivate 类
         func someFilePrivateMethod() {}              // 隐式 fileprivate 类成员
         private func somePrivateMethod() {}          // 显式 private 类成员
         }
         
         private class SomePrivateClass {                // 显式 private 类
         func somePrivateMethod() {}                  // 隐式 private 类成员
         }
         
         元组类型:
         元组的访问级别将由元组中访问级别最严格的类型来决定
         如果你构建了一个包含两种不同类型的元组，其中一个类型为 internal，另一个类型为 private，那么这个元组的访问级别为 private
         元组不同于类、结构体、枚举、函数那样有单独的定义。元组的访问级别是在它被使用时自动推断出的，而无法明确指定
         
         函数类型:
         函数的访问级别根据访问级别最严格的参数类型或返回类型的访问级别来决定.但是，如果这种访问级别不符合函数定义所在环境的默认访问级别，那么就需要明确地指定该函数的访问级别
         
         因为该函数返回类型的访问级别是 private，所以你必须使用 private 修饰符，明确指定该函数的访问级别
         private func someFunction() -> (SomeInternalClass, SomePrivateClass) {
         // 此处是函数实现部分
         }
         因为如果把该函数当做 public 或 internal 级别来使用的话，可能会无法访问 private 级别的返回值
         
         枚举类型:
         枚举成员的访问级别和该枚举类型相同，你不能为枚举成员单独指定不同的访问级别
         枚举定义中的任何原始值或关联值的类型的访问级别至少不能低于枚举类型的访问级别。例如，你不能在一个  internal 的枚举中定义 private 的原始值类型
         
         嵌套类型:
         如果在 private 的类型中定义嵌套类型，那么该嵌套类型就自动拥有 private 访问级别。如果在 public 或者  internal 级别的类型中定义嵌套类型，那么该嵌套类型自动拥有 internal 访问级别。如果想让嵌套类型拥有  public 访问级别，那么需要明确指定该嵌套类型的访问级别
 
         子类:
         子类的访问级别不得高于父类的访问级别。例如，父类的访问级别是 internal，子类的访问级别就不能是  public
         你可以在符合当前访问级别的条件下重写任意类成员（方法、属性、构造器、下标等）。
         
         可以通过重写为继承来的类成员提供更高的访问级别
         类 A 的访问级别是 public，它包含一个方法 someMethod()，访问级别为 private。类 B 继承自类 A，访问级别为 internal，但是在类 B 中重写了类 A 中访问级别为 private 的方法 someMethod()，并重新指定为 internal 级别。通过这种方式，我们就可以将某类中 private 级别的类成员重新指定为更高的访问级别，以便其他人使用
         在同一源文件中访问父类 private 级别的成员，在同一模块内访问父类 internal 级别的成员
         public class A {
         private func someMethod() {}
         }
         
         internal class B: A {
         override internal func someMethod() {
         super.someMethod()
         }
         }
         因为父类 A 和子类 B 定义在同一个源文件中，所以在子类 B 可以在重写的 someMethod() 方法中调用  super.someMethod()
         
         常量、变量、属性不能拥有比它们的类型更高的访问级别
         你不能定义一个 public 级别的属性，但是它的类型却是 private 级别的
         
         如果常量、变量、属性、下标的类型是 private 级别的，那么它们必须明确指定访问级别为 private
         下标也不能拥有比索引类型或返回类型更高的访问级别
         private var privateInstance = SomePrivateClass()
         
         常量、变量、属性、下标的 Getters 和 Setters 的访问级别和它们所属类型的访问级别相同
         
         Setter 的访问级别可以低于对应的 Getter 的访问级别，这样就可以控制变量、属性或下标的读写权限
         在  var 或 subscript 关键字之前，你可以通过 fileprivate(set)，private(set) 或 internal(set) 为它们的写入权限指定更低的访问级别
         
         struct TrackedString {
         private(set) var numberOfEdits = 0
         var value: String = "" {
         didSet {
         numberOfEdits += 1
         }
         }
         }
         ###结构体 TrackedString 和它的属性 value 都没有显式地指定访问级别，所以它们都是用默认的访问级别  internal。但是该结构体的 numberOfEdits 属性使用了 private(set) 修饰符，这意味着 numberOfEdits 属性只能在结构体的定义中进行赋值。numberOfEdits 属性的 Getter 依然是默认的访问级别 internal，但是 Setter 的访问级别是 private，这表示该属性只能在内部修改，而在结构体的外部则表现为一个只读属性###
         你可以在其他的源文件中实例化该结构体并且获取到 numberOfEdits 属性的值，但是你不能对其进行赋值
         
         下面的例子将 TrackedString 结构体明确指定为了  public 访问级别。结构体的成员（包括 numberOfEdits 属性）拥有默认的访问级别 internal。你可以结合  public 和 private(set) 修饰符把结构体中的 numberOfEdits 属性的 Getter 的访问级别设置为  public，而 Setter 的访问级别设置为 private：
         
         public struct TrackedString {
         public private(set) var numberOfEdits = 0
         public var value: String = "" {
         didSet {
         numberOfEdits += 1
         }
         }
         public init() {}
         }
         
         构造器:
         自定义构造器的访问级别可以低于或等于其所属类型的访问级别。唯一的例外是必要构造器，它的访问级别必须和所属类型的访问级别相同。
         
         如同函数或方法的参数，构造器参数的访问级别也不能低于构造器本身的访问级别
         
         Swift 会为结构体和类提供一个默认的无参数的构造器，只要它们为所有存储型属性设置了默认初始值，并且未提供自定义的构造器
         默认构造器的访问级别与所属类型的访问级别相同，除非类型的访问级别是 public。如果一个类型被指定为  public 级别，那么默认构造器的访问级别将为 internal
         // 逐一构造器
         如果结构体中任意存储型属性的访问级别为 private，那么该结构体默认的成员逐一构造器的访问级别就是  private。否则，这种构造器的访问级别依然是 internal
         
         协议:
         协议中的每一个要求都具有和该协议相同的访问级别
         如果你定义了一个 public 访问级别的协议，那么该协议的所有实现也会是 public 访问级别。这一点不同于其他类型，例如，当类型是 public 访问级别时，其成员的访问级别却只是 internal
         协议继承:
         如果定义了一个继承自其他协议的新协议，那么新协议拥有的访问级别最高也只能和被继承协议的访问级别相同
         
         一个类型可以采纳比自身访问级别低的协议。例如，你可以定义一个 public 级别的类型，它可以在其他模块中使用，同时它也可以采纳一个 internal 级别的协议，但是只能在该协议所在的模块中作为符合该协议的类型使用
         
         采纳了协议的类型的访问级别取它本身和所采纳协议两者间最低的访问级别。也就是说如果一个类型是 public 级别，采纳的协议是 internal 级别，那么采纳了这个协议后，该类型作为符合协议的类型时，其访问级别也是  internal
         
         如果你采纳了协议，那么实现了协议的所有要求后，你必须确保这些实现的访问级别不能低于协议的访问级别。例如，一个 public 级别的类型，采纳了 internal 级别的协议，那么协议的实现至少也得是 internal 级别
         
         Extension:
         你使用 extension 扩展了一个 public 或者 internal 类型，extension 中的成员就默认使用 internal 访问级别，和原始类型中的成员一致。如果你使用 extension 扩展了一个 private 类型，则 extension 的成员默认使用 private 访问级别
         
         或者，你可以明确指定 extension 的访问级别（例如，private extension），从而给该 extension 中的所有成员指定一个新的默认访问级别。这个新的默认访问级别仍然可以被单独指定的访问级别所覆盖
         
         如果你使用 extension 来遵循协议的话，就不能显式地声明 extension 的访问级别。extension 每个 protocol 要求的实现都默认使用 protocol 的访问级别
         
         Extension 的私有成员:
         在类型的声明里声明一个私有成员，在同一文件的 extension 里访问。
         在 extension 里声明一个私有成员，在同一文件的另一个 extension 里访问。
         在 extension 里声明一个私有成员，在同一文件的类型声明里访问
         
         泛型:
         泛型类型或泛型函数的访问级别取决于泛型类型或泛型函数本身的访问级别，还需结合类型参数的类型约束的访问级别，根据这些访问级别中的最低访问级别来确定
         
         类型别名:
         类型别名的访问级别不可高于其表示的类型的访问级别
         private 级别的类型别名可以作为 private，file-private，internal，public或者open类型的别名，但是 public 级别的类型别名只能作为 public 类型的别名，不能作为  internal，file-private，或 private 类型的别名
         */
        
        // TODO:===26.高级运算符
        // 按位取反运算符（~）可以对一个数值的全部比特位进行取反
        // UInt8 类型的整数有 8 个比特位，可以存储 0 ~ 255 之间的任意整数
        // 二进制的 00001111，它的前 4 位都为 0，后 4 位都为 1。这个值等价于十进制的 15 二进制值为  11110000，等价于无符号十进制数的 240
        // 按位异或运算符（^）可以对两个数的比特位进行比较。它返回一个新的数，当两个数的对应位不相同时，新数的对应位就为 1
        // 对一个数进行按位左移或按位右移，相当于对这个数进行乘以 2 或除以 2 的运算.将一个整数左移一位，等价于将这个数乘以 2，同样地，将一个整数右移一位，等价于将这个数除以 2
        /*
         无符号整数的移位运算:
         已经存在的位按指定的位数进行左移和右移。
         任何因移动而超出整型存储范围的位都会被丢弃。
         用 0 来填充移位后产生的空白位
         
         let shiftBits: UInt8 = 4 // 即二进制的 00000100
         shiftBits << 1           // 00001000
         shiftBits << 2           // 00010000
         shiftBits << 5           // 10000000
         shiftBits << 6           // 00000000
         shiftBits >> 2           // 00000001
         
         let pink: UInt32 = 0xCC6699
         let redComponent = (pink & 0xFF0000) >> 16  // redComponent 是 0xCC，即 204
         let greenComponent = (pink & 0x00FF00) >> 8 // greenComponent 是 0x66， 即 102
         let blueComponent = pink & 0x0000FF         // blueComponent 是 0x99，即 153
         
         十六进制中每两个字符表示 8 个比特位
         
         有符号整数的移位运算:
         有符号整数使用第 1 个比特位（通常被称为符号位）来表示这个数的正负。符号位为 0 代表正数，为 1 代表负数
         其余的比特位（通常被称为数值位）存储了实际的值。有符号正整数和无符号数的存储方式是一样的，都是从 0 开始算起
         符号位为 0，说明这是一个正数，另外 7 位则代表了十进制数值 4 的二进制表示
         负数的存储方式略有不同。它存储的值的绝对值等于 2 的 n 次方减去它的实际值（也就是数值位表示的值），这里的 n 为数值位的比特位数。一个 8 比特位的数有 7 个比特位是数值位，所以是 2 的 7 次方，即 128
         
         
         // -4: 这次的符号位为 1，说明这是一个负数，另外 7 个位则代表了数值 124（即 128 - 4）的二进制
         负数的表示通常被称为二进制补码表示
         
         
         当二进制为正数时，原码、反码、补码相同
         当二进制为负数时，反码=原码的数值位逐一取反，补码=反码在最低位加1
         ##数值在计算机的表示都是用补码来表示的，所以计算机的加减法都是补码的加减法##
         (-1) + (-127) = [1000 0001]原 + [1111 1111]原 = [1111 1111]补 + [1000 0001]补 = [1000 0000]补
         [+1] = [00000001]原 = [00000001]反 = [00000001]补
         [-1] = [10000001]原 = [11111110]反 = [11111111]补
         0000 0000=0      0111 1111=127   1000 0000=-128
         从补码求原码的方法跟原码求补码是一样的
         
         对于负数,先取绝对值,然后求反,加一
         -128 -> 128 -> 1000 0000 -> 0111 1111 -> 1000 0000
         
         溢出运算符:
         
         运算符函数:
         类和结构体可以为现有的运算符提供自定义的实现，这通常被称为运算符重载
         struct Vector2D {
         var x = 0.0, y = 0.0
         }
         
         extension Vector2D {
         static func + (left: Vector2D, right: Vector2D) -> Vector2D {
         return Vector2D(x: left.x + right.x, y: left.y + right.y)
         }
         }
         因为加法运算并不是一个向量必需的功能，所以这个类方法被定义在 Vector2D 的一个扩展中，而不是 Vector2D 结构体声明内
         
         这个类方法可以在任意两个 Vector2D 实例中间作为中缀运算符来使用:
         let vector = Vector2D(x: 3.0, y: 1.0)
         let anotherVector = Vector2D(x: 2.0, y: 4.0)
         let combinedVector = vector + anotherVector
         算术加法运算符是一个双目运算符，因为它可以对两个值进行运算，同时它还是中缀运算符，因为它出现在两个值中间
         
         前缀和后缀运算符:
         单目运算符只运算一个值。当运算符出现在值之前时，它就是前缀的（例如 -a），而当它出现在值之后时，它就是后缀的（例如  b!）
         要实现前缀或者后缀运算符，需要在声明运算符函数的时候在 func 关键字之前指定 prefix 或者 postfix 修饰符：
         
         extension Vector2D {
         static prefix func - (vector: Vector2D) -> Vector2D {
         return Vector2D(x: -vector.x, y: -vector.y)
         }
         }
         
         复合赋值运算符:
         复合赋值运算符将赋值运算符（=）与其它运算符进行结合
         extension Vector2D {
         static func += (left: inout Vector2D, right: Vector2D) {
         left = left + right
         }
         }
         不能对默认的赋值运算符（=）进行重载。只有组合赋值运算符可以被重载。同样地，也无法对三目条件运算符 （a ? b : c） 进行重载
         
         等价运算符: 自定义的类和结构体没有对等价运算符进行默认实现，等价运算符通常被称为“相等”运算符（==）与“不等”运算符（!=）
         extension Vector2D {
         static func == (left: Vector2D, right: Vector2D) -> Bool {
         return (left.x == right.x) && (left.y == right.y)
         }
         static func != (left: Vector2D, right: Vector2D) -> Bool {
         return !(left == right)
         }
         }
         
         自定义运算符:
         新的运算符要使用 operator 关键字在全局作用域内进行定义，同时还要指定 prefix、infix 或者 postfix 修饰符：
         
         prefix operator +++
         +++ 被实现为“前缀双自增”运算符。它使用了前面定义的复合加法运算符来让矩阵对自身进行相加，从而让 Vector2D 实例的 x 属性和 y 属性的值翻倍。实现 +++ 运算符的方式如下：
         
         extension Vector2D {
         static prefix func +++ (vector: inout Vector2D) -> Vector2D {
         vector += vector
         return vector
         }
         }
         
         
         var toBeDoubled = Vector2D(x: 1.0, y: 4.0)
         let afterDoubling = +++toBeDoubled
         // toBeDoubled 现在的值为 (2.0, 8.0)
         // afterDoubling 现在的值也为 (2.0, 8.0)
         
         
         自定义中缀运算符的优先级:
         以下例子定义了一个新的自定义中缀运算符 +-，此运算符属于 AdditionPrecedence 优先组：
         
         infix operator +-: AdditionPrecedence
         extension Vector2D {
         static func +- (left: Vector2D, right: Vector2D) -> Vector2D {
         return Vector2D(x: left.x + right.x, y: left.y - right.y)
         }
         }
         let firstVector = Vector2D(x: 1.0, y: 2.0)
         let secondVector = Vector2D(x: 3.0, y: 4.0)
         let plusMinusVector = firstVector +- secondVector
         // plusMinusVector 是一个 Vector2D 实例，并且它的值为 (4.0, -2.0)
         
         当定义前缀与后缀运算符的时候，我们并没有指定优先级。然而，如果对同一个值同时使用前缀与后缀运算符，则后缀运算符会先参与运算
         */
        
        // 词法结构（Lexical Structure）
        // 表达式（Expressions）
        // 以井字号 (#) 开头的关键字：#available、#column、#else#elseif、#endif、#file、#function、#if、#line 以及  #selector
    }
    
    func increment() {
        count += 1
        // 只要在一个方法中使用一个已知的属性或者方法名称，如果你没有明确地写self，Swift 假定你是指当前实例的属性或者方法
        self.count += 1
    }
    
    // 要操作具有递归性质的数据结构，使用递归函数是一种直截了当的方式
    func evaluate(_ expression: ArithmeticExpression) -> Int {
        switch expression {
        case let .number(value):
            return value
        case let .addition(left, right):
            return evaluate(left) + evaluate(right)
        case let .multiplication(left, right):
            return evaluate(left) * evaluate(right)
        }
    }
    
    // 枚举(以一个大写字母开头)中定义的值,是这个枚举的成员值（或成员）
    // Swift 的枚举成员在被创建时不会被赋予一个默认的整型值
    enum CompassPoint {
        case north
        case south
        case east
        case west
    }
    
    // 关联值
    enum Barcode {
        case upc(Int, Int, Int, Int)
        case qrCode(String)
    }
    
    // 原始值，这些原始值的类型必须相同，对于一个特定的枚举成员，它的原始值始终不变
    enum ASCIIControlCharacter: Character {
        case tab = "\t"
        case lineFeed = "\n"
        case carriageReturn = "\r"
    }
    
    // 原始值的隐式赋值
    // 当使用字符串作为枚举类型的原始值时，每个枚举成员的隐式原始值为该枚举成员的名称
    // 使用枚举成员的rawValue属性可以访问该枚举成员的原始值
    enum Planet: Int {
        case mercury = 1, venus, earth, mars, jupiter, saturn, uranus, neptune
    }
    
    enum ArithmeticExpression {
        case number(Int)
        indirect case addition(ArithmeticExpression, ArithmeticExpression)
        indirect case multiplication(ArithmeticExpression, ArithmeticExpression)
    }
    
    indirect enum ArithmeticExpression1 {
        case number(Int)
        case addition(ArithmeticExpression, ArithmeticExpression)
        case multiplication(ArithmeticExpression, ArithmeticExpression)
    }
    
    func serve(customer customerProvider: () -> String) {
        print("Now serving \(customerProvider())!")
    }
    
    func serve1(customer customerProvider: @autoclosure () -> String) {
        print("Now serving \(customerProvider())!")
    }
    
    func makeIncrementer(forIncrement amount: Int) -> () -> Int {
        var runningTotal = 0
        func incrementer() -> Int {
            runningTotal += amount
            return runningTotal
        }
        return incrementer
    }
    
    func backward(_ s1: String, _ s2: String) -> Bool {
        return s1 > s2
    }
    
    func canThrowAnError() throws {
        // 这个函数有可能抛出错误
    }
    
    // 无返回值函数 虽然没有返回值被定义，greet(person:) 函数依然返回了值。没有定义返回类型的函数会返回一个特殊的Void值。它其实是一个空的元组（tuple），没有任何元素，可以写成()
    func greet(person: String) {
        print("Hello, \(person)!")
    }
    
    // 指定参数标签
    func someFunction(argumentLabel parameterName: Int) {
        // 在函数体内，parameterName 代表参数值
    }
    
    // 忽略参数标签
    func someFunction(_ firstParameterName: Int, secondParameterName: Int) {
        // 在函数体内，firstParameterName 和 secondParameterName 代表参数中的第一个和第二个参数值
    }
    
    // 默认参数值
    func someFunction(parameterWithoutDefault: Int, parameterWithDefault: Int = 12) {
        // 如果你在调用时候不传第二个参数，parameterWithDefault 会值为 12 传入到函数体中。
    }
    
    // 可变参数的传入值在函数体中变为此类型的一个数组 ##一个函数最多只能拥有一个可变参数
    func arithmeticMean(_ numbers: Double...) -> Double {
        var total: Double = 0
        for number in numbers {
            total += number
        }
        return total / Double(numbers.count)
    }
    
    // 输入输出参数 ##函数参数默认是常量
    // 如果你想要一个函数可以修改参数的值，并且想要在这些修改在函数调用结束后仍然存在，那么就应该把这个参数定义为输入输出参数（In-Out Parameters）
    // 输入输出参数不能有默认值
    func swapTwoInts(_ a: inout Int, _ b: inout Int) {
        let temporaryA = a
        a = b
        b = temporaryA
    }
    
    func addTwoInts(_ a: Int, _ b: Int) -> Int {
        return a + b
    }
    
    func stepForward(_ input: Int) -> Int {
        return input + 1
    }
    func stepBackward(_ input: Int) -> Int {
        return input - 1
    }
    
    // 函数类型作为返回类型
    func chooseStepFunction(backward: Bool) -> (Int) -> Int {
        return backward ? stepBackward : stepForward
    }
    
    // 嵌套函数（nested functions）
    func chooseStepFunction1(backward: Bool) -> (Int) -> Int {
        func stepForward1(input: Int) -> Int { return input + 1 }
        func stepBackward1(input: Int) -> Int { return input - 1 }
        return backward ? stepBackward1 : stepForward1
    }
    
    
    // ===尾随闭包被调用函数===
    func someFunctionThatTakesAClosure(closure: () -> Void) {
        // 函数体部分
    }
    
    // completionHandlers定义在函数作用域范围外,这意味着数组内的闭包能够在函数返回之后被调用.必须允许“逃逸”出函数作用域
    // 很多启动异步操作的函数接受一个闭包参数作为 completion handler。这类函数会在异步操作开始之后立刻返回，但是闭包直到异步操作结束后才会被调用。在这种情况下，闭包需要“逃逸”出函数，因为闭包需要在函数返回之后被调用
    func someFunctionWithEscapingClosure(completionHandler: @escaping () -> Void) {
        completionHandlers.append(completionHandler)
    }
}
