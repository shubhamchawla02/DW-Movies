--Analyze sales data based on the color of product and class. This query gives a visualization of how the product color and class affect different sales data shown below. Left join would give null values of some sales data or example for product colored grey and class not assigned and we want only the products, which were sold.

SELECT COALESCE(pr.Color, 'No color') AS Color,COALESCE(pr.Class, 'Not assigned') AS Class, 
sum(sd.OrderQty) as Quantity,sum (sd.LineTotal) as SalesValue,sum (sd.LineTotal-sd.OrderQty*StandardCost) AS Profit,sum(sh.Freight) as shipmentCosts,sum(sd.UnitPriceDiscount ) as Discounts
FROM Production.Product pr
 join Sales.SalesOrderHeader sh
 join sales.SalesOrderDetail sd
ON sd.SalesOrderID=sh.SalesOrderID
on pr.ProductID=sd.ProductID
group by Color, Class

--analzye sales for subcategory and difference in orderdate nad shipdate
SELECT ps.Name as Subcategory ,avg(DATEDIFF(DAY,OrderDate,ShipDate) )as AvgDifference, 
sum(ss.OrderQty) as Quantity,sum (ss.LineTotal) as SalesValue,sum (ss.LineTotal-ss.OrderQty*StandardCost) AS Profit,sum(sh.Freight) as shipmentCosts,sum(ss.UnitPriceDiscount ) as Discounts

FROM Production.ProductSubcategory ps
JOIN Production.Product pp
on ps.ProductSubcategoryID=pp.ProductSubcategoryID
 JOIN Sales.SalesOrderDetail ss
on ss.ProductID=pp.ProductID
INNER JOIN Sales.SalesOrderHeader sh
on ss.SalesOrderID=sh.SalesOrderID
group by ps.Name

--Analyze sales for colors
SELECT COALESCE(pr.Color, 'No color') AS Color ,sum(sd.OrderQty) as Quantity,sum (sd.LineTotal) as SalesValue,sum (sd.LineTotal-sd.OrderQty*StandardCost) AS Profit,sum(sh.Freight) as shipmentCosts,sum(sd.UnitPriceDiscount ) as Discounts
FROM Production.Product pr
 join Sales.SalesOrderHeader sh
 join sales.SalesOrderDetail sd
ON sd.SalesOrderID=sh.SalesOrderID
on pr.ProductID=sd.ProductID
group by Color

--Analyze sales data based on the color of product and class.I have used join to eliminate null values from data sales. 
--Left join, because not all categories might have subcategories in this case they do.This query give us all combination for categories and their matching subcategories with the information on sales.

SELECT  c.Name, sc.Name,sum(sd.OrderQty) as Quantity,sum (sd.LineTotal) as SalesValue,sum (sd.LineTotal-sd.OrderQty*StandardCost) AS Profit,sum(sh.Freight) as shipmentCosts,sum(sd.UnitPriceDiscount ) as Discounts
FROM Production.Product pr
join Sales.SalesOrderHeader sh
 join sales.SalesOrderDetail sd
ON sd.SalesOrderID=sh.SalesOrderID
on pr.ProductID=sd.ProductID
 left join Production.ProductSubcategory sc
on sc.ProductSubcategoryID=pr.ProductSubcategoryID
join Production.ProductCategory c
ON sc.ProductCategoryID=c.ProductCategoryID
group by c.Name, sc.Name

--Analyze sales data based on different branches
--Sales data for a department

SELECT dp.Name ,sum(sd.OrderQty) as Quantity,sum (sd.LineTotal) as SalesValue, (sum(sd.LineTotal)-sum(sd.OrderQty*StandardCost)) AS Profit,sum(sh.Freight) as shipmentCosts,sum(sd.UnitPriceDiscount ) as Discounts
FROM Sales.SalesOrderHeader sh
join sales.SalesOrderDetail sd
ON sd.SalesOrderID=sh.SalesOrderID
join Production.Product pr
on pr.ProductID=sd.ProductID
join Sales.SalesPerson  sp
on sp.BusinessEntityID=sh.SalesPersonID
join HumanResources.EmployeeDepartmentHistory dh
on sp.BusinessEntityID=dh.BusinessEntityID
join HumanResources.Department dp
on dh.DepartmentID=dp.DepartmentID
group by dp.Name

--Analyze data for different years of orders

SELECT  Year(OrderDate) as OrderYears ,sum(sd.OrderQty) as Quantity,sum (sd.LineTotal) as SalesValue,
sum (sd.LineTotal-sd.OrderQty*StandardCost) AS Profit,sum(sh.Freight) as shipmentCosts,sum(sd.UnitPriceDiscount ) as Discounts
FROM Production.Product pr
join Sales.SalesOrderHeader sh
 join sales.SalesOrderDetail sd
ON sd.SalesOrderID=sh.SalesOrderID
on pr.ProductID=sd.ProductID
group by Year(OrderDate)
order by Year(OrderDate)Desc

--Analyze data for different months and year  of orders

SELECT  Year(OrderDate) as OrderYears ,Month(OrderDate) as OrderMonths,sum(sd.OrderQty) as Quantity,sum (sd.LineTotal) as SalesValue,sum (sd.LineTotal-sd.OrderQty*StandardCost) AS Profit,sum(sh.Freight) as shipmentCosts,sum(sd.UnitPriceDiscount ) as Discounts
FROM Production.Product pr
join Sales.SalesOrderHeader sh
 join sales.SalesOrderDetail sd
ON sd.SalesOrderID=sh.SalesOrderID
on pr.ProductID=sd.ProductID
group by Year(OrderDate), Month(OrderDate)
order by Year(OrderDate)Desc, Month(OrderDate)

--Analyze Different individual customers (names, addresses)

SELECT sc.CustomerID,pp.FirstName as FirstName, pa.AddressLine1 as AddressR,
sum(sd.OrderQty) as Quantity,sum (sd.LineTotal) as SalesValue,sum (sd.LineTotal-sd.OrderQty*StandardCost) AS Profit,sum(sh.Freight) as shipmentCosts,sum(sd.UnitPriceDiscount ) as Discounts
FROM Sales.SalesOrderHeader sh
join sales.SalesOrderDetail sd
ON sd.SalesOrderID=sh.SalesOrderID
join Production.Product pr
on pr.ProductID=sd.ProductID
join Sales.Customer sc
on sh.CustomerID=sc.CustomerID
join Person.Person pp on sc.PersonID=pp.BusinessEntityID
INNER JOIN Person.Address pa
ON pa.AddressID=sh.BillToAddressID
where PersonType = 'IN'
group by sc.CustomerID,pa.AddressLine1, pp.FirstName




