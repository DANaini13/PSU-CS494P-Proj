package com.nasoftware.Server.LogicalLayer;

import com.nasoftware.Common.Message;
import com.nasoftware.Common.ProtocolInfo;
import com.nasoftware.Server.DataLayer.Database;
import com.nasoftware.Server.DataLayer.RoomDistributor;
import com.nasoftware.Server.NetworkLayer.ChatServer;
import com.nasoftware.Server.DataLayer.Room;

import java.util.ArrayList;
import java.util.HashMap;

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
            HashMap<Integer, Room> roomHashMap = roomDistributor.getReadonlyRoomHashMap();
            if (roomHashMap.containsKey(roomNumber)) {
                Room room = roomHashMap.get(roomNumber);
                Message message = Message.createFromClientPacket(parts[1], senderID, senderName);
                if(message == null)
                    return false;
                addMessageToRoom(message, room);
                return true;
            }
            return false;
        } catch (NumberFormatException _) {
            return false;
        }
    }

    public void addMessageToRoom(Message message, Room room) {
        String header = ProtocolInfo.roomHeader;
        String headerSplitter = ProtocolInfo.contentSplitter;
        String roomSplitter = ProtocolInfo.roomSplitter;
        Integer roomID = room.roomID;
        String packet = header + headerSplitter + roomID + roomSplitter + message.generateMessagePacket();
        ArrayList<Integer> roomMembers = room.getReadOnlyMemberList();
        for (Integer memberID : roomMembers) {
            HashMap<Integer, ChatServer> map = Database.chatServerDistributor.getReadOnlyMap();
            ChatServer member = map.get(memberID);
            member.addPacketToSend(packet);
        }
    }
}
