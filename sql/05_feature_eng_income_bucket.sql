UPDATE loan
SET income_bucket = CASE
    WHEN annual_inc < 30000  THEN '< $30K'
    WHEN annual_inc < 50000  THEN '$30K - $50K'
    WHEN annual_inc < 75000  THEN '$50K - $75K'
    WHEN annual_inc < 100000 THEN '$75K - $100K'
    WHEN annual_inc < 150000 THEN '$100K - $150K'
    ELSE                          '> $150K'
END;