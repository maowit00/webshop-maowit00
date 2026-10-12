package de.hsesslingen.webshopbackend.repository;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import de.hsesslingen.webshopbackend.model.Item;

public interface ItemRepository extends JpaRepository<Item, Long> {

	List<Item> findByTitleContaining(String title);

}
