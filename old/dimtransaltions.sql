USE Cinema;

CREATE TABLE DIMTranslations(
	[titleId] [nvarchar](40),
	[title] [nvarchar](200),
	[region] [nvarchar](10)
);

INSERT INTO DIMTranslations
SELECT titleId,title,region
FROM dbo.akas WHERE region != '\N';
