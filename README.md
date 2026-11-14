# Heather Sweeney Database (SQL Server)

A relational database project implemented using Microsoft SQL Server. The project manages customers, seminars, contacts, products, invoices, and sales transactions. It includes database creation, sample data, integrity constraints, validation test cases, data quality checks, and SQL queries.

## Project Contents

| Section | Description |
|---|---|
| Database Creation | Creates the `heather sweeney` database. |
| Tables | Creates 7 relational tables with primary and foreign keys. |
| Sample Data | Inserts sample records, including 15 customers. |
| Test Cases | Tests CHECK, UNIQUE, and FOREIGN KEY constraints. |
| Data Quality | Calculates NULL value ratios for selected columns. |
| SQL Queries | Performs filtering, joins, aggregation, updates, and subqueries. |
| Views & Function | Creates invoice summary views and a customer name function. |

## Database Tables

- `customers` – Customer personal and contact information.
- `seminar` – Seminar details, dates, and locations.
- `seminar_customer` – Customer registrations for seminars.
- `contact` – Customer communication and seminar interactions.
- `products` – Product information, prices, and stock quantities.
- `invoice` – Customer invoices and payment details.
- `line_item` – Products and quantities included in invoices.

## Requirements

- Microsoft SQL Server
- SQL Server Management Studio (SSMS)

## Getting Started

1. Open SQL Server Management Studio.
2. Connect to your SQL Server instance.
3. Open the SQL script.
4. Execute the entire script.

The script creates the database, builds all 7 tables, inserts sample data, runs validation tests, checks NULL ratios, and executes example queries.

**Important:** The script is designed to create a new database. If the database already exists, remove it or modify the creation section before running the script again.

## SQL Concepts & Features

- Database and table creation (DDL).
- Data insertion and modification (DML).
- Primary keys and foreign key relationships.
- CHECK and UNIQUE constraints.
- INNER JOIN and subqueries.
- Aggregate functions (`SUM`, `AVG`, `COUNT`).
- Filtering using `WHERE` and `LIKE`.
- Views and user-defined functions.
- TRY...CATCH error handling.
- NULL value ratio analysis.
- Data integrity testing.

## Data Quality & Validation

The project includes five test cases to verify database constraints:

1. Reject invalid phone numbers.
2. Reject invalid email formats.
3. Prevent duplicate email addresses.
4. Prevent invoices for non-existing customers.
5. Prevent deleting customers with existing related records.

It also calculates the percentage of NULL values in selected columns across all seven tables.

## Technologies

- Microsoft SQL Server
- T-SQL
- SQL Server Management Studio (SSMS)

**Author:** Salma Sameh  
**Training:** NTI – DataOps Track
