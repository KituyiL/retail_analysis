-- Time view
CREATE VIEW daily_summary AS 
SELECT
    CAST(InvoiceDate AS DATE) AS Date,
    DATENAME(weekday, InvoiceDate) AS Weekday,
    DATEPART(weekday, InvoiceDate) AS WeekdayNum,
    DATEPART(hour, InvoiceDate) AS Hour,
    COUNT(DISTINCT InvoiceNo) AS OrderCount,
    SUM(TotalPrice) AS TotalSales
FROM online_retail
GROUP BY CAST(InvoiceDate AS DATE), DATENAME(weekday, InvoiceDate), DATEPART(weekday, InvoiceDate), DATEPART(hour, InvoiceDate);
GO

-- Average daily revenue
SELECT
    Weekday,
    ROUND(AVG(TotalSales), 1) AS AvgDailyRevenue
FROM daily_summary
GROUP BY Weekday
ORDER BY AvgDailyRevenue DESC;


-- Average daily orders
SELECT
    Weekday,
    ROUND(AVG(OrderCount), 1) AS AvgDailyOrders
FROM daily_summary
GROUP BY Weekday
ORDER BY AvgDailyOrders DESC;

-- Average hourly revenue
SELECT TOP 10
    Weekday,
    Hour,
    ROUND(AVG(TotalSales), 0) AS AvgHourlyRevenue,
    MAX(TotalSales) As PeakRevenue
FROM daily_summary
GROUP BY Weekday, Hour
ORDER BY AvgHourlyRevenue DESC;

--  Top average hourly orders
SELECT TOP 10
    Weekday,
    Hour,
    ROUND(AVG(OrderCount), 0) AS AvgHourlyOrders,
    MAX(OrderCount) As PeakOrders
FROM daily_summary
GROUP BY Weekday, Hour
ORDER BY AvgHourlyOrders DESC;