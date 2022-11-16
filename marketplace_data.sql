load data local infile '/CSV/shop.csv'
into table Shop
fields terminated by ','
ignore 1 rows;

load data local infile '/CSV/shopkeeper.csv'
into table Shopkeeper
fields terminated by ','
ignore 1 rows;

load data local infile '/CSV/feedback.csv'
into table Feedback
fields terminated by ','
ignore 1 rows;

load data local infile '/CSV/bill.csv'
into table Bill
fields terminated by ','
ignore 1 rows;

load data local infile '/CSV/license.csv'
into table License
fields terminated by ','
ignore 1 rows;

load data local infile '/CSV/extension.csv'
into table Extension
fields terminated by ','
ignore 1 rows;

SELECT * FROM Shop;
SELECT * FROM Shopkeeper;
SELECT * FROM Feedback;
SELECT * FROM Bill;
SELECT * FROM License;
SELECT * FROM Extension;