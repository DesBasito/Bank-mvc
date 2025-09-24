<#include "../layouts/userLayout.ftlh">
<@userLayout>
    <link rel="stylesheet" href="/css/profile.css">
    <!-- Main Content -->
    <div class="container main-content">
        <!-- Page Header -->
        <div class="row mb-4">
            <div class="col-12">
                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h2><i class="fas fa-credit-card me-2"></i>My Cards Portfolio</h2>
                        <p class="text-muted">Manage your bank cards, apply for new ones, and request blocking</p>
                    </div>
                    <button class="btn btn-gradient btn-lg" data-bs-toggle="modal" data-bs-target="#newCardModal">
                        <i class="fas fa-plus me-2"></i>Apply for New Card
                    </button>
                </div>
            </div>
        </div>

        <!-- Quick Stats -->
        <div class="row mb-4">
            <div class="col-md-3">
                <div class="card info-card">
                    <div class="card-body text-center">
                        <i class="fas fa-credit-card fa-2x text-primary mb-2"></i>
                        <h5 class="card-title">Total Cards</h5>
                        <h3 class="text-primary">${cards?size}</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card info-card">
                    <div class="card-body text-center">
                        <i class="fas fa-dollar-sign fa-2x text-success mb-2"></i>
                        <h5 class="card-title">Total Balance</h5>
                        <h3 class="text-success">${totalBalance?string.currency}</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card info-card">
                    <div class="card-body text-center">
                        <i class="fas fa-check-circle fa-2x text-info mb-2"></i>
                        <h5 class="card-title">Active Cards</h5>
                        <h3 class="text-info">${activeCards?size}</h3>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card info-card">
                    <div class="card-body text-center">
                        <i class="fas fa-exchange-alt fa-2x text-warning mb-2"></i>
                        <h5 class="card-title">This Month</h5>
                        <h3 class="text-warning">${monthlyTransactions}</h3>
                    </div>
                </div>
            </div>
        </div>

        <!-- Filters and Sorting -->
        <div class="filter-section">
            <div class="row">
                <div class="col-md-3">
                    <label class="form-label fw-bold">Filter by Status</label>
                    <select class="form-select" id="statusFilter" onchange="filterCards()">
                        <option value="">All Status</option>
                        <option value="ACTIVE">Active</option>
                        <option value="BLOCKED">Blocked</option>
                        <option value="EXPIRED">Expired</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">Filter by Type</label>
                    <select class="form-select" id="typeFilter" onchange="filterCards()">
                        <option value="">All Types</option>
                        <option value="DEBIT">Debit</option>
                        <option value="CREDIT">Credit</option>
                        <option value="VIRTUAL">Virtual</option>
                        <option value="PREPAID">Prepaid</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">Sort by</label>
                    <select class="form-select" id="sortBy" onchange="sortCards()">
                        <option value="created_desc">Date Created (Newest)</option>
                        <option value="created_asc">Date Created (Oldest)</option>
                        <option value="balance_desc">Balance (High to Low)</option>
                        <option value="balance_asc">Balance (Low to High)</option>
                        <option value="type">Card Type</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <label class="form-label fw-bold">Search</label>
                    <input type="text" class="form-control" id="searchCards" placeholder="Search card number..."
                           onkeyup="searchCards()">
                </div>
            </div>
        </div>

        <!-- Cards Grid -->
        <div class="row" id="cardsContainer">
            <#if cards?? && (cards?size > 0)>
                <#list cards as card>
                    <div class="col-md-6 col-lg-4 mb-4 card-item"
                         data-status="${card.status}"
                         data-type="${card.type}"
                         data-balance="${card.balance?c}"
                         data-created="${card.createdAt}">
                        <div class="card h-100">
                            <div class="card-visual position-relative">
                                <div class="d-flex justify-content-between align-items-start mb-3">
                                    <div>
                                        <small class="opacity-75">${card.type} CARD</small>
                                        <!-- Безопасное отображение номера карты -->
                                        <div class="card-number">${card.cardNumber}</div>
                                    </div>
                                    <#if card.status == 'ACTIVE'>
                                        <span class="badge bg-success status-badge">ACTIVE</span>
                                    <#elseif card.status == 'BLOCKED'>
                                        <span class="badge bg-danger status-badge">BLOCKED</span>
                                    <#elseif card.status == 'EXPIRED'>
                                        <span class="badge bg-warning status-badge">EXPIRED</span>
                                    </#if>
                                </div>
                                <div class="d-flex justify-content-between align-items-end">
                                    <div>
                                        <small class="opacity-75"><#if card.type == 'CREDIT'>Available<#else>Balance</#if></small>
                                        <div class="card-balance">$<#if card.balance??>${card.balance?string("#,##0.00")}<#else>0.00</#if></div>
                                    </div>
                                    <div class="text-end">
                                        <small class="opacity-75">Expires</small>
                                        <!-- Исправленное отображение даты истечения -->
                                        <div><#if card.expiryDate??>${card.expiryDate}<#else>--/--</#if></div>
                                    </div>
                                </div>
                            </div>
                            <div class="card-body">
                                <div class="d-flex justify-content-between align-items-center mb-2">
                                    <span class="text-muted">Created: <#if card.createdAt??>${card.createdAt}<#else>Unknown</#if></span>
                                    <#if card.type == 'VIRTUAL'>
                                        <span class="badge bg-secondary">VIRTUAL</span>
                                    <#else>
                                        <i class="fab fa-cc-visa fa-lg text-primary"></i>
                                    </#if>
                                </div>
                                <#if card.status == 'ACTIVE'>
                                    <div class="btn-group w-100" role="group">
                                        <button class="btn btn-outline-danger btn-sm"
                                                onclick="requestCardBlock('${card.id}', '<#if card.cardNumber??>${card.cardNumber}<#else>****</#if>')">
                                            <i class="fas fa-ban me-1"></i>Block
                                        </button>
                                        <button class="btn btn-outline-info btn-sm" onclick="viewCardDetails('${card.id}')">
                                            <i class="fas fa-eye me-1"></i>Details
                                        </button>
                                    </div>
                                <#else>
                                    <div class="text-center">
                                        <button class="btn btn-outline-secondary btn-sm" disabled>
                                            <i class="fas fa-ban me-1"></i>Card Blocked
                                        </button>
                                    </div>
                                </#if>
                            </div>
                        </div>
                    </div>
                </#list>
            </#if>
        </div>

        <!-- No Cards Found Message -->
        <div class="row" id="noCardsMessage" <#if cards?? && (cards?size > 0)>style="display: none;"</#if>>
            <div class="col-12">
                <div class="text-center py-5">
                    <i class="fas fa-credit-card fa-4x text-muted mb-3"></i>
                    <h4 class="text-muted">No cards found</h4>
                    <p class="text-muted">Try adjusting your filters or apply for a new card.</p>
                </div>
            </div>
        </div>
    </div>

    <!-- New Card Application Modal -->
    <div class="modal fade" id="newCardModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-plus me-2"></i>Apply for New Card</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="newCardForm">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Card Type</label>
                            <select class="form-select" id="cardType" required>
                                <option value="">Select card type</option>
                                <option value="DEBIT">Debit Card</option>
                                <option value="CREDIT">Credit Card</option>
                                <option value="VIRTUAL">Virtual Card</option>
                                <option value="PREPAID">Prepaid Card</option>
                            </select>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Reason for Application</label>
                            <textarea class="form-control" id="applicationReason" rows="3"
                                      placeholder="Please describe why you need this card..."></textarea>
                        </div>
                        <div class="alert alert-info">
                            <i class="fas fa-info-circle me-2"></i>
                            Your application will be reviewed by our team. You'll receive a notification once it's processed.
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-gradient" onclick="submitCardApplication()">Submit Application</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Block Card Modal -->
    <div class="modal fade" id="blockCardModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title"><i class="fas fa-ban me-2"></i>Block Card Request</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <form id="blockCardForm">
                        <input type="hidden" id="blockCardId">
                        <div class="mb-3">
                            <label class="form-label fw-bold">Card Number</label>
                            <input type="text" class="form-control" id="blockCardNumber" readonly>
                        </div>
                        <div class="mb-3">
                            <label class="form-label fw-bold">Reason for Blocking</label>
                            <select class="form-select" id="blockReason" required>
                                <option value="">Select reason</option>
                                <option value="LOST">Lost Card</option>
                                <option value="STOLEN">Stolen Card</option>
                                <option value="COMPROMISED">Security Compromised</option>
                                <option value="SUSPICIOUS">Suspicious Activity</option>
                                <option value="OTHER">Other</option>
                            </select>
                        </div>
                        <div class="alert alert-warning">
                            <i class="fas fa-exclamation-triangle me-2"></i>
                            Once blocked, you won't be able to use this card until it's unblocked by an administrator.
                        </div>
                    </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
                    <button type="button" class="btn btn-danger" onclick="submitBlockRequest()">Block Card</button>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script>
        let currentBlockCardId = null;

        function filterCards() {
            const statusFilter = document.getElementById('statusFilter').value;
            const typeFilter = document.getElementById('typeFilter').value;
            const searchTerm = document.getElementById('searchCards').value.toLowerCase();

            const cards = document.querySelectorAll('.card-item');
            let visibleCount = 0;

            cards.forEach(card => {
                const cardStatus = card.dataset.status;
                const cardType = card.dataset.type;
                const cardNumber = card.querySelector('.card-number').textContent.toLowerCase();

                const statusMatch = !statusFilter || cardStatus === statusFilter;
                const typeMatch = !typeFilter || cardType === typeFilter;
                const searchMatch = !searchTerm || cardNumber.includes(searchTerm);

                if (statusMatch && typeMatch && searchMatch) {
                    card.style.display = 'block';
                    visibleCount++;
                } else {
                    card.style.display = 'none';
                }
            });

            document.getElementById('noCardsMessage').style.display = visibleCount === 0 ? 'block' : 'none';
        }

        function searchCards() {
            filterCards();
        }

        function sortCards() {
            const sortBy = document.getElementById('sortBy').value;
            const container = document.getElementById('cardsContainer');
            const cards = Array.from(document.querySelectorAll('.card-item'));

            cards.sort((a, b) => {
                switch (sortBy) {
                    case 'created_desc':
                        return new Date(b.dataset.created) - new Date(a.dataset.created);
                    case 'created_asc':
                        return new Date(a.dataset.created) - new Date(b.dataset.created);
                    case 'balance_desc':
                        return parseFloat(b.dataset.balance) - parseFloat(a.dataset.balance);
                    case 'balance_asc':
                        return parseFloat(a.dataset.balance) - parseFloat(b.dataset.balance);
                    case 'type':
                        return a.dataset.type.localeCompare(b.dataset.type);
                    default:
                        return 0;
                }
            });

            cards.forEach(card => container.appendChild(card));
        }

        function submitCardApplication() {
            const cardType = document.getElementById('cardType').value;
            const reason = document.getElementById('applicationReason').value;

            if (!cardType) {
                alert('Please select a card type');
                return;
            }

            // AJAX request to server
            fetch('/api/v1/card-applications', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({
                    cardType: cardType,
                    comment: reason
                })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Card application submitted successfully! You will receive a notification once it\'s processed.');
                        location.reload();
                    } else {
                        alert('Error submitting application: ' + data.message);
                    }
                })
                .catch(error => {
                    alert('An error occurred while submitting the application');
                    console.error('Error:', error);
                });

            const modal = bootstrap.Modal.getInstance(document.getElementById('newCardModal'));
            modal.hide();
            document.getElementById('newCardForm').reset();
        }

        function requestCardBlock(cardId, cardNumber) {
            currentBlockCardId = cardId;
            document.getElementById('blockCardId').value = cardId;
            document.getElementById('blockCardNumber').value = cardNumber;

            const modal = new bootstrap.Modal(document.getElementById('blockCardModal'));
            modal.show();
        }

        function submitBlockRequest() {
            const cardId = currentBlockCardId;
            const reason = document.getElementById('blockReason').value;

            if (!reason) {
                alert('Please select a reason for blocking');
                return;
            }

            if (!cardId) {
                alert('No card selected for blocking');
                return;
            }

            // AJAX request to server
            fetch('/api/v1/card-block-requests', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json',
                    'X-Requested-With': 'XMLHttpRequest'
                },
                body: JSON.stringify({
                    cardId: cardId,
                    reason: reason
                })
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Block request submitted successfully! An administrator will review your request.');
                        location.reload();
                    } else {
                        alert('Error submitting request: ' + data.message);
                    }
                })
                .catch(error => {
                    alert('An error occurred while submitting the request');
                    console.error('Error:', error);
                });

            const modal = bootstrap.Modal.getInstance(document.getElementById('blockCardModal'));
            modal.hide();
            document.getElementById('blockCardForm').reset();

            currentBlockCardId = null;
        }

        // View card details
        function viewCardDetails(cardId) {
            window.location.href = '/cards/' + cardId;
        }
        document.getElementById('blockCardModal').addEventListener('hidden.bs.modal', function () {
            currentBlockCardId = null;
            document.getElementById('blockCardForm').reset();
        });
    </script>
</@userLayout>