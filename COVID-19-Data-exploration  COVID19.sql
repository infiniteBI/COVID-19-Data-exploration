/*
Covid 19 Data Exploration 
Data was divided en 2 tables, covidDeaths and CovidVaccinations

*/

--View of CovidDeaths table
select *
from `Covid19.CovidDeaths`

--View of CovidVaccinations table
select *
from `Covid19.CovidVaccinations`


-- View of the columns use in our analysis in the covidDeaths table
select continent, location, date, population, total_cases, total_deaths
from `Covid19.CovidDeaths`

-- View of the columns use in our analysis in the CovidVaccinations table
select continent, location, date, new_tests, total_tests, total_vaccinations
from `Covid19.CovidVaccinations`


--view of total cases reported by population
select location, population, max(total_cases) as TotalCasesReported, ((max(total_cases)/population)*100) as CasesByPopPercent
from `Covid19.CovidDeaths`
where continent is not null 
group by location, population
order by CasesByPopPercent desc

--view of total death reported by population
select location, population, max(total_deaths) as TotalDeathReported, (max(total_deaths)/population)*100 as DeathByPopPercent
from `Covid19.CovidDeaths`
where continent is not null 
group by location, population
order by DeathByPopPercent desc

--Comparing deaths reported by total cases report
select location, max(total_cases) as TotalCasesReported,  
max(total_deaths) as TotalDeathReported, (max(total_deaths)/max(total_cases))*100 as DeathByCasePercent
from `Covid19.CovidDeaths`
where continent is not null 
group by location, population
order by TotalDeathReported desc

--view total cases, total death, total test and total vaccinated

select 
d.location, max(d.total_cases) as TotalCasesReported,
max(d.total_deaths) as TotalDeathReported,
max(v.total_tests) as TotalTestReported,
max(v.total_vaccinations) as TotalVaccinationsReported
from
`Covid19.CovidDeaths` d join `Covid19.CovidVaccinations` v 
on d.location = v.location and d.date = v.date 
where d.continent is not null
group by d.location
order by 2 desc
 
-- Comparing total vaccinations and test by population

select 
d.location, d.population,
(max(v.total_tests)/d.population)*100 as TotalTestPercent,
(max(v.total_vaccinations)/d.population)*100 as TotalVaccinationsPercent
from
`Covid19.CovidDeaths` d join `Covid19.CovidVaccinations` v 
on d.location = v.location and d.date = v.date 
where d.continent is not null 
group by d.location, d.population
order by d.location

/*
Create a new table with the columns from both table.
Join the interested columns from 2 tables togheter to create a new table to work with
*/

CREATE table Covid19.NewTable
(
Continent string ,
Location string ,
Date datetime,
Population numeric,
Total_cases numeric,
Total_deaths numeric,
Total_tests numeric,
Total_vaccinations numeric
)


insert into NewTable
select d.continent, d.location, d.date, d.population, d.total_cases, d.total_deaths,
v.new_tests, v.total_tests, v.total_vaccinations
from
`Covid19.CovidDeaths` d join `Covid19.CovidVaccinations` v
on d.location = v.location and d.date = v.date 

--Create view to store data for later visualizations

CREATE view Covid19.total_by_category as 
select d.continent, d.location, d.date, d.population,
max(d.total_cases) as TotalCasesReported,
max(d.total_deaths) as TotalDeathReported,
max(v.total_tests) as TotalTestReported,
max(v.total_vaccinations) as TotalVaccinationsReported
from
`Covid19.CovidDeaths` d join `Covid19.CovidVaccinations` v
on d.location = v.location and d.date = v.date 
where d.continent is not null 
group by d.continent, d.location, d.date, d.population



