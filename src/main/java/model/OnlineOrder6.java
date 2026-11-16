package model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.List;

public class OnlineOrder6 {
    public static final String UNEXPORTED = "Chưa xuất";
    public static final String EXPORTED = "Đã xuất";
    public static final String DELIVERED = "Đã giao";

    private int id;
    private LocalDateTime orderDate;
    private BigDecimal totalAmount;
    private String status;
    private String deliveryAddress;
    private Customer6 customer;
    private Staff6 warehouseStaff;
    private DeliveryStaff6 deliveryStaff;
    private List<OrderDetail6> details = List.of();

    public OnlineOrder6() {
    }

    public OnlineOrder6(int id, LocalDateTime orderDate, BigDecimal totalAmount, String status, String deliveryAddress, Customer6 customer, Staff6 warehouseStaff, DeliveryStaff6 deliveryStaff, List<OrderDetail6> details) {
        this.id = id;
        this.orderDate = orderDate;
        this.totalAmount = totalAmount;
        this.status = status;
        this.deliveryAddress = deliveryAddress;
        this.customer = customer;
        this.warehouseStaff = warehouseStaff;
        this.deliveryStaff = deliveryStaff;
        this.details = details;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDateTime getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(LocalDateTime orderDate) {
        this.orderDate = orderDate;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    public Customer6 getCustomer() {
        return customer;
    }

    public void setCustomer(Customer6 customer) {
        this.customer = customer;
    }

    public Staff6 getWarehouseStaff() {
        return warehouseStaff;
    }

    public void setWarehouseStaff(Staff6 warehouseStaff) {
        this.warehouseStaff = warehouseStaff;
    }

    public DeliveryStaff6 getDeliveryStaff() {
        return deliveryStaff;
    }

    public void setDeliveryStaff(DeliveryStaff6 deliveryStaff) {
        this.deliveryStaff = deliveryStaff;
    }

    public List<OrderDetail6> getDetails() {
        return details;
    }

    public void setDetails(List<OrderDetail6> details) {
        this.details = details;
    }

    public String getOrderDateLabel() {
        return orderDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
