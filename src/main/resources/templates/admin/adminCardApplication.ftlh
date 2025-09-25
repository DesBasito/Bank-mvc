<#include "../layouts/adminLayout.ftlh">
<@adminLayout>
    <link rel="stylesheet" href="/css/applicationPage.css">

    <!-- Header Section -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2><i class="fas fa-file-alt me-2"></i>Applications Management</h2>
            <nav aria-label="breadcrumb">
                <ol class="breadcrumb">
                    <li class="breadcrumb-item"><a href="/admin">Dashboard</a></li>
                    <li class="breadcrumb-item active">Applications</li>
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
                            <h4 class="card-title">${applications.totalElements!0}</h4>
                            <p class="card-text">Total Applications</p>
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
                            <h4 class="card-title">${blockRequests.totalElements!0}</h4>
                            <p class="card-text">Block Requests</p>
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
                            <#assign pendingApplications = 0>
                            <#if applications?? && applications.content??>
                                <#list applications.content as app>
                                    <#if app.status == "PENDING">
                                        <#assign pendingApplications = pendingApplications + 1>
                                    </#if>
                                </#list>
                            </#if>
                            <h4 class="card-title">${pendingApplications}</h4>
                            <p class="card-text">Pending Applications</p>
                        </div>
                        <i class="fas fa-clock fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card border-0 bg-success text-white">
                <div class="card-body">
                    <div class="d-flex justify-content-between">
                        <div>
                            <#assign approvedApplications = 0>
                            <#if applications?? && applications.content??>
                                <#list applications.content as app>
                                    <#if app.status == "APPROVED">
                                        <#assign approvedApplications = approvedApplications + 1>
                                    </#if>
                                </#list>
                            </#if>
                            <h4 class="card-title">${approvedApplications}</h4>
                            <p class="card-text">Approved Today</p>
                        </div>
                        <i class="fas fa-check fa-2x"></i>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Filters -->
    <div class="card mb-4">
        <div class="card-body">
            <form method="GET" action="/card-applications/admin/all">
                <div class="row g-3 align-items-end">
                    <div class="col-md-4">
                        <label class="form-label">Status Filter</label>
                        <select name="status" class="form-select">
                            <option value="">All Status</option>
                            <option value="PENDING" <#if status?? && status == "PENDING">selected</#if>>Pending</option>
                            <option value="APPROVED" <#if status?? && status == "APPROVED">selected</#if>>Approved
                            </option>
                            <option value="REJECTED" <#if status?? && status == "REJECTED">selected</#if>>Rejected
                            </option>
                            <option value="CANCELLED" <#if status?? && status == "CANCELLED">selected</#if>>Cancelled
                            </option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <button type="submit" class="btn btn-primary">
                            <i class="fas fa-filter me-1"></i>Apply Filter
                        </button>
                        <a href="/card-applications/admin/all" class="btn btn-outline-secondary ms-2">
                            <i class="fas fa-times me-1"></i>Clear
                        </a>
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Application Type Tabs -->
    <ul class="nav nav-tabs mb-4" id="applicationTabs" role="tablist">
        <li class="nav-item" role="presentation">
            <button class="nav-link active" id="card-applications-tab" data-bs-toggle="tab"
                    data-bs-target="#card-applications" type="button" role="tab">
                <i class="fas fa-credit-card me-2"></i>Card Applications
                <#if applications?? && applications.content??>
                    <span class="badge bg-primary ms-2">${applications.totalElements}</span>
                </#if>
            </button>
        </li>
        <li class="nav-item" role="presentation">
            <button class="nav-link" id="block-requests-tab" data-bs-toggle="tab"
                    data-bs-target="#block-requests" type="button" role="tab">
                <i class="fas fa-ban me-2"></i>Block Requests
                <#if blockRequests?? && blockRequests.content??>
                    <span class="badge bg-warning ms-2">${blockRequests.totalElements}</span>
                </#if>
            </button>
        </li>
    </ul>

    <!-- Tab Content -->
    <div class="tab-content" id="applicationTabsContent">
        <!-- Card Applications Tab -->
        <div class="tab-pane fade show active" id="card-applications" role="tabpanel">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Card Applications</h5>
                    <small class="text-muted">Total: ${applications.totalElements!0} applications</small>
                </div>
                <div class="card-body p-0">
                    <#if applications?? && applications.content?has_content>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>User</th>
                                    <th>Card Type</th>
                                    <th>Status</th>
                                    <th>Applied Date</th>
                                    <th>Processed Date</th>
                                    <th style="width: 80px;">Details</th>
                                </tr>
                                </thead>
                                <tbody>
                                <#list applications.content as application>
                                    <tr>
                                        <td>
                                            <strong>#${application.id}</strong>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <i class="fas fa-user me-2 text-secondary"></i>
                                                <div>
                                                    <div class="fw-medium">${application.userName!""}</div>
                                                    <small class="text-muted">ID: ${application.userId!""}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <i class="fas fa-credit-card me-2 text-primary"></i>
                                                <span class="fw-medium">${application.cardType}</span>
                                            </div>
                                        </td>
                                        <td>
                                                <span class="badge
                                                    <#switch application.status>
                                                        <#case "PENDING">
                                                            bg-warning text-dark
                                                            <#break>
                                                        <#case "APPROVED">
                                                            bg-success
                                                            <#break>
                                                        <#case "REJECTED">
                                                            bg-danger
                                                            <#break>
                                                        <#case "CANCELLED">
                                                            bg-secondary
                                                            <#break>
                                                        <#default>
                                                            bg-light text-dark
                                                    </#switch>
                                                ">${application.status}</span>
                                        </td>
                                        <td>${application.createdAt}</td>
                                        <td>
                                            <#if application.processedAt??>
                                                ${application.processedAt}
                                            <#else>
                                                <span class="text-muted">Not processed</span>
                                            </#if>
                                        </td>
                                        <td>
                                            <#if application.status == "PENDING">
                                                <button class="btn btn-sm btn-success me-1"
                                                        onclick="processApplication(${application.id}, 'APPROVED')"
                                                        data-bs-toggle="tooltip" data-bs-placement="top"
                                                        title="Approve application">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger"
                                                        onclick="processApplication(${application.id}, 'REJECTED')"
                                                        data-bs-toggle="tooltip" data-bs-placement="top"
                                                        title="Reject application">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            <#else>
                                                <span class="text-muted small"><#if application.comment??>${application.comment}<#else >${application.status}</#if></span>
                                            </#if>
                                        </td>
                                    </tr>
                                </#list>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination -->
                        <#if applications.totalPages gt 1>
                            <div class="card-footer bg-white">
                                <nav aria-label="Applications pagination">
                                    <ul class="pagination justify-content-center mb-0">
                                        <#if applications.hasPrevious()>
                                            <li class="page-item">
                                                <a class="page-link"
                                                   href="?page=${applications.number - 1}<#if status??>&&status=${status}</#if>">Previous</a>
                                            </li>
                                        </#if>

                                        <#list 0..<applications.totalPages as pageNum>
                                            <li class="page-item <#if pageNum == applications.number>active</#if>">
                                                <a class="page-link"
                                                   href="?page=${pageNum}<#if status??>&&status=${status}</#if>">${pageNum + 1}</a>
                                            </li>
                                        </#list>

                                        <#if applications.hasNext()>
                                            <li class="page-item">
                                                <a class="page-link"
                                                   href="?page=${applications.number + 1}<#if status??>&&status=${status}</#if>">Next</a>
                                            </li>
                                        </#if>
                                    </ul>
                                </nav>
                            </div>
                        </#if>
                    <#else>
                        <div class="text-center py-5">
                            <i class="fas fa-file-alt fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No applications found</h5>
                            <p class="text-muted">No card applications match your current filter criteria.</p>
                        </div>
                    </#if>
                </div>
            </div>
        </div>

        <!-- Block Requests Tab -->
        <div class="tab-pane fade" id="block-requests" role="tabpanel">
            <div class="card shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Card Block Requests</h5>
                    <small class="text-muted">Total: ${blockRequests.totalElements!0} requests</small>
                </div>
                <div class="card-body p-0">
                    <#if blockRequests?? && blockRequests.content?has_content>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>User</th>
                                    <th>Card</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Request Date</th>
                                    <th>Processed Date</th>
                                    <th style="width: 80px;">Details</th>
                                </tr>
                                </thead>
                                <tbody>
                                <#list blockRequests.content as request>
                                    <tr>
                                        <td>
                                            <strong>#${request.id}</strong>
                                        </td>
                                        <td>
                                            <div class=" d-flex align-items-center">
                                                <i class="fas fa-user me-2 text-secondary"></i>
                                                <div>
                                                    <div class="fw-medium">${request.userName!""}</div>
                                                    <small class="text-muted">ID: ${request.userId!""}</small>
                                                </div>
                                            </div>
                                        </td>
                                        <td>
                                            <div class="d-flex align-items-center">
                                                <i class="fas fa-credit-card me-2 text-warning"></i>
                                                <span class="fw-medium">${request.cardNumber}</span>
                                            </div>
                                        </td>
                                        <td>${request.reason}</td>
                                        <td>
                                                <span class="badge
                                                    <#switch request.status>
                                                        <#case "PENDING">
                                                            bg-warning text-dark
                                                            <#break>
                                                        <#case "APPROVED">
                                                            bg-success
                                                            <#break>
                                                        <#case "REJECTED">
                                                            bg-danger
                                                            <#break>
                                                        <#default>
                                                            bg-light text-dark
                                                    </#switch>
                                                ">${request.status}</span>
                                        </td>
                                        <td>${request.createdAt}</td>
                                        <td>
                                            <#if request.processedAt??>
                                                ${request.processedAt}
                                            <#else>
                                                <span class="text-muted">Not processed</span>
                                            </#if>
                                        </td>
                                        <td>
                                            <#if request.status == "PENDING">
                                                <button class="btn btn-sm btn-success me-1"
                                                        onclick="processBlockRequest(${request.id}, 'APPROVED')"
                                                        data-bs-toggle="tooltip" data-bs-placement="top"
                                                        title="Approve">
                                                    <i class="fas fa-check"></i>
                                                </button>
                                                <button class="btn btn-sm btn-danger"
                                                        onclick="processBlockRequest(${request.id}, 'REJECTED')"
                                                        data-bs-toggle="tooltip" data-bs-placement="top" title="Reject">
                                                    <i class="fas fa-times"></i>
                                                </button>
                                            <#else>
                                                <span class="text-muted small"><#if request.adminComment??>${request.adminComment}<#else >${request.status}</#if></span>
                                            </#if>
                                        </td>
                                    </tr>
                                </#list>
                                </tbody>
                            </table>
                        </div>

                        <!-- Pagination for Block Requests -->
                        <#if blockRequests.totalPages gt 1>
                            <div class="card-footer bg-white">
                                <nav aria-label="Block requests pagination">
                                    <ul class="pagination justify-content-center mb-0">
                                        <#if blockRequests.hasPrevious()>
                                            <li class="page-item">
                                                <a class="page-link"
                                                   href="?page=${blockRequests.number - 1}&tab=block-requests">Previous</a>
                                            </li>
                                        </#if>

                                        <#list 0..<blockRequests.totalPages as pageNum>
                                            <li class="page-item <#if pageNum == blockRequests.number>active</#if>">
                                                <a class="page-link"
                                                   href="?page=${pageNum}&tab=block-requests">${pageNum + 1}</a>
                                            </li>
                                        </#list>

                                        <#if blockRequests.hasNext()>
                                            <li class="page-item">
                                                <a class="page-link"
                                                   href="?page=${blockRequests.number + 1}&tab=block-requests">Next</a>
                                            </li>
                                        </#if>
                                    </ul>
                                </nav>
                            </div>
                        </#if>
                    <#else>
                        <div class="text-center py-5">
                            <i class="fas fa-ban fa-3x text-muted mb-3"></i>
                            <h5 class="text-muted">No block requests found</h5>
                            <p class="text-muted">No card block requests match your current criteria.</p>
                        </div>
                    </#if>
                </div>
            </div>
        </div>
    </div>

    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <script>
        var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'));
        tooltipTriggerList.map(function (tooltipTriggerEl) {
            return new bootstrap.Tooltip(tooltipTriggerEl);
        });

        function processApplication(applicationId, action) {
            const actionText = action === 'APPROVED' ? 'approve' : 'reject';

            if (action === 'REJECTED') {
                const reason = prompt('Please provide rejection reason:');
                if (!reason) {
                    return;
                }

                if (confirm(`Are you sure you want to ` + actionText + ` this application?`)) {
                    fetch(`/api/v1/card-applications/` + applicationId + `/reject?reason=` + encodeURIComponent(reason), {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                location.reload();
                            } else {
                                alert('Error processing application: ' + data.message);
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Error processing application');
                        });
                }
            } else if (action === 'APPROVED') {
                if (confirm(`Are you sure you want to ` + actionText + ` this application?`)) {
                    fetch(`/api/v1/card-applications/` + applicationId + `/approve`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        }
                    })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                location.reload();
                            } else {
                                alert('Error processing application: ' + data.message);
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Error processing application');
                        });
                }
            }
        }

        function processBlockRequest(requestId, action) {
            const actionText = action === 'APPROVED' ? 'approve' : 'reject';
            const comment = prompt(`Please provide admin comment for `+actionText+`ing this request:`);

            if (!comment) {
                return;
            }

            if (confirm(`Are you sure you want to `+actionText+`this block request?`)) {
                let url;

                if (action === 'APPROVED') {
                    url = `/api/v1/card-block-requests/`+requestId+`/approve?adminComment=`+encodeURIComponent(comment);
                } else {
                    url = `/api/v1/card-block-requests/`+requestId+`/reject?adminComment=`+encodeURIComponent(comment);
                }

                fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.id || data.success) {
                            location.reload();
                        } else {
                            alert('Error processing request: ' + (data.message || 'Unknown error'));
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Error processing request');
                    });
            }
        }

        function logout() {
            if (confirm('Are you sure you want to logout?')) {
                window.location.href = '/logout';
            }
        }

        document.addEventListener('DOMContentLoaded', function () {
            const urlParams = new URLSearchParams(window.location.search);
            const tab = urlParams.get('tab');
            if (tab === 'block-requests') {
                const blockRequestsTab = document.getElementById('block-requests-tab');
                const tabInstance = new bootstrap.Tab(blockRequestsTab);
                tabInstance.show();
            }
        });
    </script>

</@adminLayout>