<#-- cirg override of base/login/webauthn-authenticate.ftl (stock 26.4.7).
     Minimal diff from stock (RFC-0006 §2.1): participant intro block above the form,
     aria-hidden on the decorative authenticator-list icon. The hidden webauth/authn_select
     forms, all element ids, the module script, and the stock autofocus are byte-identical. -->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=(realm.registrationAllowed && !registrationDisabled??); section>
    <#if section = "title">
     title
    <#elseif section = "header">
        ${kcSanitize(msg("webauthn-login-title"))?no_esc}
    <#elseif section = "form">

        <div class="${properties.kcFormGroupClass!}">
            <p id="cirg-webauthn-authenticate-instruction" class="${properties.kcInputHelperTextBeforeClass!}">${kcSanitize(msg("cirg-webauthn-authenticate-instruction"))?no_esc}</p>
        </div>

        <div id="kc-form-webauthn" class="${properties.kcFormClass!}">
            <form id="webauth" action="${url.loginAction}" method="post">
                <input type="hidden" id="clientDataJSON" name="clientDataJSON"/>
                <input type="hidden" id="authenticatorData" name="authenticatorData"/>
                <input type="hidden" id="signature" name="signature"/>
                <input type="hidden" id="credentialId" name="credentialId"/>
                <input type="hidden" id="userHandle" name="userHandle"/>
                <input type="hidden" id="error" name="error"/>
            </form>

            <div class="${properties.kcFormGroupClass!} no-bottom-margin">
                <#if authenticators??>
                    <form id="authn_select" class="${properties.kcFormClass!}">
                        <#list authenticators.authenticators as authenticator>
                            <input type="hidden" name="authn_use_chk" value="${authenticator.credentialId}"/>
                        </#list>
                    </form>

                    <#if shouldDisplayAuthenticators?? && shouldDisplayAuthenticators>
                        <#if authenticators.authenticators?size gt 1>
                            <p class="${properties.kcSelectAuthListItemTitle!}">${kcSanitize(msg("webauthn-available-authenticators"))?no_esc}</p>
                        </#if>

                        <div class="${properties.kcFormClass!}">
                            <#list authenticators.authenticators as authenticator>
                                <div id="kc-webauthn-authenticator-item-${authenticator?index}" class="${properties.kcSelectAuthListItemClass!}">
                                    <div class="${properties.kcSelectAuthListItemIconClass!}">
                                        <i class="${(properties['${authenticator.transports.iconClass}'])!'${properties.kcWebAuthnDefaultIcon!}'} ${properties.kcSelectAuthListItemIconPropertyClass!}" aria-hidden="true"></i>
                                    </div>
                                    <div class="${properties.kcSelectAuthListItemBodyClass!}">
                                        <div id="kc-webauthn-authenticator-label-${authenticator?index}"
                                             class="${properties.kcSelectAuthListItemHeadingClass!}">
                                            ${kcSanitize(msg('${authenticator.label}'))?no_esc}
                                        </div>

                                        <#if authenticator.transports?? && authenticator.transports.displayNameProperties?has_content>
                                            <div id="kc-webauthn-authenticator-transport-${authenticator?index}"
                                                 class="${properties.kcSelectAuthListItemDescriptionClass!}">
                                                <#list authenticator.transports.displayNameProperties as nameProperty>
                                                    <span>${kcSanitize(msg('${nameProperty!}'))?no_esc}</span>
                                                    <#if nameProperty?has_next>
                                                        <span>, </span>
                                                    </#if>
                                                </#list>
                                            </div>
                                        </#if>

                                        <div class="${properties.kcSelectAuthListItemDescriptionClass!}">
                                            <span id="kc-webauthn-authenticator-createdlabel-${authenticator?index}">
                                                ${kcSanitize(msg('webauthn-createdAt-label'))?no_esc}
                                            </span>
                                            <span id="kc-webauthn-authenticator-created-${authenticator?index}">
                                                ${kcSanitize(authenticator.createdAt)?no_esc}
                                            </span>
                                        </div>
                                    </div>
                                    <div class="${properties.kcSelectAuthListItemFillClass!}"></div>
                                </div>
                            </#list>
                        </div>
                    </#if>
                </#if>

                <div id="kc-form-buttons" class="${properties.kcFormButtonsClass!}">
                    <input id="authenticateWebAuthnButton" type="button" autofocus="autofocus"
                           value="${kcSanitize(msg("webauthn-doAuthenticate"))}"
                           class="${properties.kcButtonClass!} ${properties.kcButtonPrimaryClass!} ${properties.kcButtonBlockClass!} ${properties.kcButtonLargeClass!}"/>
                </div>
            </div>
        </div>

    <script type="module">
        import { authenticateByWebAuthn } from "${url.resourcesPath}/js/webauthnAuthenticate.js";
        const authButton = document.getElementById('authenticateWebAuthnButton');
        authButton.addEventListener("click", function() {
            const input = {
                isUserIdentified : ${isUserIdentified},
                challenge : '${challenge}',
                userVerification : '${userVerification}',
                rpId : '${rpId}',
                createTimeout : ${createTimeout?c},
                errmsg : "${msg("webauthn-unsupported-browser-text")?no_esc}"
            };
            authenticateByWebAuthn(input);
        }, { once: true });
    </script>

    <#elseif section = "info">
        <#if realm.registrationAllowed && !registrationDisabled??>
            <div id="kc-registration">
                <span>${msg("noAccount")} <a tabindex="6" href="${url.registrationUrl}">${msg("doRegister")}</a></span>
            </div>
        </#if>
    </#if>
</@layout.registrationLayout>
