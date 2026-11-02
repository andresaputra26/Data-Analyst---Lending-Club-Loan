UPDATE loan
SET home_ownership = 'OTHER'
WHERE home_ownership IN ('ANY', 'NONE');