import { createRouter, createWebHistory } from "vue-router";
import { useAuth } from "./../composables/Auth";

const routes = [
  {
    path: "/items/add",
    name: "add-item",
    component: () => import("./../components/AddItem.vue"),
    meta: {
      isProtected: true,
      requiresRole: "admin",
    },
  },
  {
    path: "/",
    alias: "/items",
    name: "items",
    component: () => import("./../components/ItemList.vue"),
    meta: {
      isProtected: false,
    },
  },
  {
    path: "/items/:id",
    name: "item-details",
    component: () => import("./../components/Item.vue"),
    meta: {
      isProtected: false,
    },
  },
  {
    path: "/items/:id/edit",
    name: "edit-item",
    component: () => import("./../components/EditItem.vue"),
    meta: {
      isProtected: true,
      requiresRole: "admin",
    },
  },
  {
    path: "/profile",
    name: "profile",
    component: () => import("./../components/UserProfile.vue"),
    meta: {
      isProtected: false,
    },
  },
  {
    path: "/unauthorized",
    name: "Unauthorized",
    component: () => import("./../components/Unauthorized.vue"),
    meta: {
      isProtected: false,
    },
  },
];

const router = createRouter({
  history: createWebHistory(),
  routes,
});

router.beforeEach(async (to, from, next) => {
  if (!to.meta.isProtected) {
    next();
    return;
  }

  try {
    const { isAuthenticated, checkUserRole, login, ensure } = useAuth();

    await ensure();

    if (!isAuthenticated.value) {
      const fullTargetUrl = window.location.origin + to.fullPath;

      await login({
        doesCurrentHrefRequiresAuth: true,
        redirectUrl: fullTargetUrl,
      });
      return;
    }

    if (isAuthenticated.value) {
      if (!checkUserRole.value(to.meta.requiresRole)) {
        next({ name: "Unauthorized" });
      } else {
        next();
      }
    }
  } catch (err) {
    console.error("Auth guard error:", err);
    next(false);
  }
});

export default router;
