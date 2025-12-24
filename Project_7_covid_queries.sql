CREATE TABLE CovidDeaths(
	iso_code VARCHAR(20),
	continent VARCHAR(20),	
	location VARCHAR(50),
	date DATE,
	population BIGINT,
	total_cases BIGINT,
	new_cases INT,
	total_deaths BIGINT,
	new_deaths INT,
	total_deaths_per_million FLOAT,
	new_deaths_per_million FLOAT,
	reproduction_rate FLOAT,
	icu_patients INT,
	hosp_patients INT,
	weekly_icu_admissions INT,
	weekly_hosp_admissions INT
);

CREATE TABLE CovidVaccinations (
	iso_code VARCHAR(20),	
	continent VARCHAR(20),
	location VARCHAR(50),
	date DATE,
	total_tests BIGINT,	
	new_tests BIGINT,
	positive_rate FLOAT,
	tests_per_case FLOAT,
	tests_units	VARCHAR(20),
	total_vaccinations BIGINT,
	people_vaccinated BIGINT,
	people_fully_vaccinated	BIGINT,
	total_boosters BIGINT,
	new_vaccinations BIGINT,
	stringency_index FLOAT,
	population_density FLOAT,
	median_age FLOAT,
	aged_65_older FLOAT,
	aged_70_older FLOAT,
	gdp_per_capita FLOAT,
	extreme_poverty FLOAT,
	cardiovasc_death_rate FLOAT,	
	diabetes_prevalence	FLOAT,
	handwashing_facilities FLOAT,
	life_expectancy	FLOAT,
	human_development_index FLOAT,	
	excess_mortality_cumulative	FLOAT,
	excess_mortality FLOAT
);

SELECT * FROM coviddeaths;
SELECT * FROM covidvaccinations;

/* Datewise likelihood of dying due to Covid-19: Total Cases vs Total Deaths in INDIA */

SELECT 
	date,
	total_cases,
	total_deaths
FROM coviddeaths
WHERE location ILIKE '%india%'

/* Total % of deaths out of entire population in INDIA */

SELECT ROUND(MAX(total_deaths)/AVG(population) * 100, 3) AS Percent_of_death
FROM coviddeaths
WHERE location ILIKE '%india%'

/* Country with highest death as a % of population */

SELECT 
	location,
	ROUND(MAX(total_deaths)/AVG(population)* 100.0, 4) AS percentage_deaths
FROM coviddeaths
WHERE total_deaths IS NOT NULL AND population IS NOT NULL
GROUP BY 1
ORDER BY percentage_deaths DESC;

/* Total % of COVID +ve Cases in INDIA */

SELECT MAX(total_cases)/AVG(population) * 100.0 AS Covid_Positive_cases
FROM coviddeaths
WHERE location ILIKE '%INDIA%';

/* Total % of COVID +ve Cases in WORLD */

SELECT location, MAX(total_cases)/AVG(population)*100.0 AS percentage_positive 
FROM coviddeaths
GROUP BY location
ORDER BY percentage_positive DESC;

/* Continent-Wise positive cases */

SELECT location, MAX(total_cases) AS total_case
FROM coviddeaths 
WHERE continent IS NULL
GROUP BY location
ORDER BY total_case DESC;

/* Continent-Wise total deaths */

SELECT location, MAX(total_deaths) AS total_deaths
FROM coviddeaths 
WHERE continent IS NULL
GROUP BY location
ORDER BY total_deaths DESC;

/* Daily newcases vs hospitalizations vs Icu_patients in India */

SELECT date, new_cases, hosp_patients, icu_patients
FROM coviddeaths
WHERE LOCATION ILIKE '%INDIA%';

/* Countrywise cases for age > 65 */

SELECT * FROM coviddeaths;
SELECT * FROM covidvaccinations;

SELECT cd.location, cd.date, cv.aged_65_older
FROM covidvaccinations AS cv
INNER JOIN coviddeaths AS cd
ON cd.iso_code=cv.iso_code AND cd.date = cv.date;

/* Countrywise Total Vaccinated persons */

SELECT cd.location AS country, MAX(cv.people_fully_vaccinated) AS fully_vaccinated
FROM covidvaccinations AS cv
INNER JOIN coviddeaths AS cd
ON cv.iso_code = cd.iso_code AND cd.date = cv.date
WHERE cd.continent IS NOT NULL 
GROUP BY country
ORDER BY fully_vaccinated DESC;