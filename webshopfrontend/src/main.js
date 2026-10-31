import { oidcEarlyInit } from 'oidc-spa/entrypoint';

// Optional hardening (freezing network APIs during callback)
const { shouldLoadApp } = oidcEarlyInit({
  BASE_URL: import.meta.env.BASE_URL,
  freezeFetch: true,
  freezeXMLHttpRequest: true
});

// Only load the actual app if we’re not in the OIDC callback processing phase
if (shouldLoadApp) {
  import('./main.lazy.js');
}
