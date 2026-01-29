-- =====================================================
-- DATABASE: LUXURY CAR SALES WEBSITE (SQL SERVER)
-- Tạo bởi: Student Project
-- Ngày: 29/01/2026
-- Mô tả: Database cho website bán xe sang với 11 bảng
-- Hệ quản trị: Microsoft SQL Server
-- =====================================================

-- Xóa database cũ nếu tồn tại
USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'LuxuryCarSales')
BEGIN
    ALTER DATABASE LuxuryCarSales SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE LuxuryCarSales;
END
GO

-- Tạo database mới
CREATE DATABASE LuxuryCarSales;
GO

-- Sử dụng database
USE LuxuryCarSales;
GO

-- =====================================================
-- 1. BẢNG USER (Người dùng)
-- =====================================================
CREATE TABLE [User] (
    user_id INT PRIMARY KEY IDENTITY(1,1),
    username NVARCHAR(50) UNIQUE NOT NULL,
    password NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(100) NOT NULL,
    email NVARCHAR(100) UNIQUE NOT NULL,
    phone NVARCHAR(20),
    role NVARCHAR(20) CHECK (role IN ('ADMIN', 'CUSTOMER')) DEFAULT 'CUSTOMER',
    status NVARCHAR(20) CHECK (status IN ('ACTIVE', 'INACTIVE', 'BLOCKED')) DEFAULT 'ACTIVE',
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE()
);
GO

-- =====================================================
-- 2. BẢNG BRAND (Hãng xe)
-- =====================================================
CREATE TABLE Brand (
    brand_id INT PRIMARY KEY IDENTITY(1,1),
    brand_name NVARCHAR(50) UNIQUE NOT NULL,
    country NVARCHAR(50),
    description NVARCHAR(MAX),
    logo NVARCHAR(255),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- =====================================================
-- 3. BẢNG CARMODEL (Dòng xe)
-- =====================================================
CREATE TABLE CarModel (
    model_id INT PRIMARY KEY IDENTITY(1,1),
    model_name NVARCHAR(100) NOT NULL,
    brand_id INT NOT NULL,
    year INT,
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (brand_id) REFERENCES Brand(brand_id) ON DELETE CASCADE
);
GO

-- =====================================================
-- 4. BẢNG CAR (Xe cụ thể)
-- =====================================================
CREATE TABLE Car (
    car_id INT PRIMARY KEY IDENTITY(1,1),
    model_id INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    color NVARCHAR(50),
    engine NVARCHAR(100),
    transmission NVARCHAR(20) CHECK (transmission IN ('AUTOMATIC', 'MANUAL', 'CVT', 'DCT')) DEFAULT 'AUTOMATIC',
    mileage INT DEFAULT 0,
    status NVARCHAR(20) CHECK (status IN ('AVAILABLE', 'SOLD', 'RESERVED')) DEFAULT 'AVAILABLE',
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (model_id) REFERENCES CarModel(model_id) ON DELETE CASCADE
);
GO

-- =====================================================
-- 5. BẢNG CARIMAGE (Hình ảnh xe)
-- =====================================================
CREATE TABLE CarImage (
    image_id INT PRIMARY KEY IDENTITY(1,1),
    car_id INT NOT NULL,
    image_url NVARCHAR(255) NOT NULL,
    is_primary BIT DEFAULT 0,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (car_id) REFERENCES Car(car_id) ON DELETE CASCADE
);
GO

-- =====================================================
-- 6. BẢNG CATEGORY (Phân loại xe)
-- =====================================================
CREATE TABLE Category (
    category_id INT PRIMARY KEY IDENTITY(1,1),
    category_name NVARCHAR(50) UNIQUE NOT NULL,
    description NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE()
);
GO

-- =====================================================
-- 7. BẢNG CARCATEGORY (Bảng trung gian - Quan hệ N-N)
-- =====================================================
CREATE TABLE CarCategory (
    car_id INT NOT NULL,
    category_id INT NOT NULL,
    PRIMARY KEY (car_id, category_id),
    FOREIGN KEY (car_id) REFERENCES Car(car_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Category(category_id) ON DELETE CASCADE
);
GO

-- =====================================================
-- 8. BẢNG ORDER (Đơn hàng)
-- =====================================================
CREATE TABLE [Order] (
    order_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    order_date DATETIME DEFAULT GETDATE(),
    total_price DECIMAL(15, 2) NOT NULL,
    status NVARCHAR(20) CHECK (status IN ('PENDING', 'PAID', 'CANCELLED', 'COMPLETED')) DEFAULT 'PENDING',
    shipping_address NVARCHAR(MAX),
    notes NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    updated_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [User](user_id) ON DELETE CASCADE
);
GO

-- =====================================================
-- 9. BẢNG ORDERDETAIL (Chi tiết đơn hàng)
-- =====================================================
CREATE TABLE OrderDetail (
    order_detail_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    car_id INT NOT NULL,
    price DECIMAL(15, 2) NOT NULL,
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (order_id) REFERENCES [Order](order_id) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES Car(car_id)
);
GO

-- =====================================================
-- 10. BẢNG PAYMENT (Thanh toán)
-- =====================================================
CREATE TABLE Payment (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    order_id INT NOT NULL,
    payment_method NVARCHAR(20) CHECK (payment_method IN ('CASH', 'BANK_TRANSFER', 'CREDIT_CARD', 'INSTALLMENT')) NOT NULL,
    payment_date DATETIME DEFAULT GETDATE(),
    payment_status NVARCHAR(20) CHECK (payment_status IN ('PENDING', 'COMPLETED', 'FAILED', 'REFUNDED')) DEFAULT 'PENDING',
    amount DECIMAL(15, 2) NOT NULL,
    transaction_id NVARCHAR(100),
    notes NVARCHAR(MAX),
    FOREIGN KEY (order_id) REFERENCES [Order](order_id) ON DELETE CASCADE
);
GO

-- =====================================================
-- 11. BẢNG REVIEW (Đánh giá xe)
-- =====================================================
CREATE TABLE Review (
    review_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT NOT NULL,
    car_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(MAX),
    review_date DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES [User](user_id) ON DELETE CASCADE,
    FOREIGN KEY (car_id) REFERENCES Car(car_id)
);
GO

-- =====================================================
-- INSERT DỮ LIỆU MẪU
-- =====================================================

-- Thêm User
INSERT INTO [User] (username, password, full_name, email, phone, role, status) VALUES
(N'admin', N'admin123', N'Nguyễn Văn Admin', N'admin@luxurycars.vn', N'0901234567', N'ADMIN', N'ACTIVE'),
(N'khachhang1', N'pass123', N'Trần Thị Hương', N'huong@gmail.com', N'0912345678', N'CUSTOMER', N'ACTIVE'),
(N'khachhang2', N'pass123', N'Lê Văn Minh', N'minh@gmail.com', N'0923456789', N'CUSTOMER', N'ACTIVE'),
(N'khachhang3', N'pass123', N'Phạm Thị Lan', N'lan@gmail.com', N'0934567890', N'CUSTOMER', N'ACTIVE');
GO

-- Thêm Brand
INSERT INTO Brand (brand_name, country, description, logo) VALUES
(N'Mercedes-Benz', N'Germany', N'Hãng xe sang đến từ Đức, nổi tiếng với chất lượng cao cấp', N'mercedes_logo.png'),
(N'BMW', N'Germany', N'Bayerische Motoren Werke - Xe thể thao cao cấp Đức', N'bmw_logo.png'),
(N'Audi', N'Germany', N'Xe sang Đức với công nghệ tiên tiến', N'audi_logo.png'),
(N'Lamborghini', N'Italy', N'Siêu xe thể thao cao cấp Italy', N'lamborghini_logo.png'),
(N'Rolls-Royce', N'United Kingdom', N'Xe siêu sang đỉnh cao', N'rollsroyce_logo.png'),
(N'Porsche', N'Germany', N'Xe thể thao hiệu suất cao', N'porsche_logo.png'),
(N'Ferrari', N'Italy', N'Siêu xe thể thao huyền thoại', N'ferrari_logo.png');
GO

-- Thêm CarModel
INSERT INTO CarModel (model_name, brand_id, year, description) VALUES
(N'S-Class', 1, 2024, N'Dòng sedan sang trọng nhất của Mercedes'),
(N'E-Class', 1, 2024, N'Sedan hạng sang cỡ trung'),
(N'G-Class', 1, 2024, N'SUV địa hình cao cấp'),
(N'7 Series', 2, 2024, N'Sedan hạng sang đầu bảng BMW'),
(N'X7', 2, 2024, N'SUV cỡ lớn sang trọng'),
(N'A8', 3, 2024, N'Sedan hạng sang Audi'),
(N'Q8', 3, 2024, N'SUV coupe thể thao'),
(N'Aventador', 4, 2023, N'Siêu xe V12 huyền thoại'),
(N'Phantom', 5, 2024, N'Xe siêu sang đỉnh cao'),
(N'911 Turbo S', 6, 2024, N'Xe thể thao iconic'),
(N'F8 Tributo', 7, 2023, N'Siêu xe V8 twin-turbo');
GO

-- Thêm Car
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(1, 5500000000, N'Black', N'V8 4.0L Twin-Turbo', N'AUTOMATIC', 0, N'AVAILABLE', N'Mercedes S500 2024 mới 100%'),
(1, 7800000000, N'White Pearl', N'V12 6.0L Twin-Turbo', N'AUTOMATIC', 0, N'AVAILABLE', N'Mercedes S680 Maybach 2024'),
(2, 3200000000, N'Silver', N'I4 2.0L Turbo', N'AUTOMATIC', 5000, N'AVAILABLE', N'Mercedes E300 2024 đã qua sử dụng'),
(3, 8500000000, N'Matte Black', N'V8 4.0L BiTurbo', N'AUTOMATIC', 0, N'AVAILABLE', N'Mercedes G63 AMG 2024'),
(4, 6200000000, N'Blue Metallic', N'I6 3.0L Twin-Turbo', N'AUTOMATIC', 0, N'AVAILABLE', N'BMW 740Li 2024'),
(5, 7500000000, N'White', N'V8 4.4L Twin-Turbo', N'AUTOMATIC', 0, N'SOLD', N'BMW X7 M60i 2024'),
(6, 5800000000, N'Gray', N'V6 3.0L TFSI', N'AUTOMATIC', 0, N'AVAILABLE', N'Audi A8L 2024'),
(7, 6500000000, N'Red', N'V8 4.0L TFSI', N'AUTOMATIC', 0, N'AVAILABLE', N'Audi Q8 2024'),
(8, 35000000000, N'Orange', N'V12 6.5L', N'AUTOMATIC', 1000, N'RESERVED', N'Lamborghini Aventador SVJ 2023'),
(9, 80000000000, N'Black Diamond', N'V12 6.75L Twin-Turbo', N'AUTOMATIC', 0, N'AVAILABLE', N'Rolls-Royce Phantom Extended 2024'),
(10, 18000000000, N'Yellow', N'Flat-6 3.8L Twin-Turbo', N'DCT', 0, N'AVAILABLE', N'Porsche 911 Turbo S 2024'),
(11, 32000000000, N'Rosso Corsa', N'V8 3.9L Twin-Turbo', N'DCT', 500, N'AVAILABLE', N'Ferrari F8 Tributo 2023');
GO

-- Thêm CarImage
INSERT INTO CarImage (car_id, image_url, is_primary) VALUES
(1, N'images/s500_front.jpg', 1),
(1, N'images/s500_side.jpg', 0),
(1, N'images/s500_interior.jpg', 0),
(2, N'images/s680_front.jpg', 1),
(3, N'images/e300_front.jpg', 1),
(4, N'images/g63_front.jpg', 1),
(4, N'images/g63_side.jpg', 0),
(5, N'images/740li_front.jpg', 1),
(6, N'images/x7_front.jpg', 1),
(7, N'images/a8l_front.jpg', 1),
(8, N'images/q8_front.jpg', 1),
(9, N'images/aventador_front.jpg', 1),
(9, N'images/aventador_side.jpg', 0),
(10, N'images/phantom_front.jpg', 1),
(11, N'images/911_front.jpg', 1),
(12, N'images/f8_front.jpg', 1);
GO

-- Thêm Category
INSERT INTO Category (category_name, description) VALUES
(N'Sedan', N'Xe sedan sang trọng'),
(N'SUV', N'Xe SUV địa hình cao cấp'),
(N'Coupe', N'Xe coupe thể thao'),
(N'Supercar', N'Siêu xe hiệu suất cao'),
(N'Limousine', N'Xe limousine siêu sang'),
(N'Electric', N'Xe điện cao cấp'),
(N'Hybrid', N'Xe hybrid tiết kiệm nhiên liệu');
GO

-- Thêm CarCategory (Quan hệ N-N)
INSERT INTO CarCategory (car_id, category_id) VALUES
(1, 1), (1, 5),  -- S500: Sedan, Limousine
(2, 1), (2, 5),  -- S680: Sedan, Limousine
(3, 1),          -- E300: Sedan
(4, 2),          -- G63: SUV
(5, 1), (5, 5),  -- 740Li: Sedan, Limousine
(6, 2),          -- X7: SUV
(7, 1), (7, 5),  -- A8L: Sedan, Limousine
(8, 2), (8, 3),  -- Q8: SUV, Coupe
(9, 4), (9, 3),  -- Aventador: Supercar, Coupe
(10, 1), (10, 5),-- Phantom: Sedan, Limousine
(11, 4), (11, 3),-- 911: Supercar, Coupe
(12, 4), (12, 3);-- F8: Supercar, Coupe
GO

-- Thêm Order
SET IDENTITY_INSERT [Order] ON;
INSERT INTO [Order] (order_id, user_id, total_price, status, shipping_address, notes) VALUES
(1, 2, 7500000000, N'COMPLETED', N'123 Nguyễn Huệ, Q1, TP.HCM', N'Giao xe tận nhà'),
(2, 3, 35000000000, N'PENDING', N'456 Lê Lợi, Q1, TP.HCM', N'Cần tư vấn thêm về bảo hiểm'),
(3, 4, 5500000000, N'PAID', N'789 Trần Hưng Đạo, Q5, TP.HCM', N'Thanh toán trước 50%');
SET IDENTITY_INSERT [Order] OFF;
GO

-- Thêm OrderDetail
INSERT INTO OrderDetail (order_id, car_id, price) VALUES
(1, 6, 7500000000),   -- BMW X7
(2, 9, 35000000000),  -- Lamborghini Aventador
(3, 1, 5500000000);   -- Mercedes S500
GO

-- Thêm Payment
INSERT INTO Payment (order_id, payment_method, payment_status, amount, transaction_id, notes) VALUES
(1, N'BANK_TRANSFER', N'COMPLETED', 7500000000, N'TXN001234567', N'Đã chuyển khoản toàn bộ'),
(2, N'INSTALLMENT', N'PENDING', 10000000000, N'TXN001234568', N'Trả trước 10 tỷ, còn lại trả góp 24 tháng'),
(3, N'BANK_TRANSFER', N'COMPLETED', 2750000000, N'TXN001234569', N'Đặt cọc 50%');
GO

-- Thêm Review
INSERT INTO Review (user_id, car_id, rating, comment) VALUES
(2, 6, 5, N'Xe rất tuyệt vời! Sang trọng và êm ái. Đáng đồng tiền bát gạo.'),
(3, 1, 4, N'Mercedes S-Class thật sự đẳng cấp, tuy nhiên giá hơi cao.'),
(4, 4, 5, N'G63 AMG quá đỉnh! Mạnh mẽ và bụi bặm. Rất hài lòng.'),
(2, 3, 4, N'E300 tốt cho giá này, nhưng đã qua sử dụng nên cần kiểm tra kỹ.');
GO

-- =====================================================
-- CÁC QUERY HỮU ÍCH ĐỂ TEST
-- =====================================================

-- 1. Xem tất cả xe còn available
-- SELECT c.*, cm.model_name, b.brand_name 
-- FROM Car c
-- INNER JOIN CarModel cm ON c.model_id = cm.model_id
-- INNER JOIN Brand b ON cm.brand_id = b.brand_id
-- WHERE c.status = 'AVAILABLE';

-- 2. Xem tất cả đơn hàng với thông tin khách hàng
-- SELECT o.*, u.full_name, u.email, u.phone
-- FROM [Order] o
-- INNER JOIN [User] u ON o.user_id = u.user_id;

-- 3. Xem xe theo category
-- SELECT c.*, cm.model_name, b.brand_name, cat.category_name
-- FROM Car c
-- INNER JOIN CarModel cm ON c.model_id = cm.model_id
-- INNER JOIN Brand b ON cm.brand_id = b.brand_id
-- INNER JOIN CarCategory cc ON c.car_id = cc.car_id
-- INNER JOIN Category cat ON cc.category_id = cat.category_id
-- WHERE cat.category_name = N'Supercar';

-- 4. Thống kê đánh giá trung bình của mỗi xe
-- SELECT c.car_id, cm.model_name, AVG(CAST(r.rating AS FLOAT)) as avg_rating, COUNT(r.review_id) as total_reviews
-- FROM Car c
-- INNER JOIN CarModel cm ON c.model_id = cm.model_id
-- LEFT JOIN Review r ON c.car_id = r.car_id
-- GROUP BY c.car_id, cm.model_name;

-- 5. Xem doanh thu theo tháng
-- SELECT 
--     YEAR(order_date) AS year,
--     MONTH(order_date) AS month,
--     SUM(total_price) AS revenue,
--     COUNT(*) AS total_orders
-- FROM [Order]
-- WHERE status = 'COMPLETED'
-- GROUP BY YEAR(order_date), MONTH(order_date)
-- ORDER BY year DESC, month DESC;

-- 6. Top 5 xe đắt nhất
-- SELECT TOP 5 c.car_id, b.brand_name, cm.model_name, c.price, c.color
-- FROM Car c
-- INNER JOIN CarModel cm ON c.model_id = cm.model_id
-- INNER JOIN Brand b ON cm.brand_id = b.brand_id
-- ORDER BY c.price DESC;

-- =====================================================
-- TẠO INDEX ĐỂ TỐI ƯU HIỆU SUẤT
-- =====================================================

CREATE INDEX IX_Car_Status ON Car(status);
CREATE INDEX IX_Car_ModelId ON Car(model_id);
CREATE INDEX IX_CarModel_BrandId ON CarModel(brand_id);
CREATE INDEX IX_Order_UserId ON [Order](user_id);
CREATE INDEX IX_Order_Status ON [Order](status);
CREATE INDEX IX_Review_CarId ON Review(car_id);
GO

-- =====================================================
-- KẾT THÚC
-- =====================================================