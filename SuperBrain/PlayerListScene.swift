//
//  FriendListScene.swift
//  SuperBrain
//
//  Created by Theresa on 16/6/28.
//  Copyright © 2016年 cynhard. All rights reserved.
//

import SpriteKit

class PlayerListScene: SKScene {
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "正在加载在线玩家列表..."
        myLabel.fontSize = 20
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
    }
}
