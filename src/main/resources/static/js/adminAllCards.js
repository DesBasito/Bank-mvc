/**
 * Toggle card status (block/unblock) via AJAX
 * @param {number} cardId - The ID of the card
 * @param {string} action - 'block' or 'unblock'
 */
function toggleCardStatus(cardId, action) {
    const actionText = action === 'block' ? 'block' : 'unblock';

    if (!confirm(`Are you sure you want to ${actionText} this card?`)) {
        return;
    }

    // Show loading modal
    const loadingModal = new bootstrap.Modal(document.getElementById('loadingModal'));
    loadingModal.show();

    // Prepare request
    const url = `/api/v1/cards/${cardId}/${action}`;

    fetch(url, {
        method: 'PUT',
        headers: {
            'Content-Type': 'application/json',
            'X-Requested-With': 'XMLHttpRequest'
        },
        credentials: 'same-origin'
    })
        .then(response => {
            loadingModal.hide();

            if (response.ok) {
                return response.json();
            } else {
                throw new Error(`HTTP ${response.status}: ${response.statusText}`);
            }
        })
        .then(data => {
            showNotification(`Card ${actionText}ed successfully!`, 'success');

            // Reload page to reflect changes
            setTimeout(() => {
                window.location.reload();
            }, 1500);
        })
        .catch(error => {
            console.error('Error:', error);
            showNotification(`Failed to ${actionText} card. Please try again.`, 'danger');
        });
}

/**
 * Show notification message
 * @param {string} message - The message to display
 * @param {string} type - Bootstrap alert type (success, danger, warning, info)
 */
function showNotification(message, type) {
    // Remove existing notifications
    document.querySelectorAll('.notification-toast').forEach(toast => toast.remove());

    const notification = document.createElement('div');
    notification.className = `alert alert-${type} alert-dismissible fade show position-fixed notification-toast`;
    notification.style.cssText = `
                top: 20px;
                right: 20px;
                z-index: 9999;
                min-width: 300px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.15);
            `;
    notification.innerHTML = `
                <i class="fas fa-${type === 'success' ? 'check-circle' : type === 'danger' ? 'exclamation-circle' : 'info-circle'} me-2"></i>
                ${message}
                <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
            `;

    document.body.appendChild(notification);

    // Auto remove after 4 seconds
    setTimeout(() => {
        if (notification.parentNode) {
            notification.remove();
        }
    }, 4000);
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
document.addEventListener('DOMContentLoaded', function() {
    document.getElementById('sort')?.addEventListener('change', function() {
        this.form.submit();
    });

    // Handle search form submission with Enter key
    document.getElementById('search')?.addEventListener('keypress', function(e) {
        if (e.key === 'Enter') {
            this.form.submit();
        }
    });

    console.log('Admin All Cards page initialized');
});