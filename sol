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

Problem Statement 7 (Cursors)
Consider the following schema for Products table. Products(Product_id, Product_Name, Product_Type, Price)
1. Write a parameterized cursor to display all products in the given price range of price and type ‘Apparel’. Hint: Take the user input for minimum and maximum price for price range.
2. Write an explicit cursor to display information of all products with Price greater than 5000.
3. Write an implicit cursor to display the number of records affected by the update operation incrementing Price of all products by 1000.

solution : 

1. Write a parameterized cursor to display all products in the given price range of price and type ‘Apparel’. Hint: Take the user input for minimum and maximum price for price range.

Step 1: Create the Products Table

-- Create the Products table
CREATE TABLE Products (
    Product_id NUMBER PRIMARY KEY,        -- Unique identifier for each product
    Product_Name VARCHAR2(50),            -- Name of the product
    Product_Type VARCHAR2(50),            -- Type of the product (e.g., Apparel, Footwear)
    Price NUMBER                           -- Price of the product
);

Step 2: Insert Sample Data into the Products Table

-- Inserting sample data into Products table
INSERT INTO Products (Product_id, Product_Name, Product_Type, Price) VALUES (1, 'T-Shirt', 'Apparel', 25);
INSERT INTO Products (Product_id, Product_Name, Product_Type, Price) VALUES (2, 'Jeans', 'Apparel', 50);
INSERT INTO Products (Product_id, Product_Name, Product_Type, Price) VALUES (3, 'Sneakers', 'Footwear', 70);
INSERT INTO Products (Product_id, Product_Name, Product_Type, Price) VALUES (4, 'Jacket', 'Apparel', 80);
INSERT INTO Products (Product_id, Product_Name, Product_Type, Price) VALUES (5, 'Hat', 'Apparel', 15);

Step 3: PL/SQL Block to Retrieve Apparel Products within a Price Range

DECLARE
    -- Variables to hold user input for price range
    v_min_price NUMBER;  -- Minimum price
    v_max_price NUMBER;  -- Maximum price

    -- Cursor declaration with parameters for price range
    CURSOR product_cursor (min_price_param NUMBER, max_price_param NUMBER) IS
        SELECT Product_id, Product_Name, Price
        FROM Products
        WHERE Product_Type = 'Apparel'
          AND Price BETWEEN min_price_param AND max_price_param;

BEGIN
    -- Simulating user input; replace with actual user input mechanism as needed
    v_min_price := 20;  -- For demonstration, setting it directly
    v_max_price := 60;  -- For demonstration, setting it directly

    -- Open the cursor with the specified price range
    FOR product_record IN product_cursor(v_min_price, v_max_price) LOOP
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product_record.Product_id || 
                             ' - Name: ' || product_record.Product_Name || 
                             ' - Price: ' || product_record.Price);
    END LOOP;

    -- Check if no records were processed and print a message if so
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No products found in the specified price range.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;
/

2. Write an explicit cursor to display information of all products with Price greater than 5000.

DECLARE
    -- Declare an explicit cursor to fetch products with price greater than 5000
    CURSOR product_cursor IS
        SELECT Product_id, Product_Name, Product_Type, Price
        FROM Products
        WHERE Price > 5000;
    
    -- Variable to store each row fetched by the cursor
    product_record product_cursor%ROWTYPE;
BEGIN
    -- Open and loop through the cursor to fetch each product with Price > 5000
    OPEN product_cursor;
    LOOP
        FETCH product_cursor INTO product_record;
        EXIT WHEN product_cursor%NOTFOUND;  -- Exit loop when no more records are found

        -- Display the details of each product
        DBMS_OUTPUT.PUT_LINE('Product ID: ' || product_record.Product_id || 
                             ' - Name: ' || product_record.Product_Name || 
                             ' - Type: ' || product_record.Product_Type || 
                             ' - Price: ' || product_record.Price);
    END LOOP;
    
    -- Close the cursor after processing all rows
    CLOSE product_cursor;
    
    -- Check if no records were processed and display a message
    IF SQL%ROWCOUNT = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No products found with price greater than 5000.');
    END IF;

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);  -- Handle exceptions
END;

3. Write an implicit cursor to display the number of records affected by the update operation incrementing Price of all products by 1000.

DECLARE
    -- Variable to store the number of rows affected by the update
    v_rows_updated NUMBER;
BEGIN
    -- Update the Price of all products by 1000
    UPDATE Products
    SET Price = Price + 1000;
    
    -- Implicit cursor to retrieve the number of rows affected by the update
    v_rows_updated := SQL%ROWCOUNT;  -- SQL%ROWCOUNT stores the number of affected rows
    
    -- Display the number of records affected by the update operation
    DBMS_OUTPUT.PUT_LINE('Number of records updated: ' || v_rows_updated);
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);  -- Handle exceptions
END;

<=============================================================================================================================================================================================================================================================================================================>

Problem Statement 8 (DML USING MYSQL)
Create following tables using a given schema and insert appropriate data into the same: Customer (CustID, Name, Cust_Address, Phone_no, Email_ID, Age)
Branch (Branch ID, Branch_Name, Address)
Account (Account_no, Branch ID, CustID, date_open, Account_type, Balance)
1. Modify the size of column “Email_Address” to 20 in Customer table.
2. Change the column “Email_Address” to Not Null in Customer table.
3. Display the total customers with the balance >50, 000 Rs.
4. Display average balance for account type=”Saving Account”.
5. Display the customer details that lives in Pune or name starts with ’A’.
6. Create a table Saving_Account with (Account_no, Branch ID, CustID, date_open, Balance) using Account Table.
7. Display the customer details Age wise with balance>=20,000Rs

solution : 

-- Create the Customer table
CREATE TABLE Customer (
    CustID INT PRIMARY KEY,          -- Customer ID
    Name VARCHAR(50),                -- Customer Name
    Cust_Address VARCHAR(100),       -- Customer Address
    Phone_no VARCHAR(15),            -- Customer Phone Number
    Email_ID VARCHAR(50),            -- Customer Email Address
    Age INT                          -- Customer Age
);

-- Create the Branch table
CREATE TABLE Branch (
    BranchID INT PRIMARY KEY,        -- Branch ID
    Branch_Name VARCHAR(50),         -- Branch Name
    Address VARCHAR(100)             -- Branch Address
);

-- Create the Account table
CREATE TABLE Account (
    Account_no INT PRIMARY KEY,      -- Account Number
    BranchID INT,                    -- Branch ID (Foreign Key)
    CustID INT,                      -- Customer ID (Foreign Key)
    date_open DATE,                  -- Account Opening Date
    Account_type VARCHAR(20),        -- Account Type (e.g., Saving Account)
    Balance DECIMAL(10, 2),          -- Account Balance
    FOREIGN KEY (BranchID) REFERENCES Branch(BranchID),
    FOREIGN KEY (CustID) REFERENCES Customer(CustID)
);

-- Insert data into Customer table
INSERT INTO Customer (CustID, Name, Cust_Address, Phone_no, Email_ID, Age) 
VALUES (1, 'John Doe', '123 Main St, Pune', '9876543210', 'john@example.com', 30),
       (2, 'Alice Smith', '456 Park Ave, Mumbai', '9988776655', 'alice@example.com', 25),
       (3, 'Bob Johnson', '789 Elm St, Pune', '9556677889', 'bob@example.com', 45),
       (4, 'Anna Taylor', '101 Oak St, Pune', '9776655443', 'anna@example.com', 35);

-- Insert data into Branch table
INSERT INTO Branch (BranchID, Branch_Name, Address) 
VALUES (1, 'Pune Main Branch', '456 Pune Road, Pune'),
       (2, 'Mumbai Branch', '789 Mumbai Street, Mumbai');

-- Insert data into Account table
INSERT INTO Account (Account_no, BranchID, CustID, date_open, Account_type, Balance) 
VALUES (101, 1, 1, '2023-01-01', 'Saving Account', 55000),
       (102, 1, 2, '2022-05-15', 'Current Account', 10000),
       (103, 2, 3, '2021-10-10', 'Saving Account', 30000),
       (104, 2, 4, '2020-03-05', 'Saving Account', 70000);

Task 1: Modify the size of the column Email_ID in the Customer table:

ALTER TABLE Customer MODIFY Email_ID VARCHAR(20);

Task 2: Change the column Email_ID to NOT NULL in the Customer table:

ALTER TABLE Customer MODIFY Email_ID VARCHAR(20) NOT NULL;

Task 3: Display the total customers with the balance > 50,000 Rs:

SELECT COUNT(DISTINCT c.CustID) AS Total_Customers
FROM Customer c
JOIN Account a ON c.CustID = a.CustID
WHERE a.Balance > 50000;

Task 4: Display the average balance for Saving Account:

SELECT AVG(Balance) AS Average_Balance
FROM Account
WHERE Account_type = 'Saving Account';

Task 5: Display the customer details that live in Pune or whose name starts with 'A':

SELECT * 
FROM Customer
WHERE Cust_Address LIKE '%Pune%' OR Name LIKE 'A%';

Task 6: Create a Saving_Account table using the Account table:

CREATE TABLE Saving_Account AS
SELECT Account_no, BranchID, CustID, date_open, Balance
FROM Account
WHERE Account_type = 'Saving Account';

Task 7: Display the customer details age-wise with balance >= 20,000 Rs:

SELECT c.Name, c.Age, a.Balance
FROM Customer c
JOIN Account a ON c.CustID = a.CustID
WHERE a.Balance >= 20000
ORDER BY c.Age;

<=============================================================================================================================================================================================================================================================================================================>

Problem Statement 9 (Map Reduce)
Create collection for Student{roll_no, name, class, dept, aggregate_marks}. Write Map Reduce Functions for following requirements.
1. Finding the total marks of students of “TE” class department-wise.
2. Finding the highest marks of students of “SE” class department-wise.
3. Find Average marks of students of “BE” class department-wise

solution : 

use school;

db.Student.insertMany([
  { roll_no: 1, name: "John", class: "TE", dept: "Computer Science", aggregate_marks: 85 },
  { roll_no: 2, name: "Alice", class: "TE", dept: "Mechanical", aggregate_marks: 75 },
  { roll_no: 3, name: "Bob", class: "SE", dept: "Computer Science", aggregate_marks: 95 },
  { roll_no: 4, name: "Charlie", class: "SE", dept: "Electrical", aggregate_marks: 90 },
  { roll_no: 5, name: "Dave", class: "BE", dept: "Civil", aggregate_marks: 80 },
  { roll_no: 6, name: "Eve", class: "BE", dept: "Computer Science", aggregate_marks: 88 },
  { roll_no: 7, name: "Grace", class: "TE", dept: "Electrical", aggregate_marks: 72 }
]);

1. Finding the Total Marks of Students of "TE" Class Department-wise

var map1 = function() {
  if (this.class == "TE") {
    emit(this.dept, this.aggregate_marks);  // Emit department as key and aggregate_marks as value
  }
};

var reduce1 = function(key, values) {
  return Array.sum(values);  // Sum up all marks for each department
};

db.Student.mapReduce(map1, reduce1, { out: "total_marks_TE" });

2. Finding the Highest Marks of Students of "SE" Class Department-wise

var map2 = function() {
  if (this.class == "SE") {
    emit(this.dept, this.aggregate_marks);  // Emit department as key and aggregate_marks as value
  }
};

var reduce2 = function(key, values) {
  return Math.max.apply(null, values);  // Find the maximum value (marks) for each department
};

db.Student.mapReduce(map2, reduce2, { out: "highest_marks_SE" });

3. Finding the Average Marks of Students of "BE" Class Department-wise

var map3 = function() {
  if (this.class == "BE") {
    emit(this.dept, { total_marks: this.aggregate_marks, count: 1 });  // Emit department as key and an object containing total_marks and count
  }
};

var reduce3 = function(key, values) {
  var result = { total_marks: 0, count: 0 };
  
  values.forEach(function(value) {
    result.total_marks += value.total_marks;  // Sum the marks
    result.count += value.count;              // Count the number of students
  });
  
  return result;
};

var finalize3 = function(key, reducedValue) {
  reducedValue.average_marks = reducedValue.total_marks / reducedValue.count;  // Calculate average
  return reducedValue;
};

db.Student.mapReduce(map3, reduce3, { out: "average_marks_BE", finalize: finalize3 });

( commands to view output )

db.total_marks_TE.find();
db.highest_marks_SE.find();
db.average_marks_BE.find();

( commands to drop table ) 

db.total_marks_TE.drop();
db.highest_marks_SE.drop();
db.average_marks_BE.drop();

<=============================================================================================================================================================================================================================================================================================================>

Problem Statement 10 (Triggers)
Employee( emp_id, dept_idemp_name, DoJ, salary, commission,job_title) Consider the schema given above for Write a PLSQL Program to
1. Create a Trigger to ensure the salary of the employee is not decreased.
2. Whenever the job title is changed for an employee write the following details into job_history table. Employee ID, old job title, old department ID, DoJ for start date, system date for end date.

solution :

-- Create the Employee table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    dept_id INT,
    emp_name VARCHAR2(50),
    DoJ DATE,
    salary NUMBER(10, 2),
    commission NUMBER(10, 2),
    job_title VARCHAR2(50)
);

-- Create the job_history table
CREATE TABLE job_history (
    emp_id INT,
    old_job_title VARCHAR2(50),
    old_dept_id INT,
    start_date DATE,
    end_date DATE,
    FOREIGN KEY (emp_id) REFERENCES Employee(emp_id)
);

-- Insert sample data into the Employee table
INSERT INTO Employee (emp_id, dept_id, emp_name, DoJ, salary, commission, job_title)
VALUES (101, 1, 'John Doe', TO_DATE('2022-01-15', 'YYYY-MM-DD'), 50000, 5000, 'Developer');

INSERT INTO Employee (emp_id, dept_id, emp_name, DoJ, salary, commission, job_title)
VALUES (102, 2, 'Alice Smith', TO_DATE('2021-05-10', 'YYYY-MM-DD'), 55000, 5500, 'Manager');

INSERT INTO Employee (emp_id, dept_id, emp_name, DoJ, salary, commission, job_title)
VALUES (103, 1, 'Bob Brown', TO_DATE('2020-03-22', 'YYYY-MM-DD'), 45000, 4000, 'Tester');

Trigger 1: Ensure Employee Salary is Not Decreased

-- Create the trigger to ensure salary is not decreased
CREATE OR REPLACE TRIGGER prevent_salary_decrease
BEFORE UPDATE ON Employee
FOR EACH ROW
BEGIN
    IF :NEW.salary < :OLD.salary THEN
        RAISE_APPLICATION_ERROR(-20001, 'Salary cannot be decreased!');
    END IF;
END;
/

Trigger 2: Log Job Title Changes in job_history Table

-- Create the trigger to log job title changes in job_history table
CREATE OR REPLACE TRIGGER log_job_title_change
BEFORE UPDATE OF job_title ON Employee
FOR EACH ROW
BEGIN
    INSERT INTO job_history (emp_id, old_job_title, old_dept_id, start_date, end_date)
    VALUES (:OLD.emp_id, :OLD.job_title, :OLD.dept_id, :OLD.DoJ, SYSDATE);
END;
/

( TESTING TRIGGERS ) 

Test Trigger 1 (Salary Decrease Prevention)

UPDATE Employee
SET salary = 40000
WHERE emp_id = 101;


Test Trigger 2 (Job Title Change Logging)

UPDATE Employee
SET job_title = 'Senior Developer'
WHERE emp_id = 101;

( to see output )

SELECT * FROM job_history;

<=============================================================================================================================================================================================================================================================================================================>

Problem Statement 11 (DDL USING MYSQL)
Create following tables using a given schema and insert appropriate data into the same: Customer (CustID, Name, Cust_Address, Phone_no, Email_ID, Age)
Branch (Branch ID, Branch_Name, Address)
Account (Account_no, Branch ID, CustID, date_open, Account_type, Balance)
1. Create the tables with referential integrity.
2. Draw the ER diagram for the same.
3. Create an Index on primary key column of table Account
4. Create the view as Customer_Info displaying the customer details for age less than 45.
5. Update the View with open date as 16/4/2017
6. Create a sequence on Branch able.
7. Create synonym ‘Branch_info’ for branch table.

solution : 

Step 1: Create Tables with Referential Integrity

-- Create the Customer table
CREATE TABLE Customer (
    CustID INT PRIMARY KEY,
    Name VARCHAR(50),
    Cust_Address VARCHAR(100),
    Phone_no VARCHAR(15),
    Email_ID VARCHAR(50),
    Age INT
);

-- Create the Branch table
CREATE TABLE Branch (
    Branch_ID INT PRIMARY KEY,
    Branch_Name VARCHAR(50),
    Address VARCHAR(100)
);

-- Create the Account table with foreign keys referencing Customer and Branch
CREATE TABLE Account (
    Account_no INT PRIMARY KEY,
    Branch_ID INT,
    CustID INT,
    date_open DATE,
    Account_type VARCHAR(20),
    Balance DECIMAL(10, 2),
    FOREIGN KEY (Branch_ID) REFERENCES Branch(Branch_ID),
    FOREIGN KEY (CustID) REFERENCES Customer(CustID)
);

-- Insert data into Customer table
INSERT INTO Customer (CustID, Name, Cust_Address, Phone_no, Email_ID, Age)
VALUES
(1, 'John Doe', '123 Main St, Pune', '9876543210', 'john.doe@example.com', 30),
(2, 'Jane Smith', '456 Oak Rd, Mumbai', '9876543220', 'jane.smith@example.com', 40),
(3, 'Alice Johnson', '789 Pine Ave, Delhi', '9876543230', 'alice.johnson@example.com', 25),
(4, 'Bob Brown', '101 Maple Dr, Bangalore', '9876543240', 'bob.brown@example.com', 35);

-- Insert data into Branch table
INSERT INTO Branch (Branch_ID, Branch_Name, Address)
VALUES
(1, 'Pune Branch', '12 IT Park, Pune'),
(2, 'Mumbai Branch', '45 Business Center, Mumbai'),
(3, 'Delhi Branch', '78 Corporate Building, Delhi'),
(4, 'Bangalore Branch', '90 Tech Lane, Bangalore');

-- Insert data into Account table
INSERT INTO Account (Account_no, Branch_ID, CustID, date_open, Account_type, Balance)
VALUES
(101, 1, 1, '2020-01-01', 'Saving', 10000.00),
(102, 2, 2, '2019-05-15', 'Current', 25000.00),
(103, 3, 3, '2021-07-20', 'Saving', 15000.00),
(104, 4, 4, '2018-11-10', 'Current', 5000.00),
(105, 1, 2, '2022-02-25', 'Saving', 12000.00),
(106, 2, 3, '2020-06-30', 'Saving', 8000.00);

Step 2: Draw the ER Diagram

The ER Diagram (Entity Relationship Diagram) for the schema will consist of the following entities:

Customer: CustID, Name, Cust_Address, Phone_no, Email_ID, Age.
Branch: Branch_ID, Branch_Name, Address.
Account: Account_no, Branch_ID, CustID, date_open, Account_type, Balance.
The relationships are as follows:

Customer is related to Account via CustID.
Branch is related to Account via Branch_ID.
In an ER diagram:

Customer has a one-to-many relationship with Account (one customer can have many accounts).
Branch has a one-to-many relationship with Account (one branch can have many accounts).

Step 3: Create an Index on the Primary Key Column of the Account Table

-- Create an index on the Account_no column (which is also a primary key)
CREATE INDEX idx_account_no ON Account(Account_no);

Step 4: Create a View Customer_Info Displaying Customer Details for Age Less Than 45

-- Create the view Customer_Info to display customer details for age less than 45
CREATE VIEW Customer_Info AS
SELECT CustID, Name, Cust_Address, Phone_no, Email_ID, Age
FROM Customer
WHERE Age < 45;

Step 5: Update the View with Open Date as 16/4/2017

-- Update the open date for accounts linked with customers from the view
UPDATE Account
SET date_open = '2017-04-16'
WHERE CustID IN (SELECT CustID FROM Customer_Info);

Step 6: Create a Sequence on the Branch Table

-- Alter the Branch table to make Branch_ID auto-increment (creating a sequence-like behavior)
ALTER TABLE Branch
MODIFY COLUMN Branch_ID INT AUTO_INCREMENT;

Step 7: Create a Synonym for the Branch Table

-- Create a synonym for the Branch table (Oracle only)
CREATE SYNONYM Branch_info FOR Branch;

<=============================================================================================================================================================================================================================================================================================================>
