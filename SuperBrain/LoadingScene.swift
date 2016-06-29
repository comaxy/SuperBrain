//
//  GameScene.swift
//  SuperBrain
//
//  Created by thunisoft on 16/6/28.
//  Copyright (c) 2016年 cynhard. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Loading..."
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
        
        let queue = dispatch_queue_create("connect", DISPATCH_QUEUE_SERIAL)
        dispatch_async(queue) {
            let ip = "172.16.160.12"
            // let ip = "192.168.1.108"
            let client = TCPClient(addr: ip, port: 7062)
            let result = client.connect(timeout: 10)
            dispatch_async(dispatch_get_main_queue(), { 
                if !result.0 {
                    myLabel.text = "Load failed!"
                } else {
//                    let playerInfo = "流星雨;123456";
//                    let playerInfoData = playerInfo.dataUsingEncoding(NSUTF8StringEncoding)
//                    client.send(data: [UInt8(1)])
//                    let length = NSData(bytes: playerInfoData?.length, length: 2)
//                    client.send(data: [UInt8((playerInfoData?.length)!)])
//                    var data = NSMutableData();
//                    var p = UnsafePointer<Void>();
 
                    //let friendListScene = FriendListScene(size: self.size)
                    //self.view?.presentScene(friendListScene)
                }
            })
        }
    }
}
