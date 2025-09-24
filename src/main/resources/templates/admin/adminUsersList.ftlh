<#include "../layouts/adminLayout.ftlh">
<@adminLayout>
    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="fas fa-users me-2"></i>Users Management</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/users">Users</a></li>
                    <li class="breadcrumb-item active">All Users</li>
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
            <div class="card border-0 bg-primary text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${users.totalElements}</h4>
                            <p class="card-text">Total Users</p>
                        </div>
                        <i class="fas fa-users fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 bg-success text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${users.content?filter(u -> u.enabled)?size}</h4>
                            <p class="card-text">Active Users</p>
                        </div>
                        <i class="fas fa-check-circle fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 bg-warning text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${users.content?filter(u -> !u.enabled)?size}</h4>
                            <p class="card-text">Blocked Users</p>
                        </div>
                        <i class="fas fa-ban fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 bg-info text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <h4 class="card-title">${users.number + 1}</h4>
                            <p class="card-text">Current Page</p>
                        </div>
                        <i class="fas fa-file-alt fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Users Table -->
    <div class="card border-0 shadow-sm">
        <div class="card-header bg-white">
            <h5 class="card-title mb-0">Users List</h5>
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover mb-0">
                    <thead class="table-light">
                    <tr>
                        <th>User</th>
                        <th>Contact</th>
                        <th>Status</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <#if users.content?has_content>
                        <#list users.content as user>
                            <tr>
                                <td>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center me-3"
                                             style="width: 40px; height: 40px; font-size: 14px;">
                                            ${user.firstName?substring(0,1)}${user.lastName?substring(0,1)}
                                        </div>
                                        <div>
                                            <div class="fw-bold">${user.fullName}</div>
                                            <small class="text-muted">ID: ${user.id}</small>
                                        </div>
                                    </div>
                                </td>
                                <td>
                                    <div>${user.phoneNumber!""}</div>
                                </td>
                                <td>
                                        <span class="badge ${user.enabled?then('bg-success', 'bg-danger')}">
                                            <i class="fas ${user.enabled?then('fa-check-circle', 'fa-times-circle')} me-1"></i>
                                            ${user.enabled?then('Active', 'Blocked')}
                                        </span>
                                </td>
                                <td>
                                    <div class="btn-group btn-group-sm">
                                        <a href="/users/${user.id}" class="btn btn-outline-primary btn-sm">
                                            <i class="fas fa-eye"></i>
                                        </a>
                                        <button class="btn btn-outline-warning btn-sm"
                                                onclick="toggleUserStatus(${user.id})">
                                            <i class="fas ${user.enabled?then('fa-ban', 'fa-check')}"></i>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                        </#list>
                    <#else>
                        <tr>
                            <td colspan="6" class="text-center p-4">
                                <i class="fas fa-users fa-3x text-muted mb-3"></i>
                                <h5 class="text-muted">No users found</h5>
                            </td>
                        </tr>
                    </#if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Pagination -->
    <#if users.totalPages gt 1>
        <nav class="mt-4" aria-label="Users pagination">
            <ul class="pagination justify-content-center">
                <#if users.hasPrevious()>
                    <li class="page-item">
                        <a class="page-link" href="/users?page=${users.number - 1}">Previous</a>
                    </li>
                </#if>

                <#list 0..<users.totalPages as page>
                    <li class="page-item ${(page == users.number)?then('active', '')}">
                        <a class="page-link" href="/users?page=${page}">${page + 1}</a>
                    </li>
                </#list>

                <#if users.hasNext()>
                    <li class="page-item">
                        <a class="page-link" href="/users?page=${users.number + 1}">Next</a>
                    </li>
                </#if>
            </ul>
        </nav>
    </#if>

    <!-- Minimal JavaScript -->
    <script>
        function toggleUserStatus(userId) {
            if (confirm('Are you sure you want to toggle user status?')) {
                fetch(`/api/v1/users/`+userId+`/toggle-status`, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                        'X-Requested-With': 'XMLHttpRequest'
                    }
                })
                    .then(response => {
                        if (response.ok) {
                            location.reload();
                        } else {
                            alert('Error toggling user status');
                        }
                    })
                    .catch(error => {
                        alert('Error: ' + error.message);
                    });
            }
        }

        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '/logout';
            }
        }
    </script>

    <style>
        .table-hover tbody tr:hover {
            background-color: #f8f9fa;
        }

        .card {
            border-radius: 10px;
        }

        .badge {
            font-size: 0.75em;
        }
    </style>
</@adminLayout>