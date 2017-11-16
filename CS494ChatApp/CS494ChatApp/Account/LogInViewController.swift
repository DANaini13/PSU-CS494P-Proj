//
//  LogInViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit


/**
 The login view controller that interact with user to finish
 the login steps.
 */
class LogInViewController: UIViewController {

    /**
     the waiting indicator that will be displayed at the center of the screen
     - Version: 1.0
    */
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    /**
     the user name text field that let user input the user name
     - Version: 1.0
     */
    @IBOutlet weak var userNameTextField: UITextField!
    
    /**
     the password text field that let user input the password
     - Version: 1.0
     */
    @IBOutlet weak var passwordTextField: UITextField!
    
    /**
     the object of LoginAndSignUpModel, check the LoginAndSignUpModel.swift for details
     - Version: 1.0
     */
    let loginAndSignUpModel = LoginAndSignUpModel()
    
    /**
     check the message view controller for the details of keyboard response
     - Version: 1.0
    */
    let keyboardOffset:CGFloat = 200
    
    /**
     override the function viewDidLoad, initialize the keyboard listeners here.
     - Version: 1.0
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        PacketsCheckerAndSender.checking = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
        let tapHandler = #selector(hideKeyBoard(byReactingTo:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapHandler)
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    /**
     override the function viewDidAppear, adjust view position here.
     - Version: 1.0
     */
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if keyBoardShowed {
            self.view.frame.origin.y -= 200
            keyBoardShowed = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /**
     perform the operation that touched the eye button at the right side
     of the password text field, it will show the password to the user.
     - Version: 1.0
     */
    @IBAction func touchTheEye(_ sender: UIButton) {
        passwordTextField.isSecureTextEntry = !passwordTextField.isSecureTextEntry
    }
    
    /**
     perform the operation that touched the login button.
     It will user the login and signup model to perform
     the login operation.
     - Version: 1.0
     */
    @IBAction func touchLoginButton(_ sender: UIButton) {
        print(PacketsCheckerAndSender.checking)
        if let username = userNameTextField.text,
            let password = passwordTextField.text {
            waitingIndicator.startAnimating()
            loginAndSignUpModel.logIn(account: username, password: password) {
                [weak self] (result) in
                DispatchQueue.main.async {
                    self?.waitingIndicator.stopAnimating()
                    if result >= 0 {
                        print("log in successfully!")
                        let userDefault = UserDefaults.standard
                        userDefault.set(result, forKey: "dynamic_id")
                        self?.hideKeyBoard()
                        self?.performSegue(withIdentifier: "mainSection", sender: self)
                    }else {
                        print("log in failed!")
                    }
                }
            }
        }
    }
    
    /**
     check the message view controller for the details of keyboard response
     - Version: 1.0
     */
    private var keyBoardShowed = false
    
    /**
     check the message view controller for the details of keyboard response
     - Version: 1.0
     */
    @objc private func keyboardWillShow(sender: NSNotification) {
        if keyBoardShowed {
            return
        }
        keyBoardShowed = true
        if self.view.frame.origin.y == -keyboardOffset {
            return
        }
        self.view.frame.origin.y -= keyboardOffset
    }
    
    /**
     check the message view controller for the details of keyboard response
     - Version: 1.0
     */
    @objc private func keyboardWillHide(sender: NSNotification) {
        if !keyBoardShowed {
            return
        }
        keyBoardShowed = false
        if self.view.frame.origin.y == 0 {
            return
        }
        self.view.frame.origin.y += keyboardOffset
    }
    
    /**
     check the message view controller for the details of keyboard response
     - Version: 1.0
     */
    private func hideKeyBoard() {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        if !keyBoardShowed {
            return
        }
        self.view.frame.origin.y = 0
        keyBoardShowed = false
    }
    
    /**
     check the message view controller for the details of keyboard response
     - Version: 1.0
     */
    @objc private func hideKeyBoard(byReactingTo tapGestureRecongnizer: UITapGestureRecognizer) {
        if tapGestureRecongnizer.state == .ended {
            hideKeyBoard()
        }
    }
    
}
