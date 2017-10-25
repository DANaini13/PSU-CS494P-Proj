package com.nasoftware.Server;

import com.nasoftware.Common.HostInfo;
import com.nasoftware.Server.NetworkLayer.ChatServerSocket;

public class Main {

    public static void main(String[] args) {
	// write your code here
        ChatServerSocket chatServer = new ChatServerSocket(HostInfo.port);
        chatServer.start();
    }
}
