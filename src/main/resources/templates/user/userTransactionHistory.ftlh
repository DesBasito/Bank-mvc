<#include "../layouts/userLayout.ftlh">
<@userLayout>
    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="fas fa-history me-2"></i>Transaction History</h2>
            <p class="text-muted">View your recent transaction activity</p>
        </div>
        <a href="/profile" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left me-1"></i>Back to Profile
        </a>
    </div>

    <!-- Statistics Cards -->
    <div class="row mb-4">
        <div class="col-md-3">
            <div class="card border-0 bg-primary text-white">
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
                            <h4 class="card-title">${monthlyTransactions}</h4>
                            <p class="card-text">This Month</p>
                        </div>
                        <i class="fas fa-calendar-alt fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 bg-info text-white">
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
                            <h4 class="card-title">${totalAmount!'0.00'}</h4>
                            <p class="card-text">Total Amount</p>
                        </div>
                        <i class="fas fa-dollar-sign fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter Options -->
    <div class="card mb-4">
        <div class="card-header">
            <h6 class="mb-0"><i class="fas fa-filter me-2"></i>Filter Transactions</h6>
        </div>
        <div class="card-body">
            <form method="GET" action="/transactions/my">
                <div class="row">
                    <div class="col-md-4">
                        <label for="cardId" class="form-label">Card</label>
                        <select class="form-select" name="cardId" id="cardId">
                            <option value="">All Cards</option>
                            <#if userCards??>
                                <#list userCards as card>
                                    <option value="${card.id}" ${(selectedCardId?? && selectedCardId == card.id)?string('selected', '')}>
                                        ${card.cardNumber} - $${card.balance}
                                    </option>
                                </#list>
                            </#if>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label for="dateFrom" class="form-label">From Date</label>
                        <input type="date" class="form-control" name="dateFrom" id="dateFrom" value="${dateFrom!''}">
                    </div>
                    <div class="col-md-3">
                        <label for="dateTo" class="form-label">To Date</label>
                        <input type="date" class="form-control" name="dateTo" id="dateTo" value="${dateTo!''}">
                    </div>
                    <div class="col-md-2">
                        <label class="form-label">&nbsp;</label>
                        <button type="submit" class="btn btn-primary d-block w-100">
                            <i class="fas fa-search me-1"></i>Filter
                        </button>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Transactions List -->
    <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
            <h5 class="mb-0">
                <i class="fas fa-list me-2"></i>Your Transactions
            </h5>
            <small class="text-muted">Page ${transactions.number + 1} of ${transactions.totalPages}</small>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Date</th>
                        <th>Transaction</th>
                        <th>Amount</th>
                        <th>Status</th>
                        <th>Description</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if transactions.content?has_content>
                        <#list transactions.content as transaction>
                            <tr class="transaction-item" style="cursor: pointer;" onclick="viewTransactionDetails(${transaction.id})">
                                <td>
                                    <div class="small">
                                        <div class="fw-bold">${transaction.createdAt}</div>
                                        <#if transaction.processedAt??>
                                            <small class="text-muted">Processed: ${transaction.processedAt}</small>
                                        </#if>
                                    </div>
                                </td>
                                <td>
                                    <div class="small">
                                        <div class="fw-bold">
                                            <i class="fas fa-arrow-right text-muted me-1"></i>
                                            From: ${transaction.fromCardNumber!'N/A'}
                                        </div>
                                        <div class="text-muted">
                                            <i class="fas fa-arrow-left text-muted me-1"></i>
                                            To: ${transaction.toCardNumber!'N/A'}
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="fw-bold text-success">$${transaction.amount}</span>
                                </td>
                                <td>
                                    <#if transaction.status == 'SUCCESS'>
                                        <span class="badge bg-success">
                                            <i class="fas fa-check me-1"></i>SUCCESS
                                        </span>
                                    <#elseif transaction.status == 'PENDING'>
                                        <span class="badge bg-warning">
                                            <i class="fas fa-clock me-1"></i>PENDING
                                        </span>
                                    <#elseif transaction.status == 'FAILED'>
                                        <span class="badge bg-danger">
                                            <i class="fas fa-times me-1"></i>FAILED
                                        </span>
                                    <#elseif transaction.status == 'REFUNDED'>
                                        <span class="badge bg-info">
                                            <i class="fas fa-undo me-1"></i>REFUNDED
                                        </span>
                                    <#else>
                                        <span class="badge bg-secondary">${transaction.status}</span>
                                    </#if>
                                </td>
                                <td>
                                    <div class="small text-muted">
                                        ${transaction.description!'No description'}
                                        <#if transaction.errorMessage??>
                                            <div class="text-danger">
                                                <i class="fas fa-exclamation-triangle me-1"></i>
                                                ${transaction.errorMessage}
                                            </div>
                                        </#if>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="5" class="text-center text-muted py-5">
                                <i class="fas fa-history fa-3x mb-3"></i>
                                <div class="h5">No transactions found</div>
                                <p>You haven't made any transactions yet or no transactions match your filters.</p>
                                <a href="/profile" class="btn btn-primary">
                                    <i class="fas fa-plus me-1"></i>Make a Transfer
                                </a>
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
        <nav aria-label="Transaction history pagination" class="mt-4">
            <ul class="pagination justify-content-center">
                <#if transactions.hasPrevious()>
                    <li class="page-item">
                        <a class="page-link" href="?page=${transactions.number - 1}&cardId=${selectedCardId!''}&dateFrom=${dateFrom!''}&dateTo=${dateTo!''}">
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
                            <a class="page-link" href="?page=${pageNum}&cardId=${selectedCardId!''}&dateFrom=${dateFrom!''}&dateTo=${dateTo!''}">${pageNum + 1}</a>
                        </li>
                    </#if>
                </#list>

                <#if transactions.hasNext()>
                    <li class="page-item">
                        <a class="page-link" href="?page=${transactions.number + 1}&cardId=${selectedCardId!''}&dateFrom=${dateFrom!''}&dateTo=${dateTo!''}">
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

    <!-- Basic JavaScript -->
    <script>
        function viewTransactionDetails(id) {
            console.log('View transaction:', id);
        }

        document.addEventListener('DOMContentLoaded', function() {
            const dateToInput = document.getElementById('dateTo');
            const dateFromInput = document.getElementById('dateFrom');

            if (!dateToInput.value) {
                dateToInput.value = new Date().toISOString().split('T')[0];
            }

            if (!dateFromInput.value) {
                const thirtyDaysAgo = new Date();
                thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
                dateFromInput.value = thirtyDaysAgo.toISOString().split('T')[0];
            }
        });
    </script>
</@userLayout>