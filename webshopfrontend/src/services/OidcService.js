import { createOidc } from 'oidc-spa/core';

const config = {
  issuerUri: 'http://localhost:8080/realms/maowit00-organisation',
  clientId: 'webshop-maowit00',
  homeUrl: '/',
  extraQueryParams: () => ({ kc_locale: 'de' })
};

export const oidc = createOidc(config);

export async function getOidc() {
  return await oidc;
}
