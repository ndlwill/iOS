//
//  TestSwiftUI.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/10.
//

import SwiftUI

struct TestSwiftUI: View {
    // 视图是它们状态的函数
    @State private var name = ""
    
    var body: some View {
        Form {
            // 双向绑定: 我们绑定文本框以便它展示我们的属性值，同时我们也绑定属性以便文本框有任何变化时属性也随之更新
            // 在 Swift 中，我们用一种特殊的符号标记这种双向绑定，在属性前写一个$符号。它告诉 Swift 不仅需要读取属性的值，也需要在绑定对象的内容改变时，把值写回属性。
            TextField("Enter your name", text: $name)
            // 在静态文本控件里，你只需要用 name 而不是 $name。因为静态文本控件并不需要双向绑定，我们只是读取值。
            Text("Your name is \(name)")
        }
    }
}

struct TestSwiftUI_Previews: PreviewProvider {
    static var previews: some View {
        TestSwiftUI()
    }
}
