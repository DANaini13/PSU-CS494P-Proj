//
//  MeViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/8/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class MeViewController: UIViewController {

    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var waitingIndecitor: UIActivityIndicatorView!
    
    
    let meModel = MeModel()
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addKeyboardListeners()
    }
    
    let keyboardOffset:CGFloat = 200
    
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
        if self.view.frame.origin.y == 0 {
            return
        }
        self.view.frame.origin.y += keyboardOffset
    }
    
    @objc private func hideKeyBoard(byReactingTo tapGestureRecongnizer: UITapGestureRecognizer) {
        if tapGestureRecongnizer.state == .ended {
            nickNameTextField.resignFirstResponder()
            if !keyBoardShowed {
                return
            }
            self.view.frame.origin.y += keyboardOffset
            keyBoardShowed = false
        }
    }
    
    @IBAction func touchSaveButton(_ sender: UIButton) {
        waitingIndecitor.startAnimating()
        if let name = nickNameTextField.text {
            meModel.setNickedName(name: name) {
                result in
                DispatchQueue.main.async {
                    [weak self] in
                    self?.waitingIndecitor.stopAnimating()
                    if result {
                        let alertController = UIAlertController(title: "Hint", message: "set name successfully!", preferredStyle: .alert)
                        let okAcount = UIAlertAction(title: "Ok", style: .cancel, handler: {
                            action in
                        })
                        alertController.addAction(okAcount)
                        self?.present(alertController, animated: true, completion: nil)
                    }else {
                        let alertController = UIAlertController(title: "Hint", message: "log in status unexpectly!", preferredStyle: .alert)
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
    
    func addKeyboardListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
        let tapHandler = #selector(hideKeyBoard(byReactingTo:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapHandler)
        self.view.addGestureRecognizer(tapGesture)
    }
    
    private var keyBoardShowed = false
    
}
