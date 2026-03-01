/*
 * CarListServlet.java
 * Controller xử lý danh sách xe với phân trang và bộ lọc
 */
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

@WebServlet(name = "CarListServlet", urlPatterns = {"/cars"})
public class CarListServlet extends HttpServlet {
    
    private static final int CARS_PER_PAGE = 12;
    
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html;charset=UTF-8");
        
        try {
            // ===== LẤY THAM SỐ TỪ REQUEST =====
            
            // Trang hiện tại (mặc định trang 1)
            String pageParam = request.getParameter("page");
            int currentPage = 1;
            if (pageParam != null && !pageParam.isEmpty()) {
                try {
                    currentPage = Integer.parseInt(pageParam);
                    if (currentPage < 1) currentPage = 1;
                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }
            
            // Bộ lọc
            String brandParam = request.getParameter("brand");
            String categoryParam = request.getParameter("category");
            String priceMinParam = request.getParameter("priceMin");
            String priceMaxParam = request.getParameter("priceMax");
            String statusParam = request.getParameter("status");
            String searchParam = request.getParameter("search");
            
            Integer brandId = null;
            Integer categoryId = null;
            BigDecimal minPrice = null;
            BigDecimal maxPrice = null;
            
            // Parse brandId
            if (brandParam != null && !brandParam.isEmpty()) {
                try {
                    brandId = Integer.parseInt(brandParam);
                } catch (NumberFormatException e) {
                    // Nếu là tên brand, cần convert sang ID
                    BrandDAO brandDAO = new BrandDAO();
                    BrandDTO brand = brandDAO.searchByName(brandParam);
                    if (brand != null) {
                        brandId = brand.getBrandId();
                    }
                }
            }
            
            // Parse categoryId
            if (categoryParam != null && !categoryParam.isEmpty()) {
                try {
                    categoryId = Integer.parseInt(categoryParam);
                } catch (NumberFormatException e) {
                    // Nếu là tên category
                    CategoryDAO categoryDAO = new CategoryDAO();
                    CategoryDTO category = categoryDAO.searchByName(categoryParam);
                    if (category != null) {
                        categoryId = category.getCategoryId();
                    }
                }
            }
            
            // Parse price
            if (priceMinParam != null && !priceMinParam.isEmpty()) {
                try {
                    // Chuyển từ tỷ VNĐ sang số
                    minPrice = new BigDecimal(priceMinParam).multiply(new BigDecimal("1000000000"));
                } catch (NumberFormatException e) {
                    minPrice = null;
                }
            }
            
            if (priceMaxParam != null && !priceMaxParam.isEmpty()) {
                try {
                    maxPrice = new BigDecimal(priceMaxParam).multiply(new BigDecimal("1000000000"));
                } catch (NumberFormatException e) {
                    maxPrice = null;
                }
            }
            
            // ===== LẤY DỮ LIỆU TỪ DAO =====
            
            CarDAO carDAO = new CarDAO();
            
            // Lấy danh sách xe theo trang + filter
            List<CarDTO> carList = carDAO.getCarsByPageWithFilter(
                currentPage, 
                CARS_PER_PAGE, 
                brandId, 
                categoryId, 
                minPrice, 
                maxPrice, 
                statusParam
            );
            
            // Đếm tổng số xe (để tính số trang)
            int totalCars = carDAO.getTotalCarsWithFilter(
                brandId, 
                categoryId, 
                minPrice, 
                maxPrice, 
                statusParam
            );
            
            // Tính tổng số trang
            int totalPages = (int) Math.ceil((double) totalCars / CARS_PER_PAGE);
            if (totalPages == 0) totalPages = 1;
            
            // ===== LẤY DANH SÁCH BRAND & CATEGORY CHO FILTER =====
            
            BrandDAO brandDAO = new BrandDAO();
            List<BrandDTO> brandList = brandDAO.getAllBrands();
            
            CategoryDAO categoryDAO = new CategoryDAO();
            List<CategoryDTO> categoryList = categoryDAO.getAllCategories();
            
            // ===== GỬI DỮ LIỆU SANG JSP =====
            
            request.setAttribute("carList", carList);
            request.setAttribute("currentPage", currentPage);
            request.setAttribute("totalPages", totalPages);
            request.setAttribute("totalCars", totalCars);
            request.setAttribute("carsPerPage", CARS_PER_PAGE);
            
            // Gửi filter parameters để giữ trạng thái
            request.setAttribute("selectedBrand", brandParam);
            request.setAttribute("selectedCategory", categoryParam);
            request.setAttribute("selectedPriceMin", priceMinParam);
            request.setAttribute("selectedPriceMax", priceMaxParam);
            request.setAttribute("selectedStatus", statusParam);
            request.setAttribute("searchKeyword", searchParam);
            
            // Gửi danh sách brand & category
            request.setAttribute("brandList", brandList);
            request.setAttribute("categoryList", categoryList);
            
            // Log thông tin
            System.out.println("=== CAR LIST SERVLET ===");
            System.out.println("Current Page: " + currentPage);
            System.out.println("Total Cars: " + totalCars);
            System.out.println("Total Pages: " + totalPages);
            System.out.println("Cars in this page: " + carList.size());
            
            // Forward sang JSP
            request.getRequestDispatcher("/cars.jsp").forward(request, response);
            
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, 
                             "Có lỗi xảy ra: " + e.getMessage());
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

    @Override
    public String getServletInfo() {
        return "Car List Servlet with Pagination and Filter";
    }
}