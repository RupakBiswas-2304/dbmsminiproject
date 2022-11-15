
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


USE mini_project;

INSERT INTO `Guest`(`id`, `name`, `phone_no`, `email`, `address`) VALUES
    (1, 'Rupak Biswas', '1234567890', 'rupakbiswas2304@gmail.com', 'Tripura'),
    (2, 'Aman Agarwal', '1234567891', 'amanagarwal6969@gmail.com', 'Russia'),
    (3, 'Sanskriti Singh', '1234567892', 'sanskritisingh@gmail.com', 'Uttar Pradesh'),
    (4, 'Dinesh Chukkala', '1234567893', 'chukkaladinesh@gmail.com', 'Delhi');
    

INSERT INTO `GuestHouse` VALUES
    (1, 'Asima'),
    (2, 'Raman'),
    (3, 'Kalam');

INSERT INTO `_RoomType` VALUES
    (1, 2, 0, 1000),
    (2, 3, 0, 1500),
    (3, 4, 0, 2000),
    (4, 2, 1, 3000),
    (5, 3, 1, 3500),
    (6, 4, 1, 4000);

INSERT INTO `Room`(`room_no`, `guesthouse_id`, `block`, `vacant`, `maintenance`, `type`) VALUES 
    ('101', 1, 'A', 1, 0, 1),
    ('102', 1, 'A', 1, 1, 2),
    ('103', 1, 'A', 1, 1, 3),
    ('104', 1, 'A', 1, 1, 4),
    ('105', 1, 'A', 1, 1, 5),
    ('106', 1, 'A', 1, 1, 6),
    ('107', 1, 'A', 1, 1, 1),
    ('108', 1, 'A', 1, 1, 2),
    ('109', 1, 'A', 1, 1, 3),
    ('110', 1, 'A', 1, 1, 4),
    ('111', 1, 'B', 1, 1, 5),
    ('112', 1, 'B', 1, 0, 6),
    ('113', 1, 'B', 1, 0, 1),
    ('114', 1, 'B', 1, 0, 2),
    ('115', 1, 'B', 1, 0, 3),
    ('116', 1, 'B', 1, 0, 4),
    ('117', 1, 'B', 1, 0, 5),
    ('118', 1, 'B', 1, 0, 6),
    ('119', 1, 'B', 1, 0, 1),
    ('120', 1, 'B', 1, 0, 2),
    ('101', 2, 'A', 1, 0, 3),
    ('102', 2, 'A', 1, 1, 4),
    ('103', 2, 'A', 1, 1, 5),
    ('104', 2, 'A', 1, 1, 6),
    ('105', 2, 'A', 1, 1, 1),
    ('106', 2, 'A', 1, 1, 2),
    ('107', 2, 'A', 1, 1, 3),
    ('108', 2, 'A', 1, 1, 4),
    ('109', 2, 'A', 1, 1, 5),
    ('110', 2, 'A', 1, 1, 6),
    ('111', 2, 'B', 1, 1, 1),
    ('112', 2, 'B', 1, 0, 2),
    ('113', 2, 'B', 1, 0, 3),
    ('114', 2, 'B', 1, 0, 4),
    ('115', 2, 'B', 1, 0, 5),
    ('116', 2, 'B', 1, 0, 6),
    ('117', 2, 'B', 1, 0, 1),
    ('118', 2, 'B', 1, 0, 2),
    ('119', 2, 'B', 1, 0, 3),
    ('120', 2, 'B', 1, 0, 4),
    ('101', 3, 'A', 1, 0, 5),
    ('102', 3, 'A', 1, 1, 6),
    ('103', 3, 'A', 1, 1, 1),
    ('104', 3, 'A', 1, 1, 2),
    ('105', 3, 'A', 1, 1, 3),
    ('106', 3, 'A', 1, 1, 4),
    ('107', 3, 'A', 1, 1, 5),
    ('108', 3, 'A', 1, 1, 6),
    ('109', 3, 'A', 1, 1, 1),
    ('110', 3, 'A', 1, 1, 2),
    ('111', 3, 'B', 1, 1, 3),
    ('112', 3, 'B', 1, 0, 4),
    ('113', 3, 'B', 1, 0, 5),
    ('114', 3, 'B', 1, 0, 6),
    ('115', 3, 'B', 1, 0, 1),
    ('116', 3, 'B', 1, 0, 2),
    ('117', 3, 'B', 1, 0, 3),
    ('118', 3, 'B', 1, 0, 4),
    ('119', 3, 'B', 1, 0, 5),
    ('120', 3, 'B', 1, 0, 6);

INSERT INTO `_PaymentOption` VALUES
    (1, 'Cash'),
    (2, 'Credit Card'),
    (3, 'Debit Card'),
    (4, 'Net Banking');

INSERT INTO `FoodItem` VALUES
    (1, 'Burger', 100, 1),
    (2, 'Pizza', 200, 0),
    (3, 'Pasta', 300, 0),
    (4, 'Sandwich', 400, 1),
    (5, 'Biryani', 500, 0),
    (6, 'Noodles', 600, 1),
    (7, 'Fried Rice', 700, 0),
    (8, 'Samosa', 800, 1),
    (9, 'Pav Bhaji', 900, 0),
    (10, 'Dosa', 1000, 1);

INSERT INTO `_Designation` VALUES
    (1, 'Manager', 1000),
    (2, 'Receptionist', 700),
    (3, 'Chef',800),
    (4, 'Waiter', 700),
    (5, 'Cleaner', 500);

INSERT INTO `_StaffShift` VALUES
    (1, '8:00:00.000000', '16:00:00.000000'),
    (2, '16:00:00.000000', '24:00:00.000000'),
    (3, '24:00:00.000000', '8:00:00.000000');

INSERT INTO `Staff` VALUES
    ( 1, 'Manager Bhaia', '8365476574', 'manager@gmail.com', 'Bitha, Patna', 1, 0, 1),
    ( 2, 'Receptionist Bhaia', '8365476575', 'receptionist@gmail.com', 'Bitha, Patna', 2, 0, 2),
    ( 3, 'Chef Bhaia', '8365476576', 'cheff@gmail.com' , 'Bitha, Patna', 3, 0, 3);