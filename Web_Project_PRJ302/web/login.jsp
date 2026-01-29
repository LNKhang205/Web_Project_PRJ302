<%-- 
    Document   : login
    Created on : Jan 29, 2026, 4:41:04 PM
    Author     : VNT
--%>

<%@page import="model.UserDTO"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <c:if test="${not empty user}">
            <c:redirect url="a.jsp"/>
        </c:if>
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="login" />
            Username: <input type="text" name="Username" required=""/><br/>
            Password: <input type="password" name="Password" required=""/><br/>
            <input type="submit" value="Login"/>
        </form>
        <c:if test="${not empty message}">
            <span style="color: red">${message}</span>
        </c:if>
    </body>
</html>
