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

// MARK: - LandmarkDetail
struct ContentView1: View {
    // 让它从父视图的环境变量中取要展示的数据
    // 当从列表页导航进入详情页后，点击喜欢按钮，喜欢的状态会在返回列表页后与列表中对应的地标喜欢状态保持一致，因为列表页和详情页的地标数据使用的是同一份，所以可以在不同页面间保持状态同步。
    @EnvironmentObject var userData: UserData
    
    var landmarkIndex: Int {
        userData.landmarks.firstIndex(where: {
            $0.id == landmark.id
        })!
    }
    
    var landmark: Landmark
    var body: some View {
        VStack {
            // 当只指定高度时，宽度会自动计算为父视图的宽度，在这里就是屏幕宽度
            MapView(coordinate: landmark.locationCoordinate).frame(height: 300)
                // 为了让地图的视图内容显示在状态栏的下方，可以给MapView添加edgesIgnoringSafeArea(.top)修改器，这可以让它在布局时忽略顶部的安全区域边距
                .edgesIgnoringSafeArea(.top)
            // 为了让图片视图叠放在地图视图的上面，可以设置图片视图的垂直偏移量为-130，图片视图的底部内边距也为-130，这个效果就是把图片垂直上移了130，同时和下面的文字区域留出了130的空白分隔区
            CircleImage(image: landmark.image).offset(y: -130)
                .padding(.bottom, -130)
            VStack(alignment: .leading) {
                HStack {
                    Text(landmark.name)
                        .font(.title)
                    
                    Button(action: {
                        self.userData.landmarks[self.landmarkIndex].isFavorite.toggle()
                    }, label: {
                        if self.userData.landmarks[self.landmarkIndex].isFavorite {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "star")
                                .foregroundColor(.gray)
                        }
                    })
                }
                
                
                HStack(alignment: .top) {
                    Text(landmark.park)
                        .font(.subheadline)
                    Spacer()
                    Text(landmark.state)
                        .font(.subheadline)
                }
            }.padding()
            // 在外层VStack内部的最下面加上Spacer，可以让上面的视图内容顶到屏幕的上边
            Spacer()
        }
        .navigationBarTitle(Text(landmark.name), displayMode: .inline)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView1(landmark: landmarkData[0])
            .environmentObject(UserData())
    }
}
