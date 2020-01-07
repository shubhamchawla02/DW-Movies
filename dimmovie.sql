SELECT tconst AS "titleId", titleType, primaryTitle, isAdult, startYear AS "broadcastYear", 
CASE
	WHEN runtimeMinutes = '\N' THEN NULL
	WHEN runtimeMinutes != '\N' THEN CAST(runtimeMinutes as INT)
END AS "displayTime", genres
INTO DIMMovie
FROM titlebasics;

SELECT * FROM DIMMovie;