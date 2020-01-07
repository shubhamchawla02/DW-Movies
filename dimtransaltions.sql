SELECT titleId,title,region
INTO DimTransaltions
FROM akas WHERE region != '\N';