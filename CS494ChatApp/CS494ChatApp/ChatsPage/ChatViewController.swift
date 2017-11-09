//
//  ChatViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/5/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController {
    
    var chatsModel = ChatsModel()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
        chatsModel.updateHandler = {[weak self] in self?.tableView.reloadData()}
        chatsModel.startChecking()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return chatsModel.length
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        if let chatCell = cell as? ChatCell {
            chatCell.room = Room(name: "Room\(chatsModel.list[indexPath.row])", lastMessage: "This is the last message!")
        }
        return cell
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessages" {
            if let controller = segue.destination as? MessageViewController,
                let cell = sender as? ChatCell{
                controller.title = cell.room?.name
            }
        }
    }

}
