//
//  ChatViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/5/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        if let chatCell = cell as? ChatCell {
            chatCell.room = Room(name: "Room\(indexPath.row + 1)", lastMessage: "This is the last message!")
        }
        return cell
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
