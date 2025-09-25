<#include "../layouts/userLayout.ftlh">
<@userLayout>
    <link rel="stylesheet" href="/css/applicationPage.css">

    <!-- Page Header -->
    <div class="row mb-4">
        <div class="col-12">
            <div class="d-flex justify-content-between align-items-center">
                <div>
                    <h2><i class="fas fa-file-alt me-2"></i>My Applications</h2>
                    <p class="text-muted">Track your card applications and block requests</p>
                </div>
            </div>
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
                <div class="card-header bg-white">
                    <h5 class="mb-0">Card Applications History</h5>
                </div>
                <div class="card-body p-0">
                    <#if applications?? && applications.content?has_content>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Card Type</th>
                                    <th>Status</th>
                                    <th>Applied Date</th>
                                    <th>Processed Date</th>
                                    <th>Details</th>
                                </tr>
                                </thead>
                                <tbody>
                                <#list applications.content as application>
                                    <tr>
                                        <td>#${application.id}</td>
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
                                                <button class="btn btn-sm btn-outline-danger"
                                                        onclick="cancelApplication(${application.id})">
                                                    <i class="fas fa-times me-1"></i>Cancel
                                                </button>
                                            <#else>
                                                <#if application.comment??>
                                                    <span class="text-muted">${application.comment}</span>
                                                <#else>
                                                    <span class="text-muted">-</span>
                                                </#if>
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
                                                <a class="page-link" href="?page=${applications.number - 1}">Previous</a>
                                            </li>
                                        </#if>

                                        <#list 0..<applications.totalPages as pageNum>
                                            <li class="page-item <#if pageNum == applications.number>active</#if>">
                                                <a class="page-link" href="?page=${pageNum}">${pageNum + 1}</a>
                                            </li>
                                        </#list>

                                        <#if applications.hasNext()>
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${applications.number + 1}">Next</a>
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
                            <p class="text-muted">You haven't submitted any card applications yet.</p>
                        </div>
                    </#if>
                </div>
            </div>
        </div>

        <!-- Block Requests Tab -->
        <div class="tab-pane fade" id="block-requests" role="tabpanel">
            <div class="card shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Card Block Requests</h5>
                </div>
                <div class="card-body p-0">
                    <#if blockRequests?? && blockRequests.content?has_content>
                        <div class="table-responsive">
                            <table class="table table-hover mb-0">
                                <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Card</th>
                                    <th>Reason</th>
                                    <th>Status</th>
                                    <th>Request Date</th>
                                    <th>Processed Date</th>
                                    <th>Admin Comment</th>
                                </tr>
                                </thead>
                                <tbody>
                                <#list blockRequests.content as request>
                                    <tr>
                                        <td>#${request.id}</td>
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
                                            <#if request.adminComment??>
                                                <span class="text-muted">${request.adminComment}</span>
                                            <#else>
                                                <span class="text-muted">-</span>
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
                                                <a class="page-link" href="?page=${blockRequests.number - 1}&tab=block-requests">Previous</a>
                                            </li>
                                        </#if>

                                        <#list 0..<blockRequests.totalPages as pageNum>
                                            <li class="page-item <#if pageNum == blockRequests.number>active</#if>">
                                                <a class="page-link" href="?page=${pageNum}&tab=block-requests">${pageNum + 1}</a>
                                            </li>
                                        </#list>

                                        <#if blockRequests.hasNext()>
                                            <li class="page-item">
                                                <a class="page-link" href="?page=${blockRequests.number + 1}&tab=block-requests">Next</a>
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
                            <p class="text-muted">You haven't submitted any card block requests yet.</p>
                        </div>
                    </#if>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <script>
        function cancelApplication(applicationId) {
            if (confirm('Are you sure you want to cancel this application?')) {
                fetch(`/api/v1/card-applications/`+applicationId+`/cancel`, {
                    method: 'PUT',
                    headers: {
                        'Content-Type': 'application/json'
                    }
                })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            location.reload();
                        } else {
                            alert('Error canceling application: ' + data.message);
                        }
                    })
                    .catch(error => {
                        console.error('Error:', error);
                        alert('Error canceling application');
                    });
            }
        }
        document.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const tab = urlParams.get('tab');
            if (tab === 'block-requests') {
                const blockRequestsTab = document.getElementById('block-requests-tab');
                const tabInstance = new bootstrap.Tab(blockRequestsTab);
                tabInstance.show();
            }
        });
    </script>

</@userLayout>