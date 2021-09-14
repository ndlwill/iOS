//
//  HikeGraph.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/28.
//

import SwiftUI

func rangeOfRanges<C: Collection>(_ ranges: C) -> Range<Double>
    where C.Element == Range<Double> {
    guard !ranges.isEmpty else { return 0..<0 }
    let low = ranges.lazy.map { $0.lowerBound }.min()!
    let high = ranges.lazy.map { $0.upperBound }.max()!
    return low..<high
}

func magnitude(of range: Range<Double>) -> Double {
    return range.upperBound - range.lowerBound
}

// 波动动画
extension Animation {
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)// 动画过程中产生了逐渐回弹效果
            .speed(2)// 加速弹簧动画的执行速度
            .delay(0.03 * Double(index))// 添加延迟效果，图表中的每个条形会顺序动起来
    }
}

struct HikeGraph: View {
    var hike: Hike
    var path: KeyPath<Hike.Observation, Range<Double>>
    
    var color: Color {
        switch path {
        case \.elevation:// 海拔
            return .gray
        case \.heartRate:// 心率
            return Color(hue: 0, saturation: 0.5, brightness: 0.7)
        case \.pace:// 步伐
            return Color(hue: 0.7, saturation: 0.4, brightness: 0.7)
        default:
            return .black
        }
    }
    
    var body: some View {
        let data = hike.observations
        print("data.indices = ", data.indices)
        
        // 总体范围  map: 返回Range<Double>数组
        let overallRange = rangeOfRanges(data.lazy.map { $0[keyPath: self.path] })
        let maxMagnitude = data.map { magnitude(of: $0[keyPath: path]) }.max()!
        let heightRatio = (1 - CGFloat(maxMagnitude / magnitude(of: overallRange))) / 2
        
        return GeometryReader { proxy in
            HStack(alignment: .bottom, spacing: proxy.size.width / 120, content: {
                ForEach(data.indices) { index in
                    GraphCapsule(
                        index: index,
                        height: proxy.size.height,
                        range: data[index][keyPath: self.path],
                        overallRange: overallRange)
                    .colorMultiply(self.color)
                    .transition(.slide)
                    .animation(.ripple(index: index))
                }
                .offset(x: 0, y: proxy.size.height * heightRatio)
            })
            .background(Color.red)
            //.border(Color.pink, width: 2)
        }
    }
}

struct HikeGraph_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HikeGraph(hike: hikeData[0], path: \.elevation)
                .frame(height: 200)
            
            HikeGraph(hike: hikeData[0], path: \.heartRate)
                .frame(height: 200)
            
            HikeGraph(hike: hikeData[0], path: \.pace)
                .frame(height: 200)
        }
    }
}
