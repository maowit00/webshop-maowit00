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
