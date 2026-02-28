<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Danh Sách Xe - Luxury Car Sales</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/style.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    
    <style>
        /* Pagination Styles */
        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 0.5rem;
            margin-top: 3rem;
            flex-wrap: wrap;
        }
        
        .pagination-btn {
            min-width: 45px;
            height: 45px;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 2px solid var(--light-gray);
            background: white;
            color: var(--primary-dark);
            font-weight: 600;
            cursor: pointer;
            transition: var(--transition);
            text-decoration: none;
        }
        
        .pagination-btn:hover {
            border-color: var(--primary-gold);
            background: var(--primary-gold);
            color: var(--primary-dark);
        }
        
        .pagination-btn.active {
            border-color: var(--primary-gold);
            background: var(--primary-gold);
            color: var(--primary-dark);
        }
        
        .pagination-btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
            background: var(--light-gray);
        }
        
        .pagination-btn:disabled:hover {
            border-color: var(--light-gray);
            background: var(--light-gray);
        }
        
        .pagination-info {
            color: var(--text-light);
            font-size: 0.95rem;
            margin: 0 1rem;
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
                    <li><a href="${pageContext.request.contextPath}/cars" class="nav-link active">Xe bán</a></li>
                    <li><a href="${pageContext.request.contextPath}/brands.jsp" class="nav-link">Hãng xe</a></li>
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
    <section class="page-header" style="background: linear-gradient(135deg, var(--primary-dark) 0%, var(--secondary-gray) 100%); padding: 8rem 0 4rem; margin-top: 80px; text-align: center; color: white;">
        <div class="container">
            <h1 class="page-title" style="color: white; margin-bottom: 1rem;">Bộ Sưu Tập Xe Sang</h1>
            <p style="font-size: 1.2rem; color: var(--light-gray);">
                Khám phá những mẫu xe cao cấp hàng đầu thế giới
            </p>
        </div>
    </section>
    
    <!-- FILTERS -->
    <section class="filters-section" style="background: var(--light-gray); padding: 2rem 0; position: sticky; top: 80px; z-index: 100;">
        <div class="container">
            <form class="filters" action="${pageContext.request.contextPath}/cars" method="GET" style="display: flex; gap: 1rem; flex-wrap: wrap; align-items: center;">
                
                <div class="filter-group" style="flex: 1; min-width: 200px;">
                    <label for="brand">Hãng xe</label>
                    <select id="brand" name="brand" class="form-control">
                        <option value="">Tất cả hãng</option>
                        <c:forEach var="brand" items="${brandList}">
                            <option value="${brand.brandId}" 
                                ${selectedBrand == brand.brandId ? 'selected' : ''}>
                                ${brand.brandName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="filter-group" style="flex: 1; min-width: 200px;">
                    <label for="category">Loại xe</label>
                    <select id="category" name="category" class="form-control">
                        <option value="">Tất cả loại</option>
                        <c:forEach var="category" items="${categoryList}">
                            <option value="${category.categoryId}"
                                ${selectedCategory == category.categoryId ? 'selected' : ''}>
                                ${category.categoryName}
                            </option>
                        </c:forEach>
                    </select>
                </div>
                
                <div class="filter-group" style="flex: 1; min-width: 150px;">
                    <label for="priceMin">Giá từ (tỷ)</label>
                    <input type="number" id="priceMin" name="priceMin" 
                           placeholder="0" min="0" step="0.1"
                           value="${selectedPriceMin}" class="form-control">
                </div>
                
                <div class="filter-group" style="flex: 1; min-width: 150px;">
                    <label for="priceMax">Đến (tỷ)</label>
                    <input type="number" id="priceMax" name="priceMax" 
                           placeholder="100" min="0" step="0.1"
                           value="${selectedPriceMax}" class="form-control">
                </div>
                
                <button type="submit" class="btn btn-primary btn-filter" style="padding: 0.75rem 2rem; margin-top: 1.75rem;">
                    <i class="fas fa-search"></i> Tìm kiếm
                </button>
                
                <a href="${pageContext.request.contextPath}/cars" class="btn btn-outline btn-filter" style="padding: 0.75rem 2rem; margin-top: 1.75rem;">
                    <i class="fas fa-times"></i> Xóa bộ lọc
                </a>
            </form>
        </div>
    </section>
    
    <!-- CARS LIST -->
    <section class="section">
        <div class="container">
            
            <!-- Results Info -->
            <div class="results-info" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem; padding-bottom: 1rem; border-bottom: 2px solid var(--light-gray);">
                <div class="results-count" style="font-size: 1.1rem; color: var(--text-light);">
                    Tìm thấy <strong style="color: var(--primary-gold); font-weight: 700;">${totalCars}</strong> xe
                    <c:if test="${totalPages > 1}">
                        - Trang <strong>${currentPage}</strong> / <strong>${totalPages}</strong>
                    </c:if>
                </div>
                <select class="sort-select" id="sortSelect" style="padding: 0.5rem 1rem; border: 2px solid var(--light-gray); background: white;">
                    <option value="newest">Mới nhất</option>
                    <option value="price-asc">Giá thấp đến cao</option>
                    <option value="price-desc">Giá cao đến thấp</option>
                    <option value="mileage">Số km thấp nhất</option>
                </select>
            </div>
            
            <!-- Car Grid -->
            <c:choose>
                <c:when test="${not empty carList}">
                    <div class="car-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 2.5rem;">
                        <c:forEach var="car" items="${carList}">
                            <div class="car-card">
                                <div class="car-card-image" style="position: relative; height: 250px; overflow: hidden; background: var(--light-gray);">
                                    <img src="https://images.unsplash.com/photo-1618843479313-40f8afb4b4d8?w=600" 
                                         alt="${car.brandName} ${car.modelName}"
                                         style="width: 100%; height: 100%; object-fit: cover;">
                                    <span class="car-badge" style="position: absolute; top: 1rem; right: 1rem; background: var(--primary-gold); color: var(--primary-dark); padding: 0.5rem 1rem; font-size: 0.75rem; font-weight: 700; text-transform: uppercase;">
                                        ${car.status}
                                    </span>
                                </div>
                                <div class="car-card-content" style="padding: 2rem;">
                                    <div class="car-brand" style="font-size: 0.85rem; color: var(--primary-gold); font-weight: 600; text-transform: uppercase; margin-bottom: 0.5rem;">
                                        ${car.brandName}
                                    </div>
                                    <h3 class="car-name" style="font-size: 1.5rem; margin-bottom: 1rem;">
                                        ${car.modelName}
                                    </h3>
                                    <div class="car-specs" style="display: flex; gap: 1rem; margin: 1rem 0; padding: 1rem 0; border-top: 1px solid var(--light-gray); border-bottom: 1px solid var(--light-gray);">
                                        <div class="car-spec" style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.85rem; color: var(--text-light);">
                                            <i class="fas fa-tachometer-alt" style="color: var(--primary-gold);"></i>
                                            <span><fmt:formatNumber value="${car.mileage}" /> km</span>
                                        </div>
                                        <div class="car-spec" style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.85rem; color: var(--text-light);">
                                            <i class="fas fa-cog" style="color: var(--primary-gold);"></i>
                                            <span>${car.transmission}</span>
                                        </div>
                                        <div class="car-spec" style="display: flex; align-items: center; gap: 0.5rem; font-size: 0.85rem; color: var(--text-light);">
                                            <i class="fas fa-palette" style="color: var(--primary-gold);"></i>
                                            <span>${car.color}</span>
                                        </div>
                                    </div>
                                    <div class="car-footer" style="display: flex; justify-content: space-between; align-items: center; margin-top: 1rem;">
                                        <div class="car-price" style="font-size: 1.8rem; font-weight: 700; color: var(--primary-dark); font-family: var(--font-display);">
                                            <fmt:formatNumber value="${car.price / 1000000000}" maxFractionDigits="1" /> tỷ
                                            <span style="font-size: 0.9rem; color: var(--text-light); font-weight: 400;">VNĐ</span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/car-detail?id=${car.carId}" 
                                           class="btn btn-primary btn-view" style="padding: 0.75rem 1.5rem; font-size: 0.85rem;">
                                            Chi tiết
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div style="text-align: center; padding: 4rem 2rem; color: var(--text-light);">
                        <i class="fas fa-car" style="font-size: 4rem; color: var(--light-gray); margin-bottom: 1rem;"></i>
                        <h3 style="margin-bottom: 1rem;">Không tìm thấy xe phù hợp</h3>
                        <p>Vui lòng thử lại với bộ lọc khác hoặc 
                           <a href="${pageContext.request.contextPath}/cars" style="color: var(--primary-gold);">xem tất cả xe</a>
                        </p>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <!-- PAGINATION -->
            <c:if test="${totalPages > 1}">
                <div class="pagination">
                    <!-- Previous Button -->
                    <c:choose>
                        <c:when test="${currentPage > 1}">
                            <a href="${pageContext.request.contextPath}/cars?page=${currentPage - 1}&brand=${selectedBrand}&category=${selectedCategory}&priceMin=${selectedPriceMin}&priceMax=${selectedPriceMax}" 
                               class="pagination-btn">
                                <i class="fas fa-chevron-left"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button class="pagination-btn" disabled>
                                <i class="fas fa-chevron-left"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Page Numbers -->
                    <c:choose>
                        <c:when test="${totalPages <= 7}">
                            <!-- Show all pages if <= 7 -->
                            <c:forEach var="i" begin="1" end="${totalPages}">
                                <a href="${pageContext.request.contextPath}/cars?page=${i}&brand=${selectedBrand}&category=${selectedCategory}&priceMin=${selectedPriceMin}&priceMax=${selectedPriceMax}" 
                                   class="pagination-btn ${i == currentPage ? 'active' : ''}">
                                    ${i}
                                </a>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <!-- Smart pagination for many pages -->
                            <c:if test="${currentPage > 3}">
                                <a href="${pageContext.request.contextPath}/cars?page=1&brand=${selectedBrand}&category=${selectedCategory}&priceMin=${selectedPriceMin}&priceMax=${selectedPriceMax}" 
                                   class="pagination-btn">1</a>
                                <span class="pagination-info">...</span>
                            </c:if>
                            
                            <c:forEach var="i" begin="${currentPage - 2 < 1 ? 1 : currentPage - 2}" 
                                      end="${currentPage + 2 > totalPages ? totalPages : currentPage + 2}">
                                <a href="${pageContext.request.contextPath}/cars?page=${i}&brand=${selectedBrand}&category=${selectedCategory}&priceMin=${selectedPriceMin}&priceMax=${selectedPriceMax}" 
                                   class="pagination-btn ${i == currentPage ? 'active' : ''}">
                                    ${i}
                                </a>
                            </c:forEach>
                            
                            <c:if test="${currentPage < totalPages - 2}">
                                <span class="pagination-info">...</span>
                                <a href="${pageContext.request.contextPath}/cars?page=${totalPages}&brand=${selectedBrand}&category=${selectedCategory}&priceMin=${selectedPriceMin}&priceMax=${selectedPriceMax}" 
                                   class="pagination-btn">${totalPages}</a>
                            </c:if>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Next Button -->
                    <c:choose>
                        <c:when test="${currentPage < totalPages}">
                            <a href="${pageContext.request.contextPath}/cars?page=${currentPage + 1}&brand=${selectedBrand}&category=${selectedCategory}&priceMin=${selectedPriceMin}&priceMax=${selectedPriceMax}" 
                               class="pagination-btn">
                                <i class="fas fa-chevron-right"></i>
                            </a>
                        </c:when>
                        <c:otherwise>
                            <button class="pagination-btn" disabled>
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </c:otherwise>
                    </c:choose>
                    
                    <span class="pagination-info">
                        Trang ${currentPage} / ${totalPages}
                    </span>
                </div>
            </c:if>
            
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
                        <a href="${pageContext.request.contextPath}/index.jsp">Trang chủ</a>
                        <a href="${pageContext.request.contextPath}/cars">Xe bán</a>
                        <a href="${pageContext.request.contextPath}/brands.jsp">Hãng xe</a>
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
    
    <script src="${pageContext.request.contextPath}/js/script.js"></script>
    
</body>
</html>
