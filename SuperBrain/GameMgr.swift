//
//  GameMgr.swift
//  SuperBrain
//
//  Created by Theresa on 16/7/3.
//  Copyright © 2016年 cynhard. All rights reserved.
//

import SpriteKit

class GameMgr: SocketMgrDelegate {
    static let sharedGameMgr = GameMgr()
    
    var gameView: SKView?
    var registerViewController: RegisterViewController?
    var gameViewController: GameViewController?
    var playerListViewController: PlayerListViewController?
    
    init() {
        SocketMgr.sharedSocketMgr.socketMgrDelegate = self
    }
    
    func goToPlayerListViewController() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let playerListViewController = mainStoryboard.instantiateViewControllerWithIdentifier("playerListViewController")
        self.gameViewController?.presentViewController(playerListViewController, animated: true, completion: nil)
    }
    
    func handleEvent(eventId: UInt8, data: [UInt8]?) {
        if let sockEvent = SockEvent(rawValue: eventId) {
            switch sockEvent {
            case .REG_RESULT: self.handleRegResult(data)
            case .LOGIN_RESULT: self.handleLoginResult(data)
            case .GET_PLAYER_LIST_RESPONSE: self.handleGetPlayerListResponse(data)
            default:
                break;
            }
        }
    }
    
    func handleRegResult(data: [UInt8]?) {
        self.registerViewController?.handleRegisterResult_async(data)
    }
    
    func handleLoginResult(data: [UInt8]?) {
        self.gameViewController?.handleLoginResult_async(data)
    }
    
    func handleGetPlayerListResponse(data: [UInt8]?) {
        self.playerListViewController?.loadPlayerList(data)
    }
}
