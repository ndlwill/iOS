//
//  CategoryHome.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/18.
//

import SwiftUI

// 首页
struct CategoryHome: View {
    
    var categories: [String: [Landmark]] {
        // 把地标数据的类别属性category传入作为分组依据，可以把地标数据按类别分组
        Dictionary(grouping: landmarkData, by: { $0.category.rawValue })
    }
    
    var featured: [Landmark] {
        landmarkData.filter { $0.isFeatured }
    }
    
    @State var showProfile = false
    @EnvironmentObject var userData: UserData
    
    var profileButton: some View {
        Button(action: {
            self.showProfile.toggle()
        }, label: {
            Image(systemName: "person.crop.circle")
                .imageScale(.large)
                .accessibility(label: Text("User Profile"))
                .padding()
        })
    }
    
    var body: some View {
        
        NavigationView {
            List {
                
                FeaturedLandmarks(landmarks: featured)
                    .scaledToFill()
                    .frame(height: 200)
                    .clipped()
                // 把视图的边距设置为0，让展示内容可以尽量贴着屏幕边沿
                    .listRowInsets(EdgeInsets())
                
                ForEach(categories.keys.sorted(), id: \.self) { key in
                    if let items = self.categories[key] {
                        CategoryRow(categoryName: key, items: items)
                    }
                }
                .listRowInsets(EdgeInsets())
                
                NavigationLink(
                    destination: LandmarkList(),
                    label: {
                        Text("See All")
                    })
            }
            .navigationBarTitle("Featured")
            // 在导航条上添加一个按钮，用来切换showProfile状态的值：true或者false
            .navigationBarItems(trailing: profileButton)
            // 添加一个模态展示的用户信息展示页，点击了用户图标时弹出展示。
            .sheet(isPresented: $showProfile, content: {
                ProfileHost().environmentObject(self.userData)
            })
        }
        
    }
}

struct FeaturedLandmarks: View {
    var landmarks: [Landmark]
    var body: some View {
        landmarks[0].image.resizable()
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
            .environmentObject(UserData())
    }
}
