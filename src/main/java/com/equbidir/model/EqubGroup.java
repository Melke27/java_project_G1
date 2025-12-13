package com.equbidir.model;

public class EqubGroup {
    private int equbId;
    private String equbName;
    private double amount;
    private String frequency;

    public EqubGroup() {}

    public EqubGroup(int equbId, String equbName, double amount, String frequency) {
        this.equbId = equbId;
        this.equbName = equbName;
        this.amount = amount;
        this.frequency = frequency;
    }

    public int getEqubId() {
        return equbId;
    }

    public void setEqubId(int equbId) {
        this.equbId = equbId;
    }

    public String getEqubName() {
        return equbName;
    }

    public void setEqubName(String equbName) {
        this.equbName = equbName;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }
}
