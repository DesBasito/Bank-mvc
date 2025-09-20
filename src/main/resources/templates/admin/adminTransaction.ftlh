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

</script>
</body>
</html>