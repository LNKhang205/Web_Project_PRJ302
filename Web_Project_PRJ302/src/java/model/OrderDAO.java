/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;


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
 * @author Latitude
 */
public class OrderDAO {

    public OrderDAO() {
    }

    /**
     * Thêm Order mới (CREATE)
     * @param order
     * @return order_id nếu thành công, -1 nếu thất bại
     */
    public int addOrder(OrderDTO order) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO [Order](user_id, total_price, shipping_address, notes) VALUES (?, ?, ?, ?)";
            pst = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);

            pst.setInt(1, order.getUserId());
            pst.setDouble(2, order.getTotalPrice());
            pst.setString(3, order.getShippingAddress());
            pst.setString(4, order.getNotes());

            pst.executeUpdate();
            rs = pst.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return -1;
    }

    /**
     * Lấy Order theo ID (READ)
     * @param orderId
     * @return OrderDTO hoặc null
     */
    public OrderDTO getOrderById(int orderId) {
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM [Order] WHERE order_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);
            rs = pst.executeQuery();

            if (rs.next()) {
                return extractOrder(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return null;
    }

    /**
     * Lấy danh sách Order theo User (READ)
     * @param userId
     * @return List<OrderDTO>
     */
    public List<OrderDTO> getOrdersByUser(int userId) {
        List<OrderDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM [Order] WHERE user_id=? ORDER BY order_date DESC";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, userId);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extractOrder(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    /**
 * Cập nhật đơn hàng (UPDATE)
 * - Chỉ cho phép cập nhật khi đơn ở trạng thái PENDING
 * - Không cho client sửa total_price
 * - Kiểm tra đúng user sở hữu đơn hàng
 *
 * @param order OrderDTO
 * @return true nếu cập nhật thành công, false nếu thất bại
 */
    public boolean updateOrder(OrderDTO order) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE [Order] SET total_price=?, status=?, shipping_address=?, notes=?, updated_at=GETDATE() WHERE order_id=? AND user_id=?";
            pst = conn.prepareStatement(sql);

            pst.setDouble(1, order.getTotalPrice());
            pst.setString(2, order.getStatus());
            pst.setString(3, order.getShippingAddress());
            pst.setString(4, order.getNotes());
            pst.setInt(5, order.getOrderId());
            pst.setInt(6, order.getUserId());

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    /**
     * Xóa Order (DELETE)
     * @param orderId
     * @return true nếu thành công, false nếu thất bại
     */
    public boolean deleteOrder(int orderId) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM [Order] WHERE order_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    // ===== HELPER =====
    private OrderDTO extractOrder(ResultSet rs) throws SQLException {
        return new OrderDTO(
                rs.getInt("order_id"),
                rs.getInt("user_id"),
                rs.getTimestamp("order_date"),
                rs.getDouble("total_price"),
                rs.getString("status"),
                rs.getString("shipping_address"),
                rs.getString("notes"),
                rs.getTimestamp("created_at"),
                rs.getTimestamp("updated_at")
        );
    }

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