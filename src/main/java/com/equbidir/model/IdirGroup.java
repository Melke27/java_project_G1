package com.equbidir.model;

public class IdirGroup {

    private int idirId;
    private String idirName;
    private double monthlyPayment;

    public IdirGroup() {
    }

    public IdirGroup(int idirId, String idirName, double monthlyPayment) {
        this.idirId = idirId;
        this.idirName = idirName;
        this.monthlyPayment = monthlyPayment;
    }

    public int getIdirId() {
        return idirId;
    }

    public void setIdirId(int idirId) {
        this.idirId = idirId;
    }

    public String getIdirName() {
        return idirName;
    }

    public void setIdirName(String idirName) {
        this.idirName = idirName;
    }

    public double getMonthlyPayment() {
        return monthlyPayment;
    }

    public void setMonthlyPayment(double monthlyPayment) {
        this.monthlyPayment = monthlyPayment;
    }
}
