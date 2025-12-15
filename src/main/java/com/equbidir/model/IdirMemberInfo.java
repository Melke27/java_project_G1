package com.equbidir.model;

public class IdirMemberInfo {
    private int idirId;
    private String idirName;
    private double monthlyPayment;
    private String paymentStatus;
    private double fundBalance;
    private int totalMembers;

    public IdirMemberInfo(int idirId, String idirName, double monthlyPayment,
                          String paymentStatus, double fundBalance, int totalMembers) {
        this.idirId = idirId;
        this.idirName = idirName;
        this.monthlyPayment = monthlyPayment;
        this.paymentStatus = paymentStatus;
        this.fundBalance = fundBalance;
        this.totalMembers = totalMembers;
    }

    public int getIdirId() { return idirId; }
    public String getIdirName() { return idirName; }
    public double getMonthlyPayment() { return monthlyPayment; }
    public String getPaymentStatus() { return paymentStatus; }
    public double getFundBalance() { return fundBalance; }
    public int getTotalMembers() { return totalMembers; }
}