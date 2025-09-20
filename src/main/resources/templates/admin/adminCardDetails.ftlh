<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - Card Details</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <link rel="stylesheet" href="/css/adminCardDetails.css">
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
                <a class="nav-link text-white active" href="/admin/cards"><i class="fas fa-credit-card me-2"></i>Cards</a>
                <a class="nav-link text-white" href="/admin/applications"><i class="fas fa-file-alt me-2"></i>Applications</a>
                <a class="nav-link text-white" href="/admin/transactions"><i class="fas fa-exchange-alt me-2"></i>Transactions</a>
                <a class="nav-link text-white" href="/admin/users"><i class="fas fa-users me-2"></i>Users</a>
                <a class="nav-link text-white" href="/admin/reports"><i class="fas fa-chart-bar me-2"></i>Reports</a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
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
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3" style="width: 50px; height: 50px;">
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
            </div