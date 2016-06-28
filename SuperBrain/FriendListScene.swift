//
//  FriendListScene.swift
//  SuperBrain
//
//  Created by Theresa on 16/6/28.
//  Copyright © 2016年 cynhard. All rights reserved.
//

import SpriteKit

class FriendListScene: SKScene {
    override func didMoveToView(view: SKView) {
        let myLabel = SKLabelNode(fontNamed:"Chalkduster")
        myLabel.text = "Load Succeeded"
        myLabel.fontSize = 45
        myLabel.position = CGPoint(x:CGRectGetMidX(self.frame), y:CGRectGetMidY(self.frame))
        
        self.addChild(myLabel)
    }
}
