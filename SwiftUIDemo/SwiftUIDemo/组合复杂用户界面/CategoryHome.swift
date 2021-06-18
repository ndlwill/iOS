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
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(categories.keys.sorted(), id: \.self) { key in
                    Text(key)
                }
            }
            .navigationBarTitle("Featured")
        }
        
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
    }
}
