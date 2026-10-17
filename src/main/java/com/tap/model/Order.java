package com.tap.model;

public class Order {

    private int orderId;
    private int userId;
    private int restaurantId;
    private double totalAmount;
    private String orderStatus;
    private String paymentMode;
    private String orderDate;
    private String deliveryAddress;

    public Order() {
    }

    public Order(int orderId, int userId, int restaurantId,
                 double totalAmount, String orderStatus,
                 String paymentMode, String orderDate,
                 String deliveryAddress) {
        this.orderId = orderId;
        this.userId = userId;
        this.restaurantId = restaurantId;
        this.totalAmount = totalAmount;
        this.orderStatus = orderStatus;
        this.paymentMode = paymentMode;
        this.orderDate = orderDate;
        this.deliveryAddress = deliveryAddress;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public String getOrderStatus() {
        return orderStatus;
    }

    public void setOrderStatus(String orderStatus) {
        this.orderStatus = orderStatus;
    }

    public String getPaymentMode() {
        return paymentMode;
    }

    public void setPaymentMode(String paymentMode) {
        this.paymentMode = paymentMode;
    }

    public String getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(String orderDate) {
        this.orderDate = orderDate;
    }

    public String getDeliveryAddress() {
        return deliveryAddress;
    }

    public void setDeliveryAddress(String deliveryAddress) {
        this.deliveryAddress = deliveryAddress;
    }

    @Override
    public String toString() {
        return "Order [orderId=" + orderId
                + ", userId=" + userId
                + ", restaurantId=" + restaurantId
                + ", totalAmount=" + totalAmount
                + ", orderStatus=" + orderStatus
                + ", paymentMode=" + paymentMode
                + ", orderDate=" + orderDate
                + ", deliveryAddress=" + deliveryAddress + "]";
    }
}