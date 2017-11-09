package com.nasoftware.Server.LogicalLayer;

import com.nasoftware.Common.Message;
import com.nasoftware.Common.ProtocolInfo;
import com.nasoftware.Server.DataLayer.Database;
import com.nasoftware.Server.DataLayer.RoomDistributor;
import com.nasoftware.Server.NetworkLayer.ChatServer;
import com.nasoftware.Server.DataLayer.Room;

import javax.xml.crypto.Data;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;
import java.util.Map;

import static com.nasoftware.Common.ProtocolInfo.contentSplitter;
import static com.nasoftware.Common.ProtocolInfo.roomHeader;
import static com.nasoftware.Common.ProtocolInfo.roomSplitter;

/**
 * Created by zeyongshan on 10/24/17.
 */
public class Courier{
    public boolean sendMessagePacket(RoomDistributor roomDistributor, String packet, int senderID, String senderName) {
        //packet example: ROOM-roomNumber-ROOM-MessageContent
        String splitter = roomSplitter;
        String header = roomHeader;
        String parts[] = packet.split(splitter);
        if (parts.length != 2)
            return false;
        String[] headerParts = parts[0].split(contentSplitter);
        if (headerParts.length != 2)
            return false;
        if (!headerParts[0].equals(header))
            return false;
        try {
            int roomNumber = Integer.parseInt(headerParts[1]);
            HashMap<Integer, Room> roomHashMap = roomDistributor.getReadOnlyRoomHashMap();
            if (roomHashMap.containsKey(roomNumber)) {
                Room room = roomHashMap.get(roomNumber);
                Message message = Message.createFromClientPacket(parts[1], senderID, senderName);
                if(message == null)
                    return false;
                HashMap<Integer, Integer> keyMap = room.getReadOnlyRoomMembersIDMap();
                if(!keyMap.containsKey(senderID))
                    return false;
                addMessageToRoom(message, room);
                return true;
            }
            return false;
        } catch (NumberFormatException e) {
            return false;
        }
    }

    private void addMessageToRoom(Message message, Room room) {
        String header = ProtocolInfo.roomHeader;
        String headerSplitter = ProtocolInfo.contentSplitter;
        String roomSplitter = ProtocolInfo.roomSplitter;
        Integer roomID = room.roomID;
        String packet = ProtocolInfo.sendHeader + ProtocolInfo.requestSplitter
                + header + headerSplitter
                + roomID + roomSplitter
                + message.generateMessagePacket();
        HashMap<Integer, ChatServer> map = Database.chatServerDistributor.getReadOnlyMap();
        for (HashMap.Entry<Integer, ChatServer> entry: map.entrySet()) {
            ChatServer member = entry.getValue();
            member.addPacketToSend(packet);
        }
    }

    //GO-COMMANDSPL-ROOM-roomNumber  //To server
    public boolean addMemberToRoom(int memberID, RoomDistributor roomDistributor, String packet) {
        String splitter = contentSplitter;
        String[] parts = packet.split(splitter);
        if(parts.length != 2)
            return false;
        try {
            int roomID = Integer.parseInt(parts[1]);
            HashMap<Integer, Room> roomHashMap = roomDistributor.getReadOnlyRoomHashMap();
            Room room = roomHashMap.get(roomID);
            if (room == null)
                return false;
            ChatServer member = Database.chatServerDistributor.getReadOnlyMap().get(memberID);
            if (member == null)
                return false;
            return room.addMember(member);
        } catch (NumberFormatException e) {
            return false;
        }
    }

    //CREATE-COMMANDSPL-Password  //To server
    public Integer createNewRoom(int memberID, RoomDistributor roomDistributor, String packet) {
        String password = "000000";
        if(!password.equals(packet)) {
            return null;
        }
        ChatServer member = Database.chatServerDistributor.getReadOnlyMap().get(memberID);
        if(member == null)
            return null;
        Room room = roomDistributor.assignANewRoomID();
        room.addMember(member);
        return room.roomID;
    }

    public void removeFromDatabase(int memberID, LinkedList<Integer> roomList) {
        HashMap<Integer, Room> roomHashMap = Database.roomDistributor.getReadOnlyRoomHashMap();
        ChatServer member = Database.chatServerDistributor.getReadOnlyMap().get(memberID);
        if(roomHashMap == null || member == null)
            return;
        while(roomList.size() > 0) {
            Room room = roomHashMap.get(roomList.removeFirst());
            if(room == null)
                continue;
            room.deleteMember(member);
        }
        Database.chatServerDistributor.removeFormDistributor(memberID);
    }

    public boolean addAccount(String account, String password) {
        return Database.accountMap.addAccount(account, password);
    }

    public boolean checkAccountPassword(String account, String password) {
        HashMap<String, String> map = Database.accountMap.getReadOnlyHashMap();
        if(map.containsKey(account)) {
            String correctPassword = map.get(account);
            return correctPassword.equals(password);
        }
        return false;
    }

    public String getRoomList() {
        StringBuilder stringBuilder = new StringBuilder();
        HashMap<Integer, Room> roomHashMap = Database.roomDistributor.getReadOnlyRoomHashMap();
        for (HashMap.Entry<Integer, Room> entry: roomHashMap.entrySet()) {
            stringBuilder.append(entry.getKey().toString());
            stringBuilder.append("-");
        }
        if(stringBuilder.toString().length() == 0) {
            return stringBuilder.toString();
        }
        return stringBuilder.toString().substring(0, stringBuilder.length()-1);
    }
}
