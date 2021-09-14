//
//  MapView.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/4.
//

import SwiftUI
import MapKit

// 要在SwiftUI中使用UIView及其子类，需要把这些UIView包裹在一个遵循UIViewRepresentable协议的SwiftUI视图中
struct MapView: UIViewRepresentable {
    
    var coordinate: CLLocationCoordinate2D

    // 第一个方法用来创建MKMapView
    // 替换body，用makeUIView(context:)方法来代替
    func makeUIView(context: Context) -> MKMapView {
        return MKMapView(frame: .zero)
    }
    
    // 第二个方法用来配置视图响应状态变化
    func updateUIView(_ uiView: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 2.0, longitudeDelta: 2.0)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        uiView.setRegion(region, animated: true)
    }
    // 在静态模式下预览时，只会渲染swiftUI视图的部分，因为MKMapView是UIView的子类，所以需要切换到实时预览模式下(Live Preview(实时预览))才能看到地图被完全渲染出来
    

}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: landmarkData[0].locationCoordinate)
    }
}
