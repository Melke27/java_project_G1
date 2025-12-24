package com.equbidir.model;

import java.math.BigDecimal;
import java.sql.Date;

public class Expense {
    private Date date;
    private String category;
    private String description;
    private BigDecimal amount;

    public Expense() {}

    public Expense(Date date, String category, String description, BigDecimal amount) {
        this.date = date;
        this.category = category;
        this.description = description;
        this.amount = amount;
    }

    public Date getDate() { return date; }
    public void setDate(Date date) { this.date = date; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getAmount() { return amount; }
    public void setAmount(BigDecimal amount) { this.amount = amount; }
}