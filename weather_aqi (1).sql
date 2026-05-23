CREATE TABLE aqi(
     Date_IST VARCHAR(50),
	 Time_IST TIME,
	 Location_delhi VARCHAR(50),
	 Lat NUMERIC(7,4),
	 Lon NUMERIC(7,4),
	 Temp_c NUMERIC(4,1),
	 Humidity INT,
	 Pressure_mb NUMERIC(5,1),
	 Windspeed_kph NUMERIC(4,1),
	 Condition_text TEXT,
	 Description VARCHAR(50),
	 AQI_index INT,
	 Pm2_5 NUMERIC(5,1),
	 Pm_10 NUMERIC(6,1),
	 Co INT,
	 No2 NUMERIC(5,1)

);

SELECT * FROM aqi

COPY aqi(Date_IST,Time_IST,Location_delhi,Lat,Lon,Temp_c,Humidity,Pressure_mb,
Windspeed_kph,Condition_text,Description,AQI_index,Pm2_5,Pm_10,Co,No2)
FROM 'C:\Program Files\PostgreSQL\17\data\delhi-weather-aqi-2025.csv'
CSV HEADER;

SELECT * FROM aqi


-- --- START API &BUSINESS QUERY -----------

-- 1.Average AQI (Overall Air Quality)

SELECT AVG(AQI_index) AS Avg_AQI
FROM aqi;

-- 2. % of Time AQI is “Unhealthy”

SELECT
   COUNT (CASE WHEN AQI_index > 150 THEN 1 END) * 100.0/COUNT(*)
   AS Unhealthy_AQ
   FROM aqi;

-- 3. Average PM2.5 & PM10 Levels

SELECT
  AVG(Pm2_5) AS Avg_Pm2_5
  FROM aqi;

SELECT
  AVG(Pm_10) AS Avg_Pm_10
  FROM aqi;
   

-- 4. Worst Pollution Location

SELECT Location_delhi, AVG(AQI_index) AS Avg_AQI
FROM aqi
GROUP BY Location_delhi
ORDER BY Avg_AQI DESC
LIMIT 3;


-- 5. Impact of Wind Speed on AQI

SELECT
   CASE 
      WHEN Windspeed_kph < 5 THEN 'Low Wind'

	  WHEN Windspeed_kph BETWEEN 5 AND 10 THEN 'Medium Wind'

	  ELSE 'High Wind'

	  END AS Wind_Category,

      AVG(AQI_index) AS Avg_AQI

	  FROM aqi

	  GROUP BY Wind_Category;
	  

---------- Business Analysis Questions 	---------- -- 


-- 3.Is PM2.5 or PM10 the major contributor to pollution?

SELECT
   AVG(Pm2_5) AS Pm_25,
   AVG(Pm_10) AS Pm_10,
   AVG(Co) AS Co,
   AVG (No2) AS No2
   FROM aqi;

-- 5.Which time of day has the worst pollution?

SELECT Time_IST, AVG(AQI_index) AS Avg_AQI
FROM aqi
GROUP BY Time_IST
ORDER BY Avg_AQI DESC
LIMIT 3;

-- ----------------- END QUERY -----------------------




