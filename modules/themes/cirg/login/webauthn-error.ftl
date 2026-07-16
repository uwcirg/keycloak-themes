<#-- cirg override of base/login/webauthn-error.ftl (stock 26.4.7).
     Minimal diff from stock (RFC-0006 §2.1): plain-language recovery block, plus a secondary
     "back to sign in" link. The stock retry mechanism (refreshPage() script,
     #kc-error-credential-form, #kc-try-again) is byte-identical. The raw error detail itself
     arrives via message.summary and is demoted in the message bundle, not here. -->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayMessage=true; section>
    <#if section = "header">
        ${kcSanitize(msg("webauthn-error-title"))?no_esc}
    <#elseif section = "form">

        <div class="${properties.kcFormGroupClass!}">
            <p id="cirg-webauthn-error-help" class="${properties.kcInputHelperTextBeforeClass!}">${kcSanitize(msg("cirg-webauthn-error-help"))?no_esc}</p>
        </div>

        <script type="text/javascript">
            refreshPage = () => {
                document.getElementById('isSetRetry').value = 'retry';
                document.getElementById('executionValue').value = '${execution}';
                document.getElementById('kc-error-credential-form').requestSubmit();
            }
        </script>

        <form id="kc-error-credential-form" class="${properties.kcFormClass!}" action="${url.loginAction}"
              method="post">
            <input type="hidden" id="executionValue" name="authenticationExecution"/>
            <input type="hidden" id="isSetRetry" name="isSetRetry"/>
        </form>

        <input tabindex="4" onclick="refreshPage()" type="button"
               class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
               name="try-again" id="kc-try-again" value="${kcSanitize(msg("doTryAgain"))?no_esc}"
        />

        <a id="kc-back-to-login" href="${url.loginUrl}"
           class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!} ${properties.kcMarginTopClass!}">${kcSanitize(msg("cirg-webauthn-back-to-login"))?no_esc}</a>

        <#if isAppInitiatedAction??>
            <form action="${url.loginAction}" class="${properties.kcFormClass!}" id="kc-webauthn-settings-form" method="post">
                <button type="submit"
                        class="${properties.kcButtonClass!} ${properties.kcButtonDefaultClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"
                        id="cancelWebAuthnAIA" name="cancel-aia" value="true">${msg("doCancel")}
                </button>
            </form>
        </#if>

    </#if>
</@layout.registrationLayout>
