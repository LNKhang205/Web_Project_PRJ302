<%-- 
    Document   : register.jsp
    Created on : Feb 3, 2026, 3:03:56 PM
    Author     : Lenove
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Register - LuxuryCars</title>
        <style>
            body {
                margin: 0;
                padding: 0;
                font-family: 'Segoe UI', Arial, sans-serif;
                /* Lấy ảnh nền giống trang index để đồng bộ */
                background-image: url("image/index1.jpg");
                background-size: cover;
                background-position: center;
                background-attachment: fixed;
                display: flex;
                justify-content: center;
                align-items: center;
                min-height: 100vh;
            }

            /* Lớp phủ làm mờ nền giống Modal */
            .register-container {
                background: rgba(0, 0, 0, 0.6);
                backdrop-filter: blur(10px);
                padding: 40px;
                border-radius: 15px;
                box-shadow: 0 15px 35px rgba(0,0,0,0.5);
                width: 400px;
                color: white;
            }

            h2 {
                text-align: center;
                margin-bottom: 25px;
                font-weight: 300;
                letter-spacing: 2px;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-size: 14px;
                opacity: 0.8;
            }

            .form-group input {
                width: 100%;
                padding: 12px;
                border-radius: 8px;
                border: 1px solid rgba(255,255,255,0.2);
                background: rgba(255,255,255,0.1);
                color: white;
                box-sizing: border-box;
                outline: none;
            }

            .form-group input:focus {
                border-color: #777;
                background: rgba(255,255,255,0.2);
            }

            input[type="submit"] {
                width: 100%;
                padding: 12px;
                margin-top: 20px;
                border: none;
                border-radius: 8px;
                background-color: #555;
                color: white;
                font-weight: bold;
                cursor: pointer;
                transition: 0.3s;
            }

            input[type="submit"]:hover {
                background-color: #777;
            }

            .footer-links {
                text-align: center;
                margin-top: 20px;
                font-size: 14px;
            }

            .footer-links a {
                color: #aaa;
                text-decoration: none;
            }

            .footer-links a:hover {
                color: white;
            }

            .msg-success {
                color: #4CAF50;
                text-align: center;
            }
            .msg-error {
                color: #FF5252;
                text-align: center;
            }
        </style>
    </head>
    <body>
        <div class="register-container">
            <h2>REGISTER</h2>

            <form action="MainController" method="post">
                <input type="hidden" name="action" value="register" />

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" value="${user.fullName}" required/>
                </div>

                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" value="${user.username}" required/>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required/>
                </div>

                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" name="confirm" required/>
                </div>

                <div class="form-group">
                    <label>Email</label>
                    <input type="text" name="email" value="${user.email}"/>
                </div>

                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" value="${user.phone}"/>
                </div>

                <input type="submit" value="CREATE ACCOUNT"/> 
            </form>

            <div class="footer-links">
                Already have an account? <a href="index.jsp">Back to Login</a>
            </div>

            <p class="msg-success">${msg}</p>
            <p class="msg-error">${error}</p>
        </div>
    </body>
</html>