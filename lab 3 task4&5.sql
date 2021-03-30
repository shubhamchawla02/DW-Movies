
----1----provides information about product’s subcategory, product’s colour and average list price; please do
---not use pivoting here
SELECT ProductSubcategoryID, Color, AVG(ListPrice) as "Average price"
FROM AdventureWorks2014.Production.Product
WHERE ProductSubcategoryID  IS NOT NULL AND Color IS NOT NULL
GROUP BY ProductSubcategoryID, Color

---2 provides information about average list price for different colours of different product subcategories;
---please put colours on columns, products’ subcategory names on rows, and average list price as values
SELECT Name, [Multi], [Black], [Silver], [Red], [Yellow], [Blue], [Grey], [Silver/Black], [White]
from(
	select psc.Name, p.Color, p.ListPrice as "ListPrice"
	from Production.Product as p
		join Production.ProductSubcategory as psc on p.ProductSubcategoryID = psc.ProductSubcategoryID
	group by psc.name, p.color, p.ListPrice
) as sometable
pivot(
	avg(ListPrice)
	for Color in ([Multi], [Black], [Silver], [Red], [Yellow], [Blue], [Grey], [Silver/Black], [White])
)as pvt

--3 provides information about average sales subtotal amounts in years due to months; please put
---months on columns, years on rows, and subtotal as values
SELECT YearOrder, [1] As "January", [2] As "February",[3] As "March",[4] As "April", [5] As "May", [6] As "June", [7] As "July"
,[8] As "August", [9] As "September", [10] As "October", [11] As "November", [12] As "December"
FROM(
	SELECT subtotal , YEAR(OrderDate) AS YearOrder, MONTH(orderdate) AS "Month"
		FROM Sales.SalesOrderHeader
		Group By YEAR(OrderDate), MONTH(orderdate),SubTotal
 		 	
) AS DerivedTable
PIVOT
(
	 Avg(subtotal) FOR Month IN("1","2","3","4","5","6","7","8","9","10","11","12")
)
AS PivotedTable


-------Task 5-------
---1 provide information about different product’s price categories:
  --a. ListPrice < 20.00 – Inexpensive
  --b. 20.00 < ListPrice < 75.00 – Regular
  --c. 75 < ListPrice < 750.00 – High
  --d. 750.00 < ListPrice – Expensive

  SELECT Name, ListPrice1=
      CASE  
		WHEN Listprice < 20.00 THEN 'Inexpensive'
		WHEN 20.00 <= ListPrice AND ListPrice < 74.99  THEN 'Regular'
		WHEN 75.00 < ListPrice AND ListPrice < 750.00 THEN 'High'
		WHEN 750 < ListPrice THEN 'Expensive'
		END, ListPrice
	FROM Production.Product
	GROUP BY Name, ListPrice
	order by ListPrice

--2 provide information about product’s name and weight displayed in kilograms (!!!). If the weight is unavailable utilise -1.
Select Name, 
CASE 
WHEN Weight IS NULL THEN '1'
ELSE cast((Weight/1000) as decimal(4,3))
END AS "Weight(kg)"
from Production.Product

--3. provide information about the number of ordered items for different colours of products in different
--years; please use CASE construct and put years on columns
SELECT 
	Color,
	CASE WHEN [2011] IS NULL THEN 0 ELSE [2011] END AS [2011],
	CASE WHEN [2012] IS NULL THEN 0 ELSE [2012] END AS [2012],
	CASE WHEN [2013] IS NULL THEN 0 ELSE [2013] END AS [2013],
	CASE WHEN [2013] IS NULL THEN 0 ELSE [2014] END AS [2014]
FROM(
SELECT 
	SUM(SOD.OrderQty) AS 'Quantity',
	CASE 
		WHEN POP.Color IS NOT NULL THEN POP.Color
		ELSE 'Invalid'
	END Color,
	YEAR(SOH.OrderDate) AS 'OrderYear'
FROM Sales.SalesOrderHeader SOH INNER JOIN Sales.SalesOrderDetail SOD 
ON SOH.SalesOrderID=SOD.SalesOrderID
INNER JOIN Production.Product POP
ON POP.ProductID = SOD.ProductID
group by POP.Name, POP.Color, YEAR(SOH.OrderDate)
) AS SRC
PIVOT(
SUM(Quantity)w
FOR OrderYear IN ([2011], [2012], [2013], [2014])
)AS PTable



