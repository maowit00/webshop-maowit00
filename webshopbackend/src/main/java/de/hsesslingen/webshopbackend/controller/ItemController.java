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

import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;

@RestController
@RequestMapping("/api-maowit00/item-management/v1")
@CrossOrigin(origins = "http://localhost:8145")
@Tag(name = "HS Esslingen Webshop", description = "This is a sample webshop to demonstrate a fullstack web application")
public class ItemController {

	@Autowired
	ItemMapper itemMapper;

	@Autowired
	ItemRepository itemRepository;

	@Operation(summary = "Get all items", description = "Returns all items, optionally filtered by title")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Items found", content = @Content(mediaType = "application/json", array = @ArraySchema(schema = @Schema(implementation = ItemResponseDTO.class)))),
			@ApiResponse(responseCode = "404", description = "No items found", content = @Content),
			@ApiResponse(responseCode = "500", description = "Internal server error", content = @Content)
	})
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

	@Operation(summary = "Get item by ID", description = "Returns a single item by its ID")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Item found", content = @Content(mediaType = "application/json", schema = @Schema(implementation = ItemResponseDTO.class))),
			@ApiResponse(responseCode = "404", description = "Item not found", content = @Content)
	})
	@GetMapping("/items/{id}")
	public ResponseEntity<ItemResponseDTO> getItemById(@PathVariable("id") long id) {
		Optional<Item> itemData = itemRepository.findById(id);

		if (itemData.isPresent()) {
			return new ResponseEntity<>(itemMapper.toResponseDTO(itemData.get()), HttpStatus.OK);
		} else {
			return new ResponseEntity<>(HttpStatus.NOT_FOUND);
		}
	}

	@Operation(summary = "Create a new item", description = "Creates a new item and returns the created item including its generated ID")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "201", description = "Item created", content = @Content(mediaType = "application/json", schema = @Schema(implementation = ItemResponseDTO.class))),
			@ApiResponse(responseCode = "500", description = "Internal server error", content = @Content)
	})
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

	@Operation(summary = "Update an item", description = "Updates an existing item by its ID and returns the updated item")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "200", description = "Item updated", content = @Content(mediaType = "application/json", schema = @Schema(implementation = ItemResponseDTO.class))),
			@ApiResponse(responseCode = "404", description = "Item not found", content = @Content)
	})
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

	@Operation(summary = "Delete an item", description = "Deletes a single item by its ID")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "204", description = "Item deleted", content = @Content),
			@ApiResponse(responseCode = "500", description = "Internal server error", content = @Content)
	})
	@DeleteMapping("/items/{id}")
	public ResponseEntity<HttpStatus> deleteItem(@PathVariable("id") long id) {
		try {
			itemRepository.deleteById(id);
			return new ResponseEntity<>(HttpStatus.NO_CONTENT);
		} catch (Exception e) {
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

	@Operation(summary = "Delete all items", description = "Deletes all items from the webshop")
	@ApiResponses(value = {
			@ApiResponse(responseCode = "204", description = "All items deleted", content = @Content),
			@ApiResponse(responseCode = "500", description = "Internal server error", content = @Content)
	})
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
