// MARK: - DNS
func dnsServers() -> [res_9_sockaddr_union] {
    let state = FVDNSResolverState.create()
    res_9_ninit(state)
    // MAXNS: maxNameServers
    var servers = [res_9_sockaddr_union](repeating: res_9_sockaddr_union(), count: Int(MAXNS)) // MAXNS: 3
    /**
        result:
        n (successful, where n is the number of addresses returned in the name server address list
        -1 (unsuccessful)
        */
    let found = Int(res_9_getservers(state, &servers, Int32(MAXNS)))
    res_9_nclose(state)
    
    if found > 0 {
        return Array(servers[0..<found]).filter() { $0.sin.sin_len > 0 }
    } else {
        return [res_9_sockaddr_union]()
    }
}

// 获取dns地址,连接VPN会变化 (VPN连接前: ["192.168.100.20", "202.96.209.5"] VPN连接后: ["8.8.8.8", "208.67.222.222"])
func getDNSAddress(_ s: res_9_sockaddr_union) -> String {
    var res = s
    // public typealias CChar = Int8
    var hostBuffer = [CChar](repeating: 0, count: Int(NI_MAXHOST))// NI_MAXHOST: 1025
    
    let _ = withUnsafePointer(to: &res) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            if s.sin.sin_family == AF_INET {// 这个情况下: AF_INET == 2, AF_INET6 == 30 s.sin6.sin6_family == 2
                Darwin.getnameinfo($0, socklen_t(s.sin.sin_len),
                &hostBuffer, socklen_t(hostBuffer.count),
                nil, socklen_t(0),
                NI_NUMERICHOST)
            } else if s.sin6.sin6_family == AF_INET6 {
                Darwin.getnameinfo($0, socklen_t(s.sin6.sin6_len),
                &hostBuffer, socklen_t(hostBuffer.count),
                nil, socklen_t(0),
                NI_NUMERICHOST)
            }
        }
    }
    
    /**
        或者: for ipv4
        var tempRes = s
        var ipv4 = [CChar](repeating: 0, count: Int(INET_ADDRSTRLEN))
        withUnsafeMutablePointer(to: &tempRes.sin.sin_addr) {
            inet_ntop(AF_INET, UnsafeRawPointer($0), &ipv4, socklen_t(INET_ADDRSTRLEN))
            print("inet: \(String(cString: ipv4))")// 192.168.100.100
        }
        */
    
    return String(cString: hostBuffer)
}