import UIKit

class RegisterViewController: UIViewController {
    
    @IBOutlet weak var playerNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordAgainTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
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
        }
        
        let password = self.passwordTextField.text!
        if password.isEmpty {
            self.alertMessage("密码不能为空！")
        }
        
        let passwordAgain = self.passwordAgainTextField.text!
        if passwordAgain.isEmpty {
            self.alertMessage("确认密码不能为空！")
        }
        
        if password != passwordAgain {
            self.alertMessage("两次密码输入不一致，请重新输入！")
        }
        
        
    }
    
    func alertMessage(msg: String) {
        let alert = UIAlertController(title: "提示", message: msg, preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
