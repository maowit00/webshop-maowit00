# Checklist Week4-2

## Setup KeyCloak

- [ ] Download Zip file

```console
wget https://github.com/keycloak/keycloak/releases/download/26.7.0/keycloak-26.7.0.zip
```

- [ ] Unzip

```console
unzip keycloak-26.7.0.zip
```

- [ ] Launch KeyCloak Server

```console
bin/kc.sh start-dev
```

- [ ] Configure

Realm:

```realm
maowit00-organisation
```

User:

```user
maowit00
```

ClientID:

```clientID
webshop-maowit00
```

- [ ] Configure URLs

- [ ] Root URL:

```Root-URL
http://localhost:[port of your frontend application]

```

- [ ] Valid Redirect URL:

```Redirect-URL
http://localhost:[port of your frontend application]/*
```

- [] Web Origin: `*`

Create the role 'admin' within your client and assign the role to your user. In addition, configure a mapper for your client that makes sure, that client roles are included in the id token.

- [ ] Create `admin`
- [ ] Create a user

- [ ] Setup Script at [/.scripts/setup/keycloak/setup.sh](/.scripts/setup/keycloak/setup.sh)
  - [ ] Link to `/usr/local/bin/keycloak` to the `bin/kc.sh` script

## KeyCloak FrontEnd Integration

- [ ] Add `oidc-spa` dependency to the [package.json](/webshopfrontend/package.json) file

```json
"oidc-spa": "^10.2.11"
```

- [ ] Create [OidcService.js](/webshopfrontend/src/services/OidcService.js)

```javascript
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
```

- [ ] Create [Auth.js](/webshopfrontend/src/composables/Auth.js)

```javascript
import { ref, computed, onMounted } from 'vue';
import { getOidc } from './../services/OidcService';

const oidcRef = ref(null);

async function ensure() {
  if (!oidcRef.value) {
    oidcRef.value = await getOidc();
  }
  return oidcRef.value;
}

export function useAuth() {

  onMounted(async () => {
    try {
      await ensure();
    } catch (error) {
      console.error('useAuth initialization error:', error);
    }
  });

  const isAuthenticated = computed(() => {
    return Boolean(oidcRef.value?.isUserLoggedIn)
  });

  const idToken = computed(() => {
    return oidcRef.value?.getDecodedIdToken() ?? null;
  });

  const checkUserRole = computed(() => {
    return (roleName) => {

      const decodedToken = oidcRef.value?.getDecodedIdToken();
      const clientId = '[your-clientID]';
      const clientRoles = decodedToken.resource_access?.[clientId]?.roles || [];
      return clientRoles.includes(roleName);

    };
  });

  const getAccessToken = async () => {
    return (await oidcRef.value?.getTokens())?.accessToken ?? null;
  };

  const login = async (options = {}) => {
    await oidcRef.value?.login({ ...options });
  };

  const logout = async (options = {}) => {
    await oidcRef.value?.logout({ redirectTo: 'home', ...options });
  };

  return { isAuthenticated, idToken, checkUserRole, getAccessToken, login, logout, ensure };
}
```

- [ ] Rename the file 'main.js' to 'main.lazy.js' and adapt it as follows.

- [ ] Import icons to 'main.lazy.js'

```javascript
import {
    faHome,
    faUser,
    faUserPlus,
    faSignInAlt,
    faSignOutAlt
  } from '@fortawesome/free-solid-svg-icons';

library.add(faHome, faUser, faUserPlus, faSignInAlt, faSignOutAlt);
```

- [ ] Rewrite [main.js](/webshopfrontend/src/main.js)

```javascript
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
```

### Router

- [ ] Add import to [index.js][index.js]

```javascript
import { useAuth } from './../composables/Auth';
```

- [ ] add `iSProtected` meta info to [index.js][index.js]

```javascript
{
  path: "/items/add",
  name: "add-item",
  component: () => import("./../components/AddItem.vue"),
  meta: {
    isProtected: true,
    requiresRole: "admin"
  }
},
```

- [ ] add routes `profile` and `unathorized`

```javascript
{
  path: "/profile",
  name: "profile",
  component: () => import("./../components/UserProfile.vue"),
  meta: {
    isProtected: false
  }
},
{
  path: '/unauthorized',
  name: 'Unauthorized',
  component: () => import('./../components/Unauthorized.vue'),
  meta: {
    isProtected: false
  }
}
```

- [ ] Prior to the statement 'export default router' add the interceptor that checks if the user is allowed to access the selected route:

```javascript
router.beforeEach(async (to, from, next) => {

  if (!to.meta.isProtected) {
    next();
    return;
  }

  try {

    const { isAuthenticated, checkUserRole, login, ensure } = useAuth();

    await ensure();

    if (!isAuthenticated.value) {
      const fullTargetUrl = window.location.origin + to.fullPath;

      await login({
        doesCurrentHrefRequiresAuth: true,
        redirectUrl: fullTargetUrl
      })
      return;
    }

    if (isAuthenticated.value) {
      if (!checkUserRole.value(to.meta.requiresRole)) {
        next({ name: 'Unauthorized' });
      } else {
        next();
      }
    }
  } catch (err) {
    console.error('Auth guard error:', err);
    next(false);
  }
});
```

[index.js]: /webshopfrontend/src/router/index.js

### Components

- [ ] create components 'Unauthorized' [Unauthorized.vue](/webshopfrontend/src/components/Unauthorized.vue)

```vue
<template>
  <div class="vertical-divider-2"/>
  <div>
    <h1>Unauthorized</h1>
    <div>Hello {{ idToken?.name || idToken?.preferred_username }}</div>
    <div>Your account does not have access to that page.</div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue';
import { useAuth } from './../composables/Auth';

const { ensure, idToken } = useAuth();

onMounted(async () => {
  await ensure(); 
});

</script>

<style>
  .vertical-divider-2 {
    height: 100px;
  }
</style>
```

- [ ] create components 'UserProfile' [UserProfile.vue](/webshopfrontend/src/components/UserProfile.vue)

```vue
<template>
  <div class="col-md-12">
    <div class="card card-container">
      <img id="profile-img" src="//ssl.gstatic.com/accounts/ui/avatar_2x.png" class="profile-img-card" />
      <label>
        <strong>{{ idToken?.name }}</strong>
      </label>
      <p>
        <strong>Id:</strong>
        {{ idToken?.preferred_username }}
      </p>
      <p>
        <strong>Email:</strong>
        {{ idToken?.email }}
      </p>
    </div>
  </div>
</template>

<script setup>
import { onMounted } from 'vue';
import { useAuth } from './../composables/Auth';

const { ensure, idToken } = useAuth();

onMounted(async () => {
  await ensure(); // populate user
});

</script>

<style>
label {
  display: block;
  margin-top: 10px;
}

.card-container.card {
  max-width: 350px !important;
  padding: 40px 40px;
}

.card {
  background-color: #f7f7f7;
  padding: 20px 25px 30px;
  margin: 0 auto 25px;
  margin-top: 50px;
  -moz-border-radius: 2px;
  -webkit-border-radius: 2px;
  border-radius: 2px;
  -moz-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
  -webkit-box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
  box-shadow: 0px 2px 2px rgba(0, 0, 0, 0.3);
}

.profile-img-card {
  width: 96px;
  height: 96px;
  margin: 0 auto 10px;
  display: block;
  -moz-border-radius: 50%;
  -webkit-border-radius: 50%;
  border-radius: 50%;
}
</style>
```

- [ ] Modify Navigator in [App.vue](/webshopfrontend/src/App.vue)

```javascript
<template>
  <div id="app">
    <nav class="navbar navbar-expand navbar-dark bg-dark">
      <div class="horizontal-divider" />
      <a href class="navbar-brand" @click.prevent>HS Esslingen</a>
      <div class="navbar-nav me-auto">
        <li class="nav-item">
          <router-link to="/" class="nav-link">
            <font-awesome-icon icon="home" />Home
          </router-link>
        </li>
        <li class="nav-item">
          <router-link to="/items" class="nav-link">Items</router-link>
        </li>
        <li class="nav-item">
          <router-link to="/items/add" class="nav-link">Add Item</router-link>
        </li>
      </div>

      <div v-if="!isAuthenticated" class="navbar-nav ms-auto">
        <li class="nav-item">
          <a class="nav-link" href @click.prevent="handleLogin">
            <font-awesome-icon icon="sign-in-alt" />LogIn
          </a>
        </li>
      </div>

      <div v-if="isAuthenticated" class="navbar-nav ms-auto">
        <li class="nav-item">
          <router-link to="/profile" class="nav-link">
            <font-awesome-icon icon="user" />
            {{ idToken?.name }}
          </router-link>
        </li>
        <li class="nav-item">
          <a class="nav-link" href @click.prevent="handleLogout">
            <font-awesome-icon icon="sign-out-alt" />LogOut
          </a>
        </li>
      </div>
    </nav>

    <div class="container">
      <router-view />
    </div>
  </div>
</template>


<script setup>
import { useAuth } from './composables/Auth';
const { isAuthenticated, idToken, login, logout } = useAuth();

function handleLogin() { login(); }
function handleLogout() { logout(); }
</script>

<style>
.list {
  text-align: left;
  max-width: 750px;
  margin: auto;
}

.horizontal-divider {
  width: 10px;
  height: auto;
  display: inline-block;
}
</style>
```

## Testing

- [ ] Install new frontend dependency

```console
npm install
```

- [ ] Start KeyCloak

- [ ] Start Backend

- [ ] Start Frontend

## Commit

- [ ] Create screenshot [week4-user-profile-view-maowit00][profile-view]

![week4-user-profile-view-maowit00][profile-view]

[profile-view]: /docs/week4-user-profile-view-maowit00.png

- [ ] Stage and commit changes

- [ ] Push

- [ ] Create Pull Request
