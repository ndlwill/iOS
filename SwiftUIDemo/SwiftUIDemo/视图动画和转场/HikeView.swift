//
//  HikeView.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/28.
//

import SwiftUI

extension AnyTransition {
    // 可以把滑入/滑出这种转场动画封装起来，方便其它视图复用同样的转场效果
    static var moveAndFade: AnyTransition {
        //AnyTransition.slide
        AnyTransition.move(edge: .trailing)// 让滑入/滑出从屏幕的同一边进行
    }
}

struct HikeView: View {
    var hike: Hike
    @State private var showDetail = false
    
    var transition: AnyTransition {
        //  使用asymmetric(insertion:removal:)修改器来定制视图显示/消失时的转场动画效果
        let insertion = AnyTransition.move(edge: .trailing)
            .combined(with: .opacity)
        let removal = AnyTransition.scale
            .combined(with: .opacity)
        return .asymmetric(insertion: insertion, removal: removal)
    }
    
    var body: some View {
        VStack {
            HStack {
                HikeGraph(hike: hike, path: \.elevation)
                    .frame(width: 50, height: 30)
                    .animation(nil)
                
                VStack(alignment: .leading) {
                    Text(hike.name)
                        .font(.headline)
                    Text(hike.distanceText)
                }
                
                Spacer()
                
                Button(action: {
                    // 给withAnimation传入一个时长4秒的基本动画参数.easeInOut(duration:4)，可以指定动画过程时长，给withAnimation传入的动画参数与.animation(_:)修改器可用参数一致。
                    withAnimation(.easeInOut(duration: 0.2)) {
                        self.showDetail.toggle()
                    }
                }, label: {
                    Image(systemName: "chevron.right.circle")
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))
                        // 如果只想让按钮具有缩放动画而不进行旋转动画，可以添加animation(nil)来实现。
                        //.animation(nil)
                        .scaleEffect(showDetail ? 1.5 : 1)
                        .padding()
                        //.animation(.easeInOut)
                        //.animation(.spring())
                })

            }

            // 在视图的状态发生改变时添加动画效果
            // 当用户点击按钮时会切换showDetail状态的值，在视图变化过程中添加动画效果。
            if showDetail {
                HikeDetail(hike: hike)
                    //.transition(.slide) // 转场动画为滑入/滑出
                    //.transition(.moveAndFade)
                    .transition(transition)
            }
        }
    }
}

struct HikeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HikeView(hike: hikeData[0])
                .padding()
            Spacer()
        }
    }
}
