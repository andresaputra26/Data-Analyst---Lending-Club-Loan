DROP TABLE IF EXISTS loan;

CREATE TABLE loan AS
SELECT
    loan_amnt,
    funded_amnt,
    CAST(NULLIF(TRIM(REPLACE(term, 'months', '')), '') AS INT) AS term,
    int_rate,
    installment,
    grade,
    sub_grade,
    emp_title,
    emp_length,
    CASE
        WHEN emp_length = '< 1 year'  THEN 0
        WHEN emp_length = '1 year'    THEN 1
        WHEN emp_length = '2 years'   THEN 2
        WHEN emp_length = '3 years'   THEN 3
        WHEN emp_length = '4 years'   THEN 4
        WHEN emp_length = '5 years'   THEN 5
        WHEN emp_length = '6 years'   THEN 6
        WHEN emp_length = '7 years'   THEN 7
        WHEN emp_length = '8 years'   THEN 8
        WHEN emp_length = '9 years'   THEN 9
        WHEN emp_length = '10+ years' THEN 10
        ELSE NULL
    END AS emp_length_num,
    home_ownership,
    annual_inc,
    verification_status,
    issue_d,
    TO_DATE('01-' || issue_d, 'DD-Mon-YYYY') AS issue_date,
    EXTRACT(YEAR FROM TO_DATE('01-' || issue_d, 'DD-Mon-YYYY'))::INT AS issue_year,
    EXTRACT(MONTH FROM TO_DATE('01-' || issue_d, 'DD-Mon-YYYY'))::INT AS issue_month,
    loan_status AS loan_status_original,
    CASE
        WHEN loan_status IN ('Fully Paid', 
             'Does not meet the credit policy. Status:Fully Paid')
             THEN 'Fully Paid'
        WHEN loan_status IN ('Charged Off', 
             'Does not meet the credit policy. Status:Charged Off')
             THEN 'Charged Off'
        WHEN loan_status = 'Current' THEN 'Current'
        WHEN loan_status LIKE '%Late%' THEN 'Late'
        WHEN loan_status = 'In Grace Period' THEN 'In Grace Period'
        WHEN loan_status = 'Default' THEN 'Default'
        ELSE 'Other'
    END AS loan_status,
    CASE
        WHEN loan_status IN ('Charged Off', 
             'Does not meet the credit policy. Status:Charged Off',
             'Default')
             OR loan_status LIKE '%Late%'
             THEN 1 ELSE 0
    END AS is_bad_loan,
    purpose,
    addr_state,
    dti,
    CASE
        WHEN dti < 10  THEN '1. 0-10'
        WHEN dti < 20  THEN '2. 10-20'
        WHEN dti < 30  THEN '3. 20-30'
        WHEN dti < 40  THEN '4. 30-40'
        ELSE                 '5. 40+'
    END AS dti_bucket,
    CASE
        WHEN annual_inc < 30000  THEN '1. < $30K'
        WHEN annual_inc < 50000  THEN '2. $30K-$50K'
        WHEN annual_inc < 75000  THEN '3. $50K-$75K'
        WHEN annual_inc < 100000 THEN '4. $75K-$100K'
        WHEN annual_inc < 150000 THEN '5. $100K-$150K'
        ELSE                          '6. > $150K'
    END AS income_bucket,
    delinq_2yrs,
    inq_last_6mths,
    open_acc,
    pub_rec,
    revol_bal,
    revol_util,
    total_acc,
    out_prncp,
    total_pymnt,
    total_rec_prncp,
    total_rec_int,
    total_rec_late_fee,
    recoveries,
    last_pymnt_amnt,
    (total_pymnt - funded_amnt) AS profit_loss,
    application_type,
    mort_acc,
    pub_rec_bankruptcies,
    tot_cur_bal,
    total_rev_hi_lim
FROM loan_raw
WHERE loan_amnt IS NOT NULL;