package com.equbidir.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class Contribution {
    private int id;
    private int equbGroupId;
    private int memberId;
    private BigDecimal amount;
    private LocalDate paymentDate;
    private String memberName; // For display purposes
    private int rotationPosition; // For rotation tracking

    public Contribution() {
    }

    public Contribution(int id, int equbGroupId, int memberId, BigDecimal amount, LocalDate paymentDate) {
        this.id = id;
        this.equbGroupId = equbGroupId;
        this.memberId = memberId;
        this.amount = amount;
        this.paymentDate = paymentDate;
    }

    public Contribution(int equbGroupId, int memberId, BigDecimal amount, LocalDate paymentDate) {
        this(0, equbGroupId, memberId, amount, paymentDate);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getEqubGroupId() {
        return equbGroupId;
    }

    public void setEqubGroupId(int equbGroupId) {
        this.equbGroupId = equbGroupId;
    }

    public int getMemberId() {
        return memberId;
    }

    public void setMemberId(int memberId) {
        this.memberId = memberId;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public LocalDate getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(LocalDate paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }

    public int getRotationPosition() {
        return rotationPosition;
    }

    public void setRotationPosition(int rotationPosition) {
        this.rotationPosition = rotationPosition;
    }
}

