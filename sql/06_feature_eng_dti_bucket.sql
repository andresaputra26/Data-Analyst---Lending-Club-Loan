UPDATE loan
SET dti_bucket = CASE
    WHEN dti < 10  THEN '0-10'
    WHEN dti < 20  THEN '10-20'
    WHEN dti < 30  THEN '20-30'
    WHEN dti < 40  THEN '30-40'
    ELSE                 '40+'
END;