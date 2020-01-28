USE DWCinema;
--------------DIM Customer
---- AGE ?
DROP TABLE DIMCustomer
CREATE TABLE DIMCustomer(
	id [int] NOT NULL,
	gender [nvarchar] (50) NOT NULL,
	age [int],
	CONSTRAINT id_pk PRIMARY KEY (id)
	)


-------------- DIM DATE

DECLARE @StartDate DATE = '20010101',
@EndDate DATE = '20181231'
CREATE TABLE DIMDate
(
  [date]       DATE NOT NULL, 
  dateid     AS CONVERT(CHAR(10),  [date], 101) PERSISTED NOT NULL,
  [day]        AS DATEPART(DAY,      [date]),
  [month]      AS DATEPART(MONTH,    [date]),
  [year]       AS DATEPART(YEAR,     [date]),
  CONSTRAINT CompKey_ID_NAME PRIMARY KEY (date, DateID)
  );

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
	movieId [nvarchar] (40) NOT NULL,
	[titleType]  [nvarchar](20),
	[primaryTitle] [nvarchar](200) NOT NULL,
	[isAdult] [int] NOT NULL,
	rating [float] NOT NULL
)
----------FACT CAST

CREATE TABLE FFCast(
	id int NOT NULL IDENTITY(1, 1),
	personid [nvarchar] (50) NOT NULL,
	movieid [nvarchar] (50) NOT NULL,
	profession [nvarchar] (200) NOT NULL,
	primaryName [nvarchar] (100) NOT NULL
)

CREATE TABLE FFGenres(
	[movideId] [nvarchar](40),
	[genre] [nvarchar](20)
);

CREATE TABLE FTransaction(
	[id] [int] NOT NULL,
	customerId [int] NOT NULL,
	movieId [varchar](50) NOT NULL,
	studentTicketsQty [int] NOT NULL,
	adultTicketsQty [int] NOT NULL,
	totalCost [float] NOT NULL,
	dateId [char](8) NOT NULL
);
