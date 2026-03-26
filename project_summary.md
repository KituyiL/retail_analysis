# Retail Analysis
## 1.0 Project overview
This is a transactional data set which contains all the transactions occurring between 01/12/2010 and 09/12/2011 for a UK-based and registered non-store online retail.The company mainly sells unique all-occasion gifts. Many customers of the company are wholesalers. The dataset has 541,909 rows and 8 columns. 
Data retrieved from https://archive.ics.uci.edu/dataset/352/online+retail

### 1.1 Variables 

|Column       | Description                      |Datatype   |More information                                                    
|-------------|----------------------------------|-----------|--------------------------------------------------------------------|
|InvoiceNo    |Invoice number                    |Nominal    |a 6-digit integral number uniquely assigned to each transaction.If  |
|             |                                  |           |this code starts with letter 'c', it indicates a cancellation.      |
|StockCode    |Product code                      |Nominal    |5-digit integral number uniquely assigned to each distinct product. |
|Description  |Product name                      |Nominal    |                                                                    |
|Quantity     |Product quantity per transaction  |Numeric	 |                                                                    |
|InvoiceDate  |Invoice Date and time             |Numeric    |Day and time when each transaction was generated.                   |
|UnitPrice    |Unit price                        |Numeric    |Product price per unit in sterling.                                 |
|CustomerID   |Customer number                   |Nominal    |5-digit integral number uniquely assigned to each customer.         |
|Country      |Country name                      |Nominal    |Name of the country where each customer resides.                    |

### 1.2 Objective
The goal is to analyse the data so as to  make more informed decisions about customer retention and product inventory.

## 2.0 Key steps
### 2.1 Data preprocessing
1. Converted Excel file to CSV file.
2. Dataset transformation
    - Converted datatypes: Invoice date to Datetime from object and Customer ID to int64 from float64.
    - Created column: TotalPrice
3. Removed 5,268 duplicate rows.
4. Missing values were found in Description and CustomerID columns

    - Customer ID : The invoices associated with missing customer Ids had no cutomer id at all. CustomerIds were given as InvoiceNo + I eg 23456I

    - Descriptions: Dropped cancelled orders and products error
        - Cancelled orders have negative quantities and start with 'C'.
        - Product errors are Damaged/missing orders that have unit price of 0, negative quantities and do not start with 'C'

        - The unique stock codes were mapped to associated descriptions and used that to fill in missing descriptions.
        - There were 15 stock codes that were dropped that had no associated descriptions. They also did not have Customer Ids and had unit price of 0.

5. Orders from the dataset that had zero unit price and quantity greater than zero were dropped.

6. All invoice numbers that were not 6 digits were an adjustment for bad debt. They were dropped.

- Final cleaned dataset had 524,877 rows and 9 columns

### 2.2 SQL
- Database ws created (RetailDB).
- A table was created and data from cleaned_data.csv inserted.
- Views and queries were created.

### 2.3 Analysis
#### 2.3.1 Customers
- **Total Number of customers:** 5,765

- UK has the most customers 5,292 (81.795%). All the other countries had less than 100 customers. Germany was 2nd with 94 customers and France 3rd with 90 customers.

- Among the top 10 customers by sales:
    - There were customers from the UK, Netherlands, EIRE and Australia. 
    - Only 1 had made 1 purchase, the rest had  customerlifetimedays > 300

- Among the top 10 customers by number of orders: 
    - There were customers from UK, EIRE and the Netherlands.
    - The top customer in UK and EIRE had > 200 orders. 
    - The top customer in more than half the countries had less than 10 orders.

- In the list of the top customer in each country:
    - Only the top customer from the Netherlands and UK had Total sales > 200,000.
    - The top customer from Bahrain and Saudi Arabia had > 500 in TotalSales and had only purchased once.


#### 2.3.2 Orders
- **Total orders:** 19,959
-**Top 3 months:** 
```
    - September 2011 : 2,769
    - October 2011   : 2,040
    - Novemebr 2011  : 1,837
```
- **Bottom 3 months:** 
```
    - December 2011  : 819
    - January 2011   : 1,08
    - February 2011  : 1,100
```
- The UK had the highest number of orders(18,018). The other countries had less than 500 orders. 
- Germany was second with 457 orders and France third with 392 orders. 
- Lebanon, Saudi, Brazil, RSA only had 1 order.

#### 2.3.3 Products
- There are 66,609 distinct products that were ordered
- There are plenty of products that were only sold once.

**Top 3 products by sales**
```
DOTCOM POSTAGE	            : 206,248.77
REGENCY CAKESTAND 3 TIER	: 174,156.54
PAPER CRAFT , LITTLE BIRDIE	: 168,469.60
```
**Bottom 3 products by sales**
```
PADS TO MATCH ALL CUSHIONS	: 0.00
HEN HOUSE W CHICK IN NEST	: 0.42
VINTAGE BLUE TINSEL REEL	: 0.84
```
**Top 3 products by quantity**
```
PAPER CRAFT , LITTLE BIRDIE	    : 80,995
MEDIUM CERAMIC TOP STORAGE JAR	: 78,033
22197	SMALL POPCORN HOLDER	: 56,898
```
**Top 3 products each month by sales**
- These products appeared the highest amount of times over the months:
```
    1. DOTCOM POSTAGE           : 11
    2. REGENCY CAKESTAND 3 TIER : 6
    3. PARTY BUNTING            : 4
```
**Top 3 products each month by quantity**
- These products appeared the highest amount of times over the months:
    1. WORLD WAR 2 GLIDERS ASSTD DESIGNS : 6
    2. JUMBO BAG RED RETROSPOT           : 5
    3. POPCORN HOLDER                    : 5

**Top 3 products in each country by sales**
- These products appeared the highest amount of times:
```
POSTAGE	                  : Austria, Belgium, Canada, European Community, Finland, France,  
                            Germany, Italy, Malta, Norway,Poland, Portugal, Switzerland
Manual	                  : Cyprus, EIRE, France, Hong Kong, Norway, Portugal, Singapore
REGENCY CAKESTAND 3 TIER  : Brazil, Greece, Israel, Lebanon, Malta, United Arab Emirates
```
**Top 3 products in each country by quantity**
- These products appeared the highest amount of times:
```
RABBIT NIGHT LIGHT	              : Australia, France, Iceland, Japan, Netherlands
RED HARMONICA IN BOX	          : Australia, Denmark, Lithuania
WORLD WAR 2 GLIDERS ASSTD DESIGNS :	Canada, Hong Kong, Unspecified
```
**Bottom 3 products in each country by quantity**
- These products appeared the highest amount of times:
```
POSTAGE	                         : Canada, Czech Republic, Denmark, Hong Kong, Malta, 
                                   Norway, Poland, Sweden, United Arab Emirates
REGENCY CAKESTAND 3 TIER         : Bahrain, Canada, Iceland, Norway, Switzerland
VINTAGE CREAM DOG FOOD CONTAINER :	Austria, Greece, Lebanon
```
#### 2.3.4 Revenue
**Total Revenue:** 10,631,048.74 GBP

**Top 3 months:**
```
2011-November	: 1,503,866.78
2011-October	: 1,151,263.73
2011-September	: 1,056,435.19
```
**Bottom 3 months:**
```
2011-February	: 522,545.56
2011-April	    : 536,968.49
2011-December	: 637,790.33
```
**Highest revenue growth rate**
```	
2011-May	769,296.61	43.27  (2011-April	536,968.49)
```
**Lowest growth rate**
```
2011-December	637,790.33	-57.59  (2011-November	1,503,866.78)
```

**Top 5 countries by revenue**
```
United Kingdom	: 899,0682.03
Netherlands	    : 285,446.34
EIRE	        : 283,140.52
Germany	        : 228,678.40
France	        : 209,625.37
```
**Bottom 5 countries**
```
Brazil	        : 1,143.60 
RSA	            : 1,002.31
Czech Republic	: 826.74
Bahrain	        : 754.14
Saudi Arabia	: 145.92
```

#### 2.3.5 Time
No orders were placed on Saturdays.

**Average daily revenue**
```
Tuesday	    : 4,282.9
Monday	    : 4,008.5
Friday	    : 3,781.4
Wednesday	: 3,621.7
Thursday	: 3,530.2
Sunday	    : 2,422.8
```
**Average daily orders**
```
Wednesday : 7
Monday	  : 7
Thursday  : 6
Friday	  : 6
Sunday	  : 6
Tuesday	  : 6
```
**Top 5 average hourly revenue**
```
Weekday	   Hour	   AvgHourlyRevenue	  PeakRevenue
Wednesday	20	   13,032.0	          13,031.50
Friday	    9	   65,94.0	          17,1679.08
Tuesday	    10	   6,507.0	          78,348.66
Tuesday	    15	   6,226.0	          42,481.97
Thursday	10	   5,804.0	          21,234.10
```
**Top average hourly orders**
```
Weekday	    Hour	AvgHourlyOrders	 PeakOrders
Wednesday	12	    11	             23
Thursday	12	    11	             21
Tuesday	    12	    10	             26
Monday	    12	    10	             20
Thursday	13	    9	             20
```
#### 2.3.6 RFM analysis(Recency, Frequency, Monetary)
- This is an analysis technique to segment customers based on their transactions. How recently they purchased, how often and how much they spent.

**Revenue per customer segment**

|CustomerSegment  |	 TotalRevenue	|RevenuePercentage |
|-----------------|-----------------|------------------|
|New customers	  | 3,854,549.47	|   36.26          |
|Loyal Customers  | 1,872,907.53	|   17.62          |
|Lost	          | 1,819,333.65    |   17.11          |
|Need Attention	  | 1,752,866.69	|   16.49          |
|VIP	          | 683,574.49	    |   6.43           |
|Active	          | 342,563.41	    |   3.22           |
|At Risk	      | 305,253.50	    |   2.87           |


**Customer segment distribution**
|CustomerSegment  |	CustomerCount |	Percentage | AvgRecency|AvgFrequency |	 AvgMonetary      |
|-----------------|---------------|------------|-----------|-------------|--------------------|
|VIP	          |    3	      |    0.05	   |     0	   |   111	     |   227,858.163333   |
|Loyal Customers  |   60	      |    1.04	   |     4	   |   40	     |   31,215.125500    |
|At Risk	      |   14	      |    0.24	   |     284   |   4	     |   21,803.821428    |
|Active	          |   43	      |    0.75	   |     7	   |   26	     |   7,966.590930     |
|New customers	  |   1690	      |    29.31   |     13	   |   4	     |   2,280.798502     |
|Need Attention	  |   1410	      |    24.46   |     56	   |   2	     |   1,243.167865     |
|Lost	          |   2545	      |    44.15   |     223   |   1	     |   714.865874       |


#### 2.3.7 Cancelled orders

Total cancelled orders: 9,251

Total revenue lost from cancelled orders: 89,3979.73

Total distinct products that were cancelled: 1,972

**Top products that were cancelled**
```
|Description               | Count   | TotalRevenue |
|--------------------------|---------|--------------|
|Manual                    |  244    |  -146784.46  |
|REGENCY CAKESTAND 3 TIER  |  180    |  -9697.05    |
|POSTAGE                   |  126    |  -11871.24   |
|JAM MAKING SET WITH JARS  |  87     |  -1012.79    |
```
#### 2.3.8 Product error

Total products with errors: 1,336

Total number of products not sold due to errors: 20,6957

Total distinct errors: 138

**Top distinct errors**

check                 : 120
damages               : 45
damaged               : 42
?                     : 41
sold as set on dotcom : 20


#### 2.3.8 Zero price

Total orders with zero unit price: 1,159

Total number of produducts lost from errors: 72,496

Total distinct products that had zero unit price: 636

**Top distinct products that had zero unit price**
```
check                         : 39           
found                         : 25           
adjustment                    : 14           
FOLKART HEART NAPKIN RINGS    : 9           
FRENCH BLUE METAL DOOR SIGN 1 : 9          
```

## 3.0 Recommendations
**Customer segments recommendations**
```
New customers  : 15% Discount first order and second order
Lost	       : 25% Discount + emails/chat messages/social media
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




