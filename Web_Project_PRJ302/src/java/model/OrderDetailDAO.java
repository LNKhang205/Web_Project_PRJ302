/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

/**
 *
 * @author Latitude
 */
public class OrderDetailDAO {

    public OrderDetailDAO() {
    }

    /**
     * Thêm OrderDetail (CREATE)
     */
    public boolean addOrderDetail(OrderDetailDTO d) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "INSERT INTO OrderDetail(order_id, car_id, price) VALUES (?, ?, ?)";
            pst = conn.prepareStatement(sql);

            pst.setInt(1, d.getOrderId());
            pst.setInt(2, d.getCarId());
            pst.setDouble(3, d.getPrice());

            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    /**
     * Lấy OrderDetail theo Order (READ)
     */
    public List<OrderDetailDTO> getByOrder(int orderId) {
        List<OrderDetailDTO> list = new ArrayList<>();
        Connection conn = null;
        PreparedStatement pst = null;
        ResultSet rs = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT * FROM OrderDetail WHERE order_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, orderId);
            rs = pst.executeQuery();

            while (rs.next()) {
                list.add(extract(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, rs);
        }
        return list;
    }

    /**
     * Xóa OrderDetail (DELETE)
     */
    public boolean deleteByOrder(int orderId) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM OrderDetail WHERE order_id=?";
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

    private OrderDetailDTO extract(ResultSet rs) throws SQLException {
        return new OrderDetailDTO(
                rs.getInt("order_detail_id"),
                rs.getInt("order_id"),
                rs.getInt("car_id"),
                rs.getDouble("price"),
                rs.getTimestamp("created_at")
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

