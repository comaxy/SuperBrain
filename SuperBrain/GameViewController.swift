//
//  GameViewController.swift
//  SuperBrain
//
//  Created by thunisoft on 16/6/28.
//  Copyright (c) 2016年 cynhard. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        GameMgr.sharedGameMgr.gameView = skView
        
        let scene = LoadingScene(size: skView.bounds.size)
        skView.presentScene(scene)
        
        scene.label.text = "正在连接服务器..."
        dispatch_async(SocketMgr.sharedSocketMgr.socket_queue) {
            
            // connect to server
            let result = SocketMgr.sharedSocketMgr.client.connect(timeout: 10)
            if !result.0 {
                dispatch_sync(dispatch_get_main_queue(), {
                    scene.label.text = "连接服务器失败，请稍后再试！"
                })
                return;
            }
            
            dispatch_sync(dispatch_get_main_queue(), {
                scene.label.text = "连接成功！"
            })
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let playerName = userDefaults.objectForKey("playerName")
            if playerName != nil {
                dispatch_sync(dispatch_get_main_queue(), { 
                    scene.label.text = "正在登录..."
                })
                let data = NSMutableData()
                let eventId = UnsafeMutablePointer<UInt8>.alloc(1)
                eventId.initialize(SockEvent.LOGIN.rawValue)
                data.appendBytes(eventId, length: 1)
                let playerInfo = (playerName as! String) + ";" + (userDefaults.objectForKey("password") as! String);
                let playerInfoData = playerInfo.dataUsingEncoding(NSUTF8StringEncoding)
                let bodyLength = UnsafeMutablePointer<UInt16>.alloc(1)
                bodyLength.initialize(UInt16((playerInfoData?.length)!))
                data.appendBytes(bodyLength, length: 2)
                data.appendData(playerInfoData!)
                SocketMgr.sharedSocketMgr.client.send(data: data)
            } else {
                dispatch_async(dispatch_get_main_queue(), {
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let registerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("registerViewController")
                    self.presentViewController(registerViewController, animated: false, completion: nil)
                })
            }
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return .AllButUpsideDown
        } else {
            return .All
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
