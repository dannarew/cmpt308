Student Club Management System (CMPT308 - Lab 3)
📖 Scenario
This database tracks the organizational structure of Student Clubs on a university campus. It manages three core areas:

Students: Individual students identified by their names and unique emails.

Departments: Academic divisions (e.g., Science, Engineering) that host various clubs.

Clubs: Organizations belonging to a specific department.

Memberships: The many-to-many relationship between Students and Clubs, capturing specific details like the date they joined and their specific role (President, Member, etc.).

🛠️ Database Design Summary
Entities & Relationships

Students & Clubs (Many-to-Many): A student can join multiple clubs, and a club can have many students. This is resolved via the memberships join table.

Departments & Clubs (One-to-Many): Each club is hosted by one department, but a department can host multiple clubs.

Schema Details

Join Table (memberships): This table stores the relationship attributes join_date and member_role.

Constraints:

Primary Keys: Ensure uniqueness for students, clubs, and departments.

Foreign Keys: Maintain referential integrity (e.g., you cannot add a membership for a student who doesn't exist).

CHECK Constraint: Ensures club_name length is at least 3 characters to prevent low-quality data entry.

NULLs: The member_role column allows NULL values for general members without specific titles.

🚀 How to Run lab3.sql
To set up the database and verify the results, follow these steps:

Create the Database:

Open pgAdmin 4.

Right-click on Databases > Create > Database....

Name the database cmpt308_lab3.

Open the Query Tool:

Select your new cmpt308_lab3 database.

Click the Query Tool icon in the top toolbar.

Execute the Script:

Open the lab3.sql file from this repository.

Copy the entire content and paste it into the pgAdmin Query Tool.

Press F5 or click the Execute/Refresh button.

Verify Results:

Check the "Messages" tab to ensure the tables were created and data was inserted successfully.

The script includes the required JOIN queries at the bottom; you can run them individually to see the output in the "Data Output" tab.

Note: The final two INSERT statements are designed to fail. This is intentional to test the PK/FK and CHECK constraints.

📂 Repository Structure
lab3.sql: Contains all DDL (Create), DML (Insert), and DQL (Select/Join) statements.

README.md: Project documentation (this file).
