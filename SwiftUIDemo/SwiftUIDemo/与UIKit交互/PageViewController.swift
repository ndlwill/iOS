//
//  PageViewController.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/29.
//

import SwiftUI

// PageViewController使用UIPageViewController去展示来自SwiftUI内容

// SwiftUI可以在苹果全平台上无缝兼容现有的UI框架。例如，可以在SwiftUI视图中嵌入UIKit视图或UIKit视图控制器，反过来在UIKit视图或UIKit视图控制器中也可以嵌入SwiftUI视图。
// 为了在SwiftUI视图中展示UIKit视图和UIKit视图控制器，需要创建遵循UIViewRepresentable和UIViewControllerRepresentable协议的类型。
struct PageViewController: UIViewControllerRepresentable {
    // 数组中的每一个元素代表在地标滚动过程中的一页视图
    var controllers: [UIViewController]
    
    @Binding var currentPage: Int
    
    // MARK: - 添加UIViewControllerRepresentable协议的两个实现
    
    // 方法内部以指定的配置创建一个UIPageViewController
    // SwiftUI会在准备显示视图时调用一次makeUIViewController(context:)方法创建UIViewController实例，并管理它的生命周期。
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(transitionStyle: .scroll,
                                                      navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator
        pageViewController.delegate = context.coordinator
        return pageViewController
    }
    
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        // 展示数组中的第一个视图控制器
        pageViewController.setViewControllers([controllers[currentPage]], direction: .forward, animated: true)
    }
    
    // SwiftUI在调用makeUIViewController(context:)前会先调用makeCoordinator()方法，因此在配置视图控制器时是可以访问到coordiantor对象的
    // 可以使用coordinator为实现通用的Cocoa模式,例如：代理模式、数据源以及目标-动作。
    // 协调者
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: - Coordinator 数据源
    // 这个Coordinator类型由SwitUI管理，用来作为视图展示的环境
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            // Array<UIViewController>.Index, typealias Index = Int
            guard let index = parent.controllers.firstIndex(of: viewController) else { return nil }
            
            if index == 0 {
                return parent.controllers.last
            }
            return parent.controllers[index - 1]
        }
        
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = parent.controllers.firstIndex(of: viewController) else { return nil }
            
            if index + 1 == parent.controllers.count {
                return parent.controllers.first
            }
            return parent.controllers[index + 1]
        }
        
        // 因为SwiftUI在页面切换动画完成时会调用这个方法，这样就可以这个方法内部获取当前正在展示的页面的下标，并同时更新绑定属性currentPage的值。
        func pageViewController(_ pageViewController: UIPageViewController,
                                didFinishAnimating finished: Bool,
                                previousViewControllers: [UIViewController],
                                transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = parent.controllers.firstIndex(of: visibleViewController)
            {
                parent.currentPage = index
            }
        }
        
        
        
        var parent: PageViewController

        init(_ pageViewController: PageViewController) {
            self.parent = pageViewController
        }
    }
}
