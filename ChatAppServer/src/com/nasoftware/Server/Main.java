package com.nasoftware.Server;

import com.nasoftware.Common.HostInfo;

public class Main {

    public static void main(String[] args) {
	// write your code here
        ChatServerSocket chatServer = new ChatServerSocket(HostInfo.port);
        chatServer.start();
    }
}
