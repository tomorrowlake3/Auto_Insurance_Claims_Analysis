-- ============================================================
-- Auto Insurance Claims Analysis — Exploratory SQL Queries
-- ============================================================
-- Author: tomorrowlake3
-- Database: claims.db (SQLite)
-- Source: Kaggle "Auto Insurance Claims Fraud Detection" dataset
--
-- Purpose: Answer the business questions that drive the
-- dashboard and executive memo. Each query is annotated with
-- the question it answers and the expected finding.
-- ============================================================


-- ------------------------------------------------------------
-- Q1: Portfolio overview — top-level KPIs for the dashboard
-- Business question: What's the overall shape of the claims portfolio?
-- ------------------------------------------------------------
SELECT
    COUNT(*) AS total_claims,
    SUM(total_claim_amount) AS total_claim_dollars,
    ROUND(AVG(total_claim_amount), 0) AS avg_claim,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 1) AS fraud_rate_pct,
    SUM(CASE WHEN is_fraud = 1 THEN total_claim_amount ELSE 0 END) AS fraud_dollars
FROM claims;


-- ------------------------------------------------------------
-- Q2: Fraud rate by incident severity — the headline finding
-- Business question: Which severity tiers have the highest fraud risk?
-- Expected: Major Damage = ~60%, all others 7-13%
-- ------------------------------------------------------------
SELECT
    incident_severity,
    COUNT(*) AS claim_count,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 1) AS fraud_rate_pct,
    ROUND(AVG(total_claim_amount), 0) AS avg_claim
FROM claims
GROUP BY incident_severity
ORDER BY fraud_rate_pct DESC;


-- ------------------------------------------------------------
-- Q3: Fraud rate by red flag count — validates the risk score
-- Business question: Does the red flag scoring system actually work?
-- Expected: Linear increase from ~14% (0 flags) to ~41% (3 flags)
-- ------------------------------------------------------------
SELECT
    red_flag_count,
    COUNT(*) AS claim_count,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 1) AS fraud_rate_pct,
    ROUND(AVG(total_claim_amount), 0) AS avg_claim
FROM claims
GROUP BY red_flag_count
ORDER BY red_flag_count;


-- ------------------------------------------------------------
-- Q4: Top fraud-risk profiles (severity + incident type combos)
-- Business question: Which combinations are most fraud-prone?
-- Expected: "Major Damage + ___" profiles dominate the top
-- ------------------------------------------------------------
SELECT
    incident_severity || ' | ' || incident_type AS profile,
    COUNT(*) AS claim_count,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 1) AS fraud_rate_pct
FROM claims
GROUP BY profile
HAVING claim_count >= 20
ORDER BY fraud_rate_pct DESC
LIMIT 10;


-- ------------------------------------------------------------
-- Q5: State-level portfolio breakdown
-- Business question: Is fraud concentrated in any specific state?
-- Expected: All 3 states ~22-26% — confirms state is NOT a useful targeting variable
-- ------------------------------------------------------------
SELECT
    policy_state,
    COUNT(*) AS claim_count,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 1) AS fraud_rate_pct,
    ROUND(AVG(policy_annual_premium), 0) AS avg_premium,
    SUM(total_claim_amount) AS total_claim_dollars
FROM claims
GROUP BY policy_state
ORDER BY fraud_rate_pct DESC;


-- ------------------------------------------------------------
-- Q6: SIU routing rule impact — validates the recommendation
-- Business question: If we route claims with 2+ red flags to SIU, what do we catch?
-- Expected: SIU pool = 28% of volume, catches 38% of fraud, $5.5M
-- ------------------------------------------------------------
SELECT
    CASE
        WHEN red_flag_count >= 2 THEN 'Route to SIU (2+ red flags)'
        ELSE 'Standard adjudication (0-1 red flags)'
    END AS routing_decision,
    COUNT(*) AS claim_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM claims), 1) AS pct_of_portfolio,
    SUM(is_fraud) AS fraud_caught,
    ROUND(SUM(is_fraud) * 100.0 / (SELECT SUM(is_fraud) FROM claims), 1) AS pct_of_fraud_caught,
    SUM(CASE WHEN is_fraud = 1 THEN total_claim_amount ELSE 0 END) AS fraud_dollars_in_pool
FROM claims
GROUP BY routing_decision
ORDER BY routing_decision DESC;


-- ------------------------------------------------------------
-- Q7: Top 20 highest-risk individual claims for adjuster triage
-- Business question: Which specific claims should an adjuster look at first?
-- ------------------------------------------------------------
SELECT
    policy_number,
    incident_severity,
    incident_type,
    total_claim_amount,
    red_flag_count,
    fraud_reported
FROM claims
WHERE red_flag_count >= 2
ORDER BY red_flag_count DESC, total_claim_amount DESC
LIMIT 20;


-- ------------------------------------------------------------
-- Q8: Demographics check — confirms which variables are NOT useful
-- Business question: Does demographic data help identify fraud, or is it noise?
-- Expected: Fraud rates similar across demographics — these aren't strong signals
-- ------------------------------------------------------------
SELECT
    'Sex: ' || insured_sex AS demographic_segment,
    COUNT(*) AS claim_count,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(is_fraud) * 100, 1) AS fraud_rate_pct
FROM claims
GROUP BY insured_sex
UNION ALL
SELECT
    'Education: ' || insured_education_level,
    COUNT(*),
    SUM(is_fraud),
    ROUND(AVG(is_fraud) * 100, 1)
FROM claims
GROUP BY insured_education_level
ORDER BY fraud_rate_pct DESC;
