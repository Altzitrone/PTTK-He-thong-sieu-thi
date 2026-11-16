package model;

import java.math.BigDecimal;

public class Item6 {
    private int id;
    private String itemName;
    private BigDecimal price;
    private int stockQuantity;
    private String description;

    public Item6() {
    }

    public Item6(int id, String itemName, BigDecimal price, int stockQuantity, String description) {
        this.id = id;
        this.itemName = itemName;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.description = description;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    public BigDecimal getPrice() {
        return price;
    }

    public void setPrice(BigDecimal price) {
        this.price = price;
    }

    public int getStockQuantity() {
        return stockQuantity;
    }

    public void setStockQuantity(int stockQuantity) {
        this.stockQuantity = stockQuantity;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }
}
