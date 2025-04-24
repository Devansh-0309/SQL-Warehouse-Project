# Data Warehouse & Analytics Project
Welcome to the **Data Warehouse & Analytics Project** repository

...

## Building The Data Warehouse

### Objective
Develop a modern data warehouse using SQL to consolidate sales, enabling analytical reporting and decision making.

### Data Architecture 
![image](https://github.com/user-attachments/assets/245bd99f-b19e-4d2c-b72e-e8be38c3dae3)


# **Data Catalog: Gold Layer**

## Overview
Data catalog is the short description of the data which is used to increase the readability of the code and helps the viewers to get a better understanding about the data before processing it. 

## Gold Layer
This layer is the final layer that consist of the processed tables and data that can be used to work on by dtaa Analyst/Scientist.

## 1. Gold.dim_customers
**Purpose**: Stores all details about the customers.
**Columns**: 

| Column        | Data Type                  | Description     |
|----------------|------------------------------|------------|
| customer_key   | INT       | Contains user defined unique indentifier e.g (1,2,3,...)|
| customer_id | INT   | Contains customer_id e.g (11000, 11001 ,....)   |
| customer_number | NVARCAHR(30)     | Contains customer number e.g (AW00011000) |
| first_name | NVARCHAR(30)| Contains the first name of the customer e.g (jon)|
| last_name | NVARCHAR(30)| Contains the last name of the customer e.g (yang)|
| country | NVARCHAR(30)| Contains the country origin of the customer e.g (Australia, France etc.)|
| marital_status | NVARCHAR(30)| Contains the marital status e.g (Married, Single, n/a)|
| gender | NVARCHAR(30)| Contains the gender of the customer e.g (Male, Female, n/a)|
| birth_date | DATE| Contains the birth date of the customer in 'YYYY-MM-DD' format |
| create_date | DATE | Contains the creation date of the customer when the id is created in 'YYYY-MM-DD' format|

## 2. Gold.dim_products
**Purpose**: Stores all details about the products.
**Columns**: 

| Column        | Data Type                  | Description     |
|----------------|------------------------------|------------|
| product_key   | INT       | Contains user defined unique indentifier e.g (1,2,3,...)|
| product_id | INT   | Contains product id e.g (210, 211 ,....)   |
| product_number | NVARCAHR(30)     | Contains product number e.g (FR-R92B-58) |
| product_name | NVARCHAR(40)| Contains the product name  e.g (Road-450 Red-48)|
| category_id | NVARCHAR(30)| Contains the category id of product e.g (BI_RB)|
| category | NVARCHAR(30)| Contains the category of products e.g (Bikes etc.)|
| sub_category | NVARCHAR(30)| Contains the sub category of product (Road Bikes etc.)|
| maintenance | NVARCHAR(30)| Contains maintenance category (NULL, Yes, No)|
| cost | INT | Contains the cost of the product |
| product_line | NVARCHAR(30) | Contains the product line e.g(Mountain, n/a etc.)|
| start_date | DATE | Contains the start date of the products in 'YYYY-MM-DD' format|

## 3. Gold.fact_sales
**Purpose**: Stores all details about the fact table sales.
**Columns**: 

| Column        | Data Type                  | Description     |
|----------------|------------------------------|------------|
| order_number   | NVARCHAR(30) | Contains unique indentifier e.g (SO43679)|
| product_key | INT   | Contains the product key integrated from dim_products view e.g(1,20,..) |
| customer_key | INT     | Contains customer key integrated with dim_customers e.g (10769,...)|
| sales | INT| Contains the sales of the product i.e (quantity/price))|
| quantity | INT | Contains the Quantity of the product purchased |
| price | INT | Contains the price of the product i.e ABS(sales) * quantity |
| order_date | DATE | Contains the order date in 'YYYY-MM-DD' format|
| ship_date | DATE | Contains the shipping date in 'YYYY-MM-DD' format|
| due_date | DATE | Contains the due date in 'YYYY-MM-DD' format|


#### Specifications
**Data Scources:** import the data from two sources (erp, crm) present as csv files.
**Data Quality:** Clean the data and make it relevant for data analysis.
**Data Integration:** Integrate the cleaned data from both the sources into a single source.
**Scope:** Focus on the latest data and no need of historization.
**Documentation:** Prepare clear of data model to support both the buisness and analytic team.

### Analytics & Reporting

#### Objective
Develop SQL-based analytics to deliver detailed insights into:
**Customer Behavious**
**Product Performance**
**Sales Trends**

These insights help stakeholders with key buisness metrices and decision making 

## License
This product is used under the (MIT Licence). You are free to use, modify and share this project.

## About me
Hi, I am **Devansh Maheshwari**. A passionate individual who has a keen interest in data and its propeties.
