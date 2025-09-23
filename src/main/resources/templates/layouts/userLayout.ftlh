<#import "spring.ftl" as spring>
<#macro layout>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>?</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
        <style>
            .navbar {
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            }
            .main-content {
                margin-top: 80px;
            }
        </style>
    </head>
    <body>
    <!-- Navigation -->
    <nav class="navbar navbar-expand-lg navbar-dark fixed-top">
        <div class="container">
            <a class="navbar-brand" href="#">
                <i class="fas fa-university me-2"></i>Bank Cards
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav me-auto">
                    <li class="nav-item">
                        <a class="nav-link <?active?>" href="user-profile.html"><i class="fas fa-user me-1"></i>Profile</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <?active?>" href="#"><i class="fas fa-file-alt me-1"></i>Applications</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <?active?>" href="user-transactions.html"><i class="fas fa-history me-1"></i>Transactions</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link <?active?>" href="user-transfer.html"><i class="fas fa-exchange-alt me-1"></i>Transfer</a>
                    </li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item dropdown">
                        <a class="nav-link"  href="/logout" onclick="logout()"><i class="fas fa-sign-out-alt me-2"></i>Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="container main-content">
       <#nested spring>
    </div>

    </body>
    </html>
</#macro>