package com.equbidir.model;

public class IdirMembership {
    private int idirId;
    private String idirName;
    private double monthlyPayment;
    private String paymentStatus;

    public IdirMembership(int idirId, String idirName, double monthlyPayment, String paymentStatus) {
        this.idirId = idirId;
        this.idirName = idirName;
        this.monthlyPayment = monthlyPayment;
        this.paymentStatus = paymentStatus;
    }

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
}
