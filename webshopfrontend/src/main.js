import { createApp } from 'vue';
import App from './App.vue';
import 'bootstrap';
import 'bootstrap/dist/css/bootstrap.min.css';
import { library } from '@fortawesome/fontawesome-svg-core';
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome';
import { faHome } from '@fortawesome/free-solid-svg-icons';
import router from './router';

library.add(faHome);

const app = createApp(App)

app.component("font-awesome-icon", FontAwesomeIcon)
app.use(router)
app.mount('#app')
