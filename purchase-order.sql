/* Purchase Order Database - SQL Practice */

/* Drop existing tables */
DROP TABLE lineitems CASCADE CONSTRAINTS;
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE customers CASCADE CONSTRAINTS;
DROP TABLE items CASCADE CONSTRAINTS;

/* Create ITEMS table */
CREATE TABLE items (
    itemno   NUMBER(5) PRIMARY KEY,
    itemname VARCHAR2(25),
    rate     NUMBER(8,2) CHECK (rate >= 0),
    taxrate  NUMBER(4,2)
);

/* Insert data into ITEMS */
INSERT INTO items VALUES (1,'Samsung Monitor',7000,10.5);
INSERT INTO items VALUES (2,'Logitech Keyboard',1000,10);
INSERT INTO items VALUES (3,'Seagate HDD 20GB',6500,12.5);
INSERT INTO items VALUES (4,'PIII Processor',8000,8);
INSERT INTO items VALUES (5,'Logitech Mouse',500,5);
INSERT INTO items VALUES (6,'Creative Speakers',4500,11.5);

/* Create CUSTOMERS table */
CREATE TABLE customers (
    custno   NUMBER(5) PRIMARY KEY,
    custname VARCHAR2(20) NOT NULL,
    dob      DATE,
    city     VARCHAR2(20),
    state    VARCHAR2(20)
);

/* Insert data into CUSTOMERS */
INSERT INTO customers VALUES (101,'Rahul',DATE '2017-01-12','Hubli','Karnataka');
INSERT INTO customers VALUES (102,'Pooja',DATE '2017-02-02','Dharwad','Karnataka');
INSERT INTO customers VALUES (103,'Mandeep',DATE '2017-02-10','Hyderabad','Andhra Pradesh');
INSERT INTO customers VALUES (104,'Poornima',DATE '2016-12-25','Bangalore','Karnataka');
INSERT INTO customers VALUES (105,'Ziya',DATE '2017-01-01','Vasco','Goa');

/* Create ORDERS table */
CREATE TABLE orders (
    ordno    NUMBER(5) PRIMARY KEY,
    orddate  DATE,
    shipdate DATE,
    custno   NUMBER(5) REFERENCES customers(custno)
);

/* Insert data into ORDERS */
INSERT INTO orders VALUES (1001,DATE '2017-01-08',DATE '2017-01-10',102);
INSERT INTO orders VALUES (1002,DATE '2016-06-18',DATE '2016-06-20',101);
INSERT INTO orders VALUES (1003,DATE '2017-02-10',DATE '2017-02-10',101);
INSERT INTO orders VALUES (1004,DATE '2016-05-18',DATE '2016-05-24',103);
INSERT INTO orders VALUES (1005,DATE '2016-06-20',DATE '2016-06-30',104);
INSERT INTO orders VALUES (1006,DATE '2017-01-15',NULL,104);

/* Create LINEITEMS table */
CREATE TABLE lineitems (
    ordno   NUMBER(5) REFERENCES orders(ordno),
    itemno  NUMBER(5) REFERENCES items(itemno),
    qty     NUMBER(3) CHECK (qty >= 1),
    price   NUMBER(8,2),
    discountrate NUMBER(4,2) DEFAULT 0,
    PRIMARY KEY (ordno, itemno)
);

/* Insert data into LINEITEMS */
INSERT INTO lineitems VALUES (1001,2,3,1000,10);
INSERT INTO lineitems VALUES (1001,1,3,7000,15);
INSERT INTO lineitems VALUES (1002,6,4,4500,20);
INSERT INTO lineitems VALUES (1003,5,10,500,0);
INSERT INTO lineitems VALUES (1004,1,1,7000,10);
INSERT INTO lineitems VALUES (1005,6,1,4600,10);
INSERT INTO lineitems VALUES (1006,2,10,950,20);

/* ------------------ ANALYTICAL QUERIES ------------------ */

/* 1. Total amount spent by each customer */
SELECT c.custname, SUM(l.qty * l.price) AS total_amount
FROM customers c
JOIN orders o ON c.custno = o.custno
JOIN lineitems l ON o.ordno = l.ordno
GROUP BY c.custname;

/* 2. Number of orders per customer */
SELECT custno, COUNT(*) AS total_orders
FROM orders
GROUP BY custno;

/* 3. Customer with highest number of orders */
SELECT custno, COUNT(*) AS total_orders
FROM orders
GROUP BY custno
ORDER BY total_orders DESC
FETCH FIRST 1 ROW ONLY;

/* 4. Customers whose name contains 'deep' */
SELECT state, COUNT(*) AS customer_count
FROM customers
WHERE LOWER(custname) LIKE '%deep%'
GROUP BY state;

/* 5. Orders count per date */
SELECT custno, orddate, COUNT(*) AS orders_count
FROM orders
GROUP BY custno, orddate;

/* 6. Number of items and average price per order */
SELECT ordno, COUNT(*) AS total_items, ROUND(AVG(price),2) AS avg_price
FROM lineitems
GROUP BY ordno;

/* 7. Orders containing item number 5 */
SELECT o.ordno, o.orddate, c.custname
FROM orders o
JOIN customers c ON o.custno = c.custno
JOIN lineitems l ON o.ordno = l.ordno
WHERE l.itemno = 5;

/* 8. Total units sold per item */
SELECT itemno, SUM(qty) AS total_units
FROM lineitems
GROUP BY itemno;

/* 9. Orders with total value greater than 10000 */
SELECT ordno
FROM lineitems
GROUP BY ordno
HAVING SUM(qty * price) > 10000;

/* 10. First order date and gap between first and last order */
SELECT custno,
       MIN(orddate) AS first_order,
       MAX(orddate) - MIN(orddate) AS gap_days
FROM orders
GROUP BY custno;