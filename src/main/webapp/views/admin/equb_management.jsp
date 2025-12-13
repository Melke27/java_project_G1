<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Equb Management</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
    <style>
        .section { margin: 20px 0; padding: 15px; border: 1px solid #ddd; border-radius: 5px; }
        table { width: 100%; border-collapse: collapse; margin: 10px 0; }
        th, td { padding: 8px; text-align: left; border: 1px solid #ddd; }
        th { background-color: #f4f4f4; }
        .btn { padding: 8px 15px; margin: 5px; cursor: pointer; }
        .btn-primary { background-color: #007bff; color: white; border: none; }
        .btn-success { background-color: #28a745; color: white; border: none; }
        .btn-warning { background-color: #ffc107; color: black; border: none; }
        .btn-danger { background-color: #dc3545; color: white; border: none; }
        .form-group { margin: 10px 0; }
        label { display: block; margin-bottom: 5px; font-weight: bold; }
        input[type="text"], input[type="number"], input[type="date"], select {
            width: 100%; padding: 8px; box-sizing: border-box;
        }
        .rotation-list { list-style: none; padding: 0; }
        .rotation-item { padding: 10px; margin: 5px 0; background: #f9f9f9; border-left: 4px solid #007bff; }
        .completed { background: #d4edda; border-left-color: #28a745; }
    </style>
</head>
<body>
<h2>Equb Management</h2>

<c:if test="${not empty group}">
    <!-- View specific group details -->
    <div class="section">
        <h3>Group Details: ${group.name}</h3>
        <p><strong>Contribution Amount:</strong> <fmt:formatNumber value="${group.contributionAmount}" type="currency" currencySymbol="ETB "/></p>
        <p><strong>Frequency:</strong> ${group.frequency}</p>
        <p><strong>Start Date:</strong> ${group.startDate}</p>
        <p><strong>Status:</strong> <c:choose><c:when test="${group.completed}">Completed</c:when><c:otherwise>Active</c:otherwise></c:choose></p>
        <p><strong>Total Members:</strong> ${group.totalMembers}</p>
        
        <a href="${pageContext.request.contextPath}/admin/equb" class="btn btn-primary">Back to Groups</a>
        <c:if test="${not group.completed}">
            <a href="${pageContext.request.contextPath}/admin/equb?action=generateRotation&groupId=${group.id}" class="btn btn-success">Generate Rotation Schedule</a>
            <a href="${pageContext.request.contextPath}/admin/equb?action=completeGroup&groupId=${group.id}" class="btn btn-warning" onclick="return confirm('Mark this group as completed?')">Mark as Completed</a>
        </c:if>
    </div>

    <!-- Record Contribution -->
    <div class="section">
        <h3>Record Contribution</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/equb">
            <input type="hidden" name="action" value="addContribution">
            <input type="hidden" name="equbGroupId" value="${group.id}">
            
            <div class="form-group">
                <label>Member</label>
                <select name="memberId" required>
                    <option value="">Select Member</option>
                    <c:forEach var="member" items="${allMembers}">
                        <option value="${member.id}">${member.name} (${member.phoneNumber})</option>
                    </c:forEach>
                </select>
            </div>
            
            <div class="form-group">
                <label>Amount</label>
                <input type="number" step="0.01" name="amount" value="${group.contributionAmount}" required>
            </div>
            
            <div class="form-group">
                <label>Payment Date</label>
                <input type="date" name="paymentDate" value="${group.startDate}" required>
            </div>
            
            <button type="submit" class="btn btn-primary">Record Contribution</button>
        </form>
    </div>

    <!-- Contributions List -->
    <div class="section">
        <h3>Contributions</h3>
        <table>
            <thead>
            <tr>
                <th>Date</th>
                <th>Member</th>
                <th>Amount</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="contribution" items="${contributions}">
                <tr>
                    <td>${contribution.paymentDate}</td>
                    <td>${contribution.memberName}</td>
                    <td><fmt:formatNumber value="${contribution.amount}" type="currency" currencySymbol="ETB "/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty contributions}">
                <tr><td colspan="3">No contributions recorded yet.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>

    <!-- Rotation Schedule -->
    <div class="section">
        <h3>Rotation Schedule</h3>
        <c:if test="${not empty rotations}">
            <ul class="rotation-list">
                <c:forEach var="rotation" items="${rotations}">
                    <li class="rotation-item <c:if test="${rotation.completed}">completed</c:if>">
                        <strong>Position ${rotation.position}:</strong> ${rotation.memberName} 
                        <br>Rotation Date: ${rotation.rotationDate}
                        <c:if test="${rotation.completed}">
                            <span style="color: green;">✓ Completed</span>
                        </c:if>
                        <c:if test="${not rotation.completed and not group.completed}">
                            <form method="post" action="${pageContext.request.contextPath}/admin/equb" style="display: inline;">
                                <input type="hidden" name="action" value="updateRotation">
                                <input type="hidden" name="rotationId" value="${rotation.id}">
                                <input type="hidden" name="groupId" value="${group.id}">
                                <label>New Position:</label>
                                <input type="number" name="newPosition" value="${rotation.position}" min="1" style="width: 80px;">
                                <button type="submit" class="btn btn-warning">Update Position</button>
                            </form>
                        </c:if>
                    </li>
                </c:forEach>
            </ul>
        </c:if>
        <c:if test="${empty rotations}">
            <p>No rotation schedule generated. Click "Generate Rotation Schedule" to create one.</p>
        </c:if>
    </div>
</c:if>

<c:if test="${empty group}">
    <!-- Create New Equb Group -->
    <div class="section">
        <h3>Create New Equb Group</h3>
        <form method="post" action="${pageContext.request.contextPath}/admin/equb">
            <input type="hidden" name="action" value="createGroup">
            
            <div class="form-group">
                <label>Group Name</label>
                <input type="text" name="name" required>
            </div>
            
            <div class="form-group">
                <label>Contribution Amount</label>
                <input type="number" step="0.01" name="contributionAmount" required>
            </div>
            
            <div class="form-group">
                <label>Frequency</label>
                <select name="frequency" required>
                    <option value="DAILY">Daily</option>
                    <option value="WEEKLY">Weekly</option>
                    <option value="MONTHLY">Monthly</option>
                </select>
            </div>
            
            <div class="form-group">
                <label>Start Date</label>
                <input type="date" name="startDate" required>
            </div>
            
            <div class="form-group">
                <label>Members (Select multiple)</label>
                <select name="memberIds" multiple style="height: 150px;">
                    <c:forEach var="member" items="${allMembers}">
                        <option value="${member.id}">${member.name} (${member.phoneNumber})</option>
                    </c:forEach>
                </select>
                <small>Hold Ctrl/Cmd to select multiple members</small>
            </div>
            
            <button type="submit" class="btn btn-success">Create Group</button>
        </form>
    </div>

    <!-- List All Equb Groups -->
    <div class="section">
        <h3>All Equb Groups</h3>
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Name</th>
                <th>Contribution Amount</th>
                <th>Frequency</th>
                <th>Start Date</th>
                <th>Members</th>
                <th>Status</th>
                <th>Actions</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="grp" items="${groups}">
                <tr>
                    <td>${grp.id}</td>
                    <td>${grp.name}</td>
                    <td><fmt:formatNumber value="${grp.contributionAmount}" type="currency" currencySymbol="ETB "/></td>
                    <td>${grp.frequency}</td>
                    <td>${grp.startDate}</td>
                    <td>${grp.totalMembers}</td>
                    <td>
                        <c:choose>
                            <c:when test="${grp.completed}">
                                <span style="color: green;">Completed</span>
                            </c:when>
                            <c:otherwise>
                                <span style="color: blue;">Active</span>
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <a href="${pageContext.request.contextPath}/admin/equb?action=view&groupId=${grp.id}" class="btn btn-primary">View</a>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty groups}">
                <tr><td colspan="8">No Equb groups created yet.</td></tr>
            </c:if>
            </tbody>
        </table>
    </div>
</c:if>

</body>
</html>

