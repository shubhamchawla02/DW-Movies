WITH costPerMonth (tmonth, title, totalCost) AS ( 
SELECT dd.month, dm.primaryTitle, SUM(totalCost) AS "totalcost" FROM 
FTransaction t INNER JOIN DIMMovie dm ON t.movieId = dm.movieId
INNER JOIN DIMDate dd ON dd.Style101 = t.dateId
GROUP BY dd.month, dm.primaryTitle
) SELECT cpm.tmonth, title, totalCost
FROM costPerMonth cpm
INNER JOIN (SELECT tmonth, MAX(totalcost) AS "cost" FROM costPerMonth GROUP BY tmonth) a ON a.tmonth = cpm.tmonth AND a.cost = cpm.totalCost;
