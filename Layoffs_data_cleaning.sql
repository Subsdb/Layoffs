-- Data Cleaning project

select * from layoffs;


-- 1. Remove Duplicates
-- 2. Standardize Data
-- 3. Deal with NULL values
-- 4. Remove unneccesary columns


-- Create a duplicate database of the raw database
create table layoffs_staging as 
select * from layoffs;

select * from layoffs_staging;

#------------------------------------------ 1. Remove Duplicates----------------------------------------------------------------------------

with duplicates_cte as
(
select *,
row_number() over (
partition by company , industry, total_laid_off, percentage_laid_off, `date`, stage,country,funds_raised_millions) as row_num
from layoffs_staging 
)
select * from duplicates_cte
where row_num > 1;


#--Create another duplicate table
CREATE TABLE `layoffs_staging2` (
  `company` text,
  `location` text,
  `industry` text,
  `total_laid_off` int DEFAULT NULL,
  `percentage_laid_off` text,
  `date` text,
  `stage` text,
  `country` text,
  `funds_raised_millions` int DEFAULT NULL,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


insert into layoffs_staging2
select *,
row_number() over(
partition by company , industry, total_laid_off, percentage_laid_off, `date`, stage,country,funds_raised_millions) as row_num
from layoffs_staging;


select * from layoffs_staging2;

SET SQL_SAFE_UPDATES = 0;


# removing duplicates 

delete from layoffs_staging2
where row_num > 1;

select * from layoffs_staging2
where row_num > 1;


#---------------------------------------------------------------2. Standardizing Data----------------------------------------------------------------------------

#removing lead and trailing blanks from the column company
select company , trim(company)
from layoffs_staging2;

update layoffs_staging2
set company = trim(company);


## Modified the column industry and named the industry uniformly
select distinct industry from layoffs_staging2
order by 1;

update layoffs_staging2
set industry = "Crypto"
where industry like "Crypto%";

select * from layoffs_staging2
where industry = "Crypto";

## Modified the column country and made the column uniform
select distinct country from layoffs_staging2 
order by country;

select * from layoffs_staging2 
where Country like "United States%";

update layoffs_staging2
set country = "United States" where country = "United States.";


## Made the Date column to have correct data type and correct format
select date from layoffs_staging2;

select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging2;

update layoffs_staging2
set date = str_to_date(`date` , '%m/%d/%Y');

alter table layoffs_staging2
modify column `date` date;



## Populating the industry column
select * from layoffs_staging2
where industry is null 
or industry = '';

select * from layoffs_staging2
where company = "Bally's Interactive";

update layoffs_staging2
set industry = Null
where industry = '';


select t1.industry, t2.industry
from layoffs_staging2 as t1
join layoffs_staging2 as t2
on t1.company = t2.company
where (t1.industry is null or t1.industry = '')
and t2.industry is not null;

update layoffs_staging2 as t1
join layoffs_staging2 as t2
on t1.company = t2.company
set t1.industry=t2.industry
where t1.industry is null 
and t2.industry is not null;

# Delete the records where laid off and %laid off column are null
delete from layoffs_staging2
where total_laid_off is null 
and percentage_laid_off is null;

# drop the unwanted column row_num
alter table layoffs_staging2
drop column row_num;

select * from layoffs_staging2;