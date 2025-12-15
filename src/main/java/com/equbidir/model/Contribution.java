package com.equbidir.model;

import java.util.Date;

public class Contribution {
    private Date paymentDate;
    private String groupName;
    private String groupType; // "Equb" or "Idir"
    private double amount;
    private String status;

    public Contribution(Date paymentDate, String groupName, String groupType, double amount, String status) {
        this.paymentDate = paymentDate;
        this.groupName = groupName;
        this.groupType = groupType;
        this.amount = amount;
        this.status = status;
    }

    public Date getPaymentDate() { return paymentDate; }
    public String getGroupName() { return groupName; }
    public String getGroupType() { return groupType; }
    public double getAmount() { return amount; }
    public String getStatus() { return status; }
}