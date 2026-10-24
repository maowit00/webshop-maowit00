# Week4-1 Planning

- [x] Create branch `week4-1`

- [x] Add the Version `/v1` in the ItemController of the backend and the http-commons in the frontend.
  - [x] Modify backend [ItemController.java][ItemController.java]
  - [x] modify `http-common` [webshopfrontend/src/http-common.js](/webshopfrontend/src/http-common.js)

## Introduce DTOs

- [x] Create dto directory [/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/dto](/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/dto)
- [x] Create mapper directory [/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/mapper](/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/mapper)

- [x] Create [ItemCreateDTO.java][ItemCreateDTO.java]

```java
package de.hsesslingen.webshopbackend.dto;

import java.math.BigDecimal;

public class ItemCreateDTO {

    private String title;
    private String description;
    private BigDecimal price;
    private Integer availability;

    public ItemCreateDTO() {}

    public ItemCreateDTO(String title, String description, BigDecimal price, Integer availability) {
        this.title = title;
        this.description = description;
        this.price = price;
        this.availability = availability;
    }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getAvailability() { return availability; }
    public void setAvailability(Integer availability) { this.availability = availability; }
}
```

- [x] Create [ItemUpdateDTO.java][ItemUpdateDTO.java]

```java
package de.hsesslingen.webshopbackend.dto;

import java.math.BigDecimal;

public class ItemUpdateDTO {

    private String title;
    private String description;
    private BigDecimal price;
    private Integer availability;

    public ItemUpdateDTO() {}

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getAvailability() { return availability; }
    public void setAvailability(Integer availability) { this.availability = availability; }
}
```

- [x] Create [ItemResponseDTO.java][ItemResponseDTO.java]

```java
package de.hsesslingen.webshopbackend.dto;

import java.math.BigDecimal;

public class ItemResponseDTO {

    private long id;
    private String title;
    private String description;
    private BigDecimal price;
    private Integer availability;

    public ItemResponseDTO() {}

    public ItemResponseDTO(long id, String title, String description, BigDecimal price, Integer availability) {
        this.id = id;
        this.title = title;
        this.description = description;
        this.price = price;
        this.availability = availability;
    }

    public long getId() { return id; }
    public void setId(long id) { this.id = id; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public BigDecimal getPrice() { return price; }
    public void setPrice(BigDecimal price) { this.price = price; }

    public Integer getAvailability() { return availability; }
    public void setAvailability(Integer availability) { this.availability = availability; }
}
```

- [x] Create [ItemMapper.java][ItemMapper.java]

```java
package de.hsesslingen.webshopbackend.mapper;

import org.springframework.stereotype.Component;
import de.hsesslingen.webshopbackend.model.Item;
import de.hsesslingen.webshopbackend.dto.ItemCreateDTO;
import de.hsesslingen.webshopbackend.dto.ItemUpdateDTO;
import de.hsesslingen.webshopbackend.dto.ItemResponseDTO;

@Component
public class ItemMapper {

    public Item toEntity(ItemCreateDTO dto) {
        if (dto == null) {
            return null;
        }
        return new Item(
            dto.getTitle(),
            dto.getDescription(),
            dto.getPrice(),
            dto.getAvailability()
        );
    }

    public ItemResponseDTO toResponseDTO(Item entity) {
        if (entity == null) {
            return null;
        }
        return new ItemResponseDTO(
            entity.getId(),
            entity.getTitle(),
            entity.getDescription(),
            entity.getPrice(),
            entity.getAvailability()
        );
    }

    public void updateEntityFromDTO(ItemUpdateDTO dto, Item entity) {
        if (dto == null || entity == null) {
            return;
        }
        entity.setTitle(dto.getTitle());
        entity.setDescription(dto.getDescription());
        entity.setPrice(dto.getPrice());
        entity.setAvailability(dto.getAvailability());
    }
}
```

[ItemCreateDTO.java]: /webshopbackend/src/main/java/de/hsesslingen/webshopbackend/dto/ItemCreateDTO.java
[ItemUpdateDTO.java]: /webshopbackend/src/main/java/de/hsesslingen/webshopbackend/dto/ItemUpdateDTO.java
[ItemResponseDTO.java]: /webshopbackend/src/main/java/de/hsesslingen/webshopbackend/dto/ItemResponseDTO.java
[ItemMapper.java]: /webshopbackend/src/main/java/de/hsesslingen/webshopbackend/mapper/ItemMapper.java

### Modify Controller

- [x] Add imports to [ItemController.java][ItemController.java]

```java
import de.hsesslingen.webshopbackend.dto.ItemCreateDTO;
import de.hsesslingen.webshopbackend.dto.ItemUpdateDTO;
import de.hsesslingen.webshopbackend.dto.ItemResponseDTO;
import de.hsesslingen.webshopbackend.mapper.ItemMapper;

import java.util.stream.Collectors;
```

- [x] Add new attribute with an annotation to the `ItemController`

```java
@Autowired
ItemMapper itemMapper;
```

- [x] Replace the methods that returns `Item` with `ItemResponseDTO` in [ItemController.java][ItemController.java]
  - [x] method `getAllItems`
  - [x] method `getItemById`
  - [x] method `createItem`
  - [x] method `updateItem`

```java
public ResponseEntity<List<ItemResponseDTO>> getAllItems(@RequestParam(required = false) String title) {
```

- [x] Modify implementation of `getAllItems`

```java
List<ItemResponseDTO> responseDTOs = items.stream()
        .map(itemMapper::toResponseDTO)
        .collect(Collectors.toList());

return new ResponseEntity<>(responseDTOs, HttpStatus.OK);
```

- [x] Modify `getItemById`

```java
return new ResponseEntity<>(itemMapper.toResponseDTO(itemData.get()), HttpStatus.OK);
```

- [x] Change input parameter of `createItem`

```java
@RequestBody ItemCreateDTO itemCreateDTO
```

- [x] Modify the try catch block

```java
Item item = itemMapper.toEntity(itemCreateDTO);
Item savedItem = itemRepository.save(item);
return new ResponseEntity<>(itemMapper.toResponseDTO(savedItem), HttpStatus.CREATED);
```

- [x] Change function parameter of `updateItem` to be `ItemUpdateDTO`

```java
@RequestBody ItemUpdateDTO itemUpdateDTO
```

- [x] Modify the if-block

```java
Item item = itemData.get();
itemMapper.updateEntityFromDTO(itemUpdateDTO, item);
Item savedItem = itemRepository.save(item);
return new ResponseEntity<>(itemMapper.toResponseDTO(savedItem), HttpStatus.OK);
```

[ItemController.java]: /webshopbackend/src/main/java/de/hsesslingen/webshopbackend/controller/ItemController.java

### Testing

- [x] Test if you broke the backend

```java
mvn spring-boot:run
```

- [x] Go to <http://localhost:8245/api-maowit00/item-management/v1/items>

- [x] Commit changes

## API Documentation

- [ ] Add dependency to [POM.xm](/webshopbackend/pom.xml)

```XML
<dependency>
  <groupId>org.springdoc</groupId>
  <artifactId>springdoc-openapi-starter-webmvc-ui</artifactId>
  <version>3.1.1</version>
</dependency>
```

### DTO Doc Annotations

- [ ] Add doc annotation to to:
  - [ ] [ItemCreateDTO.java][ItemCreateDTO.java]
  - [ ] [ItemUpdateDTO.java][ItemUpdateDTO.java]
  - [ ] [ItemResponseDTO.java][ItemResponseDTO.java]

- [ ] Import

```java
import io.swagger.v3.oas.annotations.media.Schema;
```

- [ ] Add schema doc to `title`

```java
@Schema(description = "Title of the item", example = "Principles of transaction processing")
```

- [ ] Add schema doc to `description`

```java
@Schema(description = "Detailed description of the item", example = "A clear and concise guide for anyone involved in developing applications")
```

- [ ] Add schema doc to `price`

```java
@Schema(description = "Price in EUR", example = "9.99")
```

- [ ] Add schema doc to `availability`

```java
@Schema(description = "Availability of the item", example = "10")
```

- [ ] By [ItemResponseDTO.java][ItemResponseDTO.java] add schema doc to `id`

```java
@Schema(accessMode = Schema.AccessMode.READ_ONLY, description = "Auto-generated item ID", example = "1")
```

### Controllers Doc Annotations

- [ ] Add import to [ItemController.java][ItemController.java]

```java
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
```

- [ ] Add `@Tag` to `ItemController` class definition

```java
@Tag(name = "HS Esslingen Webshop", description = "This is a sample webshop to demonstrate a fullstack web application")
```

- [ ] Add doc annotation to `getAllItems`

```java
@Operation(summary = "Get all items", description = "Returns all items, optionally filtered by title")
@ApiResponses(value = {
    @ApiResponse(responseCode = "200", description = "Items found",
        content = @Content(
            mediaType = "application/json",
            array = @ArraySchema(schema = @Schema(implementation = ItemResponseDTO.class))
        )
    ),
    @ApiResponse(responseCode = "404", description = "No items found",
        content = @Content),
    @ApiResponse(responseCode = "500", description = "Internal server error",
        content = @Content)
})
```

### HTTP Requests Doc Annotation

- [ ] Add corresponding annotations also to the other operations.

- [ ] `getItemById`

```java
@Operation(summary = "Get item by ID", description = "Returns a single item by its ID")
@ApiResponses(value = {
    @ApiResponse(responseCode = "200", description = "Item found",
        content = @Content(
            mediaType = "application/json",
            schema = @Schema(implementation = ItemResponseDTO.class)
        )
    ),
    @ApiResponse(responseCode = "404", description = "Item not found",
        content = @Content)
})
```

- [ ] `createItem`

```java
@Operation(summary = "Create a new item", description = "Creates a new item and returns the created item including its generated ID")
@ApiResponses(value = {
    @ApiResponse(responseCode = "201", description = "Item created",
        content = @Content(
            mediaType = "application/json",
            schema = @Schema(implementation = ItemResponseDTO.class)
        )
    ),
    @ApiResponse(responseCode = "500", description = "Internal server error",
        content = @Content)
})
```

- [ ] `updateItem`

```java
@Operation(summary = "Update an item", description = "Updates an existing item by its ID and returns the updated item")
@ApiResponses(value = {
    @ApiResponse(responseCode = "200", description = "Item updated",
        content = @Content(
            mediaType = "application/json",
            schema = @Schema(implementation = ItemResponseDTO.class)
        )
    ),
    @ApiResponse(responseCode = "404", description = "Item not found",
        content = @Content)
})
```

- [ ] `deleteItem`

```java
@Operation(summary = "Delete an item", description = "Deletes a single item by its ID")
@ApiResponses(value = {
    @ApiResponse(responseCode = "204", description = "Item deleted",
        content = @Content),
    @ApiResponse(responseCode = "500", description = "Internal server error",
        content = @Content)
})
```

- [ ] `deleteAllItems`

```java
@Operation(summary = "Delete all items", description = "Deletes all items from the webshop")
@ApiResponses(value = {
    @ApiResponse(responseCode = "204", description = "All items deleted",
        content = @Content),
    @ApiResponse(responseCode = "500", description = "Internal server error",
        content = @Content)
})
```

### Testing API Doc

- [ ] Start backend

```java
mvn spring-boot:run
```

- [ ] Go to <http://localhost:8245/swagger-ui/index.html>

- [ ] Make screenshot [docs/week4-swagger-ui.png](/docs/week4-swagger-ui.png)

![docs/week4-swagger-ui.png](/docs/week4-swagger-ui.png)

- [ ] Commit changes

## Install Bruno

- Install [bruno from snap](https://snapcraft.io/bruno)

```console
sudo snap install bruno
```

> Might won't for arm!

- Use the [brew](https://brew.sh/) Package manager to install [the cli one](https://formulae.brew.sh/formula/bruno-cli)

```console
brew install bruno-cli
```

### The More Complicated Way

Add mirror to the apt list by imports and trust gpg keys

- x86

```console
sudo mkdir -p /etc/apt/keyrings
sudo apt update && sudo apt install gpg curl
curl -fsSL "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x9FA6017ECABE0266" | gpg --dearmor | sudo tee /etc/apt/keyrings/bruno.gpg > /dev/null
sudo chmod 644 /etc/apt/keyrings/bruno.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/bruno.gpg] http://debian.usebruno.com/ bruno stable" | sudo tee /etc/apt/sources.list.d/bruno.list
sudo apt update && sudo apt install bruno
```

- arm

```console
wget -O bruno_arm64.deb "https://github.com/usebruno/bruno/releases/latest/download/bruno_4.1.0_arm64_linux.deb"
sudo apt install ./bruno_arm64.deb.
```

## Test REST API

### Create a collection

- [ ] Use OpenAPI URL

```url
http://localhost:8245/v3/api-docs
```

- [ ] Use location to be `webshopbackend/src/test/resources/api-test`

- [ ] Create Environment thingy

- [ ] Add `baseUrl` and `id` to Vars

```url
http://localhost:8245
```

- For each request with the id as (path) parameter add the value '{{id}}' to the parameter definition 'id'

- [ ] DON'T TEST `Delete`
- [ ] Test Everything

### Screenshots Docs

- [ ] Test [week4-getAllItems-maowit00](/docs/week4-getAllItems-maowit00.png)
- [ ] Test [week4-getItem-maowit00](/docs/week4-getItem-maowit00.png)
- [ ] Test [week4-createItem-maowit00](/docs/week4-createItem-maowit00.png)
- [ ] Test [week4-updateItem-maowit00](/docs/week4-getAllItems-maowit00.png)
