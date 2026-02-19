/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import utils.DbUtils;

/**
 *
 * @author Latitude
 */
public class PaymentDAO {

    public PaymentDAO() {
    }

    /**
     * Thêm thanh toán cho đơn hàng (CREATE) - KHÔNG lấy amount từ client -
     * Amount được lấy trực tiếp từ bảng Order - Chỉ thanh toán khi đơn ở trạng
     * thái PENDING
     *
     * @param payment PaymentDTO
     * @return true nếu thanh toán thành công, false nếu thất bại
     */
    public boolean addPayment(PaymentDTO payment) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();

            String sql = "INSERT INTO Payment(order_id, payment_method, amount, transaction_id, notes) "
                    + "SELECT order_id, ?, total_price, ?, ? "
                    + "FROM [Order] "
                    + "WHERE order_id=? AND status='PENDING'";

            pst = conn.prepareStatement(sql);

            pst.setString(1, payment.getPaymentMethod());
            pst.setString(2, payment.getTransactionId());
            pst.setString(3, payment.getNotes());
            pst.setInt(4, payment.getOrderId());

            return pst.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    /**
     * Cập nhật trạng thái Payment (UPDATE)
     */
    public boolean updatePaymentStatus(int paymentId, String status) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "UPDATE Payment SET payment_status=? WHERE payment_id=?";
            pst = conn.prepareStatement(sql);
            pst.setString(1, status);
            pst.setInt(2, paymentId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    /**
     * Xóa Payment (DELETE)
     */
    public boolean deletePayment(int paymentId) {
        Connection conn = null;
        PreparedStatement pst = null;

        try {
            conn = DbUtils.getConnection();
            String sql = "DELETE FROM Payment WHERE payment_id=?";
            pst = conn.prepareStatement(sql);
            pst.setInt(1, paymentId);
            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            closeResources(conn, pst, null);
        }
        return false;
    }

    private void closeResources(Connection conn, PreparedStatement pst, ResultSet rs) {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pst != null) {
                pst.close();
            }
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
