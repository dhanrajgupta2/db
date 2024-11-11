Problem Statement 1 (Triggers)
Employee(emp_id, emp_name, salary, designation) Salary_Backup(emp_id, old_salary, new_salary, salary_difference)
Create a Trigger to record salary change of the employee. Whenever salary is updated insert the details in Salary_Backup table.
Create a Trigger that will prevent deleting the employee record having designation as CEO.

solution 

step 1 : 

-- Create Employee table
CREATE TABLE Employee (
    emp_id NUMBER PRIMARY KEY,
    emp_name VARCHAR2(100),
    salary NUMBER,
    designation VARCHAR2(50)
);

-- Create Salary_Backup table to store salary change history
CREATE TABLE Salary_Backup (
    emp_id NUMBER,
    old_salary NUMBER,
    new_salary NUMBER,
    salary_difference NUMBER
);

step 2 : 

-- Insert sample data into Employee table
INSERT INTO Employee (emp_id, emp_name, salary, designation) 
VALUES (1, 'John Doe', 50000, 'Manager');

INSERT INTO Employee (emp_id, emp_name, salary, designation) 
VALUES (2, 'Jane Smith', 100000, 'CEO');

INSERT INTO Employee (emp_id, emp_name, salary, designation) 
VALUES (3, 'Alice Brown', 45000, 'Engineer');

INSERT INTO Employee (emp_id, emp_name, salary, designation) 
VALUES (4, 'Bob White', 60000, 'Manager');

step 3 : Create the Trigger to Record Salary Changes

CREATE OR REPLACE TRIGGER trg_salary_update
AFTER UPDATE OF salary ON Employee
FOR EACH ROW
BEGIN
    IF :OLD.salary != :NEW.salary THEN
        INSERT INTO Salary_Backup (emp_id, old_salary, new_salary, salary_difference)
        VALUES (:OLD.emp_id, :OLD.salary, :NEW.salary, :NEW.salary - :OLD.salary);
    END IF;
END;
/

step 4 : Create the Trigger to Prevent Deleting CEO

CREATE OR REPLACE TRIGGER trg_prevent_delete_ceo
BEFORE DELETE ON Employee
FOR EACH ROW
BEGIN
    IF :OLD.designation = 'CEO' THEN
        RAISE_APPLICATION_ERROR(-20001, 'Cannot delete record with designation as CEO.');
    END IF;
END;
/

step 5 : Test the Triggers

-- Update salary for employee with emp_id 1
UPDATE Employee
SET salary = 55000
WHERE emp_id = 1;

step 6 : 

SELECT * FROM Salary_Backup;

step 7 : Attempt to Delete CEO Record

-- Try to delete the CEO record
DELETE FROM Employee
WHERE emp_id = 2;

<=============================================================================================================================================================================================================================================================================================================>

Problem Statement 2

Implement MYSQL database connectivity with PHP

( connectivity )

<?php
$con=mysqli_connect('localhost','root','','student_info') or die("connection failed : ".mysqli_connect_error());
if ($con) {
  echo"Connection Established Successfully";
}
else{
  echo"Connection Could not be Established. Some Error has occured";
}
if (mysqli_connect_errno())
  {
  echo"Failed to connect to MySQL: " . mysqli_connect_error();
  }
?>

( home page )

<!DOCTYPEhtml>
<html>
<head>
    <title>insert records</title>
</head>
<body>
<divclass="row text-center">
    <divclass="container">
        <h1>Insert Student Information</h1>
    <formaction="home_page.php"method="post">
    <b> Roll Number :     </b><inputtype="text"name="Roll_Number"placeholder="Enter Roll Number"><br><br>
    <b> Student Name:    </b><inputtype="text"name="Student_Name"placeholder="Enter Student Name"><br><br>
    <b>Class :                 </b><inputtype="text"name="Class"placeholder="Enter Class Name (TE A or TE B)"><br><br>
    <b>Subject :     </b><inputtype="text"name="Subject"placeholder="Enter Subject Name"><br><br>
    <b> Marks Obtained : </b><inputtype="text"name="Marks"placeholder="Enter Marks Obtained"><br><br>
    <inputtype="submit"name="submit"value="Add Student Record"><br><br>
    </form>
<button><ahref="show_record.php">Show Students Records</a></button>
    </div>
</div>
</body>
</html>
<?php
error_reporting(0);
include'db_connection.php';
if (isset($_POST['submit'])) {
    $Roll_Number = $_POST['Roll_Number'];
    $Student_Name = $_POST['Student_Name'];
    $Class = $_POST['Class'];
    $Subject = $_POST['Subject'];
    $Marks = $_POST['Marks'];
    $sql = "INSERT INTO `te_2023` VALUES ('$Roll_Number','$Student_Name','$Class','$Subject','$Marks')";
    $data=mysqli_query($con,$sql);
    if ($data) {
        echo"Student Record Inserted Sucessfully";
    }else
    {
        echo"Record Could not be inserted. Some Error Occured";
    }
}
?>

( Delete page )

<?php
include ('db_connection.php');
$id = $_GET['roll_no'];
$sql ="DELETEFROM `te_2023` WHERERoll_No='$id'";
$data = mysqli_query($con,$sql);
if ($data) {
    echo"deleted";
    header('location:show_record.php');
}else
{
    echo"error";
}
 ?>

( show record )

<!DOCTYPEhtml>
<html>
<head>
    <title>show records</title>
</head>
<body>
<?php
include ('db_connection.php');
$sql ="select * from te_2023";
$data =mysqli_query($con,$sql);
$total=mysqli_num_rows($data);
if ($total=mysqli_num_rows($data)) {
?>
    <tableborder="2">
<tr>
<th>Roll Number</th>
<th>Student Name</th>
<th>Class</th>
<th>Subject</th>
<th>Marks Obtained</th>
<th>Update Record</th>
<th>Delete Record</th>
</tr>
    <?php
    while ($result = mysqli_fetch_array($data)) {
        echo"
            <tr>
                <td>".$result['Roll_No']."</td>
                <td>".$result['Student_Name']."</td>
                <td>".$result['Class']."</td>
                <td>".$result['Subject']."</td>
                <td>".$result['Marks_Obtained']."</td>
                <td><a href='update_record.php?roll_no=$result[Roll_No] &studentname=$result[Student_Name] & class=$result[Class] & subject=$result[Subject] & marks=$result[Marks_Obtained]'> Update </a></td>
                <td><a href='delete_record.php?roll_no=$result[Roll_No] '>Delete </a></td>
            </tr>
        ";
    }
}
else
{
    echo"no record found";
}
?>
</table>
</body>
</html>

( update record )

<!DOCTYPEhtml>
<html>
<head>
    <title>update</title>
</head>
<body>
<formaction=""method="get">
    <inputtype="text"name="roll_no"placeholder="Enter Roll Number"value="<?phpecho$_GET['roll_no']; ?>"><br><br>
    <inputtype="text"name="studentname"placeholder="Enter Student Name"value="<?phpecho$_GET['studentname']; ?>"><br><br>
    <inputtype="text"name="class"placeholder="Enter Class"value="<?phpecho$_GET['class']; ?>"><br><br>
    <inputtype="text"name="subject"placeholder="Enter Subject Name"value="<?phpecho$_GET['subject']; ?>"><br><br>
    <inputtype="text"name="marks"placeholder="Enter Marks Obtained"value="<?phpecho$_GET['marks']; ?>"><br><br>
    <inputtype="submit"name="submit"value="Update Record">
</form>
<?php
error_reporting(0);
include ('db_connection.php');

if ($_GET['submit'])
{
    $roll_no = $_GET['roll_no'];
    $studentname = $_GET['studentname'];
    $class = $_GET['class'];
    $subject = $_GET['subject'];
    $marks = $_GET['marks'];
    $sql="UPDATE te_2023 SETRoll_No='$roll_no' ,Student_Name='$studentname', Class='$class' , Subject='$subject', Marks_Obtained='$marks'   WHERERoll_No='$roll_no'";
    $data=mysqli_query($con, $sql);
    if ($data) {
        echo"Record Updated Successfully";
        header('location:show_record.php');
    }
    else{
        echo"Record is not updated";
    }
}
else
{
    echo"Click on  button to save the changes";
}
?>
</body>
</html>

<=============================================================================================================================================================================================================================================================================================================>

Problem Statement 3 (Aggregation & Indexing)
Create the Collection Movies_Data( Movie_ID, Movie_Name, Director, Genre, BoxOfficeCollection) and solve the following:
1. Display a list stating how many Movies are directed by each “Director”.
2. Display list of Movies with the highest BoxOfficeCollection in each Genre.
3. Display list of Movies with the highest BoxOfficeCollection in each Genre in ascending order of BoxOfficeCollection.
4. Create an index on field Movie_ID.
5. Create an index on fields ” Movie_Name” and ” Director”.
6. Drop an index on field Movie_ID.


solution : 

db.Movies_Data.insertMany([
  { Movie_ID: 1, Movie_Name: "Inception", Director: "Christopher Nolan", Genre: "Sci-Fi", BoxOfficeCollection: 800000000 },
  { Movie_ID: 2, Movie_Name: "Interstellar", Director: "Christopher Nolan", Genre: "Sci-Fi", BoxOfficeCollection: 700000000 },
  { Movie_ID: 3, Movie_Name: "The Dark Knight", Director: "Christopher Nolan", Genre: "Action", BoxOfficeCollection: 1000000000 },
  { Movie_ID: 4, Movie_Name: "Titanic", Director: "James Cameron", Genre: "Romance", BoxOfficeCollection: 2200000000 },
  { Movie_ID: 5, Movie_Name: "Avatar", Director: "James Cameron", Genre: "Sci-Fi", BoxOfficeCollection: 2800000000 },
  { Movie_ID: 6, Movie_Name: "Pulp Fiction", Director: "Quentin Tarantino", Genre: "Crime", BoxOfficeCollection: 210000000 },
  { Movie_ID: 7, Movie_Name: "Django Unchained", Director: "Quentin Tarantino", Genre: "Western", BoxOfficeCollection: 425000000 },
  { Movie_ID: 8, Movie_Name: "The Godfather", Director: "Francis Ford Coppola", Genre: "Crime", BoxOfficeCollection: 250000000 },
  { Movie_ID: 9, Movie_Name: "The Godfather Part II", Director: "Francis Ford Coppola", Genre: "Crime", BoxOfficeCollection: 190000000 },
  { Movie_ID: 10, Movie_Name: "The Revenant", Director: "Alejandro G. Iñárritu", Genre: "Adventure", BoxOfficeCollection: 533000000 }
])

1. Display a list stating how many movies are directed by each “Director”:

db.Movies_Data.aggregate([
   { $group: { _id: "$Director", movie_count: { $sum: 1 } } },
   { $project: { _id: 0, Director: "$_id", Total_Movies: "$movie_count" } }
])

2. Display a list of movies with the highest BoxOfficeCollection in each Genre:

db.Movies_Data.aggregate([
   { $sort: { Genre: 1, BoxOfficeCollection: -1 } },
   { $group: { _id: "$Genre", highest_movie: { $first: "$$ROOT" } } },
   { $project: { _id: 0, Movie_Name: "$highest_movie.Movie_Name", Genre: "$highest_movie.Genre", BoxOfficeCollection: "$highest_movie.BoxOfficeCollection" } }
])

3. Display a list of movies with the highest BoxOfficeCollection in each Genre in ascending order of BoxOfficeCollection:

db.Movies_Data.aggregate([
   { $sort: { Genre: 1, BoxOfficeCollection: -1 } },
   { $group: { _id: "$Genre", highest_movie: { $first: "$$ROOT" } } },
   { $sort: { "highest_movie.BoxOfficeCollection": 1 } },
   { $project: { _id: 0, Movie_Name: "$highest_movie.Movie_Name", Genre: "$highest_movie.Genre", BoxOfficeCollection: "$highest_movie.BoxOfficeCollection" } }
])

4. Create an index on the field Movie_ID:

db.Movies_Data.createIndex({ Movie_ID: 1 })

5. Create an index on fields Movie_Name and Director:

db.Movies_Data.createIndex({ Movie_Name: 1, Director: 1 })

6. Drop an index on fields Movie_Name and Director:

db.Movies_Data.dropIndex({ Movie_Name: 1, Director: 1 })

<=============================================================================================================================================================================================================================================================================================================>

Problem Statement 4 (Procedures / Functions)
Consider following schema for Bank database. Account(Account_No, Cust_Name, Balance, NoOfYears) Earned_Interest(Account_No, Interest_Amt)
1. Write a PL/SQL procedure for following requirement. Take as input Account_No and Interest Rate from User. Calculate the Interest_Amt as simple interest for the given Account_No and store it in Earned_Interest table. Display all the details of Earned_Interest Table.
2. Write a PLSQL function to display all records from Account table having Balance greater than 50,000.

solution :

1. Write a PL/SQL procedure for following requirement. Take as input Account_No and Interest Rate from User. Calculate the Interest_Amt as simple interest for the given Account_No and store it in Earned_Interest table. Display all the details of Earned_Interest Table.

Step 1: Create the Tables

-- Table to store account details
CREATE TABLE Account (
    Account_No NUMBER PRIMARY KEY,  -- Unique account number (Primary Key)
    Cust_Name VARCHAR2(100),        -- Customer's name
    Balance NUMBER,                 -- Balance in the account
    NoOfYears NUMBER                -- Number of years the account has been active
);

-- Table to store earned interest details
CREATE TABLE Earned_Interest (
    Account_No NUMBER PRIMARY KEY,  -- Account number (Primary Key)
    Interest_Amt NUMBER              -- Calculated interest amount
);

Step 2: Create the PL/SQL Procedure

CREATE OR REPLACE PROCEDURE proc_Calculate_Interest (
    p_account_no IN NUMBER,          -- Account number input
    p_interest_rate IN NUMBER         -- Interest rate input
) IS
    v_balance Account.Balance%TYPE;   -- Variable to hold the account balance
    v_no_of_years Account.NoOfYears%TYPE;  -- Variable to hold the number of years
    v_interest_amt NUMBER;            -- Variable to hold the calculated interest amount
BEGIN
    -- Fetch the Balance and NoOfYears for the given Account_No from the Account table
    SELECT Balance, NoOfYears
    INTO v_balance, v_no_of_years
    FROM Account
    WHERE Account_No = p_account_no;

    -- Calculate the interest amount as simple interest
    v_interest_amt := (v_balance * v_no_of_years * p_interest_rate) / 100;

    -- Insert or update the interest amount in the Earned_Interest table
    MERGE INTO Earned_Interest ei
    USING (SELECT p_account_no AS Account_No FROM dual) src
    ON (ei.Account_No = src.Account_No)
    WHEN MATCHED THEN
        UPDATE SET ei.Interest_Amt = v_interest_amt
    WHEN NOT MATCHED THEN
        INSERT (Account_No, Interest_Amt) 
        VALUES (p_account_no, v_interest_amt);

    -- Commit the transaction
    COMMIT;

    -- Display the updated Earned_Interest table
    DBMS_OUTPUT.PUT_LINE('Account No  |  Interest Amount');
    FOR rec IN (SELECT * FROM Earned_Interest) LOOP
        DBMS_OUTPUT.PUT_LINE(rec.Account_No || '          |  ' || rec.Interest_Amt);
    END LOOP;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Account not found.');  -- Handle case when account not found
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);   -- Handle other exceptions
END proc_Calculate_Interest;
/

Step 3: Declare and Execute the Procedure

-- Declare variables to hold input values
DECLARE
    v_account_no NUMBER;            -- Variable to hold account number
    v_interest_rate NUMBER;         -- Variable to hold interest rate
BEGIN
    -- Accept input from user
    v_account_no := &account_no;    -- User enters account number
    v_interest_rate := &interest_rate;  -- User enters interest rate

    -- Call the procedure to calculate interest
    proc_Calculate_Interest(v_account_no, v_interest_rate);
END;
/

Step 4: Insert Sample Data into the Account Table

-- Insert sample data into Account table
INSERT INTO Account (Account_No, Cust_Name, Balance, NoOfYears) 
VALUES (101, 'John Doe', 50000, 5);

INSERT INTO Account (Account_No, Cust_Name, Balance, NoOfYears) 
VALUES (102, 'Jane Doe', 30000, 3);

Step 5: Execute the Procedure with Specific Inputs

-- Execute the PL/SQL block
DECLARE
    v_account_no NUMBER;            -- Variable to hold account number
    v_interest_rate NUMBER;         -- Variable to hold interest rate
BEGIN
    v_account_no := 102;            -- Example account number
    v_interest_rate := 3;           -- Example interest rate

    -- Call the procedure to calculate interest
    proc_Calculate_Interest(v_account_no, v_interest_rate);
END;
/

Step 6: View the Results

-- Select all records from the Earned_Interest table to view results
SELECT * FROM Earned_Interest;

2. Write a PLSQL function to display all records from Account table having Balance greater than 50,000.

step 1 : 

CREATE OR REPLACE FUNCTION fn_Display_Accounts_With_High_Balance
RETURN SYS_REFCURSOR IS ~~ SYS_REFCURSOR: This is a special data type used to return a cursor
    -- Declare a cursor variable to hold the result set
    accounts_cursor SYS_REFCURSOR;
BEGIN
    -- Open the cursor for records where balance > 50,000
    OPEN accounts_cursor FOR
        SELECT Account_No, Cust_Name, Balance, NoOfYears
        FROM Account
        WHERE Balance > 50000;

    -- Return the cursor to the caller
    RETURN accounts_cursor;
END;
/

Step 2: Calling the Function and Displaying Results

DECLARE
    -- Declare a cursor variable to hold the result set returned by the function
    accounts_cursor SYS_REFCURSOR;
    -- Declare variables to hold account details
    v_account_no Account.Account_No%TYPE;
    v_cust_name Account.Cust_Name%TYPE;
    v_balance Account.Balance%TYPE;
    v_no_of_years Account.NoOfYears%TYPE;
BEGIN
    -- Call the function to get the cursor
    accounts_cursor := fn_Display_Accounts_With_High_Balance;

    -- Loop through the cursor and fetch each record
    LOOP
        FETCH accounts_cursor INTO v_account_no, v_cust_name, v_balance, v_no_of_years;
        EXIT WHEN accounts_cursor%NOTFOUND;  -- Exit loop when no more rows to fetch

        -- Display the account details
        DBMS_OUTPUT.PUT_LINE('Account No: ' || v_account_no || ' | Customer: ' || v_cust_name || ' | Balance: ' || v_balance || ' | No. of Years: ' || v_no_of_years);
    END LOOP;

    -- Close the cursor
    CLOSE accounts_cursor;
END;
/

step 3 : 

SET SERVEROUTPUT ON;

<=============================================================================================================================================================================================================================================================================================================>

Problem Statement 5 (JOINS & SUBQUERIES USING MYSQL)
Consider Following Schema
Employee (Employee_id, First_name, Last_name , Hire_date, Salary, Job_title, Manager_id, department_id) Departments(Department_id, Department_name, Manager_id, Location_id)
Locations(Location_id , Street_address , Postal_code, city, state, Country_id) Manager(Manager_id, Manager_name)
Create the tables with referential integrity.Solve following queries using joins and subqueries.
1. Write a query to find the names (first_name, last_name), the salary of the employees who earn more than the average salary and who works in any of the IT departments.
2. Write a query to find the names (first_name, last_name), the salary of the employees who earn the same salary as the minimum salary for all departments.
3. Write a query to display the employee ID, first name, last names, salary of all employees whose salary is above average for their departments.
4. Write a query to display the department name, manager name, and city.
5. Write a query to display the name (first_name, last_name), hire date, salary of all managers whose experience is more than 15 years.

solution : 

step 1 :

-- Create Employee Table
CREATE TABLE Employee (
    Employee_id INT PRIMARY KEY,
    First_name VARCHAR(50),
    Last_name VARCHAR(50),
    Hire_date DATE,
    Salary DECIMAL(10, 2),
    Job_title VARCHAR(50),
    Manager_id INT,
    Department_id INT,
    FOREIGN KEY (Manager_id) REFERENCES Manager(Manager_id),
    FOREIGN KEY (Department_id) REFERENCES Departments(Department_id)
);

-- Create Departments Table
CREATE TABLE Departments (
    Department_id INT PRIMARY KEY,
    Department_name VARCHAR(50),
    Manager_id INT,
    Location_id INT,
    FOREIGN KEY (Manager_id) REFERENCES Manager(Manager_id),
    FOREIGN KEY (Location_id) REFERENCES Locations(Location_id)
);

-- Create Locations Table
CREATE TABLE Locations (
    Location_id INT PRIMARY KEY,
    Street_address VARCHAR(100),
    Postal_code VARCHAR(10),
    City VARCHAR(50),
    State VARCHAR(50),
    Country_id INT
);

-- Create Manager Table
CREATE TABLE Manager (
    Manager_id INT PRIMARY KEY,
    Manager_name VARCHAR(100)
);

-- Insert data into Manager table
INSERT INTO Manager (Manager_id, Manager_name)
VALUES (1, 'John Doe'),
       (2, 'Jane Smith');

-- Insert data into Locations table
INSERT INTO Locations (Location_id, Street_address, Postal_code, City, State, Country_id)
VALUES (1, '1234 Elm St', '12345', 'San Francisco', 'CA', 101),
       (2, '5678 Oak St', '67890', 'Los Angeles', 'CA', 101);

-- Insert data into Departments table
INSERT INTO Departments (Department_id, Department_name, Manager_id, Location_id)
VALUES (1, 'IT', 1, 1),
       (2, 'HR', 2, 2);

-- Insert data into Employee table
INSERT INTO Employee (Employee_id, First_name, Last_name, Hire_date, Salary, Job_title, Manager_id, Department_id)
VALUES (1, 'Alice', 'Johnson', '2015-06-01', 90000, 'Software Engineer', 1, 1),
       (2, 'Bob', 'Smith', '2018-08-01', 120000, 'HR Specialist', 2, 2),
       (3, 'Charlie', 'Brown', '2010-01-01', 150000, 'Senior Developer', 1, 1),
       (4, 'David', 'Wilson', '2016-03-15', 95000, 'Software Engineer', 1, 1),
       (5, 'Eve', 'Davis', '2019-07-20', 130000, 'HR Manager', 2, 2);

step 3 : SQL Queries

Query 1: Find the names (first_name, last_name), the salary of the employees who earn more than the average salary and work in any of the IT departments.

SELECT e.First_name, e.Last_name, e.Salary
FROM Employee e
JOIN Departments d ON e.Department_id = d.Department_id
WHERE e.Salary > (SELECT AVG(Salary) FROM Employee) 
  AND d.Department_name = 'IT';

Query 2: Find the names (first_name, last_name), the salary of the employees who earn the same salary as the minimum salary for all departments.

SELECT e.First_name, e.Last_name, e.Salary
FROM Employee e
JOIN Departments d ON e.Department_id = d.Department_id
WHERE e.Salary = (SELECT MIN(Salary) FROM Employee WHERE Department_id = d.Department_id);

Query 3: Display the employee ID, first name, last names, salary of all employees whose salary is above average for their departments.

SELECT e.Employee_id, e.First_name, e.Last_name, e.Salary
FROM Employee e
JOIN Departments d ON e.Department_id = d.Department_id
WHERE e.Salary > (SELECT AVG(Salary) FROM Employee WHERE Department_id = e.Department_id);

Query 4: Display the department name, manager name, and city.

SELECT d.Department_name, m.Manager_name, l.City
FROM Departments d
JOIN Manager m ON d.Manager_id = m.Manager_id
JOIN Locations l ON d.Location_id = l.Location_id;

Query 5: Display the name (first_name, last_name), hire date, salary of all managers whose experience is more than 15 years.

SELECT e.First_name, e.Last_name, e.Hire_date, e.Salary
FROM Employee e
WHERE e.Manager_id IS NOT NULL
  AND e.Hire_date < CURDATE() - INTERVAL 15 YEAR;

<=============================================================================================================================================================================================================================================================================================================>

Problem Statement 6
Implement MongoDB database connectivity with Java

  package Shradha;

import com.mongodb.*;
import java.util.Scanner;
import java.net.UnknownHostException;
import java.util.List;

public class Ta_Ga {
    private static MongoClient mongoClient;
    private static DBCollection collection;

    public static void main(String[] args) {
        // Initialize connection to MongoDB
        try {
            mongoClient = new MongoClient("localhost", 27017);
            DB db = mongoClient.getDB("Ta_Shradha");
            collection = db.getCollection("Shradha_Hiremath");
        } catch (UnknownHostException e) {
            System.err.println("Error: Unable to connect to the MongoDB server. Please ensure it is running.");
            return;
        } catch (MongoException e) {
            System.err.println("MongoDB error: " + e.getMessage());
            return;
        }

        // Menu driven system to perform MongoDB operations
        int choice;
        Scanner scanner = new Scanner(System.in);

        do {
            // Display menu options
            System.out.println("\nMenu:");
            System.out.println("1. Insert Data");
            System.out.println("2. Update Data");
            System.out.println("3. Delete Data");
            System.out.println("4. Display All Data");
            System.out.println("5. Exit");
            System.out.print("Enter your choice: ");
            choice = scanner.nextInt();

            // Handle user choices
            switch (choice) {
                case 1:
                    insertData(scanner);
                    break;
                case 2:
                    updateData(scanner);
                    break;
                case 3:
                    deleteData(scanner);
                    break;
                case 4:
                    displayAllData();
                    break;
                case 5:
                    System.out.println("Exiting...");
                    break;
                default:
                    System.out.println("Invalid choice. Please try again.");
            }
        } while (choice != 5);

        scanner.close(); // Close scanner
        mongoClient.close(); // Close MongoDB connection
    }

    // Method to insert data into MongoDB
    private static void insertData(Scanner scanner) {
        System.out.print("Enter name: ");
        String name = scanner.next();
        System.out.print("Enter age: ");
        int age = scanner.nextInt();
        System.out.print("Enter email: ");
        String email = scanner.next();

        // Create a document to insert
        DBObject insertDoc = new BasicDBObject("name", name)
                                    .append("age", age)
                                    .append("email", email);
        collection.insert(insertDoc); // Insert document
        System.out.println("Data inserted successfully.");
    }

    // Method to update data in MongoDB
    private static void updateData(Scanner scanner) {
        System.out.print("Enter name of the user to update: ");
        String name = scanner.next();

        DBObject query = new BasicDBObject("name", name);
        DBObject user = collection.findOne(query);

        if (user != null) {
            System.out.print("Enter new age: ");
            int newAge = scanner.nextInt();
            System.out.print("Enter new email: ");
            String newEmail = scanner.next();

            // Update age and email
            DBObject updateDoc = new BasicDBObject("$set", 
                                        new BasicDBObject("age", newAge)
                                            .append("email", newEmail));
            collection.update(query, updateDoc);
            System.out.println("Data updated successfully.");
        } else {
            System.out.println("User not found.");
        }
    }

    // Method to delete data from MongoDB
    private static void deleteData(Scanner scanner) {
        System.out.print("Enter name of the user to delete: ");
        String name = scanner.next();

        DBObject query = new BasicDBObject("name", name);
        WriteResult result = collection.remove(query);

        if (result.getN() > 0) {
            System.out.println("Data deleted successfully.");
        } else {
            System.out.println("User not found.");
        }
    }

    // Method to display all data from MongoDB
    private static void displayAllData() {
        DBCursor cursor = collection.find();
        
        if (!cursor.hasNext()) {
            System.out.println("No data found.");
            return;
        }

        System.out.println("Displaying all data:");
        while (cursor.hasNext()) {
            DBObject user = cursor.next();
            System.out.println("Name: " + user.get("name") + ", Age: " + user.get("age") + ", Email: " + user.get("email"));
        }
    }
}

<=============================================================================================================================================================================================================================================================================================================>
