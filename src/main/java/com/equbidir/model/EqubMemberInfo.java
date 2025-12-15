package com.equbidir.model;

public class EqubMemberInfo {
    private int equbId;
    private String equbName;
    private double amount;
    private String frequency;
    private Integer rotationPosition;  // Can be null
    private String paymentStatus;
    private int totalMembers;

    public EqubMemberInfo(int equbId, String equbName, double amount, String frequency,
                          Integer rotationPosition, String paymentStatus, int totalMembers) {
        this.equbId = equbId;
        this.equbName = equbName;
        this.amount = amount;
        this.frequency = frequency;
        this.rotationPosition = rotationPosition;
        this.paymentStatus = paymentStatus;
        this.totalMembers = totalMembers;
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

    public Integer getRotationPosition() {
        return rotationPosition;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public int getTotalMembers() {
        return totalMembers;
    }
}