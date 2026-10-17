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
