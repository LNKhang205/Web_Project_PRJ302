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
