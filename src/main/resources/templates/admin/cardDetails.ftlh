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

    <!-- Actions -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="card">
                <div class="card-header">
                    <h5 class="mb-0">
                        <i class="fas fa-cogs text-warning me-2"></i>Card Actions
                    </h5>
                </div>
                <div class="card-body">
                    <div class="btn-group me-2" role="group">
                        <button class="btn btn-outline-primary" onclick="editCard()">
                            <i class="fas fa-edit me-1"></i>Edit Card
                        </button>
                        <button class="btn btn-outline-success" onclick="adjustBalance()" id="adjustBalanceBtn">
                            <i class="fas fa-dollar-sign me-1"></i>Adjust Balance
                        </button>
                    </div>
                    <div class="btn-group me-2" role="group">
                        <button class="btn btn-outline-warning" onclick="toggleCardStatus()" id="toggleStatusBtn">
                            <i class="fas fa-lock me-1"></i>Block Card
                        </button>
                        <button class="btn btn-outline-info" onclick="generateReport()">
                            <i class="fas fa-file-alt me-1"></i>Generate Report
                        </button>
                    </div>
                    <div class="btn-group" role="group">
                        <button class="btn btn-outline-danger" onclick="deleteCard()">
                            <i class="fas fa-trash me-1"></i>Delete Card
                        </button>
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
</div>
</div>
</div>

<!-- Balance Adjustment Modal -->
<div class="modal fade" id="balanceModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Adjust Card Balance</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <form id="balanceForm">
                    <div class="mb-3">
                        <label class="form-label">Current Balance</label>
                        <input type="text" class="form-control" id="currentBalance" readonly>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Adjustment Type</label>
                        <select class="form-select" id="adjustmentType">
                            <option value="add">Add Amount</option>
                            <option value="subtract">Subtract Amount</option>
                            <option value="set">Set New Balance</option>
                        </select>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Amount</label>
                        <input type="number" class="form-control" id="adjustmentAmount" step="0.01" min="0" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label">Reason</label>
                        <textarea class="form-control" id="adjustmentReason" rows="3"
                                  placeholder="Reason for balance adjustment..."></textarea>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="submitBalanceAdjustment()">Apply Adjustment
                </button>
            </div>
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

    function maskCardNumber(cardNumber) {
        return cardNumber.replace(/(\d{4})(\d{4})(\d{4})(\d{4})/, '**** **** **** $4');
    }

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
        document.getElementById('cardNumberDisplay').textContent = maskCardNumber(cardData.cardNumber);
        document.getElementById('expiryDateDisplay').textContent = new Date(cardData.expiryDate).toLocaleDateString('en-US', {
            month: '2-digit',
            year: '2-digit'
        });
        document.getElementById('cardHolderDisplay').textContent = cardData.ownerName.toUpperCase();

        // Update card information
        document.getElementById('cardId').textContent = cardData.id;
        document.getElementById('cardType').textContent = cardData.type;
        document.getElementById('cardStatus').textContent = cardData.status;
        document.getElementById('cardStatus').className = `badge status-badge `+cardData.status+;
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

    function updateActionButtons() {
        const toggleBtn = document.getElementById('toggleStatusBtn');
        if (cardData.status === 'BLOCKED') {
            toggleBtn.innerHTML = '<i class="fas fa-unlock me-1"></i>Unblock Card';
            toggleBtn.className = 'btn btn-outline-success';
        } else {
            toggleBtn.innerHTML = '<i class="fas fa-lock me-1"></i>Block Card';
            toggleBtn.className = 'btn btn-outline-warning';
        }
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

    function editCard() {
        alert('Edit card functionality would be implemented here');
    }

    function adjustBalance() {
        document.getElementById('currentBalance').value = formatCurrency(cardData.balance);
        const balanceModal = new bootstrap.Modal(document.getElementById('balanceModal'));
        balanceModal.show();
    }

    function submitBalanceAdjustment() {
        const adjustmentType = document.getElementById('adjustmentType').value;
        const amount = parseFloat(document.getElementById('adjustmentAmount').value);
        const reason = document.getElementById('adjustmentReason').value;

        if (!amount || amount <= 0) {
            showNotification('Please enter a valid amount', 'danger');
            return;
        }

        if (!reason.trim()) {
            showNotification('Please provide a reason for the adjustment', 'danger');
            return;
        }

        // Calculate new balance
        let newBalance = cardData.balance;
        switch (adjustmentType) {
            case 'add':
                newBalance += amount;
                break;
            case 'subtract':
                newBalance -= amount;
                break;
            case 'set':
                newBalance = amount;
                break;
        }

        if (newBalance < 0) {
            showNotification('Balance cannot be negative', 'danger');
            return;
        }

        // Update card balance
        cardData.balance = newBalance;
        document.getElementById('cardBalance').textContent = formatCurrency(newBalance);

        // Close modal
        const balanceModal = bootstrap.Modal.getInstance(document.getElementById('balanceModal'));
        balanceModal.hide();

        showNotification('Balance adjusted successfully', 'success');

        // Reset form
        document.getElementById('balanceForm').reset();
    }

    <#--function toggleCardStatus() {-->
    <#--    const action = cardData.status === 'BLOCKED' ? 'unblock' : 'block';-->
    <#--    const actionText = action === 'block' ? 'block' : 'unblock';-->

    <#--    if (confirm(`Are you sure you want to ${actionText} this card?`)) {-->
    <#--        cardData.status = cardData.status === 'BLOCKED' ? 'ACTIVE' : 'BLOCKED';-->
    <#--        loadCardDetails();-->
    <#--        showNotification(`Card ${actionText}ed successfully`, 'success');-->
    <#--    }-->
    <#--}-->

    // function deleteCard() {
    //     if (confirm('Are you sure you want to delete this card? This action cannot be undone.')) {
    //         if (confirm('This will permanently delete the card and all associated data. Are you absolutely sure?')) {
    //             alert('Card deletion functionality would be implemented here');
    //         }
    //     }
    // }

    function viewUserDetails() {
        window.location.href = `/admin/users/${card.ownerId}`;
    }

    function viewAllTransactions() {
        window.location.href = `/admin/transactions?cardId=${card.id}`;
    }

    function showNotification(message, type) {
        const notification = document.createElement('div');
        notification.className = `alert alert-`+type+` alert-dismissible fade show position-fixed`;
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.zIndex = '9999';
        notification.innerHTML =
                message+`
                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
            `;
        document.body.appendChild(notification);

        setTimeout(() => {
            notification.remove();
        }, 3000);
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