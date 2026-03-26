-- product view
CREATE VIEW product_summary AS
SELECT 
    StockCode,
    COUNT(DISTINCT StockCode) AS ProductCount,
    Description,
    Country,
    FORMAT(InvoiceDate, 'yyyy-MM') AS OrderMonth,
    SUM(Quantity) AS TotalQuantity,
    SUM(TotalPrice) AS TotalSales,
    ROW_NUMBER() OVER (ORDER BY SUM(TotalPrice) DESC) AS SalesRank,
    ROW_NUMBER() OVER (ORDER BY SUM(Quantity) DESC) AS QuantityRank,
    ROW_NUMBER() OVER(PARTITION BY Country ORDER BY SUM(TotalPrice) DESC) AS CountrySalesRank,
    ROW_NUMBER() OVER(PARTITION BY Country ORDER BY SUM(Quantity)DESC) AS CountryQuantityRank,
    ROW_NUMBER() OVER(PARTITION BY FORMAT(InvoiceDate, 'yyyy-MM') ORDER BY SUM(TotalPrice) DESC) AS MonthlySalesRank,
    ROW_NUMBER() OVER(PARTITION BY FORMAT(InvoiceDate, 'yyyy-MM') ORDER BY SUM(Quantity)DESC) AS MonthlyQuantityRank,
    ROW_NUMBER() OVER(PARTITION BY Country ORDER BY SUM(TotalPrice) ASC) AS CountrySalesRankAsc,
    ROW_NUMBER() OVER(PARTITION BY Country ORDER BY SUM(Quantity)ASC) AS CountryQuantityRankAsc,
    ROW_NUMBER() OVER(PARTITION BY FORMAT(InvoiceDate, 'yyyy-MM') ORDER BY SUM(TotalPrice) ASC) AS MonthlySalesRankAsc,
    ROW_NUMBER() OVER(PARTITION BY FORMAT(InvoiceDate, 'yyyy-MM') ORDER BY SUM(Quantity) ASC) AS MonthlyQuantityRankAsc
FROM online_retail
GROUP BY Country, StockCode, Description, FORMAT(InvoiceDate, 'yyyy-MM');
GO

-- Total number of distinct products
SELECT
    SUM(ProductCount)
FROM product_summary;

-- Top 10 products by total sales
SELECT TOP 10
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalSales) AS ProductTotal
FROM product_summary
GROUP BY StockCode
ORDER BY ProductTotal DESC;

-- Bottom 10 products by total sales
SELECT TOP 10
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalSales) AS ProductTotal
FROM product_summary
GROUP BY StockCode
ORDER BY ProductTotal  ASC;

-- Top 10 products by Quantity sold
SELECT TOP 10
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalQuantity) AS ProductQuantity
FROM product_summary
GROUP BY StockCode
ORDER BY ProductQuantity DESC;

-- Bottom 10 products by Quantity sold
SELECT TOP 10
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalQuantity) AS ProductQuantity
FROM product_summary
GROUP BY StockCode
ORDER BY ProductQuantity ASC;

-- Top 3 products in each country by Sales
SELECT 
    Country,
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalSales) AS ProductTotal
FROM product_summary
WHERE CountrySalesRank <=3
GROUP BY StockCode, Country
ORDER BY Country, ProductTotal DESC;

-- Bottom 3 products in each country by Sales
SELECT
    Country,
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalSales) AS ProductTotal
FROM product_summary
WHERE CountrySalesRankAsc <=3
GROUP BY StockCode, Country
ORDER BY Country, ProductTotal;

-- Top 3 products in each country by quantity
SELECT 
    Country,
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalQuantity) AS ProductQuantity
FROM product_summary
WHERE CountryQuantityRank <=3
GROUP BY StockCode, Country 
ORDER BY Country, ProductQuantity DESC;

-- Bottom 3 products in each country by quantity
SELECT 
    Country,
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalQuantity) AS ProductQuantity
FROM product_summary
WHERE CountryQuantityRankAsc <=3
GROUP BY StockCode, Country
ORDER BY Country, ProductQuantity;

-- Top 3 products by Sales for each month
SELECT 
    OrderMonth,
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalSales) AS ProductTotal
FROM product_summary
WHERE MonthlySalesRank <=3
GROUP BY StockCode, OrderMonth
ORDER BY OrderMonth, ProductTotal DESC;

-- Bottom 3 by Sales for each month
SELECT 
    OrderMonth,
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalSales) AS ProductTotal
FROM product_summary
WHERE MonthlySalesRankAsc <=3
GROUP BY StockCode, OrderMonth
ORDER BY OrderMonth, ProductTotal;

-- Top 3 by Quantity for each month 
SELECT
    OrderMonth,
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalQuantity) AS ProductQuantity
FROM product_summary
WHERE MonthlyQuantityRank <=3
GROUP BY StockCode, OrderMonth
ORDER BY OrderMonth, ProductQuantity DESC;

-- Bottom 3 by Quantity for each month 
SELECT
    OrderMonth,
    StockCode,
    MAX(Description) AS ProductDescription,
    SUM(TotalQuantity) AS ProductQuantity
FROM product_summary
WHERE MonthlySalesRankAsc <=3
GROUP BY StockCode, OrderMonth
ORDER BY OrderMonth, ProductQuantity;

