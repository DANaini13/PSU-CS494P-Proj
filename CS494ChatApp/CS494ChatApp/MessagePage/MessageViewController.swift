//
//  MessageTableViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/4/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    /**
     The table view that display the set of messages
     - Version: 1.0
    */
    @IBOutlet weak var tableView: UITableView!
    /**
     The send message button
     - Version: 1.0
     */
    @IBOutlet weak var sendMessageButton: UIButton!
    /**
     The message text field that the user input new message
     - Version: 1.0
     */
    @IBOutlet weak var messageTextField: UITextField!
    /**
     The label that display the specific color under the message text field
     - Version: 1.0
     */
    @IBOutlet weak var backgroundLabel: UILabel!
    
    /**
     The distance that all the views will move up when user start input messages
     - Version: 1.0
     */
    private let keyboardOffset:CGFloat = 250
    
    /**
     The message sender, which is the model of message page
     It will connect to the Web model and send messages
     - Version: 1.0
     */
    private let messageSender = MessageSender()
    
    /**
     The abstract message room that will be refreshed when new message received.
     It is a container that connect with the Chat View Controller.
     The message view controller will automatically refresh the table view
     when the message room changes. The updateUI function will be called in the
     Chat view controller
     - Version: 1.0
     */
    var messageRoom:MessageRoom?
    
    /**
     override the viewWillAppear function in the super view controller
     the view controller hide the tab bar and adjust keyboard here
     - parameter animated: the bool that show if the view should animated when it appears
     - Version: 1.0
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        adjustKeyboard()
        updateUI()
    }
    
    /**
     override the viewDidLoad function in the super view controller
     the view controller will adijust the zPosition of the send message button
     and the message text field
     - Version: 1.0
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        sendMessageButton.layer.zPosition = 100
        messageTextField.layer.zPosition = 100
        addKeyboardListeners()
    }
    
    /**
     the function that perform the touch send message button operation
     it will call use message ender inside.
     - parameter sender: the sender that active this function
     - Version: 1.0
     */
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
    
    /**
     implement the tableView function in table view Delegates
     - Version: 1.0
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageRoom!.messageList.count
    }
    
    
    /**
     implement the tableView function in table view Delegates
     - Version: 1.0
     */
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
    
    /**
     This function will updateUI when any change to the data source of the
     table view. (messageRoom is the data source)
     - Version: 1.0
     */
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let messageList = self?.messageRoom?.messageList else {
                return
            }
            guard messageList.count > 0 else {
                return
            }
            self?.tableView.reloadData()
            if messageList.count >= 2{
                let indexPath = IndexPath(row: messageList.count - 2, section: 0)
                self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
                let indexPath1 = IndexPath(row: messageList.count - 1, section: 0)
                self?.tableView.scrollToRow(at: indexPath1, at: .bottom, animated: true)
            }
        }
    }
    
    /**
     use this function to adjust the view and keyboard
     - Version: 1.0
     */
    func adjustKeyboard() {
        if keyBoardShowed {
            self.view.frame.origin.y -= keyboardOffset
            keyBoardShowed = true
        }
    }
    
    /**
     use this function to add a keyboard listener.
     It will move the views up when keyboard appear and move the views back
     when keyboard hide
     - Version: 1.0
     */
    func addKeyboardListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
        let tapHandler = #selector(hideKeyBoard(byReactingTo:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapHandler)
        self.view.addGestureRecognizer(tapGesture)
    }
    
    /**
     a variable that shows if the beyboard disappeared.
    */
    private var keyBoardShowed = false
    
    /**
     a handler of the keyboard listener
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
     a handler of the keyboard listener
     */
    @objc private func keyboardWillHide(sender: NSNotification) {
        if !keyBoardShowed {
            return
        }
        keyBoardShowed = false
        self.view.frame.origin.y = 0
    }
    
    /**
     a handler of the keyboard listener
     */
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
