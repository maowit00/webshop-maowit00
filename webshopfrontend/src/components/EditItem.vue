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
