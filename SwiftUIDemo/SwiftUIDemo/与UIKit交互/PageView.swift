//
//  PageView.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/29.
//

import SwiftUI

struct PageView<Page: View>: View {
    
    // 如果要添加一个自定义的UIPageControl控件，就需要一种方式能够在PageView中跟踪当前展示的页面。这就需要在PageView中声明一个@State属性，并传递一个针对该属性的绑定关系给PageViewController视图，在PageViewController中通过绑定关系更新状态属性，来反映当前展示的页面。
    @State var currentPage = 0
    
    var viewControllers: [UIHostingController<Page>]
    
    
    // 初始化时使用一个视图数组来初始化，并把每一个视图都嵌入在一个UIHostingController中。UIHostingController是一个UIViewController的子类，用来在UIKit环境中表示一个SwiftUI视图。
    init(_ views: [Page]) {
        self.viewControllers = views.map { UIHostingController(rootView: $0) }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing, content: {
            // 使用$语法创建一个针对状态变量的绑定关系。
            PageViewController(controllers: viewControllers, currentPage: $currentPage)
                //.frame(width: UIScreen.main.bounds.size.width)
                //.aspectRatio(3 / 2, contentMode: .fit)
                //.background(Color.yellow)
            PageControl(numberOfPages: viewControllers.count, currentPage: $currentPage)
                .frame(width: 100)
                //.background(Color.green)
        })
        .background(Color.yellow)
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(features.map { FeatureCard(landmark: $0) })
            .aspectRatio(3 / 2, contentMode: .fit)
    }
}
