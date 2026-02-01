CREATE TABLE car_theft
	(
	case_id int PRIMARY KEY,
	Theft_Date date,
	Report_Date date,
	Car_Brand varchar (15),
	Car_Model varchar (15),
	Year_of_Manufacture int,
	Car_Type varchar (15),
	Fuel_Type varchar (10),
	Color varchar (10),
	Registered_State varchar (25),
	Registered_City varchar (25),
	Location_of_Theft varchar (15),
	Time_of_Theft varchar (15),
	Police_Station varchar (15),
	Is_Recovered varchar (5),
	Recovery_Date date,
	Suspect_Identified varchar (5),
	No_of_Prev_Thefts int,
	GPS_Installed varchar (5),
	CCTV_Availability varchar (5),
	Insurance_Status varchar (15),
	Owner_Age_Group varchar (10)
	);

SELECT * FROM car_theft;

SELECT 
	COUNT(*) AS total_cases
FROM car_theft;

SELECT * FROM car_theft
	WHERE
	case_id is null or
	Theft_Date is null or
	Report_Date is null or
	Car_Brand is null or
	Car_Model is null or
	Year_of_Manufacture is null or
	Car_Type is null or
	Fuel_Type is null or
	Color is null or
	Registered_State is null or
	Registered_City is null or
	Location_of_Theft is null or
	Time_of_Theft is null or
	Police_Station is null or
	Is_Recovered is null or
	Recovery_Date is null or
	Suspect_Identified is null or
	No_of_Prev_Thefts is null or
	GPS_Installed is null or
	CCTV_Availability is null or
	Insurance_Status is null or
	Owner_Age_Group is null;

SELECT
	car_brand,
	car_model,
	year_of_manufacture
FROM car_theft
GROUP BY 1, 2, 3
ORDER BY 1, 2, 3;


SELECT
	DISTINCT fuel_type
FROM car_theft;

SELECT
	DISTINCT car_type
FROM car_theft;

SELECT
	car_type,
	COUNT(case_id)
FROM car_theft
GROUP BY 1
ORDER BY 2 DESC;

--ANALYSIS QUESTIONS--

--What brand of car is most frequently stolen?--

SELECT
	car_brand,
	COUNT(case_id)
FROM car_theft
GROUP BY 1
ORDER BY 2 DESC;

--Which state does the theft occur more frequently?--

SELECT
	registered_state,
	COUNT(case_id) AS total_cases
FROM car_theft
GROUP BY 1
ORDER BY 2 DESC;

--What time of the day does the theft most frequently occur?--

SELECT
	time_of_theft,
	COUNT(case_id) AS total_cases
FROM car_theft
GROUP BY 1
ORDER BY 2 DESC;

--What is the percentage recovery?--

SELECT 
    ROUND(100.0 * 
	SUM(CASE WHEN is_recovered = 'Yes' 
			THEN 1 ELSE 0 END) 
        / COUNT(*),
        2
    	) AS recovery_percentage
FROM car_theft;

--What age group records the highest case of car theft?--

SELECT
	owner_age_group,
	COUNT(case_id) AS total_cases
FROM car_theft
GROUP BY 1
ORDER BY 2 DESC;

--How often are there repeat cases?--

SELECT
    CASE 
        WHEN no_of_prev_thefts = 0 THEN 'First_time_theft'
        ELSE 'Repeat_theft'
    END AS theft_type,
    COUNT(*) AS total_cases
FROM car_theft
GROUP BY theft_type;


--What is the percentage recovered to not recovered?--

SELECT
    is_recovered AS recovery_status,
    COUNT(*) AS total_cases,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM car_theft
GROUP BY is_recovered;

--Is there preference to the fuel type?--

SELECT
	fuel_type,
	COUNT(*) AS total_cases
FROM car_theft
GROUP BY 1
ORDER BY 2 DESC;

--Are the car mostly GPS installed?--

SELECT
	gps_installed,
	COUNT(*) AS total_cases
FROM car_theft
GROUP BY 1
ORDER BY 2 DESC;

--Which vehicles have valid insurance and which dont?--

SELECT
	insurance_status,
	COUNT(*) AS total_cases
FROM car_theft
GROUP BY 1
ORDER BY 2 DESC;

--What is the suspect identification rate by cctv availability?--

SELECT
    cctv_availability,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN suspect_identified = 'Yes' THEN 1 ELSE 0 END) AS suspect_identified_cases,
    ROUND(
        100.0 * SUM(CASE WHEN suspect_identified = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS suspect_identification_rate
FROM car_theft
GROUP BY cctv_availability;


--What is the suspect identification rate--

SELECT
    ROUND(
        100.0 * SUM(CASE WHEN suspect_identified = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS suspect_identification_rate
FROM car_theft;

--What is the rate of repeat theft cases?--

SELECT
    CASE
        WHEN no_of_prev_thefts = 0 THEN 'First-time theft'
        ELSE 'Repeat theft'
    END AS theft_type,
    COUNT(*) AS total_cases,
    ROUND(
        100.0 * COUNT(*) / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM car_theft
GROUP BY theft_type;

--How many cases were reported on a monthly basis?--

SELECT
	EXTRACT(YEAR FROM report_date) AS Year,
	EXTRACT(MONTH FROM report_date) AS Month,
	COUNT(*) AS total_cases
FROM car_theft
GROUP BY year, month
ORDER BY year, month;

--What is the recovery rate by GPS installed?--

SELECT
    gps_installed,
    COUNT(*) AS total_cases,
    SUM(CASE WHEN is_recovered = 'Yes' THEN 1 ELSE 0 END) AS recovered_cases,
    ROUND(
        100.0 * SUM(CASE WHEN is_recovered = 'Yes' THEN 1 ELSE 0 END)
        / COUNT(*),
        2
    ) AS recovery_rate
FROM car_theft
GROUP BY gps_installed;

--What locations records the highest number of theft cases?--

SELECT
	registered_state,
	location_of_theft,
	COUNT(*) AS total_cases
FROM car_theft
GROUP BY 1,2
ORDER BY 3 DESC;

--What is the average period of time to recover the car?--

SELECT
    ROUND(
        AVG(recovery_date - theft_date),
        2
    ) AS avg_days_to_recover
FROM car_theft
WHERE is_recovered = 'Yes'
  AND recovery_date IS NOT NULL;


--End of analysis--
