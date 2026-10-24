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
import org.springframework.web.bind.annotation.CrossOrigin;

import de.hsesslingen.webshopbackend.model.Item;
import de.hsesslingen.webshopbackend.repository.ItemRepository;

import de.hsesslingen.webshopbackend.dto.ItemCreateDTO;
import de.hsesslingen.webshopbackend.dto.ItemUpdateDTO;
import de.hsesslingen.webshopbackend.dto.ItemResponseDTO;
import de.hsesslingen.webshopbackend.mapper.ItemMapper;

import java.util.stream.Collectors;

@RestController
@RequestMapping("/api-maowit00/item-management/v1")
@CrossOrigin(origins = "http://localhost:8145")
public class ItemController {

	@Autowired
	ItemMapper itemMapper;

	@Autowired
	ItemRepository itemRepository;

	@GetMapping("/items")
	public ResponseEntity<List<ItemResponseDTO>> getAllItems(@RequestParam(required = false) String title) {

		try {
			List<Item> items = new ArrayList<Item>();

			if (title == null)
				itemRepository.findAll().forEach(items::add);
			else
				itemRepository.findByTitleContaining(title).forEach(items::add);

			if (items.isEmpty()) {
				return new ResponseEntity<>(HttpStatus.NO_CONTENT);
			}

			List<ItemResponseDTO> responseDTOs = items.stream()
					.map(itemMapper::toResponseDTO)
					.collect(Collectors.toList());

			return new ResponseEntity<>(responseDTOs, HttpStatus.OK);

		} catch (Exception e) {
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@GetMapping("/items/{id}")
	public ResponseEntity<ItemResponseDTO> getItemById(@PathVariable("id") long id) {
		Optional<Item> itemData = itemRepository.findById(id);

		if (itemData.isPresent()) {
			return new ResponseEntity<>(itemMapper.toResponseDTO(itemData.get()), HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@PostMapping("/items")
	public ResponseEntity<ItemResponseDTO> createItem(@RequestBody ItemCreateDTO itemCreateDTO) {
		try {
			Item item = itemMapper.toEntity(itemCreateDTO);
			Item savedItem = itemRepository.save(item);
			return new ResponseEntity<>(itemMapper.toResponseDTO(savedItem), HttpStatus.CREATED);
		} catch (Exception e) {
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@PutMapping("/items/{id}")
	public ResponseEntity<ItemResponseDTO> updateItem(@PathVariable("id") long id,
			@RequestBody ItemUpdateDTO itemUpdateDTO) {
		Optional<Item> itemData = itemRepository.findById(id);

		if (itemData.isPresent()) {
			Item item = itemData.get();
			itemMapper.updateEntityFromDTO(itemUpdateDTO, item);
			Item savedItem = itemRepository.save(item);
			return new ResponseEntity<>(itemMapper.toResponseDTO(savedItem), HttpStatus.OK);
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
