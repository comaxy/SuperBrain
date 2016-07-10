import UIKit

class GameListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gameList: [String] = []
    var indicatorView: UIActivityIndicatorView!
    var indicatorLabel: UILabel!
    var friendPlayerName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GameMgr.sharedGameMgr.gameListViewController = self
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        self.indicatorView = UIActivityIndicatorView(frame: CGRectMake(0, 0, 30, 30))
        self.indicatorView.center = self.view.center
        self.indicatorView.frame = self.view.frame
        self.indicatorView.backgroundColor = UIColor.blackColor()
        self.indicatorView.alpha = 0.75
        self.indicatorView.activityIndicatorViewStyle = .WhiteLarge
        self.view.addSubview(self.indicatorView)
        self.indicatorLabel = UILabel(frame: CGRectMake(0, 0, 200, 30))
        self.indicatorLabel.textColor = UIColor.whiteColor()
        self.indicatorLabel.textAlignment = .Center
        self.indicatorLabel.text = "正在通信，请稍候..."
        self.indicatorLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 40)
        self.view.addSubview(self.indicatorLabel)
        self.indicatorLabel.hidden = true
        
        gameList.append("速算大比拼")
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return gameList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let gameCell = self.tableView.dequeueReusableCellWithIdentifier("gameCell", forIndexPath: indexPath)
        let gameNameLabel = gameCell.viewWithTag(1) as! UILabel
        gameNameLabel.text = self.gameList[indexPath.row]
        return gameCell
    }
    
    func handleChallengeResponse(data: [UInt8]?) {
        if data == nil {
            return
        }
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.indicatorView.stopAnimating()
            self.indicatorLabel.hidden = true
            
            let bodyUtf8 = NSData(bytes: data!, length: data!.count)
            let body = NSString(data: bodyUtf8, encoding: NSUTF8StringEncoding) as! String
            let response = body.componentsSeparatedByString(";")
            switch response[0] {
            case "1": self.alertMessage("对方同意了您的邀请！")
            case "2": self.alertMessage("对方决绝了您的邀请！")
            case "3": self.alertMessage("服务器内部错误，请稍后再试！")
            default:
                break;
            }
        }
    }
    
    func alertMessage(msg: String) {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func returnButton_TouchUpInside(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectButton_TouchUpInside(sender: UIButton) {
        self.indicatorView.startAnimating()
        self.indicatorLabel.hidden = false        
        
        let gameNameLabel = sender.superview?.superview?.viewWithTag(1) as! UILabel
        let gameName = gameNameLabel.text
        SocketMgr.sharedSocketMgr.challengeFriend(self.friendPlayerName!, gameName: gameName!)
    }
}
