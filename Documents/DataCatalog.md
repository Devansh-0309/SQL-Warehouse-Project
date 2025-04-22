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
