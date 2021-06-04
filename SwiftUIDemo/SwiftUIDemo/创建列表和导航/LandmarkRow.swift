//
//  LandmarkRow.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/4.
//

import SwiftUI

struct LandmarkRow: View {
    // 添加landmark属性做为LandmarkRow视图的一个存储属性
    var landmark: Landmark
    
    var body: some View {
        HStack {
            landmark.image
                .resizable()
                .frame(width: 50, height: 50)
            Text(landmark.name)
            Spacer()
        }
    }
}

struct LandmarkRow_Previews: PreviewProvider {
    static var previews: some View {
        // 可以使用Group的方式，返回多个不同场景下的预览视图
        // Group是一个容器，它可以把视图内容组织起来，Xcode会把Group内的每个子视图当作画布内一个单独的预览视图处理
        Group {
            // 当添加landmark属性后，预览视图可能会停止工作，因为LandmarkRow视图初始化时需要有一个landmark实例
            LandmarkRow(landmark: landmarkData[0])
                // 使用previewLayout(_:)修改器设置一个行视图在列表中显示的尺寸大小。
                .previewLayout(.fixed(width: 300, height: 70))
            LandmarkRow(landmark: landmarkData[1])
                .previewLayout(.fixed(width: 300, height: 70))
        }
        
        // 可以把previewLayout(_:)这个修改器应用到外层的Group上，Group的每一个子视图会继承自己所处环境的配置。对preivew provider的修改只会影响预览画布的表现，对实际的应用不会产生影响。
        Group {
            LandmarkRow(landmark: landmarkData[0])
            LandmarkRow(landmark: landmarkData[1])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
