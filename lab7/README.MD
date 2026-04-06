# Lab 7: Transactions

**How to run:**
1. Open pgAdmin and connect to your PostgreSQL database.
2. Open `lab7.sql` in the query tool.
3. Run the setup block first to create and populate the table, then run the queries for Part B and Part C sequentially.

**What I learned:**
I learned how to use `BEGIN` to group multiple SQL statements into a single transaction so they execute as one unit. I also learned that `COMMIT` is required to permanently save those changes to the database, while `ROLLBACK` serves as a critical safety net to discard temporary changes and revert the database to its previous state if an error occurs.
