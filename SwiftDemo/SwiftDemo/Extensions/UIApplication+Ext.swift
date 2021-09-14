//
//  UIApplication+Ext.swift
//  SwiftDemo
//
//  Created by youdone-ndl on 2021/1/14.
//  Copyright © 2021 dzcx. All rights reserved.
//

import UIKit

extension UIApplication {

    var isBeingDebugged: Bool {
        // Initialize all the fields so that,
        // if sysctl fails for some bizarre reason, we get a predictable result.
        var info = kinfo_proc()
        // Initialize mib, which tells sysctl the info we want,
        // in this case we're looking for info about a specific process ID.
        var mib = [CTL_KERN, KERN_PROC, KERN_PROC_PID, getpid()]
        // Call sysctl.
        var size = MemoryLayout.stride(ofValue: info)
        let junk = sysctl(&mib, u_int(mib.count), &info, &size, nil, 0)
        assert(junk == 0, "sysctl failed")
        // We're being debugged if the P_TRACED flag is set.
        return (info.kp_proc.p_flag & P_TRACED) != 0
    }

}
