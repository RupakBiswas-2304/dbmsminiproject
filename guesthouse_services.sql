/************************************
*************************************
** Mini Project                    **
**                                 **
** Authors:                        **
**   - Rupak Biswas                **
**   - Aman Agarwal                **
**   - Sanskriti Singh             **
**   - Dinesh Chukkala             **
**                                 **
** File: guesthouse_services.sql   **
*************************************
*************************************/

-- Refer Page-1 of flowchar.drawio


USE library_mini_project;

-- Guest table
CREATE TABLE `Guest` (
    id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    phone_no VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address TEXT
);

-- Guest House table
CREATE TABLE `GuestHouse` (
    id INT PRIMARY KEY,
    name VARCHAR(255) UNIQUE NOT NULL
);

-- _Roomtype table
CREATE  TABLE `RoomType` (
    id INT PRIMARY KEY NOT NULL UNIQUE,
    occupancy_limit INT NOT NULL,
    suit BOOLEAN,
    price INT NOT NULL
);

-- Room table
CREATE TABLE `Room` (
    id INT PRIMARY KEY  AUTO_INCREMENT,
    room_no VARCHAR(10) NOT NULL,
    guesthouse_id INT NOT NULL,
    block VARCHAR(10),
    vacant BOOLEAN,
    maintaience BOOLEAN,
    type INT NOT NULL,
    FOREIGN KEY (guesthouse_id) REFERENCES GuestHouse(id),
    FOREIGN KEY (type) REFERENCES RoomType(id)
);

-- Payment Options
CREATE TABLE `_PaymentOptions` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    option VARCHAR(50) UNIQUE NOT NULL
);

-- booking Relation table
CREATE TABLE `booking` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    paid BOOLEAN NOT NULL,
    payment_option_id INT NOT NULL,
    checkin_date DATETIME NOT NULL,
    checkout_date DATETIME NOT NULL
    FOREIGN KEY (guest_id) REFERENCES `Guest`(id),
    FOREIGN KEY (room_id) REFERENCES `Room`(id),
    FOREIGN KEY (payment_option_id) REFERENCES `_PaymentOptions`(id) 
);


-- Food Item Table
CREATE TABLE `FoodItem` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price INT NOT NULL,
    availability BOOLEAN NOT NULL
);

-- Food Orders Table
CREATE TABLE `foodOrders` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    paid BOOLEAN NOT NULL,
    payment_option_id INT NOT NULL,
    total_amount INT NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES `Guest`(id),
    FOREIGN KEY (payment_option_id) REFERENCES `_PaymentOptions`(id)
);

-- food Item Booking Table
CREATE TABLE `foodItemBooking` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    food_item_id INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `foodOrders`(id),
    FOREIGN KEY (food_item_id) REFERENCES `FoodItem`(id)
);