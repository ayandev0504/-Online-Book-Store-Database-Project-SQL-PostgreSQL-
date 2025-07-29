-- Create Tables for Books
DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
SELECT * FROM Books;

-- Create Tables for Customers
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
SELECT * FROM Customers;

-- Create Tables for Orders
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);
SELECT * FROM Orders;

--So i have imported the csv files of give tables directly.

--Basic

-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books
WHERE genre = 'Fiction';

-- 2) Find books published after the year 1950:
SELECT * FROM Books
WHERE published_year > 1950;

-- 3) List all customers from the Canada:
SELECT * FROM  Customers
WHERE country = 'Canada';

-- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE order_date BETWEEN '2023-11-23' AND '2023-11-30';

-- 5) Retrieve the total stock of books available:
SELECT SUM(stock) AS total_stock
FROM Books;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books
ORDER BY price DESC;

-- 7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
WHERE quantity > 1 ;

-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM Orders
WHERE total_amount > 20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

-- 10) Find the book with the lowest stock:
SELECT * FROM Books
ORDER BY stock LIMIT 1;

-- 11) Calculate the total revenue generated from all orders:
SELECT SUM(total_amount) AS total_revenue 
FROM Orders;

--Advance

-- 1) Retrieve the total number of books sold for each genre:
SELECT b.genre , SUM(o.quantity) AS Total_book_sold
FROM Books b
JOIN Orders o
ON  b.book_id = o.book_id
GROUP BY b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:
SELECT * FROM Books;

SELECT  genre, AVG(price) AS average_price
FROM Books
WHERE genre = 'Fantasy'
GROUP BY genre;

-- 3) List customers who have placed at least 2 orders:
SELECT * FROM Orders

SELECT o.customer_id ,c.name, COUNT(o.order_id)  AS order_count
FROM orders o
JOIN customers c ON o.customer_id=c.customer_id
GROUP BY o.customer_id , c.name
HAVING COUNT (order_id)>=2;

-- 4) Find the most frequently ordered book:
SELECT o.book_id ,b.title,COUNT(o.order_id)  AS count_order
FROM Orders o
JOIN Books b ON o.order_id = b.book_id 
GROUP BY o.book_id , b.title
ORDER BY count_order DESC LIMIT 1; 

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :
SELECT * FROM Books
WHERE genre = 'Fantasy'
ORDER BY price  DESC LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:
SELECT * FROM Books

SELECT b.author , COUNT(o.quantity)  AS BOOK_SOLD
FROM Orders o
JOIN Books b ON b.book_id = o.order_id
GROUP BY b.author;

-- 7) List the cities where customers who spent over $30 are located:
SELECT * FROM Customers

SELECT c.city , total_amount
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE total_amount>30 ;

-- 8) Find the customer who spent the most on orders:
SELECT c.customer_id , c.name , SUM(total_amount) AS TOTAL_SPENT
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY  c.customer_id , c.name
ORDER BY TOTAL_SPENT DESC LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:
SELECT b.book_id , b.title , b.stock , COALESCE(SUM(o.quantity), 0) AS ORDER_QUANTITY 
       ,b.stock - COALESCE(SUM(o.quantity), 0) AS REMAINING_QUANTITY
FROM Orders o
LEFT JOIN Books b ON o.book_id = b.book_id
GROUP BY b.book_id 
ORDER BY b.book_id;
