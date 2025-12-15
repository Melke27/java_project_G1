package com.equbidir.model;

import java.sql.Timestamp;

public class MemberMessage {
    private int messageId;
    private String title;
    private String message;
    private Timestamp createdAt;
    private int senderId;
    private String senderName;
    private String senderPhone;

    public MemberMessage(int messageId, String title, String message, Timestamp createdAt,
                         int senderId, String senderName, String senderPhone) {
        this.messageId = messageId;
        this.title = title;
        this.message = message;
        this.createdAt = createdAt;
        this.senderId = senderId;
        this.senderName = senderName;
        this.senderPhone = senderPhone;
    }

    public int getMessageId() {
        return messageId;
    }

    public String getTitle() {
        return title;
    }

    public String getMessage() {
        return message;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public int getSenderId() {
        return senderId;
    }

    public String getSenderName() {
        return senderName;
    }

    public String getSenderPhone() {
        return senderPhone;
    }
}
