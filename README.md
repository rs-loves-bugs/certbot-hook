## certbot-le-hook

This is a hook for certbot I use in tandem with a custom Burp Collaborator install. It allows me to automatically renew LetsEncrypt certificates using the Burp Collaborator DNS server.

### Requirements


- a custom Collaborator setup(use the documentation from here to install https://portswigger.net/burp/documentation/collaborator/deploying)
- certbot
- jq

### How to run

```
certbot certonly --manual --manual-auth-hook ./certbot-le-hook.sh --manual-cleanup-hook ./certbot-le-hook.sh -d collaborator.example.com
```
