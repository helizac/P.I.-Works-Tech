WITH medians AS (
  SELECT 
    country,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY daily_vaccinations) AS median_vaccinations
  FROM 
    country_vaccination_stats
  WHERE 
    daily_vaccinations IS NOT NULL
  GROUP BY 
    country
),
country_data AS (
  SELECT 
    country,
    COALESCE(PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY daily_vaccinations), 0) AS median_vaccinations
  FROM 
    country_vaccination_stats
  GROUP BY 
    country
),
filled_data AS (
  SELECT 
    cvs.country,
    cvs.date,
    COALESCE(cvs.daily_vaccinations, cd.median_vaccinations, 0) AS daily_vaccinations,
    cvs.vaccines
  FROM 
    country_vaccination_stats cvs
  LEFT JOIN 
    country_data cd ON cvs.country = cd.country
)
SELECT * FROM filled_data;