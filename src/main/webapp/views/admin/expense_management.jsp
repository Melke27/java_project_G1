<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Expense Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
</head>
<body>
<h2>Expense Management</h2>

<section>
    <h3>Add Expense</h3>
    <form method="post" action="${pageContext.request.contextPath}/admin/expenses">
        <label>Amount</label>
        <input type="number" step="0.01" name="amount" required>

        <label>Date</label>
        <input type="date" name="date" required>

        <label>Description</label>
        <input type="text" name="description" required>

        <label>Category</label>
        <select name="category" required>
            <option value="Funeral">Funeral</option>
            <option value="Emergency">Emergency</option>
            <option value="Community">Community</option>
            <option value="Other">Other</option>
        </select>
        <button type="submit">Save Expense</button>
    </form>
</section>

<section>
    <h3>Fund Balance</h3>
    <p>Current Idir fund balance: <strong><c:out value="${fundBalance}" /></strong></p>
</section>

<section>
    <h3>Expenses</h3>
    <table border="1" cellpadding="6" cellspacing="0">
        <thead>
        <tr>
            <th>Date</th>
            <th>Category</th>
            <th>Description</th>
            <th>Amount</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="expense" items="${expenses}">
            <tr>
                <td><c:out value="${expense.date}" /></td>
                <td><c:out value="${expense.category}" /></td>
                <td><c:out value="${expense.description}" /></td>
                <td><c:out value="${expense.amount}" /></td>
            </tr>
        </c:forEach>
        <c:if test="${empty expenses}">
            <tr>
                <td colspan="4">No expenses recorded yet.</td>
            </tr>
        </c:if>
        </tbody>
        <tfoot>
        <tr>
            <th colspan="3">Total</th>
            <th><c:out value="${totalExpenses}" /></th>
        </tr>
        </tfoot>
    </table>
</section>

<section>
    <h3>Category Totals</h3>
    <table border="1" cellpadding="6" cellspacing="0">
        <thead>
        <tr>
            <th>Category</th>
            <th>Total</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach var="entry" items="${categoryTotals}">
            <tr>
                <td><c:out value="${entry.key}" /></td>
                <td><c:out value="${entry.value}" /></td>
            </tr>
        </c:forEach>
        <c:if test="${empty categoryTotals}">
            <tr>
                <td colspan="2">No expenses by category.</td>
            </tr>
        </c:if>
        </tbody>
    </table>
</section>
</body>
</html>

