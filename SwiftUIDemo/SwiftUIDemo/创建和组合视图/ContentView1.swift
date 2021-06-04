//
//  ContentView.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/3.
//

import SwiftUI

// MARK: SwiftUI
/**
 在声明自定义SwiftUI视图时，视图布局要声明的在body属性中
 View协议中要求实现body属性，每一个SwiftUI视图都遵循View协议
 
 */

struct ContentView1: View {
    var body: some View {
        VStack {
            // 当只指定高度时，宽度会自动计算为父视图的宽度，在这里就是屏幕宽度
            MapView().frame(height: 300)
                // 为了让地图的视图内容显示在状态栏的下方，可以给MapView添加edgesIgnoringSafeArea(.top)修改器，这可以让它在布局时忽略顶部的安全区域边距
                .edgesIgnoringSafeArea(.top)
            // 为了让图片视图叠放在地图视图的上面，可以设置图片视图的垂直偏移量为-130，图片视图的底部内边距也为-130，这个效果就是把图片垂直上移了130，同时和下面的文字区域留出了130的空白分隔区
            CircleImage().offset(y: -130)
                .padding(.bottom, -130)
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.title)
                HStack {
                    Text("SubTitle_Left")
                        .font(.subheadline)
                    Spacer()
                    Text("SubTitle_right")
                        .font(.subheadline)
                }
            }.padding()
            // 在外层VStack内部的最下面加上Spacer，可以让上面的视图内容顶到屏幕的上边
            Spacer()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1()
    }
}
