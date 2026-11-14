/*==============================================================================
  Database : heather sweeney            (Microsoft SQL Server)
  Script   : creates the database, the 7 tables, loads the sample data,
             runs the test cases, the null value ratio check and the queries.
  Author   : Salma  -  DataOps, NTI
  Run the whole script in SSMS. It can be re-run: it drops and re-creates the DB.
==============================================================================*/

--------------------------------------------------------------------------------
-- 1. CREATE THE DATABASE
--------------------------------------------------------------------------------
USE master;
GO

CREATE DATABASE [heather sweeney];
GO
USE [heather sweeney];
GO

--------------------------------------------------------------------------------
-- 2. CREATE THE TABLES (all ID columns are VARCHAR, so there is no IDENTITY)
--------------------------------------------------------------------------------
CREATE TABLE customers (
    customerID        VARCHAR(10)  NOT NULL PRIMARY KEY,
    lastname          VARCHAR(50)  NOT NULL,
    firstname         VARCHAR(50)  NOT NULL,
    emailaddress      VARCHAR(100) NOT NULL UNIQUE
        CHECK (emailaddress LIKE '%@%._%'),
    encryptedpassword VARCHAR(255) NOT NULL,
    Phone             VARCHAR(20)  UNIQUE
        CHECK (
            Phone IS NULL OR
            (LEN(Phone) = 11 AND Phone NOT LIKE '%[^0-9]%')
        ),
    StreetAddress     VARCHAR(200) NOT NULL,
    City              VARCHAR(100) NOT NULL,
    governorate       VARCHAR(100),
    ZIP               VARCHAR(20)
);

CREATE TABLE seminar (
    seminarID       VARCHAR(10)  NOT NULL PRIMARY KEY,
    seminarDate     DATE         NOT NULL,
    seminarTime     TIME         NOT NULL,
    seminarLocation VARCHAR(100) NOT NULL
        CHECK (LEN(TRIM(seminarLocation)) > 0),
    seminarTitle    VARCHAR(200) NOT NULL
        CHECK (LEN(TRIM(seminarTitle)) > 0)
);

CREATE TABLE seminar_customer (
    seminarID  VARCHAR(10) NOT NULL,
    customerID VARCHAR(10) NOT NULL,
    CONSTRAINT pk_seminarcustomer PRIMARY KEY (seminarID, customerID),
    CONSTRAINT fk_seminarcustomer_seminar  FOREIGN KEY (seminarID)  REFERENCES seminar (seminarID),
    CONSTRAINT fk_seminarcustomer_customer FOREIGN KEY (customerID) REFERENCES customers (customerID)
);

CREATE TABLE contact (
    customerID    VARCHAR(10) NOT NULL,
    contactNumber INT         NOT NULL,
    contactDate   DATE        NOT NULL,
    contactType   VARCHAR(30) NOT NULL,
    seminarID     VARCHAR(10) NULL,
    CONSTRAINT pk_contact PRIMARY KEY (customerID, contactNumber),
    CONSTRAINT CONTACT_CUSTOMER_FK FOREIGN KEY (customerID) REFERENCES customers (customerID),
    CONSTRAINT CONTACT_SEMINAR_FK  FOREIGN KEY (seminarID)  REFERENCES seminar (seminarID)
);

CREATE TABLE products (
    productNumber      VARCHAR(10)   NOT NULL PRIMARY KEY,
    productType        VARCHAR(25)   NOT NULL,
    productDescription VARCHAR(100)  NOT NULL,
    unitPrice          DECIMAL(9,2)  NOT NULL,
    quantityOnHand     INT           NOT NULL
);

CREATE TABLE invoice (
    invoiceNumber VARCHAR(10)  NOT NULL PRIMARY KEY,
    invoiceDate   DATE         NOT NULL,
    customerID    VARCHAR(10)  NOT NULL,
    paymentType   VARCHAR(30),
    subTotal      DECIMAL(9,2),
    shipping      DECIMAL(9,2),
    tax           DECIMAL(9,2),
    total         DECIMAL(9,2),
    CONSTRAINT fk_invoicecustomer FOREIGN KEY (customerID) REFERENCES customers (customerID)
);

CREATE TABLE line_item (
    invoiceNumber VARCHAR(10)  NOT NULL,
    lineNumber    INT          NOT NULL,
    productNumber VARCHAR(10)  NOT NULL,
    quantity      INT          NOT NULL,
    unitPrice     DECIMAL(9,2) NOT NULL,
    total         DECIMAL(9,2),
    CONSTRAINT pk_lineItem PRIMARY KEY (invoiceNumber, lineNumber),
    CONSTRAINT fk_lineItem_product FOREIGN KEY (productNumber) REFERENCES products (productNumber),
    CONSTRAINT fk_lineItem_invoice FOREIGN KEY (invoiceNumber) REFERENCES invoice (invoiceNumber)
);
GO

--------------------------------------------------------------------------------
-- 3. INSERT THE DATA  (parents first, then the child tables)
--------------------------------------------------------------------------------

/***** CUSTOMERS: 15 customers, IDs C001 to C015 *****/
INSERT INTO customers (customerID, lastname, firstname, emailaddress, encryptedpassword,
                       Phone, StreetAddress, City, governorate, ZIP) VALUES
('C001', 'Jacobs',   'Nancy',   'Nancy.Jacobs@somewhere.com',   'nf46tG9E', '81787181234', '1440 West Palm Drive',      'Fort Worth', 'TX', '76110'),
('C002', 'Jacobs',   'Chantel', 'Chantel.Jacobs@somewhere.com', 'b65TG03f', '81787118234', '1550 East Palm Drive',      'Fort Worth', 'TX', '76112'),
('C003', 'Able',     'Ralph',   'Ralph.Able@somewhere.com',     'm56fGH08', '02102817987', '123 Elm Street',            'San Antonio','TX', '78214'),
('C004', 'Baker',    'Susan',   'Susan.Baker@elsewhere.com',    'PC93fEk9', '02102817876', '456 Oak Street',            'San Antonio','TX', '78216'),
('C005', 'Eagleton', 'Sam',     'Sam.Eagleton@elsewhere.com',   'bnvR44W8', '21028155765', '789 Pine Street',           'San Antonio','TX', '78218'),
('C006', 'Foxtrot',  'Kathy',   'Kathy.Foxtrot@somewhere.com',  'aa8tY4GL', '97202336234', '11023 Elm Street',          'Dallas',     'TX', '75220'),
('C007', 'George',   'Sally',   'Sally.George@somewhere.com',   'LK8G2tyF', '97242336345', '12034 San Jacinto',         'Dallas',     'TX', '75223'),
('C008', 'Hullett',  'Shawn',   'Shawn.Hullett@elsewhere.com',  'bu78WW3t', '97242336456', '13045 Flora',               'Dallas',     'TX', '75224'),
('C009', 'Pearson',  'Bobbi',   'Bobbi.Pearson@elsewhere.com',  'kq6N2O0p', '51219743344', '43 West 23rd Street',       'Austin',     'TX', '78710'),
('C010', 'Ranger',   'Terry',   'Terry.Ranger@somewhere.com',   'bv3F9Qc4', '51279744455', '56 East 18th Street',       'Austin',     'TX', '78712'),
('C011', 'Tyler',    'Jenny',   'Jenny.Tyler@somewhere.com',    'Yu4be77Z', '97292336567', '14056 South Ervay Street',  'Dallas',     'TX', '75225'),
('C012', 'Wayne',    'Joan',    'Joan.Wayne@elsewhere.com',     'JW4TX6g',  '81766718245', '1660 South Aspen Drive',    'Fort Worth', 'TX', '76115'),
('C013', 'Nguyen',   'Linh',    'Linh.Nguyen@somewhere.com',    'Lp7sQ2dX', '97242336678', '15067 Preston Road',        'Dallas',     'TX', '75230'),
('C014', 'Ortega',   'Marcus',  'Marcus.Ortega@elsewhere.com',  'mO3rT9vK', '97242336789', '16078 Greenville Avenue',   'Dallas',     'TX', '75231'),
('C015', 'Patel',    'Anita',   'Anita.Patel@somewhere.com',    'aP5nB8wZ', '97242336890', '17089 Lemmon Avenue',       'Dallas',     'TX', '75235');

/***** SEMINAR *****/
INSERT INTO seminar (seminarID, seminarDate, seminarTime, seminarLocation, seminarTitle) VALUES
('S001', '2017-10-12', '09:00', 'San Antonio Convention Center', 'Kitchen on a Budget'),
('S002', '2017-10-26', '10:00', 'Dallas Convention Center',      'Kitchen on a Big D Budget'),
('S003', '2017-11-02', '09:00', 'Austin Convention Center',      'Kitchen on a Budget'),
('S004', '2018-03-22', '10:00', 'Dallas Convention Center',      'Kitchen on a Big D Budget'),
('S005', '2018-03-23', '14:00', 'Dallas Convention Center',      'Kitchen on a Big D Budget'),
('S006', '2018-04-05', '09:00', 'Austin Convention Center',      'Kitchen on a Budget');

/***** SEMINAR_CUSTOMER *****/
INSERT INTO seminar_customer (seminarID, customerID) VALUES
('S001', 'C001'), ('S001', 'C003'), ('S001', 'C005'),
('S002', 'C006'), ('S002', 'C007'), ('S002', 'C008'),
('S002', 'C013'), ('S002', 'C014'), ('S002', 'C015'),
('S003', 'C009'), ('S003', 'C010'),
('S004', 'C006'), ('S004', 'C007'), ('S004', 'C011'), ('S004', 'C012');

/***** CONTACT *****/
-- Seminar 1 visits
INSERT INTO contact (customerID, contactNumber, contactDate, contactType, seminarID) VALUES
('C001', 1, '2017-10-12', 'Seminar', 'S001'),
('C006', 1, '2017-10-12', 'Seminar', 'S001'),
('C003', 1, '2017-10-12', 'Seminar', 'S001'),
('C007', 1, '2017-10-12', 'Seminar', 'S001'),
('C005', 1, '2017-10-12', 'Seminar', 'S001');
INSERT INTO contact (customerID, contactNumber, contactDate, contactType) VALUES
('C001', 2, '2017-10-15', 'EmailSeminarMessage'),
('C008', 2, '2017-10-15', 'EmailSeminarMessage'),
('C003', 2, '2017-10-15', 'EmailSeminarMessage'),
('C009', 2, '2017-10-15', 'EmailSeminarMessage'),
('C005', 2, '2017-10-15', 'EmailSeminarMessage'),
('C001', 3, '2017-10-15', 'FormLetterSeminar'),
('C010', 3, '2017-10-15', 'FormLetterSeminar'),
('C003', 3, '2017-10-15', 'FormLetterSeminar'),
('C011', 3, '2017-10-15', 'FormLetterSeminar'),
('C005', 3, '2017-10-15', 'FormLetterSeminar');
-- Seminar 2 visits (Nguyen, Patel, Ortega)
INSERT INTO contact (customerID, contactNumber, contactDate, contactType, seminarID) VALUES
('C013', 1, '2017-10-26', 'Seminar', 'S002'),
('C015', 1, '2017-10-26', 'Seminar', 'S002'),
('C014', 1, '2017-10-26', 'Seminar', 'S002');
INSERT INTO contact (customerID, contactNumber, contactDate, contactType) VALUES
('C006', 2, '2017-10-30', 'EmailSeminarMessage'),
('C007', 2, '2017-10-30', 'EmailSeminarMessage'),
('C006', 3, '2017-10-30', 'FormLetterSeminar'),
('C007', 3, '2017-10-30', 'FormLetterSeminar'),
('C008', 3, '2017-10-30', 'FormLetterSeminar');
-- Seminar 3 visits (Pearson, Ranger)
INSERT INTO contact (customerID, contactNumber, contactDate, contactType, seminarID) VALUES
('C009', 1, '2017-11-02', 'Seminar', 'S003'),
('C010', 1, '2017-11-02', 'Seminar', 'S003');
INSERT INTO contact (customerID, contactNumber, contactDate, contactType) VALUES
('C010', 2, '2017-11-06', 'EmailSeminarMessage'),
('C009', 3, '2017-11-06', 'FormLetterSeminar'),
('C010', 4, '2017-11-06', 'FormLetterSeminar');
-- Seminar 4 visits (Foxtrot, George, Tyler, Wayne)
INSERT INTO contact (customerID, contactNumber, contactDate, contactType, seminarID) VALUES
('C006', 6, '2018-03-22', 'Seminar', 'S004'),
('C007', 6, '2018-03-22', 'Seminar', 'S004'),
('C011', 1, '2018-03-22', 'Seminar', 'S004'),
('C012', 1, '2018-03-22', 'Seminar', 'S004');

/***** PRODUCTS (VK = video, VC = video companion, BK = book) *****/
INSERT INTO products (productNumber, productType, productDescription, unitPrice, quantityOnHand) VALUES
('VK001', 'Video',           'Kitchen Remodeling Basics',                              14.95, 50),
('VK002', 'Video',           'Advanced Kitchen Remodeling',                            14.95, 35),
('VK003', 'Video',           'Kitchen Remodeling Dallas Style',                        19.95, 25),
('VK004', 'Video',           'Heather Sweeney Seminar Live in Dallas on 25-OCT-16',    24.95, 20),
('VC001', 'Video Companion', 'Kitchen Remodeling Basics',                               7.99, 50),
('VC002', 'Video Companion', 'Advanced Kitchen Remodeling I',                           7.99, 35),
('VC003', 'Video Companion', 'Kitchen Remodeling Dallas Style',                         9.99, 25),
('BK001', 'Book',            'Kitchen Remodeling Basics For Everyone',                 24.95, 75),
('BK002', 'Book',            'Advanced Kitchen Remodeling For Everyone',               24.95, 75),
('BK003', 'Book',            'Kitchen Remodeling Dallas Style For Everyone',           24.95, 75);

/***** INVOICE *****/
INSERT INTO invoice (invoiceNumber, invoiceDate, customerID, paymentType, subTotal, shipping, tax, total) VALUES
('INV001', '2017-10-15', 'C003', 'VISA',       22.94, 5.95, 1.31,  30.20),
('INV002', '2017-12-20', 'C007', 'VISA',       24.95, 5.95, 1.42,  32.32),
('INV003', '2018-03-25', 'C013', 'MasterCard', 64.85, 5.95, 3.70,  74.50),
('INV004', '2018-03-27', 'C006', 'MasterCard', 94.79, 5.95, 5.40, 106.14),
('INV005', '2018-03-27', 'C007', 'MasterCard', 94.80, 5.95, 5.40, 106.15),
('INV006', '2018-03-31', 'C009', 'VISA',       47.89, 5.95, 2.73,  56.57),
('INV007', '2018-04-03', 'C011', 'MasterCard',109.78, 5.95, 6.26, 121.99),
('INV008', '2018-04-08', 'C005', 'MasterCard', 47.89, 5.95, 2.73,  56.57),
('INV009', '2018-04-08', 'C001', 'VISA',       47.89, 5.95, 2.73,  56.57),
('INV010', '2018-04-23', 'C003', 'VISA',       24.95, 5.95, 1.42,  32.32),
('INV011', '2018-05-07', 'C009', 'VISA',       22.94, 5.95, 1.31,  30.20),
('INV012', '2018-05-21', 'C008', 'MasterCard', 54.89, 5.95, 3.13,  63.97),
('INV013', '2018-06-05', 'C003', 'VISA',       47.89, 5.95, 2.73,  56.57),
('INV014', '2018-06-05', 'C011', 'MasterCard', 45.88, 5.95, 2.62,  54.45),
('INV015', '2018-06-05', 'C012', 'MasterCard', 94.79, 5.95, 5.40, 106.14),
('INV016', '2018-06-05', 'C003', 'VISA',       45.88, 5.95, 2.62,  54.45);

/***** LINE_ITEM *****/
INSERT INTO line_item (invoiceNumber, lineNumber, productNumber, quantity, unitPrice, total) VALUES
('INV001', 1, 'VK001', 1, 14.95, 14.95),
('INV002', 2, 'VK002', 1,  7.99,  7.99),
('INV003', 1, 'VK003', 1, 14.95, 14.95),
('INV004', 2, 'VK004', 1,  7.99,  7.99),
('INV005', 3, 'VC001', 1, 24.95, 24.95),
('INV006', 1, 'VC002', 1, 24.95, 24.95),
('INV007', 1, 'VC003', 1, 14.95, 14.95),
('INV008', 2, 'BK001', 1, 24.95, 24.95),
('INV009', 3, 'BK002', 1, 24.95, 24.95),
('INV010', 1, 'BK003', 1, 14.95, 14.95),
('INV011', 2, 'VK001', 1, 24.95, 24.95),
('INV012', 3, 'VK002', 1, 19.95, 19.95),
('INV013', 4, 'VK003', 1,  9.99,  9.99),
('INV014', 5, 'VK004', 1, 24.95, 24.95),
('INV015', 1, 'VC001', 1, 14.95, 14.95),
('INV016', 2, 'VC002', 1, 24.95, 24.95);
GO

-- Check the loaded data
SELECT * FROM customers;
SELECT * FROM seminar;
SELECT * FROM seminar_customer;
SELECT * FROM contact;
SELECT * FROM products;
SELECT * FROM invoice;
SELECT * FROM line_item;
GO

--------------------------------------------------------------------------------
-- 4. TEST CASES  (run after the data is loaded)
--    Each test is wrapped in TRY...CATCH. A test PASSES when SQL Server rejects
--    the statement.
--------------------------------------------------------------------------------

-- TEST CASE 1: Phone number with more than 11 digits -> CHECK constraint on Phone
BEGIN TRY
    INSERT INTO customers (customerID, lastname, firstname, emailaddress, encryptedpassword, Phone,
                           StreetAddress, City, governorate, ZIP)
    VALUES ('C900', 'amira', 'elamir', 'amira@gmail.com', 'hashed_password_example4',
            '010123456766',                      -- 12 digits
            'obour', 'cairo', 'cairo', '11384');
    SELECT 'TEST 1: FAILED - row was accepted' AS result;
END TRY
BEGIN CATCH
    SELECT 'TEST 1: PASSED - rejected' AS result, ERROR_NUMBER() AS error_no, ERROR_MESSAGE() AS error_message;
END CATCH;
GO

-- TEST CASE 2: E-mail address without "@" -> CHECK constraint on emailaddress
BEGIN TRY
    INSERT INTO customers (customerID, lastname, firstname, emailaddress, encryptedpassword, Phone,
                           StreetAddress, City, governorate, ZIP)
    VALUES ('C901', 'Test', 'Bad Email', 'not-an-email', 'pw123456',
            '01012345678', '1 Test Street', 'Cairo', 'Cairo', '11111');
    SELECT 'TEST 2: FAILED - row was accepted' AS result;
END TRY
BEGIN CATCH
    SELECT 'TEST 2: PASSED - rejected' AS result, ERROR_NUMBER() AS error_no, ERROR_MESSAGE() AS error_message;
END CATCH;
GO

-- TEST CASE 3: Duplicate e-mail address -> UNIQUE constraint on emailaddress
BEGIN TRY
    INSERT INTO customers (customerID, lastname, firstname, emailaddress, encryptedpassword, Phone,
                           StreetAddress, City, governorate, ZIP)
    VALUES ('C902', 'Copy', 'Nancy', 'Nancy.Jacobs@somewhere.com', 'pw123456',
            '01099998888', '2 Test Street', 'Cairo', 'Cairo', '11111');
    SELECT 'TEST 3: FAILED - row was accepted' AS result;
END TRY
BEGIN CATCH
    SELECT 'TEST 3: PASSED - rejected' AS result, ERROR_NUMBER() AS error_no, ERROR_MESSAGE() AS error_message;
END CATCH;
GO

-- TEST CASE 4: Invoice for a customer that does not exist -> FOREIGN KEY fk_invoicecustomer
BEGIN TRY
    INSERT INTO invoice (invoiceNumber, invoiceDate, customerID, paymentType,
                         subTotal, shipping, tax, total)
    VALUES ('INV999', '2018-07-01', 'C999', 'VISA', 10.00, 5.95, 0.50, 16.45);   -- C999 does not exist
    SELECT 'TEST 4: FAILED - row was accepted' AS result;
END TRY
BEGIN CATCH
    SELECT 'TEST 4: PASSED - rejected' AS result, ERROR_NUMBER() AS error_no, ERROR_MESSAGE() AS error_message;
END CATCH;
GO

-- TEST CASE 5: Delete a customer that still has child rows -> FOREIGN KEY (NO ACTION)
--              Ralph Able (C003) has seminar_customer, contact and invoice rows.
BEGIN TRY
    DELETE FROM customers WHERE emailaddress = 'Ralph.Able@somewhere.com';
    SELECT 'TEST 5: FAILED - parent row was deleted' AS result;
END TRY
BEGIN CATCH
    SELECT 'TEST 5: PASSED - rejected' AS result, ERROR_NUMBER() AS error_no, ERROR_MESSAGE() AS error_message;
END CATCH;
GO

--------------------------------------------------------------------------------
-- 5. NULL VALUE RATIO CHECK: one column per table
--    null_ratio_pct = rows where the column IS NULL / all rows * 100
--------------------------------------------------------------------------------
SELECT 'customers' AS table_name, 'governorate' AS column_name,
       COUNT(*) AS total_rows,
       SUM(CASE WHEN governorate IS NULL THEN 1 ELSE 0 END) AS null_rows,
       CAST(100.0 * SUM(CASE WHEN governorate IS NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS DECIMAL(5,2)) AS null_ratio_pct
FROM customers
UNION ALL
SELECT 'seminar', 'seminarLocation', COUNT(*),
       SUM(CASE WHEN seminarLocation IS NULL THEN 1 ELSE 0 END),
       CAST(100.0 * SUM(CASE WHEN seminarLocation IS NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS DECIMAL(5,2))
FROM seminar
UNION ALL
SELECT 'seminar_customer', 'customerID', COUNT(*),
       SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END),
       CAST(100.0 * SUM(CASE WHEN customerID IS NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS DECIMAL(5,2))
FROM seminar_customer
UNION ALL
SELECT 'contact', 'seminarID', COUNT(*),
       SUM(CASE WHEN seminarID IS NULL THEN 1 ELSE 0 END),
       CAST(100.0 * SUM(CASE WHEN seminarID IS NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS DECIMAL(5,2))
FROM contact
UNION ALL
SELECT 'products', 'quantityOnHand', COUNT(*),
       SUM(CASE WHEN quantityOnHand IS NULL THEN 1 ELSE 0 END),
       CAST(100.0 * SUM(CASE WHEN quantityOnHand IS NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS DECIMAL(5,2))
FROM products
UNION ALL
SELECT 'invoice', 'paymentType', COUNT(*),
       SUM(CASE WHEN paymentType IS NULL THEN 1 ELSE 0 END),
       CAST(100.0 * SUM(CASE WHEN paymentType IS NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS DECIMAL(5,2))
FROM invoice
UNION ALL
SELECT 'line_item', 'total', COUNT(*),
       SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END),
       CAST(100.0 * SUM(CASE WHEN total IS NULL THEN 1 ELSE 0 END) / NULLIF(COUNT(*), 0) AS DECIMAL(5,2))
FROM line_item;
GO

--------------------------------------------------------------------------------
-- 6. QUERIES
--------------------------------------------------------------------------------

-- F. Customers who live in Dallas
SELECT lastname, firstname, phone
FROM   customers
WHERE  city = 'Dallas';

-- G. Dallas customers whose last name begins with T
SELECT lastname, firstname, phone
FROM   customers
WHERE  city = 'Dallas'
  AND  lastname LIKE 'T%';

-- H. Invoices that include the Dallas seminar video (subquery)
SELECT invoiceNumber
FROM   invoice
WHERE  invoiceNumber IN
       (SELECT invoiceNumber
        FROM   line_item
        WHERE  productNumber IN
               (SELECT productNumber
                FROM   products
                WHERE  productDescription =
                       'Heather Sweeney Seminar Live in Dallas on 25-OCT-16'))
ORDER BY invoiceNumber;

-- I. Same question with JOIN ... ON
SELECT invoice.invoiceNumber
FROM   invoice
JOIN   line_item ON invoice.invoiceNumber  = line_item.invoiceNumber
JOIN   products  ON line_item.productNumber = products.productNumber
WHERE  products.productDescription =
       'Heather Sweeney Seminar Live in Dallas on 25-OCT-16'
ORDER BY invoice.invoiceNumber;

-- J. Customers who attended "Kitchen on a Big D Budget", each listed once
SELECT DISTINCT C.firstname, C.lastname, C.phone
FROM   customers C
JOIN   seminar_customer SC ON C.customerID = SC.customerID
JOIN   seminar S           ON SC.seminarID = S.seminarID
WHERE  S.seminarTitle = 'Kitchen on a Big D Budget'
ORDER BY C.lastname DESC, C.firstname DESC;

-- K. Customers who purchased a video (product numbers start with VK)
SELECT DISTINCT C.firstname, C.lastname, C.phone,
       P.productNumber, P.productDescription
FROM   customers C
JOIN   invoice   I ON C.customerID    = I.customerID
JOIN   line_item L ON I.invoiceNumber = L.invoiceNumber
JOIN   products  P ON L.productNumber = P.productNumber
WHERE  P.productNumber LIKE 'VK%'
ORDER BY C.lastname DESC, C.firstname DESC, P.productNumber DESC;

-- L. Sum of SubTotal
SELECT SUM(subTotal) AS SumOfSubTotal
FROM   invoice;

-- M. Average of SubTotal
SELECT AVG(subTotal) AS AverageOfSubTotal
FROM   invoice;

-- N. Both in one statement
SELECT SUM(subTotal) AS SumOfSubTotal,
       AVG(subTotal) AS AverageOfSubTotal
FROM   invoice;

-- O. Raise the price of VK004 from 24.95 to 34.95
UPDATE products
SET    unitPrice = 34.95
WHERE  productNumber = 'VK004';

-- P. Undo the change
UPDATE products
SET    unitPrice = 24.95
WHERE  productNumber = 'VK004';
GO

-- View: invoice summary
CREATE VIEW InvoiceSummaryView AS
SELECT I.invoiceNumber, I.invoiceDate, L.lineNumber,
       L.productNumber, P.productDescription, L.unitPrice
FROM   invoice I
JOIN   line_item L ON I.invoiceNumber  = L.invoiceNumber
JOIN   products  P ON L.productNumber  = P.productNumber;
GO

SELECT * FROM InvoiceSummaryView
ORDER BY invoiceNumber, lineNumber;
GO

-- Function: first name first (SQL Server syntax)
CREATE FUNCTION dbo.FirstNameFirst (@FirstName CHAR(25), @LastName CHAR(25))
RETURNS VARCHAR(51)
AS
BEGIN
    RETURN RTRIM(@FirstName) + ' ' + RTRIM(@LastName);
END;
GO

SELECT dbo.FirstNameFirst('Steve', 'Smith') AS FullName;
GO

-- View: customer invoice summary
CREATE VIEW CustomerInvoiceSummaryView AS
SELECT I.invoiceNumber, I.invoiceDate,
       dbo.FirstNameFirst(C.firstname, C.lastname) AS CustomerName,
       C.emailaddress, I.total
FROM   invoice I
JOIN   customers C ON I.customerID = C.customerID;
GO

SELECT * FROM CustomerInvoiceSummaryView
ORDER BY invoiceNumber;
GO

--------------------------------------------------------------------------------
-- Q. DELETE every row but keep the tables.   *** DO NOT RUN ON THE REAL DATABASE ***
--    The foreign keys have no ON DELETE action, so the children must go first.
--    (Commented out so that running the whole script does not empty the database.)
--------------------------------------------------------------------------------
-- DELETE FROM line_item;
-- DELETE FROM invoice;
-- DELETE FROM contact;
-- DELETE FROM seminar_customer;
-- DELETE FROM customers;
-- DELETE FROM seminar;
-- DELETE FROM products;