import psycopg2
from psycopg2 import Error

# --- Configuration ---
DB_HOST = "localhost"
DB_NAME = "postgres" 
DB_USER = "your_username" 
DB_PASSWORD = "your_password"

def connect():
    """Connects to the PostgreSQL database server."""
    try:
        connection = psycopg2.connect(
            user=DB_USER,
            password=DB_PASSWORD,
            host=DB_HOST,
            port="5432",
            database=DB_NAME
        )
        return connection
    except Error as e:
        print(f"Error connecting to PostgreSQL: {e}")
        return None

def view_daily_schedule(connection):
    """Executes the Basic Filter/Order Query (Query 1)."""
    date_input = input("\nEnter schedule date (YYYY-MM-DD) [Default: 2026-05-10]: ") or "2026-05-10"
    
    try:
        cursor = connection.cursor()
        query = """
            SELECT SessionDate, StartTime, EndTime, CourseCode, Status
            FROM Session
            WHERE SessionDate = %s AND Status = 'Scheduled'
            ORDER BY StartTime ASC;
        """
        cursor.execute(query, (date_input,))
        records = cursor.fetchall()

        print(f"\n--- Scheduled Sessions for {date_input} ---")
        if not records:
            print("No scheduled sessions found for this date.")
        else:
            print(f"{'Start':<10} | {'End':<10} | {'Course':<10} | {'Status'}")
            print("-" * 45)
            for row in records:
                print(f"{str(row[1]):<10} | {str(row[2]):<10} | {row[3]:<10} | {row[4]}")
        cursor.close()
    except Error as e:
        print(f"Error executing query: {e}")

def view_tutor_directory(connection):
    """Executes the Join Query 2 (M:N Resolution)."""
    try:
        cursor = connection.cursor()
        query = """
            SELECT t.Name, c.CourseCode, c.CourseName 
            FROM Tutor t
            JOIN Tutor_Course tc ON t.TutorID = tc.TutorID
            JOIN Course c ON tc.CourseCode = c.CourseCode
            ORDER BY t.Name, c.CourseCode;
        """
        cursor.execute(query)
        records = cursor.fetchall()

        print("\n--- Tutor Subject Directory ---")
        print(f"{'Tutor Name':<20} | {'Code':<10} | {'Course Name'}")
        print("-" * 65)
        for row in records:
            print(f"{row[0]:<20} | {row[1]:<10} | {row[2]}")
        cursor.close()
    except Error as e:
        print(f"Error executing query: {e}")

def main():
    print("Welcome to the Campus Tutoring Center System")
    connection = connect()
    
    if not connection:
        return

    while True:
        print("\nMain Menu:")
        print("1. View Daily Schedule")
        print("2. View Tutor Directory")
        print("3. Exit")
        
        choice = input("Enter your choice (1-3): ")
        
        if choice == '1':
            view_daily_schedule(connection)
        elif choice == '2':
            view_tutor_directory(connection)
        elif choice == '3':
            print("Exiting system. Goodbye!")
            break
        else:
            print("Invalid choice. Please try again.")

    if connection:
        connection.close()

if __name__ == "__main__":
    main()
