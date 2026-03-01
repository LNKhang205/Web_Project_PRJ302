-- ============================================================
-- SCRIPT INSERT DỮ LIỆU MẪU - PRJ30x_DB1
-- Chạy theo thứ tự: Brand → CarModel → Car
-- ============================================================

-- ===== 1. INSERT BRAND (Hãng xe) =====
INSERT INTO Brand (brand_name, country, description) VALUES
('Mercedes-Benz', 'Germany', 'Thương hiệu xe sang hàng đầu thế giới từ Đức'),
('BMW',           'Germany', 'Bayerische Motoren Werke - Niềm vui lái xe'),
('Audi',          'Germany', 'Công nghệ tiên tiến, thiết kế tinh tế'),
('Lamborghini',   'Italy',   'Siêu xe biểu tượng của Italy'),
('Rolls-Royce',   'UK',      'Biểu tượng xa xỉ và đẳng cấp vương giả'),
('Porsche',       'Germany', 'Hiệu suất thể thao kết hợp sang trọng'),
('Ferrari',       'Italy',   'Siêu xe đua đường phố huyền thoại'),
('Bentley',       'UK',      'Sang trọng và hiệu suất đỉnh cao');

-- ===== 2. INSERT CATEGORY (Loại xe) =====
INSERT INTO Category (category_name, description) VALUES
('Sedan',       'Xe sedan 4 cửa sang trọng'),
('SUV',         'Xe thể thao đa dụng'),
('Coupe',       'Xe coupe 2 cửa thể thao'),
('Convertible', 'Xe mui trần'),
('Supercar',    'Siêu xe tốc độ cao');

-- ===== 3. INSERT CARMODEL (Model xe) =====
-- Mercedes (brand_id = 1)
INSERT INTO CarModel (brand_id, model_name, year, description) VALUES
(1, 'S-Class S500',  2024, 'Flagship sedan của Mercedes'),
(1, 'S-Class S580',  2024, 'Phiên bản V8 mạnh mẽ'),
(1, 'GLS 450',       2024, 'SUV hạng sang 7 chỗ'),
(1, 'AMG GT 63',     2024, 'Hiệu suất AMG thuần khiết'),
(1, 'EQS 580',       2024, 'Sedan điện cao cấp');

-- BMW (brand_id = 2)
INSERT INTO CarModel (brand_id, model_name, year, description) VALUES
(2, '740Li',     2024, 'Sedan hạng sang BMW 7 Series'),
(2, '760i xDrive',2024, 'Phiên bản V8 cao cấp nhất'),
(2, 'X7 M60i',   2024, 'SUV 7 chỗ mạnh mẽ'),
(2, 'M8 Gran Coupe', 2024, 'Gran Coupe hiệu suất cao'),
(2, 'i7 xDrive60', 2024, 'Sedan điện thuần');

-- Audi (brand_id = 3)
INSERT INTO CarModel (brand_id, model_name, year, description) VALUES
(3, 'A8L 60 TFSI',   2024, 'Flagship sedan của Audi'),
(3, 'Q8 55 TFSI',    2024, 'SUV coupe cao cấp'),
(3, 'RS7 Sportback', 2024, 'Sportback hiệu suất cao'),
(3, 'e-tron GT',     2024, 'Gran Turismo điện cao cấp');

-- Lamborghini (brand_id = 4)
INSERT INTO CarModel (brand_id, model_name, year, description) VALUES
(4, 'Urus S',        2024, 'Siêu SUV của Lamborghini'),
(4, 'Huracan EVO',   2023, 'Supercar V10 huyền thoại'),
(4, 'Revuelto',      2024, 'Siêu xe V12 hybrid thế hệ mới');

-- Rolls-Royce (brand_id = 5)
INSERT INTO CarModel (brand_id, model_name, year, description) VALUES
(5, 'Phantom Extended', 2024, 'Đỉnh cao của sự sang trọng'),
(5, 'Ghost Extended',   2024, 'Sedan siêu sang thực dụng'),
(5, 'Cullinan Black Badge', 2024, 'SUV siêu sang');

-- Porsche (brand_id = 6)
INSERT INTO CarModel (brand_id, model_name, year, description) VALUES
(6, '911 Turbo S',    2024, 'Biểu tượng supercar của Porsche'),
(6, 'Panamera GTS',   2024, 'Gran Turismo 4 cửa'),
(6, 'Cayenne Turbo',  2024, 'SUV hiệu suất cao');

-- Ferrari (brand_id = 7)
INSERT INTO CarModel (brand_id, model_name, year, description) VALUES
(7, 'Roma Spider', 2024, 'Ferrari mui trần sang trọng'),
(7, 'SF90 Stradale', 2023, 'Siêu xe hybrid V8 đỉnh cao');

-- Bentley (brand_id = 8)
INSERT INTO CarModel (brand_id, model_name, year, description) VALUES
(8, 'Continental GT Speed', 2024, 'Grand Tourer W12 mạnh mẽ'),
(8, 'Bentayga EWB',         2024, 'SUV siêu sang phiên bản dài');

-- ===== 4. INSERT CAR (50 xe) =====
-- model_id tương ứng theo thứ tự insert ở trên:
-- 1=S500, 2=S580, 3=GLS450, 4=AMG GT63, 5=EQS580
-- 6=740Li, 7=760i, 8=X7, 9=M8, 10=i7
-- 11=A8L, 12=Q8, 13=RS7, 14=e-tron GT
-- 15=Urus S, 16=Huracan, 17=Revuelto
-- 18=Phantom, 19=Ghost, 20=Cullinan
-- 21=911 Turbo S, 22=Panamera, 23=Cayenne
-- 24=Roma Spider, 25=SF90
-- 26=Continental GT, 27=Bentayga

-- Mercedes S-Class S500 (model_id=1)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(1, 5500000000, N'Đen Obsidian',  '3.0L I6 Turbo 435hp', 'AUTOMATIC', 0,    'AVAILABLE', N'S500 2024 mới 100%, full option, màu đen huyền bí đẳng cấp'),
(1, 5200000000, N'Trắng Diamond', '3.0L I6 Turbo 435hp', 'AUTOMATIC', 1500, 'AVAILABLE', N'S500 2024 đã qua sử dụng ít, bảo dưỡng chính hãng'),
(1, 5800000000, N'Xanh Cavansite','3.0L I6 Turbo 435hp', 'AUTOMATIC', 0,    'AVAILABLE', N'S500 2024 màu xanh đặc biệt, hiếm có trên thị trường');

-- Mercedes S580 (model_id=2)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(2, 7200000000, N'Bạc Iridium',  '4.0L V8 Biturbo 503hp', 'AUTOMATIC', 0,   'AVAILABLE', N'S580 2024 V8 mạnh mẽ, trang bị đầy đủ công nghệ AI'),
(2, 6900000000, N'Đỏ Patagonia', '4.0L V8 Biturbo 503hp', 'AUTOMATIC', 800, 'AVAILABLE', N'S580 2024 màu đỏ nổi bật, nội thất da Nappa');

-- Mercedes GLS 450 (model_id=3)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(3, 6800000000, N'Đen Obsidian',  '3.0L I6 Turbo 362hp', 'AUTOMATIC', 0,    'AVAILABLE', N'GLS450 7 chỗ, hệ thống treo E-ACTIVE BODY CONTROL'),
(3, 6500000000, N'Trắng Polar',   '3.0L I6 Turbo 362hp', 'AUTOMATIC', 5000, 'AVAILABLE', N'GLS450 đã qua sử dụng, bảo hành còn hạn'),
(3, 7100000000, N'Xám Selenite',  '3.0L I6 Turbo 362hp', 'AUTOMATIC', 0,    'RESERVED',  N'GLS450 bản Maybach Edition giới hạn');

-- Mercedes AMG GT63 (model_id=4)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(4, 11500000000, N'Đen AMG Night', '4.0L V8 Biturbo 630hp', 'AUTOMATIC', 0, 'AVAILABLE', N'AMG GT63 S E Performance hybrid, mạnh 843hp kết hợp motor điện');

-- Mercedes EQS 580 (model_id=5)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(5, 7500000000, N'Xanh Haute',   'Dual Motor 523hp', 'AUTOMATIC', 0,    'AVAILABLE', N'EQS580 điện, range 770km, màn hình Hyperscreen 56 inch'),
(5, 7200000000, N'Trắng Diamond','Dual Motor 523hp', 'AUTOMATIC', 2000, 'AVAILABLE', N'EQS580 đã qua sử dụng, pin còn 98% dung lượng');

-- BMW 740Li (model_id=6)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(6, 6200000000, N'Đen Sapphire',  '3.0L I6 Turbo 375hp', 'AUTOMATIC', 0,    'AVAILABLE', N'740Li 2024 LWB, cabin thiền định, màn hình sau 31 inch'),
(6, 5900000000, N'Trắng Alpine',  '3.0L I6 Turbo 375hp', 'AUTOMATIC', 3000, 'AVAILABLE', N'740Li đã qua sử dụng, còn bảo hành hãng'),
(6, 6400000000, N'Xanh Tanzanite','3.0L I6 Turbo 375hp', 'AUTOMATIC', 0,    'AVAILABLE', N'740Li màu đặc biệt Individual, nội thất Merino da bò');

-- BMW 760i (model_id=7)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(7, 9500000000, N'Đen Carbon',   '4.4L V8 Turbo 544hp', 'AUTOMATIC', 0, 'AVAILABLE', N'760i xDrive 2024, flagship tuyệt đối của BMW, Executive Lounge'),
(7, 9200000000, N'Xám Dravite',  '4.4L V8 Turbo 544hp', 'AUTOMATIC', 500,'AVAILABLE', N'760i xDrive, xe trình diễn, đầy đủ option');

-- BMW X7 (model_id=8)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(8, 7800000000, N'Trắng Mineral', '4.4L V8 Turbo 530hp', 'AUTOMATIC', 0,    'AVAILABLE', N'X7 M60i 2024, SUV 7 chỗ mạnh mẽ, hệ thống đèn Iconic Glow'),
(8, 7500000000, N'Đen Sapphire',  '4.4L V8 Turbo 530hp', 'AUTOMATIC', 4000, 'AVAILABLE', N'X7 M60i đã qua sử dụng, đầy đủ gói nâng cấp');

-- BMW M8 Gran Coupe (model_id=9)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(9, 12000000000, N'Đỏ Imola',    '4.4L V8 Biturbo 617hp', 'AUTOMATIC', 0,    'AVAILABLE', N'M8 Gran Coupe Competition xDrive, xe thể thao 4 cửa đỉnh cao'),
(9, 11500000000, N'Xanh Marina',  '4.4L V8 Biturbo 617hp', 'AUTOMATIC', 1000, 'AVAILABLE', N'M8 Competition, màu xanh BMW Motorsport huyền thoại');

-- BMW i7 (model_id=10)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(10, 8500000000, N'Đen Sapphire',  'Dual Motor 544hp', 'AUTOMATIC', 0, 'AVAILABLE', N'i7 xDrive60 2024 thuần điện, range 625km, rear-screen rạp phim');

-- Audi A8L (model_id=11)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(11, 5800000000, N'Đen Mythos',   '6.0L W12 TFSI 585hp', 'AUTOMATIC', 0,    'AVAILABLE', N'A8L 60 TFSI 2024, phiên bản W12, sedan siêu hạng Audi'),
(11, 5500000000, N'Xám Manhattan', '6.0L W12 TFSI 585hp', 'AUTOMATIC', 2000, 'AVAILABLE', N'A8L đã qua sử dụng, đầy đủ option massage, điều hòa zone 4'),
(11, 6100000000, N'Trắng Glacier', '6.0L W12 TFSI 585hp', 'AUTOMATIC', 0,    'RESERVED',  N'A8L phiên bản extended wheelbase đặc biệt');

-- Audi Q8 (model_id=12)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(12, 5200000000, N'Đen Mythos',   '3.0L V6 TFSI 340hp', 'AUTOMATIC', 0,    'AVAILABLE', N'Q8 55 TFSI 2024, SUV coupe thể thao, Matrix LED, B&O sound'),
(12, 4900000000, N'Đỏ Tango',     '3.0L V6 TFSI 340hp', 'AUTOMATIC', 6000, 'AVAILABLE', N'Q8 đã qua sử dụng, nội thất da bò Valcona');

-- Audi RS7 (model_id=13)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(13, 8900000000, N'Xanh Ascari',  '4.0L V8 TFSI 600hp', 'AUTOMATIC', 0, 'AVAILABLE', N'RS7 Sportback Performance 2024, 600hp, 0-100 chỉ 3.4 giây'),
(13, 8500000000, N'Đen Mythos',   '4.0L V8 TFSI 600hp', 'AUTOMATIC', 500,'AVAILABLE', N'RS7 Sportback, màu đen toàn thân, Carbon package');

-- Audi e-tron GT (model_id=14)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(14, 7500000000, N'Xanh Kemora',  'Dual Motor 598hp', 'AUTOMATIC', 0,    'AVAILABLE', N'RS e-tron GT 2024, xe điện hiệu suất cao, sạc nhanh 270kW'),
(14, 7200000000, N'Đen Mythos',   'Dual Motor 598hp', 'AUTOMATIC', 1500, 'AVAILABLE', N'e-tron GT quattro, đã qua sử dụng, pin 93kWh');

-- Lamborghini Urus S (model_id=15)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(15, 22000000000, N'Vàng Giallo Orion', '4.0L V8 Biturbo 666hp', 'AUTOMATIC', 0,    'AVAILABLE', N'Urus S 2024 màu vàng đặc trưng Lamborghini, 0-100 chỉ 3.5s'),
(15, 21000000000, N'Trắng Bianco Monocerus', '4.0L V8 Biturbo 666hp', 'AUTOMATIC', 0, 'AVAILABLE', N'Urus S trắng tinh, full carbon exterior package'),
(15, 23500000000, N'Xanh Blu Eleos',  '4.0L V8 Biturbo 666hp', 'AUTOMATIC', 500, 'AVAILABLE', N'Urus Performante edition giới hạn, nhẹ hơn và nhanh hơn');

-- Lamborghini Huracan (model_id=16)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(16, 18000000000, N'Cam Arancio Borealis', '5.2L V10 NA 640hp', 'AUTOMATIC', 0,    'AVAILABLE', N'Huracan EVO RWD 2023, V10 NA nguyên thuỷ, âm thanh huyền thoại'),
(16, 17500000000, N'Đen Nero Nemesis',     '5.2L V10 NA 640hp', 'AUTOMATIC', 2000, 'AVAILABLE', N'Huracan EVO Spyder mui trần, đi 2000km, còn bảo hành');

-- Lamborghini Revuelto (model_id=17)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(17, 45000000000, N'Đỏ Rosso Efesto',  'V12 Hybrid 1015hp', 'AUTOMATIC', 0, 'AVAILABLE', N'Revuelto 2024 thế hệ mới thay Aventador, 1015hp, đặt xe từ 2023');

-- Rolls-Royce Phantom (model_id=18)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(18, 80000000000, N'Đen Diamond Black', '6.75L V12 571hp', 'AUTOMATIC', 0,   'AVAILABLE', N'Phantom Extended 2024, Gallery bespoke, Starlight headliner 1344 sao'),
(18, 75000000000, N'Trắng English White','6.75L V12 571hp', 'AUTOMATIC', 500, 'AVAILABLE', N'Phantom Extended, phiên bản năm trước, ít sử dụng');

-- Rolls-Royce Ghost (model_id=19)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(19, 45000000000, N'Xanh Navy',    '6.75L V12 571hp', 'AUTOMATIC', 0,    'AVAILABLE', N'Ghost Extended 2024, Whispers tĩnh lặng như phòng thu'),
(19, 42000000000, N'Bạc Silver',   '6.75L V12 571hp', 'AUTOMATIC', 3000, 'AVAILABLE', N'Ghost Extended đã qua sử dụng, đầy đủ gói bespoke'),
(19, 48000000000, N'Đen Obsidian', '6.75L V12 571hp', 'AUTOMATIC', 0,    'RESERVED',  N'Ghost Black Badge, dark performance đặc biệt');

-- Rolls-Royce Cullinan (model_id=20)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(20, 55000000000, N'Đen Black Badge',  '6.75L V12 600hp', 'AUTOMATIC', 0,    'AVAILABLE', N'Cullinan Black Badge 2024, màu đen toàn thân, dark chrome'),
(20, 52000000000, N'Trắng Polar',      '6.75L V12 600hp', 'AUTOMATIC', 1000, 'AVAILABLE', N'Cullinan tiêu chuẩn, nội thất bespoke champagne');

-- Porsche 911 Turbo S (model_id=21)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(21, 18000000000, N'Bạc GT Silver',   '3.8L Boxer6 Turbo 650hp', 'AUTOMATIC', 0,    'AVAILABLE', N'911 Turbo S 2024 Cabriolet, 650hp, 0-100 chỉ 2.7 giây'),
(21, 17000000000, N'Đen Jet Black',   '3.8L Boxer6 Turbo 650hp', 'AUTOMATIC', 2000, 'AVAILABLE', N'911 Turbo S Coupe 2024, đã qua sử dụng ít'),
(21, 19500000000, N'Vàng Racing',     '3.8L Boxer6 Turbo 650hp', 'AUTOMATIC', 0,    'AVAILABLE', N'911 Turbo S Sport Classic phiên bản giới hạn màu vàng');

-- Porsche Panamera (model_id=22)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(22, 9800000000, N'Đen Jet',      '4.0L V8 Turbo 473hp', 'AUTOMATIC', 0,    'AVAILABLE', N'Panamera GTS 2024, sedan thể thao 4 cửa đỉnh cao'),
(22, 9400000000, N'Xanh Gentian', '4.0L V8 Turbo 473hp', 'AUTOMATIC', 4000, 'AVAILABLE', N'Panamera GTS đã qua sử dụng, bảo dưỡng chính hãng đầy đủ');

-- Porsche Cayenne (model_id=23)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(23, 8500000000, N'Trắng Carrara', '4.0L V8 Turbo 541hp', 'AUTOMATIC', 0,    'AVAILABLE', N'Cayenne Turbo 2024, SUV hiệu suất đỉnh cao'),
(23, 8100000000, N'Xám Crayon',    '4.0L V8 Turbo 541hp', 'AUTOMATIC', 6000, 'AVAILABLE', N'Cayenne Turbo đã qua sử dụng, màu xám phong trần');

-- Ferrari Roma Spider (model_id=24)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(24, 25000000000, N'Đỏ Rosso Corsa', '3.9L V8 Turbo 620hp', 'AUTOMATIC', 0,  'AVAILABLE', N'Roma Spider 2024 mui trần, Ferrari đẹp nhất hiện tại, 0-100: 3.4s'),
(24, 24000000000, N'Trắng Bianco',   '3.9L V8 Turbo 620hp', 'AUTOMATIC', 500, 'AVAILABLE', N'Roma Spider trắng, phong cách grand tourer Italy tinh tế');

-- Ferrari SF90 (model_id=25)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(25, 60000000000, N'Đỏ Rosso Scuderia', 'V8 Hybrid 1000hp', 'AUTOMATIC', 0,   'AVAILABLE', N'SF90 Stradale 2023, hybrid V8 1000hp, siêu xe hàng đầu Ferrari'),
(25, 65000000000, N'Vàng Giallo Modena', 'V8 Hybrid 1000hp', 'AUTOMATIC', 200, 'AVAILABLE', N'SF90 Spider mui trần, phiên bản hiếm, đã đặt sản xuất');

-- Bentley Continental GT (model_id=26)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(26, 22000000000, N'Xanh Viridian',   '6.0L W12 659hp', 'AUTOMATIC', 0,    'AVAILABLE', N'Continental GT Speed 2024, W12 659hp, Grand Tourer đỉnh cao Bentley'),
(26, 21000000000, N'Đen Beluga',      '6.0L W12 659hp', 'AUTOMATIC', 1500, 'AVAILABLE', N'Continental GT Speed Convertible, mui trần sang trọng');

-- Bentley Bentayga (model_id=27)
INSERT INTO Car (model_id, price, color, engine, transmission, mileage, status, description) VALUES
(27, 30000000000, N'Trắng Ghost',    '4.0L V8 Turbo 542hp', 'AUTOMATIC', 0,    'AVAILABLE', N'Bentayga EWB 2024 phiên bản dài, 4 chỗ luxury lounge'),
(27, 28000000000, N'Xanh Peacock',   '4.0L V8 Turbo 542hp', 'AUTOMATIC', 2000, 'AVAILABLE', N'Bentayga EWB đã qua sử dụng, màu xanh đặc biệt bespoke');

-- ============================================================
-- QUERY KIỂM TRA
-- ============================================================
SELECT b.brand_name, cm.model_name, c.color, 
       FORMAT(c.price, 'N0') + ' VND' AS price, 
       c.status
FROM Car c
INNER JOIN CarModel cm ON c.model_id = cm.model_id
INNER JOIN Brand b ON cm.brand_id = b.brand_id
ORDER BY b.brand_name, cm.model_name;

SELECT COUNT(*) as [Tong so xe] FROM Car;