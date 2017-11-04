package com.nasoftware.Server.AdminInteraction;

import com.nasoftware.Common.HostInfo;
import com.nasoftware.Server.DataLayer.Database;
import com.nasoftware.Server.NetworkLayer.ChatServer;

import javax.xml.crypto.Data;
import java.util.HashMap;
import java.util.Scanner;

/**
 * Created by zeyongshan on 11/4/17.
 * The class that display information for admins.
 */
public class Interactor extends Thread {

    public void run() {
        System.out.println(
                "=================================================" + "\n" +
                "|     Welcome to user CS494 Chat Server         |" + "\n" +
                "|     The Port using is:     " + HostInfo.port + "\t\t\t\t|" + "\n" +
                "|     Detail of this server:                    |" + "\n" +
                "|         1. using TCP/IP connection            |" + "\n" +
                "|         2. multiple threading                 |" + "\n" +
                "|         3. offer room and personal chatting   |" + "\n" +
                "|     Protocols:                                |" + "\n" +
                "|         1. SET     // set nickname            |" + "\n" +
                "|         2. SEND    // send message            |" + "\n" +
                "|         3. CREATE  // create a room           |" + "\n" +
                "|         4. GO      // transfer to other room  |" + "\n" +
                "|         5. LOGIN   // log in                  |" + "\n" +
                "|         6. ADD     // sign up                 |" + "\n" +
                "|-----------------------------------------------|" + "\n" +
                "|    See ProtocolInfo and HostInfo for detail   |" + "\n" +
                "|    *********** Server Started! ************   |" + "\n" +
                "=================================================" + "\n\n\n\n"
        );

        String userInput = "";
        Scanner scanner = new Scanner(System.in);
        while (!userInput.equals("0")) {
            System.out.println("0. stop the server\n" +
                    "1. check the online user\n" +
                    "2. check the personal account information\n" +
                    "3. check the running rooms\n");
            userInput = scanner.nextLine();

            switch (userInput) {
                case "0":
                    System.exit(0);
                    break;
                case "1":
                    System.out.println("online users:");
                    HashMap<Integer, ChatServer> map = Database.chatServerDistributor.getReadOnlyMap();
                    if(map.size() == 0) {
                        System.out.println("Empty");
                    }
                    for (HashMap.Entry<Integer, ChatServer> entry: map.entrySet()) {
                        System.out.println(entry.getValue());
                    }
                    break;
                case "2":
                    System.out.println("Account List:");
                    HashMap<String, String> map1 = Database.accountMap.getReadOnlyHashMap();
                    for (HashMap.Entry<String, String> entry: map1.entrySet()) {
                        System.out.println(entry.getKey());
                    }
                    break;
                case "3":
                    break;
                default:
                    System.err.println("Input wrong!");
            }
            System.out.println("\n\n");
        }
    }
}
