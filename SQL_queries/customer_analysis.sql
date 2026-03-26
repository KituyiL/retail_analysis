-- View
DROP VIEW IF EXISTS customer_summary;
GO

-- Create view
CREATE VIEW customer_summary AS
SELECT
    CustomerID,
    Country,
    COUNT(DISTINCT InvoiceNo) AS TotalOrders,
    SUM(TotalPrice) AS TotalSales,
    MIN(InvoiceDate) AS FirstPurchase,
    MAX(InvoiceDate) As LastPurchase,
    ROW_NUMBER() OVER (ORDER BY SUM(TotalPrice) DESC) AS SalesRank,
    ROW_NUMBER() OVER (ORDER BY COUNT(DISTINCT InvoiceNo) DESC) AS OrdersRank,
    ROW_NUMBER() OVER (PARTITION BY Country ORDER BY COUNT(DISTINCT InvoiceNo) DESC) AS CountryOrdersRank,
    ROW_NUMBER() OVER (PARTITION BY Country ORDER BY SUM(TotalPrice) DESC) AS CountrySalesRank
FROM online_retail
GROUP BY CustomerID, Country;
GO

-- Total number of customers 
SELECT
    COUNT(DISTINCT CustomerID) AS CustomerCount
FROM online_retail;

-- Number of customers by country
SELECT
    Country,
    COUNT(DISTINCT CustomerID) AS CustomerCount
FROM online_retail
GROUP BY Country
ORDER BY CustomerCount DESC;

-- Top 10 customers by total sales
SELECT TOP 10
    CustomerID,
    Country,
    TotalSales,
    DATEDIFF(day, CAST(FirstPurchase AS DATE), CAST(LastPurchase AS DATE)) AS CustomerLifetimeDays,
    OrdersRank
FROM customer_summary
ORDER BY TotalSales DESC;

-- Bottom 10 customers by total sales
SELECT TOP 10
    CustomerID,
    Country,
    TotalSales,
    DATEDIFF(day, CAST(FirstPurchase AS DATE), CAST(LastPurchase AS DATE)) AS CustomerLifetimeDays,
    OrdersRank
FROM customer_summary
ORDER BY TotalSales ASC;

-- Top 10 customers by number of orders
SELECT TOP 10
    CustomerID,
    Country,
    TotalOrders,
    DATEDIFF(day, CAST(FirstPurchase AS DATE), CAST(LastPurchase AS DATE)) AS CustomerLifetimeDays,
    SalesRank
FROM customer_summary
ORDER BY TotalOrders DESC;

-- Bottom 10 customers by number of orders

SELECT TOP 10
    CustomerID,
    Country,
    TotalOrders,
    DATEDIFF(day, CAST(FirstPurchase AS DATE), CAST(LastPurchase AS DATE)) AS CustomerLifetimeDays,
    SalesRank
FROM customer_summary
ORDER BY TotalOrders ASC;

-- Top customer in each country by total sales
SELECT 
    Country,
    CustomerID,
    DATEDIFF(day, CAST(FirstPurchase AS DATE), CAST(LastPurchase AS DATE)) AS CustomerLifetimeDays,
    TotalSales
FROM customer_summary
WHERE CountrySalesRank = 1
ORDER BY TotalSales DESC;

-- Top customer in each country by total orders
SELECT  
    Country,
    CustomerID,
    DATEDIFF(day, CAST(FirstPurchase AS DATE), CAST(LastPurchase AS DATE)) AS CustomerLifetimeDays,
    TotalOrders
FROM customer_summary
WHERE CountryOrdersRank = 1
ORDER BY TotalOrders DESC;


