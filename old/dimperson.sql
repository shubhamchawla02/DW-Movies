USE DWCinema;

CREATE TABLE DIMStaff(
	[personId] [nvarchar](40),
	[primaryName] [nvarchar](100),
	[birthYear] [int],
	[deathYear] [int],
	[primaryProfession] [nvarchar](70)
);

INSERT INTO DIMStaff
SELECT nconst,primaryName, CASE WHEN birthYear = '\N' THEN NULL ELSE CAST(birthYear AS INT) END, CASE WHEN deathYear = '\N' THEN NULL ELSE CAST(deathYear AS INT) END,primaryProfession
FROM basics

SELECT * FROM DIMStaff;