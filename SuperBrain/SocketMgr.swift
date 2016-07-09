//
//  SocketMgr.swift
//  SuperBrain
//
//  Created by Theresa on 16/7/2.
//  Copyright © 2016年 cynhard. All rights reserved.
//

import Foundation

protocol SocketMgrDelegate {
    func handleEvent(eventId: UInt8, data: [UInt8]?)
}

class SocketMgr {
    static let sharedSocketMgr = SocketMgr()
    let socket_queue = dispatch_queue_create("socket_queue", DISPATCH_QUEUE_SERIAL)
    let client: TCPClient
    var socketMgrDelegate: SocketMgrDelegate?
    var stop = false
    init() {
        //let ip = "172.16.160.12"
        let ip = "192.168.1.108"
        self.client = TCPClient(addr: ip, port: 7062)
    }
    
    func runRecv() {
        let recv_queue = dispatch_queue_create("recv_queue", DISPATCH_QUEUE_SERIAL)
        dispatch_async(recv_queue) { 
            while !self.stop {
                var headerData = SocketMgr.sharedSocketMgr.client.read(3)!
                let eventId = headerData[0]
                let recvDataPtr = UnsafeMutableBufferPointer<UInt8>(start: &headerData, count: headerData.count)
                let lengthPtr_UInt8 = (recvDataPtr.baseAddress as UnsafeMutablePointer<UInt8>).successor()
                let lengthPtr_UInt16 = unsafeBitCast(lengthPtr_UInt8, UnsafePointer<UInt16>.self)
                let length = lengthPtr_UInt16.memory
                let recvData = SocketMgr.sharedSocketMgr.client.read(Int(length))
                self.socketMgrDelegate?.handleEvent(eventId, data: recvData)
            }
        }
    }
    
    func register(playerName: String, password: String) {
        let data = NSMutableData()
        let eventId = UnsafeMutablePointer<UInt8>.alloc(1)
        eventId.initialize(SockEvent.REGISTER.rawValue)
        data.appendBytes(eventId, length: 1)
        let playerInfo = playerName + ";" + password;
        let playerInfoData = playerInfo.dataUsingEncoding(NSUTF8StringEncoding)
        let bodyLength = UnsafeMutablePointer<UInt16>.alloc(1)
        bodyLength.initialize(UInt16((playerInfoData?.length)!))
        data.appendBytes(bodyLength, length: 2)
        data.appendData(playerInfoData!)
        SocketMgr.sharedSocketMgr.client.send(data: data)
    }
    
    func login(playerName: String, password: String) {
        let data = NSMutableData()
        let eventId = UnsafeMutablePointer<UInt8>.alloc(1)
        eventId.initialize(SockEvent.LOGIN.rawValue)
        data.appendBytes(eventId, length: 1)
        let playerInfo = playerName + ";" + password
        let playerInfoData = playerInfo.dataUsingEncoding(NSUTF8StringEncoding)
        let bodyLength = UnsafeMutablePointer<UInt16>.alloc(1)
        bodyLength.initialize(UInt16((playerInfoData?.length)!))
        data.appendBytes(bodyLength, length: 2)
        data.appendData(playerInfoData!)
        SocketMgr.sharedSocketMgr.client.send(data: data)
    }
    
    func fetchPlayerList() {
        let data = NSMutableData()
        let eventId = UnsafeMutablePointer<UInt8>.alloc(1)
        eventId.initialize(SockEvent.GET_PLAYER_LIST_REQUEST.rawValue)
        data.appendBytes(eventId, length: 1)
        let bodyLength = UnsafeMutablePointer<UInt16>.alloc(1)
        bodyLength.initialize(0)
        data.appendBytes(bodyLength, length: 2)
        SocketMgr.sharedSocketMgr.client.send(data: data)
    }
}