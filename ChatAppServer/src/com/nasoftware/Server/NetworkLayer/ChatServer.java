package com.nasoftware.Server.NetworkLayer;

import com.nasoftware.Common.ProtocolInfo;
import com.nasoftware.Server.DataLayer.Database;
import com.nasoftware.Server.LogicalLayer.Courier;

import java.io.*;
import java.net.Socket;
import java.util.LinkedList;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import static com.nasoftware.Common.ProtocolInfo.*;
import static com.nasoftware.Server.DataLayer.Database.roomDistributor;


/**
 * Created by zeyongshan on 10/23/17.
 */
public class ChatServer extends Thread {

    private LinkedList<String> messageSendingList = new LinkedList<String>();
    private LinkedList<Integer> roomKeyList = new LinkedList<Integer>();
    private Lock lock = new ReentrantLock();
    private Socket server;
    private String userName;
    private DataOutputStream out;
    private boolean logInStatus = false;

    public final int userID;


    public String toString() {
        if(!logInStatus) {
            return "";
        }
        String result = "---------------------------------\n";
        result += "NickedName: " + userName + "\n";
        result += "dynamic id: " + userID + "\n";
        result += "room list:  " + "\n";
        for (Integer x: roomKeyList) {
            result += "\t" + "room " + x + "\n";
        }
        result += "Thread:  " + getName() + "\n";
        result += "---------------------------------";
        return result;
    }

    public final String getUserName() {
        return userName;
    }

    public boolean isLogIn() {
        return logInStatus;
    }


    public ChatServer(Socket server, int userID) {
        this.server = server;
        this.userID = userID;
        try {
            out = new DataOutputStream(server.getOutputStream());
        } catch (IOException e) {
            e.printStackTrace();
        }
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
            String packet = messageSendingList.removeFirst();
            packet = endPointKey + packet + endPointKey;
            byte[] str = packet.getBytes();
            out.write(str, 0, str.length);
            out.flush();
        } catch (IOException e) {
            //e.printStackTrace();
        } finally {
            lock.unlock();
        }

    }

    public void addRoomIntoRoomKeyList(int id) {
        lock.lock();
        roomKeyList.add(id);
        addPacketToSend(getListHeader + requestSplitter + personalKey + roomSplitter + generateRoomString());
        lock.unlock();
    }

    public LinkedList<Integer> getReadOnlyRoomKeyList() {
        lock.lock();
        final LinkedList<Integer> list = roomKeyList;
        lock.unlock();
        return list;
    }

    private String generateRoomString() {
        StringBuilder resultBuilder = new StringBuilder();
        for(Integer x: roomKeyList) {
            resultBuilder.append(x.toString());
            resultBuilder.append("-");
        }
        if(resultBuilder.toString().length() != 0) {
            resultBuilder = new StringBuilder(resultBuilder.substring(0, resultBuilder.length()-1));
        }
        return resultBuilder.toString();
    }

    public void run() {
        NewMessageChecker checker = new NewMessageChecker(server);
        checker.start();
        while(true) {
            try {
                server.sendUrgentData(0xFF);
                sleep(100);
                sendUnsentPackets();
            } catch (IOException e) {
                break;
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
        Courier courier = new Courier();
        courier.removeFromDatabase(userID, roomKeyList);
    }

    class NewMessageChecker extends Thread {
        private Socket server;

        public NewMessageChecker(Socket server) {
            this.server = server;
        }

        private String charArrToString(char arr[]) {
            StringBuilder stringBuilder = new StringBuilder();
            for(int i=0; i<arr.length && arr[i] != '\0'; ++i) {
                stringBuilder.append(arr[i]);
            }
            return stringBuilder.toString();
        }


        public void run() {
            // Packet parser:
            try {
                BufferedReader in = new BufferedReader(new InputStreamReader(server.getInputStream()));
                char arr[] = new char[350];
                while (in.read(arr) != -1) {
                    String packet = charArrToString(arr);
                    String header = packet.split(ProtocolInfo.requestSplitter)[0];
                        if(!header.equals(addHeader)&&!header.equals(logInHeader) && !logInStatus) {
                            break;
                        }
                        switch (header) {
                            case setHeader:
                                SETParser(packet);
                                break;
                            case sendHeader:
                                SENDParser(packet);
                                break;
                            case goHeader:
                                GOParser(packet);
                                break;
                            case createHeader:
                                CREATEParser(packet);
                                break;
                            case addHeader:
                                ADDParser(packet);
                                break;
                            case logInHeader:
                                LOGINParser(packet);
                                break;
                            case getListHeader:
                                GETLISTParser(packet);
                                break;
                            case getUserHeader:
                                GETUSERParser(packet);
                                break;
                            default:
                                break;
                        }
                }
            } catch (IOException e) {
                e.printStackTrace();
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
            Courier courier = new Courier();
            if(!courier.sendMessagePacket(roomDistributor, rest, userID, userName)){
                addPacketToSend(sendHeader + requestSplitter + failedText);
                return;
            }
            addPacketToSend(sendHeader + requestSplitter + successText);
        }

        private void GOParser(String packet) {
            if (!requestChecker(packet, goHeader, requestSplitter)) {
                addPacketToSend(goHeader + requestSplitter + failedText);
                return;
            }
            String rest = packet.split(requestSplitter)[1];
            Courier courier = new Courier();
            if(!courier.addMemberToRoom(userID, roomDistributor, rest)) {
                addPacketToSend(goHeader + requestSplitter + failedText);
                return;
            }
            addPacketToSend(goHeader + requestSplitter + successText);
        }

        private void CREATEParser(String packet) {
            if (!requestChecker(packet, createHeader, requestSplitter)) {
                addPacketToSend(createHeader + requestSplitter + failedText);
                return;
            }
            String rest = packet.split(requestSplitter)[1];
            Courier courier = new Courier();
            Integer result = courier.createNewRoom(userID, roomDistributor, rest);
            if(result == null) {
                addPacketToSend(createHeader + requestSplitter + failedText);
                return;
            }
            addRoomIntoRoomKeyList(result); // check me
            addPacketToSend(createHeader + requestSplitter + roomHeader + contentSplitter + result);
        }

        private void ADDParser(String packet) {
            if (!requestChecker(packet, addHeader, requestSplitter)) {
                addPacketToSend(addHeader + requestSplitter + failedText);
                return;
            }
            String rest = packet.split(requestSplitter)[1];
            String parts[] = rest.split(contentSplitter);
            if (parts.length != 2) {
                addPacketToSend(logInHeader + requestSplitter + failedText);
                return;
            }
            Courier courier = new Courier();
            if (courier.addAccount(parts[0], parts[1])) {
                addPacketToSend(addHeader + requestSplitter + successText);
                return;
            }
            addPacketToSend(addHeader + requestSplitter + failedText);
        }

        private void LOGINParser(String packet) {
            if (!requestChecker(packet, logInHeader, requestSplitter)) {
                addPacketToSend(logInHeader + requestSplitter + failedText);
                return;
            }
            String rest = packet.split(requestSplitter)[1];
            String parts[] = rest.split(contentSplitter);
            if (parts.length != 2) {
                addPacketToSend(logInHeader + requestSplitter + failedText);
                return;
            }
            Courier courier = new Courier();
            if (courier.checkAccountPassword(parts[0], parts[1])) {
                addPacketToSend(logInHeader + requestSplitter + userID);
                logInStatus = true;
                return;
            }
            addPacketToSend(logInHeader + requestSplitter + failedText);
        }

        private void GETLISTParser(String packet) {
            if (!requestChecker(packet, getListHeader, requestSplitter)) {
                addPacketToSend(getListHeader + requestSplitter + failedText);
                return;
            }
            String rest = packet.split(requestSplitter)[1];
            Courier courier = new Courier();
            if(rest.equals(globalKey)) {
                String result = courier.getRoomList();
                addPacketToSend(getListHeader + requestSplitter + globalKey + roomSplitter + result);
            }else if(rest.equals(personalKey)){
                addPacketToSend(getListHeader + requestSplitter + personalKey + roomSplitter + generateRoomString());
            }else {
                addPacketToSend(getListHeader + requestSplitter + failedText);
            }
        }

        private void GETUSERParser(String packet) {
            if (!requestChecker(packet, getUserHeader, requestSplitter)) {
                addPacketToSend(getUserHeader + requestSplitter + failedText);
                return;
            }
            String rest = packet.split(requestSplitter)[1];
            Courier courier = new Courier();
            String list = courier.getUserList(rest);
            addPacketToSend(getUserHeader + requestSplitter + list);
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








