//
//  HikeBadge.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/28.
//

import SwiftUI

struct HikeBadge: View {
    
    var name: String
    
    var body: some View {
        VStack(alignment: .center) {
            Badge()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300)
                .scaleEffect(1.0 / 3.0)
                // 注意frame(width:height:)的两种不同的用法用来配置徽章以不同的缩放尺寸显示。
                .frame(width: 100, height: 100)
            
            Text(name)
                .font(.caption)
                .accessibility(label: Text("Badge for \(name)."))
        }
    }
}

struct HikeBadge_Previews: PreviewProvider {
    static var previews: some View {
        HikeBadge(name: "Preview Testing")
    }
}
