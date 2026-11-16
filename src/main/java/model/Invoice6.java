package model;

import java.time.LocalDateTime;

public class Invoice6 {
    private int id;
    private LocalDateTime printDate;
    private String paymentDetail;
    private OnlineOrder6 onlineOrder;
    private DeliveryStaff6 deliveryStaff;

    public Invoice6() {
    }

    public Invoice6(int id, LocalDateTime printDate, String paymentDetail, OnlineOrder6 onlineOrder, DeliveryStaff6 deliveryStaff) {
        this.id = id;
        this.printDate = printDate;
        this.paymentDetail = paymentDetail;
        this.onlineOrder = onlineOrder;
        this.deliveryStaff = deliveryStaff;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDateTime getPrintDate() {
        return printDate;
    }

    public void setPrintDate(LocalDateTime printDate) {
        this.printDate = printDate;
    }

    public String getPaymentDetail() {
        return paymentDetail;
    }

    public void setPaymentDetail(String paymentDetail) {
        this.paymentDetail = paymentDetail;
    }

    public OnlineOrder6 getOnlineOrder() {
        return onlineOrder;
    }

    public void setOnlineOrder(OnlineOrder6 onlineOrder) {
        this.onlineOrder = onlineOrder;
    }

    public DeliveryStaff6 getDeliveryStaff() {
        return deliveryStaff;
    }

    public void setDeliveryStaff(DeliveryStaff6 deliveryStaff) {
        this.deliveryStaff = deliveryStaff;
    }

    public String getPrintDateLabel() {
        return printDate == null ? "" : printDate.format(java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"));
    }
}
