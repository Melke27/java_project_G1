package com.equbidir.model;

public class Member {
    private int memberId;
    private String fullName;
    private String phone;
    private String address;
    private String role;

    // Constructor
    public Member(int memberId, String fullName, String phone, String address, String role) {
        this.memberId = memberId;
        this.fullName = fullName;
        this.phone = phone;
        this.address = address;
        this.role = role;
    }

    // Empty constructor (useful for DAO or future use)
    public Member() {}

    // Getters
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

    // Setters (ADD THESE!)
    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setRole(String role) {
        this.role = role;
    }
}