<%-- 
    Document   : profile
    Created on : Feb 6, 2026, 9:19:14 PM
    Author     : Lenove
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%-- Kiểm tra đăng nhập --%>
<c:if test="${empty sessionScope.user}">
    <c:redirect url="/login.jsp"/>
</c:if>

<c:set var="edit" value="${param.edit == 'true'}"/>
<c:set var="u" value="${sessionScope.user}"/>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Profile</title>
        <style>
            .readonly-input {
                background-color: #f0f0f0;
                border: 1px solid #ccc;
            }
            .msg-success {
                color: green;
                font-weight: bold;
            }
            .msg-error {
                color: red;
                font-weight: bold;
            }
            .actions {
                margin-top: 20px;
            }
        </style>
    </head>
    <body>

        <h2>MY PROFILE</h2>

        <%-- 1. Gửi trực tiếp đến ProfileController để xử lý --%>
        <form action="${pageContext.request.contextPath}/ProfileController" method="post">
            <input type="hidden" name="action" value="updateProfile"/>
            <input type="hidden" name="userId" value="${u.userId}"/>

            <%-- Xác định trạng thái Edit: 
     Nếu nhấn nút Edit (param.edit) HOẶC đang bị lỗi (isErrorMode) --%>
            <c:set var="edit" value="${param.edit == 'true' || requestScope.isErrorMode == 'true'}"/>
            <c:set var="u" value="${sessionScope.user}"/>

            <p>
                Username:
                <input type="text" name="username" value="${u.username}" readonly class="readonly-input" />
            </p>

            <p>
                Full Name:
                <input type="text" name="fullName"
                       <%-- Ưu tiên lấy fullName từ request nếu có lỗi, không thì lấy từ session --%>
                       value="${not empty fullName ? fullName : u.fullName}"
                       ${!edit ? 'readonly' : ''}
                       class="${!edit ? 'readonly-input' : ''}" required/>
            </p>

            <p>
                Email:
                <input type="email" name="email"
                       value="${not empty email ? email : u.email}"
                       ${!edit ? 'readonly' : ''}
                       class="${!edit ? 'readonly-input' : ''}" required/>
            </p>

            <p>
                Phone:
                <input type="text" name="phone"
                       value="${not empty phone ? phone : u.phone}"
                       ${!edit ? 'readonly' : ''}
                       class="${!edit ? 'readonly-input' : ''}"/>
            </p>

            <div class="actions">
                <c:choose>
                    <c:when test="${!edit}">
                        <a href="${pageContext.request.contextPath}/customer/profile.jsp?edit=true">Edit Profile</a>
                    </c:when>
                    <c:otherwise>
                        <input type="submit" value="UPDATE PROFILE"/>
                        <br/><br/>
                        <%-- Nút Hủy: Quay về trang Profile gốc, xóa bỏ mọi dữ liệu đang nhập dở --%>
                        <a href="${pageContext.request.contextPath}/customer/profile.jsp" style="color: grey;"><strong>Cancel</strong></a>
                    </c:otherwise>
                </c:choose>
            </div>
        </form>

        <hr>
        <%-- Hiển thị thông báo lỗi/thành công --%>
        <c:if test="${not empty msg}">
            <p class="msg-success">${msg}</p>
        </c:if>
        <c:if test="${not empty error}">
            <p class="msg-error">${error}</p>
        </c:if>

    </body>
</html>
