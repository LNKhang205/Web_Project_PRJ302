package controller;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.CarDAO;
import model.CarDTO;

@WebServlet(name = "CarDetailController", urlPatterns = {"/car-detail"})
public class CarDetailController extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            String idParam = request.getParameter("id");

            if (idParam == null || idParam.trim().isEmpty()) {
                // Không có id → về danh sách
                response.sendRedirect(request.getContextPath() + "/cars");
                return;
            }

            int carId;
            try {
                carId = Integer.parseInt(idParam.trim());
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/cars");
                return;
            }

            CarDAO carDAO = new CarDAO();
            CarDTO car = carDAO.searchById(carId);

            if (car == null) {
                // Không tìm thấy xe → về danh sách
                request.setAttribute("errorMessage", "Không tìm thấy xe với ID: " + carId);
                response.sendRedirect(request.getContextPath() + "/cars");
                return;
            }

            request.setAttribute("car", car);

            System.out.println("[CarDetailController] Loaded car: " + car.getFullCarName());

            request.getRequestDispatcher("JSP/car-detail.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/cars");
        }
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