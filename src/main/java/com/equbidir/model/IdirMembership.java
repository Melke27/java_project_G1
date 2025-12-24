package com.equbidir.model;

import java.util.ArrayList;
import java.util.List;

public class IdirMembership {

    private int idirId;
    private String idirName;
    private double monthlyPayment;
    private String paymentStatus;
    private double fundBalance;
    private int totalMembers;
    private List<Member> groupMembers = new ArrayList<>();  // ← NEW: for real member list

    // Constructor (unchanged)
    public IdirMembership(int idirId, String idirName, double monthlyPayment,
                          String paymentStatus, double fundBalance, int totalMembers) {
        this.idirId = idirId;
        this.idirName = idirName;
        this.monthlyPayment = monthlyPayment;
        this.paymentStatus = paymentStatus;
        this.fundBalance = fundBalance;
        this.totalMembers = totalMembers;
    }

    // Getters
    public int getIdirId() {
        return idirId;
    }

    public String getIdirName() {
        return idirName;
    }

    public double getMonthlyPayment() {
        return monthlyPayment;
    }

    public String getPaymentStatus() {
        return paymentStatus;
    }

    public double getFundBalance() {
        return fundBalance;
    }

    public int getTotalMembers() {
        return totalMembers;
    }

    // NEW: Getter and Setter for group members
    public List<Member> getGroupMembers() {
        return groupMembers;
    }

    public void setGroupMembers(List<Member> groupMembers) {
        this.groupMembers = groupMembers;
    }

    // Optional setters (keep them if you want)
    public void setIdirId(int idirId) {
        this.idirId = idirId;
    }

    public void setIdirName(String idirName) {
        this.idirName = idirName;
    }

    public void setMonthlyPayment(double monthlyPayment) {
        this.monthlyPayment = monthlyPayment;
    }

    public void setPaymentStatus(String paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public void setFundBalance(double fundBalance) {
        this.fundBalance = fundBalance;
    }

    public void setTotalMembers(int totalMembers) {
        this.totalMembers = totalMembers;
    }

    // Optional: toString() for debugging
    @Override
    public String toString() {
        return "IdirMembership{" +
                "idirId=" + idirId +
                ", idirName='" + idirName + '\'' +
                ", monthlyPayment=" + monthlyPayment +
                ", paymentStatus='" + paymentStatus + '\'' +
                ", fundBalance=" + fundBalance +
                ", totalMembers=" + totalMembers +
                ", groupMembersCount=" + groupMembers.size() +
                '}';
    }
}