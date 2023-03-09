select * from dbo.CovidDeaths
Where continent is NOT NULL
Order by 3,4
--Select * from dbo.CovidVaccinations
--Order by 3,4

Select location, date, total_cases, new_cases, total_deaths, population
From CovidDeaths
Where continent is NOT NULL
Order by 1,2

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From CovidDeaths
Where location like '%states%'and continent is NOT NULL
Order by 1,2

Select location, date, total_cases, population, (total_cases/population)*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Where continent is NOT NULL
Order by 1,2

Select location, Max(total_cases) as HighestInfectionCount, population, Max((total_cases/population))*100 as PercentPopulationInfected
From CovidDeaths
--Where location like '%states%'
Where continent is NOT NULL
Group by location, population
Order by PercentPopulationInfected desc

Select location, Max(cast (total_deaths as int)) as TotalDeathCount 
From CovidDeaths
--Where location like '%states%'
Where continent is NOT NULL
Group by location 
Order By TotalDeathCount desc

Select continent, Max(cast (total_deaths as int)) as TotalDeathCount 
From CovidDeaths
--Where location like '%states%'
Where continent is not NULL
Group by continent 
Order By TotalDeathCount desc

Select continent, Max(cast (total_deaths as int)) as TotalDeathCount 
From CovidDeaths
--Where location like '%states%'
Where continent is not NULL
Group by continent 
Order By TotalDeathCount desc

Select Sum(New_Cases) as total_cases, Sum(cast(new_deaths as int)) as total_deaths, SUM(cast(new_deaths as int))/ SUM(New_Cases)*100 as Deathpercentage
From CovidDeaths
--Where location like '%states%'
Where continent is NOT NULL
--Group by date
Order by 1,2

With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.DATE) as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/population)*100
from CovidDeaths dea
Join CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3 
)
Select *, (RollingPeopleVaccinated/population)*100 from popvsvac

Create View PercentPopulationVaccinated as 
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
 SUM(CONVERT(int, vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.DATE) as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/population)*100
from CovidDeaths dea
Join CovidVaccinations vac
	ON dea.location = vac.location
	and dea.date = vac.date
Where dea.continent is not null
--order by 2,3
