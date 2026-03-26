--revenue view
CREATE VIEW revenue_summary AS
SELECT
    Country,
    FORMAT(InvoiceDate, 'yyyy-MM') AS OrderMonth,
    SUM(TotalPrice) AS TotalSales,
    ROW_NUMBER() OVER(PARTITION BY Country ORDER BY SUM(TotalPrice) DESC) AS CountrySalesRank,
    ROW_NUMBER() OVER(PARTITION BY FORMAT(InvoiceDate, 'yyyy-MM') ORDER BY SUM(TotalPrice) DESC) AS MonthlySalesRank,
    ROW_NUMBER() OVER(PARTITION BY FORMAT(InvoiceDate, 'yyyy-MM') ORDER BY SUM(TotalPrice) ASC) AS MonthlySalesRankAsc,
    ROW_NUMBER() OVER(PARTITION BY Country ORDER BY SUM(TotalPrice) ASC) AS CountrySalesRankAsc
FROM online_retail
GROUP BY Country, FORMAT(InvoiceDate, 'yyyy-MM');
GO

--Total revenue
SELECT
    SUM(TotalSales) AS TotalRevenue
FROM revenue_summary

-- Total revenue per month
SELECT
    OrderMonth,
    SUM(TotalSales) AS TotalRevenue
FROM revenue_summary
GROUP BY OrderMonth
ORDER BY OrderMonth, TotalRevenue;

-- Top 5 months with highest revenue
SELECT TOP 5    
    OrderMonth,
    SUM(TotalSales) AS TotalRevenue
FROM revenue_summary
GROUP BY OrderMonth
ORDER BY TotalRevenue DESC;

-- Bottom 5 months revenue
SELECT TOP 5 
    OrderMonth,
    SUM(TotalSales) AS TotalRevenue
FROM revenue_summary
GROUP BY OrderMonth
ORDER BY TotalRevenue ASC;

-- Revenue growth per month
SELECT
    OrderMonth,
    SUM(TotalSales) AS TotalRevenue,
    ROUND(
        100 * (SUM(TotalSales) - LAG(SUM(TotalSales), 1) OVER (ORDER BY OrderMonth)) /
        NULLIF(LAG(SUM(TotalSales), 1) OVER (ORDER BY OrderMonth), 0), 2 
    )AS GrowthRate
FROM revenue_summary
GROUP BY OrderMonth
ORDER BY OrderMonth, TotalRevenue;

--Total revenue per country
SELECT
    Country,
    SUM(TotalSales) AS TotalRevenue
FROM revenue_summary
GROUP BY Country
ORDER BY Country, TotalRevenue;




