# foundryvtt-docker

This sets up foundry vtt in a docker image via docker compose

You can configure the image with docker secrets by using the options.json as a secret injection.

Example also uses oauth2 proxy to set up a config where you proxy foundry vtt to add extra security

The provided nginx config example was generated with the support of both Oauth2 documentation and the Foundry documentation.
This does not replace the buiilt in authentication of Foundry just adds a proxy in front of it.

nginx is assumed to be managed externaly, but feel free to dockerize that aswell.
