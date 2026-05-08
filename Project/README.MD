# Campus Tutoring Center Scheduling System

**Author:** Daniel Narewski
**Course:** CMPT308N Database Management

## Project Overview
This repository contains the final database implementation for the Campus Tutoring Center Scheduling System. The project replaces manual spreadsheet scheduling with a centralized PostgreSQL database to manage student demand, tutor availability, and specific course competencies.

## Files Included
* `project.sql`: The complete PostgreSQL script. This single file contains all `DROP TABLE` and `CREATE TABLE` statements, constraints, sample data inserts, a purposeful index, and the required query library.
* `cli.py`: An optional Python Command Line Interface (CLI) application submitted for the bonus extension. It connects to the PostgreSQL database to allow users to view daily schedules and browse the tutor directory.
* `README.md`: This documentation file.

## How to Run the Database (SQL)
To grade the core database implementation, execute the `project.sql` file in your local PostgreSQL environment.

1. Open pgAdmin or your preferred PostgreSQL terminal.
2. Create or connect to a database (e.g., `postgres` or a newly created `tutoring_db`).
3. Open the `project.sql` file in the query tool.
4. Execute the entire script. 
   * *Note: The script begins with `DROP TABLE ... CASCADE` statements, so it is safe to run multiple times from top to bottom.*
5. The tables will be created, populated with sample data, and the required queries will be ready to execute.

## How to Run the Application Layer (Python CLI Bonus)
To test the Python CLI application:

1. Ensure you have Python installed on your machine.
2. Install the PostgreSQL adapter by running: `pip install psycopg2-binary`
3. Open `cli.py` in a text editor and update the `DB_USER` and `DB_PASSWORD` variables at the top of the file to match your local PostgreSQL credentials.
4. Run the script from your terminal: `python cli.py`
5. Follow the on-screen prompts to view the daily scheduled sessions or the tutor subject directory.
