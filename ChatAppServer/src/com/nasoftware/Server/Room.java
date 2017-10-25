package com.nasoftware.Server;

import com.nasoftware.Common.Message;
import com.nasoftware.Common.ProtocolInfo;

import java.util.ArrayList;

/**
 * Created by zeyongshan on 10/23/17.
 */
public class Room {
    public final int roomID;

    public ArrayList<ChatServer> roomMembers = new ArrayList<ChatServer>();

    public Room(int roomID) {
        this.roomID = roomID;
    }

    public void addMessageToRoom(Message message) {
        String header = ProtocolInfo.roomHeader;
        String headerSplitter = ProtocolInfo.contentSplitter;
        String roomSplitter = ProtocolInfo.roomSplitter;
        String packet = header + headerSplitter + roomID + roomSplitter + message.generateMessagePacket();
        for (ChatServer member : roomMembers) {
            member.addPacketToSend(packet);
        }
    }

}
