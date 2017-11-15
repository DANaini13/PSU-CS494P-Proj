//
//  MessageTableViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/4/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var backgroundLabel: UILabel!
    private let keyboardOffset:CGFloat = 250
    private let messageSender = MessageSender()
    
    var messageRoom:MessageRoom?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        adjustKeyboard()
        updateUI()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageButton.layer.zPosition = 100
        messageTextField.layer.zPosition = 100
        addKeyboardListeners()
    }
    
    @IBAction func touchSendMessageButton(_ sender: UIButton) {
        guard let messageRoom = self.messageRoom else {
            return
        }
        print(messageRoom.messageList.count)
        let roomNumber = messageRoom.roomNumber
        let content = messageTextField.text!
        messageTextField.text = ""
        messageSender.sendMessage(content: content, roomNo: roomNumber) {
            result in
            if result {
                print("send message successful")
            }else {
                print("send message failed")
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageRoom!.messageList.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        let messageList = messageRoom?.messageList
        let message = messageList![indexPath.row]
        let userDefault = UserDefaults.standard
        let myID = userDefault.value(forKey: "dynamic_id") as! Int
        if myID == message.dynamicId {
            cell = tableView.dequeueReusableCell(withIdentifier: "rightCell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath)
        }
        
        if let leftCell = cell as? MessageCell {
            leftCell.message = message
        }
        
        return cell
    }
    
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let messageList = self?.messageRoom?.messageList else {
                return
            }
            guard messageList.count > 0 else {
                return
            }
            self?.tableView.reloadData()
            if messageList.count > 5{
                let indexPath1 = IndexPath(row: messageList.count - 1, section: 0)
                self?.tableView.scrollToRow(at: indexPath1, at: .bottom, animated: true)
            }
        }
    }
    
    func adjustKeyboard() {
        if keyBoardShowed {
            self.view.frame.origin.y -= keyboardOffset
            keyBoardShowed = true
        }
    }
    
    func addKeyboardListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
        let tapHandler = #selector(hideKeyBoard(byReactingTo:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapHandler)
        self.view.addGestureRecognizer(tapGesture)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
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
            messageTextField.resignFirstResponder()
            if !keyBoardShowed {
                return
            }
            self.view.frame.origin.y = 0
            keyBoardShowed = false
        }
    }

}
