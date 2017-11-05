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
    var messageList:[Message] = []
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var messageTextField: UITextField!
    @IBOutlet weak var backgroundLabel: UILabel!
    let keyboardOffset:CGFloat = 250
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendMessageButton.layer.zPosition = 100
        messageTextField.layer.zPosition = 100
        self.tabBarController?.tabBar.isHidden = true
        DispatchQueue.main.async { [weak self] in
            let indexPath = IndexPath(row: (self?.messageList.count)!-1, section: 0)
            self?.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if keyBoardShowed {
            self.view.frame.origin.y -= keyboardOffset
            keyBoardShowed = true
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        var i = 0
        var messageList:[Message] = []
        while i<30 {
            var messageContent = ""
            var j = 0
            while j < i {
                messageContent += "Hello World "
                j += 1
            }
            messageContent += "\(i)"
            messageList.append(Message(messageContent: messageContent, roomNo: 0, timeString: "currentTime", senderName: "Shan"))
            i += 1
        }
        self.messageList = messageList
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: .UIKeyboardWillHide, object: nil)
        let tapHandler = #selector(hideKeyBoard(byReactingTo:))
        let tapGesture = UITapGestureRecognizer(target: self, action: tapHandler)
        self.view.addGestureRecognizer(tapGesture)
    }
    
    @IBAction func touchMessaneButton(_ sender: UIButton) {
        messageTextField.resignFirstResponder()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messageList.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell
        if indexPath.row % 2 == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "leftCell", for: indexPath)
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "rightCell", for: indexPath)
        }
        
        let message = messageList[indexPath.row]
        if let leftCell = cell as? MessageCellLeft {
            leftCell.message = message
        }

        return cell
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
        if self.view.frame.origin.y == 0 {
            return
        }
        self.view.frame.origin.y += keyboardOffset
    }
    
    @objc private func hideKeyBoard(byReactingTo tapGestureRecongnizer: UITapGestureRecognizer) {
        if tapGestureRecongnizer.state == .ended {
            messageTextField.resignFirstResponder()
            if !keyBoardShowed {
                return
            }
            self.view.frame.origin.y += keyboardOffset
            keyBoardShowed = false
        }
    }

}
