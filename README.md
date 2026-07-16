# Keycloak Themes — UW CIRG

Custom Keycloak themes and an authentication provider for UW CIRG's identity systems
(`keycloak.cirg`). Every file here is a Keycloak theme asset — FreeMarker (`.ftl`) templates,
`theme.properties`, i18n `messages_*.properties`, and CSS/JS/image resources — or a packaged
provider JAR. There is no application code; Keycloak loads and renders these at runtime to brand
the login, email, account-admin, and welcome screens.

Built against **Keycloak 26.1** (theme API **v2** / PatternFly 5).

## Repository layout (two branches)

This repo is split across two long-lived branches with **different directory structures**:

| Branch | Purpose | Theme path | Provider path | Build files |
|--------|---------|------------|---------------|-------------|
| **`main`** | Theme **source** — edit here | `themes/<name>/` | `providers/*.jar` | none |
| **`build-jib`** | **Deployable** — build the image here | `modules/themes/<name>/` | `server/providers/` | Gradle + Jib |

A change made to a theme on `main` only ships once it also reaches `build-jib` (under
`modules/themes/`). If you're looking for `build.gradle` and don't find it, you're on `main`.

## Themes

| Theme | Types | Base (`parent`) | Notes |
|-------|-------|-----------------|-------|
| **cirg** | login, email\*, admin, welcome | `base` (login), `keycloak.v2` (admin) | Reusable CIRG base theme **designed for extension** — styled with **Bootstrap 5 + FontAwesome**, which child themes inherit via `parent=cirg`. Shared assets in `cirg/common/`. |
| **org-test** | login, email | `keycloak.v2` / `keycloak` (email) | PatternFly 5 theme; ships full `login.ftl` / `register.ftl` / `template.ftl` overrides. |
| **cnics-leaf** | login, email | `keycloak.v2` / `keycloak` (email) | Copy of `org-test` for the CNICS LEAF deployment; same override set. |
| **hivsuccess-internal** | login, email | `keycloak.v2` / `keycloak` (email) | Overrides only `messages_*.properties` (password-policy copy, site title, email text). |
| **hivsuccess-internal-dev** | login, email | `keycloak.v2` / `keycloak` (email) | Dev variant of the above. |
| **hivsuccess-upload** | login, email | `keycloak.v2` / `keycloak` (email) | Upload-portal variant; messages-only overrides. |

\* `cirg`'s `welcome` and `login` pull shared resources via `import=common/cirg`.

### Two theme families

The themes build on one of two stylistic bases:

1. **`cirg` — a reusable base theme, built for extension.** It extends Keycloak's `base` theme
   and re-skins every `kc*Class` property to **Bootstrap 5** classes, bundling Bootstrap and
   FontAwesome under `cirg/common/resources/` (shared via `import=common/cirg`). The point of
   cirg is reuse: a new theme can set `parent=cirg` to inherit the Bootstrap 5 + FontAwesome
   styling and shared assets, then override only its own branding. See `themes/cirg/README.md`
   for the extension patterns.
2. **`org-test`, `cnics-leaf`, and the three `hivsuccess-*` — PatternFly 5 themes.** These build
   directly on Keycloak's built-in **`keycloak.v2`** theme and `import=common/keycloak` rather
   than on `cirg`. `org-test` is the reference implementation for this group. (cirg remains
   available as the base for any future theme that wants the Bootstrap look.)

## Providers

- **`keycloak-restrict-client-auth.jar`** — a vendored third-party provider
  (`keycloak-restrict-client-auth`) that restricts which users may authenticate against a given
  client. It is a prebuilt binary, not compiled from this repo; `.gitignore` force-includes
  `providers/*.jar` so it stays tracked.

## Local preview

To iterate on a theme without building an image, mount it into a Keycloak container and disable
theme caching so edits show on refresh:

```bash
docker run --rm -p 8080:8080 \
  -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
  -v "$(pwd)/themes:/opt/keycloak/themes" \
  quay.io/keycloak/keycloak:26.1.0 \
  start-dev --spi-theme-cache-themes=false --spi-theme-static-max-age=-1
```

Then, in the admin console, set the realm's Login/Email/Admin/Account theme to the theme you're
editing (**Realm settings → Themes**).

## Adding or customizing a theme

A Keycloak theme is a directory of per-type subfolders (`login/`, `email/`, `admin/`,
`welcome/`), each with a `theme.properties` declaring `parent=` and overriding CSS-class
properties. Keycloak resolves any file a theme doesn't provide by walking the `parent` chain, so
a theme only needs to ship what it actually changes.

Conventions used throughout this repo:

- **Pick the right family.** For CIRG/Bootstrap branding, set `parent=cirg` and reuse
  `common/cirg`. For a PatternFly 5 look, set `parent=keycloak.v2` and `import=common/keycloak`,
  using `org-test` as the reference implementation.
- **Style through properties.** In `.ftl` files reference classes as `${properties.kcSomeClass!}`
  so child themes can re-skin without touching markup.
- **Sanitize dynamic output.** Wrap user/message-derived values as `kcSanitize(...)?no_esc`.
- **`messages_*.properties`** carries per-deployment copy (password rules, email bodies, page
  titles). HTML is allowed; preserve Keycloak's positional args (`{0}`, `{1}`, …). Files are
  UTF-8.
- `theme.properties` list values are space-separated; `\` continues a line. `stylesCommon`
  resolves against the `common/` theme, `styles` against the theme's own `resources/`.

`themes/cirg/README.md` documents the cirg parent theme and its extension patterns in more
detail.
