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
