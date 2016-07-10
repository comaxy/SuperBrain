import UIKit

class GameListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    
    var gameList: [String] = []
    var friendPlayerName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.tableFooterView = UIView(frame: CGRectZero)
        
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
    
    @IBAction func returnButton_TouchUpInside(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func selectButton_TouchUpInside(sender: UIButton) {
        let gameNameLabel = sender.superview?.superview?.viewWithTag(1) as! UILabel
        let gameName = gameNameLabel.text
        SocketMgr.sharedSocketMgr.challengeFriend(self.friendPlayerName!, gameName: gameName!)
    }
}
