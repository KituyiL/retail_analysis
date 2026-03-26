# Retail analysis

## Project overview
This project uses Python and SQL to analyse retail data. The data set contains all the transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail.The company mainly sells unique all-occasion gifts. Many customers of the company are wholesalers.

## Objective
The objective of the project is to analyse the retail data so as to make more informed decisions about customer retention and product inventory.

## Dataset  
**Source**   : [https://archive.ics.uci.edu/dataset/352/online+retail]  

**Size**     :   541,909 rows and 8 columns

**Variables**: InvoiceNo, StockCode,  Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country


## Project Structure
```bash
RETAIL/
├── data/
| ├──processed/     # processed datasets
| | ├──cancelled_orders.csv    # orders that were cancelled
| | ├──cleaned_data.csv    # final clean dataset after preprocessing
| | ├──online_retail.csv    # original datasaet (converted from excetl to csv)
| | ├──product_error     # orders with errors
│ | └──zero_price.csv    # orders where price is zero
| └── raw/
|  └──online_Retail.xlsx # original dataset (excel file)
├── Notebooks/
| ├──Analysis/
| | ├──cancelled_orders.ipynb   # analyse cancelled_orders dataset
| | ├──customer_analysis.ipynb  # run customers_analysis results
| | ├──order_analysis.ipynb     # run orders_analysis results
| | ├──product_analysis.ipynb   # run products_analysis results
| | ├──product_error.ipynb      # analyse product_error dataset
| | ├──revenue_analysis.ipynb   # run revenue_analysis results
| | ├──rfm_analysis.ipynb       # run rfm_analysis results
| | ├──segment_recommendation.ipynb # run recommendations results  
| | ├──time_analysis.ipynb       # run time_analysis results       
| | └──zero_price.ipynb          # analyse zero_price dataset
| ├──data_preprocessing.ipynb    # preprocessing of the data
| └──run_queries.ipynb           # run the SQL views and queries at once
├──Requirements/
| ├──requirements_read.md     # how to load libraries
| └──requirements.txt         # libraries required
├── SQL/
| ├──setup_database.sql         # database and table creation
| └──Total_Rows.csv             # total Rows inserted into the table
├──SQL_queries/                  # sql views and queries (incase one wants to test/run each category individaually)
| ├──customer_analysis.sql     # customers
| ├──order_analysis.sql        # orders
| ├──product_analysis.sql      # products
| ├──revenue_analysis.sql      # revenue
| ├──rfm_analysis.sql          # rfm and recommendations
| └──time_analysis.sql         # time
├── SQL_results/               # results as .csv files after running the queries
| ├──customer_analysis/        # customers
| ├──order_analysis/           # orders
| ├──product_analysis/         # products
| ├──revenue_analysis/         # revenue
| ├──rfm_analysis/             # rfm
| ├──segment_recommendation/   # recommendations
| └──time_analysis/            # time
├── project_summary.md         # Summary of the project
└── README.md                  # installation and brief project summary 
```


## Project steps
**Data preprocessing** 
- Converted excel file to csv file.
- Converted datatypes of InvoiceDate and CustomerID.
- Created TotalPrice column.
- Removed duplicates.
- Dealt with missing values in CustomerID and Descriptions columns.
- Dealt with cancelled orders, orders with errors and orders with zero unit price.

**SQL**
- Created a database and table.
- Ran SQL views and queries and results were automatically saved as .csv files.

## Analysis findings
### Customers
- UK has the most customers: 5,292 (81.795%). All the other countries had less than 100 customers.
- Top customers were mainly from: from the UK, Netherlands, EIRE and Australia.

### Orders
- The UK had the highest number of orders: 18,018 (90.275%). The other countries had less than 500 orders. 

- **Total orders:** 19,959

- **Top 3 months:** 
```
    September 2011 : 2,769
    October 2011   : 2,040
    Novemebr 2011  : 1,837
```
- **Bottom 3 months:** 
```
    December 2011  : 819
    January 2011   : 1,08
    February 2011  : 1,100
```
### Products
- There are plenty of products that were only sold once.

- **Top 3 products by sales**
```
  - DOTCOM POSTAGE	            : 206,248.77
  - REGENCY CAKESTAND 3 TIER    : 174,156.54
  - PAPER CRAFT , LITTLE BIRDIE	: 168,469.60
```

**Top 3 products by quantity**
```
  - PAPER CRAFT , LITTLE BIRDIE	    : 80,995
  - MEDIUM CERAMIC TOP STORAGE JAR	: 78,033
  - SMALL POPCORN HOLDER            : 56,898
```


### Revenue
**Total Revenue:** 10,631,048.74 GBP

**Top 3 months:**
```
  - 2011-November	: 1,503,866.78
  - 2011-October	: 1,151,263.73
  - 2011-September	: 1,056,435.19
```

**Bottom 3 months:**
```
  - 2011-February	: 522,545.56
  - 2011-April	    : 536,968.49
  - 2011-December	: 637,790.33
```

**Top 5 countries by revenue**
```
  - United Kingdom	: 899,0682.03
  - Netherlands	    : 285,446.34
  - EIRE            : 283,140.52
  - Germany	        : 228,678.40
  - France	        : 209,625.37
```

**Bottom 5 countries**
```
  - Brazil	        : 1,143.60 
  - RSA	            : 1,002.31
  - Czech Republic	: 826.74
  - Bahrain	        : 754.14
- Saudi Arabia	    : 145.92
```


### RFM
**Revenue per customer segment**

|CustomerSegment  |	 TotalRevenue	  |RevenuePercentage |
|-----------------|-----------------|------------------|
|New customers	  | 3,854,549.47	  |   36.26          |
|Loyal Customers  | 1,872,907.53	  |   17.62          |
|Lost	            | 1,819,333.65    |   17.11          |
|Need Attention	  | 1,752,866.69	  |   16.49          |
|VIP	            | 683,574.49	    |   6.43           |
|Active	          | 342,563.41	    |   3.22           |
|At Risk	        | 305,253.50	    |   2.87           |


### Cancelled orders

- Total cancelled_orders : 9,251

- Total revenue lost from cancelled orders : 89,3979.73


### Product error

- Total products with errors : 1,336

- Total number of products not sold due to errors : 20,6957

### Zero price

- Total orders with zero unit price: 1,159

- Total number of produducts lost from errors: 72,496


## Recommendations
**Customer segments recommendations**
```
New customers  : 15% Discount first order and second order
Lost	         : 25% Discount + emails/chat messages/social media
Active	       : 15% Discount voucher after every 10th/20th order + Personalised recommendation
VIP	           : VIP access
At Risk        : 20% Discount + Free shipping + personalised emails/chat messages/social media
Need Attention : 15% Discount + free shipping + personalised emails/ chat messages/social media
Loyal Customers: Loyalty program with perks
```
**Based on findings**
1. Keep track of products that sold very little and place a minimum limit to reduce the quantity to be held as inventory or to remove them completely from the catalogue.

2. Find a way to manage inventory more efficiently so as to reduce the amount of products with errors.

3. Create a model/system that analyses customer behaviour:
    - to personalize shopping experience and offers according to customer history to help increase retention.
    - to flag customers that are not active for a period of time and give them offers using the appropriate channels.
    - to find new patterns in customer behaviour that might help in providing better services.

4. Manage data input efficiently.
    1. Descriptions should be standardized. 
        - In the case of product errors and their adjustments, there should be a standard description and another column for clear explanations.
    2. StockCodes should be standardized.
        - The number of digits and whether they should have letters or not should be agreed upon.
    3. Include reasons for cancelled orders so as to be more proactive to reduce the number of cancelled orders.
    4. Include column for reason for zero unit price ie promotions, exchanges, adjustments etc 
    5. Ensure all data is correctly and fully entered.

5. Research more on international markets and competitors to increase international orders and retain current customers.

**Customers**
1. Ensure that the website/ app is easy to use and understand. This ennhances the user experience.

2. Ensure good customer care services and quick response to feedback from customers.

3. Have different channels to communicate with customers.

4. Collaborate with online influencers to reach potential customers and serve a reminder to existing customers.



## How to run the project
**Prerequisites**
- Python 
- SQL Server
- SQL Server Management Studio
- VS Code 
  - **VS Code extensions I used**
    - Python
    - Jupyter 
    - SQL Server (mssql)

1. Clone the repository
```bash
git clone https://github.com/KituyiL/retail_analysis.git
cd retail_analysis
```
2. Install dependencies
```bash
pip install -r Project/Requirements/requirements.txt
```
3. Run Notebooks\data_preprocessing.ipynb for data preprocessing.

4. Connect to SQL Server

5. Set up database
    - Execute the 'setup_database.sql' script. The script will create the database, table, and import the data.
    - You can change the names of the database and table.

6. On Notebooks\run_queries.ipynb file, update database credentials.
    - conn_str = r'DRIVER={your_driver};SERVER=your_server;DATABASE=your_database; Trusted_Connection=yes;'

7. Run the run_queries.ipynb file. This runs all the views and queries. It then saves the results as .csv files in the appropriate subfolders under SQL_results folder.
    - If you want to run individual categories you can execute the .sql files in SQL_queries folder. Note that this does not automatically save the results.

8. To view the data in the saved csv files, run the files in the Notebooks\Analysis folder.


