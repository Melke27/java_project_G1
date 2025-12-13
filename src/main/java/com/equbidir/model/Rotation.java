package com.equbidir.model;

import java.time.LocalDate;

public class Rotation {
    private int id;
    private int equbGroupId;
    private int memberId;
    private int position; // 1, 2, 3, etc.
    private LocalDate rotationDate;
    private boolean completed;
    private String memberName; // For display purposes

    public Rotation() {
    }

    public Rotation(int id, int equbGroupId, int memberId, int position, LocalDate rotationDate, boolean completed) {
        this.id = id;
        this.equbGroupId = equbGroupId;
        this.memberId = memberId;
        this.position = position;
        this.rotationDate = rotationDate;
        this.completed = completed;
    }

    public Rotation(int equbGroupId, int memberId, int position, LocalDate rotationDate) {
        this(0, equbGroupId, memberId, position, rotationDate, false);
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

    public int getPosition() {
        return position;
    }

    public void setPosition(int position) {
        this.position = position;
    }

    public LocalDate getRotationDate() {
        return rotationDate;
    }

    public void setRotationDate(LocalDate rotationDate) {
        this.rotationDate = rotationDate;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public String getMemberName() {
        return memberName;
    }

    public void setMemberName(String memberName) {
        this.memberName = memberName;
    }
}

