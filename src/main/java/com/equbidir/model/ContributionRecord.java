package com.equbidir.model;

import java.sql.Timestamp;

public class ContributionRecord {
    private String type; // "equb" or "idir"
    private String groupName;
    private double amount;
    private Timestamp paidAt;

    public ContributionRecord(String type, String groupName, double amount, Timestamp paidAt) {
        this.type = type;
        this.groupName = groupName;
        this.amount = amount;
        this.paidAt = paidAt;
    }

    public String getType() {
        return type;
    }

    public String getGroupName() {
        return groupName;
    }

    public double getAmount() {
        return amount;
    }

    public Timestamp getPaidAt() {
        return paidAt;
    }
}
