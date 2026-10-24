package de.hsesslingen.webshopbackend.dto;

import java.math.BigDecimal;

public class ItemCreateDTO {

	private String title;
	private String description;
	private BigDecimal price;
	private Integer availability;

	public ItemCreateDTO() {
	}

	public ItemCreateDTO(String title, String description, BigDecimal price, Integer availability) {
		this.title = title;
		this.description = description;
		this.price = price;
		this.availability = availability;
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

	public Integer getAvailability() {
		return availability;
	}

	public void setAvailability(Integer availability) {
		this.availability = availability;
	}
}
