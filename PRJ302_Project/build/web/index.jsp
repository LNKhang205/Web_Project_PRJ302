<%-- 
    Document   : index
    Created on : Feb 4, 2026, 9:45:43 AM
    Author     : Lenove
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>LuxuryCars - Premium Experience</title>
        <style>
            /* 1. Reset & Nền toàn màn hình */
            body, html {
                margin: 0;
                padding: 0;
                height: 100%;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            }

            .hero {
                height: 100vh; /* Full màn hình */
                background-image: linear-gradient(rgba(0,0,0,0.3), rgba(0,0,0,0.3)), url("image/index1.jpg");
                background-size: cover;
                background-position: center;
                background-attachment: fixed;
                padding: 20px;
                box-sizing: border-box;
            }

            /* 2. Header phong cách Kính mờ (Glassmorphism) */
            .header {
                color: white;
                padding: 15px 40px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-radius: 16px;
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(12px);
                -webkit-backdrop-filter: blur(12px);
                border: 1px solid rgba(255, 255, 255, 0.1);
                box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);
            }

            .logo {
                font-size: 26px;
                font-weight: 700;
                letter-spacing: 3px;
                text-transform: uppercase;
                background: linear-gradient(to right, #fff, #aaa);
                -webkit-background-clip: text;
                -webkit-text-fill-color: transparent;
            }

            .menu {
                display: flex;
                gap: 20px;
                align-items: center;
            }

            .menu a {
                color: white;
                text-decoration: none;
                font-weight: 500;
                transition: 0.3s;
                font-size: 15px;
            }

            .menu a:hover {
                color: #ddd;
            }

            /* Nút bấm sang trọng */
            .menu a.btn {
                padding: 10px 24px;
                border-radius: 30px; /* Bo tròn kiểu hiện đại */
                background: rgba(255, 255, 255, 0.2);
                border: 1px solid rgba(255, 255, 255, 0.4);
            }

            .menu a.btn:hover {
                background: rgba(255, 255, 255, 1);
                color: #000;
                transform: translateY(-2px);
            }

            /* 3. Modal tinh chỉnh */
            .modal {
                display: none;
                position: fixed;
                inset: 0;
                background: rgba(0,0,0,0.7);
                backdrop-filter: blur(8px);
                z-index: 999;
            }

            .modal-content {
                background: rgba(20, 20, 20, 0.8);
                color: white;
                width: 380px;
                margin: 10vh auto;
                padding: 35px;
                border-radius: 24px;
                border: 1px solid rgba(255, 255, 255, 0.1);
                box-shadow: 0 25px 50px rgba(0,0,0,0.5);
                animation: fadeIn 0.4s cubic-bezier(0.175, 0.885, 0.32, 1.275);
                position: relative;
            }

            .close-btn {
                position: absolute;
                top: 20px;
                right: 20px;
                font-size: 24px;
                cursor: pointer;
                opacity: 0.5;
            }
            .close-btn:hover {
                opacity: 1;
            }

            /* 4. Tối ưu Form trong Modal */
            .modal-content input[type="text"],
            .modal-content input[type="password"] {
                width: 100%;
                padding: 14px;
                margin: 10px 0 20px 0;
                border-radius: 12px;
                border: 1px solid rgba(255,255,255,0.1);
                background: rgba(255,255,255,0.05);
                color: white;
                box-sizing: border-box;
                font-size: 15px;
            }

            .modal-content input[type="submit"] {
                width: 100%;
                padding: 14px;
                background: white;
                color: black;
                border: none;
                border-radius: 12px;
                font-weight: 700;
                cursor: pointer;
                text-transform: uppercase;
                letter-spacing: 1px;
                transition: 0.3s;
            }

            .modal-content input[type="submit"]:hover {
                background: #ccc;
                transform: scale(1.02);
            }

            @keyframes fadeIn {
                from {
                    transform: scale(0.9);
                    opacity: 0;
                }
                to {
                    transform: scale(1);
                    opacity: 1;
                }
            }
        </style>
    </head>
    <body>
        <div class="hero">
            <div class="header">
                <div class="logo">LuxuryCars</div>
                <div class="menu">
                    <c:if test="${sessionScope.user == null}">
                        <a href="#" class="btn" onclick="openLogin()">Login</a>
                        <a href="register.jsp" class="btn">Register</a>
                    </c:if>
                    <c:if test="${sessionScope.user != null}">
                        <span style="margin-right: 15px">Hello, ${sessionScope.user.fullName}</span>
                        <a href="welcome.jsp">Dashboard</a>
                        <a href="MainController?action=logout">Logout</a>
                    </c:if>
                </div>
            </div>

            <div style="color: white; text-align: center; margin-top: 15vh;">
                <h1 style="font-size: 60px; letter-spacing: 5px;">DRIVE YOUR DREAM</h1>
                <p style="font-size: 20px; opacity: 0.8;">Experience the ultimate luxury car collection</p>
            </div>
        </div>

        <div id="loginModal" class="modal">
            <div class="modal-content">
                <span class="close-btn" onclick="closeLogin()">&times;</span>
                <h2 style="text-align: center; margin-bottom: 30px; font-weight: 300;">Welcome Back</h2>
                <jsp:include page="login.jsp"/>
            </div>
        </div>

        <script>
            function openLogin() {
                document.getElementById("loginModal").style.display = "block";
            }
            function closeLogin() {
                document.getElementById("loginModal").style.display = "none";
            }
            // Đóng modal khi click ra ngoài
            window.onclick = function (event) {
                let modal = document.getElementById("loginModal");
                if (event.target == modal)
                    closeLogin();
            }
        </script>

        <c:if test="${not empty openLoginSignal}">
            <script>
                window.onload = function () {
                    openLogin();
                };
            </script>
        </c:if>
    </body>
</html>