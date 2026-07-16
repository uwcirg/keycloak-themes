# CIRG Parent Theme for Keycloak

The `cirg` theme is a base parent theme for Keycloak designed to provide a foundational structure for creating customized experiences. It serves as a reusable and extendable template that includes common styles, templates, scripts, and frontend libraries (e.g., Bootstrap and FontAwesome). Future projects can extend this theme to implement custom branding, layout, and functionality while maintaining a consistent core experience.

## Goals

- **Reusability**: Provide a common base theme that can be extended for multiple projects.
- **Customization**: Allow child themes to override and extend specific templates, styles, and resources.
- **Consistency**: Ensure a consistent user experience across all extended themes by using shared resources.

## Directory Structure

The `cirg` theme is organized with a clear directory structure that follows Keycloak's theme conventions:

```plaintext
cirg/                          # Parent theme directory
├── README.md
├── admin/                     # Admin console theme type
│   ├── theme.properties       # parent=keycloak.v2
│   └── messages/
│       └── messages_en.properties
├── common/                    # Shared resources (pulled in via import=common/cirg)
│   └── resources/
│       ├── css/               # Shared CSS (base.css, styles.css, colors.css, ...)
│       ├── img/               # Shared images (logos, backgrounds)
│       ├── lib/               # Frontend libraries
│       │   ├── bootstrap/     # Bootstrap library files
│       │   └── fontawesome/   # FontAwesome library files
│       └── vendor/            # Other vendored code (rfc4648)
├── login/                     # Login theme type
│   ├── theme.properties       # parent=base, import=common/cirg
│   └── template.ftl           # FreeMarker template (templates sit directly here)
└── welcome/                   # Welcome page theme type
    ├── theme.properties       # import=common/cirg
    ├── index.ftl
    ├── messages/
    │   └── messages_en.properties
    └── resources/             # Welcome-specific assets (images, css/welcome.css)
        └── css/
```

Note that `login/` itself holds only `theme.properties` and `template.ftl` — all static
assets (CSS, images, Bootstrap, FontAwesome) live under `common/resources/` and are shared
across the theme types.

## Extending the CIRG Theme for Future Projects

To extend the `cirg` theme for new projects, there are two approaches: overriding the existing files or adding custom files to complement the original theme.

### Approach 1: Simple Overriding of Files

The first and most straightforward method to extend the `cirg` theme is by overriding existing files. This is the standard approach in Keycloak theme customization.

1. **Create a New Theme Directory**:
   - Create a new folder under the `themes` directory (e.g., `my-new-theme`).

2. **Set Up the `theme.properties` File**:
   - In the `my-new-theme/login` directory, create a `theme.properties` file that specifies `cirg` as the parent theme:
     ```properties
     parent=cirg
     internationalizationEnabled=true
     ```

3. **Override Files as Needed**:
   - Place any custom templates, styles, or scripts in the appropriate locations (templates directly in the theme-type directory, static assets under `resources/`). For instance:
      - To override the login page, create a new `login.ftl` file directly in `my-new-theme/login/`.
      - To override the CSS, create a new `style.css` file in `my-new-theme/login/resources/css/`.

4. **Deploy and Test**:
   - Deploy the new theme to the Keycloak `themes` directory and configure the realm to use it. Only the overridden files will replace those from the `cirg` theme.

### Approach 2: Adding Shared Assets via `cirg/common`

The second approach uses the shared-resources mechanism the `cirg` theme is already built on. Shared assets — CSS, images, and frontend libraries (Bootstrap, FontAwesome) — live in `cirg/common/resources/` (`css/`, `img/`, `lib/`, `vendor/`); these are the assets the cirg pages load today.

1. **How the Shared Assets Are Wired**:
   - Each theme type declares `import=common/cirg` in its `theme.properties`, which makes the shared assets in `cirg/common/resources/` available to its pages.
   - Shared stylesheets are listed in the `stylesCommon` property (paths relative to `common/resources/`). For example, from `cirg/login/theme.properties`:
     ```properties
     import=common/cirg

     stylesCommon=lib/fontawesome/css/all.css \
                 lib/bootstrap/css/bootstrap.min.css
     ```

2. **Using the Shared Assets from a Child Theme**:
   - A child theme (`parent=cirg`) declares the same `import=common/cirg` and lists the shared stylesheets it needs in `stylesCommon` — there is no need to copy Bootstrap, FontAwesome, or the shared CSS into the child theme.

3. **Adding New Shared Assets**:
   - If an asset is genuinely shared (useful to cirg itself and to any child theme), add it under `cirg/common/resources/` in the appropriate subdirectory (`css/`, `img/`, `lib/`, `vendor/`) and reference it from `stylesCommon` (or `scripts`) in each theme type that needs it.

4. **Adding Child-Specific (Non-Shared) CSS**:
   - There is currently no additive hook for extra stylesheets. A child theme that sets `styles` in its `theme.properties` **replaces** the parent's `styles` list rather than appending to it — so re-declare cirg's entries and then add your own:
     ```properties
     parent=cirg
     import=common/cirg
     styles=css/styles.css css/my-theme.css
     ```
   - Place the child-specific file under your own theme's `resources/css/`.

5. **Deploy and Test**:
   - Deploy the new theme to the Keycloak `themes` directory and configure the realm to use it. The child theme keeps the shared cirg look while layering its own assets on top.

By choosing either of these approaches, you can effectively extend the `cirg` theme to create a unique and customized user experience in Keycloak, depending on whether you want to override existing functionality or simply add to it.
