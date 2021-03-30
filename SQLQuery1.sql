1. SELECT COUNT(SalesOrderID) AS 'Amount of orders', SUM( SubTotal) AS 'Volume'
   FROM Sales.SalesOrderHeader

2. SELECT SalesOrderID, DATEDIFF(day, OrderDate, ShipDate) as "Number of days"
   FROM Sales.SalesOrderHeader
   GROUP BY SalesOrderID, OrderDate, ShipDate

3. SELECT COUNT(SalesOrderID) AS 'NumberOfOrders', SUM(SubTotal) AS Volume, YEAR(OrderDate) as Year
   FROM Sales.SalesOrderHeader
   GROUP BY YEAR(OrderDate)

4. USE AdventureWorks2017;
   SELECT   TotalProfit = '$' + convert(VARCHAR,convert(MONEY,
                  SUM(OrderQty * (UnitPrice * (1.0 - UnitPriceDiscount)) 
                  - StandardCost)))
         FROM     Sales.SalesOrderHeader AS SOH 
         INNER JOIN Sales.SalesOrderDetail AS SOD 
           ON SOD.SalesOrderID = SOH.SalesOrderID 
         INNER JOIN Production.Product P 
           ON P.ProductID = SOD.ProductID 

        GO

5. USE AdventureWorks2017;
   SELECT   [Year] = YEAR(OrderDate), 
         SoldQty = left(convert(VARCHAR,convert(MONEY, SUM(OrderQty)), 1), -3 +
                  len (convert(VARCHAR,convert(MONEY, SUM(OrderQty)), 1))), 
         SalesProfit = '$' + convert(VARCHAR,convert(MONEY,
                  SUM(OrderQty * UnitPrice * (1.0 - UnitPriceDiscount))), 1), 
         TotalProfit = '$' + convert(VARCHAR,convert(MONEY,
                  SUM(OrderQty * (UnitPrice * (1.0 - UnitPriceDiscount)) 
                  - StandardCost)),  1) 
   FROM     Sales.SalesOrderHeader AS SOH 
         INNER JOIN Sales.SalesOrderDetail AS SOD 
           ON SOD.SalesOrderID = SOH.SalesOrderID 
         INNER JOIN Production.Product P 
            ON P.ProductID = SOD.ProductID 
   GROUP BY YEAR(OrderDate) 
   ORDER BY [Year]; 
   GO

6. WITH A AS(

  SELECT CustomerID, COUNT(SalesOrderID) as 'Numer of orders', SUM(SubTotal) as summ
  FROM Sales.SalesOrderHeader
  GROUP BY CustomerID
)

  SELECT TOP (10) * FROM A
  order by summ DESC

7.  WITH A AS(

   SELECT CustomerID, COUNT(SalesOrderID) as 'SalesAmount'
   FROM Sales.SalesOrderHeader
   GROUP BY CustomerID
)

  SELECT TOP (10) * FROM A
  order by SalesAmount DESC






