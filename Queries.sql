SELECT id, gender, DATEDIFF(yy,birthDate,getDate()) AS "Age"
FROM dbo.customer;

SELECT MIN("date") FROM transactions;
SELECT MAX("date") FROM transactions;


SELECT TB.tconst, titleType, primaryTitle, CAST(isAdult AS smallint) AS "isAdult",averageRating
FROM [titlebasics] TB JOIN [dbo].[titleratings] TR ON TR.tconst=TB.tconst ;


SELECT TP.nconst AS "personId", tconst as "movieID", primaryName, category as "profession"
FROM [dbo].[titleprincipals] TP JOIN [dbo].[basics] TB
ON TP.nconst= TB.nconst