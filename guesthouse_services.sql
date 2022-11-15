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
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) UNIQUE NOT NULL
);

-- _Roomtype table
CREATE TABLE `_RoomType` (
    id INT PRIMARY KEY NOT NULL UNIQUE AUTO_INCREMENT,
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
    total_amount INT DEFAULT 0,
    payment_option_id INT,
    checkin_date DATETIME NOT NULL,
    checkout_date DATETIME,
    completed BOOLEAN DEFAULT FALSE,
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
    booking_id INT NOT NULL,
    paid BOOLEAN DEFAULT FALSE,
    payment_option_id INT,
    total_amount INT NOT NULL,
    FOREIGN KEY (guest_id) REFERENCES `Guest`(id),
    FOREIGN KEY (payment_option_id) REFERENCES `_PaymentOption`(id),
    FOREIGN KEY (booking_id) REFERENCES `booking`(id)   
);

-- food Item Booking Table
CREATE TABLE `foodItemBooking` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    amount INT NOT NULL DEFAULT 1,
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

-- ####################
-- #     Triggers     #
-- ####################

-- Trigger on INSERT of Booking
DELIMITER |
CREATE TRIGGER `BOOKING_INSERT_EVENT`
BEFORE INSERT
ON `booking` FOR EACH ROW
BEGIN
    -- UPDATING Room vacancy
	UPDATE `Room`
	SET `Room`.vacant = FALSE
	WHERE `Room`.id = NEW.room_id;

    SET NEW.total_amount = (
        SELECT TIMESTAMPDIFF(
            DAY, NEW.checkin_date, NEW.checkout_date
        )
    ) * (
        SELECT price FROM _RoomType
        WHERE _RoomType.id = (
            SELECT type FROM Room
            WHERE Room.id = NEW.room_id
        )
    ); 
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

-- Trigger on DutyLog INSERT
DELIMITER |
CREATE TRIGGER `DutyLog_INSERT_EVENT`
AFTER INSERT
ON `DutyLog` FOR EACH ROW
BEGIN
    IF (NEW.checkin_time IS NOT NULL) THEN
        UPDATE `Staff`
        SET `Staff`.on_duty = TRUE
        WHERE `Staff`.id = NEW.staff_id;
    END IF;
END; |
DELIMITER ;

-- Trigger on DutyLog UPDATE
DELIMITER |
CREATE TRIGGER `DutyLog_UPDATE_EVENT`
AFTER UPDATE
ON `DutyLog` FOR EACH ROW
BEGIN
    IF (NEW.checkout_time IS NOT NULL AND OLD.checkout_time IS NULL) THEN
        UPDATE `Staff`
        SET `Staff`.on_duty = FALSE
        WHERE `Staff`.id = NEW.staff_id;
    END IF;
END; |
DELIMITER ;

DELIMITER |
CREATE TRIGGER `HandleFoodOrderAmount`
AFTER INSERT
ON `foodItemBooking` FOR EACH ROW
BEGIN
    UPDATE `foodOrders`
    SET `foodOrders`.total_amount = (
        SELECT SUM(`FoodItem`.price * `foodItemBooking`.amount)
        FROM `foodItemBooking`
        INNER JOIN `FoodItem`
        ON `foodItemBooking`.food_item_id = `FoodItem`.id
        WHERE `foodItemBooking`.order_id = NEW.order_id
    )
    WHERE `foodOrders`.id = NEW.order_id;
END; |

-- ##########
-- Functions --
-- ##########

-- booking functions
DELIMITER ||
CREATE FUNCTION `BookGuestHouse`(
    guest_id INT,
    room_id INT,
    checkin_date DATETIME,
    payment_option_id INT
    )
    RETURNS BOOLEAN
    DETERMINISTIC
    BEGIN
        DECLARE is_avilable BOOLEAN;
        DECLARE number_of_emptyroom INT;
        SELECT COUNT(*) INTO number_of_emptyroom FROM `Room` WHERE 
            vacant = TRUE AND maintenance = TRUE AND id = room_id;
        IF number_of_emptyroom = 1 THEN 
            SET is_avilable = TRUE;
            INSERT INTO `booking` (guest_id, room_id, checkin_date,payment_option_id ) 
                VALUES (guest_id, room_id, checkin_date, payment_option_id);
        ELSE 
            SET is_avilable = FALSE;
        END IF;
        RETURN (is_avilable);
    END ||
DELIMITER ;

-- bill generation function
DELIMITER ||
CREATE PROCEDURE `GenerateBill`(
    IN guest_id INT,
    IN booking_id INT,
    IN bill_type VARCHAR(50)
)
BEGIN
    IF bill_type = 'total' THEN
        -- show all bills combining food and room
        SELECT `booking`.id as id ,`booking`.total_amount as total_amount, `booking`.payment_option_id as payment_option 
            FROM `booking` WHERE `booking`.guest_id = guest_id AND `booking`.id = booking_id UNION 
                SELECT `foodOrders`.id as id, `foodOrders`.total_amount as total_amount, `foodOrders`.payment_option_id as payment_option 
                    FROM `foodOrders` WHERE `foodOrders`.guest_id = guest_id AND `foodOrders`.booking_id = booking_id;
    ELSEIF bill_type = 'food' THEN
        SET @constString = 'total';
        SET @foodOrdersId = (SELECT id FROM `foodOrders` WHERE `foodOrders`.guest_id = guest_id AND `foodOrders`.booking_id = booking_id);
        SELECT `foodItemBooking`.id as id, `FoodItem`.name as name, (`FoodItem`.price * `foodItemBooking`.amount ) as price 
            FROM `foodItemBooking` INNER JOIN `FoodItem` ON `foodItemBooking`.food_item_id = `FoodItem`.id 
                WHERE `foodItemBooking`.order_id = @foodOrdersId UNION 
                    SELECT `foodOrders`.id as id, @constString as name, `foodOrders`.total_amount as price 
                        FROM `foodOrders` WHERE `foodOrders`.guest_id = guest_id AND `foodOrders`.booking_id = booking_id;
    END IF;
END ||
DELIMITER ;


-- food booking
DELIMITER ||
CREATE PROCEDURE `BookFood`(
    IN guest_id INT,
    IN booking_id INT,
    IN food_item_id INT,
    IN quantity INT
) BEGIN 
    SET @is_avilable = (SELECT availability from `FoodItem` WHERE `FoodItem`.id = food_item_id);
    IF @is_avilable = TRUE THEN
        SET @is_first_order = (SELECT COUNT(*) FROM `foodOrders` WHERE `foodOrders`.guest_id = guest_id AND `foodOrders`.booking_id = booking_id);
        IF @is_first_order = 0 THEN
            INSERT INTO `foodOrders` (guest_id, booking_id, total_amount) VALUES (guest_id, booking_id, 0);
            SET @foodOrdersId = (SELECT id FROM `foodOrders` WHERE `foodOrders`.guest_id = guest_id AND `foodOrders`.booking_id = booking_id);
            INSERT INTO `foodItemBooking` (order_id, food_item_id, amount) VALUES (@foodOrdersId, food_item_id, quantity);
        ELSE
            SET @foodOrdersId = (SELECT id FROM `foodOrders` WHERE `foodOrders`.guest_id = guest_id AND `foodOrders`.booking_id = booking_id);
            INSERT INTO `foodItemBooking` (order_id, food_item_id, amount) VALUES (@foodOrdersId, food_item_id, quantity);
        END IF;
    ELSE 
        SET @errorMessage = 'Food item not available';
        SELECT @errorMessage as message ;
    END IF;

END ||
DELIMITER ;