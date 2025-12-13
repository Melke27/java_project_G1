package com.equbidir.model;

public class Contribution {
    private int id;
    private int memberId;
    private int groupId;
    private String paymentStatus;
    private Integer rotationPosition;

    public Contribution() {}

    public Contribution(int id, int memberId, int groupId, String paymentStatus, Integer rotationPosition) {
        this.id = id;
        this.memberId = memberId;
        this.groupId = groupId;
        this.paymentStatus = paymentStatus;
        this.rotationPosition = rotationPosition;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getMemberId() {
        return memberId;
    }

    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }

    public int getGroupId() {
        return groupId;
    }

    public void setGroupId(int groupId) {
        this.groupId = groupId;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public Integer getRotationPosition() {
        return rotationPosition;
    }

    public void setRotationPosition(Integer rotationPosition) {
        this.rotationPosition = rotationPosition;
    }
}
