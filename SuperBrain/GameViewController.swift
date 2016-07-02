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
        let scene = LoadingScene(size: skView.bounds.size)
        skView.presentScene(scene)
        
        scene.label.text = "正在连接服务器..."
        let queue = dispatch_queue_create("socket_queue", DISPATCH_QUEUE_SERIAL)
        
        dispatch_async(queue) {
            
            // connect to server
            let ip = "172.16.160.12"
            //let ip = "192.168.1.108"
            let client = TCPClient(addr: ip, port: 7062)
            let result = client.connect(timeout: 10)

            if !result.0 {
                dispatch_sync(dispatch_get_main_queue(), {
                    scene.label.text = "连接服务器失败，请稍后再试！"
                })
                return;
            }
            
            let userDefaults = NSUserDefaults.standardUserDefaults()
            let username = userDefaults.objectForKey("username")
            if username != nil {
                dispatch_sync(dispatch_get_main_queue(), { 
                    scene.label.text = "正在登录..."
                })
                let data = NSMutableData()
                let eventId = UnsafeMutablePointer<UInt8>.alloc(1)
                eventId.initialize(SockEvent.REGISTER.rawValue)
                data.appendBytes(eventId, length: 1)
                let playerInfo = (username as! String) + ";" + (userDefaults.objectForKey("password") as! String);
                let playerInfoData = playerInfo.dataUsingEncoding(NSUTF8StringEncoding)
                let bodyLength = UnsafeMutablePointer<UInt16>.alloc(1)
                bodyLength.initialize(UInt16((playerInfoData?.length)!))
                data.appendBytes(bodyLength, length: 2)
                data.appendData(playerInfoData!)
                client.send(data: data)
            } else {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let registerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("registerViewController")
                self.presentViewController(registerViewController, animated: false, completion: nil)
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
