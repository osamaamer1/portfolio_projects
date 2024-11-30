select *
from CovidDeaths
where continent is not null
order by 3,4

--select *
--from CovidVaccinations
--order by 3,4

-- data will using
select location, date,total_cases,new_cases,total_deaths,population
from CovidDeaths
where continent is not null
order by 1,2

-- total cases vs  total death 
-- shows Possibility of dying if you get covid in your country 
select location, date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Deathpercantg
from CovidDeaths
where location ='Egypt' and  continent is not null

order by 1,2

--total cases vs population
--show what percantage of population got covid
select location, date,population,total_cases,(total_cases/population)*100 as Populationpercantg
from CovidDeaths
where continent is not null
--where location ='Egypt'
order by 1,2

-- conttries that have highest infection rate compared to population

select location,population,max(total_cases)as HighinFectionCount,max((total_cases/population))*100 as
PercentPopulationInfaction
from CovidDeaths
--where location ='Egypt'
where continent is not null
group by location,population
order by 4 desc

-- showing the countries with highest death count per population 

select location,max(cast(total_deaths as int))as totaldeathCount
from CovidDeaths
--where location ='Egypt'
where continent is not null
group by location
order by totaldeathCount desc

-- Break down by continent



--showing the continent with highest death count per population
select continent,max(cast(total_deaths as int))as totaldeathCount
from CovidDeaths
--where location ='Egypt'
where continent is not null
group by continent
order by totaldeathCount desc


--Global Numbers



--showing the continent with highest death count per population
select sum(new_cases) as totalCases,sum(cast(new_deaths as int))as totalDeath , sum(cast(new_deaths as int))/sum(new_cases)* 100
as DeathPercent
from CovidDeaths
--where location ='Egypt'
where continent is not null
--group by date
order by 1,2 


-- looking at total vaccination vs population

select dea.continent,dea.location,dea.date,population ,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)
from CovidDeaths as dea
join CovidVaccinations vac
    on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null
order by 2,3


-- Use CtE for RollingPeopleVaccinated

With Pop_Vs_Vac(continent ,location,Date,population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,population ,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)
from CovidDeaths as dea
join CovidVaccinations vac
    on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select*,(RollingPeopleVaccinated/population)*100
from Pop_Vs_Vac



--Temp Table
drop table if exists #percentPopulationVacc
create table #percentPopulationVacc
(
continent varchar(255),
location varchar(255),
date datetime,
population numeric,
new_vaccinations numeric
,RollingPeopleVaccinated numeric
)
insert into #percentPopulationVacc
select dea.continent,dea.location,dea.date,population ,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)
from CovidDeaths as dea
join CovidVaccinations vac
    on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select*,(RollingPeopleVaccinated/population)*100
from #percentPopulationVacc


--creating view to store data for visualization 

create view percentPopulationVacc as 
select dea.continent,dea.location,dea.date,population ,vac.new_vaccinations
,sum(convert(int,vac.new_vaccinations)) over(partition by dea.location order by dea.location,dea.date)
as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)
from CovidDeaths as dea
join CovidVaccinations vac
    on dea.location = vac.location
	and dea.date=vac.date
where dea.continent is not null
--order by 2,3

select *
from percentPopulationVacc


