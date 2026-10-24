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
				dto.getAvailability());
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
				entity.getAvailability());
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
