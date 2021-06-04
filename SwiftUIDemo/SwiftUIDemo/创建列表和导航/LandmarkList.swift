//
//  LandmarkList.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/4.
//

import SwiftUI

struct LandmarkList: View {
    var body: some View {
        // 除了单独列出列表中的每个元素外，列表还可以从一个集合中动态的生成。
        /*
        List {
            LandmarkRow(landmark: landmarkData[0])
            LandmarkRow(landmark: landmarkData[1])
        }
         */
        
        // 创建列表时可以传入一个集合数据和一个闭包，闭包会针对每一个数据元素返回一个视图，这个视图就是列表的行视图。
        /**
         想让数据变成可辨别的数据类型有两种方法:
         1.传入一个keypath指定数据中哪一个字段用来唯一标识这个数据元素
         2.让数据遵循Identifiable协议
         */
        List(landmarkData, id:\.id) { Landmark in
            
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {
        LandmarkList()
    }
}
