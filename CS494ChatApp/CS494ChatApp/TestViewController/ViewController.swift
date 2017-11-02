//
//  ViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 10/25/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func touchSend(_ sender: UIButton) {
    }
    
    @IBOutlet weak var screen: UILabel!
    @IBOutlet weak var text: UITextField!
}

