# Supermarket Relational DB

## Project Overview

The Supermarket Relational DB is an Oracle SQL project that demonstrates the design and implementation of a relational database for a retail management system. The database models suppliers, departments, products, employees, customers, orders, and sales transactions.

This project was originally created for academic purposes, but it has been enhanced and documented to showcase SQL skills suitable for professional review.

---

## Database Schema

**Tables Included:**

| Table             | Description                               |
|-------------------|-------------------------------------------|
| Address           | Stores addresses for suppliers, customers, and employees |
| Supplier          | Supplier details                          |
| Department        | Retail departments (e.g., Snacks, Produce, Meat) |
| Product           | Products with links to departments and suppliers |
| SupplierProduct   | Tracks supplier deliveries to store products |
| Employee          | Employee information including department and address |
| Customer          | Customer details                          |
| Order_Detail      | Customer orders including product and total amount |
| Sale_Info         | Sale transactions mapping orders to products |

---

## Setup Instructions

1. Clone this repository.
2. Import the SQL file into your database system (Oracle SQL / MySQL):
   ```bash
   mysql -u username -p < supermarket_relational_db.sql

