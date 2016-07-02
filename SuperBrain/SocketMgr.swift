//
//  SocketMgr.swift
//  SuperBrain
//
//  Created by Theresa on 16/7/2.
//  Copyright © 2016年 cynhard. All rights reserved.
//

import Foundation

class SocketMgr {
    static let sharedSocketMgr = SocketMgr()
    let socket_queue = dispatch_queue_create("socket_queue", DISPATCH_QUEUE_SERIAL)
    let client: TCPClient
    init() {
        //let ip = "172.16.160.12"
        let ip = "192.168.1.108"
        self.client = TCPClient(addr: ip, port: 7062)
    }
}