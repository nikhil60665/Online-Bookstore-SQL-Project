
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);

CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);

CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;




-- 1) Retrieve all books in the "Fiction" genre:

select * from Books
where genre = 'Fiction';


-- 2) Find books published after the year 1950:

select * from Books
where published_year > 1950;


-- 3) List all customers from the Canada:

select * from Customers
where country = 'Canada';


-- 4) Show orders placed in November 2023:

select * from Orders
where order_date between '2023-11-01' and '2023-11-30';


-- 5) Retrive the total stock of books available:

select sum(stock) as Total_Stock from books;


-- 6) Find the detils of the most expensive book:

select * from books
order by price desc
limit 1;

--or
select max(price) as Most_expnsive_book from books;


-- 7) Show all customers who ordered more than 1 quantity of a book:

select * from orders
where quantity > 1;


-- 8) Retrieve all orders where the total amount exceeds $20:

select * from orders
where total_amount > 20;


-- 9) list all genres available in the Books tables:

select genre, count(genre) as total from books
group by genre;

--or
select distinct genre from books;


-- 10) Find the book with the lowerst stock;

select * from books
order by stock asc;


-- 11) Calculate the total revenue generated from all orders:

select sum(total_amount) as total_revenue from orders;





-- Advance Questions:


-- 1) Retrieve the total number of books sold for each genre:

select b.genre, sum(o.quantity) as total_quantity from books as b
join orders as o 
on b.book_id = o.book_id
group by genre;



-- 2) Find the average price of books in the "Fantasy" genre:

Select avg(price) as average_price from books
where genre = 'Fantasy';



-- 3) List customers who have placed at least 2 orders:

select c.name, c.customer_id, count(o.order_id) as order_count from orders o
join customers c
on c.customer_id = o.customer_id
group by c.customer_id
having count(order_id) >= 2
order by order_count ;



-- 4) Find the most frequently ordered book:

select b.title, b.book_id , count(o.order_id) as order_count from orders as o
join books as b
on b.book_id = o.book_id
group by b.book_id
order by order_count desc
-- limit 1;




-- 5) Show the top 3 most expensive books of 'Fantasy' Genre:

select * from books 
where genre = 'Fantasy'
order by price desc
limit 3;




-- 6) Retrieve the total quantity of books sold by each author:

select b.author, b.book_id , sum(o.quantity) as total_count from orders as o
join books as b
on b.book_id = o.book_id
group by b.book_id
order by total_count desc;




--7) List the cities where customers who spent over $30 are located:

select c.city, count(o.order_id) as order, sum(o.total_amount) as amount from orders as o
join customers as c
on c.customer_id = o.customer_id
group by c.customer_id
having sum(o.total_amount) > 30
order by amount ;




-- 8) Find the customer who spent the most on orders

select c.customer_id, c.name, sum(o.total_amount) as total_amount from orders as o
join customers as c
on c.customer_id = o.customer_id
group by c.customer_id, c.name
order by total_amount desc;




-- 9) Calculate the stock remaining after fulfilling all orders

select b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) as order_quantity,
	b.stock - COALESCE(SUM(o.quantity),0) as remaining_quantity
from books b
left join orders o on b.book_id = o.book_id
group by b.book_id 
order by b.book_id;









