-- Orders view
CREATE VIEW order_summary AS
SELECT
    FORMAT(InvoiceDate, 'yyyy-MM') AS OrderMonth,
    CustomerID,
    InvoiceNo,
    COUNT(DISTINCT InvoiceNo) AS OrderCount,
    COUNT(DISTINCT StockCode) AS TotalDistinctProducts,
    SUM(Quantity) AS TotalQuantity,
    SUM(TotalPrice) AS TotalSales,
    Country,
    ROW_NUMBER() OVER (ORDER BY SUM(TotalPrice) DESC) AS SalesRank,
    ROW_NUMBER() OVER (PARTITION BY Country ORDER BY COUNT(DISTINCT InvoiceNo) DESC) AS CountryRank
FROM online_retail
GROUP BY CustomerID, InvoiceNo, Country, FORMAT(InvoiceDate, 'yyyy-MM');
GO

-- Total number of Orders
SELECT SUM(OrderCount) AS TotalOrders
FROM order_summary;

-- Total Number of orders per month
SELECT 
    OrderMonth,
    SUM(OrderCount) AS TotalOrders
FROM order_summary
GROUP BY OrderMonth
ORDER BY OrderMonth DESC;

-- Total number of Orders per country
SELECT 
    Country,
    SUM(OrderCount) AS TotalOrders   
FROM order_summary
GROUP BY Country
ORDER BY TotalOrders DESC;

-- Top 5 months with highest number of orders
SELECT TOP 5
    OrderMonth,
    SUM(OrderCount) AS TotalOrders
FROM order_summary
GROUP BY OrderMonth
ORDER BY TotalOrders DESC;

-- Bottom 5 months with lowest number of orders
SELECT TOP 5
    OrderMonth,
    SUM(OrderCount) AS TotalOrders 
FROM order_summary
GROUP BY OrderMonth
ORDER BY TotalOrders ASC;

-- Number of items per order
SELECT  
    InvoiceNo,
    TotalDistinctProducts,
    TotalQuantity,
    TotalSales
FROM order_summary
ORDER BY TotalQuantity DESC;

