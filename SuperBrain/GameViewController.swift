import UIKit
import SpriteKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameMgr.sharedGameMgr.gameViewController = self
        
        let skView = self.view as! SKView
        
        GameMgr.sharedGameMgr.gameView = skView
        
        let scene = LoadingScene(size: skView.bounds.size)
        skView.presentScene(scene)
        
        scene.label.text = "正在连接服务器..."
        
        SocketMgr.sharedSocketMgr.connect({ 
            dispatch_async(dispatch_get_main_queue(), {
                scene.label.text = "连接成功！"
                
                let userDefaults = NSUserDefaults.standardUserDefaults()
                let playerName = userDefaults.objectForKey("playerName")
                
                if playerName != nil {
                    scene.label.text = "正在登录..."
                    SocketMgr.sharedSocketMgr.login(playerName as! String, password: (userDefaults.objectForKey("password") as! String))
                } else {
                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                    let registerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("registerViewController")
                    self.presentViewController(registerViewController, animated: false, completion: nil)
                }
            })
        }) {
            dispatch_sync(dispatch_get_main_queue(), {
                scene.label.text = "连接服务器失败，请稍后再试！"
            })
        }
//        
//        dispatch_async(SocketMgr.sharedSocketMgr.socket_queue) {
//            
//            // connect to server
//            let result = SocketMgr.sharedSocketMgr.client.connect(timeout: 10)
//            if !result.0 {
//                dispatch_sync(dispatch_get_main_queue(), {
//                    scene.label.text = "连接服务器失败，请稍后再试！"
//                })
//                return;
//            }
//            
//            dispatch_sync(dispatch_get_main_queue(), {
//                scene.label.text = "连接成功！"
//            })
//            
//            SocketMgr.sharedSocketMgr.runRecv()
//            
//            let userDefaults = NSUserDefaults.standardUserDefaults()
//            let playerName = userDefaults.objectForKey("playerName")
//            if playerName != nil {
//                dispatch_sync(dispatch_get_main_queue(), { 
//                    scene.label.text = "正在登录..."
//                })
//                SocketMgr.sharedSocketMgr.login(playerName as! String, password: (userDefaults.objectForKey("password") as! String))
//            } else {
//                dispatch_async(dispatch_get_main_queue(), {
//                    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
//                    let registerViewController = mainStoryboard.instantiateViewControllerWithIdentifier("registerViewController")
//                    self.presentViewController(registerViewController, animated: false, completion: nil)
//                })
//            }
//        }
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
    
    func handleLoginResult_async(data: [UInt8]?) {
        dispatch_async(dispatch_get_main_queue()) { 
            GameMgr.sharedGameMgr.goToPlayerListViewController()
        }
    }
}
