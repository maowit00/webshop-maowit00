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
