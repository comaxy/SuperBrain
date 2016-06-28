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
            let client = TCPClient(addr: "192.168.1.108", port: 7062)
            let result = client.connect(timeout: 10)
            dispatch_async(dispatch_get_main_queue(), { 
                if !result.0 {
                    myLabel.text = "Load failed!"
                } else {
                    let friendListScene = FriendListScene(size: self.size)
                    self.view?.presentScene(friendListScene)
                }
            })
        }
    }
}
