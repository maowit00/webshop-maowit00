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
