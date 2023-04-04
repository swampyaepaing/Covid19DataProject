/*
Queries Tableau Project , the data extracted from above 4 queries are used for visualization with Tableau
*/



-- 1. extracing Total Cases , Total Deaths and Death Percentage of the world population

Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From DataPresentation..covid19_death
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2


-- 2. Extracting Total Death Count on comparing continents

-- We take these out as they are not inluded in the above queries and want to stay consistent
-- European Union is part of Europe

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From DataPresentation..covid19_death
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International', 'High income', 'Upper middle income', 'Lower middle income', 'Low income')
Group by location
order by TotalDeathCount desc


-- 3. Extracting Highest  infection count per country and infection rate by countries

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From DataPresentation..covid19_death
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc


-- 4. Used above query modified by Getting the data based data on each location for comparting each country by a time period


Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From DataPresentation..covid19_death
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc


-- Played around with queries 

-- 1.

Select death.continent, death.location, death.date, death.population
, MAX(vaccination.total_vaccinations) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From DataPresentation..covid19_death death
Join DataPresentation..covid19_Vaccination vaccination
	On death.location = vaccination.location
	and death.date = vaccination.date
where death.continent is not null 
group by death.continent, death.location, death.date, death.population
order by 1,2,3




-- 2.
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/SUM(New_Cases)*100 as DeathPercentage
From DataPresentation..covid19_death
--Where location like '%states%'
where continent is not null 
--Group By date
order by 1,2

-- 3

Select location, SUM(cast(new_deaths as int)) as TotalDeathCount
From DataPresentation..covid19_death
--Where location like '%states%'
Where continent is null 
and location not in ('World', 'European Union', 'International',  'High income', 'Upper middle income', 'Lower middle income', 'Low income' )
Group by location
order by TotalDeathCount desc



-- 4.

Select Location, Population, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From DataPresentation..covid19_death
--Where location like '%states%'
Group by Location, Population
order by PercentPopulationInfected desc



-- 5.

--Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
--From PortfolioProject..CovidDeaths
----Where location like '%states%'
--where continent is not null 
--order by 1,2

-- took the above query and added population

Select Location, date, population, total_cases, total_deaths
From DataPresentation..covid19_death
--Where location like '%states%'
where continent is not null 
order by 1,2;


-- 6. Vaccination compared to population


With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From DataPresentation..covid19_death dea
Join DataPresentation..covid19_Vaccination vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 
--order by 2,3
)
Select *, (RollingPeopleVaccinated/Population)*100 as PercentPeopleVaccinated
From PopvsVac


-- 7. 

Select Location, Population,date, MAX(total_cases) as HighestInfectionCount,  Max((total_cases/population))*100 as PercentPopulationInfected
From DataPresentation..covid19_death
--Where location like '%states%'
Group by Location, Population, date
order by PercentPopulationInfected desc