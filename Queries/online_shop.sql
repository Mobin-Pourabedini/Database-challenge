create table customers
(
    customerNumber      int
        constraint customers_pk
            primary key,
    customerName        VARCHAR(50),
    contactLastName     VARCHAR(50),
    contactFirstName    VARCHAR(50),
    phone               VARCHAR(50),
    addressLine1        VARCHAR(50),
    addressLine2        VARCHAR(50),
    city                VARCHAR(50),
    "state"             VARCHAR(50),
    postalCode          VARCHAR(15),
    country            VARCHAR(50),
    salesRepEmployeeNumber  int,
    creditLimit         decimal(10,2)
);

create table employees
(
    employeeNumber  int
        constraint employees_pk
            primary key,
    lastName    VARCHAR(50),
    firstName   VARCHAR(50),
    "extension" VARCHAR(10),
    email       VARCHAR(100),
    officeCode  VARCHAR(10),
    reportsTo   int,
    jobTitle    VARCHAR(50)
);


create table offices
(
    officeCode          VARCHAR(10)
        constraint offices_pk
            primary key,
    city                VARCHAR(50),
    phone               VARCHAR(50),
    addressLine1        VARCHAR(50),
    addressLine2        VARCHAR(50),
    "state"             VARCHAR(50),
    country             VARCHAR(50),
    postalCode          VARCHAR(15),
    territory           VARCHAR(10)
);

create table orderdetails
(
    orderNumber          int,
    productCode         VARCHAR(15),
    quantityOrdered     int,
    priceEach           decimal(10,2),
    orderLineNumber     smallint
);



create table orders
(
    orderNumber          int
        constraint orders_pk
            primary key,
    orderDate           date,
    requiredDate        date,
    shippedDate         date,
    status              VARCHAR(15),
    "comments"          text,
    customerNumber      int
);

create table payments
(
    customerNumber      int,
    checkNumber         VARCHAR(15),
    paymentDate         date,
    amount              decimal(10,2)
);

create table productlines
(
    productLine         VARCHAR(16)
        constraint productlines_pk
            primary key,
    textDescription     VARCHAR(4000),
    htmlDescription     TEXT,
    image               BYTEA
);

create table products
(
    productCode 	VARCHAR(15),
    productName 	VARCHAR(70),
    productLine 	VARCHAR(50),
    productScale 	VARCHAR(10),
    productVendor 	VARCHAR(50),
    productDescription 	text,
    quantityInStock 	smallint,
    buyPrice 	decimal(10,2),
    MSRP 	decimal(10,2)
);

-- FIRST PART
SELECT employeeNumber, CONCAT(employees.firstName , ' ', employees.lastName) AS NAME, count(*) AS CustomersCount
FROM employees
JOIN customers ON employeeNumber = salesRepEmployeeNumber
GROUP BY employeeNumber, CONCAT(employees.firstName , ' ', employees.lastName)
ORDER BY CustomersCount DESC;


-- SECOND PART
SELECT customerNumber
FROM (
         SELECT customers.customerNumber, SUM(priceEach * quantityOrdered) AS PRICE
         FROM customers
                  JOIN orders ON customers.customerNumber = orders.customerNumber
                  JOIN orderdetails ON orders.orderNumber = orderdetails.orderNumber
         GROUP BY customers.customerNumber
         ORDER BY PRICE DESC
         LIMIT 5
     ) AS X;

-- THIRD PART
SELECT productlines.productLine, products.productName, (MSRP-buyPrice)*quantityInStock AS VALUE,
       RANK() OVER (PARTITION BY products.productLine ORDER BY (MSRP-buyPrice)*quantityInStock DESC) AS VALUE_RANK
FROM products
JOIN productlines ON products.productLine = productlines.productLine
ORDER BY products.productLine, VALUE DESC;