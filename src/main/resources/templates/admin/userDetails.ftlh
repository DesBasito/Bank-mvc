<#include "../layouts/adminLayout.ftlh">
<@adminLayout>
    <link rel="stylesheet" href="/css/profile.css">
    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="fas fa-user me-2"></i>User Details</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/users">Users</a></li>
                    <li class="breadcrumb-item active">${user.fullName}</li>
                </ol>
            </nav>
        </div>
        <button class="btn btn-outline-secondary" onclick="logout()">
            <i class="fas fa-sign-out-alt me-1"></i>Logout
        </button>
    </div>

    <!-- User Profile Section -->
    <div class="row mb-4">
        <!-- User Info Card -->
        <div class="col-md-6 mx-auto">
            <div class="card border-0 shadow-sm h-100">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-user me-2"></i>Profile Information
                    </h5>
                </div>
                <div class="card-body">
                    <div class="text-center mb-4">
                        <div class="bg-primary text-white rounded-circle d-inline-flex align-items-center justify-content-center"
                             style="width: 80px; height: 80px; font-size: 24px;">
                            ${user.firstName?substring(0,1)}${user.lastName?substring(0,1)}
                        </div>
                        <h4 class="mt-3 mb-1">${user.fullName}</h4>
                        <span class="badge ${user.enabled?then('bg-success', 'bg-danger')} fs-6">
                            <i class="fas ${user.enabled?then('fa-check-circle', 'fa-ban')} me-1"></i>
                            ${user.enabled?then('Active', 'Blocked')}
                        </span>
                    </div>

                    <div class="row">
                        <div class="col-6 mb-3">
                            <label class="text-muted small">User ID</label>
                            <div class="fw-bold">${user.id}</div>
                        </div>
                        <div class="col-6 mb-3">
                            <label class="text-muted small">Phone</label>
                            <div class="fw-bold">${user.phoneNumber!""}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Quick Stats -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card info-card">
                <div class="card-body text-center">
                    <i class="fas fa-credit-card fa-2x text-primary mb-2"></i>
                    <h5 class="card-title">Total Cards</h5>
                    <h3 class="text-primary">${user.cards?size}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card info-card">
                <div class="card-body text-center">
                    <i class="fas fa-dollar-sign fa-2x text-success mb-2"></i>
                    <h5 class="card-title">Total Balance</h5>
                    <h3 class="text-success">${totalBalance?string.currency}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card info-card">
                <div class="card-body text-center">
                    <i class="fas fa-check-circle fa-2x text-info mb-2"></i>
                    <h5 class="card-title">Active Cards</h5>
                    <h3 class="text-info">${activeCards?size}</h3>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card info-card">
                <div class="card-body text-center">
                    <i class="fas fa-exchange-alt fa-2x text-warning mb-2"></i>
                    <h5 class="card-title">This Month</h5>
                    <h3 class="text-warning">${monthlyTransactions}</h3>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters and Sorting -->
    <div class="filter-section">
        <div class="row">
            <div class="col-md-3">
                <label class="form-label fw-bold">Filter by Status</label>
                <select class="form-select" id="statusFilter" onchange="filterCards()">
                    <option value="">All Status</option>
                    <option value="ACTIVE">Active</option>
                    <option value="BLOCKED">Blocked</option>
                    <option value="EXPIRED">Expired</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold">Filter by Type</label>
                <select class="form-select" id="typeFilter" onchange="filterCards()">
                    <option value="">All Types</option>
                    <option value="DEBIT">Debit</option>
                    <option value="CREDIT">Credit</option>
                    <option value="VIRTUAL">Virtual</option>
                    <option value="PREPAID">Prepaid</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold">Sort by</label>
                <select class="form-select" id="sortBy" onchange="sortCards()">
                    <option value="created_desc">Date Created (Newest)</option>
                    <option value="created_asc">Date Created (Oldest)</option>
                    <option value="balance_desc">Balance (High to Low)</option>
                    <option value="balance_asc">Balance (Low to High)</option>
                    <option value="type">Card Type</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-bold">Search</label>
                <input type="text" class="form-control" id="searchCards" placeholder="Search card number..."
                       onkeyup="searchCards()">
            </div>
        </div>
    </div>

    <!-- Cards Grid -->
    <div class="row" id="cardsContainer">
        <#if cards?? && (cards?size > 0)>
            <#list cards as card>
                <div class="col-md-6 col-lg-4 mb-4 card-item"
                     data-status="${card.status}"
                     data-type="${card.type}"
                     data-balance="${card.balance?c}"
                     data-created="${card.createdAt}">
                    <div class="card h-100">
                        <div class="card-visual position-relative">
                            <div class="d-flex justify-content-between align-items-start mb-3">
                                <div>
                                    <small class="opacity-75">${card.type} CARD</small>
                                    <div class="card-number">${card.cardNumber}</div>
                                </div>
                                <#if card.status == 'ACTIVE'>
                                    <span class="badge bg-success status-badge">ACTIVE</span>
                                <#elseif card.status == 'BLOCKED'>
                                    <span class="badge bg-danger status-badge">BLOCKED</span>
                                <#elseif card.status == 'EXPIRED'>
                                    <span class="badge bg-warning status-badge">EXPIRED</span>
                                </#if>
                            </div>
                            <div class="d-flex justify-content-between align-items-end">
                                <div>
                                    <small class="opacity-75"><#if card.type == 'CREDIT'>Available<#else>Balance</#if></small>
                                    <div class="card-balance">
                                        $<#if card.balance??>${card.balance?string("#,##0.00")}<#else>0.00</#if></div>
                                </div>
                                <div class="text-end">
                                    <small class="opacity-75">Expires</small>
                                    <div><#if card.expiryDate??>${card.expiryDate}<#else>--/--</#if></div>
                                </div>
                            </div>
                        </div>
                        <div class="card-body">
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <span class="text-muted">Created: <#if card.createdAt??>${card.createdAt}<#else>Unknown</#if></span>
                                <#if card.type == 'VIRTUAL'>
                                    <span class="badge bg-secondary">VIRTUAL</span>
                                <#else>
                                    <i class="fab fa-cc-visa fa-lg text-primary"></i>
                                </#if>
                            </div>
                            <div class="btn-group w-100" role="group">
                                <a class="btn btn-outline-info btn-sm" href="/cards/${card.id}">
                                    <i class="fas fa-eye me-1"></i>Details
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
            </#list>
        </#if>
    </div>

    <!-- No Cards Found Message -->
    <div class="row" id="noCardsMessage" <#if cards?? && (cards?size > 0)>style="display: none;"</#if>>
        <div class="col-12">
            <div class="text-center py-5">
                <i class="fas fa-credit-card fa-4x text-muted mb-3"></i>
                <h4 class="text-muted">No cards found</h4>
                <p class="text-muted">Try adjusting your filters or apply for a new card.</p>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        let currentBlockCardId = null;

        function filterCards() {
            const statusFilter = document.getElementById('statusFilter').value;
            const typeFilter = document.getElementById('typeFilter').value;
            const searchTerm = document.getElementById('searchCards').value.toLowerCase();

            const cards = document.querySelectorAll('.card-item');
            let visibleCount = 0;

            cards.forEach(card => {
                const cardStatus = card.dataset.status;
                const cardType = card.dataset.type;
                const cardNumber = card.querySelector('.card-number').textContent.toLowerCase();

                const statusMatch = !statusFilter || cardStatus === statusFilter;
                const typeMatch = !typeFilter || cardType === typeFilter;
                const searchMatch = !searchTerm || cardNumber.includes(searchTerm);

                if (statusMatch && typeMatch && searchMatch) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            document.getElementById('noCardsMessage').style.display = visibleCount === 0 ? 'block' : 'none';
        }

        function searchCards() {
            filterCards();
        }

        function sortCards() {
            const sortBy = document.getElementById('sortBy').value;
            const container = document.getElementById('cardsContainer');
            const cards = Array.from(document.querySelectorAll('.card-item'));

            cards.sort((a, b) => {
                switch (sortBy) {
                    case 'created_desc':
                        return new Date(b.dataset.created) - new Date(a.dataset.created);
                    case 'created_asc':
                        return new Date(a.dataset.created) - new Date(b.dataset.created);
                    case 'balance_desc':
                        return parseFloat(b.dataset.balance) - parseFloat(a.dataset.balance);
                    case 'balance_asc':
                        return parseFloat(a.dataset.balance) - parseFloat(b.dataset.balance);
                    case 'type':
                        return a.dataset.type.localeCompare(b.dataset.type);
                    default:
                        return 0;
                }
            });

            cards.forEach(card => container.appendChild(card));
        }
    </script>
</@adminLayout>