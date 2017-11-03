//
//  LogInViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    let loginAndSignUpModel = LoginAndSignUpModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        PacketsCheckerAndSender.start()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    
    @IBAction func touchTheEye(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    @IBAction func touchLoginButton(_ sender: UIButton) {
        if let username = userNameTextField.text,
            let password = passwordTextField.text {
            waitingIndicator.startAnimating()
            loginAndSignUpModel.logIn(account: username, password: password) {
                [weak self] (result) in
                if result {
                    print("log in successfully!")
                }
                DispatchQueue.main.async {
                    self?.waitingIndicator.stopAnimating()
                }
            }
        }
    }
    
}
