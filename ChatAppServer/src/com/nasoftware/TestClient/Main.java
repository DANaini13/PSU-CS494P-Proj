package com.nasoftware.TestClient;

import com.nasoftware.Common.HostInfo;

import java.io.BufferedInputStream;
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
                BufferedInputStream bis = new BufferedInputStream(in);

                DataInputStream dis = new DataInputStream(bis);
                byte[] bytes = new byte[1]; // 一次读取一个byte
                String ret = "";
                while (dis.read(bytes) != -1) {
                    ret += BytesHexString(bytes);
                    if (dis.available() == 0) { //一个请求
                        System.out.println(hexStr2Str(ret));
                        ret = "";
                    }
                }

            } catch (IOException e) {
                break;
            }
        }
    }

    private String hexStr2Str(String hexStr)
    {
        String str = "0123456789ABCDEF";
        char[] hexs = hexStr.toCharArray();
        byte[] bytes = new byte[hexStr.length() / 2];
        int n;

        for (int i = 0; i < bytes.length; i++)
        {
            n = str.indexOf(hexs[2 * i]) * 16;
            n += str.indexOf(hexs[2 * i + 1]);
            bytes[i] = (byte) (n & 0xff);
        }
        return new String(bytes);
    }

    private String BytesHexString(byte[] b) {
        String ret = "";
        for (int i = 0; i < b.length; i++) {
            String hex = Integer.toHexString(b[i] & 0xFF);
            if (hex.length() == 1) {
                hex = '0' + hex;
            }
            ret += hex.toUpperCase();
        }
        return ret;
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
                byte[] str = context.getBytes();
                out.write(str, 0, str.length);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
