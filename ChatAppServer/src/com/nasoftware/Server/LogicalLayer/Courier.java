package com.nasoftware.Server.LogicalLayer;

import com.nasoftware.Common.Message;
import com.nasoftware.Common.ProtocolInfo;
import com.nasoftware.Server.DataLayer.Database;
import com.nasoftware.Server.DataLayer.RoomDistributor;
import com.nasoftware.Server.NetworkLayer.ChatServer;
import com.nasoftware.Server.DataLayer.Room;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedList;

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
        } catch (NumberFormatException _) {
            return false;
        }
    }

    private void addMessageToRoom(Message message, Room room) {
        String header = ProtocolInfo.roomHeader;
        String headerSplitter = ProtocolInfo.contentSplitter;
        String roomSplitter = ProtocolInfo.roomSplitter;
        Integer roomID = room.roomID;
        String packet = header + headerSplitter + roomID + roomSplitter + message.generateMessagePacket();
        ArrayList<Integer> roomMembers = room.getReadOnlyMemberList();
        HashMap<Integer, ChatServer> map = Database.chatServerDistributor.getReadOnlyMap();
        for (Integer memberID : roomMembers) {
            ChatServer member = map.get(memberID);
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
        } catch (NumberFormatException _) {
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
        for(Integer x: roomList) {
            Room room = roomHashMap.get(x);
            if(room == null)
                continue;
            room.deleteMember(member);
        }
        Database.chatServerDistributor.removeFormDistributor(memberID);
    }
}
