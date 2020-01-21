USE DWCinema

CREATE TABLE DIMMovie(
	[titleId] [nvarchar](40) NOT NULL,
	[titleType]  [nvarchar](20),
	[primaryTitle] [nvarchar](200) NOT NULL,
	[isAdult] [int] NOT NULL,
	[broadcastYear] [int],
	[displayTime] [int],
	[generes] [nvarchar](40)
)


INSERT INTO DIMMovie
SELECT tconst, titleType, primaryTitle, CAST(isAdult AS INT), CAST(startYear AS INT) AS "broadcastYear", 
CASE
	WHEN runtimeMinutes = '\N' THEN NULL
	WHEN runtimeMinutes != '\N' THEN CAST(runtimeMinutes as INT)
END AS "displayTime", genres
FROM titlebasics;

SELECT * FROM DIMMovie;

DROP TABLE DIMMovie;