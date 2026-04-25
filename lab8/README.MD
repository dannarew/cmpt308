# Lab 8 - Database Roles, Functions, and Triggers

## What this Lab Demonstrates
This lab demonstrates how to implement database-level security and centralize business logic in PostgreSQL. Specifically, it covers:
* **Security & Authorization:** Creating distinct user roles (`advisor_role` and `registrar_role`) and applying the principle of least privilege using `GRANT` and `REVOKE`.
* **Centralized Logic:** Using a PL/pgSQL stored function (`register_student`) to handle course registration, ensuring data integrity by checking student existence, course capacity, and preventing duplicate enrollments in a single transaction.
* **Automated Auditing:** Implementing a database trigger that automatically logs a record to an audit table (`lab8_enrollment_audit`) whenever a new registration occurs.

## How to Run
1. Open pgAdmin (or your preferred PostgreSQL client) and connect to your database.
2. Open a new Query Tool.
3. Open the `lab8.sql` file and copy its entire contents into the Query Tool.
4. Execute the script. 
   * *Note: The script includes `DROP TABLE` and `DROP ROLE` statements at the top, so it can be safely run multiple times from a clean slate.*
5. To test the logic, highlight and execute the individual `SELECT` queries at the bottom of the file (under the Test Cases and Reports sections) and view the Data Output tab.
