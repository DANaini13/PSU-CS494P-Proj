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
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sendMessageButton.layer.zPosition = 100
        messageTextField.layer.zPosition = 100
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let indexPath = IndexPath(row: messageList.count-1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: false)
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
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
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

}
