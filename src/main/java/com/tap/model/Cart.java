package com.tap.model;

import java.util.HashMap;
import java.util.Map;

/**
 * Model class that manages the collection of CartItems, 
 * the active restaurantId, and cart business logic.
 */
public class Cart {

    // Key: itemId, Value: CartItem
    private Map<Integer, CartItem> items;
    
    // Tracks the current restaurant ID for the order
    private int restaurantId;

    // 1. Constructor: Initializes an empty cart
    public Cart() {
        this.items = new HashMap<>();
        this.restaurantId = 0;
    }

    // 2. Getters & Setters for restaurantId
    public int getRestaurantId() {
        return restaurantId;
    }

    public void setRestaurantId(int restaurantId) {
        this.restaurantId = restaurantId;
    }

    // 3. Add an item to the cart
    public void addItem(CartItem item) {
        if (item == null) {
            return;
        }

        // If this is the first item added to the cart, set the cart's restaurantId
        if (items.isEmpty()) {
            this.restaurantId = item.getRestaurantId();
        }

        // If item is from a different restaurant, reset cart for the new restaurant
        if (this.restaurantId != 0 && this.restaurantId != item.getRestaurantId()) {
            items.clear();
            this.restaurantId = item.getRestaurantId();
        }

        int itemId = item.getItemId();

        if (items.containsKey(itemId)) {
            // Item already exists -> increase quantity
            CartItem existingItem = items.get(itemId);
            int newQuantity = existingItem.getQuantity() + item.getQuantity();
            existingItem.setQuantity(newQuantity);
        } else {
            // New item -> add to cart
            items.put(itemId, item);
        }
    }

    // 4. Update quantity of an existing item
    public void updateItem(int itemId, int quantity) {
        if (items.containsKey(itemId)) {
            if (quantity <= 0) {
                // Remove item if quantity reduced to 0 or less
                items.remove(itemId);
                if (items.isEmpty()) {
                    this.restaurantId = 0;
                }
            } else {
                CartItem existingItem = items.get(itemId);
                existingItem.setQuantity(quantity);
            }
        }
    }

    // 5. Remove a specific item from the cart
    public void removeItem(int itemId) {
        items.remove(itemId);
        if (items.isEmpty()) {
            this.restaurantId = 0;
        }
    }

    // 6. Get all items in the cart
    public Map<Integer, CartItem> getItems() {
        return items;
    }

    // 7. Calculate subtotal amount of all items in the cart
    public double getTotalAmount() {
        double total = 0.0;
        for (CartItem item : items.values()) {
            total += item.getTotalPrice();
        }
        return total;
    }

    // 8. Get total number of individual items in the cart
    public int getTotalQuantity() {
        int totalQuantity = 0;
        for (CartItem item : items.values()) {
            totalQuantity += item.getQuantity();
        }
        return totalQuantity;
    }

    // 9. Clear all items from the cart and reset restaurantId
    public void clear() {
        items.clear();
        this.restaurantId = 0;
    }

    // 10. Check if the cart is empty
    public boolean isEmpty() {
        return items.isEmpty();
    }

    // 11. Overridden toString() for debugging
    @Override
    public String toString() {
        return "Cart [restaurantId=" + restaurantId 
                + ", itemsCount=" + items.size() 
                + ", totalQuantity=" + getTotalQuantity() 
                + ", totalAmount=" + getTotalAmount() + "]";
    }
}
