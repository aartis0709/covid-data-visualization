Queries used for Tableau Project
*/

-- 1. 

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From death
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- Just a double check based off the data provided
-- numbers are extremely close so we will keep them - The Second includes "International"  Location


--Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where location = 'World'
----Group By date
--order by 1,2


-- 2. 

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From death
Where continent is null 
and location not in ('World', 'European Union', 'International','High income', 
'Lower middle income','Low income', 'Upper middle income' )
Group by location
order by TotalDeathCount desc


-- 3.

Select Location, Population, MAX(cast(total_cases as numeric)) as HighestInfectionCount,  
Max(cast(total_cases as numeric)/(cast (population as numeric)))*100 as PercentPopulationInfected
From death
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4.


Select Location, Population,date, MAX(cast(total_cases as numeric)) as HighestInfectionCount,  
Max((cast(total_cases as numeric)/cast(population as numeric) ))*100 as PercentPopulationInfected
From death
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc