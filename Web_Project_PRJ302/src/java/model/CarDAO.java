<<<<<<< HEAD
=======
<<<<<<< HEAD
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 *
 * @author VNT
 */
public class CarDAO {
   
        // Số xe mỗi trang
    private static final int CARS_PER_PAGE = 12;
    
    public CarDAO() {
    }
    
    /**
     * Lấy xe theo trang (PAGINATION)
     * @param page - Số trang (bắt đầu từ 1)
     * @param carsPerPage - Số xe mỗi trang
     * @return List<CarDTO>
     */
    public List<CarDTO> getCarsByPage(int page, int carsPerPage) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            
            // Tính OFFSET
            int offset = (page - 1) * carsPerPage;
            
            // SQL Server sử dụng OFFSET ... FETCH
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "ORDER BY c.car_id DESC " +
                        "OFFSET ? ROWS " +
                        "FETCH NEXT ? ROWS ONLY";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, offset);
            pst.setInt(2, carsPerPage);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy xe theo trang với bộ lọc (PAGINATION + FILTER)
     * @param page
     * @param carsPerPage
     * @param brandId - null nếu không lọc
     * @param categoryId - null nếu không lọc
     * @param minPrice - null nếu không lọc
     * @param maxPrice - null nếu không lọc
     * @param status - null nếu không lọc
     * @return List<CarDTO>
     */
    public List<CarDTO> getCarsByPageWithFilter(int page, int carsPerPage, 
                                                  Integer brandId, Integer categoryId,
                                                  BigDecimal minPrice, BigDecimal maxPrice,
                                                  String status) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            int offset = (page - 1) * carsPerPage;
            
            // Build SQL động
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT c.*, cm.model_name, b.brand_name, b.brand_id ");
            sql.append("FROM Car c ");
            sql.append("INNER JOIN CarModel cm ON c.model_id = cm.model_id ");
            sql.append("INNER JOIN Brand b ON cm.brand_id = b.brand_id ");
            
            // Nếu filter theo category, cần JOIN thêm
            if (categoryId != null) {
                sql.append("LEFT JOIN CarCategory cc ON c.car_id = cc.car_id ");
            }
            
            // WHERE clause
            List<String> conditions = new ArrayList<>();
            if (brandId != null) {
                conditions.add("b.brand_id = ?");
            }
            if (categoryId != null) {
                conditions.add("cc.category_id = ?");
            }
            if (minPrice != null) {
                conditions.add("c.price >= ?");
            }
            if (maxPrice != null) {
                conditions.add("c.price <= ?");
            }
            if (status != null && !status.isEmpty()) {
                conditions.add("c.status = ?");
            }
            
            if (!conditions.isEmpty()) {
                sql.append("WHERE ");
                sql.append(String.join(" AND ", conditions));
                sql.append(" ");
            }
            
            sql.append("ORDER BY c.car_id DESC ");
            sql.append("OFFSET ? ROWS FETCH NEXT ? ROWS ONLY");
            
            pst = conn.prepareStatement(sql.toString());
            
            // Set parameters
            int paramIndex = 1;
            if (brandId != null) {
                pst.setInt(paramIndex++, brandId);
            }
            if (categoryId != null) {
                pst.setInt(paramIndex++, categoryId);
            }
            if (minPrice != null) {
                pst.setBigDecimal(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                pst.setBigDecimal(paramIndex++, maxPrice);
            }
            if (status != null && !status.isEmpty()) {
                pst.setString(paramIndex++, status);
            }
            pst.setInt(paramIndex++, offset);
            pst.setInt(paramIndex++, carsPerPage);
            
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Đếm tổng số xe (để tính số trang)
     * @return int
     */
    public int getTotalCars() {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) as total FROM Car";
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return 0;
    }
    
    /**
     * Đếm tổng số xe với bộ lọc (để tính số trang)
     * @param brandId
     * @param categoryId
     * @param minPrice
     * @param maxPrice
     * @param status
     * @return int
     */
    public int getTotalCarsWithFilter(Integer brandId, Integer categoryId,
                                      BigDecimal minPrice, BigDecimal maxPrice,
                                      String status) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT COUNT(DISTINCT c.car_id) as total ");
            sql.append("FROM Car c ");
            sql.append("INNER JOIN CarModel cm ON c.model_id = cm.model_id ");
            sql.append("INNER JOIN Brand b ON cm.brand_id = b.brand_id ");
            
            if (categoryId != null) {
                sql.append("LEFT JOIN CarCategory cc ON c.car_id = cc.car_id ");
            }
            
            List<String> conditions = new ArrayList<>();
            if (brandId != null) {
                conditions.add("b.brand_id = ?");
            }
            if (categoryId != null) {
                conditions.add("cc.category_id = ?");
            }
            if (minPrice != null) {
                conditions.add("c.price >= ?");
            }
            if (maxPrice != null) {
                conditions.add("c.price <= ?");
            }
            if (status != null && !status.isEmpty()) {
                conditions.add("c.status = ?");
            }
            
            if (!conditions.isEmpty()) {
                sql.append("WHERE ");
                sql.append(String.join(" AND ", conditions));
            }
            
            pst = conn.prepareStatement(sql.toString());
            
            int paramIndex = 1;
            if (brandId != null) {
                pst.setInt(paramIndex++, brandId);
            }
            if (categoryId != null) {
                pst.setInt(paramIndex++, categoryId);
            }
            if (minPrice != null) {
                pst.setBigDecimal(paramIndex++, minPrice);
            }
            if (maxPrice != null) {
                pst.setBigDecimal(paramIndex++, maxPrice);
            }
            if (status != null && !status.isEmpty()) {
                pst.setString(paramIndex++, status);
            }
            
            rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return 0;
    }
    
    /**
     * Tìm xe theo ID
     * @param id
     * @return CarDTO hoặc null
     */
    public CarDTO searchById(int id) {
        CarDTO car = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.car_id = ?";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                car = extractCarFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return car;
    }
    
    // ===== HELPER METHODS =====
    
    /**
     * Trích xuất CarDTO từ ResultSet
     */
    private CarDTO extractCarFromResultSet(ResultSet rs) throws SQLException {
        int carId = rs.getInt("car_id");
        int modelId = rs.getInt("model_id");
        BigDecimal price = rs.getBigDecimal("price");
        String color = rs.getString("color");
        String engine = rs.getString("engine");
        String transmission = rs.getString("transmission");
        int mileage = rs.getInt("mileage");
        String status = rs.getString("status");
        String description = rs.getString("description");
        Timestamp createdAt = rs.getTimestamp("created_at");
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        
        String modelName = rs.getString("model_name");
        String brandName = rs.getString("brand_name");
        int brandId = rs.getInt("brand_id");
        
        return new CarDTO(carId, modelId, price, color, engine, transmission, 
                         mileage, status, description, createdAt, updatedAt, 
                         modelName, brandName, brandId);
    }
    
    /**
     * Đóng resources
     */
    private void closeResources(Connection conn, PreparedStatement pst, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    /**
     * Lấy tất cả xe
     * @return List<CarDTO>
     */
    public List<CarDTO> getAllCars() {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy tất cả xe đang AVAILABLE (có sẵn để bán)
     * @return List<CarDTO>
     */
    public List<CarDTO> getAvailableCars() {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.status = 'AVAILABLE' " +
                        "ORDER BY c.created_at DESC";
            
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Tìm kiếm xe theo nhiều tiêu chí
     * @param keyword - Từ khóa tìm kiếm (tên model, brand, màu, mô tả)
     * @return List<CarDTO>
     */
    public List<CarDTO> searchCars(String keyword) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE cm.model_name LIKE ? OR b.brand_name LIKE ? " +
                        "OR c.color LIKE ? OR c.description LIKE ? " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pst.setString(1, searchPattern);
            pst.setString(2, searchPattern);
            pst.setString(3, searchPattern);
            pst.setString(4, searchPattern);
            
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lọc xe theo khoảng giá
     * @param minPrice
     * @param maxPrice
     * @return List<CarDTO>
     */
    public List<CarDTO> filterByPrice(BigDecimal minPrice, BigDecimal maxPrice) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.price BETWEEN ? AND ? " +
                        "ORDER BY c.price ASC";
            
            pst = conn.prepareStatement(sql);
            pst.setBigDecimal(1, minPrice);
            pst.setBigDecimal(2, maxPrice);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy xe theo Brand (hãng xe)
     * @param brandId
     * @return List<CarDTO>
     */
    public List<CarDTO> getCarsByBrand(int brandId) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE b.brand_id = ? " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, brandId);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy xe theo Model
     * @param modelId
     * @return List<CarDTO>
     */
    public List<CarDTO> getCarsByModel(int modelId) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.model_id = ? " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, modelId);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy xe theo trạng thái (AVAILABLE, SOLD, RESERVED)
     * @param status
     * @return List<CarDTO>
     */
    public List<CarDTO> getCarsByStatus(String status) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.status = ? " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setString(1, status);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Thêm xe mới (CREATE)
     * @param car
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean addCar(CarDTO car) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, car.getModelId());
            pst.setBigDecimal(2, car.getPrice());
            pst.setString(3, car.getColor());
            pst.setString(4, car.getEngine());
            pst.setString(5, car.getTransmission());
            pst.setInt(6, car.getMileage());
            pst.setString(7, car.getStatus());
            pst.setString(8, car.getDescription());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Cập nhật thông tin xe (UPDATE)
     * @param car
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCar(CarDTO car) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Car SET model_id=?, price=?, color=?, engine=?, transmission=?, " +
                        "mileage=?, status=?, description=?, updated_at=GETDATE() " +
                        "WHERE car_id=?";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, car.getModelId());
            pst.setBigDecimal(2, car.getPrice());
            pst.setString(3, car.getColor());
            pst.setString(4, car.getEngine());
            pst.setString(5, car.getTransmission());
            pst.setInt(6, car.getMileage());
            pst.setString(7, car.getStatus());
            pst.setString(8, car.getDescription());
            pst.setInt(9, car.getCarId());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Xóa xe (DELETE)
     * @param carId
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteCar(int carId) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM Car WHERE car_id=?";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, carId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Cập nhật trạng thái xe (AVAILABLE, SOLD, RESERVED)
     * @param carId
     * @param status
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCarStatus(int carId, String status) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Car SET status=?, updated_at=GETDATE() WHERE car_id=?";
            
            pst = conn.prepareStatement(sql);
            pst.setString(1, status);
            pst.setInt(2, carId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Cập nhật giá xe
     * @param carId
     * @param newPrice
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCarPrice(int carId, BigDecimal newPrice) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Car SET price=?, updated_at=GETDATE() WHERE car_id=?";
            
            pst = conn.prepareStatement(sql);
            pst.setBigDecimal(1, newPrice);
            pst.setInt(2, carId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Đếm số xe theo trạng thái
     * @param status
     * @return int
     */
    public int countCarsByStatus(String status) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) as total FROM Car WHERE status=?";
            
            pst = conn.prepareStatement(sql);
            pst.setString(1, status);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return 0;
    }
    
    /**
     * Lấy Top N xe đắt nhất
     * @param limit
     * @return List<CarDTO>
     */
    public List<CarDTO> getTopExpensiveCars(int limit) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT TOP (?) c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "ORDER BY c.price DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, limit);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy xe mới nhất
     * @param limit
     * @return List<CarDTO>
     */
    public List<CarDTO> getNewestCars(int limit) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT TOP (?) c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.status = 'AVAILABLE' " +
                        "ORDER BY c.created_at DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, limit);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
}
=======
>>>>>>> c352d8c (clean tracked files)
/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 *
 * @author VNT
 */
public class CarDAO {
    
    public CarDAO() {
    }
    
    /**
     * Tìm xe theo ID
     * @param id
     * @return CarDTO hoặc null nếu không tìm thấy
     */
    public CarDTO searchById(int id) {
        CarDTO car = null;
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.car_id = ?";
            
            System.out.println(sql);
            pst = conn.prepareStatement(sql);
            pst.setInt(1, id);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                car = extractCarFromResultSet(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        System.out.println(car);
        return car;
    }
    
    /**
     * Lấy tất cả xe
     * @return List<CarDTO>
     */
    public List<CarDTO> getAllCars() {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy tất cả xe đang AVAILABLE (có sẵn để bán)
     * @return List<CarDTO>
     */
    public List<CarDTO> getAvailableCars() {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.status = 'AVAILABLE' " +
                        "ORDER BY c.created_at DESC";
            
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Tìm kiếm xe theo nhiều tiêu chí
     * @param keyword - Từ khóa tìm kiếm (tên model, brand, màu, mô tả)
     * @return List<CarDTO>
     */
    public List<CarDTO> searchCars(String keyword) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE cm.model_name LIKE ? OR b.brand_name LIKE ? " +
                        "OR c.color LIKE ? OR c.description LIKE ? " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            String searchPattern = "%" + keyword + "%";
            pst.setString(1, searchPattern);
            pst.setString(2, searchPattern);
            pst.setString(3, searchPattern);
            pst.setString(4, searchPattern);
            
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lọc xe theo khoảng giá
     * @param minPrice
     * @param maxPrice
     * @return List<CarDTO>
     */
    public List<CarDTO> filterByPrice(BigDecimal minPrice, BigDecimal maxPrice) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.price BETWEEN ? AND ? " +
                        "ORDER BY c.price ASC";
            
            pst = conn.prepareStatement(sql);
            pst.setBigDecimal(1, minPrice);
            pst.setBigDecimal(2, maxPrice);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy xe theo Brand (hãng xe)
     * @param brandId
     * @return List<CarDTO>
     */
    public List<CarDTO> getCarsByBrand(int brandId) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE b.brand_id = ? " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, brandId);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy xe theo Model
     * @param modelId
     * @return List<CarDTO>
     */
    public List<CarDTO> getCarsByModel(int modelId) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.model_id = ? " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, modelId);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy xe theo trạng thái (AVAILABLE, SOLD, RESERVED)
     * @param status
     * @return List<CarDTO>
     */
    public List<CarDTO> getCarsByStatus(String status) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.status = ? " +
                        "ORDER BY c.car_id DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setString(1, status);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Thêm xe mới (CREATE)
     * @param car
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean addCar(CarDTO car) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) " +
                        "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, car.getModelId());
            pst.setBigDecimal(2, car.getPrice());
            pst.setString(3, car.getColor());
            pst.setString(4, car.getEngine());
            pst.setString(5, car.getTransmission());
            pst.setInt(6, car.getMileage());
            pst.setString(7, car.getStatus());
            pst.setString(8, car.getDescription());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Cập nhật thông tin xe (UPDATE)
     * @param car
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCar(CarDTO car) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Car SET model_id=?, price=?, color=?, engine=?, transmission=?, " +
                        "mileage=?, status=?, description=?, updated_at=GETDATE() " +
                        "WHERE car_id=?";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, car.getModelId());
            pst.setBigDecimal(2, car.getPrice());
            pst.setString(3, car.getColor());
            pst.setString(4, car.getEngine());
            pst.setString(5, car.getTransmission());
            pst.setInt(6, car.getMileage());
            pst.setString(7, car.getStatus());
            pst.setString(8, car.getDescription());
            pst.setInt(9, car.getCarId());
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Xóa xe (DELETE)
     * @param carId
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteCar(int carId) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM Car WHERE car_id=?";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, carId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Cập nhật trạng thái xe (AVAILABLE, SOLD, RESERVED)
     * @param carId
     * @param status
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCarStatus(int carId, String status) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Car SET status=?, updated_at=GETDATE() WHERE car_id=?";
            
            pst = conn.prepareStatement(sql);
            pst.setString(1, status);
            pst.setInt(2, carId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Cập nhật giá xe
     * @param carId
     * @param newPrice
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean updateCarPrice(int carId, BigDecimal newPrice) {
        Connection conn = null;
        PreparedStatement pst = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Car SET price=?, updated_at=GETDATE() WHERE car_id=?";
            
            pst = conn.prepareStatement(sql);
            pst.setBigDecimal(1, newPrice);
            pst.setInt(2, carId);
            
            int rowsAffected = pst.executeUpdate();
            return rowsAffected > 0;
            
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        } finally {
            closeResources(conn, pst, null);
        }
    }
    
    /**
     * Đếm tổng số xe
     * @return int
     */
    public int getTotalCars() {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) as total FROM Car";
            
            pst = conn.prepareStatement(sql);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return 0;
    }
    
    /**
     * Đếm số xe theo trạng thái
     * @param status
     * @return int
     */
    public int countCarsByStatus(String status) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT COUNT(*) as total FROM Car WHERE status=?";
            
            pst = conn.prepareStatement(sql);
            pst.setString(1, status);
            rs = pst.executeQuery();
            
            if (rs.next()) {
                return rs.getInt("total");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return 0;
    }
    
    /**
     * Lấy Top N xe đắt nhất
     * @param limit
     * @return List<CarDTO>
     */
    public List<CarDTO> getTopExpensiveCars(int limit) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT TOP (?) c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "ORDER BY c.price DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, limit);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    /**
     * Lấy xe mới nhất
     * @param limit
     * @return List<CarDTO>
     */
    public List<CarDTO> getNewestCars(int limit) {
        List<CarDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;
        
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT TOP (?) c.*, cm.model_name, b.brand_name, b.brand_id " +
                        "FROM Car c " +
                        "INNER JOIN CarModel cm ON c.model_id = cm.model_id " +
                        "INNER JOIN Brand b ON cm.brand_id = b.brand_id " +
                        "WHERE c.status = 'AVAILABLE' " +
                        "ORDER BY c.created_at DESC";
            
            pst = conn.prepareStatement(sql);
            pst.setInt(1, limit);
            rs = pst.executeQuery();
            
            while (rs.next()) {
                CarDTO car = extractCarFromResultSet(rs);
                list.add(car);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        
        return list;
    }
    
    // ===== HELPER METHODS =====
    
    /**
     * Trích xuất thông tin Car từ ResultSet
     * @param rs
     * @return CarDTO
     * @throws SQLException
     */
    private CarDTO extractCarFromResultSet(ResultSet rs) throws SQLException {
        int carId = rs.getInt("car_id");
        int modelId = rs.getInt("model_id");
        BigDecimal price = rs.getBigDecimal("price");
        String color = rs.getString("color");
        String engine = rs.getString("engine");
        String transmission = rs.getString("transmission");
        int mileage = rs.getInt("mileage");
        String status = rs.getString("status");
        String description = rs.getString("description");
        Timestamp createdAt = rs.getTimestamp("created_at");
        Timestamp updatedAt = rs.getTimestamp("updated_at");
        
        // Thông tin từ JOIN
        String modelName = rs.getString("model_name");
        String brandName = rs.getString("brand_name");
        int brandId = rs.getInt("brand_id");
        
        return new CarDTO(carId, modelId, price, color, engine, transmission, 
                         mileage, status, description, createdAt, updatedAt, 
                         modelName, brandName, brandId);
    }
    
    /**
     * Đóng các resources (Connection, PreparedStatement, ResultSet)
     * @param conn
     * @param pst
     * @param rs
     */
    private void closeResources(Connection conn, PreparedStatement pst, ResultSet rs) {
        try {
            if (rs != null) rs.close();
            if (pst != null) pst.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
<<<<<<< HEAD
=======
>>>>>>> b28e309bb64eae46f8e51c1be1faa09d6c4c12de
>>>>>>> c352d8c (clean tracked files)
