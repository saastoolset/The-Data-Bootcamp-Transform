-- load data 
use database RAW;
use  RAW.globalmart;

create OR REPLACE table ORDERS (
    ORDERID string,
    ORDERDATE string,
    SHIPDATE string,
    SHIPMODE string,
    CUSTOMERID string,
    PRODUCTID string,
    ORDERCOSTPRICE float,
    ORDERSELLINGPRICE float
);


create OR REPLACE table CUSTOMERS (
	CustomerID	string,
	CustomerName	string,
	Segment	string,
	Country string,
    State string
);

create OR REPLACE table PRODUCT (
	Category	string,
	ProductID	string,
	ProductName	string,
	SubCategory	string
);


CREATE OR REPLACE FILE FORMAT RAW.GLOBALMART.mycsvformat
  TYPE = "CSV",
  FIELD_DELIMITER = ",",
  SKIP_HEADER = 1;

CREATE OR REPLACE STAGE RAW.GLOBALMART.STG_ORDERS
  FILE_FORMAT = mycsvformat;
CREATE OR REPLACE STAGE RAW.GLOBALMART.STG_PRODUCT
  FILE_FORMAT = mycsvformat;
CREATE OR REPLACE STAGE RAW.GLOBALMART.STG_CUSTOMERS
  FILE_FORMAT = mycsvformat;

-- Table Stage:@%,  Named Stage: @, User stages: @~
-- PUT file://C:\temp\orders.csv @%orders ;
-- PUT file://C:\temp\orders.csv @globalmart.orders AUTO_COMPRESS=TRUE;
-- full qualified name
-- ## VC cannot execute PUT, only sucess on SNOWSQL client
PUT file://C:\temp\orders.csv @RAW.GLOBALMART.STG_ORDERS;

PUT file://C:\temp\product.csv @RAW.GLOBALMART.STG_PRODUCT;
PUT file://C:\temp\customers.csv @RAW.GLOBALMART.STG_CUSTOMERS;

-- PUT file://C:\temp\orders.csv @~/staged;
-- PUT file://C:\temp\orders*.csv @stg_orders;

-- list @RAW.GLOBALMART.STG_ORDERS;
-- remove @RAW.GLOBALMART.STG_ORDERS;

COPY INTO RAW.GLOBALMART.ORDERS
  FROM @RAW.GLOBALMART.STG_ORDERS/orders.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file';

COPY INTO RAW.GLOBALMART.PRODUCT
  FROM @RAW.GLOBALMART.STG_PRODUCT/product.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file';

COPY INTO RAW.GLOBALMART.CUSTOMERS
  FROM @RAW.GLOBALMART.STG_CUSTOMERS/customers.csv.gz
  FILE_FORMAT = (FORMAT_NAME = mycsvformat)
  ON_ERROR = 'skip_file';




 select count(*) from RAW.GLOBALMART.ORDERS;