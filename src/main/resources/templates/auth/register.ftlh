<#import "../layout.ftlh" as register>
<@register.layout ; spring>
    <main>
        <#if _csrf??>
            <form action="/register" method="post">
                <fieldset>
                    <p>Registration</p>
                    <div class="form-element">
                        <div class="row gx-5 gy-3">
                            <div class="col-6">
                                <label for="userName" class="form-label"><@spring.message 'register.userName'/></label>
                                <@spring.formInput "userCreationDto.name" 'class="form-control" id="userName" placeholder="First name"aria-label="First name"'/>
                                <@spring.showErrors "<br>" "error text-danger"/>

                            </div>
                            <div class="col-6">
                                <label for="surname" class="form-label"><@spring.message 'register.surname'/></label>
                                <@spring.formInput "userCreationDto.surname" 'class="form-control" id="surname" placeholder="Surname" aria-label="surname"'/>
                                <@spring.showErrors "<br>" "error text-danger"/>

                            </div>
                            <div class="col-6">
                                <label for="email" class="form-label"><@spring.message 'register.email'/></label>
                                <@spring.formInput "userCreationDto.email" 'class="form-control" id="email" placeholder="email" aria-label="Email"'/>
                                <@spring.showErrors "<br>" "error text-danger"/>

                            </div>
                            <div class="col-6">
                                <label for="password" class="form-label"><@spring.message 'register.userPassword'/></label>
                                <@spring.formPasswordInput "userCreationDto.password" 'class="form-control" id="password" placeholder="password" aria-label="password"'/>
                                <@spring.showErrors "<br>" "error text-danger"/>

                            </div>
                            <div class="col-3">
                                <label for="age" class="form-label"><@spring.message 'register.age'/></label>
                                <@spring.formInput "userCreationDto.age" 'class="form-control" id ="age" placeholder="age" aria-label="age"'/>
                                <@spring.showErrors "<br>" "error text-danger"/>

                            </div>
                            <div class="col-9">
                                <label for="phoneNum" class="form-label"><@spring.message 'register.phone'/></label>
                                <@spring.formInput "userCreationDto.phoneNumber" 'class="form-control" id="phoneNum" placeholder="phone number" aria-label="phoneNumber"'/>
                                <@spring.showErrors "<br>" "error text-danger"/>

                            </div>
                        </div>
                    </div>
                    <div class="form-element mb-4">
                        <label for="account-type" class="form-label"><@spring.message 'register.role'/></label>
                        <select name="accType" id="account-type" class="form-control" required>
                            <option value=2>applicant</option>
                            <option value=1>employer</option>
                        </select>
                    </div>
                    <input type="hidden" name="${(_csrf.parameterName)!'csrf'}"
                           value="${(_csrf.token)!'--no-token--'}"/>
                    <button class="btn btn-primary" type="submit"><@spring.message 'layout.register'/>!</button>

                    <a class="btn btn-warning btn-link text-decoration-none text-dark"
                       onclick="window.location.href='/login'">
                        <@spring.message 'register.have.account'/>
                    </a>
                </fieldset>
            </form>
        </#if>
    </main>
</@register.layout>