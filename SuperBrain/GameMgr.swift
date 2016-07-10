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
    
    func appRootViewController() -> UIViewController? {
        var topVC = UIApplication.sharedApplication().keyWindow?.rootViewController
        while topVC?.presentedViewController != nil {
            topVC = topVC?.presentedViewController
        }
        return topVC
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
            case .CHALLENGE_FRIEND_REQUEST: self.handleChallengeFriendRequest(data)
            case .CHALLENGE_FRIEND_RESPONSE: self.handleChallengeFriendResponse(data)
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
    
    func handleChallengeFriendRequest(data: [UInt8]?) {
        if data == nil {
            return
        }
        let bodyUtf8 = NSData(bytes: data!, length: data!.count)
        let body = NSString(data: bodyUtf8, encoding: NSUTF8StringEncoding) as! String
        let challengeInfo = body.componentsSeparatedByString(";")

        dispatch_async(dispatch_get_main_queue()) {
            let alert = UIAlertController(title: "提示", message: challengeInfo[0] + "向你挑战" + challengeInfo[1] + "，是否接受？", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "是", style: .Default, handler: { action in
                SocketMgr.sharedSocketMgr.replyChallenge(true, reason: "OK")
            }))
            alert.addAction(UIAlertAction(title: "否", style: .Default, handler: { action in
                SocketMgr.sharedSocketMgr.replyChallenge(false, reason: "I AM NOT FREE")
            }))
            self.appRootViewController()!.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    func handleChallengeFriendResponse(data: [UInt8]?) {
        if data == nil {
            return
        }
        let bodyUtf8 = NSData(bytes: data!, length: data!.count)
        let body = NSString(data: bodyUtf8, encoding: NSUTF8StringEncoding) as! String
        let response = body.componentsSeparatedByString(";")
        switch response[0] {
        case "1": print("friend agree")
        case "2": print("friend disagree")
        case "3": print("server internal error")
        default:
            break;
        }
    }
}
