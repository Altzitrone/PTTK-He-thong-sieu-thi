package model;

import java.math.BigDecimal;

public class OrderDetail6 {
    private int id;
    private Item6 item;
    private int quantity;
    private BigDecimal unitPrice;

    public OrderDetail6() {
    }

    public OrderDetail6(int id, Item6 item, int quantity, BigDecimal unitPrice) {
        this.id = id;
        this.item = item;
        this.quantity = quantity;
        this.unitPrice = unitPrice;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Item6 getItem() {
        return item;
    }

    public void setItem(Item6 item) {
        this.item = item;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public BigDecimal getLineTotal() {
        return unitPrice.multiply(BigDecimal.valueOf(quantity));
    }
}
