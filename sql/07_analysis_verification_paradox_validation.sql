SELECT grade,
  ROUND(100.0 * COUNT(*) FILTER (WHERE loan_status='Charged Off' AND verification_status='Verified')
        / NULLIF(COUNT(*) FILTER (WHERE verification_status='Verified'),0), 2)      AS verified_dr,
  ROUND(100.0 * COUNT(*) FILTER (WHERE loan_status='Charged Off' AND verification_status='Not Verified')
        / NULLIF(COUNT(*) FILTER (WHERE verification_status='Not Verified'),0), 2)  AS not_verified_dr,
  ROUND(100.0 * COUNT(*) FILTER (WHERE verification_status='Verified') / COUNT(*), 1) AS pct_verified
FROM loan
WHERE loan_status IN ('Fully Paid','Charged Off')
GROUP BY grade
ORDER BY grade;