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
    <div class="form-group">
      <label for="availability">Availability</label>
      <input class="form-control" id="availability" required v-model="item.availability" name="price" type="text" />
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
