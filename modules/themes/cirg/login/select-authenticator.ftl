<#-- cirg override of base/login/select-authenticator.ftl (stock 26.4.7).
     Minimal diff from stock (RFC-0006 §2.1): aria-hidden="true" on the decorative icons
     (stock omits it — NFR-006). All classes remain property-driven via kcSelectAuthList* /
     kcAuthenticator* in theme.properties; markup otherwise byte-identical. -->
<#import "template.ftl" as layout>
<@layout.registrationLayout displayInfo=false; section>
    <#if section = "header" || section = "show-username">
        <#if section = "header">
            ${msg("loginChooseAuthenticator")}
        </#if>
    <#elseif section = "form">

        <form id="kc-select-credential-form" class="${properties.kcFormClass!}" action="${url.loginAction}" method="post">
            <div class="${properties.kcSelectAuthListClass!}">
                <#list auth.authenticationSelections as authenticationSelection>
                    <button class="${properties.kcSelectAuthListItemClass!}" type="submit" name="authenticationExecution" value="${authenticationSelection.authExecId}">

                        <div class="${properties.kcSelectAuthListItemIconClass!}">
                            <i class="${properties['${authenticationSelection.iconCssClass}']!authenticationSelection.iconCssClass} ${properties.kcSelectAuthListItemIconPropertyClass!}" aria-hidden="true"></i>
                        </div>
                        <div class="${properties.kcSelectAuthListItemBodyClass!}">
                            <div class="${properties.kcSelectAuthListItemHeadingClass!}">
                                ${msg('${authenticationSelection.displayName}')}
                            </div>
                            <div class="${properties.kcSelectAuthListItemDescriptionClass!}">
                                ${msg('${authenticationSelection.helpText}')}
                            </div>
                        </div>
                        <div class="${properties.kcSelectAuthListItemFillClass!}"></div>
                        <div class="${properties.kcSelectAuthListItemArrowClass!}">
                            <i class="${properties.kcSelectAuthListItemArrowIconClass!}" aria-hidden="true"></i>
                        </div>
                    </button>
                </#list>
            </div>
        </form>

    </#if>
</@layout.registrationLayout>
