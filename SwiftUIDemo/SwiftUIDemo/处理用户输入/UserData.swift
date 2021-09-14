//
//  UserData.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/16.
//

import SwiftUI
import Combine
// ObservableObject协议来自响应式框架Combine。SwiftUI可以订阅可观察对象，并在数据发生改变时更新视图的显示内容

// 要实现用户标记哪个地标为自己喜爱的地标这个功能，需要使用可观察对象(observalble object)存放地标数据
// 可观察对象是一种可以绑定到具体SwifUI视图环境中的数据对象。SwiftUI可以察觉它影响视图展示的任何变化，并在这种变化发生后及时更新对应视图的展示内容
final class UserData: ObservableObject {
    // 添加存储属性showFavoritesOnly和landmarks，并赋予初始值。可观察对象需要对外公布内部数据的任何改动，因此订阅此可观察对象的订阅者就可以获得对应的数据改动信息
    // 给新建的数据模型的每一个属性添加@Published属性修饰词
    @Published var showFavoritesOnly = false
    @Published var landmarks = landmarkData
    @Published var profile = Profile.default
}
