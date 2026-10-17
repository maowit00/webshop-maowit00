# ToDos Week3-1

## Branching

- [x] Create branch week3-1

## Frontend

### Install DevTools

- [x] Install nodejs
- [x] Install npm
- [x] Installer Scripts of course

### Setup Project

- [x] Create frontend directory `webshopfrontend`
- [x] Create vue.js project with vite
- [x] Init script

```options
Chose the following options:
Ok to proceed? (y) y
Project name: webshopfrontend
Select a framework: Vue
Select a variant: JavaScript
Use Vite 8 beat (Experimental)?: no
Install with npm and start now?: yes
```

- [x] Add webpage icon from <https://moodle.hs-esslingen.de/moodle/pluginfile.php/739044/mod_page/content/33/hs-esslingen.png> at [webshopfrontend/src/assets](/webshopfrontend/src/assets)
  - [x] Use the one from public webpage <https://www.hs-esslingen.de/_assets/a56ae91e12d607d39339b1d55834c4d9/Images/favicon/favicon.ico>
  - An `.ico` should be as good as an `.png` for `16x16` icon.

```console
curl -L --create-dirs -o webshopfrontend/src/assets/hs-esslingen.ico "https://www.hs-esslingen.de/_assets/a56ae91e12d607d39339b1d55834c4d9/Images/favicon/favicon.ico"
```

### Extend Template

- [x] Modify [/webshopfrontend/index.html](/webshopfrontend/index.html)

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <link rel="icon" type="image/png" href="./src/assets/hs-esslingen.ico" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>HS Esslingen Webshop</title>
  </head>
  <body>
    <div id="app"></div>
    <script type="module" src="/src/main.js"></script>
  </body>
</html>
```

- [x] Modify project config at [vite.config.js](/webshopfrontend/vite.config.js)

Replace with unique number.

```javascript
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig({
  plugins: [vue()],
  server: {
    port: 8145,
  }
})
```

- [x] Modify [main.js](/webshopfrontend/src/main.js)

```javascript
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
```

- [x] Modify [App.vue](/webshopfrontend/src/App.vue)

```vue
<template>
  <div id="app">
    <nav class="navbar navbar-expand navbar-dark bg-dark">
      <div class="horizontal-divider"/>
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
    </nav>
    <div class="container">
      <router-view />
    </div>
  </div>
</template>

<script setup>
</script>
  
<style>
.list {
  text-align: left;
  max-width: 750px;
  margin: auto;
}
.horizontal-divider{
    width:10px;
    height:auto;
    display:inline-block;
  }
</style>
```

- [x] Create [webshopfrontend/src/router/index.js](/webshopfrontend/src/router/index.js)

> Still in the same folder, create the folder 'router' and within this folder the file 'index.js' that contains the following code.

```vue
import { createRouter, createWebHistory } from 'vue-router';

const routes = [
  {
    path: "/items/add",
    name: "add-item",
    component: () => import("./../components/AddItem.vue")
  },
  {
    path: "/",
    alias: "/items",
    name: "items",
    component: () => import("./../components/ItemList.vue")
  },
  {
    path: "/items/:id",
    name: "item-details",
    component: () => import("./../components/Item.vue")
  },
  {
    path: "/items/:id/edit",
    name: "edit-item",
    component: () => import("./../components/EditItem.vue")
  }
];


const router = createRouter({
  history: createWebHistory(),
  routes
})

export default router
```

- [x] Delete [HelloWorld.vue](/webshopfrontend/src/components/HelloWorld.vue)

- [x] Create [Item.vue](/webshopfrontend/src/components/Item.vue)

```vue
<template>
  <div class="vertical-divider" />
  <div v-if="currentItem" class="view-form">
    <form>
      <div class="form-group">
        <div>Title</div>
        <div>{{ currentItem.title }}</div>
      </div>
      <div class="form-group">
        <div>Description</div>
        <div>{{ currentItem.description }}</div>
      </div>
      <div class="form-group">
        <div>Price</div>
        <div>{{ currentItem.price }}</div>
      </div>
    </form>
    <button type="edit" class="btn btn-success" @click="editItem">
      Edit
    </button>
  </div>
  <div v-else>
    <p>{{ message }}</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import ItemDataService from "../services/ItemDataService";

const currentItem = ref(null);
const message = ref('');

const route = useRoute();
const router = useRouter();

const editItem = () => {
  router.push({ name: "edit-item" });
};

onMounted(async () => {
  message.value = '';
  try {
    const response = await ItemDataService.get(route.params.id);
    currentItem.value = response.data;
  } catch (e) {
    console.log(e);
    message.value = 'Data could not be loaded.';
  }
});
</script>

<style>
.view-form {
  max-width: 300px;
  margin: auto;
}

.form-group {
  margin-bottom: 10px;
}

.vertical-divider {
  height: 10px;
}
</style>
```

- [x] Create [ItemList.vue](/webshopfrontend/src/components/ItemList.vue)

```vue
<template>
  <div class="vertical-divider" />
  <div class="list row">
    <div class="col-md-8">
      <div class="input-group mb-3">
        <input type="text" class="form-control" placeholder="Search by title" v-model="title" />
        <div class="horizontal-divider" />
        <div class="input-group-append">
          <button class="btn btn-outline-secondary" type="button" @click="searchTitle">
            Search
          </button>
        </div>
      </div>
    </div>
    <div class="col-md-8">
      <h4>Search Result</h4>
      <ul class="list-group">
        <li class="list-group-item" v-for="(item, index) in items" :key="index">
          <router-link :to="{ path: '/items/' + item.id }" append>{{ item.title }}</router-link>
          <div>
            {{ item.description }}
            <div>
              {{ "Price: " + item.price }}
            </div>
          </div>
        </li>
      </ul>
      <p>{{ message }}</p>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import ItemDataService from "../services/ItemDataService";

const items = ref([]);
const title = ref("");
const message = ref("");

async function retrieveItems() {
  try {
    const response = await ItemDataService.getAll();
    items.value = response.data;
  } catch (e) {
    console.log(e);
    message.value = 'Data could not be loaded.';
  }
}

async function searchTitle() {
  if (!title.value) {
    retrieveItems();
    return;
  }
  try {
    const response = await ItemDataService.findByTitle(title.value);
    items.value = response.data;
  } catch (e) {
    console.log(e);
    message.value = 'Data could not be loaded.';
  }
}

onMounted(() => {
  retrieveItems();
});
</script>

<style>
.list {
  text-align: left;
  max-width: 750px;
  margin: auto;
}

.list-group-item {
  margin-bottom: 10px;
}

.horizontal-divider {
  width: 10px;
  height: auto;
  display: inline-block;
}

.vertical-divider {
  height: 10px;
}
</style>
```

- [x] Create [AddItem.vue](/webshopfrontend/src/components/AddItem.vue)

```vue
<template>
  <div class="vertical-divider" />
  <div class="submit-form">
    <div class="form-group">
      <label for="title">Title</label>
      <input class="form-control" id="title" required v-model="item.title" name="title" type="text" />
    </div>
    <div class="form-group">
      <label for="description">Description</label>
      <textarea class="form-control" id="description" required v-model="item.description" name="description"
        rows="3"></textarea>
    </div>
    <div class="form-group">
      <label for="price">Price</label>
      <input class="form-control" id="price" required v-model="item.price" name="price" type="text" />
    </div>

    <button @click="saveItem" class="btn btn-success">Submit</button>
    <p>{{ message }}</p>
  </div>
</template>

<script setup>
import { reactive, ref } from 'vue';
import ItemDataService from "../services/ItemDataService";

const item = reactive({
  id: null,
  title: "",
  description: "",
  price: ""
});

const message = ref("");

async function saveItem() {
  const data = {
    title: item.title,
    description: item.description,
    price: item.price
  };

  try {
    const response = await ItemDataService.create(data);
    item.id = response.data.id;

    item.title = "";
    item.description = "";
    item.price = "";

    message.value = 'Item added successfully';
  } catch (error) {
    console.log(error);
    message.value = 'The item could not be added';
  }
}
</script>

<style>
.submit-form {
  max-width: 300px;
  margin: auto;
}

.form-group {
  margin-bottom: 10px;
}

.vertical-divider {
  height: 10px;
}
</style>
```

- [x] Create [EditItem.vue](/webshopfrontend/src/components/EditItem.vue)

```vue
<template>
  <div class="vertical-divider" />
  <div v-if="currentItem" class="edit-form">
    <form>
      <div class="form-group">
        <label for="title">Title</label>
        <input type="text" class="form-control" id="title" v-model="currentItem.title" />
      </div>
      <div class="form-group">
        <label for="description">Description</label>
        <textarea type="text" class="form-control" id="description" v-model="currentItem.description" />
      </div>
      <div class="form-group">
        <label for="price">Price</label>
        <input type="text" class="form-control" id="price" v-model="currentItem.price" />
      </div>
    </form>
    <button type="submit" class="btn btn-success" @click="updateItem">
      Update
    </button>
    <div class="horizontal-divider" />
    <button class="btn btn-danger mr-2" @click="deleteItem">
      Delete
    </button>
    <p>{{ message }}</p>
  </div>
  <div v-else>
    <p>{{ message }}</p>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import ItemDataService from "../services/ItemDataService";

const route = useRoute();
const router = useRouter();

const currentItem = ref(null);
const message = ref('');

async function updateItem() {
  if (!currentItem.value) return;
  try {
    await ItemDataService.update(currentItem.value.id, currentItem.value);
    router.push({ name: "item-details" });
  } catch (error) {
    console.log(error);
    message.value = 'The item could not be updated';
  }
}

async function deleteItem() {
  if (!currentItem.value) return;
  try {
    await ItemDataService.delete(currentItem.value.id);
    router.push({ name: "items" });
  } catch (error) {
    console.log(error);
    message.value = 'The item could not be deleted';
  }
}

onMounted(async () => {
  message.value = '';
  try {
    const response = await ItemDataService.get(route.params.id);
    currentItem.value = response.data;
  } catch (error) {
    console.log(error);
    message.value = 'Data could not be loaded.';
  }
});
</script>

<style>
.edit-form {
  max-width: 300px;
  margin: auto;
}

.form-group {
  margin-bottom: 10px;
}

.vertical-divider {
  height: 10px;
}
</style>
```

- [x] Create [webshopfrontend/src/services](/webshopfrontend/src/services) directory.

- [x] Create [ItemDataService.js](/webshopfrontend/src/services/ItemDataService.js)

```javascript
import http from "../http-common";

class ItemDataService {
  getAll() {
    return http.get("/items");
  }

  get(id) {
    return http.get(`/items/${id}`);
  }

  create(data) {
    return http.post("/items", data);
  }

  update(id, data) {
    return http.put(`/items/${id}`, data);
  }

  delete(id) {
    return http.delete(`/items/${id}`);
  }

  deleteAll() {
    return http.delete(`/items`);
  }

  findByTitle(title) {
    return http.get(`/items?title=${title}`);
  }
}

export default new ItemDataService();
```

- [x] Create [http-common.js](/webshopfrontend/src/http-common.js)

```javascript
import axios from "axios";

export default axios.create({
  baseURL: "http://localhost:8245/api-maowit00/item-management",
  headers: {
    "Content-type": "application/json"
  }
});
```

- [x] Modify [package.json](/webshopfrontend/package.json) to add dependencies.

```json
{
  "name": "webshop-frontend",
  "private": true,
  "version": "0.0.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vite build",
    "preview": "vite preview"
  },
  "dependencies": {
    "vue": "^3.5.25",
    "axios": "^1.20.0",
    "bootstrap": "^5.3.8",
    "vue-router": "^5.3.1",
    "@fortawesome/fontawesome-svg-core": "^7.3.1",
    "@fortawesome/free-solid-svg-icons": "^7.3.1",
    "@fortawesome/vue-fontawesome": "^3.3.3"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^6.0.2",
    "vite": "^7.3.1"
  }
}
```

- [x] Configure Backend with `@CrossOrigin` Annotation at [webshopbackend/src/main/java/de/hsesslingen/webshopbackend/controller/ItemController.java](/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/controller/ItemController.java)

```java
import org.springframework.web.bind.annotation.CrossOrigin;
...
@CrossOrigin(origins = "http://localhost:8145")
public class ItemController {
...
```

## Testing Changes

- [x] Install Frontend dependencies

```console
npm install
```

- [x] Check frontend testing server

```console
npm run dev
```

- [ ] Check changes at <http://localhost:8145>

- [ ] Screenshot under the path [doc/week3-items-list-view-maowit00.png](/doc/week3-items-list-view-maowit00.png)

![doc/week3-items-list-view-maowit00.png](/doc/week3-items-list-view-maowit00.png)

- [ ] Commit changes

- [ ] Push and create merge request with viewier notification.
