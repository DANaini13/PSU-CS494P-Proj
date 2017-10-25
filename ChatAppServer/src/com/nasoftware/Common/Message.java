package com.nasoftware.Common;

import java.util.Date;
import static com.nasoftware.Common.ProtocolInfo.*;

/**
 * Created by zeyongshan on 10/23/17.
 */
public class Message {
    private Date date = new Date();
    public final String content;
    public final int senderID;
    public final String senderName;


    public static Message createFromServerPacket(String packet) {
        String[] parts = packet.split(messageSplitter);
        if (parts.length != 2)
            return null;
        if (!parts[0].equals(ProtocolInfo.messageHeader))
            return null;
        String[] messParts = parts[1].split(contentSplitter);
        if (messParts.length != 4)
            return null;
        try {
            int senderID   = Integer.parseInt(messParts[0]);
            String senderName = messParts[1];
            Date date = new Date(messParts[2]);
            String content = messParts[3];
            Message message = new Message(content, senderID, senderName);
            message.date = date;
            return message;
        }catch (NumberFormatException _) {
            return null;
        }
    }

    // MESS-MESSSPLITTER-content: To server
    public static Message createFromClientPacket(String packet, int senderID, String senderName) {
        String[] parts = packet.split(messageSplitter);
        if (parts.length != 2)
            return null;
        if (!parts[0].equals(messageHeader))
            return null;
        String[] messParts = parts[1].split(contentSplitter);
         if (messParts.length != 1)
            return null;
        try {
            Message message = new Message(messParts[0], senderID, senderName);
            return message;
        }catch (NumberFormatException _) {
            return null;
        }
    }

    public Message(String messageContent, int senderID, String senderName) {
        this.content = messageContent;
        this.senderID = senderID;
        this.senderName = senderName;
    }

    public String generateMessageStringForDisplay() {
        return date + "\n" + senderName + "\t: " + content;
    }

    public String generateMessagePacket() {
        String header = "MESS" + messageSplitter;
        if(senderName != null)
            return header + senderID + contentSplitter + senderName + contentSplitter + date + contentSplitter + content;
        else
            return header + senderID + contentSplitter + "UNKNOWN" + contentSplitter + date + contentSplitter + content;
    }
}
