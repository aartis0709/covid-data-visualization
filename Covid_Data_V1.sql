--select location, date, total_cases, new_cases, total_deaths, population from death
--order by 1,2;

--total cases vs total deaths

-- select location, date, total_cases, total_deaths, (total_deaths / total_cases)* 100 as deathpercent from death
-- where location = '%states%'
-- order by 1,2;

--select location, date, total_cases, population,(cast(total_cases as numeric) / cast(population as numeric))*100.0 as infection_percentage from death
--where location='United States';

-- looking at contries with highest infection rate


select location, max(total_cases) as highestpercentagecount, population,max(cast(total_cases as numeric) / cast(population as numeric))*100.0 as infection_percentage from death
group by location, population
order by infection_percentage desc;



--by location

select location, max(total_deaths) as totaldeath_count from death
group by location
order by totaldeath_count;
 
 -- by continent

select continent, max(total_deaths) as totaldeath_count from death
where continent is not null
group by continent
order by totaldeath_count desc;



-- global numbers

select location, date, total_cases, total_deaths, (cast(total_deaths as numeric) / cast(total_cases as numeric))*100.00 as death_percentage from death
where continent is not null
order by 1,2;

-- group by date total cases, deaths and percentage for globe 

select date, sum(cast(new_cases as numeric)) as total_cases, sum(cast(new_deaths as numeric)) as total_deaths, sum(cast(new_deaths as numeric))/ sum(cast(new_cases as numeric))*100.00 as death_percentage 
from death
where continent is not null
group by date
order by 1,2;

--- total death percent for world

select sum(cast(new_cases as numeric)) as total_cases, sum(cast(new_deaths as numeric)) as total_deaths, sum(cast(new_deaths as numeric))/ sum(cast(new_cases as numeric))*100.00 as death_percentage 
from death
where continent is not null
order by 1,2;

--Joinning 2 tables


select * from death d
join vaccine v
on d.location = v.location
and d.date = v.date


-- looking at total population vs vaccination


select d.continent, d.location, d.date, d.population, v.new_vaccinations from death d
join vaccine v
on d.location = v.location
and d.date = v.date
where d.continent is not null
order by 2,3;



-- rolling count on vaccination


select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) as rolling_people_vaccinated,
---(rolling_people_vaccinated/population)* 100.00
from death d
join vaccine v
on d.location = v.location
and d.date = v.date
where d.continent is not null
order by 2,3;

--Using CTE
with popvsvac (continent, location, date, population, new_vaccinations, rolling_people_vaccinated)
as 
(
select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) 
as rolling_people_vaccinated
---(rolling_people_vaccinated/population)* 100.00
From death d
join vaccine v
on d.location = v.location
and d.date = v.date
where d.continent is not null)
select *, (cast(rolling_people_vaccinated as numeric)/ cast(population as numeric))*100  
from popvsvac


--Temp Table
drop table if exists percentpop
create table percentpop
(
continent varchar,
location varchar,
date date,
population numeric,
new_vaccinations numeric,
rolling_people_vaccinated numeric
)

insert into percentpop

select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) 
as rolling_people_vaccinated
---(rolling_people_vaccinated/population)* 100.00
From death d
join vaccine v
on d.location = v.location
and d.date = v.date
--where d.continent is not null

select *, (rolling_people_vaccinated/population)* 100.00
from percentpop;



--Create view to store data for visualization
create view percentpopview as 

select d.continent, d.location, d.date, d.population, v.new_vaccinations, 
sum(v.new_vaccinations) over (partition by d.location order by d.location, d.date) 
as rolling_people_vaccinated
---(rolling_people_vaccinated/population)* 100.00
From death d
join vaccine v
on d.location = v.location
and d.date = v.date
where d.continent is not null
--order by 2,3