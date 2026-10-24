# Week4-1 Planning

- [x] Create branch `week4-1`

## Introduce DTOs

- [ ] Create dto directory [/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/dto](/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/dto)
- [ ] Create mapper directory [/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/mapper](/webshopbackend/src/main/java/de/hsesslingen/webshopbackend/mapper)

- [ ] Create [ItemCreateDTO.java][ItemCreateDTO.java]

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

- [ ] Create [ItemUpdateDTO.java][ItemUpdateDTO.java]

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

- [ ] Create [ItemResponseDTO.java][ItemResponseDTO.java]

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

- [ ] Create [ItemMapper.java][ItemMapper.java]

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

- Add imports to [ItemController.java][ItemController.java]

```java
import de.hsesslingen.webshopbackend.dto.ItemCreateDTO;
import de.hsesslingen.webshopbackend.dto.ItemUpdateDTO;
import de.hsesslingen.webshopbackend.dto.ItemResponseDTO;
import de.hsesslingen.webshopbackend.mapper.ItemMapper;

import java.util.stream.Collectors;
```

- Add Annotation to the `ItemController`

```java
@Autowired
ItemMapper itemMapper;
```

- [ ] Replace the methods that returns `Item` with `ItemResponseDTO` in [ItemController.java][ItemController.java]

- [ ] Modify implementation of `getAllItems`

```java
List<ItemResponseDTO> responseDTOs = items.stream()
        .map(itemMapper::toResponseDTO)
        .collect(Collectors.toList());

return new ResponseEntity<>(responseDTOs, HttpStatus.OK);
```

- [ ] Modify `getItemById`

```java
return new ResponseEntity<>(itemMapper.toResponseDTO(itemData.get()), HttpStatus.OK);
```

- [ ] Change input parameter of `createItem`

```java
@RequestBody ItemCreateDTO itemCreateDTO
```

- [ ] Modify the try catch block

```java
Item item = itemMapper.toEntity(itemCreateDTO);
Item savedItem = itemRepository.save(item);
return new ResponseEntity<>(itemMapper.toResponseDTO(savedItem), HttpStatus.CREATED);
```

- [ ] Change function parameter of `updateItem` to be `ItemUpdateDTO`

```java
@RequestBody ItemUpdateDTO itemUpdateDTO
```

- [ ] Modify the if-block

```java
Item item = itemData.get();
itemMapper.updateEntityFromDTO(itemUpdateDTO, item);
Item savedItem = itemRepository.save(item);
return new ResponseEntity<>(itemMapper.toResponseDTO(savedItem), HttpStatus.OK);
```

[ItemController.java]: /webshopbackend/src/main/java/de/hsesslingen/webshopbackend/controller/ItemController.java

### Testing

- [ ] Test if you broke the backend

```java
mvn spring-boot:run
```

- [ ] Commit changes
