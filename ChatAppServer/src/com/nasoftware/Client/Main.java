package com.nasoftware.Client;

import com.nasoftware.Common.HostInfo;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.Scanner;

/**
 * Created by zeyongshan on 10/24/17.
 */
public class Main {

    public static void main(String[] args) {
        // write your code here
        try {
            Socket client = new Socket(HostInfo.address, HostInfo.port);
            MessageChecker messageChecker = new MessageChecker(new DataInputStream(client.getInputStream()));
            messageChecker.start();
            MessageSender messageSender = new MessageSender(new DataOutputStream(client.getOutputStream()));
            messageSender.start();
        } catch (IOException e) {
            System.err.println("Connection refused!");
        }
    }
}

class MessageChecker extends Thread {
    private DataInputStream in;

    public MessageChecker(DataInputStream in){
        this.in = in;
    }

    public void run() {
        while(true) {
            try {
                String content = in.readUTF();
                System.out.println(content);
            } catch (IOException e) {
                break;
            }
        }
    }
}

class MessageSender extends Thread {
    private DataOutputStream out;

    public MessageSender(DataOutputStream out) {
        this.out = out;
    }

    public void run() {
        try {
            Scanner scanner = new Scanner(System.in);
            while (true) {
                String context = scanner.nextLine();
                out.writeUTF(context);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
