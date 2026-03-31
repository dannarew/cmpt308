Lab 6: Indexes and Query Plans
Author: Daniel
Course: CMPT308

How to Run the SQL
Open TablePlus (or pgAdmin) and connect to the PostgreSQL database containing the Students, Courses, and Enrollments tables from the previous labs.

Open the lab6.sql file in the query editor.

Execute the file from top to bottom. It contains all the necessary EXPLAIN queries and CREATE INDEX statements, divided into parts using SQL comments.

Observations on Query Plans and Indexing
After generating baseline query plans in Part A and creating targeted single-column and composite indexes in Part B, the queries were re-run in Part C.

Postgres continued to choose Sequential Scans (Seq Scan) and Nested Loops over Index Scans for the filtered and joined queries. This occurred because the tables currently contain very little data. PostgreSQL calculates that the overhead of loading an index, finding the pointer, and jumping to the specific disk location is actually more expensive than simply reading a tiny table sequentially from top to bottom.

While the indexes did not change the query plan for this specific, small dataset, they would drastically reduce the execution cost and switch the query plans to Index Scans if these tables contained thousands or millions of rows.
