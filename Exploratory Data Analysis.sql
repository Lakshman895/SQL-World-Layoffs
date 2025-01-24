-- DATA EXPLORATORY

SELECT *
FROM layoffs_staging_2;

-- Looking at the MAX of total_laid_off & percentage_laid_off

SELECT MAX(total_laid_off), MAX(percentage_laid_off)
FROM layoffs_staging_2;

SELECT *
FROM layoffs_staging_2
WHERE percentage_laid_off = 1
ORDER BY total_laid_off DESC;

-- Looking which companies has the number of total_laid_off

SELECT company, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company
ORDER BY 2 DESC;

-- What is min and max data the data lies between

SELECT MIN(`date`), MAX(`date`)
FROM layoffs_staging_2;

-- Looking which Industries has the number of total_laid_off
SELECT industry, SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY industry
ORDER BY 2 DESC;

-- Looking which countries has the number of total_laid_off

SELECT country, SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY country
ORDER BY 2 DESC;

-- Looking which year has the number of total_laid_off


SELECT YEAR(`date`), SUM(total_laid_off)
FROM layoffs_staging2
GROUP BY YEAR(`date`)
ORDER BY 1 DESC;

-- Looking which month has the number of total_laid_off

SELECT SUBSTRING(`date`, 1,7) AS MONTH, SUM(total_laid_off)
FROM layoffs_staging_2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY MONTH 
ORDER BY 1;

-- Creating Window Function and Creating Rolling total for the months

WITH rolling_total AS (
SELECT SUBSTRING(`date`, 1,7) AS MONTH, SUM(total_laid_off) AS total_off
FROM layoffs_staging_2
WHERE SUBSTRING(`date`, 1,7) IS NOT NULL
GROUP BY MONTH 
ORDER BY 1 ASC
)
SELECT MONTH, total_off, SUM(total_off)
OVER(ORDER BY MONTH) AS rolling_total
FROM rolling_total;

-- Looking at the company in which year does they have layoffs

SELECT company, YEAR(date), SUM(total_laid_off)
FROM layoffs_staging_2
GROUP BY company, YEAR(date)
ORDER BY 3 DESC;

-- Creating window function to rank for layoffs for the top 5 positions of the company for the years 

WITH ranking_companies (company, year, total_offs) AS(
SELECT company, YEAR(date), SUM(total_laid_off) 
FROM layoffs_staging_2
GROUP BY company, YEAR(date)
),
company_year_ranking AS(
SELECT *,
DENSE_RANK() OVER(PARTITION BY year ORDER BY total_offs DESC) AS Ranking
FROM ranking_companies
WHERE year IS NOT NULL)
SELECT *
FROM company_year_ranking
WHERE Ranking <=5
;