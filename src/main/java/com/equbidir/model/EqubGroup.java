package com.equbidir.model;

import java.math.BigDecimal;
import java.time.LocalDate;

public class EqubGroup {
    private int id;
    private String name;
    private BigDecimal contributionAmount;
    private String frequency; // DAILY, WEEKLY, MONTHLY
    private LocalDate startDate;
    private boolean completed;
    private int totalMembers;

    public EqubGroup() {
    }

    public EqubGroup(int id, String name, BigDecimal contributionAmount, String frequency, 
                     LocalDate startDate, boolean completed) {
        this.id = id;
        this.name = name;
        this.contributionAmount = contributionAmount;
        this.frequency = frequency;
        this.startDate = startDate;
        this.completed = completed;
    }

    public EqubGroup(String name, BigDecimal contributionAmount, String frequency, LocalDate startDate) {
        this(0, name, contributionAmount, frequency, startDate, false);
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public BigDecimal getContributionAmount() {
        return contributionAmount;
    }

    public void setContributionAmount(BigDecimal contributionAmount) {
        this.contributionAmount = contributionAmount;
    }

    public String getFrequency() {
        return frequency;
    }

    public void setFrequency(String frequency) {
        this.frequency = frequency;
    }

    public LocalDate getStartDate() {
        return startDate;
    }

    public void setStartDate(LocalDate startDate) {
        this.startDate = startDate;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public int getTotalMembers() {
        return totalMembers;
    }

    public void setTotalMembers(int totalMembers) {
        this.totalMembers = totalMembers;
    }
}

