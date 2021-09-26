
# SQL Data Exploration

## 1. Dataset
Download dataset pada situs Our World In Data khusus untuk COVID-19, lalu menetukan rentang waktu dataset yang akan diambil

<img width=720 src=https://user-images.githubusercontent.com/74480780/134254497-cdc353f5-f27f-4769-b2e7-21e99498b860.png>

File akan ter-download dengan extensi csv, tampilkan pada excel dengan beberapa perubahan format agar tampilan dataset pada excel berupa tabel

- comma-separated shape

<img width=720 src=https://user-images.githubusercontent.com/74480780/134254840-19f0fd4a-8a2e-451c-bb1f-01601c191e76.png>

- Perubahan menjadi tampilan tabel

<img width=720 src=https://user-images.githubusercontent.com/74480780/134255525-18e1b3a8-4da6-46bf-beec-e797c34455b0.png>

## 2. Membuat Tabel Baru dari Dataset Utama

Membuat dua tabel baru dari dataset utama, yaitu mengenai data kematian COVID-19 dan data vaksinasi COVID-19

- CovidDeaths.xlsx

<img width=720 src=https://user-images.githubusercontent.com/74480780/134256471-4c43c718-a55b-4de4-aa91-8104a4f1de2a.png>

- CovidVaccinations.xlsx

<img width=720 src=https://user-images.githubusercontent.com/74480780/134256531-f835053b-60eb-4efc-9005-8901719a8027.png>

## 3. Membuat Database dan Import Dataset

Membuat Database dengan Microsoft SQL Server Management Studio

<img width=720 src=https://user-images.githubusercontent.com/74480780/134482443-05337d06-de9f-463a-89c5-38a300ddd472.png>

Import CovidDeaths.xlxs dan CovidVaccinations.xlxs ke dalam database

<img width=480 src=https://user-images.githubusercontent.com/74480780/134498212-a8732aec-cc9a-4b5d-b868-5c572cc528be.png>

## 4. Data Exploration

Eksplorasi data dengan SQL Query

### 4.1 Melihat data dari kedua tabel

```
SELECT * 
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3, 4
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134499458-87dd37ec-a373-47d8-88ce-4e0193fdbf42.png>

```
SELECT * 
FROM PortfolioProject.dbo.CovidVaccinations
ORDER BY 3, 4
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134499616-6db88524-6fd3-4d8c-9c65-661df13f2c34.png>

### 4.2 Menampilkan Data yang Akan Digunakan

Terdapat 26 field pada tabel sehingga tidak efisien jika kita menampilkan semua data termasuk data yang kurang informatif, pilih beberapa field yang dianggap penting dan lebih informatif dari field yang lainnya.

#### 4.2.1 Eksplorasi Data Pada Tabel CovidDeaths

Memilih field Location, date, total_cases, new_cases, total_deaths, population agar lebih informatif.

```
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1, 2
```

Mengurutkan berdasarkan Location dan date agar menampilkan data berdasarkan lokasi yang berisi nama negara lalu selanjutnya diurutkan berdasarkan tanggal sehingga kita lebih mudah menganalisa beberapa faktor yang berkaitan dengan rentang waktu seperti perbandingan kenaikan dan penurunan kasus tertentu.

<img width=720 src=https://user-images.githubusercontent.com/74480780/134501649-0b93c1f7-5a59-425a-b34c-8ba4c60aff55.png>

Dalam sekilas data yang kita lihat, untuk field total_deaths berisi NULL karena pandemi merebak di berbagai tempat tidak akan langsung menimbulkan kematian. 

- Eksplorasi awal mula COVID-19 menimbulkan kematian

```
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE total_deaths IS NOT NULL
ORDER BY 1, 2
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134760745-5372779d-382c-4722-8660-43ddd4a80d22.png>

Angka kematian akan muncul beberapa waktu setelah pandemi menyebar dalam suatu lokasi. Untuk Afghanistan misalnya, angka kematian baru muncul pada 23 Maret 2020. Tentu penyebaran pandemi COVID-19 dan dampak kematiannya akan berbeda pada setiap lokasi/negara, hal ini valid jika kita eksplor data dengan nama lokasi yang berbeda, Contohnya Indonesia.

```
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
WHERE Location = 'Indonesia' AND total_deaths IS NOT NULL
ORDER BY 1, 2
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134760770-5920189a-d737-4493-ba47-447dd3509960.png>

Dataset yang kita eksplor mencatat bahwa di Indonesia, pandemi baru menimbulkan kematian dimulai pada 11 Maret 2020. Dengan begitu banyaknya data yang tersedia pada tabel, kita hanya akan fokus pada kasus COVID-19 yang ada di Indonesia saja. 

- Presentase kematian akibat COVID-19

Semisal kita ingin melihat angka presentase kematian akibat COVID-19 di Indonesia.

```
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS PresentaseKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Indonesia'
ORDER BY 1, 2
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134761677-569778e0-a9fd-4631-9701-8f58e98595e1.png>

Hal yang dapat kita ketahui bahwa angka presentase kematian di Indonesia tidak ada yang melampaui angka 10 persen. Untuk presentase kematian terbesar berada di sekitar angka 9 persen.

```
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS PresentaseKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Indonesia'
ORDER BY PresentaseKematian DESC
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134763239-bfc9cff4-b3e2-4d82-ae47-c57d4e468a55.png>

Namun angka presentase tersebut tidak dapat selalu menjadi acuan, untuk angka presentase kematian yang besar cenderung ada di bulan-bulan awal karena angka total_cases dengan total_deaths belum memiliki perbandingan jauh sehingga pada bulan-bulan awal presentase kematian cenderung besar seperti terlihat pada hasil query di atas.

Kita juga dapat melihat presentase kematian akibat COVID-19 pada akhir tahun 2020 di Indonesia.

```
SELECT location, date, population, total_cases, total_deaths, (total_deaths/total_cases)*100 AS PresentaseKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Indonesia' AND date >= '2020-12-15 00:00:00.000'
ORDER BY 1, 2
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134762922-f6bad456-f8c8-4daf-90ae-693979641457.png>

Dalam skala global, angka total kematian untuk Indonesia dapat kita ketahui dengan membandingkannya dengan negara-negara lain.

```
SELECT location, MAX(CAST(total_deaths AS INT)) AS TotalAngkaKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location 
ORDER BY TotalAngkaKematian DESC
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134777519-de94f2e1-8d6b-49c9-8722-2f5760fd4a91.png>

Seperti yang terlihat pada hasil query di atas, Indonesia menempati peringkat ke 7 dengan total angka kematian sebesar 140.634 (per tanggal 22 September 2021). Jika kita tarik lebih luas, kita dapat melihat benua mana saja yang memiliki total angka kematian terbanyak.

```
SELECT continent, MAX(CAST(total_deaths AS INT)) AS TotalAngkaKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY continent 
ORDER BY TotalAngkaKematian DESC
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134777747-91026afe-3fce-4f6a-a9bd-0a2b61e3adfa.png>

- Presentase orang terinfeksi dalam populasi suatu negara

Selain melihat angka dan presentase yang berkaitan dengan kematian, kita akan melihat angka total_cases per populasi untuk melihat seberapa persen orang-orang yang terinfeksi berdasarkan populasi lokasi terkait.

```
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PresentaseTerinfeksi
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Indonesia'
ORDER BY 1, 2
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134763552-82d668a8-a928-4940-a1a0-6db776246e5c.png>

Jika kita lihat presentase pada akhir tahun 2020.

```
SELECT location, date, population, total_cases, (total_cases/population)*100 AS PresentaseTerinfeksi
FROM PortfolioProject.dbo.CovidDeaths
WHERE location = 'Indonesia' AND DATE >= '2020-12-15 00:00:00.000'
ORDER BY 1, 2
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134763646-9f2d5b1a-7575-431f-9e6b-4e88bd6a3d93.png>

Selanjutnya, kita akan menampilkan angka presentase terinfeksi di berbagai lokasi/negara yang berbeda sehingga kita dapat mengetahui rata-rata angka terinfeksi per lokasi dan membandingkannya dengan Indonesia.

```
SELECT location, population, MAX(total_cases) AS AngkaKasusTertinggi, MAX((total_cases/population))*100 
 AS PresentasePopulasiTerinfeksi
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY Location, population
ORDER BY 1
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134764374-ddfa8ad2-d7a8-49fd-bf11-fe882d597833.png>

Jika kita urutkan berdasarkan presentase infeksi tertinggi

```
SELECT location, population, MAX(total_cases) AS AngkaKasusTertinggi, MAX((total_cases/population))*100 
 AS PresentasePopulasiTerinfeksi
FROM PortfolioProject.dbo.CovidDeaths
GROUP BY Location, population
ORDER BY PresentasePopulasiTerinfeksi DESC
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134764475-e93a8b29-8087-470c-8790-d34ab42a9f10.png>

Untuk Indonesia sendiri menempati urutan ke 121 dengan angka presentase terinfeksi sekitar 1,517 persen

<img width=720 src=https://user-images.githubusercontent.com/74480780/134764527-99e6c5a7-285a-4e03-a11d-da287b0ac619.png>

- Eksplor data berdasarkan rentang waktu/tanggal

```
SELECT date, SUM(new_cases), SUM(CAST(new_deaths AS INT)), 
 SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS PresentaseKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1, 2
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134778353-96737887-03a1-41c8-a9d5-041f7df2f17d.png>

Hasil query di atas menunjukkan jumlah setiap angka kasus baru, angka kematian baru, dan presentase kematian per hari dari seluruh dunia. Tentu akan banyak NULL pada awal bulan, seperti yang sudah dibahas sebelumnya. Tetapi saat kita scroll ke bawah di tanggal tertentu data point sudah tidak NULL lagi.

<img width=720 src=https://user-images.githubusercontent.com/74480780/134778365-5872dcb8-a91c-4522-b270-b2f32fa62d68.png>

Setiap kasus di seluruh dunia dikelompokkan dan dijumlahkan berdasarkan tanggal, sampai rentang tanggal 20 September 2021. Dan jika kita ingin menjumlahkan seluruh angka tersebut dari seluruh dunia maka akan didapat angka yang sangat besar.

```
SELECT SUM(new_cases) AS TotalAngkaKasus, SUM(CAST(new_deaths AS INT)) AS TotalAngkaKematian, 
 SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS PresentaseKematian
FROM PortfolioProject.dbo.CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2
```

<img width=720 src=https://user-images.githubusercontent.com/74480780/134778501-ad4add20-dc3c-4e3f-800c-02e624686951.png>

#### 4.2.2 Eksplorasi Data Pada Tabel CovidVaccinations

