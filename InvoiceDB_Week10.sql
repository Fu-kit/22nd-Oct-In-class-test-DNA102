-- Create the invoiceDB database

-- Error deffence
-- 1) If 'InvoiceDB' does not exist, please create it
IF DB_ID('InvoiceDB') IS NULL
    CREATE DATABASE InvoiceDB;
GO

USE InvoiceDB;
GO

-- 2) Drop in dependency order (children -> parents)
-- If a table exists, drop it. Children first, parents later.
IF OBJECT_ID('dbo.OrderDetails', 'U') IS NOT NULL DROP TABLE dbo.OrderDetails;
IF OBJECT_ID('dbo.Orders', 'U')       IS NOT NULL DROP TABLE dbo.Orders;
IF OBJECT_ID('dbo.Products', 'U')     IS NOT NULL DROP TABLE dbo.Products;
IF OBJECT_ID('dbo.Customers', 'U')    IS NOT NULL DROP TABLE dbo.Customers;
GO

-- Create tables
-- 3) Create a table of Customers
CREATE TABLE Customers (
	CustomerID INT PRIMARY KEY,
	[Name] VARCHAR(100), 
	Email VARCHAR(100),
	[Address] VARCHAR(200),
	City VARCHAR(50),
	Country VARCHAR(50)
)

-- 4) Create a table of Products
CREATE TABLE Products (
	ProductID INT PRIMARY KEY,
	ProductName VARCHAR(100),
	Price DECIMAL(10, 2)
);

-- 5) Create a table of Orders
CREATE TABLE Orders (
	OrderID INT PRIMARY KEY,
	CustomerID INT,
	OrderDate DATE,
	TotalAmount DECIMAL(10, 2),
	FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- 6) Create a table of OrderDetails
CREATE TABLE OrderDetails (
	OrderDetailID INT PRIMARY KEY,
	OrderID INT,
	ProductID INT,
	Quantity INT,
	FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
	FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Insert sample data

-- 7) Insert sample data into Customers
INSERT INTO Customers (CustomerID, [Name], Email, [Address], City, Country)
VALUES
(1, 'John Doe', 'john@example.com', '123 Main St', 'New York', 'USA'),
(2, 'Jane Smith', 'jane@example.com', '456 Elm St', 'London', 'UK'),
(3, 'Bob Johnson', 'bob@example.com', '789 Oak St', 'Paris', 'France');

-- 8) Insert sample data into Products
INSERT INTO Products (ProductID, ProductName, Price)
VALUES
(1, 'Laptop', 999.99),
(2, 'Smartphone', 499.99),
(3, 'Tablet', 299.99);

-- 9) Insert sample data into Orders
INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
VALUES
(1, 1, '2023-01-15', 1499.98),
(2, 2, '2023-02-20', 299.99),
(3, 3, '2023-03-25', 299.99);

-- 10) Insert sample data into OrderDetails
INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)
VALUES
(1, 1, 1, 1),
(2, 1, 2, 1),
(3, 2, 2, 1),
(4, 3, 1, 1),
(5, 3, 2, 1),
(6, 2, 3, 1);

-- Insert more sample data (1000 customers, 100 products, 10000 orders)
-- 11) Insert more data into Customers
-- @i plays a role of "Number counter".
DECLARE @i INT =4;
WHILE @i <= 1000
BEGIN
	INSERT INTO Customers (CustomerID, [Name], Email, [Address], City, Country)
	VALUES (@i, 'Customer' + CAST(@i AS VARCHAR), 'Customer' + CAST(@i AS VARCHAR) + '@example.com', 'Address' + CAST(@i AS VARCHAR), 'City' + CAST(@i AS VARCHAR), 'Country' + CAST(@i AS VARCHAR));
	SET @i = @i + 1;
END

-- 12) Insert more data into Products
SET @i = 4;
WHILE @i <= 100
BEGIN
	INSERT INTO Products (ProductID, ProductName, Price)
	VALUES (@i, 'Product' + CAST(@i AS VARCHAR), RAND() * 1000)
	SET @i = @i + 1;
END;

-- 13)
SET @i = 4;
WHILE @i <= 10000
BEGIN
	DECLARE @CustomerID INT = FLOOR(RAND() * 1000) + 1;
	DECLARE @OrderDate DATE = DATEADD(DAY, - FLOOR(RAND() * 365), GETDATE());
	DECLARE @TotalAmount DECIMAL(10, 2) = 0;

	INSERT INTO Orders (OrderID, CustomerID, OrderDate, TotalAmount)
	VALUES (@i, @CustomerID, @OrderDate, @TotalAmount);

	DECLARE @j INT = 1; 
	WHILE @j <= FLOOR(RAND() * 5) + 1
	BEGIN
		DECLARE @ProductID INT = FLOOR(RAND() * 100) + 1;
		DECLARE @Quantity INT = FLOOR(RAND() * 5) + 1;

		INSERT INTO OrderDetails (OrderDetailID, OrderID, ProductID, Quantity)
		VALUES (@i * 10 + @j, @i, @ProductID, @Quantity);

		SET @TotalAmount = @TotalAmount + (
		SELECT Price * @Quantity FROM Products WHERE ProductID = @ProductID
		);

		SET @j = @j +1;
	END;

UPDATE Orders SET TotalAmount = @TotalAmount WHERE OrderID = @i;
SET @i = @i + 1;
END;   -- ✅ close outer WHILE loop


-- Related lerning -> https://adci.instructure.com/courses/320/pages/week-10-learning-resources?module_item_id=13643
