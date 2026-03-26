-- Create database
CREATE DATABASE RetailDB;
GO

-- Switch to the database created
USE RetailDB;
GO

--Drop table if exists
DROP TABLE IF EXISTS online_retail;
GO

--Create table to match csv structure
CREATE TABLE online_retail (
    InvoiceNo VARCHAR(20),
    StockCode VARCHAR(20),
    Description VARCHAR(1000),
    Quantity INT,
    InvoiceDate DATETIME,
    UnitPrice DECIMAL(10, 2),
    CustomerID VARCHAR(20),
    Country VARCHAR(50),
    TotalPrice DECIMAL(10, 2)
);
GO

-- Import data from csv file
BULK INSERT online_retail
FROM 'C:\my_projects\final_projects\SQL_Projects\Retail\data\processed\cleaned_data.csv'
WITH (
    FORMAT = 'CSV',  
    FIELDQUOTE = '"', -- specify the quote character
    FIRSTROW = 2, --skip header row
    FIELDTERMINATOR = ',', --separator between fields
    ROWTERMINATOR = '\n', --character that marks the end of each row
    CODEPAGE = '65001',  -- UTF-8
    TABLOCK -- reduces number of logged records
);
GO

-- Verify data importation
SELECT COUNT(*) AS 'Number of Rows Loaded' FROM online_retail;
GO
