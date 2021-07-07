//
//  CategoryRow.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/25.
//

import SwiftUI

struct CategoryRow: View {
    
    var categoryName: String
    var items: [Landmark]
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Text(self.categoryName)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)
            
            ScrollView(.horizontal, showsIndicators: false, content: {
                HStack(alignment: .top, spacing: 0) {
                    
                    ForEach(self.items) { landmark in
                        NavigationLink(
                            destination: ContentView1(landmark: landmark),
                            label: {
                                CategoryItem(landmark: landmark)
                            })
                        
                    }

                }
            })
            .frame(height: 185)
            
            
        }
    }
}

/**
 使用renderingMode(_:)和foregroundColor(_:)这两个属性修改器来改变地标类别项的导航样式。
 做为NavigationLink标签的CategoryItem中的文本会使用Environment中的强调颜色，图片可能以模板图片的方式渲染，这些都可以使用属性修改器来调整，达到最佳效果
 */
struct CategoryItem: View {
    var landmark: Landmark
    var body: some View {
        VStack(alignment: .leading) {
            landmark.image
                .renderingMode(.original)
                .resizable()
                .frame(width: 155, height: 155)
                .cornerRadius(5)
            Text(landmark.name)
                .foregroundColor(.primary)
                .font(.caption)
        }
        .padding(.leading, 15)
    }
}

struct CategoryRow_Previews: PreviewProvider {
    static var previews: some View {
        CategoryRow(categoryName: landmarkData[0].category.rawValue, items: Array(landmarkData.prefix(3)))
    }
}
