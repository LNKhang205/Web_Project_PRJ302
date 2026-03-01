package controller;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.BrandDAO;
import model.BrandDTO;
import model.CarDAO;
import model.CarDTO;
import model.CategoryDAO;
import model.CategoryDTO;

@WebServlet(name = "CarListController", urlPatterns = {"/cars"})
public class CarListController extends HttpServlet {

    private static final int CARS_PER_PAGE = 12;

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        try {
            // ===== THAM SỐ PHÂN TRANG =====
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            if (pageParam != null && !pageParam.trim().isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam.trim());
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            // ===== THAM SỐ BỘ LỌC =====
            String brandParam    = request.getParameter("brand");
            String categoryParam = request.getParameter("category");
            String priceMinParam = request.getParameter("priceMin");
            String priceMaxParam = request.getParameter("priceMax");

            Integer brandId    = null;
            Integer categoryId = null;
            BigDecimal minPrice = null;
            BigDecimal maxPrice = null;

            if (brandParam != null && !brandParam.trim().isEmpty()) {
                try { brandId = Integer.parseInt(brandParam.trim()); }
                catch (NumberFormatException e) { /* bỏ qua giá trị không hợp lệ */ }
            }

            if (categoryParam != null && !categoryParam.trim().isEmpty()) {
                try { categoryId = Integer.parseInt(categoryParam.trim()); }
                catch (NumberFormatException e) { /* bỏ qua */ }
            }

            if (priceMinParam != null && !priceMinParam.trim().isEmpty()) {
                try {
                    // Người dùng nhập theo đơn vị tỷ VNĐ
                    minPrice = new BigDecimal(priceMinParam.trim())
                                    .multiply(new BigDecimal("1000000000"));
                } catch (NumberFormatException e) { /* bỏ qua */ }
            }

            if (priceMaxParam != null && !priceMaxParam.trim().isEmpty()) {
                try {
                    maxPrice = new BigDecimal(priceMaxParam.trim())
                                    .multiply(new BigDecimal("1000000000"));
                } catch (NumberFormatException e) { /* bỏ qua */ }
            }

            // ===== LẤY DỮ LIỆU TỪ DAO =====
            CarDAO carDAO = new CarDAO();

            // Lấy danh sách xe theo trang + bộ lọc (không lọc theo status để hiện tất cả xe)
            List<CarDTO> carList = carDAO.getCarsByPageWithFilter(
                    currentPage, CARS_PER_PAGE,
                    brandId, categoryId,
                    minPrice, maxPrice,
                    null  // null = không lọc status, hiện tất cả xe
            );

            // Tổng số xe để tính phân trang
            int totalCars = carDAO.getTotalCarsWithFilter(
                    brandId, categoryId,
                    minPrice, maxPrice,
                    null
            );

            int totalPages = (int) Math.ceil((double) totalCars / CARS_PER_PAGE);
            if (totalPages < 1) totalPages = 1;

            // ===== DANH SÁCH BRAND & CATEGORY CHO BỘ LỌC =====
            BrandDAO brandDAO = new BrandDAO();
            List<BrandDTO> brandList = brandDAO.getAllBrands();

            CategoryDAO categoryDAO = new CategoryDAO();
            List<CategoryDTO> categoryList = categoryDAO.getAllCategories();

            // ===== SET ATTRIBUTES SANG JSP =====
            request.setAttribute("carList",    carList);
            request.setAttribute("totalCars",  totalCars);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);

            // Giữ lại giá trị bộ lọc để hiển thị lại trên form
            request.setAttribute("selectedBrand",    brandParam);
            request.setAttribute("selectedCategory", categoryParam);
            request.setAttribute("selectedPriceMin", priceMinParam);
            request.setAttribute("selectedPriceMax", priceMaxParam);

            request.setAttribute("brandList",    brandList);
            request.setAttribute("categoryList", categoryList);

            // Debug log
            System.out.println("[CarListController] Page=" + currentPage
                    + " | Total=" + totalCars
                    + " | Cars loaded=" + carList.size());

            // Forward sang JSP
            request.getRequestDispatcher("JSP/cars.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "Có lỗi xảy ra khi tải danh sách xe: " + e.getMessage());
            request.getRequestDispatcher("JSP/cars.jsp").forward(request, response);
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
