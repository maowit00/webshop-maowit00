package de.hsesslingen.webshopbackend.dto;

import java.math.BigDecimal;

public class ItemUpdateDTO {

	private String title;
	private String description;
	private BigDecimal price;
	private Integer availability;

	public ItemUpdateDTO() {
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
