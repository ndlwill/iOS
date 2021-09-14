//
//  HikeDetail.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/28.
//

import SwiftUI

struct HikeDetail: View {
    
    let hike: Hike
    @State var dataToShow = \Hike.Observation.elevation
    
    var buttons = [
        ("Elevation", \Hike.Observation.elevation),
        ("Heart Rate", \Hike.Observation.heartRate),
        ("Pace", \Hike.Observation.pace)
    ]
    
    var body: some View {
        VStack {
            HikeGraph(hike: hike, path: dataToShow)
                .frame(height: 200)
                .border(Color.blue, width: 1)
            
            HStack(spacing: 25) {
                ForEach(buttons, id: \.0) { value in
                    Button(action: {
                        self.dataToShow = value.1
                    }, label: {
                        Text(value.0)
                            .font(.system(size: 15))
                            .foregroundColor(value.1 == self.dataToShow ? Color.gray : Color.accentColor)
                            .animation(nil)
                    })
                }
            }
            .border(Color.black, width: 1)
        }
    }
}

struct HikeDetail_Previews: PreviewProvider {
    static var previews: some View {
        HikeDetail(hike: hikeData[0])
    }
}
