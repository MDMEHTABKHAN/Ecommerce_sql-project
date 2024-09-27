CREATE DATABASE ecommerce_db;

USE ecommerce_db;

-- Table: Customers
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerName VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(255)
);

-- Table: Categories
CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY AUTO_INCREMENT,
    CategoryName VARCHAR(100)
);



-- Table: Products
CREATE TABLE Products (
    ProductID INT PRIMARY KEY AUTO_INCREMENT,
    ProductName VARCHAR(100),
    Price DECIMAL(10, 2),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Table: Orders
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    OrderDate DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Table: OrderDetails
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Table: Payments
CREATE TABLE Payments (
    PaymentID INT PRIMARY KEY AUTO_INCREMENT,
    OrderID INT,
    PaymentDate DATE,
    Amount DECIMAL(10, 2),
    PaymentMethod VARCHAR(50),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID)
);




-- Insert sample data into Customers
INSERT INTO Customers (CustomerName, Email, Phone, Address)
VALUES 
('John Doe', 'john@example.com', '1234567890', '123 Main St'),
('Jane Smith', 'jane@example.com', '0987654321', '456 Elm St');

-- Insert sample data into Categories
INSERT INTO Categories (CategoryName)
VALUES ('Electronics'), ('Clothing'), ('Books');

-- Insert sample data into Products
INSERT INTO Products (ProductName, Price, CategoryID)
VALUES 
('Laptop', 1000.00, 1),
('Smartphone', 700.00, 1),
('T-Shirt', 20.00, 2),
('Novel', 15.00, 3);

-- Insert sample data into Orders
INSERT INTO Orders (CustomerID, OrderDate)
VALUES 
(1, '2023-09-10'),
(2, '2023-09-11');

-- Insert sample data into OrderDetails
INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
VALUES 
(1, 1, 1, 1000.00),
(1, 4, 2, 15.00),
(2, 2, 1, 700.00),
(2, 3, 3, 20.00);

-- Insert sample data into Payments
INSERT INTO Payments (OrderID, PaymentDate, Amount, PaymentMethod)
VALUES 
(1, '2023-09-10', 1030.00, 'Credit Card'),
(2, '2023-09-11', 760.00, 'PayPal');

-- to fond the top sales 
SELECT 
    P.ProductName, 
    SUM(OD.Quantity) AS TotalSold
FROM 
    OrderDetails OD
JOIN 
    Products P ON OD.ProductID = P.ProductID
GROUP BY 
    P.ProductID
ORDER BY 
    TotalSold DESC;


-- total sales of each customer 
SELECT 
    C.CustomerName, 
    SUM(P.Amount) AS TotalSales
FROM 
    Payments P
JOIN 
    Orders O ON P.OrderID = O.OrderID
JOIN 
    Customers C ON O.CustomerID = C.CustomerID
GROUP BY 
    C.CustomerID;

-- generating most revenue
SELECT 
    Cat.CategoryName, 
    SUM(OD.Quantity * OD.UnitPrice) AS TotalRevenue
FROM 
    OrderDetails OD
JOIN 
    Products P ON OD.ProductID = P.ProductID
JOIN 
    Categories Cat ON P.CategoryID = Cat.CategoryID
GROUP BY 
    Cat.CategoryID
ORDER BY 
    TotalRevenue DESC;
    
-- Create Views for Sales Trends
CREATE VIEW SalesTrends AS
SELECT 
    O.OrderDate, 
    SUM(OD.Quantity * OD.UnitPrice) AS DailyRevenue
FROM 
    Orders O
JOIN 
    OrderDetails OD ON O.OrderID = OD.OrderID
GROUP BY 
    O.OrderDate
ORDER BY 
    O.OrderDate;

-- Query the view to see sales trends
SELECT * FROM SalesTrends;


