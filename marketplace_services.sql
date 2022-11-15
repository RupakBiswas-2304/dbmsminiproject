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
    shop_id INT NOT NULL,
    name VARCHAR(255) NOT NULL,
    PRIMARY KEY (shop_id)
);

CREATE TABLE Shopkeeper
(
    keeper_id INT NOT NULL,
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
    bill_id INT NOT NULL,
    type ENUM('water', 'electricity', 'rent') NOT NULL,
    shop_id INT NOT NULL,
    amount INT NOT NULL,
    mod_pay ENUM('cash', 'digital'),
    bill_satus BOOLEAN
    PRIMARY KEY (bill_id),
    FOREIGN KEY (shop_id) REFERENCES Shop(shop_id)
);

CREATE TABLE Feedback
(
    feedbk_id INT NOT NULL,
    shop_id INT NOT NULL,
    rating NOT NULL CHECK(rating BETWEEN 0 AND 10),
    PRIMARY KEY (feedbk_id),
    FOREIGN KEY (shop_id) REFERENCES Shop(shop_id)
);

CREATE TABLE License
(
    lic_id INT NOT NULL,
    shop_id INT NOT NULL,
    issue_date DATE NOT NULL,
    expire_date DATE NOT NULL,
    lic_status BOOLEAN,
    PRIMARY KEY (lic_id),
    FOREIGN KEY (shop_id) REFERENCES Shop(shop_id)
);

CREATE TABLE Extension
(
    ext_id INT NOT NULL,
    lic_id INT NOT NULL,
    ext_period INT NOT NULL,
    ext_fee INT NOT NULL,
    mod_pay ENUM('cash', 'digital'),
    ext_status BOOLEAN,
    PRIMARY KEY (ext_id),
    FOREIGN KEY (shop_id) REFERENCES Shop(shop_id)
);


