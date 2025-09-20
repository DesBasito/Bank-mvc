<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Applications Management</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/adminApplicationPage.css">
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
                <a class="nav-link text-white active" href="/admin/applications"><i class="fas fa-file-alt me-2"></i>Applications</a>
                <a class="nav-link text-white" href="/admin/transactions"><i class="fas fa-exchange-alt me-2"></i>Transactions</a>
                <a class="nav-link text-white" href="/admin/users"><i class="fas fa-users me-2"></i>Users</a>
                <a class="nav-link text-white" href="/admin/reports"><i class="fas fa-chart-bar me-2"></i>Reports</a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h2><i class="fas fa-file-alt me-2"></i>Applications Management</h2>
                <button class="btn btn-outline-secondary" onclick="logout()">
                    <i class="fas fa-sign-out-alt me-1"></i>Logout
                </button>
            </div>

            <!-- Application Type Tabs -->
            <ul class="nav nav-tabs mb-4" id="applicationTabs" role="tablist">
                <li class="nav-item" role="presentation">
                    <button class="nav-link active" id="card-tab" data-bs-toggle="tab" data-bs-target="#card-applications"
                            type="button" role="tab" onclick="switchApplicationType('card')">
                        <i class="fas fa-credit-card me-2"></i>Card Applications
                        <span class="badge bg-primary ms-2" id="cardAppCount">0</span>
                    </button>
                </li>
                <li class="nav-item" role="presentation">
                    <button class="nav-link" id="block-tab" data-bs-toggle="tab" data-bs-target="#block-requests"
                            type="button" role="tab" onclick="switchApplicationType('block')">
                        <i class="fas fa-ban me-2"></i>Block Requests
                        <span class="badge bg-warning ms-2" id="blockReqCount">0</span>
                    </button>
                </li>
            </ul>

            <!-- Filter Section -->
            <div class="filter-section">
                <div class="row">
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Status Filter</label>
                        <select class="form-select" id="statusFilter" onchange="filterApplications()">
                            <option value="">All Statuses</option>
                            <option value="PENDING">Pending</option>
                            <option value="APPROVED">Approved</option>
                            <option value="REJECTED">Rejected</option>
                            <option value="CANCELLED">Cancelled</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label fw-bold">Date Range</label>
                        <select class="form-select" id="dateFilter" onchange="filterApplications()">
                            <option value="">All Time</option>
                            <option value="today">Today</option>
                            <option value="week">This Week</option>
                            <option value="month">This Month</option>
                            <option value="quarter">This Quarter</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label fw-bold">Search by User</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="fas fa-search"></i></span>
                            <input type="text" class="form-control" id="userSearch"
                                   placeholder="Search by user name..." onkeyup="filterApplications()">
                        </div>
                    </div>
                    <div class="col-md-2">
                        <label class="form-label fw-bold">Action</label>
                        <button class="btn btn-primary w-100" onclick="clearFilters()">
                            <i class="fas fa-refresh me-1"></i>Clear
                        </button>
                    </div>
                </div>
            </div>

            <!-- Tab Content -->
            <div class="tab-content" id="applicationTabContent">
                <!-- Card Applications Tab -->
                <div class="tab-pane fade show active" id="card-applications" role="tabpanel">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Card Applications</h5>
                            <div class="d-flex gap-2">
                                <span class="badge bg-warning" id="pendingCardApps">Pending: 0</span>
                                <span class="badge bg-info" id="totalCardApps">Total: 0</span>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div id="cardApplicationsList">
                                <!-- Card applications will be loaded here -->
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Block Requests Tab -->
                <div class="tab-pane fade" id="block-requests" role="tabpanel">
                    <div class="card">
                        <div class="card-header d-flex justify-content-between align-items-center">
                            <h5 class="mb-0">Block Requests</h5>
                            <div class="d-flex gap-2">
                                <span class="badge bg-warning" id="pendingBlockReqs">Pending: 0</span>
                                <span class="badge bg-info" id="totalBlockReqs">Total: 0</span>
                            </div>
                        </div>
                        <div class="card-body p-0">
                            <div id="blockRequestsList">
                                <!-- Block requests will be loaded here -->
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Pagination -->
            <nav aria-label="Applications pagination" class="mt-3">
                <ul class="pagination justify-content-center" id="pagination">
                    <!-- Pagination will be generated dynamically -->
                </ul>
            </nav>
        </div>
    </div>
</div>

<!-- Application Action Modal -->
<div class="modal fade" id="actionModal" tabindex="-1">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="actionModalTitle">Process Application</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div id="applicationDetails" class="mb-3">
                    <!-- Application details will be loaded here -->
                </div>
                <div class="mb-3">
                    <label class="form-label">Action</label>
                    <select class="form-select" id="actionType">
                        <option value="approve">Approve</option>
                        <option value="reject">Reject</option>
                    </select>
                </div>
                <div class="mb-3">
                    <label class="form-label">Comment (Optional)</label>
                    <textarea class="form-control" id="actionComment" rows="3"
                              placeholder="Add a comment about your decision..."></textarea>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" onclick="submitAction()">Confirm Action</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
    // Sample data
    let cardApplications = [
        {
            id: 1,
            userId: 123,
            userName: "John Doe",
            cardType: "DEBIT",
            comment: "Need a card for daily expenses",
            status: "PENDING",
            createdAt: "2024-09-20T10:30:00Z",
            processedAt: null
        },
        {
            id: 2,
            userId: 124,
            userName: "Jane Smith",
            cardType: "CREDIT",
            comment: "Business expenses card",
            status: "APPROVED",
            createdAt: "2024-09-19T14:15:00Z",
            processedAt: "2024-09-19T16:30:00Z"
        },
        {
            id: 3,
            userId: 125,
            userName: "Bob Johnson",
            cardType: "VIRTUAL",
            comment: "Online shopping",
            status: "PENDING",
            createdAt: "2024-09-18T09:20:00Z",
            processedAt: null
        }
    ];

    let blockRequests = [
        {
            id: 1,
            userId: 123,
            userName: "John Doe",
            cardId: 456,
            cardNumber: "4111111111111111",
            reason: "Lost my card during travel",
            status: "PENDING",
            createdAt: "2024-09-20T08:15:00Z",
            processedAt: null,
            adminComment: null
        },
        {
            id: 2,
            userId: 124,
            userName: "Jane Smith",
            cardId: 457,
            cardNumber: "4222222222222222",
            reason: "Suspicious activity detected",
            status: "APPROVED",
            createdAt: "2024-09-19T11:45:00Z",
            processedAt: "2024-09-19T12:30:00Z",
            adminComment: "Verified with user, card blocked"
        }
    ];

    let currentApplicationType = 'card';
    let filteredData = [];
    let currentPage = 1;
    const itemsPerPage = 5;
    let selectedApplication = null;

    function getStatusBadgeClass(status) {
        switch(status) {
            case 'PENDING': return 'bg-warning';
            case 'APPROVED': return 'bg-success';
            case 'REJECTED': return 'bg-danger';
            case 'CANCELLED': return 'bg-secondary';
            default: return 'bg-secondary';
        }
    }

    function maskCardNumber(cardNumber) {
        return cardNumber ? cardNumber.replace(/(\d{4})(\d{4})(\d{4})(\d{4})/, '**** **** **** $4') : '';
    }

    function formatDate(dateString) {
        return new Date(dateString).toLocaleDateString('en-US', {
            year: 'numeric',
            month: 'short',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit'
        });
    }

    function switchApplicationType(type) {
        currentApplicationType = type;
        currentPage = 1;
        loadApplications();
    }

    function loadApplications() {
        if (currentApplicationType === 'card') {
            filteredData = [...cardApplications];
            document.getElementById('cardAppCount').textContent = cardApplications.length;
            renderCardApplications();
        } else {
            filteredData = [...blockRequests];
            document.getElementById('blockReqCount').textContent = blockRequests.length;
            renderBlockRequests();
        }
        updateStats();
    }

    function renderCardApplications() {
        const container = document.getElementById('cardApplicationsList');
        const startIndex = (currentPage - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;
        const appsToShow = filteredData.slice(startIndex, endIndex);

        if (appsToShow.length === 0) {
            container.innerHTML = `
                    <div class="text-center p-4">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">No applications found</h5>
                        <p class="text-muted">Try adjusting your filters</p>
                    </div>
                `;
            return;
        }

        container.innerHTML = appsToShow.map(app => `
                <div class="application-item p-3 border-bottom">
                    <div class="row align-items-center">
                        <div class="col-md-2">
                            <div class="d-flex align-items-center">
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                                     style="width: 40px; height: 40px; font-size: 0.9rem;">
                                    ${app.userName.split(' ').map(n => n[0]).join('')}
                                </div>
                                <div>
                                    <div class="fw-bold">${app.userName}</div>
                                    <small class="text-muted">ID: ${app.userId}</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <span class="badge bg-info">${app.cardType}</span>
                        </div>
                        <div class="col-md-3">
                            <div class="text-truncate" title="${app.comment}">
                                ${app.comment || 'No comment provided'}
                            </div>
                        </div>
                        <div class="col-md-2">
                            <span class="badge status-badge ${getStatusBadgeClass(app.status)}">${app.status}</span>
                        </div>
                        <div class="col-md-2">
                            <small class="text-muted">${formatDate(app.createdAt)}</small>
                        </div>
                        <div class="col-md-1">
                            ${app.status === 'PENDING' ? `
                                <button class="btn btn-sm btn-outline-primary" onclick="processApplication('card', ${app.id})" title="Process">
                                    <i class="fas fa-cog"></i>
                                </button>
                            ` : `
                                <button class="btn btn-sm btn-outline-info" onclick="viewApplicationDetails('card', ${app.id})" title="View Details">
                                    <i class="fas fa-eye"></i>
                                </button>
                            `}
                        </div>
                    </div>
                </div>
            `).join('');

        renderPagination();
    }

    function renderBlockRequests() {
        const container = document.getElementById('blockRequestsList');
        const startIndex = (currentPage - 1) * itemsPerPage;
        const endIndex = startIndex + itemsPerPage;
        const reqsToShow = filteredData.slice(startIndex, endIndex);

        if (reqsToShow.length === 0) {
            container.innerHTML = `
                    <div class="text-center p-4">
                        <i class="fas fa-inbox fa-3x text-muted mb-3"></i>
                        <h5 class="text-muted">No block requests found</h5>
                        <p class="text-muted">Try adjusting your filters</p>
                    </div>
                `;
            return;
        }

        container.innerHTML = reqsToShow.map(req => `
                <div class="application-item p-3 border-bottom">
                    <div class="row align-items-center">
                        <div class="col-md-2">
                            <div class="d-flex align-items-center">
                                <div class="bg-danger text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                                     style="width: 40px; height: 40px; font-size: 0.9rem;">
                                    ${req.userName.split(' ').map(n => n[0]).join('')}
                                </div>
                                <div>
                                    <div class="fw-bold">${req.userName}</div>
                                    <small class="text-muted">ID: ${req.userId}</small>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2">
                            <div class="fw-bold">${maskCardNumber(req.cardNumber)}</div>
                            <small class="text-muted">Card ID: ${req.cardId}</small>
                        </div>
                        <div class="col-md-3">
                            <div class="text-truncate" title="${req.reason}">
                                ${req.reason}
                            </div>
                        </div>
                        <div class="col-md-2">
                            <span class="badge status-badge ${getStatusBadgeClass(req.status)}">${req.status}</span>
                        </div>
                        <div class="col-md-2">
                            <small class="text-muted">${formatDate(req.createdAt)}</small>
                        </div>
                        <div class="col-md-1">
                            ${req.status === 'PENDING' ? `
                                <button class="btn btn-sm btn-outline-warning" onclick="processApplication('block', ${req.id})" title="Process">
                                    <i class="fas fa-cog"></i>
                                </button>
                            ` : `
                                <button class="btn btn-sm btn-outline-info" onclick="viewApplicationDetails('block', ${req.id})" title="View Details">
                                    <i class="fas fa-eye"></i>
                                </button>
                            `}
                        </div>
                    </div>
                </div>
            `).join('');

        renderPagination();
    }

    function renderPagination() {
        const pagination = document.getElementById('pagination');
        const totalPages = Math.ceil(filteredData.length / itemsPerPage);

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
            pagination.innerHTML += `
                    <li class="page-item ${currentPage === i ? 'active' : ''}">
                        <a class="page-link" href="#" onclick="changePage(${i})">${i}</a>
                    </li>
                `;
        }

        // Next button
        pagination.innerHTML += `
                <li class="page-item ${currentPage === totalPages ? 'disabled' : ''}">
                    <a class="page-link" href="#" onclick="changePage(${currentPage + 1})">Next</a>
                </li>
            `;
    }

    function changePage(page) {
        const totalPages = Math.ceil(filteredData.length / itemsPerPage);
        if (page >= 1 && page <= totalPages) {
            currentPage = page;
            loadApplications();
        }
    }

    function updateStats() {
        if (currentApplicationType === 'card') {
            const pending = cardApplications.filter(app => app.status === 'PENDING').length;
            document.getElementById('pendingCardApps').textContent = `Pending: ${pending}`;
            document.getElementById('totalCardApps').textContent = `Total: ${filteredData.length}`;
        } else {
            const pending = blockRequests.filter(req => req.status === 'PENDING').length;
            document.getElementById('pendingBlockReqs').textContent = `Pending: ${pending}`;
            document.getElementById('totalBlockReqs').textContent = `Total: ${filteredData.length}`;
        }
    }

    function filterApplications() {
        const statusFilter = document.getElementById('statusFilter').value;
        const dateFilter = document.getElementById('dateFilter').value;
        const userSearch = document.getElementById('userSearch').value.toLowerCase();

        const sourceData = currentApplicationType === 'card' ? cardApplications : blockRequests;

        filteredData = sourceData.filter(item => {
            const matchesStatus = !statusFilter || item.status === statusFilter;
            const matchesUser = !userSearch || item.userName.toLowerCase().includes(userSearch);
            const matchesDate = !dateFilter || filterByDate(item.createdAt, dateFilter);

            return matchesStatus && matchesUser && matchesDate;
        });

        currentPage = 1;
        loadApplications();
    }

    function filterByDate(dateString, filter) {
        const itemDate = new Date(dateString);
        const now = new Date();

        switch(filter) {
            case 'today':
                return itemDate.toDateString() === now.toDateString();
            case 'week':
                const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
                return itemDate >= weekAgo;
            case 'month':
                const monthAgo = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate());
                return itemDate >= monthAgo;
            case 'quarter':
                const quarterAgo = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
                return itemDate >= quarterAgo;
            default:
                return true;
        }
    }

    function clearFilters() {
        document.getElementById('statusFilter').value = '';
        document.getElementById('dateFilter').value = '';
        document.getElementById('userSearch').value = '';
        filterApplications();
    }

    function processApplication(type, id) {
        const data = type === 'card' ? cardApplications : blockRequests;
        selectedApplication = data.find(item => item.id === id);

        if (!selectedApplication) return;

        // Set modal title
        const modalTitle = type === 'card' ? 'Process Card Application' : 'Process Block Request';
        document.getElementById('actionModalTitle').textContent = modalTitle;

        // Load application details
        loadApplicationDetailsInModal(selectedApplication, type);

        // Show modal
        const modal = new bootstrap.Modal(document.getElementById('actionModal'));
        modal.show();
    }

    function loadApplicationDetailsInModal(app, type) {
        const detailsContainer = document.getElementById('applicationDetails');

        if (type === 'card') {
            detailsContainer.innerHTML = `
                    <div class="card">
                        <div class="card-body">
                            <h6 class="card-title">Application Details</h6>
                            <div class="row">
                                <div class="col-6">
                                    <strong>User:</strong> ${app.userName}<br>
                                    <strong>User ID:</strong> ${app.userId}<br>
                                    <strong>Card Type:</strong> <span class="badge bg-info">${app.cardType}</span>
                                </div>
                                <div class="col-6">
                                    <strong>Created:</strong> ${formatDate(app.createdAt)}<br>
                                    <strong>Status:</strong> <span class="badge ${getStatusBadgeClass(app.status)}">${app.status}</span>
                                </div>
                            </div>
                            <div class="mt-2">
                                <strong>Comment:</strong><br>
                                <em>${app.comment || 'No comment provided'}</em>
                            </div>
                        </div>
                    </div>
                `;
        } else {
            detailsContainer.innerHTML = `
                    <div class="card">
                        <div class="card-body">
                            <h6 class="card-title">Block Request Details</h6>
                            <div class="row">
                                <div class="col-6">
                                    <strong>User:</strong> ${app.userName}<br>
                                    <strong>User ID:</strong> ${app.userId}<br>
                                    <strong>Card:</strong> ${maskCardNumber(app.cardNumber)}
                                </div>
                                <div class="col-6">
                                    <strong>Created:</strong> ${formatDate(app.createdAt)}<br>
                                    <strong>Status:</strong> <span class="badge ${getStatusBadgeClass(app.status)}">${app.status}</span>
                                </div>
                            </div>
                            <div class="mt-2">
                                <strong>Reason for blocking:</strong><br>
                                <em>${app.reason}</em>
                            </div>
                        </div>
                    </div>
                `;
        }
    }

    function viewApplicationDetails(type, id) {
        const data = type === 'card' ? cardApplications : blockRequests;
        const app = data.find(item => item.id === id);

        if (!app) return;

        // Set modal title for viewing
        const modalTitle = type === 'card' ? 'Card Application Details' : 'Block Request Details';
        document.getElementById('actionModalTitle').textContent = modalTitle;

        // Load details
        loadApplicationDetailsInModal(app, type);

        // Hide action controls since this is view-only
        document.querySelector('#actionModal .modal-footer').style.display = 'none';
        document.getElementById('actionType').closest('.mb-3').style.display = 'none';
        document.getElementById('actionComment').closest('.mb-3').style.display = 'none';

        // Show modal
        const modal = new bootstrap.Modal(document.getElementById('actionModal'));
        modal.show();

        // Restore controls when modal is hidden
        modal._element.addEventListener('hidden.bs.modal', function() {
            document.querySelector('#actionModal .modal-footer').style.display = 'block';
            document.getElementById('actionType').closest('.mb-3').style.display = 'block';
            document.getElementById('actionComment').closest('.mb-3').style.display = 'block';
        });
    }

    function submitAction() {
        if (!selectedApplication) return;

        const action = document.getElementById('actionType').value;
        const comment = document.getElementById('actionComment').value;

        // Update application status
        selectedApplication.status = action === 'approve' ? 'APPROVED' : 'REJECTED';
        selectedApplication.processedAt = new Date().toISOString();

        if (comment) {
            if (currentApplicationType === 'card') {
                selectedApplication.adminComment = comment;
            } else {
                selectedApplication.adminComment = comment;
            }
        }

        // Close modal
        const modal = bootstrap.Modal.getInstance(document.getElementById('actionModal'));
        modal.hide();

        // Refresh display
        loadApplications();

        // Show notification
        const actionText = action === 'approve' ? 'approved' : 'rejected';
        showNotification(`Application ${actionText} successfully`, 'success');

        // Reset form
        document.getElementById('actionComment').value = '';
        selectedApplication = null;
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
        loadApplications();
    });
</script>
</body>
</html>