//
//  ProfileHost.swift
//  SwiftUIDemo
//
//  Created by youdone-ndl on 2021/6/28.
//

import SwiftUI

struct ProfileHost: View {
    
    @Environment(\.editMode) var mode
    
    // 从环境变量中读取用户简介信息，并把数据传递给ProfileHost视图的控件上进行展示。
    // 为了在编辑状态下修改简介信息后确认修改前避免更新全局状态(例如在编辑用户名的过程中)，编辑视图在一个备份属性中进行相应的修改操作，确认修改后，才把备份属性同步到全局应用状态中。
    @EnvironmentObject var userData: UserData
    
    @State var draftProfile = Profile.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20, content: {
            HStack {
                // 在ProfileHost视图上添加一个取消按钮。不像编辑模式按钮提供的完成按钮，取消按钮不会应用修改后的简介备份信息到实际的简介数据上。
                if self.mode?.wrappedValue == .active {
                    Button("Cancel") {
                        self.draftProfile = self.userData.profile
                        self.mode?.animation().wrappedValue = .inactive
                    }
                }
                
                Spacer()
                
                EditButton()
            }
            
            if self.mode?.wrappedValue == .inactive {
                ProfileSummary(profile: userData.profile)
            } else {
                // 把简单的绑定关系传递给简介编辑器.现在当你点击Edit按钮，简介视图就会变成编辑模式了。
                ProfileEditor(profile: $draftProfile)
                // 当用户点击完成按钮后，使用onAppear(perform:)和onDisappear(perform:)来更新或保存用户简介数据。下一次进入编辑模式时，使用上一次的用户简介数据来展示。
                    .onAppear(perform: {
                        self.draftProfile = self.userData.profile
                    })
                    .onDisappear(perform: {
                        self.userData.profile = self.draftProfile
                    })
            }
            
        })
        .padding()
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost().environmentObject(UserData())
    }
}
