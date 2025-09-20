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