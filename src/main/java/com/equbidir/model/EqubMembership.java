package com.equbidir.model;

import java.util.ArrayList;
import java.util.List;

public class EqubMembership {

    private int equbId;
    private String equbName;
    private double amount;
    private String frequency;
    private String paymentStatus;
    private Integer rotationPosition; // Nullable
    private List<Member> groupMembers = new ArrayList<>(); // Moved here

    public EqubMembership(int equbId, String equbName, double amount,
                          String frequency, String paymentStatus, Integer rotationPosition) {
        this.equbId = equbId;
        this.equbName = equbName;
        this.amount = amount;
        this.frequency = frequency;
        this.paymentStatus = paymentStatus;
        this.rotationPosition = rotationPosition;
    }

    // Getters
    public int getEqubId() {
        return equbId;
    }

    public String getEqubName() {
        return equbName;
    }

    public double getAmount() {
        return amount;
    }

    public String getFrequency() {
        return frequency;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public Integer getRotationPosition() {
        return rotationPosition;
    }

    public List<Member> getGroupMembers() {
        return groupMembers;
    }

    public void setGroupMembers(List<Member> groupMembers) {
        this.groupMembers = groupMembers;
    }
}