//
//  GameMgr.swift
//  SuperBrain
//
//  Created by Theresa on 16/7/3.
//  Copyright © 2016年 cynhard. All rights reserved.
//

import SpriteKit

class GameMgr {
    static let sharedGameMgr = GameMgr()
    var gameView: SKView?
    
    func goToPlayerListScene() {
        let playerListScene = PlayerListScene(size: self.gameView!.bounds.size)
        self.gameView!.presentScene(playerListScene)
    }
}
