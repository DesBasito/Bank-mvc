<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Transactions</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/adminTransaction.css">
</head>
<body>
<div class="container-fluid">
    <div class="row">
        <!-- Sidebar -->
        <div class="col-md-2 sidebar text-white p-3">
            <h4 class="mb-4">
                <i class="fas fa-university"></i> Bank Admin
            </h4>
            <nav class="nav flex-column">
                <a class="nav-link text-white" href="/admin/cards"><i class="fas fa-credit-card me-2"></i>Cards</a>
                <a class="nav-link text-white" href="/admin/applications"><i class="fas fa-file-alt me-2"></i>Applications</a>
                <a class="nav-link text-white active" href="/admin/transactions"><i class="fas fa-exchange-alt me-2"></i>Transactions</a>
                <a class="nav-link text-white" href="/admin/users"><i class="fas fa-users me-2"></i>Users</a>
                <a class="nav-link text-white" href="/admin/reports"><i class="fas fa-chart-bar me-2"></i>Reports</a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-exchange-alt me-2"></i>Transactions Management</h2>
                <button class="btn btn-outline-secondary" onclick="logout()">
                    <i class="fas fa-sign-out-alt me-1"></i>Logout
                </button>
            </div>

            <!-- Statistics Cards -->
            <div class="row mb-4">
                <div class="col-md-3">
                    <div class="card stats-card border-primary">
                        <div class="card-body text-center">
                            <i class="fas fa-chart-line fa-2x text-primary mb-2"></i>
                            <h5 class="card-title">Total Transactions</h5>
                            <h3 class="text-primary" id="totalTransactions">1,234</h3>
                            <small class="text-muted">All time</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stats-card border-success">
                        <div class="card-body text-center">
                            <i class="fas fa-dollar-sign fa-2x text-success mb-2"></i>
                            <h5 class="card-title">Total Volume</h5>
                            <h3 class="text-success" id="totalVolume">$2.5M</h3>
                            <small class="text-muted">All time</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stats-card border-warning">
                        <div class="card-body text-center">
                            <i class="fas fa-clock fa-2x text-warning mb-2"></i>
                            <h5 class="card-title">Today's Transactions</h5>
                            <h3 class="text-warning" id="todayTransactions">89</h3>
                            <small class="text-muted">Last 24 hours</small>
                        </div>
                    </div>
                </div>
                <div class="col-md-3">
                    <div class="card stats-card border-info">
                        <div class="card-body text-center">
                            <i class="fas fa-chart-bar fa-2x text-info mb-2"></i>
                            <h5 class="card-title">Average Amount</h5>
                            <h3 class="text-info" id="avgAmount">$156</h3>
                            <small class="text-muted">Per transaction</small>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row">
                    <div class="col-md-2">
                        <label class="form-label fw-bold">Status</label>
                        <select class="form-select" id="statusFilter" onchange="filterTransactions()">
                            <option value="">All Statuses</option>
                            <option value="SUCCESS">Success</option>
                            <option value="PENDING">Pending</option>
                            <option value="FAILED">Failed</option>
                            <option value="CANCELLED">Cancelled</option>
                            <option value="REFUNDED">Refunded</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">Date Range</label>
                        <select class="form-select" id="dateFilter" onchange="filterTransactions()">
                            <option value="">All Time</option>
                            <option value="today">Today</option>
                            <option value="week">This Week</option>
                            <option value="month">This Month</option>
                            <option value="quarter">This Quarter</option>
                        </select>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">Amount Range</label>
                        <select class="form-select" id="amountFilter" onchange="filterTransactions()">
                            <option value="">All Amounts</option>
                            <option value="0-100">$0 - $100</option>
                            <option value="100-500">$100 - $500</option>
                            <option value="500-1000">$500 - $1,000</option>
                            <option value="1000+">$1,000+</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Search</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                            <input type="text" class="form-control" id="searchInput"
                                   placeholder="Card number, user..." onkeyup="filterTransactions()">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">Actions</label>
                        <div class="d-flex gap-1">
                            <button class="btn btn-primary flex-fill" onclick="filterTransactions()">
                                <i class="fas fa-filter"></i>
                            </button>
                            <button class="btn btn-outline-secondary flex-fill" onclick="clearFilters()">
                                <i class="fas fa-times"></i>
                            </button>
                        </div>
                    </div>
                    <div class="col-md-1">
                        <label class="form-label fw-bold">Export</label>
                        <button class="btn btn-success w-100" onclick="exportTransactions()" title="Export to CSV">
                            <i class="fas fa-download"></i>
                        </button>
                    </div>
                </div>
            </div>

            <!-- Transactions Table -->
            <div class="card">
                <div class="card-header d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Transactions List</h5>
                    <span class="badge bg-info" id="transactionsCount">Total: 0 transactions</span>
                </div>
                <div class="card-body p-0">
                    <div class="table-responsive">
                        <table class="table table-hover mb-0">
                            <thead class="table-dark">
                            <tr>
                                <th>ID</th>
                                <th>Date & Time</th>
                                <th>From Card</th>
                                <th>To Card</th>
                                <th>Amount</th>
                                <th>Description</th>
                                <th>Status</th>
                                <th>Actions</th>
                            </tr>
                            </thead>
                            <tbody id="transactionsTableBody">
                            <!-- Dynamic content will be loaded here -->
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <nav aria-label="Transactions pagination" class="mt-3">
                <ul class="pagination justify-content-center" id="pagination">
                    <!-- Pagination will be generated dynamically -->
                </ul>
            </nav>
        </div>
    </div>
</div>

<!-- Transaction Details Modal -->
<div class="modal fade" id="transactionModal" tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">Transaction Details</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="transactionDetails">
                    <!-- Transaction details will be loaded here -->
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary" onclick="generateTransactionReport()" id="reportBtn">
                    <i class="fas fa-file-pdf me-1"></i>Generate Report
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    // Sample transactions data
    let allTransactions = [
        {
            id: 1001,
            fromCardId: 1,
            fromCardNumber: "4111111111111111",
            fromCardOwner: "John Doe",
            toCardId: 2,
            toCardNumber: "4222222222222222",
            toCardOwner: "Jane Smith",
            amount: 500.00,
            description: "Transfer to friend",
            status: "SUCCESS",
            createdAt: "2024-09-20T14:30:00Z",
            processedAt: "2024-09-20T14:30:05Z",
            errorMessage: null
        },
        {
            id: 1002,
            fromCardId: 2,
            fromCardNumber: "4222222222222222",
            fromCardOwner: "Jane Smith",
            toCardId: 1,
            toCardNumber: "4111111111111111",
            toCardOwner: "John Doe",
            amount: 200.00,
            description: "Return payment",
            status: "SUCCESS",
            createdAt: "2024-09-20T10:15:00Z",
            processedAt: "2024-09-20T10:15:03Z",
            errorMessage: null
        },
        {
            id: 1003,
            fromCardId: 3,
            fromCardNumber: "4333333333333333",
            fromCardOwner: "Bob Johnson",
            toCardId: 1,
            toCardNumber: "4111111111111111",
            toCardOwner: "John Doe",
            amount: 1500.00,
            description: "Business payment",
            status: "PENDING",
            createdAt: "2024-09-20T16:45:00Z",
            processedAt: null,
            errorMessage: null
        },
        {
            id: 1004,
            fromCardId: 1,
            fromCardNumber: "4111111111111111",
            fromCardOwner: "John Doe",
            toCardId: 4,
            toCardNumber: "4444444444444444",
            toCardOwner: "Alice Brown",
            amount: 750.00,
            description: "Service payment",
            status: "FAILED",
            createdAt: "2024-09-19T11:20:00Z",
            processedAt: "2024-09-19T11:20:02Z",
            errorMessage: "Insufficient funds"
        }
    ];

    let filteredTransactions = [...allTransactions];
    let currentPage = 1;
    const transactionsPerPage = 10;
    let selectedTransaction = null;

    function maskCardNumber(cardNumber) {
        return cardNumber.replace(/(\d{4})(\d{4})(\d{4})(\d{4})/, '**** **** **** $4');
    }

    function formatCurrency(amount) {
        return new Intl.NumberFormat('en-US', {
            style: 'currency',
            currency: 'USD'
        }).format(amount);
    }

    function formatDateTime(dateString) {
        return new Date(dateString).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
    }

    function getStatusBadgeClass(status) {
        switch(status) {
            case 'SUCCESS': return 'bg-success';
            case 'PENDING': return 'bg-warning';
            case 'FAILED': return 'bg-danger';
            case 'CANCELLED': return 'bg-secondary';
            case 'REFUNDED': return 'bg-info';
            default: return 'bg-secondary';
        }
    }

    function getStatusIcon(status) {
        switch(status) {
            case 'SUCCESS': return 'fas fa-check-circle';
            case 'PENDING': return 'fas fa-clock';
            case 'FAILED': return 'fas fa-times-circle';
            case 'CANCELLED': return 'fas fa-ban';
            case 'REFUNDED': return 'fas fa-undo';
            default: return 'fas fa-question-circle';
        }
    }

    function renderTransactions() {
        const tableBody = document.getElementById('transactionsTableBody');
        const startIndex = (currentPage - 1) * transactionsPerPage;
        const endIndex = startIndex + transactionsPerPage;
        const transactionsToShow = filteredTransactions.slice(startIndex, endIndex);

        tableBody.innerHTML = '';

        if (transactionsToShow.length === 0) {
            tableBody.innerHTML = `
                    <tr>
                        <td colspan="8" class="text-center p-4">
                            <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No transactions found</h5>
                            <p class="text-muted">Try adjusting your filters</p>
                        </td>
                    </tr>
                `;
            return;
        }

        transactionsToShow.forEach(transaction => {
            const row = document.createElement('tr');
            row.className = 'transaction-item';
            row.innerHTML = `
                    <td class="fw-bold">#${transaction.id}</td>
                    <td>
                        <div>${formatDateTime(transaction.createdAt)}</div>
                        ${transaction.processedAt ?
                `<small class="text-muted">Processed: ${formatDateTime(transaction.processedAt)}</small>` :
                '<small class="text-muted">Not processed yet</small>'
            }
                    </td>
                    <td>
                        <div class="card-number">${maskCardNumber(transaction.fromCardNumber)}</div>
                        <small class="text-muted">${transaction.fromCardOwner}</small>
                    </td>
                    <td>
                        <div class="card-number">${maskCardNumber(transaction.toCardNumber)}</div>
                        <small class="text-muted">${transaction.toCardOwner}</small>
                    </td>
                    <td class="amount-positive">${formatCurrency(transaction.amount)}</td>
                    <td>
                        <div class="text-truncate" style="max-width: 150px;" title="${transaction.description}">
                            ${transaction.description || 'No description'}
                        </div>
                    </td>
                    <td>
                        <span class="badge status-badge ${getStatusBadgeClass(transaction.status)}">
                            <i class="${getStatusIcon(transaction.status)} me-1"></i>
                            ${transaction.status}
                        </span>
                    </td>
                    <td>
                        <div class="btn-group" role="group">
                            <button class="btn btn-sm btn-outline-primary" onclick="viewTransactionDetails(${transaction.id})" title="View Details">
                                <i class="fas fa-eye"></i>
                            </button>
                            ${transaction.status === 'PENDING' ? `
                                <button class="btn btn-sm btn-outline-success" onclick="approveTransaction(${transaction.id})" title="Approve">
                                    <i class="fas fa-check"></i>
                                </button>
                                <button class="btn btn-sm btn-outline-danger" onclick="cancelTransaction(${transaction.id})" title="Cancel">
                                    <i class="fas fa-times"></i>
                                </button>
                            ` : ''}
                            ${transaction.status === 'SUCCESS' ? `
                                <button class="btn btn-sm btn-outline-warning" onclick="refundTransaction(${transaction.id})" title="Refund">
                                    <i class="fas fa-undo"></i>
                                </button>
                            ` : ''}
                        </div>
                    </td>
                `;
            tableBody.appendChild(row);
        });

        updateTransactionsCount();
        renderPagination();
    }

    function updateTransactionsCount() {
        document.getElementById('transactionsCount').textContent = `Total: ${filteredTransactions.length} transactions`;
    }

    function renderPagination() {
        const pagination = document.getElementById('pagination');
        const totalPages = Math.ceil(filteredTransactions.length / transactionsPerPage);

        pagination.innerHTML = '';

        if (totalPages <= 1) return;

        // Previous button
        pagination.innerHTML += `
                <li class="page-item ${currentPage === 1 ? 'disabled' : ''}">
                    <a class="page-link" href="#" onclick="changePage(${currentPage - 1})">Previous</a>
                </li>
            `;

        // Page numbers
        for (let i = 1; i <= totalPages; i++) {
            if (i === 1 || i === totalPages || (i >= currentPage - 2 && i <= currentPage + 2)) {
                pagination.innerHTML += `
                        <li class="page-item ${currentPage === i ? 'active' : ''}">
                            <a class="page-link" href="#" onclick="changePage(${i})">${i}</a>
                        </li>
                    `;
            } else if (i === currentPage - 3 || i === currentPage + 3) {
                pagination.innerHTML += `<li class="page-item disabled"><span class="page-link">...</span></li>`;
            }
        }

        // Next button
        pagination.innerHTML += `
                <li class="page-item ${currentPage === totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="#" onclick="changePage(${currentPage + 1})">Next</a>
                </li>
            `;
    }

    function changePage(page) {
        const totalPages = Math.ceil(filteredTransactions.length / transactionsPerPage);
        if (page >= 1 && page <= totalPages) {
            currentPage = page;
            renderTransactions();
        }
    }

    function filterTransactions() {
        const statusFilter = document.getElementById('statusFilter').value;
        const dateFilter = document.getElementById('dateFilter').value;
        const amountFilter = document.getElementById('amountFilter').value;
        const searchTerm = document.getElementById('searchInput').value.toLowerCase();

        filteredTransactions = allTransactions.filter(transaction => {
            const matchesStatus = !statusFilter || transaction.status === statusFilter;
            const matchesDate = !dateFilter || filterByDate(transaction.createdAt, dateFilter);
            const matchesAmount = !amountFilter || filterByAmount(transaction.amount, amountFilter);
            const matchesSearch = !searchTerm ||
                transaction.fromCardNumber.includes(searchTerm) ||
                transaction.toCardNumber.includes(searchTerm) ||
                transaction.fromCardOwner.toLowerCase().includes(searchTerm) ||
                transaction.toCardOwner.toLowerCase().includes(searchTerm) ||
                transaction.description.toLowerCase().includes(searchTerm);

            return matchesStatus && matchesDate && matchesAmount && matchesSearch;
        });

        currentPage = 1;
        renderTransactions();
        updateStats();
    }

    function filterByDate(dateString, filter) {
        const transactionDate = new Date(dateString);
        const now = new Date();

        switch(filter) {
            case 'today':
                return transactionDate.toDateString() === now.toDateString();
            case 'week':
                const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
                return transactionDate >= weekAgo;
            case 'month':
                const monthAgo = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate());
                return transactionDate >= monthAgo;
            case 'quarter':
                const quarterAgo = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
                return transactionDate >= quarterAgo;
            default:
                return true;
        }
    }

    function filterByAmount(amount, filter) {
        switch(filter) {
            case '0-100':
                return amount >= 0 && amount <= 100;
            case '100-500':
                return amount > 100 && amount <= 500;
            case '500-1000':
                return amount > 500 && amount <= 1000;
            case '1000+':
                return amount > 1000;
            default:
                return true;
        }
    }

    function clearFilters() {
        document.getElementById('statusFilter').value = '';
        document.getElementById('dateFilter').value = '';
        document.getElementById('amountFilter').value = '';
        document.getElementById('searchInput').value = '';
        filteredTransactions = [...allTransactions];
        currentPage = 1;
        renderTransactions();
        updateStats();
    }

    function updateStats() {
        // Update statistics based on filtered data
        const total = filteredTransactions.length;
        const totalVolume = filteredTransactions.reduce((sum, t) => sum + t.amount, 0);
        const avgAmount = total > 0 ? totalVolume / total : 0;

        const today = new Date().toDateString();
        const todayCount = filteredTransactions.filter(t =>
            new Date(t.createdAt).toDateString() === today
        ).length;

        document.getElementById('totalTransactions').textContent = total.toLocaleString();
        document.getElementById('totalVolume').textContent = formatCurrency(totalVolume);
        document.getElementById('todayTransactions').textContent = todayCount.toString();
        document.getElementById('avgAmount').textContent = formatCurrency(avgAmount);
    }

    function viewTransactionDetails(transactionId) {
        selectedTransaction = allTransactions.find(t => t.id === transactionId);
        if (!selectedTransaction) return;

        const detailsContainer = document.getElementById('transactionDetails');
        detailsContainer.innerHTML = `
                <div class="row">
                    <div class="col-md-6">
                        <div class="card h-100">
                            <div class="card-header">
                                <h6 class="mb-0"><i class="fas fa-info-circle me-2"></i>Transaction Information</h6>
                            </div>
                            <div class="card-body">
                                <div class="row mb-2">
                                    <div class="col-4"><strong>ID:</strong></div>
                                    <div class="col-8">#${selectedTransaction.id}</div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-4"><strong>Amount:</strong></div>
                                    <div class="col-8 fw-bold text-success">${formatCurrency(selectedTransaction.amount)}</div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-4"><strong>Status:</strong></div>
                                    <div class="col-8">
                                        <span class="badge ${getStatusBadgeClass(selectedTransaction.status)}">
                                            <i class="${getStatusIcon(selectedTransaction.status)} me-1"></i>
                                            ${selectedTransaction.status}
                                        </span>
                                    </div>
                                </div>
                                <div class="row mb-2">
                                    <div class="col-4"><strong>Created:</strong></div>
                                    <div class="col-8">${formatDateTime(selectedTransaction.createdAt)}</div>
                                </div>
                                ${selectedTransaction.processedAt ? `
                                    <div class="row mb-2">
                                        <div class="col-4"><strong>Processed:</strong></div>
                                        <div class="col-8">${formatDateTime(selectedTransaction.processedAt)}</div>
                                    </div>
                                ` : ''}
                                ${selectedTransaction.errorMessage ? `
                                    <div class="row mb-2">
                                        <div class="col-4"><strong>Error:</strong></div>
                                        <div class="col-8 text-danger">${selectedTransaction.errorMessage}</div>
                                    </div>
                                ` : ''}
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="card h-100">
                            <div class="card-header">
                                <h6 class="mb-0"><i class="fas fa-exchange-alt me-2"></i>Transfer Details</h6>
                            </div>
                            <div class="card-body">
                                <div class="mb-3">
                                    <h6 class="text-muted">From Card</h6>
                                    <div class="card-number">${maskCardNumber(selectedTransaction.fromCardNumber)}</div>
                                    <small class="text-muted">${selectedTransaction.fromCardOwner}</small>
                                </div>
                                <div class="text-center mb-3">
                                    <i class="fas fa-arrow-down fa-2x text-primary"></i>
                                </div>
                                <div class="mb-3">
                                    <h6 class="text-muted">To Card</h6>
                                    <div class="card-number">${maskCardNumber(selectedTransaction.toCardNumber)}</div>
                                    <small class="text-muted">${selectedTransaction.toCardOwner}</small>
                                </div>
                                <div class="mt-3">
                                    <h6 class="text-muted">Description</h6>
                                    <p class="mb-0">${selectedTransaction.description || 'No description provided'}</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            `;

        const modal = new bootstrap.Modal(document.getElementById('transactionModal'));
        modal.show();
    }

    function approveTransaction(transactionId) {
        if (confirm('Are you sure you want to approve this transaction?')) {
            const transaction = allTransactions.find(t => t.id === transactionId);
            if (transaction) {
                transaction.status = 'SUCCESS';
                transaction.processedAt = new Date().toISOString();
                renderTransactions();
                showNotification('Transaction approved successfully', 'success');
            }
        }
    }

    function cancelTransaction(transactionId) {
        if (confirm('Are you sure you want to cancel this transaction?')) {
            const transaction = allTransactions.find(t => t.id === transactionId);
            if (transaction) {
                transaction.status = 'CANCELLED';
                transaction.processedAt = new Date().toISOString();
                renderTransactions();
                showNotification('Transaction cancelled successfully', 'warning');
            }
        }
    }

    function refundTransaction(transactionId) {
        if (confirm('Are you sure you want to refund this transaction?')) {
            const transaction = allTransactions.find(t => t.id === transactionId);
            if (transaction) {
                transaction.status = 'REFUNDED';
                renderTransactions();
                showNotification('Transaction refunded successfully', 'info');
            }
        }
    }

    function generateTransactionReport() {
        if (selectedTransaction) {
            alert(`Generating detailed report for transaction #${selectedTransaction.id}`);
            // Implement report generation logic here
        }
    }

    function exportTransactions() {
        // Simple CSV export functionality
        let csv = 'ID,Date,From Card,From Owner,To Card,To Owner,Amount,Description,Status\n';

        filteredTransactions.forEach(transaction => {
            csv += `${transaction.id},`;
            csv += `"${formatDateTime(transaction.createdAt)}",`;
            csv += `"${maskCardNumber(transaction.fromCardNumber)}",`;
            csv += `"${transaction.fromCardOwner}",`;
            csv += `"${maskCardNumber(transaction.toCardNumber)}",`;
            csv += `"${transaction.toCardOwner}",`;
            csv += `${transaction.amount},`;
            csv += `"${transaction.description || ''}",`;
            csv += `${transaction.status}\n`;
        });

        const blob = new Blob([csv], { type: 'text/csv' });
        const url = window.URL.createObjectURL(blob);
        const a = document.createElement('a');
        a.setAttribute('hidden', '');
        a.setAttribute('href', url);
        a.setAttribute('download', `transactions_${new Date().toISOString().split('T')[0]}.csv`);
        document.body.appendChild(a);
        a.click();
        document.body.removeChild(a);

        showNotification('Transactions exported successfully', 'success');
    }

    function showNotification(message, type) {
        const notification = document.createElement('div');
        notification.className = `alert alert-${type} alert-dismissible fade show position-fixed`;
        notification.style.top = '20px';
        notification.style.right = '20px';
        notification.style.zIndex = '9999';
        notification.innerHTML = `
                ${message}
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
    document.addEventListener('DOMContentLoaded', function() {
        renderTransactions();
        updateStats();
    });
</script>
</body>
</html>