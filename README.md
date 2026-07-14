# customer_retention_analysis
## PROJECT GOAL
The project aims to analyze the online sales dataset of a superstore in the United States to understand which customer segments, product categories and regions they should target or avoid.  The project also performed cohort analysis to identify customer retention rate over time and therefore propose targeted marketing strategy to increase customer lifetime value and sales.

## DATASET OVERVIEW
The dataset contains 9994 transactional records  in the period of 2014-2017 and has 21 fields in total: 
Row ID; Order ID; Order Date; Ship Date; Ship Mode; Customer ID; Customer Name; Segment; Country; City; State; Postal Code; Region; Product ID; Category ; Sub-Category; Product Name; Sales; Quantity; Discount; Profit 

Dataset Source: Superstore Sales - Kaggle: https://www.kaggle.com/datasets/vivek468/superstore-dataset-final

## DATA CLEANING
There are 4 steps in cleaning the data using Excel and SQL:

- Check missing values.

- Check duplicate records.

- Check the standard format.

- Check abnormal values.

## EXPLORATORY DATA ANALYSIS (EDA)
### 1. Sales Performance Analysis
Key Metrics: Sales, Profit, Orders, Average Order Value (AOV), Gross Margin (%)

Key Findings:
- Sales and profit increased consistently from 2014 to 2017, indicating sustained business growth.
- Revenue peaked in Q4, particularly in November.
- Although 2014 generated higher sales than 2015, its profit was lower.

Business Insights:
- The business has maintained a strong and steady growth trajectory.
- Q4 represents the most critical sales season, driven by major shopping events such as Black Friday, Cyber Monday, and the Christmas holiday season.
- The lower profitability in 2014 suggests that profit margins were not fully optimized, potentially due to aggressive discounting strategies or an unfavorable product mix.

### 2. Customer Analysis
Key Metrics: Total Customers, Average Purchase Frequency, Average Revenue per Customer, Repeat Purchase Rate

Key Findings:
- The Consumer segment accounts for more than 50% of the total customer base.
- Corporate customers generate higher average revenue per customer.
- Customers purchase an average of 6.32 times, with over half making 6–10 purchases. Purchase frequency is relatively consistent across customer segments.
- Revenue is well distributed across customers rather than relying heavily on a small group of high-value buyers.

Business Insights:
- The Consumer segment serves as the primary revenue driver due to its large customer base.
- Corporate customers demonstrate a higher Customer Lifetime Value (CLV).
- The business faces relatively low revenue concentration risk, as sales are not overly dependent on a few major customers.

### 3. Regional Analysis
Key Metrics: Sales, Profit

Key Findings:
- The West and East regions contribute the largest share of both sales and profit.
- California and New York are the most profitable markets.
- Texas, Ohio, Philadelphia, and Houston generate low or even negative profits.

Business Insights:
- Revenue and profitability are concentrated in several key geographic markets.
- Certain regions achieve strong sales but deliver weak profit margins, indicating operational inefficiencies.

### 4. Product Analysis
Key Metrics: Sales, Profit

Key Findings
- Technology is the highest-performing category in both sales and profit.
- Furniture generates strong sales but contributes relatively low profit.
- Tables and Bookcases are consistently unprofitable product subcategories.
- Canon ImageCLASS is the best-selling product.

Business Insights
- Technology serves as the primary driver of business growth.
- Furniture negatively impacts overall profitability, likely due to high discount rates or elevated operating costs.

## CUSTOMER RETENTION ANALYSIS USING COHORT ANALYSIS
Key Metrics: Customer Retention Rate, Cohort Size

Key Findings
- Customer retention declines sharply after the first month.
- By the second month, only 5–15% of customers return for another purchase.
- Retention remains low but relatively stable thereafter.
- The March cohort acquired the highest number of new customers.

Business Insights
- The largest customer drop-off occurs immediately after the first purchase.
- Customers tend to make purchases on an as-needed basis rather than following a recurring buying pattern.
- Marketing campaigns launched in early spring appear to be more effective at acquiring new customers.

## RECOMMENDATIONS
Based on the analysis, the company should focus on improving both profitability and customer retention while leveraging its strongest growth drivers. The key strategic recommendations are:
- Capitalize on Q4 demand by increasing marketing investment, optimizing inventory planning, and preparing promotional campaigns ahead of the peak shopping season.
- Improve profit margins by reviewing discount policies, monitoring Gross Margin across product categories, and optimizing pricing strategies.
- Expand the Consumer segment while strengthening relationships with high-value Corporate customers through tailored pricing, long-term contracts, and dedicated B2B programs.
- Increase customer retention by implementing first-to-second purchase campaigns within the first 30 days, supported by automated email, SMS, and voucher incentives, as well as a structured loyalty program.
- Invest in high-performing markets and products, particularly California, New York, and the Technology category, while addressing operational inefficiencies in low-profit regions such as Texas and Ohio.
- Optimize the product portfolio by reassessing pricing and promotional strategies for Furniture and considering the repositioning or discontinuation of persistently unprofitable products.
- Leverage data-driven decision making by analyzing successful customer acquisition campaigns (such as the March cohort) and continuously monitoring customer behavior, profitability, and retention metrics to drive sustainable long-term growth.

Overall, these initiatives aim to increase Customer Lifetime Value (CLV), improve operational efficiency, strengthen profitability, and support sustainable business growth.


