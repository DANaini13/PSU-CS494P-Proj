//
//  SignUpViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/2/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    /**
     The object of LoginAndSignUpModel
     Check the LoginAndSignUpModel.swift for details
     - Version: 1.0
     */
    private let loginAndSignUpModel = LoginAndSignUpModel()
    
    /**
     the user name text field that let user input the user name
     - Version: 1.0
     */
    @IBOutlet weak var usernameTextField: UITextField!
    
    /**
     the password text field that let user input the password
     - Version: 1.0
     */
    @IBOutlet weak var passwordTextField: UITextField!
    
    /**
     the password text field that used to confirm the password that user
     input is correct
     - Version: 1.0
     */
    @IBOutlet weak var confirmTextField: UITextField!
    
    let keyboardOffset:CGFloat = 200
    
    override func viewDidLoad() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
        let tapHandler = #selector(hideKeyBoard(byReactingTo:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapHandler)
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func touchCreateButton(_ sender: UIButton) {
        guard confirmTextField.text! == passwordTextField.text! && passwordTextField.text!.count >= 6 else {
            return;
        }
        if let account = usernameTextField.text, let password = passwordTextField.text {
            waitingIndicator.startAnimating()
            print("account: \(account)   password: \(password)")
            loginAndSignUpModel.signUp(account: account, password: password) {
                [weak self] (result) in
                DispatchQueue.main.async {
                    self?.waitingIndicator.stopAnimating()
                    if result {
                        let alertController = UIAlertController(title: "Hint", message: "Sign up successfully!", preferredStyle: .alert)
                        let okAcount = UIAlertAction(title: "Ok", style: .cancel, handler: {
                            action in
                        })
                        alertController.addAction(okAcount)
                        self?.present(alertController, animated: true, completion: nil)
                    }else {
                        let alertController = UIAlertController(title: "Hint", message: "Account already exist!", preferredStyle: .alert)
                        let okAcount = UIAlertAction(title: "Ok", style: .cancel, handler: {
                            action in
                        })
                        alertController.addAction(okAcount)
                        self?.present(alertController, animated: true, completion: nil)
                    }
                }
                
            }
        }
    }
    
    @IBOutlet weak var waitingIndicator: UIActivityIndicatorView!
    
    private var keyBoardShowed = false
    
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
    
    @objc private func keyboardWillHide(sender: NSNotification) {
        if !keyBoardShowed {
            return
        }
        keyBoardShowed = false
        self.view.frame.origin.y = 0
    }
    
    @objc private func hideKeyBoard(byReactingTo tapGestureRecongnizer: UITapGestureRecognizer) {
        if tapGestureRecongnizer.state == .ended {
            usernameTextField.resignFirstResponder()
            passwordTextField.resignFirstResponder()
            confirmTextField.resignFirstResponder()
            if !keyBoardShowed {
                return
            }
            self.view.frame.origin.y += keyboardOffset
            keyBoardShowed = false
        }
    }
}
