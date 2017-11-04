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
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
        let tapHandler = #selector(hideKeyBoard(byReactingTo:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapHandler)
        self.view.addGestureRecognizer(tapGesture)
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if keyBoardShowed {
            self.view.frame.origin.y -= 200
            keyBoardShowed = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                DispatchQueue.main.async {
                    self?.waitingIndicator.stopAnimating()
                    if result {
                        print("log in successfully!")
                        self?.hideKeyBoard()
                        self?.performSegue(withIdentifier: "mainSection", sender: self)
                    }else {
                        print("log in failed!")
                    }
                }
            }
        }
    }
    
    private var keyBoardShowed = false
    
    @objc private func keyboardWillShow(sender: NSNotification) {
        if keyBoardShowed {
            return
        }
        self.view.frame.origin.y -= 200
        keyBoardShowed = true
    }
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        if !keyBoardShowed {
            return
        }
        self.view.frame.origin.y += 200
        keyBoardShowed = false
    }
    
    private func hideKeyBoard() {
            userNameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            if !keyBoardShowed {
                return
            }
            self.view.frame.origin.y += 200
            keyBoardShowed = false
    }
    
    @objc private func hideKeyBoard(byReactingTo tapGestureRecongnizer: UITapGestureRecognizer) {
        if tapGestureRecongnizer.state == .ended {
            hideKeyBoard()
        }
    }
    
}
