//
//  RapidCalculationViewController.swift
//  SuperBrain
//
//  Created by Theresa on 16/7/20.
//  Copyright © 2016年 cynhard. All rights reserved.
//

import UIKit

class RapidCalculationViewController: UIViewController {
    @IBOutlet weak var resultTextField: UITextField!
    @IBOutlet weak var number2Label: UILabel!
    @IBOutlet weak var operatorLabel: UILabel!
    @IBOutlet weak var number1Label: UILabel!
    
    override func viewDidLoad() {
        self.resultTextField.keyboardType = .NumberPad
        self.resultTextField.becomeFirstResponder()
    }
}
