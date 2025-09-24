<#include "../layouts/adminLayout.ftlh">
<@adminLayout>
    <link rel="stylesheet" href="/css/cardDetails.css">
    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="fas fa-credit-card me-2"></i>Card Details</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/admin/cards">Cards</a></li>
                    <li class="breadcrumb-item active">Details</li>
                </ol>
            </nav>
        </div>
        <button class="btn btn-outline-secondary" onclick="logout()">
            <i class="fas fa-sign-out-alt me-1"></i>Logout
        </button>
    </div>

    <!-- Card Information -->
    <div class="row mb-4">
        <!-- Card Visual -->
        <div class="col-md-4">
            <div class="card-visual text-center position-relative">
                <div class="position-relative">
                    <h6 class="mb-2">BANK CARD</h6>
                    <div class="card-number mb-3" id="cardNumberDisplay">**** **** **** 1234</div>
                    <div class="d-flex justify-content-between align-items-end">
                        <div>
                            <small>VALID THRU</small>
                            <div id="expiryDateDisplay">12/26</div>
                        </div>
                        <div>
                            <i class="fab fa-cc-visa fa-2x"></i>
                        </div>
                    </div>
                    <div class="mt-3">
                        <small>CARD HOLDER</small>
                        <div id="cardHolderDisplay">JOHN DOE</div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Card Info -->
        <div class="col-md-8">
            <div class="row">
                <div class="col-md-6">
                    <div class="card info-card h-100">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="fas fa-info-circle text-primary me-2"></i>Card Information
                            </h5>
                            <div class="row">
                                <div class="col-6">
                                    <small class="text-muted">Card ID</small>
                                    <div class="fw-bold" id="cardId">001</div>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted">Card Type</small>
                                    <div><span class="badge bg-info" id="cardType">DEBIT</span></div>
                                </div>
                                <div class="col-6 mt-3">
                                    <small class="text-muted">Status</small>
                                    <div><span class="badge status-badge bg-success" id="cardStatus">ACTIVE</span></div>
                                </div>
                                <div class="col-6 mt-3">
                                    <small class="text-muted">Created</small>
                                    <div id="createdDate">2024-01-15</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-md-6">
                    <div class="card info-card h-100">
                        <div class="card-body text-center">
                            <h5 class="card-title">
                                <i class="fas fa-wallet text-success me-2"></i>Current Balance
                            </h5>
                            <div class="card-balance text-success" id="cardBalance">$15,000.50</div>
                            <small class="text-muted">Last updated: <span id="lastUpdated">2 hours ago</span></small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Owner Information -->
    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card info-card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-user text-primary me-2"></i>Card Owner
                    </h5>
                </div>
                <div class="card-body">
                    <div class="d-flex align-items-center mb-3">
                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                             style="width: 50px; height: 50px;">
                            <span id="ownerInitials">JD</span>
                        </div>
                        <div>
                            <h6 class="mb-1" id="ownerName">John Doe</h6>
                            <small class="text-muted" id="ownerPhone">+1 (555) 123-4567</small>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-6">
                            <small class="text-muted">User ID</small>
                            <div class="fw-bold" id="ownerId">123</div>
                        </div>
                        <div class="col-6">
                            <small class="text-muted">Status</small>
                            <div><span class="badge bg-success" id="ownerStatus">ACTIVE</span></div>
                        </div>
                    </div>
                    <div class="mt-3">
                        <a href="#" class="btn btn-outline-primary btn-sm" onclick="viewUserDetails()">
                            <i class="fas fa-eye me-1"></i>View User Details
                        </a>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card info-card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-chart-line text-success me-2"></i>Quick Stats
                    </h5>
                </div>
                <div class="card-body">
                    <div class="row text-center">
                        <div class="col-4">
                            <div class="fw-bold text-primary fs-4" id="totalTransactions">156</div>
                            <small class="text-muted">Total Transactions</small>
                        </div>
                        <div class="col-4">
                            <div class="fw-bold text-success fs-4" id="monthlySpent">$2,340</div>
                            <small class="text-muted">This Month</small>
                        </div>
                        <div class="col-4">
                            <div class="fw-bold text-warning fs-4" id="avgTransaction">$89</div>
                            <small class="text-muted">Avg Transaction</small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Recent Transactions -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <i class="fas fa-exchange-alt text-info me-2"></i>Recent Transactions
            </h5>
            <a href="#" class="btn btn-outline-primary btn-sm" onclick="viewAllTransactions()">View All</a>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Date</th>
                        <th>Type</th>
                        <th>Description</th>
                        <th>Amount</th>
                        <th>Status</th>
                    </tr>
                    </thead>
                    <tbody id="transactionsTableBody">
                    <!-- Transactions will be loaded here -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    let cardData = {
        id: 1,
        cardNumber: "4111111111111111",
        ownerName: "John Doe",
        ownerId: 123,
        ownerPhone: "+1 (555) 123-4567",
        type: "DEBIT",
        status: "ACTIVE",
        balance: 15000.50,
        expiryDate: "2026-12-31",
        createdAt: "2024-01-15T10:30:00Z"
    };

    let recentTransactions = [
        {
            id: 1,
            date: "2024-09-20",
            type: "Transfer",
            description: "Transfer to savings",
            amount: -500.00,
            status: "SUCCESS"
        },
        {
            id: 2,
            date: "2024-09-19",
            type: "Deposit",
            description: "Salary deposit",
            amount: 3000.00,
            status: "SUCCESS"
        },
        {
            id: 3,
            date: "2024-09-18",
            type: "Purchase",
            description: "Online shopping",
            amount: -89.99,
            status: "SUCCESS"
        }
    ];


    function formatCurrency(amount) {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(amount);
    }

    function getStatusBadgeClass(status) {
        switch (status) {
            case 'ACTIVE':
                return 'bg-success';
            case 'BLOCKED':
                return 'bg-danger';
            case 'EXPIRED':
                return 'bg-warning';
            default:
                return 'bg-secondary';
        }
    }

    function getTransactionTypeIcon(type) {
        switch (type.toLowerCase()) {
            case 'transfer':
                return 'fas fa-exchange-alt';
            case 'deposit':
                return 'fas fa-arrow-down text-success';
            case 'purchase':
                return 'fas fa-shopping-cart';
            case 'withdrawal':
                return 'fas fa-arrow-up text-danger';
            default:
                return 'fas fa-circle';
        }
    }

    function loadCardDetails() {
        // Update card visual
        document.getElementById('cardNumberDisplay').textContent = cardData.cardNumber;
        document.getElementById('expiryDateDisplay').textContent = new Date(cardData.expiryDate).toLocaleDateString('en-US', {
            month: '2-digit',
            year: '2-digit'
        });
        document.getElementById('cardHolderDisplay').textContent = cardData.ownerName.toUpperCase();

        // Update card information
        document.getElementById('cardId').textContent = cardData.id;
        document.getElementById('cardType').textContent = cardData.type;
        document.getElementById('cardStatus').textContent = cardData.status;
        document.getElementById('cardStatus').className = `badge status-badge `+cardData.status;
        document.getElementById('createdDate').textContent = new Date(cardData.createdAt).toLocaleDateString();
        document.getElementById('cardBalance').textContent = formatCurrency(cardData.balance);

        // Update owner information
        document.getElementById('ownerInitials').textContent = cardData.ownerName.split(' ').map(n => n[0]).join('');
        document.getElementById('ownerName').textContent = cardData.ownerName;
        document.getElementById('ownerPhone').textContent = cardData.ownerPhone;
        document.getElementById('ownerId').textContent = cardData.ownerId;

        // Update action buttons based on status
        updateActionButtons();
    }


    function loadRecentTransactions() {
        const tableBody = document.getElementById('transactionsTableBody');
        tableBody.innerHTML = '';

        recentTransactions.forEach(transaction => {
            const row = document.createElement('tr');
            row.className = 'transaction-item';

            const date = new Date(transaction.date).toLocaleDateString();
            const icon = getTransactionTypeIcon(transaction.type);
            const amountClass = transaction.amount >= 0 ? 'text-success' : 'text-danger';
            const formattedAmount = formatCurrency(Math.abs(transaction.amount));
            const badgeClass = transaction.status === 'SUCCESS' ? 'bg-success' : 'bg-danger';

            row.innerHTML =
                '<td>' + date + '</td>' +
                '<td>' +
                '<i class="' + icon + ' me-2"></i>' +
                transaction.type +
                '</td>' +
                '<td>' + transaction.description + '</td>' +
                '<td class="' + amountClass + '">' +
                formattedAmount +
                '</td>' +
                '<td>' +
                '<span class="badge ' + badgeClass + '">' +
                transaction.status +
                '</span>' +
                '</td>';

            tableBody.appendChild(row);
        });
    }


    function viewUserDetails() {
        window.location.href = `/admin/users/${card.ownerId}`;
    }

    function viewAllTransactions() {
        window.location.href = `/admin/transactions?cardId=${card.id}`;
    }

    function logout() {
        if (confirm('Are you sure you want to logout?')) {
            window.location.href = '/logout';
        }
    }

    // Initialize page
    document.addEventListener('DOMContentLoaded', function () {
        loadCardDetails();
        loadRecentTransactions();
    });
</script>
</@adminLayout>