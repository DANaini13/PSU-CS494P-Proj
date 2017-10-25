package com.nasoftware.Server;

import com.nasoftware.Common.ProtocolInfo;

import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.net.Socket;
import java.util.LinkedList;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import static com.nasoftware.Common.ProtocolInfo.*;
import static com.nasoftware.Server.Database.chatServerDistributor;
import static com.nasoftware.Server.Database.roomDistributor;


/**
 * Created by zeyongshan on 10/23/17.
 */
public class ChatServer extends Thread {

    private LinkedList<String> messageSendingList = new LinkedList<String>();
    private Lock lock = new ReentrantLock();
    private Socket server;
    private String userName;

    public final int userID;


    public ChatServer(Socket server, int userID) {
        this.server = server;
        this.userID = userID;
    }

    public void addPacketToSend(String message) {
        lock.lock();
        messageSendingList.add(message);
        lock.unlock();
    }

    private void sendUnsentPackets() {
        lock.lock();
        if(messageSendingList.size() <= 0) {
            lock.unlock();
            return;
        }
        try {
            DataOutputStream out = new DataOutputStream(server.getOutputStream());
            out.writeUTF(messageSendingList.removeFirst());
           // System.err.println("send message to " + userID);
        } catch (IOException e) {
            //e.printStackTrace();
        } finally {
            lock.unlock();
        }

    }



    public void run() {
        NewMessageChecker checker = new NewMessageChecker(server, userID);
        checker.start();
        while(true) {
            try {
                server.sendUrgentData(0xFF);
                sleep(50);
                sendUnsentPackets();
            } catch (IOException e) {
                break;
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        if (!chatServerDistributor.removeFormDistributor(userID)) {
            System.err.println("failed remove from hashTable");
        }
        System.out.println(userID + " finished");
    }

    class NewMessageChecker extends Thread {
        private Socket server;
        private int userID;

        public NewMessageChecker(Socket server, int userID) {
            this.server = server;
            this.userID = userID;
        }

        public void run() {
            // Packet parser:
            while(true) {
                try {
                    DataInputStream in = new DataInputStream(server.getInputStream());
                    String packet = in.readUTF();
                    // header parser:
                    String header = packet.split(ProtocolInfo.requestSplitter)[0];
                    switch (header) {
                        case setHeader:
                            SETParser(packet);
                            break;
                        case sendHeader:
                            SENDParser(packet);
                            break;
                        case goHeader:
                            break;
                        case createHeader:
                            break;
                        default:
                            //return;
                    }
                } catch (IOException e) {
                    break;
                }
            }
        }

        private void SETParser(String packet) {
            if (!requestChecker(packet, setHeader, requestSplitter)) {
                addPacketToSend(setHeader + requestSplitter + failedText);
            }
            String name = packet.split(requestSplitter)[1];
            userName = name;
            addPacketToSend(setHeader + requestSplitter + successText);
        }

        private void SENDParser(String packet) {
            if (!requestChecker(packet, sendHeader, requestSplitter)) {
                addPacketToSend(sendHeader + requestSplitter + failedText);
            }
            String rest = packet.split(requestSplitter)[1];
            if(!roomDistributor.sendMessagePacket(rest, userID, userName)){
                addPacketToSend(sendHeader + requestSplitter + failedText);
                return;
            }
            addPacketToSend(sendHeader + requestSplitter + successText);
        }

        private void GOParser(String packet) {

        }

        private boolean requestChecker(String packet, String header, String splitter) {
            String[] parts = packet.split(splitter);
            if(parts.length != 2) {
                return false;
            }
            if(!parts[0].equals(header)) {
                return false;
            }
            return true;
        }
    }

}








