<#-- Register page using new authentication layout -->
<#include "../layouts/authLayout.ftlh">
<@authLayout title="Create Account" subtitle="Join us today! Create your secure banking account" ; spring>
    <form id="registerForm" method="POST" action="/auth/register">
        <!-- First Name -->
        <div class="form-floating">
            <label for="firstName" id="userName">
                <i class="fas fa-user me-2"></i>First Name
            </label>
            <@spring.formInput "userCreationDto.name" 'class="form-control" id="userName" placeholder="First name" aria-label="First name"'/>
            <@spring.showErrors "<br>" "error text-danger"/>
        </div>

        <!-- Last Name -->
        <div class="form-floating">
            <label for="lastName">
                <i class="fas fa-user me-2"></i>Last Name
            </label>
            <@spring.formInput "userCreationDto.surname" 'class="form-control" id="lastName" placeholder="Last name" aria-label="Last name"'/>
            <@spring.showErrors "<br>" "error text-danger"/>
        </div>

        <!-- Middle Name (optional) -->
        <div class="form-floating">
            <label for="middleName">
                <i class="fas fa-user me-2"></i>Middle Name (optional)
            </label>
            <@spring.formInput "userCreationDto.middleName" 'class="form-control" id="middleName" placeholder="Middle name" aria-label="Middle name"'/>
            <@spring.showErrors "<br>" "error text-danger"/>
        </div>

        <!-- Phone Number -->
        <div class="form-floating">
            <label for="phoneNumber">
                <i class="fas fa-phone me-2"></i>Phone Number
            </label>
            <div class="form-text">Format: +7(XXX)XXXXXXX</div>
            <@spring.formInput "userCreationDto.phoneNumber" 'class="form-control" id="phoneNumber" placeholder="Phone number" aria-label="Phone number"'/>
            <@spring.showErrors "<br>" "error text-danger"/>
        </div>

        <!-- Password -->
        <div class="form-floating">
            <label for="password">
                <i class="fas fa-lock me-2"></i>Password
            </label>
            <div class="form-text">
                Password must be between 5 and 11 characters
            </div>
            <@spring.formPasswordInput "userCreationDto.password" 'class="form-control" id="password" placeholder="Password" required autocomplete="new-password"'/>
            <@spring.showErrors "<br>" "error text-danger"/>
        </div>

        <!-- Terms and Conditions -->
        <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="termsAccept" required>
            <label class="form-check-label" for="termsAccept">
                I agree to the <a href="#" class="text-decoration-none">Terms of Service</a>
                and <a href="#" class="text-decoration-none">Privacy Policy</a>
            </label>
        </div>

        <!-- Marketing Emails -->
        <div class="form-check mb-3">
            <input class="form-check-input" type="checkbox" id="marketingEmails">
            <label class="form-check-label" for="marketingEmails">
                I want to receive promotional emails and updates
            </label>
        </div>

        <!-- Submit Button -->
        <button class="btn btn-auth" type="submit">
            <i class="fas fa-user-plus me-2"></i>
            Create Account
        </button>

        <!-- Links -->
        <div class="auth-links">
            <div class="text-center">
                <span class="text-muted">Already have an account?</span>
                <a href="/auth/login" class="ms-2">
                    <i class="fas fa-sign-in-alt me-1"></i>Sign In
                </a>
            </div>
        </div>
    </form>

    <!-- Additional Information -->
    <div class="mt-4 text-center">
        <small class="text-muted">
            <i class="fas fa-shield-alt me-1"></i>
            All personal information is encrypted and securely stored
        </small>
    </div>
</@authLayout>