//
//  Landmark.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/4.
//

import SwiftUI
import CoreLocation

struct Landmark: Hashable, Codable, Identifiable {
    // 因为Landmark类型已经定义了id属性，正好满足Identifiable协议，所以不需要添加其它代码
    // 切换回文件LandmarkList.swift，移除keypath \.id，因为landmarkData数据集合的元素已经遵循了Identifiable协议，所以在列表初始化器中可以直接使用，不需要手动标明数据的唯一标识符了
    var id: Int
    var name: String
    fileprivate var imageName: String
    fileprivate var coordinates: Coordinates
    var state: String
    var park: String
    var category: Category
    var isFavorite: Bool

    var locationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(
            latitude: coordinates.latitude,
            longitude: coordinates.longitude)
    }

    enum Category: String, CaseIterable, Codable, Hashable {
        case featured = "Featured"
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"
    }
}

extension Landmark {
    var image: Image {
        ImageStore.shared.image(name: imageName)
    }
}

struct Coordinates: Hashable, Codable {
    var latitude: Double
    var longitude: Double
}
