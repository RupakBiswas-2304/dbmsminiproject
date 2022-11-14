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

--  _Designation Table
CREATE TABLE `_Designation` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    designation VARCHAR(50) NOT NULL,
    salary INT
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
    FOREIGN KEY (designation_id) REFERENCES `_Designation`(id)
);

--  DutyLog Table
CREATE TABLE `DutyLog` (
    id INT PRIMARY KEY AUTO_INCREMENT,
    staff_id INT NOT NULL,
    checkin_time DATETIME,
    checkout_time DATETIME,
    FOREIGN KEY (staff_id) REFERENCES `Staff`(id)
);