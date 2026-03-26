-- create rfm view
CREATE VIEW customer_rfm AS
WITH last_date AS (
    SELECT MAX(InvoiceDate) AS CurrentDate
    FROM online_retail
),
rfm_calculations AS (
    -- Base metrics for each customer
    SELECT
        CustomerID,
        -- Recency: Days since the last purchase (how recently a customer has made a purchase)
        DATEDIFF(day, MAX(InvoiceDate), l.CurrentDate) AS Recency,
        --Frequency: Count of invoices (how often a customer makes a purchase)
        COUNT(DISTINCT InvoiceNo) AS Frequency,
        --Monetary: Total money spent (how much money a customer has spent over time)
        SUM(TotalPrice) AS Monetary
    FROM online_retail
    CROSS JOIN last_date l
    WHERE CustomerID IS NOT NULL
    GROUP BY CustomerID, l.CurrentDate
),
rfm_scoring AS (
    -- Convert metrics to 1-3 scores
    SELECT *,
        CASE
            WHEN Recency <=30 THEN 3
            WHEN Recency <=90 THEN 2
            ELSE 1
        END AS RecencyScore,
        CASE
            WHEN Frequency >= 60 THEN 3
            WHEN Frequency >=20 THEN 2
            ELSE 1
        END AS FrequencyScore,
        CASE
            WHEN Monetary >= 70000 THEN 3
            WHEN Monetary >= 9000 THEN 2
            ELSE 1
        END AS MonetaryScore
    FROM rfm_calculations
)
--Assign customer segments based on combined scores
SELECT
    CustomerID,
    Recency,
    Frequency,
    Monetary,
    RecencyScore,
    FrequencyScore,
    MonetaryScore,
    CASE
        -- VIP : Highest tier 
        WHEN RecencyScore = 3 AND FrequencySCore = 3 AND MonetaryScore = 3 THEN 'VIP'
        
        -- Loyal Customers
        WHEN RecencyScore = 3 AND FrequencySCore >= 2 AND MonetaryScore >= 2 THEN 'Loyal Customers'
      
        -- Potential Loyalist
        WHEN RecencyScore = 3 AND FrequencySCore = 2 AND MonetaryScore = 2 THEN 'Potential Loyalist'
        
        -- New Customers
        WHEN RecencyScore = 3 AND FrequencySCore = 1 AND MonetaryScore <= 3 THEN 'New customers'
        
        -- Active
        WHEN RecencyScore >= 2 AND FrequencySCore >= 2 AND MonetaryScore >= 1 THEN 'Active'
        
        -- Need Attention
        WHEN RecencyScore >= 2 AND FrequencySCore <= 2 AND MonetaryScore <= 2 THEN 'Need Attention'

        -- Lost
        WHEN RecencyScore = 1 AND FrequencySCore = 1 AND MonetaryScore = 1 THEN 'Lost'
                   
        -- At risk
        WHEN RecencyScore = 1 AND FrequencySCore <= 3 AND MonetaryScore <= 3 THEN 'At Risk'
        
        ELSE 'Other'
    END AS CustomerSegment
FROM rfm_scoring;
GO

-- Marketing recommendations
CREATE VIEW recommendations AS
    SELECT
        CustomerID,
        CustomerSegment,
        Recency,
        Frequency,
        Monetary,
        RecencyScore,
        FrequencyScore,
        MonetaryScore,
    --Actionable
    CASE
        WHEN CustomerSegment = 'VIP' THEN 'VIP access'  
        WHEN CustomerSegment = 'Loyal Customers' THEN 'Loyalty program with perks' 
        WHEN CustomerSegment = 'Potential Loyalist' THEN 'Rewards after every 10th order/ every other month + Personalised recommendation' 
        WHEN CustomerSegment = 'New Customers' THEN '15% Discount first order and second order' 
        WHEN CustomerSegment = 'Active' THEN '15% Discount voucher after every 10th/20th order + Personalised recommendation'
        WHEN CustomerSegment = 'Need Attention' THEN '15% Discount + free shipping + personalised emails/ chat messages/social media'
        WHEN CustomerSegment = 'At risk' THEN '20% Discount + Free shipping + personalised emails/chat messages/social media'
        WHEN CustomerSegment = 'Lost' THEN '25% Discount + emails/chat messages/social media'
        ELSE 'Standard Newsletter'
    END AS Recommendation
FROM customer_rfm;
GO

--Customer segments distribution
SELECT
    CustomerSegment,
    COUNT(*) AS CustomerCount,
    ROUND(100.0 * COUNT(*)/ SUM(COUNT(*)) OVER(), 2) AS Percentage,
    AVG(Recency) AS AvgRecency,
    AVG(Frequency) AS AvgFrequency,
    AVG(Monetary) AS AvgMonetary
FROM customer_rfm
GROUP BY CustomerSegment
ORDER BY AvgMonetary DESC;

--Top customers
SELECT TOP 10
    CustomerID,
    CustomerSegment,
    Recency,
    Frequency,
    Monetary,
    RecencyScore,
    Frequencyscore,
    MonetaryScore
FROM customer_rfm
WHERE CustomerSegment = 'VIP'
ORDER BY Monetary DESC;

--Customers that are at risk/need more attention
SELECT TOP 20
    CustomerID,
    CustomerSegment,
    Recency,
    Frequency,
    Monetary,
    RecencyScore,
    Frequencyscore,
    MonetaryScore
FROM customer_rfm
WHERE CustomerSegment IN ('At Risk', 'Need Attention')
ORDER BY Monetary DESC;

-- Revenue per segment
SELECT
    CustomerSegment,
    SUM(Monetary) AS TotalRevenue,
    ROUND(100.0 * SUM(Monetary) / SUM(SUM(Monetary)) OVER(), 2) AS RevenuePercentage
FROM customer_rfm
GROUP BY CustomerSegment
ORDER BY TotalRevenue DESC;

-- Recommendation per segment
SELECT
    CustomerSegment,
    SUM(Monetary) AS TotalRevenue,
    ROUND(100.0 * SUM(Monetary) / SUM(SUM(Monetary)) OVER(), 2) AS RevenuePercentage,
    Recommendation
FROM recommendations
GROUP BY CustomerSegment, Recommendation;
