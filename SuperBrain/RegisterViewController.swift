import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    var indicatorView: UIActivityIndicatorView!
    var indicatorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        self.indicatorLabel.text = "正在注册，请稍候..."
        self.indicatorLabel.center = CGPointMake(self.view.center.x, self.view.center.y + 40)
        self.view.addSubview(self.indicatorLabel)
        self.indicatorLabel.hidden = true
    }
    
    @IBAction func playerNameTextField_DidEndOnExit(sender: UITextField) {
        self.passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func passwordTextField_DidEndOnExit(sender: UITextField) {
        self.passwordAgainTextField.becomeFirstResponder()
    }
    
    @IBAction func passwordAgainTextField_DidEndOnExit(sender: UITextField) {
        sender.resignFirstResponder()
    }
    
    @IBAction func view_TouchDown(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    @IBAction func registerButton_TouchUpInside(sender: AnyObject) {
        let playerName = self.playerNameTextField.text!.stringByTrimmingCharactersInSet(NSCharacterSet(charactersInString: " "))
        if playerName.isEmpty {
            self.alertMessage("用户名不能为空！")
            return
        }
        
        let password = self.passwordTextField.text!
        if password.isEmpty {
            self.alertMessage("密码不能为空！")
            return
        }
        
        let passwordAgain = self.passwordAgainTextField.text!
        if passwordAgain.isEmpty {
            self.alertMessage("确认密码不能为空！")
            return
        }
        
        if password != passwordAgain {
            self.alertMessage("两次密码输入不一致，请重新输入！")
            return
        }
        
        self.view.endEditing(true)
        
        self.indicatorView.startAnimating()
        self.indicatorLabel.hidden = false
        
        dispatch_async(SocketMgr.sharedSocketMgr.socket_queue) {
            self.sendRegisterData_async(playerName, password: password)
            self.recvRegisterResult_async();
        }
    }
    
    func alertMessage(msg: String) {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func sendRegisterData_async(playerName: String, password: String) {
        let data = NSMutableData()
        let eventId = UnsafeMutablePointer<UInt8>.alloc(1)
        eventId.initialize(SockEvent.REGISTER.rawValue)
        data.appendBytes(eventId, length: 1)
        let playerInfo = playerName + ";" + password;
        let playerInfoData = playerInfo.dataUsingEncoding(NSUTF8StringEncoding)
        let bodyLength = UnsafeMutablePointer<UInt16>.alloc(1)
        bodyLength.initialize(UInt16((playerInfoData?.length)!))
        data.appendBytes(bodyLength, length: 2)
        data.appendData(playerInfoData!)
        SocketMgr.sharedSocketMgr.client.send(data: data)
    }
    
    func recvRegisterResult_async() {
        var recvData = SocketMgr.sharedSocketMgr.client.read(3)!
        let eventId = recvData[0]
        let recvDataPtr = UnsafeMutableBufferPointer<UInt8>(start: &recvData, count: recvData.count)
        let lengthPtr_UInt8 = (recvDataPtr.baseAddress as UnsafeMutablePointer<UInt8>).successor()
        let lengthPtr_UInt16 = unsafeBitCast(lengthPtr_UInt8, UnsafePointer<UInt16>.self)
        let length = lengthPtr_UInt16.memory
        recvData = SocketMgr.sharedSocketMgr.client.read(Int(length))!
        let bodyUtf8 = NSData(bytes: recvData, length: Int(length))
        let body = NSString(data: bodyUtf8, encoding: NSUTF8StringEncoding) as! String
        print(eventId, body)
    }
}
