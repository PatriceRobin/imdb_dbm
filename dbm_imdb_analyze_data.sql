#imdb databank
use imdb;

SELECT 
    *
FROM
    movies m
        LEFT JOIN
    budget AS b ON b.movie = m.name AND m.year = b.year
WHERE
    b.movie IS NOT NULL;

SELECT 
    name, year, COUNT(*)
FROM
    movies
GROUP BY name , year
HAVING COUNT(*) > 1;

SELECT 
    COUNT(*)
FROM
    (SELECT 
        name, year, COUNT(*)
    FROM
        movies
    GROUP BY name , year
    HAVING COUNT(*) > 1) x;
