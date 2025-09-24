<#-- Authentication Layout for login and register pages -->
<#macro authLayout title="" subtitle="">
<#import "/spring.ftl" as spring>
    <!DOCTYPE html>
    <html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title><#if title != "">${title} - </#if>Bank MVC - Secure Banking</title>

        <!-- Bootstrap CSS -->
        <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">

        <!-- Custom Authentication Styles -->
        <style>
            :root {
                --bank-primary: #2c3e50;
                --bank-secondary: #3498db;
                --bank-accent: #e74c3c;
                --bank-success: #27ae60;
                --bank-dark: #1a252f;
            }

            body {
                background: linear-gradient(135deg, var(--bank-dark) 0%, var(--bank-primary) 50%, var(--bank-secondary) 100%);
                min-height: 100vh;
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                position: relative;
                overflow-x: hidden;
            }

            /* Animated background elements */
            body::before {
                content: '';
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background:
                        radial-gradient(circle at 20% 50%, rgba(52, 152, 219, 0.1) 0%, transparent 50%),
                        radial-gradient(circle at 80% 20%, rgba(231, 76, 60, 0.1) 0%, transparent 50%),
                        radial-gradient(circle at 40% 80%, rgba(39, 174, 96, 0.1) 0%, transparent 50%);
                animation: backgroundMove 20s ease-in-out infinite;
                z-index: -1;
            }

            @keyframes backgroundMove {
                0%, 100% {
                    background:
                            radial-gradient(circle at 20% 50%, rgba(52, 152, 219, 0.1) 0%, transparent 50%),
                            radial-gradient(circle at 80% 20%, rgba(231, 76, 60, 0.1) 0%, transparent 50%),
                            radial-gradient(circle at 40% 80%, rgba(39, 174, 96, 0.1) 0%, transparent 50%);
                }
                50% {
                    background:
                            radial-gradient(circle at 80% 20%, rgba(52, 152, 219, 0.15) 0%, transparent 50%),
                            radial-gradient(circle at 20% 80%, rgba(231, 76, 60, 0.15) 0%, transparent 50%),
                            radial-gradient(circle at 60% 40%, rgba(39, 174, 96, 0.15) 0%, transparent 50%);
                }
            }

            .auth-container {
                min-height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px 0;
            }

            .auth-card {
                background: rgba(255, 255, 255, 0.95);
                backdrop-filter: blur(10px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 20px;
                box-shadow:
                        0 20px 40px rgba(0, 0, 0, 0.1),
                        0 0 0 1px rgba(255, 255, 255, 0.05);
                padding: 3rem 2.5rem;
                max-width: 450px;
                width: 100%;
                margin: 0 auto;
                position: relative;
                overflow: hidden;
                animation: cardSlideIn 0.8s ease-out;
            }

            .auth-card::before {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                right: 0;
                height: 4px;
                background: linear-gradient(90deg, var(--bank-secondary), var(--bank-primary), var(--bank-accent));
                border-radius: 20px 20px 0 0;
            }

            @keyframes cardSlideIn {
                from {
                    opacity: 0;
                    transform: translateY(30px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .auth-header {
                text-align: center;
                margin-bottom: 2rem;
            }

            .auth-header h1 {
                color: var(--bank-dark);
                font-size: 2rem;
                font-weight: 700;
                margin-bottom: 0.5rem;
                letter-spacing: -0.5px;
            }

            .auth-header .subtitle {
                color: #6c757d;
                font-size: 1rem;
                font-weight: 400;
            }

            .bank-logo {
                width: 60px;
                height: 60px;
                background: linear-gradient(135deg, var(--bank-secondary), var(--bank-primary));
                border-radius: 50%;
                display: flex;
                align-items: center;
                justify-content: center;
                margin: 0 auto 1rem auto;
                color: white;
                font-size: 24px;
                box-shadow: 0 10px 20px rgba(44, 62, 80, 0.2);
            }

            .form-floating {
                margin-bottom: 1.5rem;
            }

            .form-floating > .form-control {
                height: 60px;
                border: 2px solid #e9ecef;
                border-radius: 12px;
                font-size: 1rem;
                transition: all 0.3s ease;
                background: rgba(255, 255, 255, 0.9);
            }

            .form-floating > .form-control:focus {
                border-color: var(--bank-secondary);
                box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.15);
                background: white;
            }

            .form-floating > label {
                color: #6c757d;
                font-weight: 500;
            }

            .btn-auth {
                width: 100%;
                height: 50px;
                font-size: 1rem;
                font-weight: 600;
                border-radius: 12px;
                border: none;
                background: linear-gradient(135deg, var(--bank-secondary), var(--bank-primary));
                color: white;
                transition: all 0.3s ease;
                position: relative;
                overflow: hidden;
            }

            .btn-auth:hover {
                background: linear-gradient(135deg, #2980b9, #1a252f);
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(52, 152, 219, 0.3);
                color: white;
            }

            .btn-auth:focus {
                color: white;
                box-shadow: 0 0 0 0.2rem rgba(52, 152, 219, 0.25);
            }

            .btn-auth:active {
                transform: translateY(0);
            }

            .auth-links {
                text-align: center;
                margin-top: 2rem;
                padding-top: 1.5rem;
                border-top: 1px solid #e9ecef;
            }

            .auth-links a {
                color: var(--bank-secondary);
                text-decoration: none;
                font-weight: 500;
                transition: all 0.3s ease;
                position: relative;
            }

            .auth-links a:hover {
                color: var(--bank-primary);
                text-decoration: none;
            }

            .auth-links a::after {
                content: '';
                position: absolute;
                width: 0;
                height: 2px;
                bottom: -2px;
                left: 50%;
                background: var(--bank-secondary);
                transition: all 0.3s ease;
                transform: translateX(-50%);
            }

            .auth-links a:hover::after {
                width: 100%;
            }

            .alert {
                border-radius: 12px;
                border: none;
                margin-bottom: 1.5rem;
                font-weight: 500;
            }

            .alert-danger {
                background: rgba(231, 76, 60, 0.1);
                color: var(--bank-accent);
                border-left: 4px solid var(--bank-accent);
            }

            .alert-success {
                background: rgba(39, 174, 96, 0.1);
                color: var(--bank-success);
                border-left: 4px solid var(--bank-success);
            }

            .form-text {
                color: #6c757d;
                font-size: 0.875rem;
                margin-top: 0.5rem;
            }

            .password-toggle {
                position: absolute;
                right: 15px;
                top: 50%;
                transform: translateY(-50%);
                cursor: pointer;
                color: #6c757d;
                z-index: 10;
            }

            .password-toggle:hover {
                color: var(--bank-secondary);
            }

            /* Loading state */
            .btn-auth.loading {
                pointer-events: none;
            }

            .btn-auth.loading::after {
                content: '';
                position: absolute;
                top: 50%;
                left: 50%;
                width: 20px;
                height: 20px;
                margin: -10px 0 0 -10px;
                border: 2px solid transparent;
                border-top-color: white;
                border-radius: 50%;
                animation: spin 1s linear infinite;
            }

            @keyframes spin {
                0% { transform: rotate(0deg); }
                100% { transform: rotate(360deg); }
            }

            /* Responsive adjustments */
            @media (max-width: 576px) {
                .auth-card {
                    margin: 1rem;
                    padding: 2rem 1.5rem;
                }

                .auth-header h1 {
                    font-size: 1.75rem;
                }
            }

            /* Focus ring improvements */
            .form-control:focus,
            .btn:focus {
                outline: none;
            }

            /* Custom scrollbar for webkit browsers */
            ::-webkit-scrollbar {
                width: 8px;
            }

            ::-webkit-scrollbar-track {
                background: rgba(0,0,0,0.1);
            }

            ::-webkit-scrollbar-thumb {
                background: var(--bank-secondary);
                border-radius: 4px;
            }

            ::-webkit-scrollbar-thumb:hover {
                background: var(--bank-primary);
            }
        </style>
    </head>
    <body>
    <div class="auth-container">
        <div class="auth-card">
            <div class="auth-header">
                <div class="bank-logo">
                    <i class="fas fa-university"></i>
                </div>
                <h1>${title}</h1>
                <p class="subtitle">${subtitle}</p>
            </div>

            <#nested spring>
        </div>
    </div>

    <!-- Bootstrap JavaScript -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>

    <!-- Custom Authentication Scripts -->
    <script>
        // Password toggle functionality
        function togglePassword(inputId) {
            const input = document.getElementById(inputId);
            const icon = input.nextElementSibling.nextElementSibling;

            if (input.type === 'password') {
                input.type = 'text';
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            } else {
                input.type = 'password';
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            }
        }

        // Form loading state
        function setFormLoading(formId, isLoading) {
            const form = document.getElementById(formId);
            const button = form.querySelector('.btn-auth');

            if (isLoading) {
                button.classList.add('loading');
                button.disabled = true;
            } else {
                button.classList.remove('loading');
                button.disabled = false;
            }
        }

        // Auto-dismiss alerts
        document.addEventListener('DOMContentLoaded', function() {
            const alerts = document.querySelectorAll('.alert');
            alerts.forEach(alert => {
                setTimeout(() => {
                    if (alert.parentNode) {
                        alert.remove();
                    }
                }, 5000);
            });

            // Add loading state to forms on submit
            const forms = document.querySelectorAll('form');
            forms.forEach(form => {
                form.addEventListener('submit', function() {
                    setFormLoading(form.id, true);
                });
            });
        });

        // URL parameter handling for error messages
        const urlParams = new URLSearchParams(window.location.search);

        if (urlParams.has('error')) {
            const errorDiv = document.createElement('div');
            errorDiv.className = 'alert alert-danger';
            errorDiv.innerHTML = '<i class="fas fa-exclamation-triangle me-2"></i>Invalid email or password. Please try again.';

            const formCard = document.querySelector('.auth-card');
            const header = formCard.querySelector('.auth-header');
            header.insertAdjacentElement('afterend', errorDiv);
        }

        if (urlParams.has('logout')) {
            const successDiv = document.createElement('div');
            successDiv.className = 'alert alert-success';
            successDiv.innerHTML = '<i class="fas fa-check-circle me-2"></i>You have been successfully logged out.';

            const formCard = document.querySelector('.auth-card');
            const header = formCard.querySelector('.auth-header');
            header.insertAdjacentElement('afterend', successDiv);
        }

        if (urlParams.has('registered')) {
            const successDiv = document.createElement('div');
            successDiv.className = 'alert alert-success';
            successDiv.innerHTML = '<i class="fas fa-check-circle me-2"></i>Registration successful! Please log in.';

            const formCard = document.querySelector('.auth-card');
            const header = formCard.querySelector('.auth-header');
            header.insertAdjacentElement('afterend', successDiv);
        }
    </script>
    </body>
    </html>
</#macro>