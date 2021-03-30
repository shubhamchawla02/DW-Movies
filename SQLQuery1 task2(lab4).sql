DECLARE @StartDate DATE = '20100101', @NumberOfYears INT = 11;
SET DATEFIRST 7;
SET DATEFORMAT mdy;
SET LANGUAGE US_ENGLISH;
DECLARE @CutoffDate DATE = DATEADD(YEAR, @NumberOfYears, @StartDate);
DROP TABLE dimDate;
CREATE TABLE dimDate
(
[date]       DATE PRIMARY KEY,

  [day]        AS DATEPART(DAY,          [date]),

  [month]      AS DATEPART(MONTH,    [date]),

  FirstOfMonth AS CONVERT(DATE, DATEADD(MONTH, DATEDIFF(MONTH, 0, [date]), 0)),

  [MonthName]  AS DATENAME(MONTH,    [date]),

  [week]       AS DATEPART(WEEK,         [date]),

  [ISOweek]    AS DATEPART(ISO_WEEK, [date]),

  [DayOfWeek]  AS DATEPART(WEEKDAY,  [date]),

  [DayName]      AS DATENAME(WEEKDAY,  [date]),

  [quarter]    AS DATEPART(QUARTER,  [date]),

  [year]       AS DATEPART(YEAR,         [date]),

  EUStyle            AS CONVERT(varchar, [date], 105),

  IsWeekend    AS CONVERT(BIT, CASE WHEN DATEPART(WEEKDAY,  [date]) IN (1,7) THEN 1 ELSE 0 END),

  FirstOfYear  AS CONVERT(DATE, DATEADD(YEAR,  DATEDIFF(YEAR,  0, [date]), 0)),

  DateID             AS CONVERT(CHAR(8),   [date], 112),

  ---PRIMARY KEY(DateID, Date)

  Style101     AS CONVERT(CHAR(10),  [date], 101)
);
INSERT INTO dimDate([date])
SELECT d
FROM
(
  SELECT d = DATEADD(DAY, rn - 1, @StartDate)
  FROM
  (
       SELECT TOP (DATEDIFF(DAY, @StartDate, @CutoffDate))
          rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
        FROM sys.all_objects AS s1
        CROSS JOIN sys.all_objects AS s2
        ORDER BY s1.[object_id]

  ) AS x
) AS y;

--2.2.1 Checking the total number of rows
SELECT COUNT(date) AS NoOfRows FROM dimDate

--2.2.2 Number of unique years:
 SELECT COUNT(DISTINCT year) As NoOfUniqueYears FROM dimDate;

--2.2.3 Unique year-month combinations:
SELECT COUNT(*) FROM (SELECT  DISTINCT year, month FROM dimDate) AS diff;

--2.2.4 5 random rows for logical business correctness:
select top 5* from dimDate order by date

---2.3a
SELECT pp.ProductID, pp.Name, pp.ProductNumber, COALESCE(pps.Name, 'no subcat') AS Subcategory, 
COALESCE(ppc.Name, 'no category') AS Category, pp.ListPrice, COALESCE(pp.Color, 'No color') AS Color,pp.ProductLine, pp.Class,pp.Weight, pp.Size,

                  CASE
                   WHEN
                        (
                           SELECT DISTINCT ProductID
                           FROM AdventureWorks2017.Production.TransactionHistory pth
                           WHERE pp.ProductID = pth.ProductID
                               )     IS NULL THEN 'Not purchased'

                         ELSE 'Purchased'
                  END
                  AS Purchased,
         CASE pp.DaysToManufacture
                         WHEN(
                                  0
                               ) THEN 'Manufactured'

                         ELSE 'Not Manufactured'
                  END
        AS Manufactured

FROM AdventureWorks2017.Production.Product pp
LEFT JOIN  AdventureWorks2017.Production.ProductSubcategory pps
           ON pps.ProductSubcategoryID = pp.ProductSubcategoryID
LEFT JOIN AdventureWorks2017.Production.ProductCategory ppc
           ON ppc.ProductCategoryID = pps.ProductCategoryID

--b Set necessary constraints
   
ALTER TABLE DWAW.DIMProduct
ALTER COLUMN ProductID INTEGER NOT NULL

ALTER TABLE DWAW.DIMProduct
ADD CONSTRAINT PK_ProductionProductID PRIMARY KEY (ProductID)

ALTER TABLE DWAW.DIMProduct
ADD CONSTRAINT CK_Product_Class
CHECK (UPPER([Class])='H' OR UPPER([Class])='M' OR UPPER([Class])='L' OR [Class] IS NULL)

ALTER TABLE DWAW.DIMProduct
ADD CONSTRAINT CK_Product_ProductLine
CHECK (UPPER([ProductLine])='R' OR UPPER([ProductLine])='M' OR UPPER([ProductLine])='T' OR UPPER([ProductLine])='S' OR [ProductLine] IS NULL)

ALTER TABLE DWAW.DIMProduct
ADD CONSTRAINT CK_Product_ListPrice
CHECK ([ListPrice]>=(0.00))

ALTER TABLE DWAW.DIMProduct
ADD CONSTRAINT CK_Product_Weight
CHECK ([Weight]>(0.00))

--c Verifying Correctness
SELECT  COALESCE(p.Color,'noColor')AS Color, COUNT(COALESCE(p.Color, '')) AS ColorsinAdventureWorks, COUNT(pp.Color) AS NoOfColors
FROM AdventureWorks2017.Production.Product p
INNER JOIN AdventureWorks2017.Production.Product pp
ON pp.ProductID = p.ProductID
GROUP BY p.Color

SELECT COUNT(ProductID) AS dimproduct
FROM AdventureWorks2017.Production.Product

SELECT COUNT(ProductID) AS advworks
FROM AdventureWorks2017.Production.Product

--2.4
SELECT soh.SalesOrderID AS TransactionID, sod.SalesOrderDetailID AS TransactionDetailID, convert(varchar, OrderDate, 23) as OrderDate ,
convert(varchar, DueDate, 23) as DueDate,convert(varchar, ShipDate, 23) as ShipDate, sod.ProductID AS prodID, sod.UnitPrice AS UnitPrice, 
sod.OrderQty AS Quantity, LineTotal AS totalvalue, sod.UnitPriceDiscount AS UnitPriceDiscount,( sod.UnitPriceDiscount*sod.OrderQty)AS DiscountInTotal

FROM AdventureWorks2017.Sales.SalesOrderHeader soh
JOIN AdventureWorks2017.Sales.SalesOrderDetail sod
ON sod.SalesOrderID=soh.SalesOrderID



---3.1 Individual Customer Perspective:
SELECT sc.CustomerID, pp.FirstName,pp.LastName,pp.MiddleName, pp.Title,  addr.AddressLine1, addr.PostalCode,addr.City, addr.Province, addr.Country, addr.CountryCode, st.Name AS Region, st.[Group] AS 'Geographic Area Name'
FROM   AdventureWorks2017.Sales.Customer sc

INNER JOIN AdventureWorks2017.Person.Person   pp
ON sc.PersonID = pp.BusinessEntityID
INNER JOIN AdventureWorks2017.Sales.SalesTerritory st
ON sc.TerritoryID = st.TerritoryID CROSS APPLY

(
SELECT TOP 1 Address.AddressLine1, Address.City,  StateProvince.Name AS Province, CountryRegion.Name AS Country,CountryRegion.CountryRegionCode as CountryCode, Address.PostalCode

FROM   AdventureWorks2017.Person.BusinessEntityAddress addr
INNER JOIN AdventureWorks2017.Person.Address
ON addr.AddressID = AdventureWorks2017.Person.Address.AddressID

INNER JOIN AdventureWorks2017.Person.StateProvince
ON AdventureWorks2017.Person.Address.StateProvinceID = AdventureWorks2017.Person.StateProvince.StateProvinceID

INNER JOIN AdventureWorks2017.Person.CountryRegion
ON AdventureWorks2017.Person.StateProvince.CountryRegionCode = AdventureWorks2017.Person.CountryRegion.CountryRegionCode

WHERE  addr.BusinessEntityID = pp.BusinessEntityID
ORDER BY addr.ModifiedDate DESC
) AS addr
WHERE PersonType = 'IN';

--CHECKING if the number of customers with person type indivdual is equal to the one in adventureWorks2017
SELECT sc.CustomerID

FROM AdventureWorks2017.Sales.Customer sc
INNER JOIN AdventureWorks2017.Person.Person   pp
  ON sc.PersonID = pp.BusinessEntityID
WHERE PersonType = 'IN';

--3.2 
--Sale’s Location Perspective:
SELECT st.TerritoryID AS LocationID, st.Name, pc.Name AS 'Country name', st.[Group] AS 'Geographic area name'

FROM AdventureWorks2017.Sales.SalesTerritory st
INNER JOIN AdventureWorks2017.Person.CountryRegion pc
ON st.CountryRegionCode = pc.CountryRegionCode;

ALTER TABLE DIMSalesLocation
ADD PRIMARY KEY (LocationID);

ALTER TABLE DIMSalesLocation
ALTER COLUMN LocationID INTEGER NOT NULL

--Checks with adventureWorks

Select TerritoryID
FROM AdventureWorks2017.Sales.SalesTerritory

--3.3

SELECT sd.SalesOrderID AS TransactionID, SalesOrderDetailID AS TransactionDetailID, 
convert(date,DateID,23) as DateID,sh.TerritoryID AS LocationID,ProductID, sh.CustomerID,UnitPrice,OrderQty ,LineTotal, UnitPriceDiscount, (UnitPriceDiscount * OrderQty) as TotalDiscount

--INTO dwaw.CustomerSales
FROM AdventureWorks2017.Sales.SalesOrderDetail sd

left JOIN AdventureWorks2017.Sales.SalesOrderHeader  sh
ON sd.SalesOrderID =sh.SalesOrderID
left JOIN dbo.dimDate
ON dimDate.day = DAY(sh.OrderDate)
AND dimDate.month = Month (sh.OrderDate)
AND  dimDate.year = YEAR(sh.OrderDate)
left JOIN AdventureWorks2017.Sales.Customer

ON sh.CustomerID = AdventureWorks2017.Sales.Customer.CustomerID

left JOIN AdventureWorks2017.Person.Person

ON AdventureWorks2017.Sales.Customer.PersonID = AdventureWorks2017.Person.Person.BusinessEntityID

-- WHERE  PersonType = 'IN'


---4th task

ALTER TABLE dbo.DIMContinent
ADD PRIMARY KEY(ContinentID)

ALTER TABLE dbo.DIMProductionRating
ADD FOREIGN KEY (ContinentID) REFERENCES DWAW.DIMProductionRating(ContinentID); 

SELECT pr.Product,Rating City, ContinentID, Gender=(case when Gender='M' then 'Male' else 'Female' end), DAY(Time) as d, MONTH(Time) as m, YEAR(TIME) AS Y

-- INTO dwaw.DIMProductRating2

FROM DIMProductRating pr

left JOIN chinky.DIMContinent ct

ON  pr.ContinentID= ct.ContinentID






 

