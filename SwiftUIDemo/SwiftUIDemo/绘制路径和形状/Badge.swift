//
//  Badge.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/28.
//

import SwiftUI

struct Badge: View {
    
    static let rotationCount = 8
    
    // 使用ForEach复制多个徽章图标，按360度周解均分，每一个徽章符号都比前一个多旋转45度，这种就会形成一个类似太阳和徽章图标
    var badgeSymbols: some View {
        ForEach(0 ..< Self.rotationCount) { i in
            RotatedBadgeSymbol(angle: Angle(degrees: Double(i * 45)))
                .opacity(0.5)
        }
    }
    
    var body: some View {
        ZStack {
            BadgeBackground()
            
            GeometryReader { geometry in
                self.badgeSymbols
                    .scaleEffect(1.0 / 4.0, anchor: .top)
                    .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
            }
            
        }
        .scaledToFit()
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}
