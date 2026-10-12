# ToDos Week2-1

## New Branch

- [ ] Create branch `week2-1`

- From terminal:

```console
git switch -c week2-1 week1
```

> You should be already on branch `week1` unless you've been messing around with git.

- Or from GUI (vscode):
  - Open command window `Ctrl + Shift + P`
  - look for create branch by typing `branch`
  - Not as cool :/

## Install Java Deps (Backend)

- [ ] Install Java OpenJDK and Maven

```console
sudo apt update
sudo apt install -y openjdk-21-jdk maven
```

See script at [/.scripts/setup/java/install.sh](/.scripts/setup/java/install.sh) (not really useful to look at)

## Get Template

- [ ] [Create Spring Boot Template](https://start.spring.io/)

Create spring boot project

- Open the spring initializer: <https://start.spring.io/>

- For project choose the option 'Maven'
- For language the option 'Java'
- And for Spring Boot the option '4.1.1'. Fill in the following metadata:
  - Group: 'de.hsesslingen'
  - Artifact: 'webshopbackend'
  - Package name: 'de.hsesslingen.webshopbackend'
  - Packaging: 'jar'
  - Configuration: 'Properties'
  - Java: '21'
- Click 'Dependencies' and choose the following options:
  - Spring Web
  - Spring Data JPA
  - H2 Database

- [ ] Script pls, [fetch spring boot template curl](/.scripts/project/spring-boot/setup/fetch-template.sh)

## Extend Backend from Template

- [ ] Create [.....model/Item.java](/webshop-backend/src/main/java/de/hsesslingen/webshopbackend/model/Item.java)

- [ ] Create [..... controller/ItemController.java](/webshop-backend/src/main/java/de/hsesslingen/webshopbackend/controller/ItemController.java)

- [ ] Create [..... repository/ItemRepository.java](/webshop-backend/src/main/java/de/hsesslingen/webshopbackend/repository/ItemRepository.java)

---

- [ ] Create [/webshop-backend/src/main/java/de/hsesslingen/webshopbackend/model/Item.java](/webshop-backend/src/main/java/de/hsesslingen/webshopbackend/model/Item.java)

```java
package de.hsesslingen.webshopbackend.model;

import jakarta.persistence.*;
import java.math.BigDecimal; 

@Entity
@Table(name = "item")
public class Item {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private long id;

    @Column(name = "title")
    private String title;

    @Column(name = "description")
    private String description;

    @Column(name = "price")
    private BigDecimal price;

    public Item() {

    }

    public Item(String title, String description, BigDecimal price) {
        this.title = title;
        this.description = description;
        this.price = price;
    }

    public long getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "Tutorial [id=" + id + ", title=" + title + ", desc=" + description + ", price=" + price + "]";
    }

}
```

- [ ] Create [/webshop-backend/src/main/java/de/hsesslingen/webshopbackend/controller/ItemController.java](/webshop-backend/src/main/java/de/hsesslingen/webshopbackend/controller/ItemController.java)
  - [ ] Replace `[your-hs-esslingen-user-name]` with username!

```java
package de.hsesslingen.webshopbackend.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import de.hsesslingen.webshopbackend.model.Item;
import de.hsesslingen.webshopbackend.repository.ItemRepository;

@RestController
@RequestMapping("/api-maowit00/item-management/")
public class ItemController {

    @Autowired
    ItemRepository itemRepository;

    @GetMapping("/items")
    public ResponseEntity<List<Item>> getAllItems(@RequestParam(required = false) String title) {
        
        try {
            List<Item> items = new ArrayList<Item>();

            if (title == null)
                itemRepository.findAll().forEach(items::add);
            else
                itemRepository.findByTitleContaining(title).forEach(items::add);

            if (items.isEmpty()) {
                return new ResponseEntity<>(HttpStatus.NO_CONTENT);
            }

            return new ResponseEntity<>(items, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @GetMapping("/items/{id}")
    public ResponseEntity<Item> getItemById(@PathVariable("id") long id) {
        Optional<Item> itemData = itemRepository.findById(id);

        if (itemData.isPresent()) {
            return new ResponseEntity<>(itemData.get(), HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @PostMapping("/items")
    public ResponseEntity<Item> createItem(@RequestBody Item item) {
        try {
            Item _item = itemRepository
                    .save(new Item(item.getTitle(), item.getDescription(), item.getPrice()));
            return new ResponseEntity<>(_item, HttpStatus.CREATED);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/items/{id}")
    public ResponseEntity<Item> updateItem(@PathVariable("id") long id, @RequestBody Item item) {
        Optional<Item> itemData = itemRepository.findById(id);

        if (itemData.isPresent()) {
            Item _item = itemData.get();
            _item.setTitle(item.getTitle());
            _item.setDescription(item.getDescription());
            _item.setPrice(item.getPrice());
            return new ResponseEntity<>(itemRepository.save(_item), HttpStatus.OK);
        } else {
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    @DeleteMapping("/items/{id}")
    public ResponseEntity<HttpStatus> deleteItem(@PathVariable("id") long id) {
        try {
            itemRepository.deleteById(id);
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @DeleteMapping("/items")
    public ResponseEntity<HttpStatus> deleteAllItems() {
        try {
            itemRepository.deleteAll();
            return new ResponseEntity<>(HttpStatus.NO_CONTENT);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }

    }

}
```

- [ ] Create [/webshop-backend/src/main/java/de/hsesslingen/webshopbackend/repository/ItemRepository.java](/webshop-backend/src/main/java/de/hsesslingen/webshopbackend/repository/ItemRepository.java)

```java
package de.hsesslingen.webshopbackend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import de.hsesslingen.webshopbackend.model.Item;

public interface ItemRepository extends JpaRepository<Item, Long> {
  
  List<Item> findByTitleContaining(String title);
  
}
```

## Config Properties

- [ ] Edit [webshop-backend/src/main/resources](/webshop-backend/src/main/resources/application.properties)
  - [ ] Replace `[your-hs-esslingen-user-name]` with username
  - [ ] Come up with an original password.
  - [ ] Check a unique number

In the folder `~/lab/[your-project-folder]/webshop-backend/src/main/resources` modify the file application.properties to use the code shown below. Note that you have to fill in appropriate values for the parameters given in `[]`. You can find your unique number in the ReadMe file of your project.

```properties
server.port=8245
spring.h2.console.enabled=true
spring.h2.console.path=/h2-ui
 
spring.datasource.url=jdbc:h2:mem:itemdb
spring.datasource.driverClassName=org.h2.Driver
spring.datasource.username=webshop-maowit00
spring.datasource.password=not-hs-password
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.H2Dialect
spring.jpa.hibernate.ddl-auto= update
```

## Test

- [ ] Test
  - cd into `webshop-backend`

```console
mvn spring-boot:run
```

- [ ] Insert dummy data into h2-ui

- [ ] Go to <http://localhost:8245/h2-ui>

In the browser navigate to `http://localhost:82[your-unique-number]/h2-ui/` to start the UI for the in memory database.

Use the parameters defined in the file application properties.

- JDBC URL:

```url
jdbc:h2:mem:itemdb
```

- User name:

```username
webshop-maowit00
```

- Password:

```password
not-hs-password
```

Add one or multiple entries to the table item.

- [ ] Create Database

```SQL
CREATE TABLE item (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    description TEXT,
    price NUMERIC(10, 2) NOT NULL
);
```

- [ ] Insert SQL Values

```SQL
INSERT INTO item (title, description, price) VALUES ('Principles of transaction processing', 'A clear and concise guide for anyone involved in developing applications', 9.99);
INSERT INTO item (title, description, price) VALUES ('REST und http', 'Eine theoretisch fundierte und praxistaugliche Anleitung zum Einsatz von RESTful HTTP', 19.95);
INSERT INTO item (title, description, price) VALUES ('The inner game of tennis', 'The timeless guide to achieving the state of “relaxed concentration” that’s not only the key to peak performance in tennis but the secret to success in life itself', 9.99);
INSERT INTO item (title, description, price) VALUES ('The IT Crowd', 'The comedic misadventures of Roy, Moss and their grifting supervisor Jen, a rag-tag team of IT support workers at a large corporation headed by a hotheaded yuppie.', 14.99);
INSERT INTO item (title, description, price) VALUES ('Winning ugly - Mentale Kriegsführung im Tennis', 'Wie Sie mit der Strategie des legendären Erfolgstrainers bessere Spieler schlagen.', 14.99);
INSERT INTO item (title, description, price) VALUES ('Chuck', 'When a computer geek inadvertently downloads critical government secrets into his brain, both the CIA and the NSA assign an agent to protect him and exploit his newfound skills.', 14.99);
```

- [ ] Checkout JSON Response in Browser <http://localhost:8245/api-maowit00/item-management/items>

- [ ] Screenshot the SQL commit

## Commit and Push

- [ ] git commit and push `week2-1`
