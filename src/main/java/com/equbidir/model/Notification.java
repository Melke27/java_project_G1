package com.equbidir.model;

import java.sql.Timestamp;

public class Notification {
    private int notificationId;
    private String title;
    private String message;
    private Timestamp createdAt;
    private String createdByName;

    public Notification(int notificationId, String title, String message, Timestamp createdAt, String createdByName) {
        this.notificationId = notificationId;
        this.title = title;
        this.message = message;
        this.createdAt = createdAt;
        this.createdByName = createdByName;
    }

    public int getNotificationId() {
        return notificationId;
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

    public String getCreatedByName() {
        return createdByName;
    }
}
