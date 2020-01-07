--DIM Payment 

SELECT CO.id,studentTicketsQty, adultTicketsQty,costType, CAST(Studentprice AS int)*CAST(studentTicketsQty AS int) AS Total_Student_Price, CAST(Adultprice AS int) * CAST(adultTicketsQty AS int) AS 'Total adult price'
INTO DimPayment
FROM  [dbo].[costs] CO JOIN [dbo].[customer] CU ON CO.id = CU.id 
JOIN  [dbo].[transactions] TR ON CU.id= TR.id
JOIN [dbo].[principals] P ON TR.adultTicketsQty=P.ordering
JOIN[dbo].[name.basics] NB ON NB.nconst=P.nconst
JOIN [dbo].[title.akas] AK ON P.tconst = AK.titleId
JOIN [dbo].[title.ratings] R ON AK.titleId= R.tconst

---
SELECT tconst,nconst,category, job, characters
INTO DIMresponsibilitymatrix
FROM dbo.principals






