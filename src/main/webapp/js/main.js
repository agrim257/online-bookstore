/**
 * Online Bookstore - Advanced Dynamic Frontend Engine
 * Includes Theme Management, Toast Alerts, Live Search & Filter,
 * Dynamic Book Covers, Modal Preview, Cart Steppers, and Micro-interactions.
 */

(function () {
    'use strict';

    // ==========================================
    // 1. THEME TOGGLE (Dark / Light)
    // ==========================================
    const THEME_STORAGE_KEY = 'bookstore_theme';

    function initTheme() {
        const savedTheme = localStorage.getItem(THEME_STORAGE_KEY);
        // Default to dark theme for modern luxury look, or respect saved preference
        const currentTheme = savedTheme ? savedTheme : 'dark';
        applyTheme(currentTheme);

        document.querySelectorAll('.theme-toggle-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const active = document.documentElement.getAttribute('data-theme') || 'dark';
                const nextTheme = active === 'dark' ? 'light' : 'dark';
                applyTheme(nextTheme);
                localStorage.setItem(THEME_STORAGE_KEY, nextTheme);
                showToast(`Switched to ${nextTheme === 'dark' ? 'Dark' : 'Light'} Mode`, 'info');
            });
        });
    }

    function applyTheme(theme) {
        document.documentElement.setAttribute('data-theme', theme);
        document.querySelectorAll('.theme-toggle-btn').forEach(btn => {
            const icon = btn.querySelector('i');
            if (icon) {
                if (theme === 'dark') {
                    icon.className = 'fas fa-sun';
                    btn.setAttribute('title', 'Switch to Light Mode');
                } else {
                    icon.className = 'fas fa-moon';
                    btn.setAttribute('title', 'Switch to Dark Mode');
                }
            }
        });
    }

    // ==========================================
    // 2. TOAST NOTIFICATION SYSTEM
    // ==========================================
    function createToastContainer() {
        let container = document.getElementById('toast-container');
        if (!container) {
            container = document.createElement('div');
            container.id = 'toast-container';
            container.className = 'toast-container';
            document.body.appendChild(container);
        }
        return container;
    }

    window.showToast = function (message, type = 'info', duration = 3800) {
        const container = createToastContainer();
        const toast = document.createElement('div');
        toast.className = `toast toast-${type} animate-slide-in`;

        const iconMap = {
            success: 'fa-circle-check',
            error: 'fa-circle-exclamation',
            danger: 'fa-circle-xmark',
            warning: 'fa-triangle-exclamation',
            info: 'fa-circle-info'
        };
        const icon = iconMap[type] || 'fa-bell';

        toast.innerHTML = `
            <div class="toast-content">
                <i class="fas ${icon} toast-icon"></i>
                <span class="toast-message">${message}</span>
            </div>
            <button class="toast-close" aria-label="Close">&times;</button>
            <div class="toast-progress"></div>
        `;

        container.appendChild(toast);

        const closeBtn = toast.querySelector('.toast-close');
        closeBtn.addEventListener('click', () => dismissToast(toast));

        const timer = setTimeout(() => dismissToast(toast), duration);

        function dismissToast(el) {
            clearTimeout(timer);
            el.classList.add('toast-hiding');
            setTimeout(() => {
                if (el.parentNode) el.parentNode.removeChild(el);
            }, 300);
        }
    };

    // Auto-detect URL query params and alert user with sleek toasts
    function checkUrlAlerts() {
        const urlParams = new URLSearchParams(window.location.search);
        const msg = urlParams.get('msg');
        const err = urlParams.get('error');

        if (msg === 'registered') {
            showToast('Account created successfully! Welcome aboard.', 'success', 5000);
        } else if (msg === 'logged_out') {
            showToast('You have been logged out securely.', 'info', 4000);
        } else if (msg === 'success') {
            showToast('Order confirmed! Thank you for your purchase.', 'success', 5000);
        } else if (msg === 'saved') {
            showToast('Book details saved successfully!', 'success', 4000);
        } else if (msg === 'deleted') {
            showToast('Book removed from catalog.', 'warning', 4000);
        } else if (msg === 'updated') {
            showToast('Changes updated successfully!', 'success', 4000);
        }

        if (err === 'stock_error') {
            showToast('Order failed: Requested quantity exceeds available inventory.', 'error', 5000);
        } else if (err === 'unauthorized') {
            showToast('Access denied: Administrator privileges required.', 'danger', 5000);
        } else if (err === 'login_required') {
            showToast('Please sign in to proceed with your order.', 'warning', 4500);
        }
    }

    // ==========================================
    // 3. DYNAMIC BOOK COVERS GENERATOR
    // ==========================================
    const COVER_GRADIENTS = [
        ['#4f46e5', '#7c3aed'], // Indigo to Violet
        ['#0284c7', '#2563eb'], // Sky to Blue
        ['#059669', '#0d9488'], // Emerald to Teal
        ['#e11d48', '#be123c'], // Rose to Ruby
        ['#d97706', '#b45309'], // Amber to Ochre
        ['#7c2d12', '#431407'], // Saddle to Leather
        ['#4c1d95', '#1e1b4b'], // Deep Royal Midnight
        ['#0f766e', '#134e4a']  // Forest Pine
    ];

    function hashString(str) {
        let hash = 0;
        for (let i = 0; i < str.length; i++) {
            hash = (hash << 5) - hash + str.charCodeAt(i);
            hash |= 0;
        }
        return Math.abs(hash);
    }

    function initProceduralCovers() {
        document.querySelectorAll('.procedural-book-cover').forEach(cover => {
            const title = cover.dataset.title || 'Book Title';
            const author = cover.dataset.author || 'Author';
            const category = cover.dataset.category || 'General';

            const hash = hashString(title + author);
            const palette = COVER_GRADIENTS[hash % COVER_GRADIENTS.length];

            cover.style.background = `linear-gradient(135deg, ${palette[0]} 0%, ${palette[1]} 100%)`;
        });
    }

    // ==========================================
    // 4. LIVE CLIENT-SIDE SEARCH & CATEGORY FILTER (books.jsp)
    // ==========================================
    function initCatalogFilters() {
        const liveSearchInput = document.getElementById('liveSearchInput');
        const categoryChips = document.querySelectorAll('.category-chip');
        const bookCards = document.querySelectorAll('.book-card-item');
        const emptyNotice = document.getElementById('noLiveResultsNotice');
        const countBadge = document.getElementById('liveFilteredCount');

        if (!bookCards.length) return;

        let activeCategory = 'all';
        let searchQuery = '';

        function filterBooks() {
            let visibleCount = 0;
            const q = searchQuery.trim().toLowerCase();

            bookCards.forEach(card => {
                const title = (card.dataset.title || '').toLowerCase();
                const author = (card.dataset.author || '').toLowerCase();
                const cat = (card.dataset.category || '').toLowerCase();

                const matchesQuery = !q || title.includes(q) || author.includes(q) || cat.includes(q);
                const matchesCategory = activeCategory === 'all' || cat === activeCategory.toLowerCase();

                if (matchesQuery && matchesCategory) {
                    card.style.display = '';
                    card.classList.add('animate-fade-in');
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            if (emptyNotice) {
                emptyNotice.style.display = visibleCount === 0 ? 'block' : 'none';
            }
            if (countBadge) {
                countBadge.textContent = `${visibleCount} title${visibleCount === 1 ? '' : 's'}`;
            }
        }

        if (liveSearchInput) {
            liveSearchInput.addEventListener('input', (e) => {
                searchQuery = e.target.value;
                filterBooks();
            });
        }

        categoryChips.forEach(chip => {
            chip.addEventListener('click', (e) => {
                e.preventDefault();
                categoryChips.forEach(c => c.classList.remove('active'));
                chip.classList.add('active');
                activeCategory = chip.dataset.cat || 'all';
                filterBooks();
            });
        });

        // Quick View modal bindings
        document.querySelectorAll('.btn-quick-view').forEach(btn => {
            btn.addEventListener('click', (e) => {
                e.preventDefault();
                const id = btn.dataset.id;
                const title = btn.dataset.title;
                const author = btn.dataset.author;
                const price = btn.dataset.price;
                const category = btn.dataset.category;
                const stock = parseInt(btn.dataset.stock, 10);
                const desc = btn.dataset.description || 'No detailed description available.';
                openQuickViewModal({ id, title, author, price, category, stock, desc });
            });
        });
    }

    // ==========================================
    // 5. QUICK VIEW MODAL
    // ==========================================
    function openQuickViewModal(book) {
        let modal = document.getElementById('bookQuickViewModal');
        if (!modal) return;

        const hash = hashString(book.title + book.author);
        const palette = COVER_GRADIENTS[hash % COVER_GRADIENTS.length];

        const coverEl = modal.querySelector('.modal-book-cover');
        if (coverEl) {
            coverEl.style.background = `linear-gradient(135deg, ${palette[0]} 0%, ${palette[1]} 100%)`;
            coverEl.querySelector('.modal-cover-title').textContent = book.title;
            coverEl.querySelector('.modal-cover-author').textContent = book.author;
        }

        modal.querySelector('.modal-book-title').textContent = book.title;
        modal.querySelector('.modal-book-author').textContent = `By ${book.author}`;
        modal.querySelector('.modal-book-category').textContent = book.category;
        modal.querySelector('.modal-book-price').textContent = `₹${parseFloat(book.price).toFixed(2)}`;
        modal.querySelector('.modal-book-desc').textContent = book.desc;

        const stockBadge = modal.querySelector('.modal-book-stock');
        const form = modal.querySelector('.modal-cart-form');
        const bookIdInput = modal.querySelector('input[name="bookId"]');
        const detailLink = modal.querySelector('.modal-detail-link');

        if (detailLink) {
            detailLink.href = `${detailLink.dataset.base}?id=${book.id}`;
        }
        if (bookIdInput) {
            bookIdInput.value = book.id;
        }

        if (book.stock > 0) {
            stockBadge.className = 'badge badge-in';
            stockBadge.innerHTML = `<i class="fas fa-check-circle"></i> In Stock (${book.stock})`;
            if (form) form.style.display = 'flex';
        } else {
            stockBadge.className = 'badge badge-out';
            stockBadge.innerHTML = `<i class="fas fa-times-circle"></i> Out of Stock`;
            if (form) form.style.display = 'none';
        }

        modal.classList.add('modal-open');
        document.body.style.overflow = 'hidden';
    }

    window.closeQuickViewModal = function () {
        const modal = document.getElementById('bookQuickViewModal');
        if (modal) {
            modal.classList.remove('modal-open');
            document.body.style.overflow = '';
        }
    };

    // ==========================================
    // 6. QUANTITY STEPPERS
    // ==========================================
    function initQuantitySteppers() {
        document.querySelectorAll('.qty-stepper').forEach(stepper => {
            const input = stepper.querySelector('input[type="number"]');
            const btnMinus = stepper.querySelector('.qty-btn.minus');
            const btnPlus = stepper.querySelector('.qty-btn.plus');

            if (!input) return;

            const min = parseInt(input.getAttribute('min') || '1', 10);
            const max = parseInt(input.getAttribute('max') || '999', 10);

            if (btnMinus) {
                btnMinus.addEventListener('click', (e) => {
                    e.preventDefault();
                    let val = parseInt(input.value || min, 10);
                    if (val > min) {
                        input.value = val - 1;
                        input.dispatchEvent(new Event('change'));
                    }
                });
            }

            if (btnPlus) {
                btnPlus.addEventListener('click', (e) => {
                    e.preventDefault();
                    let val = parseInt(input.value || min, 10);
                    if (val < max) {
                        input.value = val + 1;
                        input.dispatchEvent(new Event('change'));
                    } else {
                        showToast(`Max available quantity is ${max}`, 'warning');
                    }
                });
            }
        });
    }

    // ==========================================
    // 7. CART DYNAMICS (Free Shipping & Coupon)
    // ==========================================
    function initCartDynamics() {
        const shippingProgressBar = document.getElementById('freeShippingProgress');
        const shippingText = document.getElementById('freeShippingText');
        const totalAmountEl = document.getElementById('cartGrandTotal');

        if (totalAmountEl && shippingProgressBar) {
            const total = parseFloat(totalAmountEl.dataset.total || '0');
            const target = 500.00; // Free shipping at ₹500

            if (total >= target) {
                shippingProgressBar.style.width = '100%';
                shippingProgressBar.classList.add('progress-complete');
                if (shippingText) {
                    shippingText.innerHTML = '<i class="fas fa-truck-fast"></i> <strong>Congratulations!</strong> You unlocked FREE Express Shipping!';
                }
            } else {
                const diff = (target - total).toFixed(2);
                const pct = Math.min(100, Math.round((total / target) * 100));
                shippingProgressBar.style.width = `${pct}%`;
                if (shippingText) {
                    shippingText.innerHTML = `<i class="fas fa-truck"></i> Add <strong>₹${diff}</strong> more to qualify for <strong>FREE Express Shipping</strong>!`;
                }
            }
        }

        // Coupon code simulation
        const couponForm = document.getElementById('couponForm');
        if (couponForm) {
            couponForm.addEventListener('submit', (e) => {
                e.preventDefault();
                const code = (couponForm.querySelector('input[name="couponCode"]').value || '').trim().toUpperCase();
                const discountNotice = document.getElementById('couponNotice');

                if (code === 'BOOKWORM10' || code === 'SAVE10') {
                    showToast('Coupon applied: 10% discount on order!', 'success');
                    if (discountNotice) {
                        discountNotice.style.display = 'block';
                        discountNotice.innerHTML = '<i class="fas fa-tag"></i> <strong>10% OFF</strong> applied! (Simulated)';
                    }
                } else if (code) {
                    showToast('Invalid or expired discount code. Try "BOOKWORM10"', 'warning');
                }
            });
        }
    }

    // ==========================================
    // 8. DEMO CREDENTIALS AUTOFILL
    // ==========================================
    function initDemoCredentials() {
        const adminBtn = document.getElementById('btnDemoAdmin');
        const customerBtn = document.getElementById('btnDemoCustomer');

        if (adminBtn) {
            adminBtn.addEventListener('click', (e) => {
                e.preventDefault();
                const emailInput = document.querySelector('input[name="email"]');
                const passInput = document.querySelector('input[name="password"]');
                if (emailInput && passInput) {
                    emailInput.value = 'admin@bookstore.com';
                    passInput.value = 'admin123';
                    showToast('Filled demo Admin credentials!', 'info');
                }
            });
        }

        if (customerBtn) {
            customerBtn.addEventListener('click', (e) => {
                e.preventDefault();
                const emailInput = document.querySelector('input[name="email"]');
                const passInput = document.querySelector('input[name="password"]');
                if (emailInput && passInput) {
                    emailInput.value = 'customer@example.com';
                    passInput.value = 'password123';
                    showToast('Filled sample Customer credentials!', 'info');
                }
            });
        }

        // Password Reveal Toggle
        document.querySelectorAll('.password-toggle-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const targetId = btn.dataset.target;
                const input = document.getElementById(targetId) || btn.parentElement.querySelector('input');
                if (!input) return;
                const isPassword = input.type === 'password';
                input.type = isPassword ? 'text' : 'password';
                btn.innerHTML = isPassword ? '<i class="fas fa-eye-slash"></i>' : '<i class="fas fa-eye"></i>';
            });
        });
    }

    // ==========================================
    // 9. ADMIN LIVE PREVIEW (admin-book-form.jsp)
    // ==========================================
    function initAdminLivePreview() {
        const titleInput = document.getElementById('adminBookTitle');
        const authorInput = document.getElementById('adminBookAuthor');
        const catInput = document.getElementById('adminBookCat');
        const priceInput = document.getElementById('adminBookPrice');

        const prevTitle = document.getElementById('previewCardTitle');
        const prevAuthor = document.getElementById('previewCardAuthor');
        const prevCat = document.getElementById('previewCardCategory');
        const prevPrice = document.getElementById('previewCardPrice');
        const prevCoverTitle = document.getElementById('previewCoverTitle');
        const prevCoverAuthor = document.getElementById('previewCoverAuthor');
        const prevCover = document.getElementById('previewBookCover');

        if (!titleInput || !prevTitle) return;

        function updatePreview() {
            const title = titleInput.value || 'Book Title';
            const author = authorInput ? authorInput.value || 'Author Name' : 'Author Name';
            const cat = catInput ? catInput.value || 'General' : 'General';
            const price = priceInput ? parseFloat(priceInput.value || '0').toFixed(2) : '0.00';

            prevTitle.textContent = title;
            if (prevAuthor) prevAuthor.textContent = `By ${author}`;
            if (prevCat) prevCat.textContent = cat;
            if (prevPrice) prevPrice.textContent = `₹${price}`;
            if (prevCoverTitle) prevCoverTitle.textContent = title;
            if (prevCoverAuthor) prevCoverAuthor.textContent = author;

            if (prevCover) {
                const hash = hashString(title + author);
                const palette = COVER_GRADIENTS[hash % COVER_GRADIENTS.length];
                prevCover.style.background = `linear-gradient(135deg, ${palette[0]} 0%, ${palette[1]} 100%)`;
            }
        }

        titleInput.addEventListener('input', updatePreview);
        if (authorInput) authorInput.addEventListener('input', updatePreview);
        if (catInput) catInput.addEventListener('input', updatePreview);
        if (priceInput) priceInput.addEventListener('input', updatePreview);

        updatePreview();
    }

    // ==========================================
    // 10. ADMIN TABLE FILTER
    // ==========================================
    function initTableFilters() {
        const filterInput = document.getElementById('adminTableSearch');
        if (!filterInput) return;

        const table = document.querySelector('.data-table');
        if (!table) return;

        const rows = table.querySelectorAll('tbody tr');

        filterInput.addEventListener('input', () => {
            const query = filterInput.value.toLowerCase().trim();
            rows.forEach(row => {
                const text = row.textContent.toLowerCase();
                row.style.display = text.includes(query) ? '' : 'none';
            });
        });
    }

    // ==========================================
    // 11. MOBILE DRAWER NAVIGATION
    // ==========================================
    function initMobileNav() {
        const toggleBtn = document.getElementById('mobileNavToggle');
        const mobileDrawer = document.getElementById('mobileNavDrawer');
        const overlay = document.getElementById('mobileNavOverlay');

        if (toggleBtn && mobileDrawer) {
            toggleBtn.addEventListener('click', () => {
                mobileDrawer.classList.toggle('active');
                if (overlay) overlay.classList.toggle('active');
                document.body.style.overflow = mobileDrawer.classList.contains('active') ? 'hidden' : '';
            });

            if (overlay) {
                overlay.addEventListener('click', () => {
                    mobileDrawer.classList.remove('active');
                    overlay.classList.remove('active');
                    document.body.style.overflow = '';
                });
            }
        }
    }

    // ==========================================
    // 11. AUTOMATED 3D BOOK SPLASH MOTION GRAPHIC
    // ==========================================
    function initBookSplashAnimation() {
        const overlay = document.getElementById('bookIntroSplash');
        const splashBook = document.getElementById('splashBook');
        const heroBook = document.getElementById('heroInteractiveBook');

        if (!overlay || !splashBook) return;

        let audioCtx = null;

        // Realistic Page Rustle Synthesis via HTML5 Web Audio API
        function playRustle(intensity = 0.12, duration = 0.12) {
            try {
                const AudioContextClass = window.AudioContext || window.webkitAudioContext;
                if (!AudioContextClass) return;
                if (!audioCtx) audioCtx = new AudioContextClass();
                if (audioCtx.state === 'suspended') audioCtx.resume();

                const bufferSize = audioCtx.sampleRate * duration;
                const buffer = audioCtx.createBuffer(1, bufferSize, audioCtx.sampleRate);
                const data = buffer.getChannelData(0);
                for (let i = 0; i < bufferSize; i++) {
                    data[i] = (Math.random() * 2 - 1) * Math.exp(-i / (bufferSize * 0.35));
                }

                const noise = audioCtx.createBufferSource();
                noise.buffer = buffer;

                const filter = audioCtx.createBiquadFilter();
                filter.type = 'bandpass';
                filter.frequency.setValueAtTime(1300, audioCtx.currentTime);
                filter.Q.setValueAtTime(1.4, audioCtx.currentTime);

                const gainNode = audioCtx.createGain();
                gainNode.gain.setValueAtTime(intensity, audioCtx.currentTime);
                gainNode.gain.exponentialRampToValueAtTime(0.001, audioCtx.currentTime + duration);

                noise.connect(filter);
                filter.connect(gainNode);
                gainNode.connect(audioCtx.destination);
                noise.start();
            } catch (e) {}
        }

        function runAnimation() {
            overlay.classList.remove('hidden');
            overlay.classList.remove('splash-fade-out');
            splashBook.classList.remove('book-opened');
            document.body.style.overflow = 'hidden';

            // 1. Smooth open
            setTimeout(() => {
                splashBook.classList.add('book-opened');
                playRustle(0.14, 0.15);
                setTimeout(() => playRustle(0.09, 0.1), 220);
                setTimeout(() => playRustle(0.08, 0.1), 380);
            }, 300);

            // 2. Smooth close
            setTimeout(() => {
                splashBook.classList.remove('book-opened');
                playRustle(0.12, 0.14);
            }, 1400);

            // 3. Fade out & reveal home page automatically
            setTimeout(() => {
                overlay.classList.add('splash-fade-out');
                document.body.style.overflow = '';
                try {
                    sessionStorage.setItem('bookstore_splash_seen', 'true');
                } catch (e) {}
            }, 1900);

            // 4. Fully hide
            setTimeout(() => {
                overlay.classList.add('hidden');
            }, 2500);
        }

        // If user clicks anywhere on splash during animation, dissolve immediately
        overlay.addEventListener('click', () => {
            overlay.classList.add('splash-fade-out');
            document.body.style.overflow = '';
            try {
                sessionStorage.setItem('bookstore_splash_seen', 'true');
            } catch (e) {}
            setTimeout(() => overlay.classList.add('hidden'), 650);
        });

        // Hero book replay trigger (if clicked on catalog page)
        if (heroBook) {
            heroBook.addEventListener('click', (e) => {
                e.preventDefault();
                runAnimation();
            });
        }

        // Check session storage so it doesn't replay on every single internal click
        const hasSeenSplash = sessionStorage.getItem('bookstore_splash_seen');
        if (!hasSeenSplash) {
            runAnimation();
        } else {
            overlay.classList.add('hidden');
        }
    }

    // ==========================================
    // INITIALIZATION
    // ==========================================
    document.addEventListener('DOMContentLoaded', () => {
        initTheme();
        checkUrlAlerts();
        initProceduralCovers();
        initCatalogFilters();
        initQuantitySteppers();
        initCartDynamics();
        initDemoCredentials();
        initAdminLivePreview();
        initTableFilters();
        initMobileNav();
        initBookSplashAnimation();
    });

})();

