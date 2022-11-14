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

USE mini_project;

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
CREATE TABLE `_RoomType` (
    id INT PRIMARY KEY NOT NULL UNIQUE,
    occupancy_limit INT NOT NULL,
    suite BOOLEAN,
    price INT NOT NULL
);

-- Room table
CREATE TABLE `Room` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    room_no VARCHAR(10) NOT NULL,
    guesthouse_id INT NOT NULL,
    block VARCHAR(10),
    vacant BOOLEAN,
    maintenance BOOLEAN,
    type INT NOT NULL,
    FOREIGN KEY (guesthouse_id) REFERENCES `GuestHouse`(id),
    FOREIGN KEY (type) REFERENCES `_RoomType`(id)
);

-- Payment Options
CREATE TABLE `_PaymentOption` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    payment_option VARCHAR(50) UNIQUE NOT NULL
);

-- booking Relation table
CREATE TABLE `booking` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    room_id INT NOT NULL,
    paid BOOLEAN NOT,
    payment_option_id INT,
    checkin_date DATETIME NOT NULL,
    checkout_date DATETIME NOT NULL, 
    completed BOOLEAN,
    FOREIGN KEY (guest_id) REFERENCES `Guest`(id),
    FOREIGN KEY (room_id) REFERENCES `Room`(id),
    FOREIGN KEY (payment_option_id) REFERENCES `_PaymentOption`(id)
);

-- Food Item Table
CREATE TABLE`FoodItem` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price INT NOT NULL,
    availability BOOLEAN NOT NULL
);

-- Food Orders Table
CREATE TABLE `foodOrders` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    guest_id INT NOT NULL,
    paid BOOLEAN,
    payment_option_id INT,
    total_amount INT NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES `Guest`(id),
    FOREIGN KEY (payment_option_id) REFERENCES `_PaymentOption`(id)
);

-- food Item Booking Table
CREATE TABLE `foodItemBooking` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    food_item_id INT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES `foodOrders`(id),
    FOREIGN KEY (food_item_id) REFERENCES `FoodItem`(id)
);

--  _Designation Table
CREATE TABLE `_Designation` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    designation VARCHAR(50) NOT NULL,
    salary INT
);

-- Staff Shift Table
CREATE TABLE `_StaffShift` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    entry_time TIME NOT NULL,
    exit_time TIME NOT NULL
);

--  Staff Table
CREATE TABLE `Staff` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    phone_no VARCHAR(15) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    address TEXT,
    designation_id INT NOT NULL,
    on_duty BOOLEAN,
    shift_id INT,
    FOREIGN KEY (designation_id) REFERENCES `_Designation`(id),
    FOREIGN KEY (shift_id) REFERENCES `_StaffShift`(id)
);

--  DutyLog Table
CREATE TABLE `DutyLog` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT NOT NULL,
    checkin_time DATETIME,
    checkout_time DATETIME,
    FOREIGN KEY (staff_id) REFERENCES `Staff`(id)
);

-- MaintenanceLog Table
CREATE TABLE `MaintenanceLog` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT NOT NULL,
    room_id INT NOT NULL,
    log_time DATETIME NOT NULL,
    FOREIGN KEY (staff_id) REFERENCES `Staff`(id),
    FOREIGN KEY (room_id) REFERENCES `Room`(id)
);

-- Trigger on INSERT of Booking
DELIMITER |
CREATE TRIGGER `BOOKING_INSERT_EVENT`
AFTER INSERT
ON `booking` FOR EACH ROW
BEGIN
	UPDATE `Room`
	SET `Room`.vacant = FALSE
	WHERE `Room`.id = NEW.room_id;
END; |
DELIMITER ;

-- Trigger on UPDATE of Booking
DELIMITER |
CREATE TRIGGER `BOOKING_UPDATE_EVENT`
AFTER UPDATE
ON `booking` FOR EACH ROW
BEGIN
    IF (NEW.completed = TRUE AND OLD.completed = FALSE) THEN
	    UPDATE `Room`
	    SET `Room`.vacant = TRUE, `Room`.maintenance = TRUE
	    WHERE `Room`.id = NEW.room_id;
    END IF;
END; |
DELIMITER ;

-- Functions --

-- booking functions
DELIMITER ||
CREATE FUNCTION `getBookingDetails`(
    guest_id INT,
    room_id INT,
    checkin_time DATETIME
    )
    RETURNS INT
    DETERMINISTIC
    BEGIN
        DECLARE is_avilable BOOLEAN;
        DECLARE number_of_emptyroom INT;
        SELECT COUNT(*) INTO number_of_emptyroom FROM `Room` WHERE \
            vacant = TRUE AND maintenance = TRUE;
        IF number_of_emptyroom = 0 THEN 
            SET is_avilable = TRUE;
        ELSE 
            SET is_avilable = FALSE;
        END IF;
        INSERT 
    END ||
DELIMITER;