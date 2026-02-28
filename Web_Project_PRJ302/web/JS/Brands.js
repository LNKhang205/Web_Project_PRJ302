// =====================================================
// BRANDS PAGE - Filter and Animation
// =====================================================

document.addEventListener('DOMContentLoaded', function() {
    
    const filterButtons = document.querySelectorAll('.country-filter-btn');
    const brandCards = document.querySelectorAll('.brand-card');
    const brandsGrid = document.getElementById('brandsGrid');
    
    // ===== Filter Brands by Country =====
    filterButtons.forEach(button => {
        button.addEventListener('click', function() {
            const country = this.dataset.country;
            
            // Update active button
            filterButtons.forEach(btn => btn.classList.remove('active'));
            this.classList.add('active');
            
            // Filter brands
            filterBrands(country);
        });
    });
    
    function filterBrands(country) {
        let visibleCount = 0;
        
        brandCards.forEach(card => {
            const cardCountry = card.dataset.country;
            
            if (country === 'all' || cardCountry === country) {
                card.style.display = 'block';
                // Animate on show
                card.style.animation = 'none';
                setTimeout(() => {
                    card.style.animation = `fadeInUp 0.6s ease ${visibleCount * 0.1}s forwards`;
                    visibleCount++;
                }, 10);
            } else {
                card.style.display = 'none';
            }
        });
        
        // Show message if no brands found
        showNoResultsMessage(visibleCount);
    }
    
    // ===== Show No Results Message =====
    function showNoResultsMessage(count) {
        let noResultsMsg = document.getElementById('noResultsMessage');
        
        if (count === 0) {
            if (!noResultsMsg) {
                noResultsMsg = document.createElement('div');
                noResultsMsg.id = 'noResultsMessage';
                noResultsMsg.style.cssText = `
                    grid-column: 1 / -1;
                    text-align: center;
                    padding: 4rem 2rem;
                    color: var(--text-light);
                `;
                noResultsMsg.innerHTML = `
                    <i class="fas fa-search" style="font-size: 4rem; color: var(--light-gray); margin-bottom: 1rem;"></i>
                    <h3 style="margin-bottom: 1rem;">Không tìm thấy hãng xe</h3>
                    <p>Vui lòng chọn quốc gia khác hoặc <button class="country-filter-btn" data-country="all" style="display: inline; padding: 0.5rem 1rem; margin-top: 1rem;">xem tất cả</button></p>
                `;
                brandsGrid.appendChild(noResultsMsg);
                
                // Add event listener to the new button
                const newBtn = noResultsMsg.querySelector('.country-filter-btn');
                newBtn.addEventListener('click', function() {
                    filterButtons.forEach(btn => btn.classList.remove('active'));
                    filterButtons[0].classList.add('active');
                    filterBrands('all');
                });
            }
        } else {
            if (noResultsMsg) {
                noResultsMsg.remove();
            }
        }
    }
    
    // ===== URL Parameters (for deep linking) =====
    function getUrlParams() {
        const params = new URLSearchParams(window.location.search);
        return {
            country: params.get('country') || 'all'
        };
    }
    
    function applyUrlParams() {
        const params = getUrlParams();
        
        if (params.country && params.country !== 'all') {
            const targetButton = Array.from(filterButtons).find(
                btn => btn.dataset.country === params.country
            );
            
            if (targetButton) {
                filterButtons.forEach(btn => btn.classList.remove('active'));
                targetButton.classList.add('active');
                filterBrands(params.country);
            }
        }
    }
    
    // Apply URL parameters on page load
    applyUrlParams();
    
    // ===== Card Hover Effects =====
    brandCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-10px) scale(1.02)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0) scale(1)';
        });
    });
    
    // ===== Animate Stats on Scroll =====
    const statsSection = document.querySelector('.stats-section');
    const statNumbers = document.querySelectorAll('.stat-number');
    let hasAnimated = false;
    
    function animateStats() {
        if (hasAnimated) return;
        
        const sectionTop = statsSection.getBoundingClientRect().top;
        const windowHeight = window.innerHeight;
        
        if (sectionTop < windowHeight - 100) {
            hasAnimated = true;
            
            statNumbers.forEach((stat, index) => {
                const finalValue = stat.textContent;
                const isNumber = !isNaN(parseInt(finalValue));
                
                if (isNumber) {
                    const target = parseInt(finalValue);
                    let current = 0;
                    const increment = target / 50;
                    const duration = 1500;
                    const stepTime = duration / 50;
                    
                    stat.textContent = '0';
                    
                    const timer = setInterval(() => {
                        current += increment;
                        if (current >= target) {
                            stat.textContent = finalValue;
                            clearInterval(timer);
                        } else {
                            stat.textContent = Math.floor(current) + (finalValue.includes('+') ? '+' : '');
                        }
                    }, stepTime);
                }
            });
        }
    }
    
    if (statsSection) {
        window.addEventListener('scroll', animateStats);
        animateStats(); // Check on page load
    }
    
    // ===== Search Functionality (Optional Enhancement) =====
    function addSearchBar() {
        const filterSection = document.querySelector('.filter-section .container');
        
        const searchContainer = document.createElement('div');
        searchContainer.style.cssText = `
            margin-bottom: 2rem;
            text-align: center;
        `;
        
        searchContainer.innerHTML = `
            <input 
                type="text" 
                id="brandSearch" 
                placeholder="Tìm kiếm hãng xe..." 
                style="
                    width: 100%;
                    max-width: 500px;
                    padding: 1rem 1.5rem;
                    border: 2px solid var(--light-gray);
                    font-size: 1rem;
                    font-family: var(--font-body);
                    transition: var(--transition);
                "
            >
        `;
        
        filterSection.insertBefore(searchContainer, filterSection.firstChild);
        
        const searchInput = document.getElementById('brandSearch');
        
        searchInput.addEventListener('focus', function() {
            this.style.borderColor = 'var(--primary-gold)';
        });
        
        searchInput.addEventListener('blur', function() {
            this.style.borderColor = 'var(--light-gray)';
        });
        
        searchInput.addEventListener('input', function() {
            const searchTerm = this.value.toLowerCase();
            let visibleCount = 0;
            
            brandCards.forEach(card => {
                const brandName = card.querySelector('.brand-name').textContent.toLowerCase();
                const brandDescription = card.querySelector('.brand-description').textContent.toLowerCase();
                
                if (brandName.includes(searchTerm) || brandDescription.includes(searchTerm)) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });
            
            showNoResultsMessage(visibleCount);
            
            // Reset country filter if searching
            if (searchTerm) {
                filterButtons.forEach(btn => btn.classList.remove('active'));
            }
        });
    }
    
    // Uncomment to enable search bar
    // addSearchBar();
    
    // ===== Initial Animation =====
    brandCards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(30px)';
        
        setTimeout(() => {
            card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, index * 100);
    });
    
    // ===== Add CSS Animation =====
    const style = document.createElement('style');
    style.textContent = `
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }
        
        @keyframes wave {
            0% { background-position: 0 0; }
            100% { background-position: 1200px 0; }
        }
    `;
    document.head.appendChild(style);
    
    // ===== Console Log =====
    console.log('%c🏎️ BRANDS PAGE LOADED', 'font-size: 16px; font-weight: bold; color: #D4AF37;');
    console.log(`Total brands: ${brandCards.length}`);
    
});