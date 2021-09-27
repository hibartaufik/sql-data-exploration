-- DATA EXPLORATION

-- Show all data CovidDeaths
SELECT * 
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3, 4

-- Show all data CovidVaccinations
SELECT * 
FROM PortfolioProject.dbo.CovidVaccinations
ORDER BY 3, 4

-- Eksplorasi Data Pada Tabel CovidDeaths

-- Memilih field Location, date, total_cases, new_cases, total_deaths, population agar lebih informatif
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1, 2

-- Eksplorasi awal mula COVID-19 menimbulkan kematian
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE total_deaths IS NOT NULL
ORDER BY 1, 2

-- Eksplorasi awal mula COVID-19 menimbulkan kematian di Indonesia
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE Location = 'Indonesia' AND total_deaths IS NOT NULL
ORDER BY 1, 2

-- Presentase kematian akibat COVID-19 di Indonesia
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS PresentaseKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Indonesia'
ORDER BY 1, 2


-- Urutan presentase kematian akibat COVID-19 di Indonesia
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS PresentaseKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Indonesia'
ORDER BY PresentaseKematian DESC


-- Presentase kematian COVID-19 akhir tahun 2020 di Indonesia.
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS PresentaseKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Indonesia' AND date >= '2020-12-15 00:00:00.000'
ORDER BY 1, 2


-- Angka total kematian tiap negara
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalAngkaKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location 
ORDER BY TotalAngkaKematian DESC

-- Angka total kematiam tiap benua
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalAngkaKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY TotalAngkaKematian DESC

-- Presentase orang terinfeksi di Indonesia
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PresentaseTerinfeksi
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Indonesia'
ORDER BY 1, 2


-- Presentase orang terinfeksi di Indonesia pada akhir tahun 2020
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PresentaseTerinfeksi
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Indonesia' AND DATE >= '2020-12-15 00:00:00.000'
ORDER BY 1, 2

-- Presentase orang terinfeksi tiap negara
SELECT location, population, MAX(total_cases) AS AngkaKasusTertinggi, MAX((total_cases/population))*100 
 AS PresentasePopulasiTerinfeksi
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY Location, population
ORDER BY 1


-- Presentase infeksi tertinggi lingkup negara
SELECT location, population, MAX(total_cases) AS AngkaKasusTertinggi, MAX((total_cases/population))*100 
 AS PresentasePopulasiTerinfeksi
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY Location, population
ORDER BY PresentasePopulasiTerinfeksi DESC

-- Eksplor data berdasarkan rentang waktu/tanggal
SELECT date, SUM(new_cases), SUM(CAST(new_deaths AS INT)), 
 SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS PresentaseKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2

-- Total keseluruhan angka kasus terinfeksi, angka kematian, dan presentase kematian di dunia
SELECT SUM(new_cases) AS TotalAngkaKasus, SUM(CAST(new_deaths AS INT)) AS TotalAngkaKematian, 
 SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS PresentaseKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2


-- Eksplorasi Data Pada Tabel CovidVaccinations

-- Join tabel CovidDeaths dengan CovidVaccinations
SELECT *
FROM PortfolioProject.dbo.CovidDeaths death
JOIN PortfolioProject.dbo.CovidVaccinations vaccin
ON death.location = vaccin.location
AND death.date = vaccin.date

-- Ekplorasi angka vaksinasi
SELECT death.continent, death.location, death.date, death.population, vaccin.new_vaccinations
FROM PortfolioProject.dbo.CovidDeaths death
JOIN PortfolioProject.dbo.CovidVaccinations vaccin
	ON death.location = vaccin.location
	AND death.date = vaccin.date
WHERE death.continent IS NOT NULL
ORDER BY 2, 3

-- Angka vaksinasi di Indonesia
SELECT death.continent, death.location, death.date, death.population, vaccin.new_vaccinations
FROM PortfolioProject.dbo.CovidDeaths death
JOIN PortfolioProject.dbo.CovidVaccinations vaccin
	ON death.location = vaccin.location
	AND death.date = vaccin.date
WHERE death.continent IS NOT NULL AND death.location = 'Indonesia' AND vaccin.new_vaccinations IS NOT NULL
ORDER BY 2, 3

-- Ekplorasi vaksinasi dan angka progresnya setiap hari tiap negara
SELECT death.continent, death.location, death.date, death.population, vaccin.new_vaccinations,
 SUM(CONVERT(INT, vaccin.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) 
 AS ProgresVaksinasi
FROM PortfolioProject.dbo.CovidDeaths death
JOIN PortfolioProject.dbo.CovidVaccinations vaccin
	ON death.location = vaccin.location
	AND death.date = vaccin.date
WHERE death.continent IS NOT NULL AND death.location = 'Indonesia' AND vaccin.new_vaccinations IS NOT NULL
ORDER BY 2, 3

-- Membuat view berdasarkan eksplorasi angka vaksinasi dan progres vaksinasi
CREATE VIEW PresentaseVaksinasi AS
SELECT death.continent, death.location, death.date, death.population, vaccin.new_vaccinations,
 SUM(CONVERT(INT, vaccin.new_vaccinations)) OVER (PARTITION BY death.location ORDER BY death.location, death.date) 
 AS ProgresVaksinasi
FROM PortfolioProject.dbo.CovidDeaths death
JOIN PortfolioProject.dbo.CovidVaccinations vaccin
	ON death.location = vaccin.location
	AND death.date = vaccin.date
WHERE death.continent IS NOT NULL