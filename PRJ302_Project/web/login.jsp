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
        
        <form action="MainController" method="post">
            <input type="hidden" name="action" value="login" />
            Username: <input type="text" name="txtUsername" required="" value="${txtUsername != null ? txtUsername : ''}"/><br/>
            Password: <input type="password" name="txtPassword" required=""/><br/>
            <input type="submit" value="Login"/>
        </form>
        <br/>
        <a href="register.jsp">Register</a>
        <br/>
        <c:if test="${not empty message}">
            <span style="color: red">${message}</span>
        </c:if>
    </body>
</html>
