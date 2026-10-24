package de.hsesslingen.webshopbackend.dto;

import io.swagger.v3.oas.annotations.media.Schema;

import java.math.BigDecimal;

public class ItemUpdateDTO {

	@Schema(description = "Title of the item", example = "Principles of transaction processing")
	private String title;
	
	@Schema(description = "Detailed description of the item", example = "A clear and concise guide for anyone involved in developing applications")
	private String description;
	
	@Schema(description = "Price in EUR", example = "9.99")
	private BigDecimal price;

	@Schema(description = "Availability of the item", example = "10")
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
