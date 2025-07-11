#### EXPLORATORY DATA ANALYSIS

Select * from layoffs_staging2;

## Which company had faced the most no. of layoff
select * from layoffs_staging2
where percentage_laid_off = 1
order by total_laid_off desc;

select company , sum(total_laid_off) as total_laid_off
from layoffs_staging2
group by company , total_laid_off
order by 2 desc;

select min(`date`) , max(`date`)
from layoffs_staging2;

select industry , sum(total_laid_off) as total_laid_off
from layoffs_staging2
group by industry
order by 2 desc;

select country , sum(total_laid_off) as total_laid_off
from layoffs_staging2
group by country
order by 2 desc;

with cte as
(
select `date` , sum(total_laid_off) as total_laid_off
from layoffs_staging2
group by `date`
order by 1 desc
)
select  max(total_laid_off)
from cte;

select year(`date`) , sum(total_laid_off) as total_laid_off
from layoffs_staging2
group by year(`date`)
order by 1 desc;

select stage , sum(total_laid_off) as total_laid_off
from layoffs_staging2
group by stage
order by 2 desc;


select `date` from layoffs_staging2;

select substr(`date` ,6,2) as month from layoffs_staging2;


with cte as 
(
select substr(`date` ,1,7) as `month` , sum(total_laid_off)  as total_laid_off
from layoffs_staging2
where substr(`date` ,1,7) is not null
group by `month`
order by 1
)
select `month`, total_laid_off, 
sum(total_laid_off) over(order by `month`) as Rolling_Total
from cte;


select company , year(`date`) , sum(total_laid_off)  as total_laid_off
from layoffs_staging2
group by company , year(`date`)
order by 3 desc