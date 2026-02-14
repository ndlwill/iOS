
/**
 同 vc 的
 view.safeAreaInsets.top
 view.safeAreaInsets.bottom
 不同，不会受 vc 中是否有 
 navigationBar 和 tabBar 
 以及 vc.view 的布局方式（比如，vc.view是整个屏幕高度，还是从navigationBar底部到屏幕底部的高度，还是屏幕顶部到tabBar顶部的高度）影响。
 
 window:
 safeAreaInsets.top 44
 safeAreaInsets.bottom 34
 
 vc.view 有navigationBar，有tabBar:
 vc.view navigationBar(44)，tabBar(83 = 34 + 49)
 
 vc.view 显示navigationBar，显示tabBar
 (1)vc.view是屏幕顶部到tabBar顶部的高度
 safeAreaInsets.top 44+44=88
 safeAreaInsets.bottom 0
 (2)vc.view是整个屏幕高度
 safeAreaInsets.top 44+44=88
 safeAreaInsets.bottom 83
 
 vc.view 显示navigationBar（包括透明显示的这种，能看到导航返回按钮），不显示tabBar
 (1)vc.view是整个屏幕高度
 safeAreaInsets.top 44+44=88
 safeAreaInsets.bottom 34
 (2)vc的subVC.view是从navigationBar底部到屏幕底部的高度
 subVC.view的
 safeAreaInsets.top 0
 safeAreaInsets.bottom 34
 */
public extension UIWindow {
    var topSafeAreaHeight: CGFloat {
        safeAreaInsets.top
    }
    
    var bottomSafeAreaHeight: CGFloat {
        safeAreaInsets.bottom
    }
}
