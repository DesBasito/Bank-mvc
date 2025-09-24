<#-- Admin All Cards Template using FreeMarker -->
<#include "../layouts/adminLayout.ftlh">
<@adminLayout ; spring>
    <link rel="stylesheet" href="/css/adminAllCards.css">
    <!-- Header with title and actions -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-credit-card me-2"></i>All Cards Management</h2>
        <a class="btn btn-outline-secondary" href="/logout">
            <i class="fas fa-sign-out-alt me-1"></i>Logout
        </a>
    </div>

    <!-- Filters and balance Section -->
    <div class="balance-section mb-4">
        <form method="get" action="/cards/all" class="row g-3">
            <div class="col-md-2">
                <label class="form-label fw-bold">balance from: </label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-balance"></i></span>
                    <input type="number" class="form-control" id="balanceFrom" name="balanceFrom"
                           placeholder="balance cards..." value="${balanceFrom!""}">
                </div>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-bold">balance to: </label>
                <div class="input-group">
                    <span class="input-group-text"><i class="fas fa-balance"></i></span>
                    <input type="number" class="form-control" id="balanceTo" name="balanceTo"
                           placeholder="balance cards..." value="${balanceTo!""}">
                </div>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-bold">Filter by Status</label>
                <select class="form-select" id="status" name="status">
                    <option value="">All Statuses</option>
                    <option value="ACTIVE" <#if status?? && status == "ACTIVE">selected</#if>>Active</option>
                    <option value="BLOCKED" <#if status?? && status == "BLOCKED">selected</#if>>Blocked</option>
                    <option value="EXPIRED" <#if status?? && status == "EXPIRED">selected</#if>>Expired</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-bold">Sort by</label>
                <select class="form-select" id="sort" name="sort">
                    <option value="id" <#if sort?? && sort == "id">selected</#if>>ID</option>
                    <option value="cardNumber" <#if sort?? && sort == "cardNumber">selected</#if>>Card Number</option>
                    <option value="balance" <#if sort?? && sort == "balance">selected</#if>>Balance</option>
                    <option value="expiryDate" <#if sort?? && sort == "expiryDate">selected</#if>>Expiry Date</option>
                    <option value="createdAt" <#if sort?? && sort == "createdAt">selected</#if>>Created Date</option>
                </select>
            </div>

            <div class="col-md-2 d-flex align-items-end">
                <button type="submit" class="btn btn-primary me-2">
                    <i class="fas fa-filter"></i> Apply
                </button>
                <a href="/cards/all" class="btn btn-outline-secondary">
                    <i class="fas fa-times"></i> Clear
                </a>
            </div>
        </form>
    </div>

    <!-- Cards Count and Results -->
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h5 class="mb-0">
                Total: <span class="text-primary">${cards.totalElements}</span> cards
            </h5>
        </div>
        <div class="text-muted">
            Page ${cards.number + 1} of ${cards.totalPages}
            (${cards.size} per page)
        </div>
    </div>

    <!-- Cards Table -->
    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>Card Number</th>
                        <th>Card Holder</th>
                        <th>Type</th>
                        <th>Status</th>
                        <th>Balance</th>
                        <th>Expiry Date</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if cards.content?has_content>
                        <#list cards.content as card>
                            <tr class="card-item">
                                <td class="card-number">
                                    <#-- Mask card number showing only last 4 digits -->
                                    ${card.cardNumber}
                                </td>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="avatar-sm bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-2">
                                            ${card.ownerName?substring(0, 1)?upper_case}
                                        </div>
                                        <div>
                                            <div class="fw-medium">${card.ownerName}</div>
                                            <small class="text-muted">ID: ${card.ownerId}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <span class="badge bg-info">${card.type}</span>
                                </td>
                                <td>
                                        <span class="badge status-badge
                                            <#if card.status == 'ACTIVE'>bg-success<#elseif card.status == 'BLOCKED'>bg-danger<#elseif card.status == 'EXPIRED'>bg-warning<#else>bg-secondary</#if>">
                                            ${card.status}
                                        </span>
                                </td>
                                <td class="balance">
                                    $${card.balance?string["#,##0.00"]}
                                </td>
                                <td>
                                    <#if card.expiryDate??>
                                        ${card.expiryDate}
                                    <#else>
                                        -
                                    </#if>
                                </td>
                                <td>
                                    <div class="btn-group" role="group">
                                        <!-- View Details Button -->
                                        <a href="/cards/${card.id}"
                                           class="btn btn-sm btn-outline-primary"
                                           title="View Details">
                                            <i class="fas fa-eye"></i>
                                        </a>

                                        <!-- Block/Unblock Button -->
                                        <#if card.status == 'BLOCKED'>
                                            <button class="btn btn-sm btn-outline-success"
                                                    onclick="toggleCardStatus(${card.id})"
                                                    title="Unblock Card">
                                                <i class="fas fa-unlock"></i>
                                            </button>
                                        <#else>
                                            <button class="btn btn-sm btn-outline-danger"
                                                    onclick="toggleCardStatus(${card.id})"
                                                    title="Block Card">
                                                <i class="fas fa-lock"></i>
                                            </button>
                                        </#if>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="7" class="text-center py-4">
                                <div class="text-muted">
                                    <i class="fas fa-balance fa-2x mb-2"></i>
                                    <p class="mb-0">No cards found</p>
                                    <#if balance?? && balance != "">
                                        <small>Try adjusting your balance criteria</small>
                                    </#if>
                                </div>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Pagination -->
    <#if cards.totalPages gt 1>
        <nav aria-label="Cards pagination" class="mt-4">
            <ul class="pagination justify-content-center">
                <!-- First Page -->
                <#if cards.number gt 0>
                    <li class="page-item">
                        <a class="page-link"
                           href="?
<#if balanceFrom?? && balanceFrom != "">balanceFrom=${balanceFrom}</#if>
<#if balanceTo?? && balanceTo != "">&balanceTo=${balanceTo}</#if>
<#if status?? && status != "">&status=${status}</#if>
<#if sort?? && sort != "">&sort=${sort}</#if>">
                            <i class="fas fa-angle-double-left"></i>
                        </a>
                    </li>
                </#if>

                <#if cards.hasPrevious()>
                    <li class="page-item">
                        <a class="page-link"
                           href="?page=${cards.number - 1}&size=${cards.size}<#if balance?? && balance != "">&balance=${balance}</#if><#if status?? && status != "">&status=${status}</#if><#if sort?? && sort != "">&sort=${sort}</#if>">
                            <i class="fas fa-angle-left"></i> Previous
                        </a>
                    </li>
                </#if>

                <!-- Page Numbers -->
                <#assign startPage = cards.number - 2>
                <#assign endPage = cards.number + 2>
                <#if startPage lt 0>
                    <#assign startPage = 0>
                    <#assign endPage = [4, cards.totalPages - 1]?min>
                </#if>
                <#if endPage gte cards.totalPages>
                    <#assign endPage = cards.totalPages - 1>
                    <#assign startPage = [0, cards.totalPages - 5]?max>
                </#if>

                <#list startPage..endPage as pageNum>
                    <li class="page-item <#if pageNum == cards.number>active</#if>">
                        <a class="page-link"
                           href="?
<#if balanceFrom?? && balanceFrom != "">balanceFrom=${balanceFrom}</#if>
<#if balanceTo?? && balanceTo != "">&balanceTo=${balanceTo}</#if>
<#if status?? && status != "">&status=${status}</#if>
<#if sort?? && sort != "">&sort=${sort}</#if>">
                            ${pageNum + 1}
                        </a>
                    </li>
                </#list>

                <!-- Next Page -->
                <#if cards.hasNext()>
                    <li class="page-item">
                        <a class="page-link"
                           href="?
<#if balanceFrom?? && balanceFrom != "">balanceFrom=${balanceFrom}</#if>
<#if balanceTo?? && balanceTo != "">&balanceTo=${balanceTo}</#if>
<#if status?? && status != "">&status=${status}</#if>
<#if sort?? && sort != "">&sort=${sort}</#if>">
                            Next <i class="fas fa-angle-right"></i>
                        </a>
                    </li>
                </#if>

                <!-- Last Page -->
                <#if cards.number lt cards.totalPages - 1>
                    <li class="page-item">
                        <a class="page-link" href="?
<#if balanceFrom?? && balanceFrom != "">balanceFrom=${balanceFrom}</#if>
<#if balanceTo?? && balanceTo != "">&balanceTo=${balanceTo}</#if>
<#if status?? && status != "">&status=${status}</#if>
<#if sort?? && sort != "">&sort=${sort}</#if>">
                            <i class="fas fa-angle-double-right"></i>
                        </a>
                    </li>
                </#if>
            </ul>
        </nav>
    </#if>

    <!-- Loading Modal for AJAX requests -->
    <div class="modal fade" id="loadingModal" tabindex="-1" data-bs-backdrop="static" data-bs-keyboard="false">
        <div class="modal-dialog modal-sm modal-dialog-centered">
            <div class="modal-content">
                <div class="modal-body text-center py-4">
                    <div class="spinner-border text-primary mb-3" role="status">
                        <span class="visually-hidden">Loading...</span>
                    </div>
                    <p class="mb-0">Processing request...</p>
                </div>
            </div>
        </div>
    </div>
    <!-- JavaScript for Card Management -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        /**
         * Toggle card status (block/unblock) via AJAX
         * @param {number} cardId - The ID of the card
         */

        function toggleCardStatus(cardId) {
            if (!confirm(`Are you sure you want to change status of this card?`)) {
                return;
            }

            const url = `/api/v1/cards/` + cardId + `/toggle`;

            fetch(url, {
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

        /**
         * Logout function
         */
        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '/logout';
            }
        }

        // Initialize page
        document.addEventListener('DOMContentLoaded', function () {
            document.getElementById('sort')?.addEventListener('change', function () {
                this.form.submit();
            });

            // Handle search form submission with Enter key
            document.getElementById('search')?.addEventListener('keypress', function (e) {
                if (e.key === 'Enter') {
                    this.form.submit();
                }
            });

            console.log('Admin All Cards page initialized');
        });
    </script>
</@adminLayout>