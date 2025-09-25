<#include "../layouts/adminLayout.ftlh">
<@adminLayout>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="fas fa-exchange-alt me-2"></i>Transactions Management</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/transactions/all">Transactions</a></li>
                    <li class="breadcrumb-item active">All Transactions</li>
                </ol>
            </nav>
        </div>
        <button class="btn btn-outline-secondary" onclick="logout()">
            <i class="fas fa-sign-out-alt me-1"></i>Logout
        </button>
    </div>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card border-0 bg-info text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${transactions.totalElements}</h4>
                            <p class="card-text">Total Transactions</p>
                        </div>
                        <i class="fas fa-exchange-alt fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 bg-success text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${transactions.numberOfElements}</h4>
                            <p class="card-text">This Page</p>
                        </div>
                        <i class="fas fa-file-alt fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 bg-warning text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${transactions.totalPages}</h4>
                            <p class="card-text">Total Pages</p>
                        </div>
                        <i class="fas fa-pages fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 bg-danger text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${transactions.number + 1}</h4>
                            <p class="card-text">Current Page</p>
                        </div>
                        <i class="fas fa-hashtag fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Transactions Table -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <i class="fas fa-list me-2"></i>All Transactions
            </h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>ID</th>
                        <th>From Card</th>
                        <th>To Card</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if transactions.content?has_content>
                        <#list transactions.content as transaction>
                            <tr>
                                <td>
                                    <span class="fw-bold text-primary">#${transaction.id}</span>
                                </td>
                                <td>
                                    <div class="small">
                                        <div class="fw-bold">${transaction.fromCardNumber!'N/A'}</div>
                                        <small class="text-muted">ID: ${transaction.fromCardId!'N/A'}</small>
                                    </div>
                                </td>
                                <td>
                                    <div class="small">
                                        <div class="fw-bold">${transaction.toCardNumber!'N/A'}</div>
                                        <small class="text-muted">ID: ${transaction.toCardId!'N/A'}</small>
                                    </div>
                                </td>
                                <td>
                                    <span class="fw-bold text-success">$${transaction.amount}</span>
                                </td>
                                <td>
                                    <#if transaction.status == 'SUCCESS'>
                                        <span class="badge bg-success">SUCCESS</span>
                                    <#elseif transaction.status == 'PENDING'>
                                        <span class="badge bg-warning">PENDING</span>
                                    <#elseif transaction.status == 'FAILED'>
                                        <span class="badge bg-danger">FAILED</span>
                                    <#elseif transaction.status == 'REFUNDED'>
                                        <span class="badge bg-info">REFUNDED</span>
                                    <#else>
                                        <span class="badge bg-secondary">${transaction.status}</span>
                                    </#if>
                                </td>
                                <td>
                                    <div class="small">
                                        <div>${transaction.createdAt}</div>
                                        <#if transaction.processedAt??>
                                            <small class="text-muted">Processed: ${transaction.processedAt}</small>
                                        </#if>
                                    </div>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <button class="btn btn-outline-primary"
                                                onclick="viewTransaction(${transaction.id})">
                                            <i class="fas fa-eye"></i>
                                        </button>
                                        <#if transaction.status == 'SUCCESS'>
                                            <button class="btn btn-outline-warning"
                                                    onclick="refundTransaction(${transaction.id})">
                                                <i class="fas fa-undo"></i>
                                            </button>
                                        </#if>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="7" class="text-center text-muted py-4">
                                <i class="fas fa-exchange-alt fa-2x mb-3"></i>
                                <div>No transactions found</div>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Pagination -->
    <#if transactions.totalPages gt 1>
        <nav aria-label="Transactions pagination" class="mt-4">
            <ul class="pagination justify-content-center">
                <#if transactions.hasPrevious()>
                    <li class="page-item">
                        <a class="page-link" href="?page=${transactions.number - 1}">
                            <i class="fas fa-chevron-left"></i>
                        </a>
                    </li>
                <#else>
                    <li class="page-item disabled">
                        <span class="page-link"><i class="fas fa-chevron-left"></i></span>
                    </li>
                </#if>

                <#list 0..transactions.totalPages-1 as pageNum>
                    <#if pageNum == transactions.number>
                        <li class="page-item active">
                            <span class="page-link">${pageNum + 1}</span>
                        </li>
                    <#else>
                        <li class="page-item">
                            <a class="page-link" href="?page=${pageNum}">${pageNum + 1}</a>
                        </li>
                    </#if>
                </#list>

                <#if transactions.hasNext()>
                    <li class="page-item">
                        <a class="page-link" href="?page=${transactions.number + 1}">
                            <i class="fas fa-chevron-right"></i>
                        </a>
                    </li>
                <#else>
                    <li class="page-item disabled">
                        <span class="page-link"><i class="fas fa-chevron-right"></i></span>
                    </li>
                </#if>
            </ul>
        </nav>
    </#if>

    <!-- Transaction Details Modal -->
    <div class="modal fade" id="transactionModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">
                        <i class="fas fa-receipt me-2"></i>Transaction Details
                    </h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <!-- Transaction Information -->
                        <div class="col-md-6">
                            <div class="card border-0 bg-light">
                                <div class="card-header bg-primary text-white">
                                    <h6 class="mb-0">
                                        <i class="fas fa-info-circle me-2"></i>Transaction Information
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <div class="row mb-3">
                                        <div class="col-4">
                                            <strong>ID:</strong>
                                        </div>
                                        <div class="col-8">
                                            <span id="modalTransactionId" class="text-primary fw-bold">#</span>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-4">
                                            <strong>Amount:</strong>
                                        </div>
                                        <div class="col-8">
                                            <span id="modalAmount" class="text-success fw-bold fs-5">$</span>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-4">
                                            <strong>Status:</strong>
                                        </div>
                                        <div class="col-8">
                                            <span id="modalStatus" class="badge"></span>
                                        </div>
                                    </div>
                                    <div class="row mb-3">
                                        <div class="col-4">
                                            <strong>Created:</strong>
                                        </div>
                                        <div class="col-8">
                                            <span id="modalCreated"></span>
                                        </div>
                                    </div>
                                    <div class="row mb-3" id="modalProcessedRow" style="display: none;">
                                        <div class="col-4">
                                            <strong>Processed:</strong>
                                        </div>
                                        <div class="col-8">
                                            <span id="modalProcessed"></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Transfer Details -->
                        <div class="col-md-6">
                            <div class="card border-0 bg-light">
                                <div class="card-header bg-info text-white">
                                    <h6 class="mb-0">
                                        <i class="fas fa-exchange-alt me-2"></i>Transfer Details
                                    </h6>
                                </div>
                                <div class="card-body">
                                    <!-- From Card -->
                                    <div class="mb-4">
                                        <h6 class="text-muted mb-2">From Card</h6>
                                        <div class="p-3 border rounded bg-white">
                                            <div id="modalFromCard" class="fw-bold"></div>
                                            <small id="modalFromCardId" class="text-muted"></small>
                                        </div>
                                    </div>

                                    <!-- Arrow -->
                                    <div class="text-center mb-4">
                                        <i class="fas fa-arrow-down fa-2x text-primary"></i>
                                    </div>

                                    <!-- To Card -->
                                    <div class="mb-4">
                                        <h6 class="text-muted mb-2">To Card</h6>
                                        <div class="p-3 border rounded bg-white">
                                            <div id="modalToCard" class="fw-bold"></div>
                                            <small id="modalToCardId" class="text-muted"></small>
                                        </div>
                                    </div>

                                    <!-- Description -->
                                    <div class="mb-3">
                                        <h6 class="text-muted mb-2">Description</h6>
                                        <div id="modalDescription" class="p-2 bg-white border rounded"></div>
                                    </div>

                                    <!-- Error Message -->
                                    <div id="modalErrorRow" class="mb-3" style="display: none;">
                                        <h6 class="text-danger mb-2">
                                            <i class="fas fa-exclamation-triangle me-1"></i>Error Message
                                        </h6>
                                        <div id="modalError"
                                             class="p-2 bg-danger-light border border-danger rounded text-danger"></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button id="modalRefundBtn" type="button" class="btn btn-warning" style="display: none;"
                            onclick="refundFromModal()">
                        <i class="fas fa-undo me-1"></i>Refund Transaction
                    </button>
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Basic JavaScript for actions -->
    <script>
        let currentTransactionId = null;

        function viewTransaction(id) {
            // Find transaction data from the table row
            let transactions = [
                <#list transactions.content as transaction>
                {
                    id: ${transaction.id},
                    amount: '${transaction.amount}',
                    status: '${transaction.status}',
                    createdAt: '${transaction.createdAt}',
                    processedAt: '${transaction.processedAt!''}',
                    fromCardNumber: '${transaction.fromCardNumber!'N/A'}',
                    fromCardId: '${transaction.fromCardId!'N/A'}',
                    toCardNumber: '${transaction.toCardNumber!'N/A'}',
                    toCardId: '${transaction.toCardId!'N/A'}',
                    description: '${transaction.description!'No description'}',
                    errorMessage: '${transaction.errorMessage!''}'
                }<#if transaction_has_next>, </#if>
                </#list>
            ];

            const transaction = transactions.find(t => t.id === id);
            if (!transaction) return;

            currentTransactionId = id;

            // Fill modal data
            document.getElementById('modalTransactionId').textContent = '#' + transaction.id;
            document.getElementById('modalAmount').textContent = transaction.amount;
            document.getElementById('modalCreated').textContent = transaction.createdAt;
            document.getElementById('modalFromCard').textContent = transaction.fromCardNumber;
            document.getElementById('modalFromCardId').textContent = 'ID: ' + transaction.fromCardId;
            document.getElementById('modalToCard').textContent = transaction.toCardNumber;
            document.getElementById('modalToCardId').textContent = 'ID: ' + transaction.toCardId;
            document.getElementById('modalDescription').textContent = transaction.description;

            // Set status badge
            const statusBadge = document.getElementById('modalStatus');
            statusBadge.className = 'badge';
            switch (transaction.status) {
                case 'SUCCESS':
                    statusBadge.className += ' bg-success';
                    statusBadge.innerHTML = '<i class="fas fa-check me-1"></i>SUCCESS';
                    document.getElementById('modalRefundBtn').style.display = 'inline-block';
                    break;
                case 'PENDING':
                    statusBadge.className += ' bg-warning';
                    statusBadge.innerHTML = '<i class="fas fa-clock me-1"></i>PENDING';
                    document.getElementById('modalRefundBtn').style.display = 'none';
                    break;
                case 'FAILED':
                    statusBadge.className += ' bg-danger';
                    statusBadge.innerHTML = '<i class="fas fa-times me-1"></i>FAILED';
                    document.getElementById('modalRefundBtn').style.display = 'none';
                    break;
                case 'REFUNDED':
                    statusBadge.className += ' bg-info';
                    statusBadge.innerHTML = '<i class="fas fa-undo me-1"></i>REFUNDED';
                    document.getElementById('modalRefundBtn').style.display = 'none';
                    break;
                default:
                    statusBadge.className += ' bg-secondary';
                    statusBadge.textContent = transaction.status;
                    document.getElementById('modalRefundBtn').style.display = 'none';
            }

            if (transaction.processedAt) {
                document.getElementById('modalProcessed').textContent = transaction.processedAt;
                document.getElementById('modalProcessedRow').style.display = 'flex';
            } else {
                document.getElementById('modalProcessedRow').style.display = 'none';
            }

            if (transaction.errorMessage) {
                document.getElementById('modalError').textContent = transaction.errorMessage;
                document.getElementById('modalErrorRow').style.display = 'block';
            } else {
                document.getElementById('modalErrorRow').style.display = 'none';
            }

            // Show modal
            const modal = new bootstrap.Modal(document.getElementById('transactionModal'));
            modal.show();
        }

        function refundFromModal() {
            if (!currentTransactionId) return;
            refundTransaction(currentTransactionId);
        }

        function refundTransaction(id) {
            if (confirm('Are you sure you want to refund this transaction?')) {
                fetch(`/api/v1/transactions/` + id + `/refund`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest',
                    },
                    credentials: 'same-origin'
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('Card status changed successfully!');
                        } else {
                            alert('Operation failed:' + data.message);

                        }
                    })
                setTimeout(() => {
                    window.location.reload();
                }, 1500);
            }
        }

        function logout() {
            window.location.href = '/logout';
        }

        // Clear modal data when closed
        document.getElementById('transactionModal').addEventListener('hidden.bs.modal', function () {
            currentTransactionId = null;
        });
    </script>
</@adminLayout>