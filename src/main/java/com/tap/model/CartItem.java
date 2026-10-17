package com.tap.model;

/**
 * Model class representing a single dish entry inside the FastX shopping cart.
 */
public class CartItem {

    private int itemId;
    private int restaurantId;
    private String name;
    private double price;
    private int quantity;
    private String imagePath;

    // 1. Default No-Argument Constructor
    public CartItem() {
        super();
    }

    // 2. Parameterized Constructor
    public CartItem(int itemId, int restaurantId, String name, double price, int quantity, String imagePath) {
        super();
        this.itemId = itemId;
        this.restaurantId = restaurantId;
        this.name = name;
        this.price = price;
        this.quantity = quantity;
        this.imagePath = imagePath;
    }

    // 3. Getters and Setters
    public int getItemId() {
        return itemId;
    }

    public void setItemId(int itemId) {
        this.itemId = itemId;
    }

    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getImagePath() {
        return imagePath;
    }

    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    // 4. Helper Method: Calculates item total (unit price * quantity)
    public double getTotalPrice() {
        return this.price * this.quantity;
    }

    // 5. Overridden toString() for easy debugging & logging
    @Override
    public String toString() {
        return "CartItem [itemId=" + itemId 
                + ", restaurantId=" + restaurantId 
                + ", name=" + name 
                + ", price=" + price 
                + ", quantity=" + quantity 
                + ", imagePath=" + imagePath 
                + ", totalPrice=" + getTotalPrice() + "]";
    }
}
