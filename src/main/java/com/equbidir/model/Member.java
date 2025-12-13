package com.equbidir.model;

public class Member {
    private int memberId;
    private String fullName;
    private String phone;
    private String address;
    private String role;

    public Member(int memberId, String fullName, String phone, String address, String role) {
        this.memberId = memberId;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.role = role;
    }

    public int getMemberId() {
        return memberId;
    }

    public String getFullName() {
        return fullName;
    }

    public String getPhone() {
        return phone;
    }

    public String getAddress() {
        return address;
    }

    public String getRole() {
        return role;
    }
}