import UIKit

class PlayerListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var playerList: [String]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        GameMgr.sharedGameMgr.playerListViewController = self
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
        SocketMgr.sharedSocketMgr.fetchPlayerList()
    }
    
    @IBAction func flushButton_TouchUpInside(sender: UIButton) {
        SocketMgr.sharedSocketMgr.fetchPlayerList()
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    func loadPlayerList(data: [UInt8]?) {
        if data != nil {
            let bodyUtf8 = NSData(bytes: data!, length: data!.count)
            let body = NSString(data: bodyUtf8, encoding: NSUTF8StringEncoding) as! String
            self.playerList = body.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: ";")).componentsSeparatedByString(";")
        }
        dispatch_async(dispatch_get_main_queue()) { 
            self.tableView.reloadData()
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCellWithIdentifier("playerCell", forIndexPath: indexPath)
        let playerNameLabel = cell?.viewWithTag(1) as! UILabel
        playerNameLabel.text = self.playerList?[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.playerList != nil {
            return self.playerList!.count
        } else {
            return 0
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "goToGameList" {
            let gameListViewController = segue.destinationViewController as! GameListViewController
            let gameCell = (sender as! UIView).superview!.superview!
            let friendPlayerName = (gameCell.viewWithTag(1) as! UILabel).text!
            gameListViewController.friendPlayerName = friendPlayerName
        }
    }
}
