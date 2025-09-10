# Parking Management System DB

## Project Overview

The Parking Management System DB is an Oracle SQL project that demonstrates the design and implementation of a relational database for managing parking operations.  
The database models customers, vehicles, parking zones, parking sessions, transactions, and customer feedback messages.

This project was originally created for academic purposes, but it has been enhanced and documented to showcase SQL and PL/SQL skills suitable for professional review.

---

## Database Schema

**Tables Included:**

| Table           | Description                                                  |
|-----------------|--------------------------------------------------------------|
| Customer        | Stores customer details including contact and payment info   |
| Vehicle         | Manages vehicle information linked to customers              |
| Zone            | Parking zones with capacity, rates, and availability         |
| ParkingSession  | Records customer parking sessions with start/end times       |
| Transaction     | Payment details for parking sessions                         |
| Message         | Customer feedback and system-generated notifications         |

---

## Setup Instructions

1. Clone this repository.
2. Import the SQL file into your Oracle SQL environment:
   ```bash
   sqlplus username/password@XE @parking_management.sql

