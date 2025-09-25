<#include "../layouts/userLayout.ftlh">
<@userLayout>
    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="fas fa-exchange-alt me-2"></i>Transfer Between My Cards</h2>
            <p class="text-muted">Transfer money between your active cards</p>
        </div>
        <a href="/profile" class="btn btn-outline-primary">
            <i class="fas fa-arrow-left me-1"></i>Back to Profile
        </a>
    </div>

    <!-- Transfer Form -->
    <div class="row justify-content-center">
        <div class="col-md-8">
            <div class="card shadow-sm">
                <div class="card-header bg-primary text-white">
                    <h5 class="card-title mb-0">
                        <i class="fas fa-money-bill-transfer me-2"></i>Transfer Details
                    </h5>
                </div>
                <div class="card-body">
                    <#if activeCards?has_content>
                        <form id="transferForm" action="/transactions/transfer" method="post">
                            <div class="row mb-3">
                                <div class="col-md-6">
                                    <label for="fromCardId" class="form-label">
                                        <i class="fas fa-credit-card me-1"></i>From Card
                                    </label>
                                    <select class="form-select" id="fromCardId" name="fromCardId" required>
                                        <option value="">Select source card...</option>
                                        <#list activeCards as card>
                                            <option value="${card.id}"
                                                    data-balance="${card.balance}"
                                                    data-type="${card.type}">
                                                ${card.cardNumber} (${card.type}) - Balance: $${card.balance}
                                            </option>
                                        </#list>
                                    </select>
                                    <div class="form-text" id="fromCardBalance">
                                        <i class="fas fa-info-circle me-1"></i>Select a card to see balance
                                    </div>
                                </div>

                                <div class="col-md-6">
                                    <label for="toCardId" class="form-label">
                                        <i class="fas fa-credit-card me-1"></i>To Card
                                    </label>
                                    <select class="form-select" id="toCardId" name="toCardId" required>
                                        <option value="">Select destination card...</option>
                                        <#list activeCards as card>
                                            <option value="${card.id}"
                                                    data-type="${card.type}">
                                                ${card.cardNumber} (${card.type}) - Balance: $${card.balance}
                                            </option>
                                        </#list>
                                    </select>
                                    <div class="form-text">
                                        <i class="fas fa-info-circle me-1"></i>Choose destination card
                                    </div>
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="amount" class="form-label">
                                    <i class="fas fa-dollar-sign me-1"></i>Transfer Amount
                                </label>
                                <div class="input-group">
                                    <span class="input-group-text">$</span>
                                    <input type="number"
                                           class="form-control"
                                           id="amount"
                                           name="amount"
                                           min="0.01"
                                           step="0.01"
                                           placeholder="0.00"
                                           required>
                                </div>
                                <div class="form-text">
                                    <i class="fas fa-info-circle me-1"></i>Minimum amount: $0.01
                                </div>
                            </div>

                            <div class="mb-3">
                                <label for="description" class="form-label">
                                    <i class="fas fa-comment me-1"></i>Description (Optional)
                                </label>
                                <textarea class="form-control"
                                          id="description"
                                          name="description"
                                          rows="3"
                                          maxlength="500"
                                          placeholder="Add a note for this transfer..."></textarea>
                                <div class="form-text">
                                    <span id="charCount">0</span>/500 characters
                                </div>
                            </div>

                            <!-- Transfer Summary -->
                            <div id="transferSummary" class="alert alert-info" style="display: none;">
                                <h6><i class="fas fa-receipt me-2"></i>Transfer Summary</h6>
                                <div class="row">
                                    <div class="col-md-6">
                                        <strong>From:</strong> <span id="summaryFromCard">-</span><br>
                                        <strong>Available:</strong> $<span id="summaryFromBalance">0.00</span>
                                    </div>
                                    <div class="col-md-6">
                                        <strong>To:</strong> <span id="summaryToCard">-</span><br>
                                        <strong>Amount:</strong> $<span id="summaryAmount">0.00</span>
                                    </div>
                                </div>
                            </div>

                            <div class="d-grid gap-2">
                                <button type="submit" class="btn btn-primary btn-lg" id="submitBtn" disabled>
                                    <i class="fas fa-paper-plane me-2"></i>Transfer Money
                                </button>
                            </div>
                        </form>
                    <#else>
                        <div class="text-center py-5">
                            <i class="fas fa-exclamation-triangle fa-3x text-warning mb-3"></i>
                            <h4>No Active Cards Available</h4>
                            <p class="text-muted">You need at least one active card to make transfers.</p>
                            <a href="/profile" class="btn btn-primary">
                                <i class="fas fa-plus me-1"></i>Apply for New Card
                            </a>
                        </div>
                    </#if>
                </div>
            </div>
        </div>
    </div>

    <script>
        // Form validation and UI updates
        const form = document.getElementById('transferForm');
        const fromCardSelect = document.getElementById('fromCardId');
        const toCardSelect = document.getElementById('toCardId');
        const amountInput = document.getElementById('amount');
        const descriptionInput = document.getElementById('description');
        const submitBtn = document.getElementById('submitBtn');
        const transferSummary = document.getElementById('transferSummary');
        const charCount = document.getElementById('charCount');

        // Character counter for description
        descriptionInput?.addEventListener('input', function() {
            charCount.textContent = this.value.length;
        });

        // Update from card balance info
        fromCardSelect?.addEventListener('change', function() {
            const selectedOption = this.options[this.selectedIndex];
            const balanceText = document.getElementById('fromCardBalance');

            if (selectedOption.value) {
                const balance = selectedOption.dataset.balance;
                balanceText.innerHTML = `<i class="fas fa-wallet me-1"></i>Available balance: $`+balance;
                balanceText.className = 'form-text text-success';
            } else {
                balanceText.innerHTML = '<i class="fas fa-info-circle me-1"></i>Select a card to see balance';
                balanceText.className = 'form-text';
            }
            updateSummary();
            validateForm();
        });

        // Update summary and validation when fields change
        [toCardSelect, amountInput].forEach(element => {
            element?.addEventListener('change', function() {
                updateSummary();
                validateForm();
            });
        });

        amountInput?.addEventListener('input', function() {
            updateSummary();
            validateForm();
        });

        function updateSummary() {
            const fromCard = fromCardSelect?.options[fromCardSelect.selectedIndex];
            const toCard = toCardSelect?.options[toCardSelect.selectedIndex];
            const amount = amountInput?.value;

            if (fromCard?.value && toCard?.value && amount) {
                document.getElementById('summaryFromCard').textContent =
                    fromCard.text.split(' (')[0] + ' (' + fromCard.dataset.type + ')';
                document.getElementById('summaryFromBalance').textContent = fromCard.dataset.balance;
                document.getElementById('summaryFromCard').textContent =
                    fromCard.text.split(' (')[0] + ' (' + toCard.dataset.type + ')';
                document.getElementById('summaryAmount').textContent = amount;
                transferSummary.style.display = 'block';
            } else {
                transferSummary.style.display = 'none';
            }
        }

        function validateForm() {
            const fromCardId = fromCardSelect?.value;
            const toCardId = toCardSelect?.value;
            const amount = parseFloat(amountInput?.value);

            let isValid = true;
            let errorMessage = '';

            // Check if cards are selected
            if (!fromCardId || !toCardId) {
                isValid = false;
                errorMessage = 'Please select both cards';
            }
            // Check if same card selected
            else if (fromCardId === toCardId) {
                isValid = false;
                errorMessage = 'Cannot transfer to the same card';
            }
            // Check amount
            else if (!amount || amount <= 0) {
                isValid = false;
                errorMessage = 'Please enter a valid amount';
            }

            if (submitBtn) {
                submitBtn.disabled = !isValid;
                if (!isValid && errorMessage) {
                    submitBtn.innerHTML = `<i class="fas fa-exclamation-triangle me-2"></i>`+errorMessage;
                } else if (isValid) {
                    submitBtn.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Transfer Money';
                }
            }
        }

        // Prevent same card selection
        fromCardSelect?.addEventListener('change', function() {
            const fromValue = this.value;
            Array.from(toCardSelect.options).forEach(option => {
                option.disabled = option.value === fromValue;
            });
        });

        toCardSelect?.addEventListener('change', function() {
            const toValue = this.value;
            Array.from(fromCardSelect.options).forEach(option => {
                option.disabled = option.value === toValue;
            });
        });

        // Form submission
        form?.addEventListener('submit', function(e) {
            e.preventDefault();

            const formData = new FormData(this);
            const data = {
                fromCardId: parseInt(formData.get('fromCardId')),
                toCardId: parseInt(formData.get('toCardId')),
                amount: parseFloat(formData.get('amount')),
                description: formData.get('description')
            };

            // Disable submit button during processing
            submitBtn.disabled = true;
            submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin me-2"></i>Processing...';

            fetch('/api/v1/transactions/transfer', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(data)
            })
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        alert('Transfer completed successfully! Transaction ID: ' + data.message.split(': ')[1]);
                        window.location.href = '/profile';
                    } else {
                        alert('Transfer failed!: ' + data.message);
                    }
                })
                .catch(error => {
                    alert('Error: ' + error.message);
                    submitBtn.disabled = false;
                    submitBtn.innerHTML = '<i class="fas fa-paper-plane me-2"></i>Transfer Money';
                });
        });
    </script>
</@userLayout>