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
