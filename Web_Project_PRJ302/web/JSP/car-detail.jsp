<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Chi Tiết Xe - Luxury Car Sales</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <style>
            .detail-section {
                padding: 8rem 0 4rem;
                margin-top: 80px;
            }

            .detail-container {
                display: grid;
                grid-template-columns: 1.2fr 1fr;
                gap: 4rem;
            }

            .image-gallery {
                position: relative;
            }

            .main-image {
                width: 100%;
                height: 500px;
                overflow: hidden;
                background: var(--light-gray);
                margin-bottom: 1rem;
            }

            .main-image img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .thumbnail-list {
                display: grid;
                grid-template-columns: repeat(4, 1fr);
                gap: 0.5rem;
            }

            .thumbnail {
                height: 100px;
                cursor: pointer;
                overflow: hidden;
                border: 3px solid transparent;
                transition: var(--transition);
            }

            .thumbnail:hover,
            .thumbnail.active {
                border-color: var(--primary-gold);
            }

            .thumbnail img {
                width: 100%;
                height: 100%;
                object-fit: cover;
            }

            .detail-info {
                position: sticky;
                top: 100px;
                height: fit-content;
            }

            .detail-badge {
                display: inline-block;
                background: var(--primary-gold);
                color: var(--primary-dark);
                padding: 0.5rem 1.5rem;
                font-size: 0.85rem;
                font-weight: 700;
                text-transform: uppercase;
                letter-spacing: 0.1em;
                margin-bottom: 1rem;
            }

            .detail-brand {
                font-size: 1rem;
                color: var(--primary-gold);
                font-weight: 600;
                text-transform: uppercase;
                letter-spacing: 0.1em;
                margin-bottom: 0.5rem;
            }

            .detail-title {
                font-size: 2.5rem;
                margin-bottom: 1.5rem;
            }

            .detail-price {
                font-size: 3rem;
                font-weight: 700;
                color: var(--primary-dark);
                font-family: var(--font-display);
                margin-bottom: 2rem;
            }

            .detail-price span {
                font-size: 1.2rem;
                color: var(--text-light);
                font-weight: 400;
            }

            .specs-grid {
                display: grid;
                grid-template-columns: repeat(2, 1fr);
                gap: 1.5rem;
                padding: 2rem;
                background: var(--light-gray);
                margin-bottom: 2rem;
            }

            .spec-item {
                display: flex;
                flex-direction: column;
                gap: 0.5rem;
            }

            .spec-label {
                font-size: 0.85rem;
                color: var(--text-light);
                text-transform: uppercase;
                letter-spacing: 0.05em;
            }

            .spec-value {
                font-size: 1.1rem;
                font-weight: 600;
                color: var(--primary-dark);
            }

            .detail-description {
                padding: 2rem 0;
                border-top: 2px solid var(--light-gray);
                border-bottom: 2px solid var(--light-gray);
                margin-bottom: 2rem;
            }

            .detail-description h3 {
                margin-bottom: 1rem;
            }

            .detail-description p {
                line-height: 1.8;
            }

            .action-buttons {
                display: flex;
                flex-direction: column;
                gap: 1rem;
            }

            .btn-contact {
                width: 100%;
                text-align: center;
                padding: 1.2rem;
            }

            .contact-info {
                display: flex;
                flex-direction: column;
                gap: 1rem;
                margin-top: 2rem;
                padding: 1.5rem;
                background: var(--light-gray);
            }

            .contact-item {
                display: flex;
                align-items: center;
                gap: 1rem;
            }

            .contact-item i {
                color: var(--primary-gold);
                font-size: 1.2rem;
            }

            @media (max-width: 968px) {
                .detail-container {
                    grid-template-columns: 1fr;
                    gap: 2rem;
                }

                .detail-info {
                    position: relative;
                    top: 0;
                }
            }
        </style>
    </head>
    <body>

        <!-- HEADER -->
        <header class="header" id="header">
            <div class="container">
                <nav class="nav">
                    <a href="${pageContext.request.contextPath}/JSP/index.jsp" class="logo">
                        LUXURY<span>CARS</span>
                    </a>

                    <ul class="nav-menu" id="navMenu">
                        <li><a href="${pageContext.request.contextPath}/JSP/index.jsp" class="nav-link">Trang chủ</a></li>
                        <li><a href="${pageContext.request.contextPath}/JSP/cars.jsp" class="nav-link active">Xe bán</a></li>
                        <li><a href="${pageContext.request.contextPath}/JSP/brands.jsp" class="nav-link">Hãng xe</a></li>
                        <li><a href="${pageContext.request.contextPath}/JSP/index.jsp#about" class="nav-link">Về chúng tôi</a></li>
                        <li><a href="${pageContext.request.contextPath}/JSP/index.jsp#contact" class="nav-link">Liên hệ</a></li>
                        <li><a href="${pageContext.request.contextPath}/JSP/login.jsp" class="nav-link"><i class="fas fa-user"></i> Đăng nhập</a></li>
                    </ul>

                    <div class="mobile-toggle" id="mobileToggle">
                        <span></span>
                        <span></span>
                        <span></span>
                    </div>
                </nav>
            </div>
        </header>

        <!-- CAR DETAIL -->
        <section class="detail-section">
            <div class="container">
                <div class="detail-container">
                    <!-- Image Gallery -->
                    <div class="image-gallery">
                        <div class="main-image" id="mainImage">
                            <img src="https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=800" alt="Mercedes S-Class">
                        </div>
                        <div class="thumbnail-list">
                            <div class="thumbnail active" onclick="changeImage(this)">
                                <img src="https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=300" alt="Thumbnail 1">
                            </div>
                            <div class="thumbnail" onclick="changeImage(this)">
                                <img src="https://images.unsplash.com/photo-1617531653332-bd46c24f2068?w=300" alt="Thumbnail 2">
                            </div>
                            <div class="thumbnail" onclick="changeImage(this)">
                                <img src="https://images.unsplash.com/photo-1606220838315-056192d5e927?w=300" alt="Thumbnail 3">
                            </div>
                            <div class="thumbnail" onclick="changeImage(this)">
                                <img src="https://images.unsplash.com/photo-1617531653520-bd466ee429b1?w=300" alt="Thumbnail 4">
                            </div>
                        </div>
                    </div>

                    <!-- Car Info -->
                    <div class="detail-info">
                        <span class="detail-badge">Mới về</span>
                        <div class="detail-brand">Mercedes-Benz</div>
                        <h1 class="detail-title">S-Class S500 2024</h1>
                        <div class="detail-price">5.5 tỷ <span>VNĐ</span></div>

                        <!-- Specs -->
                        <div class="specs-grid">
                            <div class="spec-item">
                                <span class="spec-label"><i class="fas fa-calendar"></i> Năm sản xuất</span>
                                <span class="spec-value">2024</span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label"><i class="fas fa-tachometer-alt"></i> Số km đã đi</span>
                                <span class="spec-value">0 km</span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label"><i class="fas fa-cog"></i> Hộp số</span>
                                <span class="spec-value">Tự động</span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label"><i class="fas fa-gas-pump"></i> Nhiên liệu</span>
                                <span class="spec-value">Xăng</span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label"><i class="fas fa-palette"></i> Màu sắc</span>
                                <span class="spec-value">Đen</span>
                            </div>
                            <div class="spec-item">
                                <span class="spec-label"><i class="fas fa-engine"></i> Động cơ</span>
                                <span class="spec-value">V8 4.0L Twin-Turbo</span>
                            </div>
                        </div>

                        <!-- Description -->
                        <div class="detail-description">
                            <h3>Mô tả</h3>
                            <p>
                                Mercedes-Benz S-Class 2024 là đỉnh cao của sự sang trọng và công nghệ. 
                                Với động cơ V8 4.0L Twin-Turbo mạnh mẽ, nội thất da cao cấp, 
                                hệ thống âm thanh Burmester 3D, và đầy đủ công nghệ an toàn hiện đại nhất. 
                                Xe được bảo hành chính hãng, có đầy đủ giấy tờ, chưa qua sử dụng.
                            </p>
                        </div>

                        <!-- Action Buttons -->
                        <div class="action-buttons">
                            <a href="#contact" class="btn btn-primary btn-contact">
                                <i class="fas fa-phone"></i> Liên hệ ngay
                            </a>
                            <a href="#" class="btn btn-outline btn-contact">
                                <i class="fas fa-calendar"></i> Đặt lịch xem xe
                            </a>
                        </div>

                        <!-- Contact Info -->
                        <div class="contact-info">
                            <div class="contact-item">
                                <i class="fas fa-phone"></i>
                                <span>Hotline: <strong>1900 xxxx</strong></span>
                            </div>
                            <div class="contact-item">
                                <i class="fas fa-envelope"></i>
                                <span>Email: <strong>sales@luxurycars.vn</strong></span>
                            </div>
                            <div class="contact-item">
                                <i class="fas fa-map-marker-alt"></i>
                                <span>Showroom: <strong>123 Nguyễn Huệ, Q1, TP.HCM</strong></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- RELATED CARS -->
        <section class="section" style="background: var(--light-gray);">
            <div class="container">
                <div class="section-header">
                    <h2 class="section-title">Xe Tương Tự</h2>
                    <p class="section-subtitle">Những mẫu xe bạn có thể quan tâm</p>
                </div>

                <div class="car-grid">
                    <!-- Related cars would go here -->
                    <div class="car-card">
                        <div class="car-card-image">
                            <img src="https://images.unsplash.com/photo-1617531653332-bd46c24f2068?w=600" alt="Mercedes Maybach">
                            <span class="car-badge">Cao cấp</span>
                        </div>
                        <div class="car-card-content">
                            <div class="car-brand">Mercedes-Benz</div>
                            <h3 class="car-name">S680 Maybach 2024</h3>
                            <div class="car-specs">
                                <div class="car-spec"><i class="fas fa-tachometer-alt"></i> <span>0 km</span></div>
                                <div class="car-spec"><i class="fas fa-cog"></i> <span>Tự động</span></div>
                            </div>
                            <div class="car-footer">
                                <div class="car-price">7.8 tỷ <span>VNĐ</span></div>
                                <a href="${pageContext.request.contextPath}/JSP/car-detail.jsp?id=2" class="btn btn-primary btn-view">Chi tiết</a>
                            </div>
                        </div>
                    </div>

                    <div class="car-card">
                        <div class="car-card-image">
                            <img src="https://images.unsplash.com/photo-1555215695-3004980ad54e?w=600" alt="BMW 740Li">
                            <span class="car-badge">Mới về</span>
                        </div>
                        <div class="car-card-content">
                            <div class="car-brand">BMW</div>
                            <h3 class="car-name">740Li 2024</h3>
                            <div class="car-specs">
                                <div class="car-spec"><i class="fas fa-tachometer-alt"></i> <span>0 km</span></div>
                                <div class="car-spec"><i class="fas fa-cog"></i> <span>Tự động</span></div>
                            </div>
                            <div class="car-footer">
                                <div class="car-price">6.2 tỷ <span>VNĐ</span></div>
                                <a href="${pageContext.request.contextPath}/JSP/car-detail.jsp?id=5" class="btn btn-primary btn-view">Chi tiết</a>
                            </div>
                        </div>
                    </div>

                    <div class="car-card">
                        <div class="car-card-image">
                            <img src="https://images.unsplash.com/photo-1617531653520-bd466ee429b1?w=600" alt="Audi A8L">
                            <span class="car-badge">Bán chạy</span>
                        </div>
                        <div class="car-card-content">
                            <div class="car-brand">Audi</div>
                            <h3 class="car-name">A8L 2024</h3>
                            <div class="car-specs">
                                <div class="car-spec"><i class="fas fa-tachometer-alt"></i> <span>0 km</span></div>
                                <div class="car-spec"><i class="fas fa-cog"></i> <span>Tự động</span></div>
                            </div>
                            <div class="car-footer">
                                <div class="car-price">5.8 tỷ <span>VNĐ</span></div>
                                <a href="${pageContext.request.contextPath}/JSP/car-detail.jsp?id=7" class="btn btn-primary btn-view">Chi tiết</a>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <!-- FOOTER -->
        <footer class="footer">
            <div class="container">
                <div class="footer-content">
                    <div class="footer-section">
                        <h3>LUXURY<span style="color: var(--primary-gold);">CARS</span></h3>
                        <p>Đối tác tin cậy cho những chiếc xe sang đẳng cấp thế giới.</p>
                    </div>
                    <div class="footer-section">
                        <h3>Liên Kết</h3>
                        <div class="footer-links">
                            <a href="${pageContext.request.contextPath}/JSP/index.jsp">Trang chủ</a>
                            <a href="${pageContext.request.contextPath}/JSP/cars.jsp">Xe bán</a>
                            <a href="${pageContext.request.contextPath}/JSP/login.jsp">Đăng nhập</a>
                        </div>
                    </div>
                    <div class="footer-section">
                        <h3>Liên Hệ</h3>
                        <p><i class="fas fa-phone"></i> 1900 xxxx</p>
                        <p><i class="fas fa-envelope"></i> info@luxurycars.vn</p>
                    </div>
                </div>
                <div class="footer-bottom">
                    <p>&copy; 2024 LuxuryCars. All rights reserved.</p>
                </div>
            </div>
        </footer>

        <script src="${pageContext.request.contextPath}/JS/Script.js"></script>
        <script>
                                // Change main image when clicking thumbnail
                                function changeImage(thumbnail) {
                                    const mainImage = document.getElementById('mainImage').querySelector('img');
                                    const thumbnailImage = thumbnail.querySelector('img');

                                    mainImage.src = thumbnailImage.src.replace('w=300', 'w=800');

                                    // Update active thumbnail
                                    document.querySelectorAll('.thumbnail').forEach(t => t.classList.remove('active'));
                                    thumbnail.classList.add('active');
                                }
        </script>

    </body>
</html>
