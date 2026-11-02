WITH base AS (
  SELECT * FROM loan WHERE loan_status IN ('Fully Paid','Charged Off')
)
SELECT scenario,
       COUNT(*) AS loans_kept,
       ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM base), 1) AS pct_volume_kept,
       ROUND(100.0 * SUM((loan_status='Charged Off')::int) / COUNT(*), 2) AS default_rate,
       ROUND((SUM(total_pymnt - funded_amnt) / 1e6)::numeric, 1) AS net_profit_m,
       ROUND((100.0 * SUM(total_pymnt - funded_amnt) / SUM(funded_amnt))::numeric, 2) AS roi
FROM (
  SELECT 'S0: Baseline' AS scenario, * FROM base
  UNION ALL
  SELECT 'S1: tanpa grade E-G', * FROM base
   WHERE grade NOT IN ('E','F','G')
  UNION ALL
  SELECT 'S2: S1 + tanpa tenor 60 di grade D', * FROM base
   WHERE grade NOT IN ('E','F','G') AND NOT (grade = 'D' AND term = 60)
  UNION ALL
  SELECT 'S3: S2 + bunga maks 17%', * FROM base
   WHERE grade NOT IN ('E','F','G') AND NOT (grade = 'D' AND term = 60) AND int_rate <= 17
) s
GROUP BY scenario ORDER BY scenario;