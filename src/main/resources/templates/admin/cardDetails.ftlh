<#include "../layouts/adminLayout.ftlh">
<@adminLayout>
    <link rel="stylesheet" href="/css/cardDetails.css">

    <!-- Header -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="fas fa-credit-card me-2"></i>Card Details</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/cards/all">Cards</a></li>
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
                    <div class="card-number mb-3" id="cardNumberDisplay">${card.cardNumber}</div>
                    <div class="d-flex justify-content-between align-items-end">
                        <div>
                            <small>VALID THRU</small>
                            <div id="expiryDateDisplay">${card.expiryDate}</div>
                        </div>
                        <div>
                            <i class="fab fa-cc-visa fa-2x"></i>
                        </div>
                    </div>
                    <div class="mt-3">
                        <small>CARD HOLDER</small>
                        <div id="cardHolderDisplay">${card.ownerName?upper_case}</div>
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
                                    <div class="fw-bold" id="cardId">${card.id}</div>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted">Type</small>
                                    <div class="fw-bold" id="cardType">${card.type}</div>
                                </div>
                                <div class="col-6 mt-2">
                                    <small class="text-muted">Status</small>
                                    <div><span class="badge status-badge ${card.status}" id="cardStatus">${card.status}</span></div>
                                </div>
                                <div class="col-6 mt-2">
                                    <small class="text-muted">Created</small>
                                    <div id="createdDate">${card.createdAt}</div>
                                </div>
                                <div class="col-12 mt-3">
                                    <small class="text-muted">Current Balance</small>
                                    <div class="fw-bold fs-4 text-success" id="cardBalance">$${card.balance}</div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Owner Information -->
                <div class="col-md-6">
                    <div class="card info-card h-100">
                        <div class="card-body">
                            <h5 class="card-title">
                                <i class="fas fa-user text-primary me-2"></i>Card Owner
                            </h5>
                            <div class="d-flex align-items-center mb-3">
                                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                                     style="width: 50px; height: 50px;">
                                    <span id="ownerInitials">${card.ownerName}</span>
                                </div>
                                <div>
                                    <h6 class="mb-1" id="ownerName">${card.ownerName}</h6>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-6">
                                    <small class="text-muted">User ID</small>
                                    <div class="fw-bold" id="ownerId">${card.ownerId}</div>
                                </div>
                                <div class="col-6">
                                    <small class="text-muted">Status</small>
                                    <div><span class="badge bg-success" id="ownerStatus">ACTIVE</span></div>
                                </div>
                            </div>
                            <div class="mt-3">
                                <a class="btn btn-outline-primary btn-sm" href="/admin/users/${card.ownerId}">
                                    <i class="fas fa-eye me-1"></i>View User Details
                                </a>
                            </div>
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
                <i class="fas fa-exchange-alt text-info me-2"></i>Recent Transactions (Last 10)
            </h5>
            <a class="btn btn-outline-primary btn-sm" href="/transactions/all?cardId=${card.id}">
                <i class="fas fa-list me-1"></i>View All
            </a>
        </div>
        <div class="card-body p-0">
            <#if transactions??>
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
                        <tbody>
                        <#list transactions as transaction>
                            <tr class="transaction-item">
                                <td>${transaction.createdAt}</td>
                                <td>
                                    <i class="fas fa-exchange-alt me-2"></i>
                                    Transfer
                                </td>
                                <td>${transaction.description!'-'}</td>
                                <td class="<#if (transaction.amount >= 0)>text-success<#else>text-danger</#if>">
                                    $${transaction.amount?abs}
                                </td>
                                <td>
                                    <span class="badge <#if transaction.status == 'SUCCESS'>bg-success<#elseif transaction.status == 'PENDING'>bg-warning<#else>bg-danger</#if>">
                                        ${transaction.status}
                                    </span>
                                </td>
                            </tr>
                        </#list>
                        </tbody>
                    </table>
                </div>
            <#else>
                <div class="text-center p-4">
                    <i class="fas fa-receipt fa-3x text-muted mb-3"></i>
                    <h5 class="text-muted">No transactions found</h5>
                    <p class="text-muted">This card has no transaction history yet.</p>
                </div>
            </#if>
        </div>
    </div>

    <style>
        .card-visual {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(102, 126, 234, 0.3);
            min-height: 200px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .card-number {
            font-family: 'Courier New', monospace;
            font-size: 1.2rem;
            letter-spacing: 2px;
            font-weight: bold;
        }

        .info-card {
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            border: none;
            border-radius: 10px;
        }

        .status-badge {
            font-size: 0.8rem;
        }

        .status-badge.ACTIVE {
            background-color: #28a745 !important;
        }

        .status-badge.BLOCKED {
            background-color: #dc3545 !important;
        }

        .status-badge.EXPIRED {
            background-color: #6c757d !important;
        }

        .transaction-item:hover {
            background-color: #f8f9fa;
        }
    </style>

    <script>

        function viewAllTransactions() {
            window.location.href = ``;
        }

        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '/logout';
            }
        }

        function formatCurrency(amount) {
            return new Intl.NumberFormat('en-US', {
                style: 'currency',
                currency: 'USD'
            }).format(amount);
        }
    </script>
</@adminLayout>