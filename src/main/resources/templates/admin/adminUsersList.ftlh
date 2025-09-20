<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin - Users Management</title>
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
  <link rel="stylesheet" href="/css/adminUserList.css">
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
        <a class="nav-link text-white" href="/admin/transactions"><i class="fas fa-exchange-alt me-2"></i>Transactions</a>
        <a class="nav-link text-white active" href="/admin/users"><i class="fas fa-users me-2"></i>Users</a>
        <a class="nav-link text-white" href="/admin/reports"><i class="fas fa-chart-bar me-2"></i>Reports</a>
      </nav>
    </div>

    <!-- Main Content -->
    <div class="col-md-10 p-4">
      <div class="d-flex justify-content-between align-items-center mb-4">
        <h2><i class="fas fa-users me-2"></i>Users Management</h2>
        <div class="d-flex gap-2">
          <button class="btn btn-success" onclick="createNewUser()">
            <i class="fas fa-plus me-1"></i>Create User
          </button>
          <button class="btn btn-outline-secondary" onclick="logout()">
            <i class="fas fa-sign-out-alt me-1"></i>Logout
          </button>
        </div>
      </div>

      <!-- Statistics Cards -->
      <div class="row mb-4">
        <div class="col-md-3">
          <div class="card stats-card border-primary">
            <div class="card-body text-center">
              <i class="fas fa-users fa-2x text-primary mb-2"></i>
              <h5 class="card-title">Total Users</h5>
              <h3 class="text-primary" id="totalUsers">156</h3>
              <small class="text-muted">All registered users</small>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stats-card border-success">
            <div class="card-body text-center">
              <i class="fas fa-user-check fa-2x text-success mb-2"></i>
              <h5 class="card-title">Active Users</h5>
              <h3 class="text-success" id="activeUsers">142</h3>
              <small class="text-muted">Currently active</small>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stats-card border-warning">
            <div class="card-body text-center">
              <i class="fas fa-user-times fa-2x text-warning mb-2"></i>
              <h5 class="card-title">Blocked Users</h5>
              <h3 class="text-warning" id="blockedUsers">14</h3>
              <small class="text-muted">Temporarily blocked</small>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stats-card border-info">
            <div class="card-body text-center">
              <i class="fas fa-user-plus fa-2x text-info mb-2"></i>
              <h5 class="card-title">New Users</h5>
              <h3 class="text-info" id="newUsers">8</h3>
              <small class="text-muted">This month</small>
            </div>
          </div>
        </div>
      </div>

      <!-- Filter Section -->
      <div class="filter-section">
        <div class="row">
          <div class="col-md-3">
            <label class="form-label fw-bold">User Status</label>
            <select class="form-select" id="statusFilter" onchange="filterUsers()">
              <option value="">All Statuses</option>
              <option value="true">Active</option>
              <option value="false">Blocked</option>
            </select>
          </div>
          <div class="col-md-3">
            <label class="form-label fw-bold">Registration Date</label>
            <select class="form-select" id="dateFilter" onchange="filterUsers()">
              <option value="">All Time</option>
              <option value="today">Today</option>
              <option value="week">This Week</option>
              <option value="month">This Month</option>
              <option value="quarter">This Quarter</option>
            </select>
          </div>
          <div class="col-md-4">
            <label class="form-label fw-bold">Search Users</label>
            <div class="input-group">
              <span class="input-group-text"><i class="fas fa-search"></i></span>
              <input type="text" class="form-control" id="userSearch"
                     placeholder="Name, phone, email..." onkeyup="filterUsers()">
            </div>
          </div>
          <div class="col-md-2">
            <label class="form-label fw-bold">Actions</label>
            <button class="btn btn-primary w-100" onclick="clearFilters()">
              <i class="fas fa-refresh me-1"></i>Clear
            </button>
          </div>
        </div>
      </div>

      <!-- Users Table -->
      <div class="card">
        <div class="card-header d-flex justify-content-between align-items-center">
          <h5 class="mb-0">Users List</h5>
          <span class="badge bg-info" id="usersCount">Total: 0 users</span>
        </div>
        <div class="card-body p-0">
          <div class="table-responsive">
            <table class="table table-hover mb-0">
              <thead class="table-dark">
              <tr>
                <th>User</th>
                <th>Contact</th>
                <th>Status</th>
                <th>Cards Count</th>
                <th>Total Balance</th>
                <th>Registered</th>
                <th>Actions</th>
              </tr>
              </thead>
              <tbody id="usersTableBody">
              <!-- Dynamic content will be loaded here -->
              </tbody>
            </table>
          </div>
        </div>
      </div>

      <!-- Pagination -->
      <nav aria-label="Users pagination" class="mt-3">
        <ul class="pagination justify-content-center" id="pagination">
          <!-- Pagination will be generated dynamically -->
        </ul>
      </nav>
    </div>
  </div>
</div>

<!-- User Action Modal -->
<div class="modal fade" id="userActionModal" tabindex="-1">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="actionModalTitle">User Action</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
      </div>
      <div class="modal-body">
        <div id="userActionDetails">
          <!-- User details will be loaded here -->
        </div>
        <div class="mb-3">
          <label class="form-label">Reason (Optional)</label>
          <textarea class="form-control" id="actionReason" rows="3"
                    placeholder="Provide a reason for this action..."></textarea>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Cancel</button>
        <button type="button" class="btn" id="confirmActionBtn" onclick="confirmUserAction()">
          Confirm Action
        </button>
      </div>
    </div>
  </div>
</div>

<script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
<script>
  // Sample users data
  let allUsers = [
    {
      id: 1,
      firstName: "John",
      lastName: "Doe",
      middleName: "William",
      phoneNumber: "+1(555)123-4567",
      email: "john.doe@email.com",
      enabled: true,
      createdAt: "2024-01-15T10:30:00Z",
      updatedAt: "2024-09-20T14:30:00Z",
      cardsCount: 3,
      totalBalance: 25000.50,
      role: "USER"
    },
    {
      id: 2,
      firstName: "Jane",
      lastName: "Smith",
      middleName: "Elizabeth",
      phoneNumber: "+1(555)234-5678",
      email: "jane.smith@email.com",
      enabled: true,
      createdAt: "2024-02-20T09:15:00Z",
      updatedAt: "2024-09-19T16:45:00Z",
      cardsCount: 2,
      totalBalance: 18500.00,
      role: "USER"
    },
    {
      id: 3,
      firstName: "Bob",
      lastName: "Johnson",
      middleName: "Robert",
      phoneNumber: "+1(555)345-6789",
      email: "bob.johnson@email.com",
      enabled: false,
      createdAt: "2024-03-10T14:20:00Z",
      updatedAt: "2024-09-18T11:30:00Z",
      cardsCount: 1,
      totalBalance: 0.00,
      role: "USER"
    },
    {
      id: 4,
      firstName: "Alice",
      lastName: "Brown",
      middleName: "Marie",
      phoneNumber: "+1(555)456-7890",
      email: "alice.brown@email.com",
      enabled: true,
      createdAt: "2024-04-05T16:45:00Z",
      updatedAt: "2024-09-20T08:15:00Z",
      cardsCount: 4,
      totalBalance: 32000.75,
      role: "USER"
    },
    {
      id: 5,
      firstName: "Admin",
      lastName: "User",
      middleName: "System",
      phoneNumber: "+1(555)000-0000",
      email: "admin@bank.com",
      enabled: true,
      createdAt: "2023-12-01T00:00:00Z",
      updatedAt: "2024-09-20T12:00:00Z",
      cardsCount: 0,
      totalBalance: 0.00,
      role: "ADMIN"
    }
  ];

  let filteredUsers = [...allUsers];
  let currentPage = 1;
  const usersPerPage = 10;
  let selectedUser = null;
  let pendingAction = null;

  function getRandomColor() {
    const colors = ['#007bff', '#28a745', '#dc3545', '#ffc107', '#17a2b8', '#6f42c1', '#e83e8c'];
    return colors[Math.floor(Math.random() * colors.length)];
  }

  function getUserInitials(user) {
    return (user.firstName.charAt(0) + user.lastName.charAt(0)).toUpperCase();
  }

  function formatCurrency(amount) {
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD'
    }).format(amount);
  }

  function formatDate(dateString) {
    return new Date(dateString).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric'
    });
  }

  function renderUsers() {
    const tableBody = document.getElementById('usersTableBody');
    const startIndex = (currentPage - 1) * usersPerPage;
    const endIndex = startIndex + usersPerPage;
    const usersToShow = filteredUsers.slice(startIndex, endIndex);

    tableBody.innerHTML = '';

    if (usersToShow.length === 0) {
      tableBody.innerHTML = `
                    <tr>
                        <td colspan="7" class="text-center p-4">
                            <i class="fas fa-users fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No users found</h5>
                            <p class="text-muted">Try adjusting your filters</p>
                        </td>
                    </tr>
                `;
      return;
    }

    usersToShow.forEach(user => {
      const row = document.createElement('tr');
      row.className = 'user-item';
      row.innerHTML = `
                    <td>
                        <div class="d-flex align-items-center">
                            <div class="user-avatar me-3" style="background-color: ${getRandomColor()}">
                                ${getUserInitials(user)}
                            </div>
                            <div>
                                <div class="fw-bold">${user.firstName} ${user.middleName} ${user.lastName}</div>
                                <small class="text-muted">ID: ${user.id} | ${user.role}</small>
                            </div>
                        </div>
                    </td>
                    <td>
                        <div>${user.phoneNumber}</div>
                        <small class="text-muted">${user.email}</small>
                    </td>
                    <td>
                        <span class="badge status-badge ${user.enabled ? 'bg-success' : 'bg-danger'}">
                            <i class="fas ${user.enabled ? 'fa-check-circle' : 'fa-times-circle'} me-1"></i>
                            ${user.enabled ? 'Active' : 'Blocked'}
                        </span>
                    </td>
                    <td>
                        <span class="badge bg-info">${user.cardsCount}</span>
                        ${user.cardsCount > 0 ? '<small class="text-muted d-block">cards</small>' : ''}
                    </td>
                    <td class="fw-bold ${user.totalBalance > 0 ? 'text-success' : 'text-muted'}">
                        ${formatCurrency(user.totalBalance)}
                    </td>
                    <td>
                        <div>${formatDate(user.createdAt)}</div>
                        <small class="text-muted">Updated: ${formatDate(user.updatedAt)}</small>
                    </td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn btn-sm btn-outline-primary" onclick="viewUserDetails(${user.id})" title="View Details">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn btn-sm btn-outline-info" onclick="editUser(${user.id})" title="Edit User">
                                <i class="fas fa-edit"></i>
                            </button>
                            ${user.enabled ? `
                                <button class="btn btn-sm btn-outline-warning" onclick="showUserActionModal(${user.id}, 'block')" title="Block User">
                                    <i class="fas fa-user-lock"></i>
                                </button>
                            ` : `
                                <button class="btn btn-sm btn-outline-success" onclick="showUserActionModal(${user.id}, 'unblock')" title="Unblock User">
                                    <i class="fas fa-user-check"></i>
                                </button>
                            `}
                            ${user.role !== 'ADMIN' ? `
                                <button class="btn btn-sm btn-outline-danger" onclick="showUserActionModal(${user.id}, 'delete')" title="Delete User">
                                    <i class="fas fa-trash"></i>
                                </button>
                            ` : ''}
                        </div>
                    </td>
                `;
      tableBody.appendChild(row);
    });

    updateUsersCount();
    renderPagination();
  }

  function updateUsersCount() {
    document.getElementById('usersCount').textContent = `Total: ${filteredUsers.length} users`;
  }

  function renderPagination() {
    const pagination = document.getElementById('pagination');
    const totalPages = Math.ceil(filteredUsers.length / usersPerPage);

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
    const totalPages = Math.ceil(filteredUsers.length / usersPerPage);
    if (page >= 1 && page <= totalPages) {
      currentPage = page;
      renderUsers();
    }
  }

  function filterUsers() {
    const statusFilter = document.getElementById('statusFilter').value;
    const dateFilter = document.getElementById('dateFilter').value;
    const searchTerm = document.getElementById('userSearch').value.toLowerCase();

    filteredUsers = allUsers.filter(user => {
      const matchesStatus = statusFilter === '' || user.enabled.toString() === statusFilter;
      const matchesDate = !dateFilter || filterByDate(user.createdAt, dateFilter);
      const matchesSearch = !searchTerm ||
              user.firstName.toLowerCase().includes(searchTerm) ||
              user.lastName.toLowerCase().includes(searchTerm) ||
              user.middleName.toLowerCase().includes(searchTerm) ||
              user.phoneNumber.includes(searchTerm) ||
              user.email.toLowerCase().includes(searchTerm);

      return matchesStatus && matchesDate && matchesSearch;
    });

    currentPage = 1;
    renderUsers();
    updateStats();
  }

  function filterByDate(dateString, filter) {
    const userDate = new Date(dateString);
    const now = new Date();

    switch(filter) {
      case 'today':
        return userDate.toDateString() === now.toDateString();
      case 'week':
        const weekAgo = new Date(now.getTime() - 7 * 24 * 60 * 60 * 1000);
        return userDate >= weekAgo;
      case 'month':
        const monthAgo = new Date(now.getFullYear(), now.getMonth() - 1, now.getDate());
        return userDate >= monthAgo;
      case 'quarter':
        const quarterAgo = new Date(now.getFullYear(), now.getMonth() - 3, now.getDate());
        return userDate >= quarterAgo;
      default:
        return true;
    }
  }

  function clearFilters() {
    document.getElementById('statusFilter').value = '';
    document.getElementById('dateFilter').value = '';
    document.getElementById('userSearch').value = '';
    filteredUsers = [...allUsers];
    currentPage = 1;
    renderUsers();
    updateStats();
  }

  function updateStats() {
    const total = allUsers.length;
    const active = allUsers.filter(u => u.enabled).length;
    const blocked = total - active;
    const thisMonth = new Date();
    const monthAgo = new Date(thisMonth.getFullYear(), thisMonth.getMonth() - 1, thisMonth.getDate());
    const newThisMonth = allUsers.filter(u => new Date(u.createdAt) >= monthAgo).length;

    document.getElementById('totalUsers').textContent = total.toString();
    document.getElementById('activeUsers').textContent = active.toString();
    document.getElementById('blockedUsers').textContent = blocked.toString();
    document.getElementById('newUsers').textContent = newThisMonth.toString();
  }

  function viewUserDetails(userId) {
    window.location.href = `/admin/users/${userId}`;
  }

  function editUser(userId) {
    alert(`Edit user functionality would be implemented here for user ID: ${userId}`);
  }

  function createNewUser() {
    alert('Create new user functionality would be implemented here');
  }

  function showUserActionModal(userId, action) {
    selectedUser = allUsers.find(u => u.id === userId);
    pendingAction = action;

    if (!selectedUser) return;

    const modal = document.getElementById('userActionModal');
    const title = document.getElementById('actionModalTitle');
    const details = document.getElementById('userActionDetails');
    const confirmBtn = document.getElementById('confirmActionBtn');

    // Set modal content based on action
    switch(action) {
      case 'block':
        title.textContent = 'Block User';
        confirmBtn.textContent = 'Block User';
        confirmBtn.className = 'btn btn-warning';
        break;
      case 'unblock':
        title.textContent = 'Unblock User';
        confirmBtn.textContent = 'Unblock User';
        confirmBtn.className = 'btn btn-success';
        break;
      case 'delete':
        title.textContent = 'Delete User';
        confirmBtn.textContent = 'Delete User';
        confirmBtn.className = 'btn btn-danger';
        break;
    }

    // Load user details
    details.innerHTML = `
                <div class="card">
                    <div class="card-body">
                        <div class="d-flex align-items-center mb-3">
                            <div class="user-avatar me-3" style="background-color: ${getRandomColor()}">
                                ${getUserInitials(selectedUser)}
                            </div>
                            <div>
                                <h6 class="mb-1">${selectedUser.firstName} ${selectedUser.middleName} ${selectedUser.lastName}</h6>
                                <small class="text-muted">${selectedUser.phoneNumber} | ${selectedUser.email}</small>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-6">
                                <strong>User ID:</strong> ${selectedUser.id}<br>
                                <strong>Role:</strong> ${selectedUser.role}<br>
                                <strong>Status:</strong> <span class="badge ${selectedUser.enabled ? 'bg-success' : 'bg-danger'}">${selectedUser.enabled ? 'Active' : 'Blocked'}</span>
                            </div>
                            <div class="col-6">
                                <strong>Cards:</strong> ${selectedUser.cardsCount}<br>
                                <strong>Balance:</strong> ${formatCurrency(selectedUser.totalBalance)}<br>
                                <strong>Registered:</strong> ${formatDate(selectedUser.createdAt)}
                            </div>
                        </div>
                        ${action === 'delete' ? `
                            <div class="alert alert-danger mt-3">
                                <i class="fas fa-exclamation-triangle me-2"></i>
                                <strong>Warning:</strong> This action cannot be undone. All user data including cards and transactions will be permanently deleted.
                            </div>
                        ` : ''}
                    </div>
                </div>
            `;

    const bootstrapModal = new bootstrap.Modal(modal);
    bootstrapModal.show();
  }

  function confirmUserAction() {
    if (!selectedUser || !pendingAction) return;

    const reason = document.getElementById('actionReason').value;

    switch(pendingAction) {
      case 'block':
        selectedUser.enabled = false;
        selectedUser.updatedAt = new Date().toISOString();
        showNotification(`User ${selectedUser.firstName} ${selectedUser.lastName} has been blocked`, 'warning');
        break;
      case 'unblock':
        selectedUser.enabled = true;
        selectedUser.updatedAt = new Date().toISOString();
        showNotification(`User ${selectedUser.firstName} ${selectedUser.lastName} has been unblocked`, 'success');
        break;
      case 'delete':
        if (selectedUser.cardsCount > 0) {
          showNotification('Cannot delete user with active cards', 'danger');
          return;
        }
        const index = allUsers.findIndex(u => u.id === selectedUser.id);
        if (index > -1) {
          allUsers.splice(index, 1);
          filteredUsers = [...allUsers];
        }
        showNotification(`User ${selectedUser.firstName} ${selectedUser.lastName} has been deleted`, 'info');
        break;
    }

    // Close modal
    const modal = bootstrap.Modal.getInstance(document.getElementById('userActionModal'));
    modal.hide();

    // Refresh display
    filterUsers();

    // Reset form
    document.getElementById('actionReason').value = '';
    selectedUser = null;
    pendingAction = null;
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
    renderUsers();
    updateStats();
  });
</script>
</body>
</html>