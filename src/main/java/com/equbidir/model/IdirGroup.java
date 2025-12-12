package com.equbidir.model;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Objects;

/**
 * Domain model representing an Idir group along with its payments and expenses.
 * This is an in-memory representation to keep the example self contained.
 */
public class IdirGroup {
    private int id;
    private String name;
    private double monthlyContribution;
    private LocalDate createdAt = LocalDate.now();
    private final List<Payment> payments = new ArrayList<>();
    private final List<Expense> expenses = new ArrayList<>();

    public IdirGroup() {
    }

    public IdirGroup(int id, String name, double monthlyContribution) {
        this.id = id;
        this.name = name;
        this.monthlyContribution = monthlyContribution;
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

    public double getMonthlyContribution() {
        return monthlyContribution;
    }

    public void setMonthlyContribution(double monthlyContribution) {
        this.monthlyContribution = monthlyContribution;
    }

    public LocalDate getCreatedAt() {
        return createdAt;
    }

    public List<Payment> getPayments() {
        return Collections.unmodifiableList(payments);
    }

    public List<Expense> getExpenses() {
        return Collections.unmodifiableList(expenses);
    }

    public void addPayment(Payment payment) {
        payments.add(Objects.requireNonNull(payment));
    }

    public void addExpense(Expense expense) {
        expenses.add(Objects.requireNonNull(expense));
    }

    public double getTotalPayments() {
        return payments.stream().mapToDouble(Payment::getAmount).sum();
    }

    public double getTotalExpenses() {
        return expenses.stream().mapToDouble(Expense::getAmount).sum();
    }

    public double getBalance() {
        return getTotalPayments() - getTotalExpenses();
    }

    public static class Payment {
        private final String member;
        private final double amount;
        private final LocalDate paidDate;

        public Payment(String member, double amount, LocalDate paidDate) {
            this.member = member;
            this.amount = amount;
            this.paidDate = paidDate;
        }

        public String getMember() {
            return member;
        }

        public double getAmount() {
            return amount;
        }

        public LocalDate getPaidDate() {
            return paidDate;
        }
    }

    public static class Expense {
        private final String description;
        private final double amount;
        private final LocalDate spentDate;

        public Expense(String description, double amount, LocalDate spentDate) {
            this.description = description;
            this.amount = amount;
            this.spentDate = spentDate;
        }

        public String getDescription() {
            return description;
        }

        public double getAmount() {
            return amount;
        }

        public LocalDate getSpentDate() {
            return spentDate;
        }
    }
}
