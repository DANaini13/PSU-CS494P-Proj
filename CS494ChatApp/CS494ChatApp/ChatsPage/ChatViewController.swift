//
//  ChatViewController.swift
//  CS494ChatApp
//
//  Created by zeyong shan on 11/5/17.
//  Copyright © 2017 zeyong shan. All rights reserved.
//

import UIKit

class ChatViewController: UITableViewController {
    
    var container = ChatsContainer()
    
    override func viewDidLoad() {
        setUpdateRoomHandler()
        addNewMessageListener()
        container.check()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return container.length
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatCell", for: indexPath)
        if let chatCell = cell as? ChatCell {
            let room = container.list[indexPath.row]
            let number = room.roomNumber
            let lastMessage = room.messageList.last?.message ?? "   "
            chatCell.room = Room(name: "Room \(number)", lastMessage: lastMessage)
            chatCell.newMessageNum = room.unreadMessage
        }
        return cell
    }


    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMessages" {
            if let controller = segue.destination as? MessageViewController,
                let cell = sender as? ChatCell{
                controller.title = cell.room?.name
                let roomNo = controller.title?.components(separatedBy: " ")[1]
                controller.messageRoom = container.getRoom(with: Int(roomNo!)!)
                controller.messageRoom?.unreadMessage = 0
                cell.newMessageNum = 0
            }
        }
    }

    
    func addNewMessageListener() {
        PacketsCheckerAndSender.setNewMessageHandler() {
            [weak self] newMessage in
            if let messageViewController =
                self?.navigationController?.visibleViewController as? MessageViewController {
                if messageViewController.messageRoom?.roomNumber == newMessage.roomNumber {
                    self?.container.addMessageToRoomsWithoutIncrementUnread(message: newMessage)
                    messageViewController.updateUI()
                }else {
                    self?.container.addMessageToRooms(message: newMessage)
                }
            }else {
                self?.container.addMessageToRooms(message: newMessage)
            }
        }
    }
    
    func setUpdateRoomHandler() {
        container.updateHandler = {
            DispatchQueue.main.async {
                [weak self] in
                self?.tableView.reloadData()
                
            }
        }
    }
}
