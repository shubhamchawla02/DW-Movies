--------------DIM Customer
---- AGE ?

CREATE TABLE DIMCustomer(
	id [nvarchar] (50) NOT NULL,
	gender [nvarchar] (50) NOT NULL
	)


INSERT INTO DIMCustomer
SELECT id, gender 
FROM dbo.customer




-------------- DIM DATE

DECLARE @StartDate DATE = '20100101',
@EndDate DATE = '20201231'
CREATE TABLE DIMDate
(
  [date]       DATE NOT NULL, 
  dateid     AS CONVERT(CHAR(8), [date], 112) PERSISTED NOT NULL,
  [day]        AS DATEPART(DAY,      [date]),
  [month]      AS DATEPART(MONTH,    [date]),
  [year]       AS DATEPART(YEAR,     [date]),
  Style101     AS CONVERT(CHAR(10),  [date], 101),
  CONSTRAINT CompKey_ID_NAME PRIMARY KEY (date, DateID));

INSERT DIMDate
SELECT d
FROM
(
  SELECT d = DATEADD(DAY, rn - 1, @StartDate)
  FROM 
  (
    SELECT TOP (DATEDIFF(DAY, @StartDate, @EndDate)) 
      rn = ROW_NUMBER() OVER (ORDER BY s1.[object_id])
    FROM sys.all_objects AS s1
    CROSS JOIN sys.all_objects AS s2
    ORDER BY s1.[object_id]
  ) AS x
) AS y;

-----------------DIM MOVIE

CREATE TABLE DIMMovie(
	movieid [nvarchar] (40) NOT NULL,
	[titleType]  [nvarchar](20),
	[primaryTitle] [nvarchar](200) NOT NULL,
	[isAdult] [int] NOT NULL,
	rating [float] NOT NULL
)


INSERT INTO DIMMovie
SELECT TB.tconst, titleType, primaryTitle, CAST(isAdult AS INT),averageRating
FROM [title.basics] TB JOIN [dbo].[title.ratings] TR ON TR.tconst=TB.tconst 


----------FACT CAST
-- Person id ?
CREATE TABLE FCast(
	id [nvarchar] (40) NOT NULL,
	movieid [nvarchar] (40) NOT NULL,
	category [nvarchar] (200) NOT NULL,
	primaryName [nvarchar] (100) NOT NULL
)

SELECT TP.nconst, tconst, category,primaryName 
FROM [dbo].[principals] TP JOIN [dbo].[name.basics] TB
ON TP.nconst= TB.nconst

------- Fact transaction 


SELECT customerId,movieId,studentTicketsQty,adultTicketsQty,dateid
FROM dbo.transactions T JOIN dbo.DIMDate D
