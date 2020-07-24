
//
//  AppDelegate.swift
//  SwiftDemo
//
//  Created by dzcx on 2019/7/17.
//  Copyright © 2019 dzcx. All rights reserved.
//

// MARK: Network tools
// https://github.com/mediaios/net-diagnosis

// MARK: github tools
// https://github.com/filsv/iPhoneOSDeviceSupport

// MARK: swift开源框架
// https://www.jianshu.com/p/0797ca000ee1

// MARK: 直播 && 音视频
// https://www.jianshu.com/p/7d1f6c20799d
// https://juejin.im/user/58ec343861ff4b00691b4f26/posts

// MARK: interview
// https://www.jianshu.com/u/b0a8b4cbff94

// MARK: 大神blog
// https://www.jianshu.com/u/8367278ff6cf
// https://www.jianshu.com/p/2b1d9e9eb10d
// https://www.jianshu.com/u/57da48d44319

// MARK: Swift 语法规范 && SwiftLint
// https://github.com/github/swift-style-guide
/**
 多态 可以通过 协议 实现
 
 SwiftLint:
 1.安装全局配置(Homebrew 安装)
 brew info [软件名称]
 brew --help
 brew list --versions
 brew search swiftlint
 brew install swiftlint
 swiftlint help
 swiftlint version
 swiftlint autocorrect
 //查看所有可获得的规则以及对应的 ID
 swiftlint rules
 
 if which swiftlint >/dev/null; then
   swiftlint
 else
   echo "warning: SwiftLint not installed, download from https://github.com/realm/SwiftLint"
 fi
 2. 使用 CocoaPods 安装
 这种方式只能针对单个项目有效,如果你想要针对不同的项目使用不同的SwiftLint 版本，这是一种很好的解决方案
 pod 'SwiftLint'
 ${PODS_ROOT}/SwiftLint/swiftlint in your Script Build Phases
 
 安装完成后,需要在Xcode中配置相关设置,才能使 SwiftLint 在 Xcode 中自动检测代码规范。
 只需要在 Xcode 的 Build Phases 中新建一个 Run Script Phase 配置项，在里面添加相关代码后,编译即可
 */

// MARK: Device
/**
 let device = UIDevice.current
 print("name = \(device.name)  systemVersion = \(device.systemVersion)  systemName = \(device.systemName) model = \(device.model)")
 name = “Administrator”的 iPhone  systemVersion = 13.4.1  systemName = iOS model = iPhone
 */

// MARK: 查看Xcode所使用的swift版本
/**
 查看Swift版本
 xcrun swift -version

 xcodebuild -showsdks
 
 xcrun --find swift
 
 Xcode项目中查看
 Build Settings -> Swift Language Version
 */

// MARK: Swift Blog
// https://www.jianshu.com/u/4d2db3bb937c

// MARK: 国外blog
// https://www.raywenderlich.com/10978716-ios-apprentice

// MARK: swift查看内存地址小工具Mems
// https://github.com/CoderMJLee/Mems.git

// MARK: NEKit
// https://github.com/zhuhaow

// MARK: ==Vendors==
// https://juejin.im/user/5a52075e6fb9a01c9d31b107/posts
// https://www.cnblogs.com/edensyd/p/9450079.html
// https://www.jianshu.com/p/c845dc2f794a
// MARK: Keychain
// https://github.com/kishikawakatsumi/KeychainAccess
// MARK: XCGLogger
// https://github.com/DaveWoodCom/XCGLogger
// MARK: SwiftyStoreKit
// MARK: FSCalendar
// MARK: FSPagerView

// MARK: 工具
// Zeplin Lookin3

// MARK: ===团队Blog===
// https://www.jianshu.com/u/3db23baa08c7

// =====github=====
// https://github.com/devicekit/DeviceKit

// 大哥blog: swift编程规范
// https://note.u-inn.cn/ios-swift-style/

// github swift demo
// https://github.com/hilen/TSWeChat

// RxSwift
// https://www.jianshu.com/p/f61a5a988590

// RxSwift 中文文档
// https://beeth0ven.github.io/RxSwift-Chinese-Documentation/

// ##swift##
// http://www.hangge.com/blog/cache/category_72_1.html

// Moya-ObjectMapper
// https://github.com/ivanbruel/Moya-ObjectMapper

// ###RxSwiftCommunity###
// https://github.com/RxSwiftCommunity
// RxAlamofire
// https://github.com/RxSwiftCommunity/RxAlamofire
// RxDataSources
// https://github.com/RxSwiftCommunity/RxDataSources

// Date
// https://github.com/malcommac/SwiftDate

// MARK: 写时复制(copy-on-write)
/**
 var array1: [Int] = [0, 1, 2, 3]
 var array2 = array1

 print(address: array1) //0x600000078de0
 print(address: array2) //0x600000078de0

 array2.append(4)
 print(address: array2) //0x6000000aa100
 */

// MARK: ==Error==
/**
 public protocol Error {
 }
 extension Error {
 }
 A type representing an error value that can be thrown. Any type that declares conformance to the Error protocol can be used to represent an error in Swift’s error handling system. Because the Error protocol has no requirements of its own, you can declare conformance on any custom type you create.

 struct XMLParsingError: Error {
     enum ErrorKind {
         case invalidCharacter
         case mismatchedTag
         case internalError
     }

     let line: Int
     let column: Int
     let kind: ErrorKind
 }

 func parse(_ source: String) throws -> XMLDoc {
     // ...
     throw XMLParsingError(line: 19, column: 5, kind: .mismatchedTag)
     // ...
 }
 
 do {
     let xmlDoc = try parse(myXMLData)
 } catch let e as XMLParsingError {
     print("Parsing error: \(e.kind) [\(e.line):\(e.column)]")
 } catch {
     print("Other error: \(error)")
 }
 // Prints "Parsing error: mismatchedTag [19:5]"
 
 Alamofire中的错误示例:
 public enum AFError: Error {
     public enum ParameterEncodingFailureReason {
         case missingURL
         case jsonEncodingFailed(error: Error)
         case propertyListEncodingFailed(error: Error)
     }

     
     public enum MultipartEncodingFailureReason {
         case bodyPartURLInvalid(url: URL)
         case bodyPartFilenameInvalid(in: URL)
         case bodyPartFileNotReachable(at: URL)
         case bodyPartFileNotReachableWithError(atURL: URL, error: Error)
         case bodyPartFileIsDirectory(at: URL)
         case bodyPartFileSizeNotAvailable(at: URL)
         case bodyPartFileSizeQueryFailedWithError(forURL: URL, error: Error)
         case bodyPartInputStreamCreationFailed(for: URL)

         case outputStreamCreationFailed(for: URL)
         case outputStreamFileAlreadyExists(at: URL)
         case outputStreamURLInvalid(url: URL)
         case outputStreamWriteFailed(error: Error)

         case inputStreamReadFailed(error: Error)
     }

     
     public enum ResponseValidationFailureReason {
         case dataFileNil
         case dataFileReadFailed(at: URL)
         case missingContentType(acceptableContentTypes: [String])
         case unacceptableContentType(acceptableContentTypes: [String], responseContentType: String)
         case unacceptableStatusCode(code: Int)
     }

     
     public enum ResponseSerializationFailureReason {
         case inputDataNil
         case inputDataNilOrZeroLength
         case inputFileNil
         case inputFileReadFailed(at: URL)
         case stringSerializationFailed(encoding: String.Encoding)
         case jsonSerializationFailed(error: Error)
         case propertyListSerializationFailed(error: Error)
     }

     case parameterEncodingFailed(reason: ParameterEncodingFailureReason)
     case multipartEncodingFailed(reason: MultipartEncodingFailureReason)
     case responseValidationFailed(reason: ResponseValidationFailureReason)
     case responseSerializationFailed(reason: ResponseSerializationFailureReason)
 }
 
 错误的表示：
 /// 定义一个枚举类型的错误类型
 enum MyEnumError: Error {
     case errorOne
     case errorTwo
     /// 实现Error协议的localizedDescription只读实例属性
     var localizedDescription: String {
         let desc = self == .errorOne ? "the first errror" : "the second error"
         return "\(self): \(desc)"
     }
 }
  
 /// 定义一个结构体类型的错误类型
 struct MyStructError: Error {
     var errCode: Int = 0
     /// 实现Error协议的localizedDescription只读实例属性
     var localizedDescription: String {
         return "The error code is: \(errCode)"
     }
 }
 
 错误抛出：
 func foo(a: Int) throws -> Int {
     if a < -10 {
         // 如果a的值小于-10，
         // 则抛出MyEnumError.errorOne
         throw MyEnumError.errorOne
     }
     else if a > 10 {
         // 如果a的值大于10，
         // 则抛出MyEnumError.errorTwo
         throw MyEnumError.errorTwo
     }
     else if a == 0 {
         // 如果a的值为0，
         // 那么抛出MyStructError对象，
         // 并且其errCode的值为-1
         throw MyStructError(errCode: -1)
     }
      
     print("a = \(a)")
      
     return a
 }
 
 错误捕获与处理：
 do {
     var value = try foo(a: -100)
     value += try foo(a: 100)
     value += try foo(a: 0)
      
     print("value = \(value)")
 }   // 下面紧接着使用catch语句块
 catch let err {
     // 如果在do语句块中有任一错误抛出，
     // 那么即会执行此catch语句块中的内容
     print("err is: \(err)")
 }
 */

// MARK: URLNavigator
/**
 https://cloud.tencent.com/developer/article/1444577
 https://github.com/SeongBrave/Twilight
 URLNavigator是Swift版本的Router。
 Router的主要作用是解耦
 
 之前在各个ViewController间跳转，需要import ViewController，这样就造成ViewController之间的依赖，也即耦合
 */

// MARK: ===the swift programming language===Swift 官方===
// https://docs.swift.org/swift-book/LanguageGuide/Closures.html#ID95

// MARK: App 签名的原理
// http://www.cocoachina.com/articles/19427
// http://blog.cnbang.net/tech/3386/
/**
 iOS 签名机制挺复杂，各种证书，Provisioning Profile，entitlements，CertificateSigningRequest，p12，AppID
 一定要保证每一个安装到 iOS 上的 APP 都是经过苹果官方允许的
 
 非对称加密:
 通常我们说的签名就是数字签名，它是基于非对称加密算法实现的
 对称加密是通过同一份密钥加密和解密数据，而非对称加密则有两份密钥，分别是公钥和私钥，用公钥加密的数据，要用私钥才能解密，用私钥加密的数据，要用公钥才能解密。
 
 RSA:
 1.选两个质数 p 和 q，相乘得出一个大整数n，例如 p = 61，q = 53，n = pq = 3233
 2.选 1-n 间的随便一个质数e，例如 e = 17
 3.经过一系列数学公式，算出一个数字 d，满足：
 a.通过 n 和 e 这两个数据一组数据进行数学运算后，可以通过 n 和 d 去反解运算，反过来也可以。
 b.如果只知道 n 和 e，要推导出 d，需要知道 p 和 q，也就是要需要把 n 因数分解。
 
 上述的 (n,e) 这两个数据在一起就是公钥，(n,d) 这两个数据就是私钥，满足用私钥加密，公钥解密，或反过来公钥加密，私钥解密，也满足在只暴露公钥 (只知道 n 和 e)的情况下，要推导出私钥 (n,d)，需要把大整数 n 因数分解。目前因数分解只能靠暴力穷举，而 n 数字越大，越难以用穷举计算出因数 p 和 q，也就越安全，当 n 大到二进制 1024 位或 2048 位时，以目前技术要破解几乎不可能，所以非常安全。
 
 1.首先用一种算法，算出原始数据的摘要。需满足 a.若原始数据有任何变化，计算出来的摘要值都会变化。 b.摘要要够短。这里最常用的算法是MD5。
 2.生成一份非对称加密的公钥和私钥，私钥我自己拿着，公钥公布出去。
 3.对一份数据，算出摘要后，用私钥加密这个摘要，得到一份加密后的数据，称为原始数据的签名。把它跟原始数据一起发送给用户。
 4.用户收到数据和签名后，用公钥解密得到摘要。同时用户用同样的算法计算原始数据的摘要，对比这里计算出来的摘要和用公钥解密签名得到的摘要是否相等，若相等则表示这份数据中途没有被篡改过，因为如果篡改过，摘要会变化。
 
 之所以要有第一步计算摘要，是因为非对称加密的原理限制可加密的内容不能太大
 
 怎样通过数字签名的机制保证每一个安装到 iOS 上的 APP 都是经过苹果认证允许的:
 最简单的签名:
 最直接的方式，苹果官方生成一对公私钥，在 iOS 里内置一个公钥，私钥由苹果后台保存，我们传 App 上 AppStore 时，苹果后台用私钥对 APP 数据进行签名，iOS 系统下载这个 APP 后，用公钥验证这个签名，若签名正确，这个 APP 肯定是由苹果后台认证的，并且没有被修改过，也就达到了苹果的需求：保证安装的每一个 APP 都是经过苹果官方允许的。
 
 如果我们 iOS 设备安装 APP 只有从 AppStore 下载这一种方式的话，这件事就结束了，没有任何复杂的东西，只有一个数字签名，非常简单地解决问题。
 但实际上因为除了从 AppStore 下载，我们还可以有三种方式安装一个 App：
 1.开发 App 时可以直接把开发中的应用安装进手机进行调试。
 2.In-House 企业内部分发，可以直接安装企业证书签名后的 APP。
 3.AD-Hoc 相当于企业分发的限制版，限制安装设备数量，较少用。
 
 开发时安装APP，它有两个个需求：
 1.安装包不需要传到苹果服务器，可以直接安装到手机上。如果你编译一个 APP 到手机前要先传到苹果服务器签名，这显然是不能接受的。
 2.苹果必须对这里的安装有控制权，包括
 a. 经过苹果允许才可以这样安装。
 b. 不能被滥用导致非开发app也能被安装。
 苹果这里给出的方案是使用了双层签名:
 1.在你的 Mac 开发机器生成一对公私钥，这里称为公钥L，私钥L。L:Local
 2.苹果自己有固定的一对公私钥，跟上面 AppStore 例子一样，私钥在苹果后台，公钥在每个 iOS 设备上。这里称为公钥A，私钥A。A:Apple
 3.把公钥 L 传到苹果后台，用苹果后台里的私钥 A 去签名公钥 L。得到一份数据包含了公钥 L 以及其签名，把这份数据称为证书。
 4.在开发时，编译完一个 APP 后，用本地的私钥 L 对这个 APP 进行签名，同时把第三步得到的证书一起打包进 APP 里，安装到手机上。
 5.在安装时，iOS 系统取得证书，通过系统内置的公钥 A，去验证证书的数字签名是否正确。
 6.验证证书后确保了公钥 L 是苹果认证过的，再用公钥 L 去验证 APP 的签名，这里就间接验证了这个 APP 安装行为是否经过苹果官方允许。（这里只验证安装行为，不验证APP 是否被改动，因为开发阶段 APP 内容总是不断变化的，苹果不需要管。）
 
 上述流程只解决了上面第一个需求，也就是需要经过苹果允许才可以安装，还未解决第二个避免被滥用的问题:
 苹果再加了两个限制，一是限制在苹果后台注册过的设备才可以安装，二是限制签名只能针对某一个具体的 APP。
 在上述第三步，苹果用私钥 A 签名我们本地公钥 L 时，实际上除了签名公钥 L，还可以加上无限多数据，这些数据都可以保证是经过苹果官方认证的，不会有被篡改的可能。
 把 允许安装的设备 ID 列表 和 App对应的 AppID 等数据，都在第三步这里跟公钥L一起组成证书，再用苹果私钥 A 对这个证书签名。
 在最后第 5 步验证时就可以拿到设备 ID 列表，判断当前设备是否符合要求。根据数字签名的原理，只要数字签名通过验证，第 5 步这里的设备 IDs / AppID / 公钥 L 就都是经过苹果认证的，无法被修改，苹果就可以限制可安装的设备和 APP，避免滥用。
 
 实际上除了 设备 ID / AppID，还有其他信息也需要在这里用苹果签名，像这个 APP 里 iCloud / push / 后台运行 等权限苹果都想控制，苹果把这些权限开关统一称为 Entitlements，它也需要通过签名去授权。
 上面我们把各种额外信息塞入证书里是不合适的，于是苹果另外搞了个东西，叫 Provisioning Profile，一个 Provisioning Profile 里就包含了证书以及上述提到的所有额外信息，以及所有信息的签名。
 
 1.在你的 Mac 开发机器生成一对公私钥，这里称为公钥L，私钥L。L:Local
 2.苹果自己有固定的一对公私钥，跟上面 AppStore 例子一样，私钥在苹果后台，公钥在每个 iOS 设备上。这里称为公钥A，私钥A。A:Apple
 3.把公钥 L 传到苹果后台，用苹果后台里的私钥 A 去签名公钥 L。得到一份数据包含了公钥 L 以及其签名，把这份数据称为证书。
 4.在苹果后台申请 AppID，配置好设备 ID 列表和 APP 可使用的权限，再加上第③步的证书，组成的数据用私钥 A 签名，把数据和签名一起组成一个 Provisioning Profile 文件，下载到本地 Mac 开发机。
 5.在开发时，编译完一个 APP 后，用本地的私钥 L 对这个 APP 进行签名，同时把第④步得到的 Provisioning Profile 文件打包进 APP 里，文件名为 embedded.mobileprovision，把 APP 安装到手机上。
 6.在安装时，iOS 系统取得证书，通过系统内置的公钥 A，去验证 embedded.mobileprovision 的数字签名是否正确，里面的证书签名也会再验一遍。
 7.确保了 embedded.mobileprovision 里的数据都是苹果授权以后，就可以取出里面的数据，做各种验证，包括用公钥 L 验证APP签名，验证设备 ID 是否在 ID 列表上，AppID 是否对应得上，权限开关是否跟 APP 里的 Entitlements 对应等。
 开发者证书从签名到认证最终苹果采用的流程大致是这样
 
 上面的步骤对应到我们平常具体的操作和概念是这样的：
 1.第 1 步对应的是 keychain 里的 “从证书颁发机构请求证书”，这里就本地生成了一对公私钥，保存的 CertificateSigningRequest 就是公钥，私钥保存在本地电脑里。
 2.第 2 步苹果处理，不用管。
 3.第 3 步对应把 CertificateSigningRequest 传到苹果后台生成证书，并下载到本地。这时本地有两个证书，一个是第 1 步生成的，一个是这里下载回来的，keychain 会把这两个证书关联起来，因为他们公私钥是对应的，在XCode选择下载回来的证书时，实际上会找到 keychain 里对应的私钥去签名。这里私钥只有生成它的这台 Mac 有，如果别的 Mac 也要编译签名这个 App 怎么办？答案是把私钥导出给其他 Mac 用，在 keychain 里导出私钥，就会存成 .p12 文件，其他 Mac 打开后就导入了这个私钥。
 4.第 4 步都是在苹果网站上操作，配置 AppID / 权限 / 设备等，最后下载 Provisioning Profile 文件。
 5.第 5 步 XCode 会通过第 3 步下载回来的证书（存着公钥），在本地找到对应的私钥（第一步生成的），用本地私钥去签名 App，并把 Provisioning Profile 文件命名为 embedded.mobileprovision 一起打包进去。这里对 App 的签名数据保存分两部分，Mach-O 可执行文件会把签名直接写入这个文件里，其他资源文件则会保存在 _CodeSignature 目录下。
 第 6 – 7 步的打包和验证都是 Xcode 和 iOS 系统自动做的事。
 
 证书：内容是公钥或私钥，由其他机构对其签名组成的数据包。
 Entitlements：包含了 App 权限开关列表。
 CertificateSigningRequest：本地公钥。
 p12：本地私钥，可以导入到其他电脑。
 Provisioning Profile：包含了 证书 / Entitlements 等数据，并由苹果后台私钥签名的数据包。
 
 另外两种方式 In-House 企业签名和 AD-Hoc 流程也是差不多的，只是企业签名不限制安装的设备数，另外需要用户在 iOS 系统设置上手动点击信任这个企业才能通过验证。
 
 而 AppStore 的签名验证方式有些不一样，前面我们说到最简单的签名方式，苹果在后台直接用私钥签名 App 就可以了，实际上苹果确实是这样做的，如果去下载一个 AppStore 的安装包，会发现它里面是没有 embedded.mobileprovision 文件的，也就是它安装和启动的流程是不依赖这个文件，验证流程也就跟上述几种类型不一样了。
 
 据猜测，因为上传到 AppStore 的包苹果会重新对内容加密，原来的本地私钥签名就没有用了，需要重新签名，从 AppStore 下载的包苹果也并不打算控制它的有效期，不需要内置一个 embedded.mobileprovision 去做校验，直接在苹果用后台的私钥重新签名，iOS 安装时用本地公钥验证 App 签名就可以了。
 
 那为什么发布 AppStore 的包还是要跟开发版一样搞各种证书和 Provisioning Profile？猜测因为苹果想做统一管理，Provisioning Profile 里包含一些权限控制，AppID 的检验等，苹果不想在上传 AppStore 包时重新用另一种协议做一遍这些验证，就不如统一把这部分放在 Provisioning Profile 里，上传 AppStore 时只要用同样的流程验证这个 Provisioning Profile 是否合法就可以了。

 所以 App 上传到 AppStore 后，就跟你的 证书 / Provisioning Profile 都没有关系了，无论他们是否过期或被废除，都不会影响 AppStore 上的安装包。
 
 AppStore 加密:
 另一个问题是我们把 App 传上 AppStore 后，苹果会对 App 进行加密，导致 App 体积增大不少，这个加密实际上是没卵用的，只是让破解的人要多做一个步骤，运行 App 去内存 dump 出可执行文件而已，无论怎样加密，都可以用这种方式拿出加密前的可执行文件。
 
 ==========签名的过程:
 1.首先mac生成csr文件,然后发送到Apple服务器,Apple进行签名,生成证书.
 2.然后创建appid,选择功能权限,添加设备.
 3.接着把第二步创建的信息包括第一步的证书信息组合起来,Apple进行签名,就生成了Provisioning Profile文件.
 4.Xcode编译的时候,mac会对app包签名,并且把Provisioning Profile文件也打包进去,生成文件embedded.mobileprovision.
 5.api包安装到设备上的时候,设备会对embedded.mobileprovision进行验证,以及对相关信息进行验证,比如设备是否注册,appid等等.
 
 由于个人或者公司账号限制设备数为100,如果想在一百台以上的设备上安装,打一次包就不能实现,因为Provisioning Profile中只有那100台设备,即使在这100台设备安装之后,在apple developer删除这些设备,再添加另外100台,这新的100台设备也是不能安装的.这时只能重新打包,或者重签名
 ,批量的重签名可以使用第三方的服务.

 */

// MARK: ===音视频===Audio Unit
// https://www.jianshu.com/p/5d18180c69b8
// https://www.jianshu.com/p/f859640fcb33

// MARK: APP重签名
/**
 查看APP包的签名信息
 $codesign -vv -d xxx.app
 
 要重签名一定要有一个证书才可以，如下命令查看本机所有证书
 $security find-identity -v -p codesigning
 
 查看描述文件信息:
 $security cms -D -i 描述文件路径
 
 在开发完成之后我们的APP要上传到App Store需要进行加密，从App Store下载安装APP的时候需要解密，这是一个可逆的过程。进入到.app 路径下，查看可执行文件的加密信息!
 $otool -l WeChat | grep crypt
 加密标识为0，代表没有加密（因为已经砸壳了）两个标识代表这个可执行文件支持两个架构arm64、armv7
 
 逆向重签名有一个强大的Xcode插件MonkeyDev
 */

// MARK: 逆向
// https://github.com/AloneMonkey/MonkeyDev

// MARK: ===动画===
// https://github.com/WalkingToTheDistant/ImgAnimation
// https://www.jianshu.com/u/25b2d09211e4

// MARK: gitlab
/**
 Gitlab-CI是GitLab Continuous Integration（Gitlab持续集成）的简称
 持续集成是一个软件工程概念，表示不断的将代码集成到主干分支的行为
 每次我们集成代码的时候，我们希望系统能够帮助我们完成一些事情，比如说构建项目，打包，自动化测试等等，也就是所谓的持续递交
 
 Gitlab-CI配置起来也很方便，只需要开启Gitlab-runner和书写.gitlab-ci.yml文件即可完成
 Runner的作用是运行定义在.gitlab-ci.yml文件里的代码。Runner可以看做一种虚拟机
 Runner分为两种，一种是可以作用于任何项目的Runner，叫做Shared Runner。还有一种只能作用于特定的项目，叫做Specified Runner
 如果若干个项目拥有相似的需求，那么就可以使用Shared Runner，避免使空闲的Runner过多。如果某个项目的CI活动非常频繁，那么可以考虑使用Specified Runner
 
 一般不要在安装了Gitlab的机器上面部署Runner，因为两者都会消耗大量的内存，会引起性能问题
 
 https://docs.gitlab.com/runner/install/osx.html // runner
 */

// MARK: git
/**
 git push <远程主机名> <本地分支名>  <远程分支名>
 
 git push origin master
 如果远程分支被省略，如上则表示将本地分支推送到与之存在追踪关系的远程分支（通常两者同名），如果该远程分支不存在，则会被新建
 */

// MARK: 原子操作
/**
 对于一个资源，在写入或读取时，只允许在一个时刻一个角色进行操作，则为原子操作
 对于 let 声明的资源，永远是原子性的。
 对于 var 声明的资源，是非原子性的，对其进行读写时，必须使用一定的手段，确保其值的正确性
 */

/*
 RxSwift: 响应式编程
 Rx 是 ReactiveX 的缩写 (reactive:有反应的)
 http://reactivex.io/
 */

// Swift4.0
/*
 Swift3 新增了 #keyPath()
 Swift4 中直接用 \ 作为开头创建 KeyPath
 类型可以定义为 class、struct
 定义类型时无需加上 @objc 等关键字
 user1.value(forKeyPath: #keyPath(User.name)) 返回的类型是 Any，user1[keyPath: \User.name] 直接返回 String 类型
 使用 appending 方法向已定义的 Key Path 基础上填加新的 Key Path。
 let keyPath1 = \User.phone
 let keyPath2 = keyPath1.appending(path: \.number)
 
 类与协议的组合类型:
 #在 Swift4 中，可以把类（Class）和协议（Protocol）用 & 组合在一起作为一个类型使用
 #在 Swift4 中, private 属性作用域扩大到 extension
 
 下标支持泛型:
 下标的返回类型支持泛型
 下标类型同样支持泛型
 struct GenericDictionary<Key: Hashable, Value> {
 private var data: [Key: Value]
 
 init(data: [Key: Value]) {
 self.data = data
 }
 
 subscript<T>(key: Key) -> T? {
 return data[key] as? T
 }
 }
 
 Codable 序列化:
 如果要将一个对象持久化，需要把这个对象序列化。过去的做法是实现 NSCoding 协议，但实现 NSCoding 协议的代码写起来很繁琐，尤其是当属性非常多的时候。
 Swift4 中引入了 Codable 协议，可以大大减轻了我们的工作量。我们只需要让需要序列化的对象符合 Codable 协议即可，不用再写任何其他的代码
 struct Language: Codable {
 var name: String
 var version: Int
 }
 
 Encode 操作
 let swift = Language(name: "Swift", version: 4)
 
 //encoded对象
 let encodedData = try JSONEncoder().encode(swift)
 
 //从encoded对象获取String
 let jsonString = String(data: encodedData, encoding: .utf8)
 print(jsonString)
 
 Decode 操作
 let decodedData = try JSONDecoder().decode(Language.self, from: encodedData)
 print(decodedData.name, decodedData.version)
 
 Swift 4 中有一个很大的变化就是 String 可以当做 Collection 来用，并不是因为 String 实现了 Collection 协议:
 
 swap() 方法将会被废弃，建议使用 tuple（元组）特性来实现值交换，也只需要一句话就能实现：
 var a = 1
 var b = 2
 (b, a) = (a, b)
 
 
 过去的情况（Swift3）如果想把 Swift 写的 API 暴露给 Objective-C 调用，需要增加 @objc。在 Swift 3 中，编译器会在很多地方为我们隐式的加上 @objc
 比如当一个类继承于 NSObject，那么这个类的所有方法都会被隐式的加上 @objc。
 class MyClass: NSObject {
 func print() { } // 包含隐式的 @objc
 func show() { } // 包含隐式的 @objc
 }
 在 Swift 4 中隐式 @objc 自动推断只会发生在下面这种必须要使用 @objc 的情况
 覆盖父类的 Objective-C 方法
 符合一个 Objective-C 的协议
 
 大多数地方必须手工显示地加上 @objc。
 class MyClass: NSObject {
 @objc func print() { } //显示的加上 @objc
 @objc func show() { } //显示的加上 @objc
 }
 如果在类前加上 @objcMembers，那么它、它的子类、扩展里的方法都会隐式的加上 @objc
 如果在扩展（extension）前加上 @objc，那么该扩展里的方法都会隐式的加上 @objc
 如果在扩展（extension）前加上 @nonobjc，那么该扩展里的方法都不会隐式的加上 @objc
 
 MARK:单例
 1.静态常量
 class MyClass {
 static let shared = MyClass()
 private init() { }
 }
 
 2.全局变量
 fileprivate let sharedInstance = MyClass()
 class MyClass {
 
 static var shared: MyClass {
 return sharedInstance
 }
 
 fileprivate init() { }
 }
 
 Swift在初始化过程中定义了这么多规则, 归根到底是为了所有属性能被初始化
 便利构造器是对类初始化方法的补充
 convenience的一般用法: 扩展类的构造函数
 */

// MARK:swift源码解析
// https://www.jianshu.com/u/a4b11b398b1e

// MARK: Swift 3.0
/**
 在 Swift 3 中，编译器会在很多地方为我们隐式的加上 @objc。
 当一个类继承于 NSObject，那么这个类的所有方法都会被隐式的加上 @objc。
 class MyClass: NSObject {
     func print() { } // 包含隐式的 @objc
     func show() { } // 包含隐式的 @objc
 }
 但这样做很多并不需要暴露给 Objective-C 也被加上了 @objc。而大量 @objc 会导致二进制文件大小的增加
 
 swift 4.0
 在 Swift 4 中隐式 @objc 自动推断只会发生在下面这种必须要使用 @objc 的情况：
 覆盖父类的 Objective-C 方法
 符合一个 Objective-C 的协议
 
 大多数地方必须手工显示地加上 @objc。
 class MyClass: NSObject {
     @objc func print() { } //显示的加上 @objc
     @objc func show() { } //显示的加上 @objc
 }
 
 如果在类前加上 @objcMembers，那么它、它的子类、扩展里的方法都会隐式的加上 @objc。
 @objcMembers
 class MyClass: NSObject {
     func print() { } //包含隐式的 @objc
     func show() { } //包含隐式的 @objc
 }
  
 extension MyClass {
     func baz() { } //包含隐式的 @objc
 }
 
 如果在扩展（extension）前加上 @objc，那么该扩展里的方法都会隐式的加上 @objc。
 class SwiftClass { }
  
 @objc extension SwiftClass {
     func foo() { } //包含隐式的 @objc
     func bar() { } //包含隐式的 @objc
 }
 
 如果在扩展（extension）前加上 @nonobjc，那么该扩展里的方法都不会隐式的加上 @objc。
 @objcMembers
 class MyClass : NSObject {
     func wibble() { } //包含隐式的 @objc
 }
  
 @nonobjc extension MyClass {
     func wobble() { } //不会包含隐式的 @objc
 }
 
 */

/*
 MARK:Swift4.0
 
 Swift 的静态语言特性，每个函数的调用在编译期间就可以确定
 
 CaseInterable协议:
 
 检查序列元素是否符合条件:
 let scores = [86, 88, 95, 92]
 //返回一个BOOL
 let passed = scores.allSatisfy({ $0 > 85 })
 
 布尔切换:
 toggle()方法
 
 #warning和#error编译指令:
 */

/*
 MARK:static 与 class 的区别:
 static 可以在类、结构体、或者枚举中使用。而 class 只能在类中使用。
 static 可以修饰存储属性，static 修饰的存储属性称为静态变量(常量)。而 class 不能修饰存储属性。
 static 修饰的计算属性不能被重写。而 class 修饰的可以被重写。
 static 修饰的静态方法不能被重写。而 class 修饰的类方法可以被重写。
 class 修饰的计算属性被重写时，可以使用 static 让其变为静态属性。
 class 修饰的类方法被重写时，可以使用 static 让方法变为静态方法
 */

// MARK: 函数式编程
/**
 Functor 和 Monad 都是函数式编程的概念
 
 Functor意味着实现了 map 方法，而Monad意味着实现了flatMap
 因此 Optional 类型和 Array 类型都既是 Functor 又是 Monad，与Result一样，它们都是一种复合类型，或者叫 Wrapper 类型
 
 map 方法：传入的 transform 函数的 入参是 Wrapped 类型，返回的是 Wrapped 类型
 flatMap 方法：传入的 transform 函数的 入参是 Wrapped 类型，返回的是 Wrapper 类型
 */

struct Point {
    var x: Double
    var y: Double
}

struct TestPoint {
    let x: Double
    let y: Double
    let isFilled: Bool
}

enum Season{
    case spring(Int,Int,Int),
         summer(String,String,String),
         autumn(Bool,Bool,Bool),
         winter(Int,Int),
         unknown(Bool)
}

// (UnsafeRawPointer?) -> Unmanaged<CFString>?  // 函数字面量
func arrayCopyDescriptionCallBack(_ p: UnsafeRawPointer?) -> Unmanaged<CFString>? {
    return nil
}

import UIKit
import Accelerate




// markdown
/**
 # 一级标题
 1.
 2.
 ## 二级标题
 -
 -
 [官网](https:XXX) 链接
 */

// markup语法 只在playground中能用
//: # 一级标题

// MARK: swift支持多行注释的嵌套
/*
 1
 /*
 ======
 */
 2.
 */

// MARK: Bool
/**
 /*
 C语言和OC并没有真正的Bool类型
 C语言的Bool类型非0即真
 OC中if可以是任何整数(非0即真),
 OC语言的Bool类型是typedef signed char BOOL;

 Swift引入了真正的Bool类型
 Bool true false
 Swift中的if的条件只能是一个Bool的值或者是返回值是Bool类型的表达式(==/!=/>/<等等)
 */
 */

// MARK:static、const、extern
/**
 static关键字：
 修饰局部变量时：
 1、使得局部变量只初始化一次
 2、局部变量在程序中只有一份内存
 3、局部变量作用域不变，但是生命周期改变了（程序结束才能销毁）
 修饰全局变量：
 1、全局变量的作用域仅限当前文件，外部类是不可以访问到该全局变量的。
 
 被const修饰的变量是只读的：
 基本数据类型：
 int const a = 10; 和const int b = 20; 效果是一样的 只读常量
 指针类型：
 NSString *p;
 *p是地址中的值，p是指针地址。
 NSString const *p 表示地址中的值没法改变，但是指针的指向可以改变；
 而 NSString *const p 表示指针的指向不能改变，但是地址里的内容是可以改变的
 
 extern 外部常量的最佳方法：
 extern const 关键字，表示这个变量已经声明
 
 .m文件中定义的常量，用const修饰代表常量。其中const CGFloat a = 10.f; 和 CGFloat const a = 10.f;两种写法是一样的，都代表a值为常量，不可修改。但是外部可通过extern CGFloat a;引用该变量
 
 全局变量若只想被该文件所持有，不希望被外界引用，则用static修饰，也就是static const CGFloat a = 10.f;和 static CGFloat const a = 10.f；
 */

// MARK: 大佬优化blog
/**
 https://juejin.im/user/5b9b0ef16fb9a05d353c6418/posts
 冷启动优化
 https://juejin.im/post/5e4bbbe15188254945385eb5
 
 
 
 
 MLeaksFinder 是 WeRead 团队开源的iOS内存泄漏检测工具
 https://github.com/Tencent/MLeaksFinder
 */

// MARK: Metal
/**
 https://blog.csdn.net/cordova/article/month/2020/04
 */

// MARK: ==Charles==
/**
 设置网络，进行抓包:
 将移动设备和电脑设备设置为同一个网络，即连接同一个Wi-Fi。
 利用电脑查询IP地址
 设置移动设备的网络代理模式 进入连接的无线网的高级模式
 进入HTTP代理模式，然后选择手动，并在服务器中填写自己查到的IP地址，然后在端口中填写8888，最后存储设置。

 证书配置，拦截HTTPS请求
 需要设置SSL Proxying Settings，将对应的域名以及端口添加进去，使用*:*即可
 另外还有相关证书的配置，通过help->SSL Proxying去安装证书，Mac与iPhone都要进行安装并且信任
 配置电脑端证书，选择install Charles Root Certificate，然后安装，最后选择始终信任
 配置手机端证书，选择install Charles Root Certificate on a Mobile Device or Remote Browser，然后在手机浏览器里输入chls.pro/ssl下载，进行安装。最后一步就是进入手机设置，通用->关于本机->证书信任设置，然后信任刚刚安装的证书即可
 
 Mock链接的数据：
 如果列表有很多的请求，可以通过左下角的Filter:进行筛选
 
 方法一：
 首先要选择出想要mock数据的接口，设置断点
 然后需要再次触发访问该接口。Charles会停留在断点接口，提供一个Edit Request页，可提供修改参数以及请求类型、请求链接的校验。
 接着点击Execute进行执行下一步，选择JSON Text可以看到断点链接返回的参数，这个时候就可以改动返回值的结果，以达到想要测试的目的。
 执行Execute，便可看到下面结果（确保没有请求超时）
 方法二:
 按照方法一的步骤，获取到断点链接返回的数据后，把数据源拷贝出来，本地新建一个JSON类型的文件，把返回的数据复制到该文件中
 把保存好的json文件放置在桌面
 同时修改你要mock的数据
 在你需要调试的接口，右键有个Map Local
 选择你在本地提前写好的json文件
 最后再次触发该请求即可。
 */

// MARK: ==离屏渲染 （Offscreen rendering）==
/**
 iOS 9.0 之前UIimageView跟UIButton设置圆角都会触发离屏渲染。
 iOS 9.0 之后UIButton设置圆角会触发离屏渲染，而UIImageView里png图片设置圆角不会触发离屏渲染了，如果设置其他阴影效果之类的还是会触发离屏渲染的
 1.通过设置layer的属性
 maskToBounds会触发离屏渲染，GPU在当前屏幕缓冲区外新开辟了一个渲染缓冲区进行工作，也就是离屏渲染，这会给我们带来额外的性能损耗，如果这样的圆角操作达到一定数量，会触发缓冲区的频繁合并和上下文的频繁切换，性能的代价会宏观的表现在用户体验上<掉帧>
 
 对于文本视图实现圆角（UILabel, UIView, UITextField, UITextView）
 均只进行cornerRadius设置，不进行masksToBounds的设置
 对于UILabel, UIView, UITextField来说，实现了圆角的设置，并没有产生离屏渲染；
 而对于UITextView，产生了离屏渲染
 
 2.使用贝塞尔曲线UIBezierPath和Core Graphics框架画出一个圆角
 UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
  imageView.image = [UIImage imageNamed:@"TestImage.jpg"];
  // 开始对imageView进行画图
  UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);
  // 使用贝塞尔曲线画出一个圆形图
  [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds cornerRadius:imageView.frame.size.width] addClip];
  [imageView drawRect:imageView.bounds];
  imageView.image = UIGraphicsGetImageFromCurrentImageContext();
  // 结束画图
  UIGraphicsEndImageContext();
  [self.view addSubview:imageView];
 
 UIGraphicsBeginImageContextWithOption(CGSize size, BOOL opaque, CGFloat scale)各参数的含义：
 size ---新创建的文图上下文大小
 opaque --- 透明开关，如果图形完全不用透明，设置为YES以优化位图的存储。
 scale --- 缩放因子。虽然这里可以用[UIScreen mainScreen].scale来获取，但实际上设为0后，系统会自动设置正确的比例

  3.使用Core Graphics框架画出一个圆角
 UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
 imageView.image = [UIImage imageNamed:@"TestImage.jpg"];

 // 开始对imageView进行画图
 UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 0.0);

 // 获取图形上下文
 CGContextRef ctx = UIGraphicsGetCurrentContext();

 // 设置一个范围
 CGRect rect = CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height);

 // 根据一个rect创建一个椭圆
 CGContextAddEllipseInRect(ctx, rect);

 // 裁剪
 CGContextClip(ctx);

 // 讲原照片画到图形上下文
 [imageView.image drawInRect:rect];

 // 从上下文上获取裁剪后的照片
 UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

 // 关闭上下文
 UIGraphicsEndImageContext();
 imageView.image = image;
 [self.view addSubview:imageView];

  4.使用CAShapeLayer和UIBezierPath设置圆角
 UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 200, 100, 100)];
 imageView.image = [UIImage imageNamed:@"TestImage.jpg"];
 UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:imageView.bounds byRoundingCorners:UIRectCornerAllCorners
 cornerRadii:imageView.bounds.size];
 CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];
 // 设置大小
 maskLayer.frame = imageView.bounds;
 // 设置图形样子
 maskLayer.path = maskPath.CGPath;
 imageView.layer.mask = maskLayer;
 [self.view addSubview:imageView];
 第四种方法并不可取，存在离屏渲染.掉帧更加严重。基本上不能使用
 
 5.混合图层
 在需要裁剪的视图上面添加一层视图，以达到圆角的效果
 - (void)drawRoundedCornerImage {
     UIImageView *iconImgV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
     iconImgV.image = [UIImage imageNamed:@"icon"];
     [self.view addSubview:iconImgV];
     
     [iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(iconImgV.size);
         make.top.equalTo(self.view.mas_top).offset(500);
         make.centerX.equalTo(self.view);
     }];
     
     UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
     [self.view addSubview:imgView];
     
     [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.size.mas_equalTo(imgView.size);
         make.top.equalTo(iconImgV.mas_top);
         make.leading.equalTo(iconImgV.mas_leading);
     }];
     
     // 圆形
     imgView.image = [self drawCircleRadius:100 outerSize:CGSizeMake(200, 200) fillColor:[UIColor whiteColor]];
 }

 // 绘制圆形
 - (UIImage *)drawCircleRadius:(float)radius outerSize:(CGSize)outerSize fillColor:(UIColor *)fillColor {
     UIGraphicsBeginImageContextWithOptions(outerSize, false, [UIScreen mainScreen].scale);
     
     // 1、获取当前上下文
     CGContextRef contextRef = UIGraphicsGetCurrentContext();
     
     //2.描述路径
     // ArcCenter:中心点 radius:半径 startAngle起始角度 endAngle结束角度 clockwise：是否逆时针
     UIBezierPath *bezierPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(outerSize.width * 0.5, outerSize.height * 0.5) radius:radius startAngle:0 endAngle:M_PI * 2 clockwise:NO];
     [bezierPath closePath];
     
     // 3.外边
     [bezierPath moveToPoint:CGPointMake(0, 0)];
     [bezierPath addLineToPoint:CGPointMake(outerSize.width, 0)];
     [bezierPath addLineToPoint:CGPointMake(outerSize.width, outerSize.height)];
     [bezierPath addLineToPoint:CGPointMake(0, outerSize.height)];
     [bezierPath addLineToPoint:CGPointMake(0, 0)];
     [bezierPath closePath];
     
     //4.设置颜色
     [fillColor setFill];
     [bezierPath fill];
     
     CGContextDrawPath(contextRef, kCGPathStroke);
     UIImage *antiRoundedCornerImage = UIGraphicsGetImageFromCurrentImageContext();
     UIGraphicsEndImageContext();
     
     return antiRoundedCornerImage;
 }


 
 在Application这一层中主要是CPU在操作，而到了Render Server这一层，CoreAnimation会将具体操作转换成发送给GPU的draw calls（以前是call OpenGL ES，现在慢慢转到了Metal），显然CPU和GPU双方同处于一个流水线中，协作完成整个渲染工作。

 离屏渲染的定义:
 ###
 如果要在显示屏上显示内容，我们至少需要一块与屏幕像素数据量一样大的frame buffer，作为像素数据存储区域，而这也是GPU存储渲染结果的地方。如果有时因为面临一些限制，无法把渲染结果直接写入frame buffer，而是先暂存在另外的内存区域，之后再写入frame buffer，那么这个过程被称之为离屏渲染。
 ###
 
 CPU”离屏渲染“
 如果我们在UIView中实现了drawRect方法，就算它的函数体内部实际没有代码，系统也会为这个view申请一块内存区域，等待CoreGraphics可能的绘画操作。
 对于类似这种“新开一块CGContext来画图“的操作，有很多文章和视频也称之为“离屏渲染”（因为像素数据是暂时存入了CGContext，而不是直接到了frame buffer）
 其实所有CPU进行的光栅化操作（如文字渲染、图片解码），都无法直接绘制到由GPU掌管的frame buffer，只能暂时先放在另一块内存之中，说起来都属于“离屏渲染”。
 CPU渲染并非真正意义上的离屏渲染
 
 如果你的view实现了drawRect，此时打开Xcode调试的“Color offscreen rendered yellow”开关，你会发现这片区域不会被标记为黄色，说明Xcode并不认为这属于离屏渲染
 
 ###
 其实通过CPU渲染就是俗称的“软件渲染”，而真正的离屏渲染发生在GPU
 ###
 
 主要的渲染操作都是由CoreAnimation的Render Server模块，通过调用显卡驱动所提供的OpenGL/Metal接口来执行的。
 通常对于每一层layer，Render Server会遵循“画家算法”，按次序输出到frame buffer，后一层覆盖前一层，就能得到最终的显示结果
 ###
 在iOS中，设备主存和GPU的显存共享物理内存，这样可以省去一些数据传输开销
 ###
 
 作为“画家”的GPU虽然可以一层一层往画布上进行输出，但是无法在某一层渲染完成之后，再回过头来擦除/改变其中的某个部分——因为在这一层之前的若干层layer像素数据，已经在渲染中被永久覆盖了。这就意味着，对于每一层layer，要么能找到一种通过单次遍历就能完成渲染的算法，要么就不得不另开一块内存，借助这个临时中转区域来完成一些更复杂的、多次的修改/剪裁操作。
 
 如果要绘制一个带有圆角并剪切圆角以外内容的容器，就会触发离屏渲染
 可能：
 将一个layer的内容裁剪成圆角，可能不存在一次遍历就能完成的方法
 容器的子layer因为父容器有圆角，那么也会需要被裁剪，而这时它们还在渲染队列中排队，尚未被组合到一块画布上，自然也无法统一裁剪
 此时我们就不得不开辟一块独立于frame buffer的空白内存，先把容器以及其所有子layer依次画好，然后把四个角“剪”成圆形，再把结果画到frame buffer中。这就是GPU的离屏渲染
 https://texturegroup.org/docs/corner-rounding.html
 
 常见离屏渲染场景分析：
 cornerRadius+clipsToBounds
 shadow
 虽然layer本身是一块矩形区域，但是阴影默认是作用在其中”非透明区域“的，而且需要显示在所有layer内容的下方，因此根据画家算法必须被渲染在先。但矛盾在于此时阴影的本体（layer和其子layer）都还没有被组合到一起，怎么可能在第一步就画出只有完成最后一步之后才能知道的形状呢
 不过如果我们能够预先告诉CoreAnimation（通过shadowPath属性）阴影的几何形状，那么阴影当然可以先被独立渲染出来，不需要依赖layer本体，也就不再需要离屏渲染了
 group opacity
 alpha并不是分别应用在每一层之上，而是只有到整个layer树画完之后，再统一加上alpha，最后和底下其他layer的像素进行组合。
 （从iOS7开始，如果没有显式指定，group opacity会默认打开）
 mask
 我们知道mask是应用在layer和其所有子layer的组合之上的，而且可能带有透明度，那么其实和group opacity的原理类似
 
 GPU离屏渲染的性能影响：
 GPU的操作是高度流水线化的。本来所有计算工作都在有条不紊地正在向frame buffer输出，此时突然收到指令，需要输出到另一块内存，那么流水线中正在进行的一切都不得不被丢弃，切换到只能服务于我们当前的“切圆角”操作。等到完成以后再次清空，再回到向frame buffer输出的正常流程。
 
 善用离屏渲染：
 尽管离屏渲染开销很大，但是当我们无法避免它的时候，可以想办法把性能影响降到最低。优化思路也很简单：既然已经花了不少精力把图片裁出了圆角，如果我能把结果缓存下来，那么下一帧渲染就可以复用这个成果，不需要再重新画一遍了。

 CALayer为这个方案提供了对应的解法：shouldRasterize。一旦被设置为true，Render Server就会强制把layer的渲染结果（包括其子layer，以及圆角、阴影、group opacity等等）保存在一块内存中，这样一来在下一帧仍然可以被复用，而不会再次触发离屏渲染。有几个需要注意的点：
 shouldRasterize的主旨在于降低性能损失，但总是至少会触发一次离屏渲染。如果你的layer本来并不复杂，也没有圆角阴影等等，打开这个开关反而会增加一次不必要的离屏渲染
 离屏渲染缓存有空间上限，最多不超过屏幕总像素的2.5倍大小
 一旦缓存超过100ms没有被使用，会自动被丢弃
 layer的内容（包括子layer）必须是静态的，因为一旦发生变化（如resize，动画），之前辛苦处理得到的缓存就失效了。如果这件事频繁发生，我们就又回到了“每一帧都需要离屏渲染”的情景，而这正是开发者需要极力避免的。针对这种情况，Xcode提供了“Color Hits Green and Misses Red”的选项，帮助我们查看缓存的使用是否符合预期
 其实除了解决多次离屏渲染的开销，shouldRasterize在另一个场景中也可以使用：如果layer的子结构非常复杂，渲染一次所需时间较长，同样可以打开这个开关，把layer绘制到一块缓存，然后在接下来复用这个结果，这样就不需要每次都重新绘制整个layer树了
 
 什么时候需要CPU渲染:
 渲染性能的调优，其实始终是在做一件事：平衡CPU和GPU的负载，让他们尽量做各自最擅长的工作
 绝大多数情况下，得益于GPU针对图形处理的优化，我们都会倾向于让GPU来完成渲染任务，而给CPU留出足够时间处理各种各样复杂的App逻辑。为此Core Animation做了大量的工作，尽量把渲染工作转换成适合GPU处理的形式（也就是所谓的硬件加速，如layer composition，设置backgroundColor等等）。
 但是对于一些情况，如文字（CoreText使用CoreGraphics渲染）和图片（ImageIO）渲染，由于GPU并不擅长做这些工作，不得不先由CPU来处理好以后，再把结果作为texture传给GPU。除此以外，有时候也会遇到GPU实在忙不过来的情况，而CPU相对空闲（GPU瓶颈），这时可以让CPU分担一部分工作，提高整体效率。
 一个典型的例子是，我们经常会使用CoreGraphics给图片加上圆角（将图片中圆角以外的部分渲染成透明）。整个过程全部是由CPU完成的。这样一来既然我们已经得到了想要的效果，就不需要再另外给图片容器设置cornerRadius。
 
 渲染不是CPU的强项，调用CoreGraphics会消耗其相当一部分计算时间，并且我们也不愿意因此阻塞用户操作，因此一般来说CPU渲染都在后台线程完成（这也是AsyncDisplayKit的主要思想），然后再回到主线程上，把渲染结果传回CoreAnimation。这样一来，多线程间数据同步会增加一定的复杂度
 同样因为CPU渲染速度不够快，因此只适合渲染静态的元素，如文字、图片（想象一下没有硬件加速的视频解码，性能惨不忍睹）
 作为渲染结果的bitmap数据量较大（形式上一般为解码后的UIImage），消耗内存较多，所以应该在使用完及时释放，并在需要的时候重新生成，否则很容易导致OOM
 一定要使用Instruments的不同工具来测试性能，而不是仅凭猜测来做决定
 
 优化:
 大量应用AsyncDisplayKit(Texture)作为主要渲染框架，对于文字和图片的异步渲染操作交由框架来处理
 对于图片的圆角，统一采用“precomposite”的策略，也就是不经由容器来做剪切，而是预先使用CoreGraphics为图片裁剪圆角
 对于视频的圆角，由于实时剪切非常消耗性能，我们会创建四个白色弧形的layer盖住四个角，从视觉上制造圆角的效果
 对于view的圆形边框，如果没有backgroundColor，可以放心使用cornerRadius来做
 对于所有的阴影，使用shadowPath来规避离屏渲染
 对于特殊形状的view，使用layer mask并打开shouldRasterize来对渲染结果进行缓存
 对于模糊效果，不采用系统提供的UIVisualEffect，而是另外实现模糊效果（CIGaussianBlur），并手动管理渲染结果
 
 https://zhuanlan.zhihu.com/p/72653360
 */


// MARK: swift 常用第三方库
/**
 https://www.jianshu.com/p/f4282df18537
 
 */

// MARK: Swift 常用UI
/**
 // UI库
 https://github.com/Ramotion/swift-ui-animation-components-and-libraries
 
 // tab-bar
 https://github.com/Ramotion/animated-tab-bar
 */


// MARK: UIApplicationMain
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    var globalVar = 100
    
    func testInOut(_ number: inout Int) {
        number += globalVar
    }
 
    // 定义时必须指定一个类型
    func takeIntPointer(_ p: UnsafePointer<Int>) {// 常量指针: UnsafePointer
        // p.pointee += 1 // 报错: Left side of mutating operator isn't mutable: 'pointee' is a get-only property
        print("takeIntPointer: \(p.pointee)")
    }
    
    func takeRawPointer(_ p: UnsafeRawPointer?) {
        print("takeRawPointer: \(p.debugDescription)")
    }
    
    func takeIntMutPointer(_ p: UnsafeMutablePointer<Int>) {
        p.pointee += 1
        print("takeIntMutPointer: \(p.pointee)")
    }
    
    func takeRawMutPointer(_ p: UnsafeMutableRawPointer?) {
        print("takeRawMutPointer: \(p.debugDescription)")
    }
    
    func takeAutoreleasingPointer(_ p: AutoreleasingUnsafeMutablePointer<Int>) {
        
    }
    
    // 指针可以使用load等方法转为对应的类型
    func pri<T>(address p: UnsafeRawPointer, as type: T.Type) {
        let value = p.load(as: type)
        print(value)
    }
    
    // ================
    func incrementor(ptr: UnsafeMutablePointer<Int>) {
        ptr.pointee += 1
    }
    
    func incrementor1(num: inout Int) {
        num += 1
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        print("AppDelegate: \(#file): \(#function)")
        
        // MARK: dispatch_once && method swizzling
        OnceClass.takeOnceTimeFunc()
        OnceClass.takeOnceTimeFunc()
        
        
        // MARK: UserDefaults
        /**
         ["INNextHearbeatDate": 615967481.533718, "INNextFreshmintRefreshDateKey": 615536873.3292, "AppleKeyboards": <__NSCFArray 0x281d04a80>(
         zh_Hans-Pinyin@sw=Pinyin-Simplified;hw=US,
         zh_Hans-Pinyin@sw=Pinyin10-Simplified;hw=US,
         ar@sw=Arabic;hw=Automatic,
         en_US@hw=US;sw=QWERTY,
         yue_Hant-HWR@sw=HWR-Traditional,
         zh_Hant-HWR@sw=HWR-Traditional,
         emoji@sw=Emoji,
         com.sogou.sogouinput.basekeyboard
         )
         , "AppleKeyboardsExpanded": 1, "AppleLanguagesSchemaVersion": 1001, "CarCapabilities": {
             CarCapabilitiesDefaultIdentifier =     {
                 CRCapabilitiesDisabledFeatureKey = 0;
                 CRCapabilitiesUserInterfaceStyleKey = 2;
                 CapabilitiesDashboardRoundedCornersKey = "{{0, 0}, {0, 0}}";
                 CapabilitiesNowPlayingAlbumArtKey = 2;
                 CapabilitiesViewAreaInsetKey = "{{0, 0}, {0, 0}}";
             };
         }, "AKDeviceUnlockState": 1, "AKLastEmailListRequestDateKey": 2020-07-09 03:18:54 +0000, "com.apple.content-rating.ExplicitMusicPodcastsAllowed": 1, "AppleTemperatureUnit": Celsius, "PKKeychainVersionKey": 7, "com.apple.content-rating.TVShowRating": 1000, "NSPersonNameDefaultDisplayNameOrder": 2, "com.apple.content-rating.ExplicitBooksAllowed": 1, "AddingEmojiKeybordHandled": 1, "AppleLanguages": <__NSCFArray 0x281203d20>(
         zh-Hans-CN,
         ar-CN,
         en-CN,
         zh-Hant-HK,
         zh-Hant-CN,
         yue-Hant-CN
         )
         , "MSVLoggingMasterSwitchEnabledKey": 0, "AKLastIDMSEnvironment": 0, "NSLanguages": <__NSArrayI 0x2815191d0>(
         zh-Hans-CN,
         ar-CN,
         en-CN,
         zh-Hant-HK,
         zh-Hant-CN,
         yue-Hant-CN,
         en
         )
         , "AppleICUForce24HourTime": 1, "ApplePasscodeKeyboards": <__NSCFArray 0x281203cc0>(
         zh_Hans-Pinyin@sw=Pinyin-Simplified;hw=US,
         zh_Hans-Pinyin@sw=Pinyin10-Simplified;hw=US,
         en_US@hw=US;sw=QWERTY,
         zh_Hant-HWR@sw=HWR-Traditional,
         emoji@sw=Emoji
         )
         , "com.apple.content-rating.AppRating": 1000, "AKLastCheckInAttemptDate": 2019-10-19 12:39:30 +0000, "AppleLocale": zh_CN, "AKLastCheckInSuccessDate": 2019-10-19 12:39:33 +0000, "NSInterfaceStyle": macintosh, "AppleLanguagesDidMigrate": 17F80, "com.apple.content-rating.MovieRating": 1000, "AppleITunesStoreItemKinds": <__NSCFArray 0x281801f00>(
         podcast,
         artist,
         itunes-u,
         booklet,
         document,
         movie,
         eBook,
         software,
         software-update,
         podcast-episode
         )
         ]
         
         比如应用内切换中英文，就需要修改AppleLanguages的value
         AppleLanguages与手机设置里面的首选语言顺序相同
         
         在App内想切换成中文
         UserDefaults.standard.setValue(["zh-Hans-CN"], forKey: "AppleLanguages")
         
         那么如果这个时候用户在系统设置中切换到了日语，那么我想在客户端中通过跟随手机系统的设置，还原到日语，该怎么办呢?
         
         */
        let udDic = UserDefaults.standard.dictionaryRepresentation()
        print("udDic = \(udDic)")
        UserDefaults.standard.setValue(["zh-Hans-CN"], forKey: "AppleLanguages")
        print("udDic after = \(UserDefaults.standard.dictionaryRepresentation())")
        UserDefaults.standard.setValue(nil, forKey: "AppleLanguages")// 恢复到系统默认值
        // or: UserDefaults.standard.removeObject(forKey: "AppleLanguages")
        print("udDic final = \(UserDefaults.standard.dictionaryRepresentation())")
        
        // MARK: Bundle
        /**
         all = [NSBundle </private/var/containers/Bundle/Application/F12EDFCC-16AB-426C-8AE7-A0061742CE82/FlyClient.app> (loaded), NSBundle </System/Library/CoreServices/CoreGlyphs.bundle> (not yet loaded)]
         bundleURL = file:///private/var/containers/Bundle/Application/F12EDFCC-16AB-426C-8AE7-A0061742CE82/FlyClient.app/
         resourceURL = Optional(file:///private/var/containers/Bundle/Application/F12EDFCC-16AB-426C-8AE7-A0061742CE82/FlyClient.app/)
         zh-Hans.lproj = Optional("/private/var/containers/Bundle/Application/F12EDFCC-16AB-426C-8AE7-A0061742CE82/FlyClient.app/zh-Hans.lproj")
         zh-Hans.lproj bundle = Optional(NSBundle </var/containers/Bundle/Application/F12EDFCC-16AB-426C-8AE7-A0061742CE82/FlyClient.app/zh-Hans.lproj> (not yet loaded))
         
         
         NSLocalizedString(T##key: String##String, comment: T##String)
         public func NSLocalizedString(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String) -> String
         Bundle.main.localizedString(forKey: T##String, value: T##String?, table: T##String?)
         */
        print("all = \(Bundle.allBundles)")
        print("bundleURL = \(Bundle.main.bundleURL)")
        print("resourceURL = \(Bundle.main.resourceURL)")
        let zhPath = Bundle.main.path(forResource: "zh-Hans", ofType: "lproj")
        print("zh-Hans.lproj = \(zhPath)")
        print("zh-Hans.lproj bundle = \(Bundle.init(path: zhPath ?? ""))")
        
        print(Bundle.ndl_bundleURLSchemes)
        print(Bundle.ndl_bundle(with: BusinessUnitHome.self))
        
        // MARK: Array && ArraySlice
        let originArray = [1, 3, 4]
        let range = 0..<originArray.count
        let rangeArray: ArraySlice<Int> = originArray[range]
        let testArr = Array(rangeArray)
        
        let rangeTest1 = 0...0
        for i in rangeTest1 {
            print(i)
        }
        let rangeTest2 = 0..<0
        for i in rangeTest2 {
            print(i)
        }
        
        // MARK: 内存安全访问
        /**
         https://docs.swift.org/swift-book/LanguageGuide/MemorySafety.html#//apple_ref/doc/uid/TP40014097-CH46-ID567
         重叠访问主要带有 in-out 参数的函数（或方法）以及结构体中带有 mutating 关键字的方法
         
         In-Out 参数的访问冲突
         
         self 的访问冲突
         在结构体中，带有 mutating 关键字的方法调用期间对 self 具有写入权限
         
         属性的访问冲突
         */
        var inoutValue = 88
        testInOut(&inoutValue)// inoutValue: 188
        // 会崩溃: accesses to 0x600003b195d8, but modification requires exclusive access修改需要独占访问
        /**
         globalVar是一个全局变量
         冲突的原因在于 number 和 globalVar 引用的是内存中同一区域，并且同时进行读写访问，因此导致访问冲突。
         */
        // testInOut(&globalVar)
        // 可以采用复制 globalVar 的方式解决该问题
        var tempGlobal = globalVar
        testInOut(&tempGlobal)// globalVar: 200
        
        
        // MARK: deinit
        /**
         先UIViewController deinit->再它里面的view deinit
         */
        
        // MARK:MemoryLayout-内存中的布局
        /**
         汇编中MOV为赋值指令，MOV后面的字母为操作数长度，b（byte）为一个字节
         $代表着字面量，%开头的是CPU的寄存器
         movb $0x2, 0x500f(%rip)这一句汇编代码的意思就是将2这个常量赋值给寄存器%rip中的地址加上0x500f
         
         callq 0x100002700: 就是调用0x100002700所在的函数
         
         callq  *0x78(%rcx)// 将%rcx的值加上0x78，得出一个函数地址值，并且调用这个函数
         
         枚举:
         枚举的内存大小受关联值的影响，也就是说枚举的关联值是存储在枚举内部的:
         以Season枚举为例子:
         枚举值分配的空间是按照最大的枚举值来分配的，Season类型的枚举summer(String,String,String)需要占用49个字节（一个Stirng占16个字节，3 * 16 + 1 = 49）
         所以Season会给所有的枚举值分配49个字节，并在第49个字节存放枚举值。
         由于内存对齐长度为8个字节，系统分配的内存必须为8的倍数。所以系统会分配56个字节给Season类型的枚举值。
         
         结论: 单个枚举所占空间是按照枚举关联值所占字节总和最高的枚举字节数+1个字节的方式来分配的。
         在没有关联值的情况下，枚举在内存中占1个字节且所占内存的大小不受原始值影响。
         关联值会保存在枚举的内存中，影响着枚举所占内存的大小。
         
         类:
         class Animal{
             var age:Int = 0
             var height:Int = 10
             init() {
             }
         }
         var animal = Animal.init()
         size: 8
         stride: 8
         alignment: 8
         无论往Person对象中增加还是减少存储属性，通过MemoryLayout类方法打印出的内存占用都是8个字节，这是因为Animal对象存储在堆中
         animal变量内部保存着Animal对象的内存地址
         MemoryLayout打印的是animal这个变量所占用的内存，所以无论如何打印出来的都是swift指针大小，也就是8个字节
         
         如何查看Animal对象的大小呢?
         通过汇编查看:
         movq %rax, 0x4cd2(%rip) // 赋值
         lldb: register read rax
         得到Animal对象地址值
         
         Animal对象实际占用24个字节，由于堆空间内存对齐的长度为16个字节，意味着Animal对象占用的内存必须为16的倍数，所以系统实际给Animal对象分配了32个字节
         前8个字节是类型信息，第9～16个字节保存的是引用计数
         第17～24个字节保存着age变量
         
         结论: class的对象的前8个字节保存着type的meta data，其中包括了方法的地址
         由于类的实例对象保存在堆空间中，系统需要通过检查引用计数的情况来确定是否需要回收对象（ARC中系统已经帮我们处理堆内存的管理，程序员不需要关心引用计数，但这并不代表引用计数不存在），所以对象中需要留出8个字节保存引用计数情况。类可以被继承，由于面向对象语言的多态特性，在调用类的实例对象方法时，编译器需要动态地获取对象方法所在的函数地址，所以需要留出8个字节保存类的类型信息，比如对象方法的地址就保存在类型信息中。
         所以当类的实例对象在调用对象方法时，性能的开销相比结构体以及枚举调用方法要大，因为多态的存在，系统会先找到该对象的前8个字节（type meta data）加上一个偏移值得到函数的地址，再找到这个函数去调用。
         
         结构体:
         struct Person {
             var age:Int = 10
             var man:Bool = true
             func test() {
                 print("test")
             }
         }
         let per = Person()
         size: 16
         stride: 9
         alignment: 8
         
         由于结构体是值类型，相较于类而言其不能被子类继承，也不需要引用计数来管理其内存的释放。
         所以在存储属性相同的情况下，结构体的内存要比类小。
         结构体由于不能继承，其方法地址在编译的时候就能确定。
         */
        let size = MemoryLayout<TestPoint>.size// 17
        let stride = MemoryLayout<TestPoint>.stride// 24
        let alignment = MemoryLayout<TestPoint>.alignment// 8
        
        // MARK: 悬空指针（Dangling pointer）
        /**
         一个指针所指的内存被释放后，这个指针就被悬空了。
         避免悬空指针？
         基本思路：在释放一块内存时，将指向这块内存的指针变量设置为NULL。访问指针变量前，先判断是否为NULL。
         */
        
        // MARK: 指针UnsafePointer和托管Unmanaged和UnsafeRawPointer
        /**
         unsafe：不安全的，并不是真的不安全，大概是提示开发者少用。
         Write Access：可写入。
         Collection：像一个容器，可添加数据。
         Strideable：指针可使用 advanced 函数移动。
         Typed：是否需要指定类型（范型）。
         
         ===============================start
         C
         Swift
         注解

         const Type *
         UnsafePointer<Type>
         指针可变，指针指向的内存值不可变

         Type *
         UnsafeMutablePointer<Type>
         指针和指针指向的内存值均可变

         ClassType * const *
         UnsafePointer<UnsafePointer<Type>>
         指针的指针：指针不可变，指针指向的类可变

         ClassType **
         UnsafeMutablePointer<UnsafeMutablePointer<Type>>
         指针的指针：指针和指针指向的类均可变

         ClassType **
         AutoreleasingUnsafeMutablePointer<Type>
         作为OC方法中的指针参数

         const void *
         UnsafeRawPointer
         指针指向的内存区，类型未定

         void *
         UnsafeMutableRawPointer
         指针指向的内存区，类型未定

         StructType *
         OpaquePointer
         c语言中的一些自定义类型，Swift中并未有相对应的类型

         int a[]
         UnsafeBufferPointer/UnsafeMutableBufferPointer
         一种数组指针
         ===============================end
         
         但是Swift的&操作和C语言不同的一点是，Swift不允许直接获取对象的指针，比如下面的代码就会编译不通过。
         let a = NSData()
         let b = &a //编译出错
         
         ###内存可能有几种状态：###
         未指定类型未初始化、指定类型未初始化、指定类型已初始化。
         未分配的：没有预留的内存分配给指针
         已分配的：指针指向一个有效的已分配的内存地址，但是值没有被初始化。
         已初始化：指针指向已分配和已初始化的内存地址。
         
         UnsafePointer<T> 是不可变的。当然对应地，它还有一个可变变体，UnsafeMutablePointer<T>
         C 中的指针都会被以这两种类型引入到 Swift 中：C 中 const 修饰的指针对应 UnsafePointer (最常见的应该就是 C 字符串的 const char * 了)
         对于一个 UnsafePointer<T> 类型，我们可以通过 pointee 属性对其进行取值
         如果这个指针是可变的 UnsafeMutablePointer<T> 类型，我们还可以通过 pointee 对它进行赋值
         
         UnsafeMutablePointer:我们如果想要新建一个指针，需要做的是使用 allocate(capacity:) 这个类方法。该方法根据参数 capacity: Int 向系统申请 capacity 个数的对应泛型类型的内存
         
         对于返回值、变量、参数的指针
         const Type *    UnsafePointer<Type>
         Type *    UnsafeMutablePointer<Type>
         对于类对象的指针
         Type * const *    UnsafePointer<Type>
         Type * __strong *    UnsafeMutablePointer<Type>
         
         const void *    UnsafeRawPointer
         void *    UnsafeMutableRawPointer

         Swift 中存在表示一组连续数据指针的 UnsafeBufferPointer<T>
         
         pointee 可理解为解引(dereference)，即用 * 符号获得指针指向内存区域的值
         
         托管: TestPointerViewController.swift
         https://developer.apple.com/library/archive/documentation/CoreFoundation/Conceptual/CFMemoryMgmt/Concepts/Ownership.html
         
         当我们从CF函数中获取到Unmanaged<T>对象的时候，我们需要调用takeRetainedValue或者takeUnretainedValue获取到对象T
         如果一个函数名中包含Create或Copy，则调用者获得这个对象的同时也获得对象所有权，返回值Unmanaged需要调用takeRetainedValue()方法获得对象。调用者不再使用对象时候，Swift代码中不需要调用CFRelease函数放弃对象所有权，这是因为Swift仅支持ARC内存管理
         如果一个函数名中包含Get，则调用者获得这个对象的同时不会获得对象所有权，返回值Unmanaged需要调用takeUnretainedValue()方法获得对象
         
         苹果的一些底层框架返回的对象有的是自动管理内存的（annotated APIs），有的是不自动管理内存
         对于Core Fundation中有@annotated注释的函数来说，返回的是托管对象，无需自己管理内存，可以直接获取到CF对象，并且可以无缝转化(toll free bridging)成Fundation对象，比如NSString和CFString
         对于尚未注释的函数来说，苹果给出的是使用非托管对象Unmanaged<T>进行管理的过渡方案。
         当我们从CF函数中获取到Unmanaged<T>对象的时候，我们需要调用takeRetainedValue或者takeUnretainedValue获取到对象T
         1.如果一个函数名中包含Create或Copy，则调用者获得这个对象的同时也获得对象所有权，返回值Unmanaged需要调用takeRetainedValue()方法获得对象。调用者不再使用对象时候，Swift代码中不需要调用CFRelease函数放弃对象所有权，这是因为Swift仅支持ARC内存管理
         2.如果一个函数名中包含Get，则调用者获得这个对象的同时不会获得对象所有权，返回值Unmanaged需要调用takeUnretainedValue()方法获得对象。
         */
        
        var aa = 10
        // 这里和 C 的指针使用类似，我们通过在变量名前面加上 & 符号就可以将指向这个变量的指针传递到接受指针作为参数的方法中去
        incrementor(ptr: &aa)
        print("aa = \(aa)")// 11
        
        print("===takeIntPointer===")
        var aa1 = 11
        takeIntPointer(&aa1)// 11
        let intArray = [1, 2]
        // [Type]数组类型值，将数组起始地址传入函数
        takeIntPointer(intArray)// 1
        //takeIntPointer(&intArray)// 报错：
        
        print("===takeRawPointer===")
        //takeRawPointer(&1)// 报错：Cannot pass immutable value as inout argument: literals are not mutable
        var x: Int = 16, y: Float = 12.8
        takeRawPointer(&x)
        takeRawPointer(&y)
        takeRawPointer([1, 2])
        
        print("===takeIntMutPointer===")
        //let x1 = 26// 报错: Cannot pass immutable value as inout argument: 'x1' is a 'let' constant
        var x1 = 26
        var arr11 = [2, 8]// 必须用var
        takeIntMutPointer(&x1)// 27
        takeIntMutPointer(&arr11)// 3
        
        print("===takeIntMutPointer===")
        var x2 = 28
        var arr22 = [2, 9]
        takeRawMutPointer(&x2)
        takeRawMutPointer(&arr22)
        
        // MARK: AutoreleasingUnsafeMutablePointer 自动释放指针
        
        // 与这种做法类似的是使用 Swift 的 inout 关键字。我们在将变量传入 inout 参数的函数时，同样也使用 & 符号表示地址。不过区别是在函数体内部我们不需要处理指针类型，而是可以对参数直接进行操作
        incrementor1(num: &aa)
        print("aa = \(aa)")// 12
        
        // ===指针初始化和内存管理===
        var intPtr = UnsafeMutablePointer<Int>.allocate(capacity: 1)
        // 内存进行了分配，并且值已经被初始化. 这种状态下的指针是可以保证正常使用的
        intPtr.initialize(to: 10)// 在完成初始化后，我们就可以通过 pointee 来操作指针指向的内存值了
        intPtr.pointee = 11
        print(intPtr, intPtr.pointee)// 地址， 11
        
        // 注意其实在这里对于 Int 这样的在 C 中映射为 int 的 “平凡值” 来说，deinitialize 并不是必要的，因为这些值被分配在常量段上。但是对于像类的对象或者结构体实例来说，如果不保证初始化和摧毁配对的话，是会出现内存泄露的。所以没有特殊考虑的话，不论内存中到底是什么，保证 initialize: 和 deinitialize 配对会是一个好习惯。
        let rawPtr: UnsafeMutableRawPointer = intPtr.deinitialize(count: 1)
        print(intPtr, intPtr.pointee, rawPtr)
        intPtr.deallocate()
        
        print("\(Int.max)")
        
        // ======
        let intPointer = UnsafeMutablePointer<Int>.allocate(capacity: 4)
        for i in 0..<4 {
            (intPointer + i).initialize(to: i)
        }
        print(intPointer.pointee)
        intPointer.deallocate()
        
        // ======
        // 未分配的指针用allocate方法分配一定的内存空间。
        let uint8Pointer = UnsafeMutablePointer<UInt8>.allocate(capacity: 8)
        // 分配完内存空间的指针用各种init方法来绑定一个值或一系列值。初始化时，必须保证指针是未初始化的。
        uint8Pointer.initialize(repeating: 20, count: 4)
        print(uint8Pointer[0], uint8Pointer[3], uint8Pointer[4])  // 20, 20, 0
        // 修改值
        uint8Pointer[0] = 10
        uint8Pointer[4] = 30
        print(uint8Pointer[0], uint8Pointer[3], uint8Pointer[4])  // 10, 20, 30
        // 回到初始化值之前，没有释放指针指向的内存，指针依旧指向之前的值。
        uint8Pointer.deinitialize(count: 8)
        print(uint8Pointer[0], uint8Pointer[3], uint8Pointer[4]) // 10, 20, 30
        // 在释放指针内存之前，必须要保证指针是未初始化的
        uint8Pointer.deallocate()
        delay(by: 3.0) {
            print("===3.0===")
            print(uint8Pointer[0], uint8Pointer[3], uint8Pointer[4]) // 可能是任何值，已经销毁了
        }
        
        var structPointers = UnsafeMutablePointer<Point>.allocate(capacity: 3)
        var ppp = Point(x: 20.9, y: 39.8)
        structPointers[1] = ppp// ###不推荐，它不适用指针指向一个类，或某些特定的结构体和枚举的情况###
        // 从安全的角度来讲，最受欢迎的初始化手段是使用 initialize 分配完成内存后，直接设置变量的初始值
        structPointers.initialize(repeating: Point(x: 100.9, y: 100.8), count: 1)
        print(structPointers[0], structPointers[1], structPointers[2], structPointers, structPointers.advanced(by: 1))
        structPointers.deinitialize(count: 3)
        structPointers.deallocate()
        
        // MARK: ===UnsafeRawPointer&&UnsafeMutableRawPointer===
        /**
         如果要类型化，必须将内存绑定到一个类型上
         
         UnsafeMutableRawBufferPointer 实例可以写入内存
         */
        testRawPointer()
        testTypePointer()
        tranRawToTypePointer()
        getInstByte()
        
        // UnsafeRawPointer只能由其他指针用init方法得到，与UnsafePointer类似，没有allocate静态方法
        var uint64: UInt64 = 257// 257  = 1 0000 0001
        let rawPointer = UnsafeRawPointer(UnsafeMutablePointer(&uint64))
        let int64PointerT =  rawPointer.load(as: Int64.self)
        let uint8Point = rawPointer.load(as: UInt8.self)// 而UInt8 表示存储8个位的无符号整数，即一个字节大小
        print(int64PointerT) // 257
        print(uint8Point) // 1
        
        let pointer = UnsafeMutableRawBufferPointer.allocate(byteCount: 3, alignment: MemoryLayout<Int>.alignment)
        pointer.copyBytes(from: [7, 2, 3])
        pointer.forEach {
            print($0) // 1, 2, 3
        }



        
        // MARK: ===UnsafeMutablePointer && UnsafePointer===
        /**
         
         UnsafeMutablePointer<Int>.allocate(capacity: <#T##Int#>)
         
         UnsafePointer中的pointee属性只能get不能set。
         UnsafePointer中没有allocate方法。
         */
        
        // MARK: 将指针引用的内存作为不同的类型访问
        /**
         withMemoryRebound:
         将内存临时重新绑定到其他类型
         
         MemoryLayout<Int>.stride// 8
         MemoryLayout<Int8>.stride// 1
         
         bindMemory:
         该方法绑定内存为指定类型并返回一个UnsafeMutablePointer<指定类型>的指针，用到了指向内存的原始指针。
         */
        // 类型占用内存小->大不能显示123打印的显示140734414027899（一个很大的数）
        var int8: Int8 = 123
        withUnsafePointer(to: &int8) { (innerPointer) -> Void in
            // innerPointer: UnsafePointer<Int8>
            
            innerPointer.withMemoryRebound(to: Int.self, capacity: 1) { (pointer2) -> Void in
                print("pointer2.pointee = \(pointer2.pointee)")// 140734414027899
            }
        }
        
        // 类型占用内存大->小能显示打印的86
        var intV: Int = 86
        withUnsafePointer(to: &intV) { (innerPointer) -> Void in
            // innerPointer: UnsafePointer<Int>
            
            innerPointer.withMemoryRebound(to: Int8.self, capacity: MemoryLayout<Int>.size / MemoryLayout<Int8>.size) { (pointer2) -> Void in
                print("pointer2.pointee = \(pointer2.pointee) next = \(pointer2.advanced(by: 1).pointee)")// 86, 0
            }
        }
        
        
        let aaa = 107
        let aaaObj = aaa as AnyObject// NSNumber
        print("aaa地址为: \(Unmanaged<AnyObject>.passUnretained(aaaObj).toOpaque())")// 0xfbc9287c2474b9a5
        
        var string111 = "hello" // 5个字符 'h' 'e' 'l' 'l' 'o' 每个字符占一个字节
        var strdata = string111.data(using: .ascii)
        strdata?.withUnsafeBytes({ (ptr: UnsafePointer<Int8>) in
            print(ptr.pointee) // 104 = 'h'
        })
        
        let ff = Point(x: 23.9, y: 76.7)
    
        // 模拟器
        #if arch(i386) || arch(x86_64)

        #endif
        
        
        // MARK: ===指向数组的指针===UnsafeBufferPointer&&UnsafeMutableBufferPointer===
        /**
         在 Swift 中将一个数组作为参数传递到 C API 时，Swift 已经帮助我们完成了转换
         
         public func vDSP_vadd(_ __A: UnsafePointer<Float>, _ __IA: vDSP_Stride, _ __B: UnsafePointer<Float>, _ __IB: vDSP_Stride, _ __C: UnsafeMutablePointer<Float>, _ __IC: vDSP_Stride, _ __N: vDSP_Length)
         
         UnsafeBufferPointer
         UnsafeMutableBufferPointer
         UnsafeRawBufferPointer
         UnsafeMutableRawBufferPointer
         
         实现了Collection，因此可以直接使用Collection中的各种方法来遍历操作数据
         这个UnsafeBufferPointer是常量，它只能获取到数据，不能通过这个指针去修改数据。与之对应的是UnsafeMutableBufferPointer指针。
         
         对于一般的接受 const 数组的 C API，其要求的类型为 UnsafePointer，
         而非 const 的数组则对应 UnsafeMutablePointer。
         使用时，对于 const 的参数，我们直接将 Swift 数组传入 (上例中的 a 和 b)；而对于可变的数组，在前面加上 & 后传入即可
         
         对于传参，Swift 进行了简化，使用起来非常方便。
         但是如果我们想要使用指针来像之前用 pointee 的方式直接操作数组的话，就需要借助一个特殊的类型：UnsafeMutableBufferPointer
         Buffer Pointer 是一段连续的内存的指针，通常用来表达像是数组或者字典这样的集合类型
         */
        let a: [Float] = [1, 2, 3, 4]
        let b: [Float] = [0.5, 0.25, 0.125, 0.0625]
        var result: [Float] = [0, 0, 0, 0]
        vDSP_vadd(a, 1, b, 1, &result, 1, 4)// // result now contains [1.5, 2.25, 3.125, 4.0625]

        var array = [1, 2, 3, 4, 5]
        var arrayPtr = UnsafeMutableBufferPointer<Int>(start: &array, count: array.count)// baseAddress 是第一个元素的指针，类型为 UnsafeMutablePointer<Int>
        if let basePtr: UnsafeMutablePointer<Int> = arrayPtr.baseAddress {
            print(basePtr.pointee)  // 1
            basePtr.pointee = 10
            print(basePtr.pointee) // 10, array数组的第一个元素也为10了
            
            //下一个元素
            let nextPtr = basePtr.successor()
            print(nextPtr.pointee) // 2
        }
        
        array.withUnsafeBufferPointer { bufferPointer in
            bufferPointer.forEach {
                print($0)
            }
        }
        
        let p111 = UnsafeMutablePointer<Int>.allocate(capacity: 5)
        let buf111 = UnsafeMutableBufferPointer<Int>.init(start: p111, count: 5)
        print(buf111.count)
        
        // MARK: ==Memory Access==指针操作和转换==
        /**
         要通过类型化操作访问底层内存，必须将内存绑定到一个简单的类型
         
         在 Swift 中不能像 C 里那样使用 & 符号直接获取地址来进行操作
         ===如果我们想对某个变量进行指针操作===，我们可以借助 withUnsafePointer 或 withUnsafeMutablePointer 这两个辅助方法
         这两个方法接受两个参数，第一个是 inout 的任意类型，第二个是一个闭包
         Swift 会将第一个输入转换为指针，然后将这个转换后的 Unsafe 的指针作为参数，去调用闭包。withUnsafePointer 或 withUnsafeMutablePointer 的差别是前者转化后的指针不可变，后者转化后的指针可变
         */
        var test = 10
        test = withUnsafeMutablePointer(to: &test, { (ptr: UnsafeMutablePointer<Int>) -> Int in
            print("address =", ptr)
            ptr.pointee += 1
            return ptr.pointee
        })
        print("test = \(test)")// 11
        
        var sss = 8
        sss = withUnsafePointer(to: &sss) { ptr in
            return ptr.pointee + 2
            // 此时, 会新开辟空间, 令sss指向新地址, 值为2,
        }
        print(sss)// 10
        
        // MARK: unsafeBitCast
        /**
         unsafeBitCast 是非常危险的操作，它会将一个指针指向的内存强制按位转换为目标的类型
         因为这种转换是在 Swift 的类型管理之外进行的，因此编译器无法确保得到的类型是否确实正确，你必须明确地知道你在做什么
         
         因为 NSArray 是可以存放任意 NSObject 对象的，当我们在使用 CFArrayGetValueAtIndex 从中取值的时候，得到的结果将是一个 UnsafePointer<Void>。由于我们很明白其中存放的是 String 对象，因此可以直接将其强制转换为 CFString
         
         关于 unsafeBitCast 一种更常见的使用场景是不同类型的指针之间进行转换。因为指针本身所占用的的大小是一定的，所以指针的类型进行转换是不会出什么致命问题的。这在与一些 C API 协作时会很常见。比如有很多 C API 要求的输入是 void *，对应到 Swift 中为 UnsafePointer<Void>。我们可以通过下面这样的方式将任意指针转换为 UnsafePointer。
         */
        let nsarray = NSArray(object: "meow")
        let array2str = unsafeBitCast(CFArrayGetValueAtIndex(nsarray, 0), to: CFString.self)// “meow”
        
        var count111 = 100
        // UnsafePointer<Void> has been replaced by UnsafeRawPointer
        let voidPtr = withUnsafePointer(to: &count111, { (a: UnsafePointer<Int>) -> UnsafePointer<Void> in
            return unsafeBitCast(a, to: UnsafePointer<Void>.self)
        })
        // voidPtr 是 UnsafePointer<Void>。相当于 C 中的 void *

        // 转换回 UnsafePointer<Int>
        let intPtr111 = unsafeBitCast(voidPtr, to: UnsafePointer<Int>.self)
        intPtr111.pointee //100
        
        // MARK: swift && c
        // withUnsafeMutablePointer方法可以将Swift对象ViewController转换为UnsafeMutablePointer<ViewController>类型，这样才可以当做参数传入C函数
        var blockSelf = self
        let appDelegatePointer: UnsafeMutablePointer<AppDelegate> = withUnsafeMutablePointer(to: &blockSelf) {
            return $0
        }
        
        // Context(info: <#T##UnsafeMutableRawPointer!#>, retain: <#T##((UnsafeRawPointer?) -> UnsafeRawPointer?)!##((UnsafeRawPointer?) -> UnsafeRawPointer?)!##(UnsafeRawPointer?) -> UnsafeRawPointer?#>)
        var context = Context(info: appDelegatePointer, retain: nil)
        abcPrint(&context) { (mutRawPointer) in
            // C函数的回调函数中，传出来一个UnsafeMutableRawPointer对象的指针，展示了3种方式，可以将这个指针转换为AppDelegate对象。
            let controller1 = mutRawPointer?.assumingMemoryBound(to: AppDelegate.self).pointee
            print("controller1: \(String(describing: controller1))")
            
            let controller2 = mutRawPointer?.bindMemory(to: AppDelegate.self, capacity: 1).pointee
            print("controller2: \(String(describing: controller2))")
            
            let controller3 = mutRawPointer?.load(as: AppDelegate.self)
            print("controller3: \(String(describing: controller3))")
        }
        
        // MARK: 可变 不可变
        // 当一个函数需要传入不可变指针时，可变指针可以直接传入。
        // 而当一个函数需要可变指针时，可以使用init(mutating other: UnsafePointer<Pointee>)方法转换
        // UnsafeMutablePointer<Int>.init(mutating: <#T##UnsafePointer<Int>#>)
        
        
        // MARK: 函数指针
        /**
         在C中有回调函数，当swift要调用C中这类函数时，可以使用函数指针。

         swift中可以用@convention 修饰一个闭包，

         @convention(swift) : 表明这个是一个swift的闭包
         @convention(block) ：表明这个是一个兼容oc的block的闭包，可以传入OC的方法。
         @convention(c) : 表明这个是兼容c的函数指针的闭包，可以传入C的方法。
         
         C中的方法int (*)(void) 在swift中就是@convention(c) () -> Int32
         在调用C函数需要传入函数指针时，swift可以传入闭包的字面量或者nil，也可以直接传入一个闭包。
         */
        // public struct CFArrayCallBacks
        // public typealias CFArrayRetainCallBack = @convention(c) (CFAllocator?, UnsafeRawPointer?) -> UnsafeRawPointer?
        // public typealias CFArrayReleaseCallBack = @convention(c) (CFAllocator?, UnsafeRawPointer?) -> Void
        // public typealias CFArrayCopyDescriptionCallBack = @convention(c) (UnsafeRawPointer?) -> Unmanaged<CFString>?
        // public typealias CFArrayEqualCallBack = @convention(c) (UnsafeRawPointer?, UnsafeRawPointer?) -> DarwinBoolean
        var callbacks = CFArrayCallBacks(version: 0, retain: nil, release: nil, copyDescription: arrayCopyDescriptionCallBack, equal: { (p1, p2) -> DarwinBoolean in
            return DarwinBoolean(true)
        })
        // callbacks: UnsafePointer<CFArrayCallBacks>
        var cfMutableArray = CFArrayCreateMutable(nil, 0, &callbacks)
        
        
        
        // MARK: ==="@"===
        /**
         @IBOutlet
         如果你用@IBOutlet属性标记一个属性，那么Interface Builder（IB）将识别那个变量，并且你将能够通过提供的“outlet”机制将你的源代码与你的XIB或者Storyboard连接起来
         
         @IBAction
         @IBAction同样是连接代码和Interface Builder的桥梁，只不过@IBAction连接的是func函数，而不是属性。被标记的方法将直接接收由用户界面触发的事件。
         
         @IBInspectable
         我们经常用Interface Builder的属性编辑面板对控件的属性进行设置，但是还有一些属性并没有暴露在Interface Builder的设置面板中。用@IBInspectable标记一个NSCodable的属性将会使它可以很容易地在Interface Builder的属性面板编辑器中进行编辑
         
         @IBDesignable
         当给一个UIView的子类应用@IBDesignable时，这个类就可以显示在Interface Builder中，使我们的代码变得“所见即所写”，我们对代码的修改也可以实时的反馈在Interface Builder中。
         
         @UIApplicationMain
         这个属性使被标记的类作为本应用的代理。通常来说，这个代理类都是系统自动创建的AppDelegate.swift文件。
         
         @available
         通过@available使得被标记的方法或属性适用于不同的平台或系统版本。
         @available(swift 4.1)
         @available(iOS 11, *)
         
         @objcMembers
         通常在项目中如果想把Swift写的API暴露给Objective-C调用，需要增加@objc。这个@objcMembers是一个便捷方法来标记一个类的全部方法都加上@objc。不过这个属性会引起性能问题。
         
         @escaping

         如果你希望被标记的值可以存储起来以便后续代码继续使用，你可以将闭包的参数标记为@escaping，换句话说，被标记的值的可以超越原来的生命周期范围，被外界调用。
         
         @discardableResult
         默认情况下，如果调用一个函数，但函数的返回值并未使用，那么编译器会发出警告。你可以通过给func使用@discardableResult来抑制警告。
         
         @autoclosure
         如果一个func有一个闭包参数，这个闭包参数没有形参但有返回类型。@autoclosure可以神奇地把这样的func转换成有一个参数且这个参数的类型就是闭包的返回值类型的func。这样的好处是在调用这个带闭包的func时，传的实参不用非得是闭包类型，只要是闭包返回值类型的就可以了，@autoclosure会自动把这个值转换成闭包类型。
         
         @objc: TestClass.swift
         这个属性就是关联Swift对象和OC对象的桥梁。你还可以通过@objc提供一个标识符，这个标识符就是对应到OC中的类或方法。
         
         @nonobjc
         使用这个属性来禁止隐式添加@objc属性。@nonobjc告诉编译器当前声明的内容不能在OC中使用
         
         @convention特性是在 Swift 2.0 中引入的，用于修饰函数类型，它指出了函数调用的约定
         @convention(swift) : 表明这个是一个swift的闭包
         @convention(block) ：表明这个是一个兼容oc的block的闭包
         @convention(c) : 表明这个是兼容c的函数指针的闭包。

         它用来修饰func，而且它还带有一个参数，这个参数的取值一般是：swift、c、block。被修饰的func可以用来匹配其他语言平台的函数指针类型的形参
         1. 当调用C函数的时候，可以传入被@convention(c)修饰的swift函数，来匹配C函数形参中的函数指针。
         2. 当调用OC方法的时候，可以传入被@convention(block)修饰的swift函数，来匹配OC方法形参中的block参数。
         
         CGFloat myCFunc(CGFloat (callback)(CGFloat x, CGFloat y)) {
            return callback(1.1, 2.2)
         }
         
         let swiftCallback: @convention(c) (CGFloat, CGFloat) -> CGFloat = {
            (x, y) -> CGFloat in
            return x + y
         }
         
         let result = myCFunc( swiftCallback )// 3.3
         */
        
        
        // MARK: String
        /**
         NSString对象使用UTF-16编码
         
         endIndex是最后一个元素后边的那个元素，因此不能直接访问，否则会崩溃。
         不同的字符可能需要不同数量的内存来存储，因此为了确定哪个Character位于特定位置，您必须从每个Unicode标量的开始或结尾处遍历String。因此，Swift字符串不能用整数值索引。(不能用整数下标随机访问)
         
         Swift标准库只支持的三种下标访问String字符串的方法:
         Range<String.Index>：元素为String.Index类型的Range（开区间）
         String.Index：String.Index元素
         ClosedRange<String.Index>：元素为String.Index类型的CloseRange（闭区间）
         
         Swift的String类型是基于Unicode标量建立的，先来介绍一下Unicode和Unicode标量
         人类使用的文字和符号要想被计算机所理解必须要经过编码，Unicode就是其中的一种编码标准。
         码点：Unicode标准为世界上几乎所有的书写系统里所使用的每一个字符或符号定义了一个唯一的数字。这个数字叫做码点（code points），以U+xxxx这样的格式写成，格式里的xxxx代表四到六个十六进制的数。例如U+0061表示小写的拉丁字母(LATIN SMALL LETTER A)("a")，U+1F425表示小鸡表情(FRONT-FACING BABY CHICK) ("🐥")

         编码格式：通过字符到码点之间的映射，人们得以用统一的方式表示符号，但还需要定义另一种编码来确定码点与其存储在内存和硬盘中的值的对应关系。有三种Unicode支持的编码格式：

         UTF-8：表示一个码点需要1～4个八位的码元。利用字符串的utf8属性进行访问。
         UTF-16：用一或两个16位的码元表示一个吗点。利用字符串的utf16属性进行访问。
         21位的 Unicode 标量值集合，也就是字符串的UTF-32编码格式，用21位的码元表示一个码点。利用字符串的unicodeScalars属性进行访问。
         
         如“é”, “김”, and “🇮🇳”是作为独立的character存在的，这些独立的character可能是由多个Unicode码点组成的。
         */
        let testStr = "abc123"
        print("start = \(testStr[testStr.startIndex])")// a
        let endIndex = testStr.index(before: testStr.endIndex)// 最后一个元素
        let endValue: Character = testStr[endIndex]
        print("endValue = \(endValue)")
//        print("end = \(testStr[testStr.endIndex])")// Fatal error: String index is out of bounds
        
        let string = "e\u{301}" // é
        let charFromNSString = (string as NSString).character(at: 0)  //101 说明此方法的索引对象是字符串对应的UTF-16码元。所以返回了索引为0的码元，即101.对于这种情况OC中有专门的字符串正规化处理办法，也可以判断一个字符的码元长度
        let charFromString = string[string.startIndex]  //é
        
        let enclosedEAcute: Character = "\u{E9}\u{20DD}"
        // enclosedEAcute 是 é⃝
        let regionalIndicatorForUS: Character = "\u{1F1FA}\u{1F1F8}"
        // regionalIndicatorForUS 是 🇺🇸
        print("enclosedEAcute = \(enclosedEAcute) regionalIndicatorForUS = \(regionalIndicatorForUS)")
        
        
        // ========================================
        // 数组map
//        var arr1 : [Int] = [1, 2, 3] // print: ==1== ==2== ==3==
        // 可选类型map
        var arr1 : [Int]? = [1, 2, 3]// print: ==[1, 2, 3]==
        arr1.map {
            print("==\($0)==")
        }

        // ========================================
        // 可选类型
        let num: Int? = 1
        switch num {
        case .none:
            print("nil")
        case .some(let intNum):
            print("intNum = \(intNum)")
        }
        
        // ========================================
        // 会创建多个线程
        DispatchQueue.global().async {
            print("1.\(Thread.current)")
        }
        
        DispatchQueue.global().async {
            print("2.\(Thread.current)")
        }
        
        DispatchQueue.global().async {
            print("3.\(Thread.current)")
        }
        
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        UserDefaults.standard.set("100", forKey: "StringKey")
    }
    
    // 原生(Raw)指针
    func testRawPointer() {
        let count = 2
        let stride = MemoryLayout<Int>.stride
        let aligment = MemoryLayout<Int>.alignment
        let byteCount = stride * count
        
        // 创建分配所需字节数
        let pointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: aligment)

        defer {
            pointer.deallocate()
        }
        // MARK: rawPointer 使用 storeBytes 和 load 方法存储和读取字节
        // advanced: 移动指针地址
        pointer.storeBytes(of: 42, as: Int.self)
        pointer.advanced(by: stride).storeBytes(of: 6, as: Int.self)
        // 也可以直接使用 + 运算符：
        // (pointer + stride).storeBytes(of: 6, as: Int.self)
        let val = pointer.load(as: Int.self)// 42
        let val1 = pointer.advanced(by: stride).load(as: Int.self)// 6
        
        
        let bufferPointer = UnsafeRawBufferPointer(start: pointer, count: byteCount)
        for (index, byte) in bufferPointer.enumerated() {
            print("bute \(index): \(byte)")
        }
    }
    
    // 类型指针
    func testTypePointer() {
        let count = 2
        let stride = MemoryLayout<Int>.stride
        let aligment = MemoryLayout<Int>.alignment
        let byteCount = stride * count
        
        // 类型指针，在分配内存的时候通过给范型赋值来指定当前指针所操作的数据类型
        // 因为通过给范型参数赋值，已经知道了要存储的数据类型，其alignment和stride就确定了，这时只需要再知道存储几个数据即可。
        let pointer = UnsafeMutablePointer<Int>.allocate(capacity: count)
        pointer.initialize(repeating: 0, count: count)

        defer {
            pointer.deinitialize(count: count)
            pointer.deallocate()
        }

        pointer.pointee = 42
        // advanced: 这里是按类型值的个数进行移动
        pointer.advanced(by: 1).pointee = 6
        // 这里也可以使用运算符 + 进行移动：
//        (pointer + 1).pointee = 6
        print(pointer.pointee)// 42
        let val = pointer.advanced(by: 1).pointee// 6
        
        let bufferPointer = UnsafeBufferPointer(start: pointer, count: count)
        for (index, value) in bufferPointer.enumerated() {
            print("value \(index): \(value)")
        }
    }
    
    // 原生指针转换为类型指针
    func tranRawToTypePointer() {
        let count = 2
        let stride = MemoryLayout<Int>.stride
        let aligment = MemoryLayout<Int>.alignment
        let byteCount = stride * count
        
        // 创建原生指针
        let rawPointer = UnsafeMutableRawPointer.allocate(byteCount: byteCount, alignment: aligment)
        // 延迟释放原生指针的内存
        defer {
            rawPointer.deallocate()
        }
        
        // 将原生指针绑定类型: 原生指针转换为类型指针，是通过调用内存绑定到特定的类型来完成的
        // The number of bytes in this region is `count * MemoryLayout<T>.stride`.
        // Returns: A typed pointer to the newly bound memory
        let typePointer: UnsafeMutablePointer<Int> = rawPointer.bindMemory(to: Int.self, capacity: count)
        
        typePointer.initialize(repeating: 0, count: count)
        defer {
            typePointer.deinitialize(count: count)
        }
        
        typePointer.pointee = 42
        typePointer.advanced(by: 1).pointee = 9
        print(typePointer.pointee)// 42
        let val = typePointer.advanced(by: 1).pointee// 9
        
        let bufferPointer = UnsafeBufferPointer(start: typePointer, count: count)
        for (index, value) in bufferPointer.enumerated() {
            print("value \(index): \(value)")
        }
        
    }
    
    // 获取一个实例的字节
    func getInstByte() {
        var sample = Sample(number: 25, flag: true)
        
        print("==getInstByte==")
        // 该方法和回调闭包都有返回值，如果闭包有返回值，此返回值将会作为该方法的返回值.但是，一定不要在闭包中将body的参数，即：UnsafeRawBufferPointer 类型的指针作为返回值返回，该参数的使用范围仅限当前闭包，该参数的使用范围仅限当前闭包，该参数的使用范围仅限当前闭包。
        withUnsafeBytes(of: &sample) { (rs) in
            for bute in rs {
                print(bute)
            }
        }
        
    }
    
    // MARK: （rawPointer: bindMemory && assumingMemoryBound  他们的返回值都是UnsafeMutablePointer<T>） && typePointer: withMemoryRebound
    /**
     bindMemory:
     Use the bindMemory(to:capacity:) method to bind the memory referenced by this pointer to the type T. The memory must be uninitialized or initialized to a type that is layout compatible with T. If the memory is uninitialized, it is still uninitialized after being bound to T.
     
     Warning:
     A memory location may only be bound to one type at a time. The behavior of accessing memory as a type unrelated to its bound type is undefined.
     
     let count = 4
     let bytesPointer = UnsafeMutableRawPointer.allocate(
             bytes: 100,
             alignedTo: MemoryLayout<Int8>.alignment)
     let int8Pointer = bytesPointer.bindMemory(to: Int8.self, capacity: count)
     
     After calling bindMemory(to:capacity:), the first four bytes of the memory referenced by bytesPointer are bound to the Int8 type, though they remain uninitialized. The remainder of the allocated region is unbound raw memory. All 100 bytes of memory must eventually be deallocated.
     
     Parameters:
     type
     The type T to bind the memory to.
     count
     The amount of memory to bind to type T, counted as instances of T.
     
     Returns:
     A typed pointer to the newly bound memory. The memory in this region is bound to T, but has not been modified in any other way. The number of bytes in this region is count * MemoryLayout<T>.stride.
     
     
     withMemoryRebound：
     Use this method when you have a pointer to memory bound to one type and you need to access that memory as instances of another type. Accessing memory as a type T requires that the memory be bound to that type. A memory location may only be bound to one type at a time, so accessing the same memory as an unrelated type without first rebinding the memory is undefined.
     If `body` has a return value, that value is also used as the return value for the `withMemoryRebound(to:capacity:_:)` method.
     The region of memory starting at this pointer and covering count instances of the pointer’s Pointee type must be initialized.
     
     Because this pointer’s memory is no longer bound to its Pointee type while the body closure executes, do not access memory using the original pointer from within body. Instead, use the body closure’s pointer argument to access the values in memory as instances of type T.
     
     Note：
     Only use this method to rebind the pointer’s memory to a type with the same size and stride as the currently bound Pointee type. To bind a region of memory to a type that is a different size, convert the pointer to a raw pointer and use the bindMemory(to:capacity:) method.
     
     Parameters:
     type
     The type to temporarily bind the memory referenced by this pointer. The type T must be the same size and be layout compatible with the pointer’s Pointee type.
     count
     The number of instances of Pointee to bind to type.
     body
     A closure that takes a typed pointer to the same memory as this pointer, only bound to type T. The closure’s pointer argument is valid only for the duration of the closure’s execution. If body has a return value, that value is also used as the return value for the withMemoryRebound(to:capacity:_:) method.
     Returns:
     The return value, if any, of the body closure parameter.
     
     assumingMemoryBound:
     Returns a typed pointer to the memory referenced by this pointer, assuming that the memory is already bound to the specified type.
     
     Use this method when you have a raw pointer to memory that has already been bound to the specified type. The memory starting at this pointer must be bound to the type T. Accessing memory through the returned pointer is undefined if the memory has not been bound to T. To bind memory to T, use bindMemory(to:capacity:) instead of this method.
     
     Parameters:
     to
     The type T that the memory has already been bound to.

     Returns:
     A typed pointer to the same memory as this raw pointer.
     */


}

// MARK: 闭包(Closure)
/**
 闭包有三种形式:
 全局函数，有名字的闭包并且不捕获任何值(定义的一般函数)
 嵌套函数，有名字的闭包，可以在闭包所在函数内部捕获值(函数里嵌套函数)
 闭包表达式，没有名字的闭包，使用简洁的语法，可以在包裹闭包的上下文捕获值(闭包)

 //Global function
 func block() {
     print("block")    //block
 }
 
 //Nested function
 func block(){
     let name = "block"
     func printStr() {
         print(name)
     }
     printStr()
 }
 block()    //block
 
 //Closure expression
 let block = {
     print("block")
 }
 block()    //block
 
 
 func makeIncrementer(from start: Int, amount: Int) -> ()->Int {
     var number = start
     return {
         number += amount
         return number
     }
 }
 let incrementer = makeIncrementer(from: 0, amount: 1)
 incrementer()  //1
 incrementer()  //2
 incrementer()  //3
 每次调用incrementer()都会执行闭包里面的操作，而闭包的上下文就是makeIncrementer函数
 
 //block
 NSInteger number = 1;
 NSMutableString *str = [NSMutableString stringWithString: @"hello"];
 void(^block)() = ^{
   NSLog(@"%@--%ld", str, number);
 };
 [str appendString: @" world!"];
 number = 5;
 block();    //hello world!--1
 
 //closure
 var str = "hello"
 var number = 1
 let block = {
     print(str + "--" + " \(number)")
 }
 str.append(" world!")
 number = 5
 block()    //hello world!--5
 
 逃逸闭包，指的是当一个函数有闭包作为参数，但是闭包的执行比函数的执行要迟
 这个闭包的作用域本来是在当前函数里面的，然后它要逃出这个作用域，不想和函数同归于尽
 那么闭包怎么逃逸呢？最简单的方法是把闭包赋值给外面的变量
 
 如果逃逸闭包访问的是类里面的成员，必须带上self来访问
 
 自动闭包作为函数参数，不写"{}"，直接写返回值
 */

// MARK: ---MJ---
// MARK: swift
/**
 2014.6月发布的
 2019.6 swift 5.1
 
 swift5.1  Xcode11  macos10.14
 
 OC的编译器前端是Clang，编译器后端是LLVM
 Swift的编译器前端是swiftc，编译器后端是LLVM
 编译器前端：词法分析
 编译器后端：LLVM 生成对应平台的二进制代码
 
 想运行在ios系统，最终生成的是ARM架构的代码
 
 生成swift语法树
 swiftc -dump-ast main.swift
 生成最简洁的sil代码
 swiftc -emit-sil main.swift
 生成LLVM IR代码
 swiftc -emit-ir main.swift -o main.ll
 生成汇编代码
 swift -emit-assembly main.swift -o main.s
 
 对汇编代码进行分析，能真正掌握编程语言的本质
 
 import PlaygroundSupport
 PlaygroundPage.current.liveView = view
 
 // 元祖
 let tuple1 = (404, "Not Found")
 let tuple2 = (code: 404, msg: "Not Found")
 let (statusCode, statusMsg) = tuple1
 let (statusCode, _) = tuple1
 print(statusCode)
 
 if 后面的条件只能是bool类型，不像oc里面 非0的就是true
 
 // 不加var默认是let
 for var i in 0...3 {
 i+=5
 print(i)
 }
 
 区间运算符用在数组上,names是个数组
 for name in names[0...3] {
 
 }
 
 区间类型
 ClosedRange: 1...3
 Range: 1..<3
 PartialRangeThrough: ...5
 
 带间隔的区间值
 let hours = 11
 let hourInterval = 2
 从4开始，累加2，不s超过11
 for tickMark in stride(from: 4, through: hours, by: hourInterval) {
 // 4,6,8,10
 }
 
 ASCII
 "\0"..."~"
 
 swicth默认可以不写break，并不会贯穿到后面
 fallthrough实现贯穿效果
 如果使用了fallthrough 语句，则会继续执行之后的 case 或 default 语句，不论条件是否满足都会执行。
 case，default后面至少要有一条语句，default不处理的话加break
 枚举类型可以不必使用default
 支持String，Character
 复合条件：case "jack", "rose":
 区间匹配：case 1..<5:
 元祖匹配:
 let point = (1, 1)
 case (0,0):
 case (_, 0):
 case (-2...2, -2...2): // 匹配这个
 值绑定: let point = (2, 0)
 case (let x, 0): // 0匹配，把2赋值给x
 case let (x, y):
 where:
 let point = (1, -1)
 case let (x, y) where x == -y:
 
 numbers是数组
 for num in numbers where num > 0 {
 
 }
 
 41:23
 */

// MARK: 字面量
/**
 可存ASCII字符，Unicode字符
 let ch: Character = ""
 
 let doubleDecimal = 125.0 // 1.25e2 等价于1.25*(10^2)
 
 // 16进制
 0xFp2 等价于 15*(2^2)
 
 1000000 等价于 100_0000
 
 000123.456
 
 let array = [1, 2, 3]
 */

// MARK:类型转换
/**
 let int1: UInt16 = 2_000
 let int2: UInt8 = 1
 let int3 = int1 + UInt16(int2) // 把内存占用小的转成大的
 */



// MARK: ---汇编
/**
 指令:
 callq 表示函数调用
 addq 加法
 */
