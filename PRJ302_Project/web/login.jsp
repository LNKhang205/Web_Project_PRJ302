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

        <div class="login-form-container">
            <h2 style="text-align: center; margin-bottom: 25px; font-weight: 300; letter-spacing: 2px;"><strong>LOGIN</strong></h2>

            <form action="MainController" method="post">
                <input type="hidden" name="action" value="login" />

                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="txtUsername" required="" value="${txtUsername != null ? txtUsername : ''}"/>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="txtPassword" required=""/>
                </div>

                <input type="submit" value="Sign In"/>
            </form>

            <div style="text-align: center; margin-top: 20px; font-size: 14px;">
                Don't have an account? <a href="register.jsp" style="color: #aaa; text-decoration: none;">Register</a>
            </div>

            <c:if test="${not empty message}">
                <div style="color: #FF5252; text-align: center; margin-top: 15px; font-size: 14px;">
                    ${message}
                </div>
            </c:if>
        </div>
    </body>
</html>
