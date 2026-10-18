# ToDos: Week3-2

Extend Project with `availability` Attribute for listed items in the webshop

## Migrate DB

- [x] Migrate existing data base with the new scheme.

```SQL
CREATE TABLE item (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL,
    availability INTEGER NOT NULL
);
```

Migrating by altering table

```SQL
ALTER TABLE item ADD COLUMN availability INTEGER NOT NULL DEFAULT 10;
```

The altered table must have a value. But this can be removed afterwards

```SQL
ALTER TABLE item ALTER COLUMN availability DROP DEFAULT;
```

But this is already not real data anyhow.

- [x] Update SQL init scripts

## Update Backend

### Model

- [x] Modify Model to account for the new table shape

- [x] Extend Model [webshopbackend/src/main/java/de/hsesslingen/webshopbackend/model/Item.java](/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/model/Item.java)- [ ] Add availability Attribute

```java
    @Column(name = "availability")
    private Integer availability;
```

- [x] Update Constructor

```java
public Item(String title, String description, BigDecimal price, Integer availability) {
    this.title = title;
    this.description = description;
    this.price = price;
    this.availability = availability;
}
```

- [x] Add getter method

```java
public Integer getAvailability() {
    return this.availability;
}
```

- [x] Add setter method

```java
public void setAvailability(Integer availability) {
    this.availability = availability;
}
```

- [x] Update String Representation

```java
@Override
public String toString() {
    return "Tutorial [id=" + id + ", title=" + title + ", desc=" + description + ", price=" + price + ", availability=" + availability + "]";
}
```

### Controller

- [x] Update Backend [ItemController.java](/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/controller/ItemController.java)

- [x] Update POST Mapping to account for the new attribute

```java
@PostMapping("/items")
public ResponseEntity<Item> createItem(@RequestBody Item item) {
    try {
        Item _item = itemRepository
                .save(new Item(item.getTitle(), item.getDescription(), item.getPrice(), item.getAvailability()));
        return new ResponseEntity<>(_item, HttpStatus.CREATED);
    } catch (Exception e) {
        return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
    }
}
```

- [x] Update PUT Mapping

```java
@PutMapping("/items/{id}")
public ResponseEntity<Item> updateItem(@PathVariable("id") long id, @RequestBody Item item) {
    Optional<Item> itemData = itemRepository.findById(id);

    if (itemData.isPresent()) {
        Item _item = itemData.get();
        _item.setTitle(item.getTitle());
        _item.setDescription(item.getDescription());
        _item.setPrice(item.getPrice());
        _item.setAvailability(item.getAvailability());
        return new ResponseEntity<>(itemRepository.save(_item), HttpStatus.OK);
    } else {
        return new ResponseEntity<>(HttpStatus.NOT_FOUND);
    }
}
```

### Test Backend

- [x] Check if mvn project still builds

```console
mvn spring-boot:run
```

- [x] See at <http://localhost:8245/api-maowit00/item-management/items>

### Update Frontend

- [x] Update Frontend user interface to insert availability info.

## [Item.vue](/webshopfrontend/src/components/Item.vue)

- [x] Extend [Item.vue](/webshopfrontend/src/components/Item.vue) with availability div

```vue
      <div class="form-group">
        <div>Availability</div>
        <div>{{ currentItem.availability }}</div>
      </div>
```

## [ItemList.vue](/webshopfrontend/src/components/ItemList.vue)

- [x] Extend [ItemList.vue](/webshopfrontend/src/components/ItemList.vue)

```vue
<div>
  {{ "Availability: " + item.availability }}
</div>
```

## [EditItem.vue](/webshopfrontend/src/components/EditItem.vue)

- [x] Extend [EditItem.vue](/webshopfrontend/src/components/EditItem.vue)

```vue
      <div class="form-group">
        <label for="availability">Availability</label>
        <input type="text" class="form-control" id="availability" v-model="currentItem.availability" />
      </div>
```

## [AddItem.vue](/webshopfrontend/src/components/AddItem.vue)

- [x] Extend [AddItem.vue](/webshopfrontend/src/components/AddItem.vue)

```vue
    <div class="form-group">
      <label for="availability">Availability</label>
      <input class="form-control" id="availability" required v-model="item.availability" name="price" type="text" />
    </div>
```

### Testing

- [x] Check frontend server

```console
npm run dev
```

- [x] Go to <http://localhost:8145>

## Committing

- [x] Check if everything works
  - [x] Launch backend/frontend
  - [x] Go to <http://localhost:8145>

- [ ] Some Screenshots
  - [ ] item view
  - [ ] item view
  - [ ] item view

- [ ] Commit, Push and Ask for Merge
