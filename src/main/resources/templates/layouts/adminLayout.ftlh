<#macro adminLayout>
<#import "/spring.ftl" as spring>
    <!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin - All Cards</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        .sidebar {
            min-height: 100vh;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        }
    </style>
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
                <a class="nav-link text-white <?active?>" href="/cards/all"><i class="fas fa-credit-card me-2"></i>Cards</a>
                <a class="nav-link text-white <?active?>" href="/card-applications/admin/all"><i class="fas fa-file-alt me-2"></i>Applications</a>
                <a class="nav-link text-white <?active?>" href="/transactions/all"><i class="fas fa-exchange-alt me-2"></i>Transactions</a>
                <a class="nav-link text-white <?active?>" href="/users"><i class="fas fa-users me-2"></i>Users</a>
                <a class="nav-link text-white <?active?>" href="/card-block-requests/admin/all"><i class="fas fa-chart-bar me-2"></i>Reports</a>
            </nav>
        </div>

        <!-- Main Content -->
        <div class="col-md-10 p-4">
            <#nested spring>
        </div>
    </div>
</div>

</body>
</html>
</#macro>