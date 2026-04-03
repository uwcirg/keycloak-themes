A repository of keycloak theme code, mostly for the keycloak.cirg system.

## Themes

This repository contains the following Keycloak themes:

- cirg                                                                                                                                                                                                                                                                                    
- hivsuccess-internal                                                                                                                                                                                                                                                                     
- hivsuccess-internal-dev                                                                                                                                                                                                                                                                 
- hivsuccess-upload                                                                                                                                                                                                                                                                       
- org-test

## Providers

Provider integrations and authentication mechanisms:

- keycloak-restrict-client-auth.jar 

## How to Build and Run

1. Clone the repository:
   ```bash
   git clone https://github.com/uwcirg/keycloak-themes.git
   cd keycloak-themes
   ```
2. Build and send the image to github packages:
   ```bash
   ./gradlew jib
   ```
