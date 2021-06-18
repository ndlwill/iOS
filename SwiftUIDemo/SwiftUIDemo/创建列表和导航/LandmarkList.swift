//
//  LandmarkList.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/4.
//

import SwiftUI

struct LandmarkList: View {
    // 状态(State)是一个值或者一个值的集合，会随着时间而改变，同时会影响视图的内容、行为或布局。在属性前面加上@State修饰词就是给视图添加了一个状态值
    // 点击Resume按钮或快捷键Command+Option+P刷新画布。当对视图进行添加或修改属性等结构性改变时，需要手动刷新画布
    //@State var showFavoriteOnly = false
    
    // 使用@EnvironmentObject修饰的userData属性来替换原来的showFavoritesOnly状态属性，并对预览视图调用environmentObject(_:)修改器。只要environmentObject(_:)修改器应用在视图的父视图上，userData就能够自动获取它的值。
    @EnvironmentObject var userData: UserData
    
    var body: some View {
        // 除了单独列出列表中的每个元素外，列表还可以从一个集合中动态的生成。
        /*
        List {
            LandmarkRow(landmark: landmarkData[0])
            LandmarkRow(landmark: landmarkData[1])
        }
         */
        
        // 给列表添加导航能力，把列表视图嵌套到NavigationView视图中，然后把列表的每一个行视图嵌套进NavigationLink视图中，就可以建立起从地标列表视图到地标详情页的跳转。
        NavigationView {
            // 创建列表时可以传入一个集合数据和一个闭包，闭包会针对每一个数据元素返回一个视图，这个视图就是列表的行视图。
            /**
             想让数据变成可辨别的数据类型有两种方法:
             1.传入一个keypath指定数据中哪一个字段用来唯一标识这个数据元素
             2.让数据遵循Identifiable协议
             */
            // 在一个列表中组合静态和动态视图，或者组合两个甚至多个不同的动态视图组，使用ForEach类型动态生成而不是给列表传入数据集合生成列表视图
            List {
                // 为了让用户控制地标列表的过滤器，需要添加一个可以修改showFavoritesOnly值的控件，传递一个绑定关系给toggle控件可以实现
                
                // 一个绑定关系(binding)是对可变状态的引用。当用户点击toggle控件，从开到关或从关到开，toggle控件会通过绑定关系对应的更新视图的状态
                // 传入一个showFavoritesOnly的绑定关系。使用$前缀来获得一个状态变量或属性的绑定关系
                // 与@State修饰的属性一样，也可以使用$前缀访问userData对象的成员绑定引用
                Toggle(isOn: $userData.showFavoritesOnly, label: {
                    Text("Favorite Only")
                })
                
                ForEach(userData.landmarks) { landmark in
                    // 可以定制地标列表，让它只显示用户喜欢的地标，或者显示所有的地标
                    if !self.userData.showFavoritesOnly || landmark.isFavorite {
                        // 在列表的闭包中，将每一个行元素包裹在NavigationLink中返回，并指定LandmarkDetail视图为目标视图
                        NavigationLink(destination: ContentView1(landmark: landmark)) {
                            LandmarkRow(landmark: landmark)
                        }
                    }
                }
                
            }
            .navigationBarTitle(Text("Landmarks"))// 导航条标题
        }
        
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        
        ForEach(["iPhone 11", "iPhone SE (2nd generation)"], id: \.self) { deviceName in
            LandmarkList()
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
                .environmentObject(UserData())
        }
        
    }
}
