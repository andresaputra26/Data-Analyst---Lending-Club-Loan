DELETE FROM loan
WHERE annual_inc IS NULL 
   OR dti IS NULL 
   OR dti < 0 
   OR dti >= 999;