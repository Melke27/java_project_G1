package com.equbidir.dao;

import com.equbidir.model.IdirGroup;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * Simple in-memory DAO for managing Idir groups, payments, and expenses.
 * Replace with JDBC/ORM when a real database is available.
 */
public class IdirDAO {
    private static final Map<Integer, IdirGroup> GROUPS = new ConcurrentHashMap<>();
    private static final AtomicInteger ID_GENERATOR = new AtomicInteger(1);

    public List<IdirGroup> findAll() {
        return new ArrayList<>(GROUPS.values());
    }

    public Optional<IdirGroup> findById(int id) {
        return Optional.ofNullable(GROUPS.get(id));
    }

    public IdirGroup create(String name, double monthlyContribution) {
        int id = ID_GENERATOR.getAndIncrement();
        IdirGroup group = new IdirGroup(id, name, monthlyContribution);
        GROUPS.put(id, group);
        return group;
    }

    public boolean update(int id, String name, double monthlyContribution) {
        IdirGroup group = GROUPS.get(id);
        if (group == null) {
            return false;
        }
        group.setName(name);
        group.setMonthlyContribution(monthlyContribution);
        return true;
    }

    public boolean delete(int id) {
        return GROUPS.remove(id) != null;
    }

    public boolean recordPayment(int groupId, String member, double amount, LocalDate paidDate) {
        IdirGroup group = GROUPS.get(groupId);
        if (group == null) {
            return false;
        }
        group.addPayment(new IdirGroup.Payment(member, amount, paidDate));
        return true;
    }

    public boolean recordExpense(int groupId, String description, double amount, LocalDate spentDate) {
        IdirGroup group = GROUPS.get(groupId);
        if (group == null) {
            return false;
        }
        group.addExpense(new IdirGroup.Expense(description, amount, spentDate));
        return true;
    }
}
