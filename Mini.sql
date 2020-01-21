--DIM Payment  INTO DimPayment 



SELECT CO.id,studentTicketsQty, adultTicketsQty,costType, CONVERT(BIGINT,Studentprice) * CONVERT(BIGINT,studentTicketsQty) AS Total_Student_Price, CONVERT(BIGINT, Adultprice) * CONVERT(BIGINT, adultTicketsQty) AS 'Total adult price'
FROM

DROP TABLE DimPayment
---
SELECT tconst,nconst,category, job, characters
FROM dbo.titleprincipals
