//
//  BadgeBackground.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/28.
//

import SwiftUI

struct BadgeBackground: View {
    
    var body: some View {
        // 把徽章路径包裹在一个Geometry Reader中，这样徽章可以使用容器的大小，定义自己绘制的尺寸，这样就不需要硬编码绘制尺寸了(100)。
        // 当绘制区域不是正方形时，使用绘制区域的最小边长(长宽中哪个最小使用哪个)作为绘制徽章背景的边长，并保持徽章背景的长宽比为1:1
        GeometryReader { geometry in
            
            Path({ path in
                print("width=", geometry.size.width)
                print("height=", geometry.size.height)
                
                // 给路径添加起点，move(to:)方法可以把绘图光标移动到绘图中的一点，准备绘制的起点
                var width: CGFloat = min(geometry.size.width, geometry.size.height)
                let height = width
                
                // 使用xScale和xOffset参数调整变量，把徽章几何绘图区域居中绘制出来
                let xScale: CGFloat = 0.832
                let xOffset: CGFloat = (width * (1.0 - xScale)) / 2.0
                width *= xScale
                
                path.move(to: CGPoint(x: xOffset + width * 0.95, y: height * (0.20 + HexagonParameters.adjustment)))
                
                // 使用六边形的绘制参数数据HexagonParameters
                HexagonParameters.points.forEach {
                    path.addLine(to: CGPoint(x: xOffset + width * $0.useWidth.0 * $0.xFactors.0,
                                             y: height * $0.useHeight.0 * $0.yFactors.0))
                    
                    // 使用addQuadCurve(to:control:)方法绘制贝塞尔曲线，让六边形的角变的更圆润些。
                    path.addQuadCurve(to: CGPoint(x: xOffset + width * $0.useWidth.1 * $0.xFactors.1,
                                                  y: height * $0.useHeight.1 * $0.yFactors.1),
                                      control: CGPoint(x: xOffset + width * $0.useWidth.2 * $0.xFactors.2,
                                                       y: height * $0.useHeight.2 * $0.yFactors.2))
                }
            })
            .fill(LinearGradient(gradient: Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                                 startPoint: UnitPoint(x: 0.5, y: 0),
                                 endPoint: UnitPoint(x: 0.5, y: 0.6)))
            // 渐变色上再使用aspectRatio(_:contentMode:)修改器，让渐变色按内容宽高比进行成比例渐变填充。
            .aspectRatio(1, contentMode: .fit)
        }
        
    }
    
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
}

struct BadgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BadgeBackground()
    }
}
