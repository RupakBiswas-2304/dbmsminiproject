/***************************************
****************************************
** Mini Project                       **
**                                    **
** Authors:                           **
**   - Rupak Biswas                   **
**   - Aman Agarwal                   **
**   - Sanskriti Singh                **
**   - Dinesh Chukkala                **
**                                    **
** File: marketplace_services.sql     **
****************************************
****************************************/

CREATE TABLE Shop
(
    shop_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (shop_id)
);

CREATE TABLE Shopkeeper
(
    keeper_id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    shop_id INT NOT NULL,
    ph_no VARCHAR(10) NOT NULL,
    acc_no VARCHAR(15),
    address TEXT,
    PRIMARY KEY (keeper_id),
    FOREIGN KEY (shop_id) REFERENCES Shop(shop_id)

);

CREATE TABLE Bill
(
    bill_id INT NOT NULL AUTO_INCREMENT,
    type ENUM('water', 'electricity', 'rent') NOT NULL,
    shop_id INT NOT NULL,
    amount INT NOT NULL,
    mod_pay ENUM('cash', 'digital'),
    bill_status BOOLEAN NOT NULL DEFAULT 0,
    PRIMARY KEY (bill_id),
    FOREIGN KEY (shop_id) REFERENCES Shop(shop_id)
);

CREATE TABLE Feedback
(
    feedbk_id INT NOT NULL AUTO_INCREMENT,
    shop_id INT NOT NULL,
    rating INT NOT NULL CHECK(rating BETWEEN 0 AND 10),
    remark TEXT,
    PRIMARY KEY (feedbk_id),
    FOREIGN KEY (shop_id) REFERENCES Shop(shop_id)
);

CREATE TABLE License
(
    lic_id INT NOT NULL AUTO_INCREMENT,
    shop_id INT NOT NULL,
    issue_date DATE NOT NULL,
    expire_date DATE NOT NULL,
    lic_status BOOLEAN NOT NULL DEFAULT 0,
    PRIMARY KEY (lic_id),
    FOREIGN KEY (shop_id) REFERENCES Shop(shop_id)
);

CREATE TABLE Extension
(
    ext_id INT NOT NULL AUTO_INCREMENT,
    lic_id INT NOT NULL,
    ext_period INT NOT NULL,
    ext_fee INT NOT NULL,
    mod_pay ENUM('cash', 'digital'),
    ext_status BOOLEAN NOT NULL DEFAULT 0,
    PRIMARY KEY (ext_id),
    FOREIGN KEY (lic_id) REFERENCES License(lic_id)
);

DELIMITER //
CREATE PROCEDURE before_delete_in_Shop
(
    IN shop_id INT
)
BEGIN
    DELETE FROM Shopkeeper WHERE shop_id = @shop_id;
    DELETE FROM Bill WHERE shop_id = @shop_id;
    DELETE FROM Feedback WHERE shop_id = @shop_id;
    DELETE FROM License WHERE shop_id = @shop_id;
    DELETE FROM Extension WHERE lic_id = (SELECT lic_id FROM License WHERE shop_id = @shop_id);
END; //
DELIMITER ;

DELIMITER //
CREATE TRIGGER remove_Shop
BEFORE UPDATE
ON Shop FOR EACH ROW
BEGIN
    CALL before_delete_in_Shop(OLD.shop_id);
END //
DELIMITER ;