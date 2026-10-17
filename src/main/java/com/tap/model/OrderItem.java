
package com.tap.model;

public class OrderItem {

    private int orderItemId;
    private int orderId;
    private int menuId;
    private int quantity;
    private double price;

    public OrderItem() {
    }

    public OrderItem(int orderItemId, int orderId, int menuId,
                     int quantity, double price) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.menuId = menuId;
        this.quantity = quantity;
        this.price = price;
    }

    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    @Override
    public String toString() {
        return "OrderItem [orderItemId=" + orderItemId
                + ", orderId=" + orderId
                + ", menuId=" + menuId
                + ", quantity=" + quantity
                + ", price=" + price + "]";
    }
}