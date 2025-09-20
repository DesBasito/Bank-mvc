<#import "../layout.ftlh" as main>

<@main.layout ; spring>
    <div class="py-2">
        <div class="row d-flex justify-content-center align-items-center h-100">
            <div class="col-12 col-md-8 col-lg-6 col-xl-5">
                <div class="card bg-white text-black" style="border-radius: 1rem;">
                    <div class="card-body p-5 text-center">
                        <form id="login" class="mt-md-4 pb-5" method="POST" action="/login">

                            <h2 class="fw-bold mb-2 text-uppercase"><@spring.message 'layout.login'/></h2>
                            <p id="login-text" class="text-black-50 mb-5"><@spring.message 'login.enter'/></p>

                            <div class="form-outline form-black mb-4">
                                <input type="email" id="email" class="form-control form-control-lg"
                                       name="username"/>
                                <label class="form-label" for="email"><@spring.message 'register.email'/></label>
                            </div>

                            <div class="form-outline form-black mb-4">
                                <input type="password" id="password" class="form-control form-control-lg"
                                       name="password"/>
                                <label class="form-label" for="password"><@spring.message 'register.userPassword' /></label>
                            </div>
                            <#if _csrf??>
                                <input type="hidden" name="${(_csrf.parameterName)!'csrf-param-name'}"
                                       value="${(_csrf.token)!'csrf-token'}"/>
                            </#if>
                            <button id="submission" class="btn btn-outline-primary btn-lg px-5" type="submit">
                                <@spring.message 'layout.login'/>
                            </button>

                        </form>
                        <div>
                            <p class="mb-0"> <@spring.message 'login.noAccount'/> <a href="/register" class="text-primary-50
                                text-decoration-none fw-bold"><@spring.message 'loginPage.register'/></a>
                            </p>
                        </div>
                        <div>
                             <a href="/forgot_password" class="text-primary-50
                                text-decoration-none fw-bold"><@spring.message 'login.forgot.password'/></a>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>


    <script src="https://code.jquery.com/jquery-3.6.1.min.js"
            integrity="sha256-o88AwQnZB+VDvE9tvIXrMQaPlFFSUTR+nldQm1LuPXQ=" crossorigin="anonymous"></script>
    <script>
        let params = new URLSearchParams(window.location.search);
        if (params.has("error")) {
            window.onload = () => {
                let msg = $('#login-text')

                $(msg).text('Неверный email или пароль...')
                $(msg).addClass('text-danger');
                $(msg).removeClass('text-black-50');
            }
        }

        const checkUser = document.getElementById('submission')
        checkUser.addEventListener('click', () => {
            const userEmail = document.querySelector('[name = "username"]').value;
                localStorage.setItem('user', userEmail)
        })
    </script>
</@main.layout>