package controller;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.UserDAO;
import model.UserDTO;

@WebServlet(name = "LoginController", urlPatterns = {"/LoginController"})
public class LoginController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String url = "index.jsp"; // Mặc định quay về index nếu lỗi
        HttpSession session = request.getSession();

        String txtUsername = request.getParameter("txtUsername");
        String txtPassword = request.getParameter("txtPassword");

        // 1. Kiểm tra đầu vào trống
        if (txtUsername == null || txtPassword == null || txtUsername.trim().isEmpty() || txtPassword.trim().isEmpty()) {
            request.setAttribute("message", "Please enter both UserID and Password.");
            request.setAttribute("txtUsername", txtUsername);
            RequestDispatcher rd = request.getRequestDispatcher("login.jsp"); // Đẩy về trang login thuần
            rd.forward(request, response);
            return;
        }

        UserDAO udao = new UserDAO();
        UserDTO user = udao.login(txtUsername, txtPassword);

        // 2. Kiểm tra thông tin đăng nhập
        if (user == null) {
            request.setAttribute("message", "Invalid UserID or Password!");
            request.setAttribute("txtUsername", txtUsername);
            url = "login.jsp"; // Quay lại trang login để báo lỗi
        } 
        // 3. Kiểm tra trạng thái tài khoản
        else if (!"ACTIVE".equals(user.getStatus())) {
            url = "E403.jsp"; // Trang báo lỗi không có quyền truy cập
        } 
        // 4. Đăng nhập thành công
        else {
            session.setAttribute("user", user);

            // Phân quyền điều hướng (Sử dụng sendRedirect để tránh lặp form khi F5)
            if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("admin/dashboard.jsp");
            } else {
                response.sendRedirect("customer/welcome.jsp");
            }
            return; 
        }

        // Forward cho các trường hợp thất bại để giữ lại thông báo lỗi
        RequestDispatcher rd = request.getRequestDispatcher(url);
        rd.forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }
}