<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hãng Xe Cao Cấp - Luxury Car Sales</title>
    
    <!-- CSS -->
    <link rel="stylesheet" href="style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        .page-header {
            background: linear-gradient(135deg, var(--primary-dark) 0%, var(--secondary-gray) 100%);
            padding: 8rem 0 4rem;
            margin-top: 80px;
            text-align: center;
            color: white;
            position: relative;
            overflow: hidden;
        }
        
        .page-header::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('data:image/svg+xml,<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 1200 600"><path d="M0 300L50 275L100 300L150 250L200 275L250 325L300 300L350 275L400 325L450 300L500 250L550 275L600 300L650 275L700 250L750 300L800 275L850 300L900 275L950 325L1000 300L1050 275L1100 300L1150 275L1200 300V600H0Z" fill="rgba(212, 175, 55, 0.05)"/></svg>') repeat-x;
            opacity: 0.3;
            animation: wave 20s linear infinite;
        }
        
        .page-title {
            color: white;
            margin-bottom: 1rem;
            position: relative;
            z-index: 2;
        }
        
        .page-subtitle {
            font-size: 1.2rem;
            color: var(--light-gray);
            position: relative;
            z-index: 2;
        }
        
        .brands-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
            gap: 2.5rem;
            margin-top: 3rem;
        }
        
        .brand-card {
            background: white;
            border-radius: 0;
            overflow: hidden;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            position: relative;
            border: 2px solid transparent;
        }
        
        .brand-card:hover {
            transform: translateY(-10px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-gold);
        }
        
        .brand-card-header {
            padding: 3rem 2rem;
            background: linear-gradient(135deg, var(--light-gray) 0%, white 100%);
            text-align: center;
            position: relative;
            border-bottom: 3px solid var(--primary-gold);
        }
        
        .brand-logo {
            width: 120px;
            height: 120px;
            margin: 0 auto 1.5rem;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border-radius: 50%;
            box-shadow: var(--shadow-md);
            font-size: 3rem;
            color: var(--primary-gold);
        }
        
        .brand-name {
            font-size: 2rem;
            margin-bottom: 0.5rem;
            color: var(--primary-dark);
        }
        
        .brand-country {
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            padding: 0.5rem 1rem;
            background: white;
            color: var(--text-light);
            font-size: 0.9rem;
            border-radius: 20px;
            box-shadow: var(--shadow-sm);
        }
        
        .brand-country i {
            color: var(--primary-gold);
        }
        
        .brand-card-body {
            padding: 2rem;
        }
        
        .brand-description {
            color: var(--text-light);
            line-height: 1.8;
            margin-bottom: 1.5rem;
        }
        
        .brand-stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin-bottom: 1.5rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--light-gray);
        }
        
        .brand-stat {
            text-align: center;
        }
        
        .brand-stat-value {
            font-size: 2rem;
            font-weight: 700;
            color: var(--primary-gold);
            font-family: var(--font-display);
            margin-bottom: 0.25rem;
        }
        
        .brand-stat-label {
            font-size: 0.85rem;
            color: var(--text-light);
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .brand-actions {
            display: flex;
            gap: 1rem;
        }
        
        .btn-brand {
            flex: 1;
            padding: 0.875rem;
            text-align: center;
            font-size: 0.9rem;
        }
        
        .filter-section {
            background: var(--light-gray);
            padding: 2rem 0;
            margin-bottom: 3rem;
        }
        
        .country-filters {
            display: flex;
            gap: 1rem;
            flex-wrap: wrap;
            justify-content: center;
        }
        
        .country-filter-btn {
            padding: 0.75rem 1.5rem;
            background: white;
            border: 2px solid var(--light-gray);
            color: var(--primary-dark);
            font-family: var(--font-body);
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 0.05em;
        }
        
        .country-filter-btn:hover,
        .country-filter-btn.active {
            background: var(--primary-gold);
            border-color: var(--primary-gold);
            color: var(--primary-dark);
        }
        
        .stats-section {
            background: var(--primary-dark);
            padding: 4rem 0;
            margin-top: 4rem;
            color: white;
        }
        
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 3rem;
            text-align: center;
        }
        
        .stat-item {
            padding: 2rem;
        }
        
        .stat-number {
            font-size: 3.5rem;
            font-weight: 700;
            color: var(--primary-gold);
            font-family: var(--font-display);
            margin-bottom: 0.5rem;
        }
        
        .stat-label {
            font-size: 1.1rem;
            color: var(--light-gray);
        }
        
        @media (max-width: 768px) {
            .brands-grid {
                grid-template-columns: 1fr;
            }
            
            .country-filters {
                flex-direction: column;
            }
            
            .country-filter-btn {
                width: 100%;
            }
        }
    </style>
</head>
<body>
    
    <!-- HEADER -->
    <header class="header" id="header">
        <div class="container">
            <nav class="nav">
                <a href="${pageContext.request.contextPath}/index.jsp" class="logo">
                    LUXURY<span>CARS</span>
                </a>
                
                <ul class="nav-menu" id="navMenu">
                    <li><a href="${pageContext.request.contextPath}/index.jsp" class="nav-link">Trang chủ</a></li>
                    <li><a href="${pageContext.request.contextPath}/cars.jsp" class="nav-link">Xe bán</a></li>
                    <li><a href="${pageContext.request.contextPath}/brands.jsp" class="nav-link active">Hãng xe</a></li>
                    <li><a href="${pageContext.request.contextPath}/index.jsp#about" class="nav-link">Về chúng tôi</a></li>
                    <li><a href="${pageContext.request.contextPath}/index.jsp#contact" class="nav-link">Liên hệ</a></li>
                    <li><a href="${pageContext.request.contextPath}/login.jsp" class="nav-link"><i class="fas fa-user"></i> Đăng nhập</a></li>
                </ul>
                
                <div class="mobile-toggle" id="mobileToggle">
                    <span></span>
                    <span></span>
                    <span></span>
                </div>
            </nav>
        </div>
    </header>
    
    <!-- PAGE HEADER -->
    <section class="page-header">
        <div class="container">
            <h1 class="page-title">Hãng Xe Cao Cấp</h1>
            <p class="page-subtitle">
                Khám phá các thương hiệu xe sang hàng đầu thế giới
            </p>
        </div>
    </section>
    
    <!-- FILTER BY COUNTRY -->
    <section class="filter-section">
        <div class="container">
            <div class="country-filters">
                <button class="country-filter-btn active" data-country="all">
                    <i class="fas fa-globe"></i> Tất cả quốc gia
                </button>
                <button class="country-filter-btn" data-country="Germany">
                    <i class="fas fa-flag"></i> Đức (Germany)
                </button>
                <button class="country-filter-btn" data-country="Italy">
                    <i class="fas fa-flag"></i> Ý (Italy)
                </button>
                <button class="country-filter-btn" data-country="United Kingdom">
                    <i class="fas fa-flag"></i> Anh (UK)
                </button>
                <button class="country-filter-btn" data-country="Japan">
                    <i class="fas fa-flag"></i> Nhật Bản (Japan)
                </button>
            </div>
        </div>
    </section>
    
    <!-- BRANDS GRID -->
    <section class="section">
        <div class="container">
            <div class="brands-grid" id="brandsGrid">
                
                <!-- Brand Card 1 - Mercedes-Benz -->
                <div class="brand-card" data-country="Germany">
                    <div class="brand-card-header">
                        <div class="brand-logo">
                            <i class="fas fa-star"></i>
                        </div>
                        <h2 class="brand-name">Mercedes-Benz</h2>
                        <span class="brand-country">
                            <i class="fas fa-map-marker-alt"></i>
                            Germany
                        </span>
                    </div>
                    <div class="brand-card-body">
                        <p class="brand-description">
                            Hãng xe sang đến từ Đức, nổi tiếng với chất lượng cao cấp, công nghệ tiên tiến 
                            và thiết kế sang trọng. Mercedes-Benz là biểu tượng của sự đẳng cấp và đẳng cấp.
                        </p>
                        <div class="brand-stats">
                            <div class="brand-stat">
                                <div class="brand-stat-value">15+</div>
                                <div class="brand-stat-label">Dòng xe</div>
                            </div>
                            <div class="brand-stat">
                                <div class="brand-stat-value">32</div>
                                <div class="brand-stat-label">Xe có sẵn</div>
                            </div>
                        </div>
                        <div class="brand-actions">
                            <a href="${pageContext.request.contextPath}/cars.jsp?brand=mercedes" class="btn btn-primary btn-brand">
                                <i class="fas fa-car"></i> Xem xe
                            </a>
                            <a href="#" class="btn btn-outline btn-brand">
                                <i class="fas fa-info-circle"></i> Chi tiết
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Brand Card 2 - BMW -->
                <div class="brand-card" data-country="Germany">
                    <div class="brand-card-header">
                        <div class="brand-logo">
                            <i class="fas fa-circle"></i>
                        </div>
                        <h2 class="brand-name">BMW</h2>
                        <span class="brand-country">
                            <i class="fas fa-map-marker-alt"></i>
                            Germany
                        </span>
                    </div>
                    <div class="brand-card-body">
                        <p class="brand-description">
                            Bayerische Motoren Werke - Xe thể thao cao cấp từ Đức. BMW nổi tiếng với 
                            hiệu suất vượt trội, thiết kế thể thao và công nghệ lái tự động tiên tiến.
                        </p>
                        <div class="brand-stats">
                            <div class="brand-stat">
                                <div class="brand-stat-value">12+</div>
                                <div class="brand-stat-label">Dòng xe</div>
                            </div>
                            <div class="brand-stat">
                                <div class="brand-stat-value">28</div>
                                <div class="brand-stat-label">Xe có sẵn</div>
                            </div>
                        </div>
                        <div class="brand-actions">
                            <a href="${pageContext.request.contextPath}/cars.jsp?brand=bmw" class="btn btn-primary btn-brand">
                                <i class="fas fa-car"></i> Xem xe
                            </a>
                            <a href="#" class="btn btn-outline btn-brand">
                                <i class="fas fa-info-circle"></i> Chi tiết
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Brand Card 3 - Audi -->
                <div class="brand-card" data-country="Germany">
                    <div class="brand-card-header">
                        <div class="brand-logo">
                            <i class="fas fa-circle-notch"></i>
                        </div>
                        <h2 class="brand-name">Audi</h2>
                        <span class="brand-country">
                            <i class="fas fa-map-marker-alt"></i>
                            Germany
                        </span>
                    </div>
                    <div class="brand-card-body">
                        <p class="brand-description">
                            Xe sang Đức với công nghệ tiên tiến Quattro và thiết kế hiện đại. 
                            Audi là sự kết hợp hoàn hảo giữa công nghệ, hiệu suất và phong cách.
                        </p>
                        <div class="brand-stats">
                            <div class="brand-stat">
                                <div class="brand-stat-value">11+</div>
                                <div class="brand-stat-label">Dòng xe</div>
                            </div>
                            <div class="brand-stat">
                                <div class="brand-stat-value">24</div>
                                <div class="brand-stat-label">Xe có sẵn</div>
                            </div>
                        </div>
                        <div class="brand-actions">
                            <a href="${pageContext.request.contextPath}/cars.jsp?brand=audi" class="btn btn-primary btn-brand">
                                <i class="fas fa-car"></i> Xem xe
                            </a>
                            <a href="#" class="btn btn-outline btn-brand">
                                <i class="fas fa-info-circle"></i> Chi tiết
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Brand Card 4 - Lamborghini -->
                <div class="brand-card" data-country="Italy">
                    <div class="brand-card-header">
                        <div class="brand-logo">
                            <i class="fas fa-crown"></i>
                        </div>
                        <h2 class="brand-name">Lamborghini</h2>
                        <span class="brand-country">
                            <i class="fas fa-map-marker-alt"></i>
                            Italy
                        </span>
                    </div>
                    <div class="brand-card-body">
                        <p class="brand-description">
                            Siêu xe thể thao cao cấp từ Italia. Lamborghini là biểu tượng của tốc độ, 
                            sức mạnh và thiết kế đột phá với những chiếc siêu xe đẳng cấp thế giới.
                        </p>
                        <div class="brand-stats">
                            <div class="brand-stat">
                                <div class="brand-stat-value">5+</div>
                                <div class="brand-stat-label">Dòng xe</div>
                            </div>
                            <div class="brand-stat">
                                <div class="brand-stat-value">8</div>
                                <div class="brand-stat-label">Xe có sẵn</div>
                            </div>
                        </div>
                        <div class="brand-actions">
                            <a href="${pageContext.request.contextPath}/cars.jsp?brand=lamborghini" class="btn btn-primary btn-brand">
                                <i class="fas fa-car"></i> Xem xe
                            </a>
                            <a href="#" class="btn btn-outline btn-brand">
                                <i class="fas fa-info-circle"></i> Chi tiết
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Brand Card 5 - Rolls-Royce -->
                <div class="brand-card" data-country="United Kingdom">
                    <div class="brand-card-header">
                        <div class="brand-logo">
                            <i class="fas fa-gem"></i>
                        </div>
                        <h2 class="brand-name">Rolls-Royce</h2>
                        <span class="brand-country">
                            <i class="fas fa-map-marker-alt"></i>
                            United Kingdom
                        </span>
                    </div>
                    <div class="brand-card-body">
                        <p class="brand-description">
                            Xe siêu sang đỉnh cao từ Anh Quốc. Rolls-Royce là đỉnh cao của sự xa hoa, 
                            thủ công tinh xảo và đẳng cấp dành cho giới thượng lưu.
                        </p>
                        <div class="brand-stats">
                            <div class="brand-stat">
                                <div class="brand-stat-value">4+</div>
                                <div class="brand-stat-label">Dòng xe</div>
                            </div>
                            <div class="brand-stat">
                                <div class="brand-stat-value">6</div>
                                <div class="brand-stat-label">Xe có sẵn</div>
                            </div>
                        </div>
                        <div class="brand-actions">
                            <a href="${pageContext.request.contextPath}/cars.jsp?brand=rollsroyce" class="btn btn-primary btn-brand">
                                <i class="fas fa-car"></i> Xem xe
                            </a>
                            <a href="#" class="btn btn-outline btn-brand">
                                <i class="fas fa-info-circle"></i> Chi tiết
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Brand Card 6 - Porsche -->
                <div class="brand-card" data-country="Germany">
                    <div class="brand-card-header">
                        <div class="brand-logo">
                            <i class="fas fa-bolt"></i>
                        </div>
                        <h2 class="brand-name">Porsche</h2>
                        <span class="brand-country">
                            <i class="fas fa-map-marker-alt"></i>
                            Germany
                        </span>
                    </div>
                    <div class="brand-card-body">
                        <p class="brand-description">
                            Xe thể thao hiệu suất cao từ Đức. Porsche nổi tiếng với dòng 911 huyền thoại 
                            và các mẫu xe thể thao mang tính biểu tượng của ngành công nghiệp ô tô.
                        </p>
                        <div class="brand-stats">
                            <div class="brand-stat">
                                <div class="brand-stat-value">8+</div>
                                <div class="brand-stat-label">Dòng xe</div>
                            </div>
                            <div class="brand-stat">
                                <div class="brand-stat-value">18</div>
                                <div class="brand-stat-label">Xe có sẵn</div>
                            </div>
                        </div>
                        <div class="brand-actions">
                            <a href="${pageContext.request.contextPath}/cars.jsp?brand=porsche" class="btn btn-primary btn-brand">
                                <i class="fas fa-car"></i> Xem xe
                            </a>
                            <a href="#" class="btn btn-outline btn-brand">
                                <i class="fas fa-info-circle"></i> Chi tiết
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Brand Card 7 - Ferrari -->
                <div class="brand-card" data-country="Italy">
                    <div class="brand-card-header">
                        <div class="brand-logo">
                            <i class="fas fa-horse-head"></i>
                        </div>
                        <h2 class="brand-name">Ferrari</h2>
                        <span class="brand-country">
                            <i class="fas fa-map-marker-alt"></i>
                            Italy
                        </span>
                    </div>
                    <div class="brand-card-body">
                        <p class="brand-description">
                            Siêu xe thể thao huyền thoại từ Italia. Ferrari là biểu tượng của đam mê tốc độ, 
                            di sản đua xe Formula 1 và thiết kế Ý đẳng cấp thế giới.
                        </p>
                        <div class="brand-stats">
                            <div class="brand-stat">
                                <div class="brand-stat-value">9+</div>
                                <div class="brand-stat-label">Dòng xe</div>
                            </div>
                            <div class="brand-stat">
                                <div class="brand-stat-value">12</div>
                                <div class="brand-stat-label">Xe có sẵn</div>
                            </div>
                        </div>
                        <div class="brand-actions">
                            <a href="${pageContext.request.contextPath}/cars.jsp?brand=ferrari" class="btn btn-primary btn-brand">
                                <i class="fas fa-car"></i> Xem xe
                            </a>
                            <a href="#" class="btn btn-outline btn-brand">
                                <i class="fas fa-info-circle"></i> Chi tiết
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Brand Card 8 - Bentley -->
                <div class="brand-card" data-country="United Kingdom">
                    <div class="brand-card-header">
                        <div class="brand-logo">
                            <i class="fas fa-chess-queen"></i>
                        </div>
                        <h2 class="brand-name">Bentley</h2>
                        <span class="brand-country">
                            <i class="fas fa-map-marker-alt"></i>
                            United Kingdom
                        </span>
                    </div>
                    <div class="brand-card-body">
                        <p class="brand-description">
                            Xe sang trọng thủ công cao cấp từ Anh. Bentley kết hợp giữa hiệu suất mạnh mẽ 
                            và sự sang trọng tinh tế với nội thất da thủ công đẳng cấp.
                        </p>
                        <div class="brand-stats">
                            <div class="brand-stat">
                                <div class="brand-stat-value">5+</div>
                                <div class="brand-stat-label">Dòng xe</div>
                            </div>
                            <div class="brand-stat">
                                <div class="brand-stat-value">10</div>
                                <div class="brand-stat-label">Xe có sẵn</div>
                            </div>
                        </div>
                        <div class="brand-actions">
                            <a href="${pageContext.request.contextPath}/cars.jsp?brand=bentley" class="btn btn-primary btn-brand">
                                <i class="fas fa-car"></i> Xem xe
                            </a>
                            <a href="#" class="btn btn-outline btn-brand">
                                <i class="fas fa-info-circle"></i> Chi tiết
                            </a>
                        </div>
                    </div>
                </div>
                
                <!-- Brand Card 9 - Lexus -->
                <div class="brand-card" data-country="Japan">
                    <div class="brand-card-header">
                        <div class="brand-logo">
                            <i class="fas fa-fan"></i>
                        </div>
                        <h2 class="brand-name">Lexus</h2>
                        <span class="brand-country">
                            <i class="fas fa-map-marker-alt"></i>
                            Japan
                        </span>
                    </div>
                    <div class="brand-card-body">
                        <p class="brand-description">
                            Thương hiệu xe sang của Toyota từ Nhật Bản. Lexus nổi tiếng với độ tin cậy cao, 
                            công nghệ hybrid tiên tiến và sự hoàn thiện tuyệt hảo trong từng chi tiết.
                        </p>
                        <div class="brand-stats">
                            <div class="brand-stat">
                                <div class="brand-stat-value">10+</div>
                                <div class="brand-stat-label">Dòng xe</div>
                            </div>
                            <div class="brand-stat">
                                <div class="brand-stat-value">22</div>
                                <div class="brand-stat-label">Xe có sẵn</div>
                            </div>
                        </div>
                        <div class="brand-actions">
                            <a href="${pageContext.request.contextPath}/cars.jsp?brand=lexus" class="btn btn-primary btn-brand">
                                <i class="fas fa-car"></i> Xem xe
                            </a>
                            <a href="#" class="btn btn-outline btn-brand">
                                <i class="fas fa-info-circle"></i> Chi tiết
                            </a>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
    </section>
    
    <!-- STATS SECTION -->
    <section class="stats-section">
        <div class="container">
            <div class="stats-grid">
                <div class="stat-item">
                    <div class="stat-number">9</div>
                    <div class="stat-label">Thương hiệu cao cấp</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">80+</div>
                    <div class="stat-label">Dòng xe khác nhau</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">160+</div>
                    <div class="stat-label">Xe có sẵn</div>
                </div>
                <div class="stat-item">
                    <div class="stat-number">5</div>
                    <div class="stat-label">Quốc gia</div>
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
                    <div class="social-links">
                        <a href="#" class="social-link"><i class="fab fa-facebook-f"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-instagram"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-youtube"></i></a>
                        <a href="#" class="social-link"><i class="fab fa-tiktok"></i></a>
                    </div>
                </div>
                
                <div class="footer-section">
                    <h3>Liên Kết</h3>
                    <div class="footer-links">
                        <a href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
                        <a href="${pageContext.request.contextPath}/cars.jsp">Xe bán</a>
                        <a href="${pageContext.request.contextPath}/brands.jsp">Hãng xe</a>
                        <a href="${pageContext.request.contextPath}/login.jsp">Đăng nhập</a>
                    </div>
                </div>
                
                <div class="footer-section">
                    <h3>Dịch Vụ</h3>
                    <div class="footer-links">
                        <a href="#">Mua xe</a>
                        <a href="#">Bán xe</a>
                        <a href="#">Tư vấn</a>
                        <a href="#">Bảo hiểm</a>
                    </div>
                </div>
                
                <div class="footer-section">
                    <h3>Liên Hệ</h3>
                    <p><i class="fas fa-map-marker-alt"></i> 123 Nguyễn Huệ, Q1, TP.HCM</p>
                    <p><i class="fas fa-phone"></i> 1900 xxxx</p>
                    <p><i class="fas fa-envelope"></i> info@luxurycars.vn</p>
                </div>
            </div>
            
            <div class="footer-bottom">
                <p>&copy; 2024 LuxuryCars. All rights reserved.</p>
            </div>
        </div>
    </footer>
    
    <!-- JavaScript -->
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
    <script src="${pageContext.request.contextPath}/js/brands.js"></script>
    
</body>
</html>
