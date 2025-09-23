<#-- Login page using new authentication layout -->
<#include "../layouts/authLayout.ftlh">

<@authLayout title="Sign In" subtitle="Welcome back! Please sign in to your account">
    <form id="loginForm" method="POST" action="/login">
        <!-- Email Field -->
        <div class="form-floating">
            <input type="tel"
                   class="form-control"
                   id="tel"
                   name="username"
                   placeholder="phone number"
                   required
                   autocomplete="tel"
                   autofocus>
            <label for="tel">
                <i class="fas fa-envelope me-2"></i>Phone number
            </label>
        </div>

        <!-- Password Field -->
        <div class="form-floating position-relative">
            <input type="password"
                   class="form-control"
                   id="password"
                   name="password"
                   placeholder="Password"
                   required
                   autocomplete="current-password">
            <label for="password">
                <i class="fas fa-lock me-2"></i>Password
            </label>
            <span class="password-toggle" onclick="togglePassword('password')">
                <i class="fas fa-eye"></i>
            </span>
        </div>

        <!-- Remember Me -->
        <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" value="true" id="rememberMe" name="remember-me">
            <label class="form-check-label" for="rememberMe">
                Remember me on this device
            </label>
        </div>

        <!-- Submit Button -->
        <button class="btn btn-auth" type="submit">
            <i class="fas fa-sign-in-alt me-2"></i>
            Sign In
        </button>

        <!-- Links -->
        <div class="auth-links">
            <div class="row">
                <div class="col-6 text-start">
                    <a href="/auth/forgot_password">
                        <i class="fas fa-key me-1"></i>Forgot Password?
                    </a>
                </div>
                <div class="col-6 text-end">
                    <a href="/auth/register">
                        <i class="fas fa-user-plus me-1"></i>Create Account
                    </a>
                </div>
            </div>
        </div>
    </form>

    <!-- Additional Information -->
    <div class="mt-4 text-center">
        <small class="text-muted">
            <i class="fas fa-shield-alt me-1"></i>
            Your connection is secured with 256-bit SSL encryption
        </small>
    </div>
</@authLayout>