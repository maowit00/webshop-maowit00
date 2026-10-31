import axios from "axios";
import { useAuth } from './composables/Auth';

const instance = axios.create({
  baseURL: "http://localhost:8245/api-maowit00/item-management/v1",
  headers: {
    "Content-type": "application/json"
  }
});

instance.interceptors.request.use(async config => {
  const { getAccessToken, ensure, isAuthenticated } = useAuth();

  await ensure();

  if (isAuthenticated.value) {

    const token = await getAccessToken();

    if (token) {
      config.headers['Authorization'] = 'Bearer ' + token;
    }
  }

  return config;

});

export default instance;
