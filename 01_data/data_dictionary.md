# Data Dictionary — Auto Insurance Claims Dataset

**Source:** Kaggle — Auto Insurance Claims Fraud Detection
**Records:** 1,000 claims
**Time period:** Policies bound 1990–2015; incidents in early 2015
**Geography:** Ohio, Illinois, Indiana

---

## Cleaning notes

The raw dataset required the following cleanup before analysis:

| Issue | Action taken |
|---|---|
| Column `_c39` was entirely empty (likely a CSV export artifact) | Dropped |
| Three columns used `?` as a missing-value sentinel: `collision_type`, `property_damage`, `police_report_available` | Replaced with `Unknown` (and kept as a feature — "unknown" is itself a fraud signal) |
| `policy_bind_date` and `incident_date` stored as text | Converted to date type |
| No 1/0 fraud flag for aggregation | Added `is_fraud` column (Y → 1, N → 0) |
| No age groupings | Added `age_band` column (Under 25, 25–34, 35–44, 45–54, 55+) |
| No tenure in years | Added `policy_tenure_years` (months / 12) |
| No fraud-screening indicators | Added 4 red-flag columns + `red_flag_count` |

---

## Column reference

### Customer & policy
| Column | Type | Description |
|---|---|---|
| `policy_number` | int | Unique policy identifier |
| `months_as_customer` | int | Tenure with the insurer in months |
| `policy_tenure_years` | float | Tenure in years (derived) |
| `age` | int | Policyholder age |
| `age_band` | category | Age grouping (derived) |
| `policy_bind_date` | date | When the policy started |
| `policy_state` | category | State the policy was issued in (OH, IL, IN) |
| `policy_csl` | text | Combined Single Limit (e.g., 250/500) |
| `policy_deductable` | int | Policy deductible in $ |
| `policy_annual_premium` | float | Annual premium paid in $ |
| `umbrella_limit` | int | Umbrella coverage limit in $ |
| `insured_zip` | int | Insured's ZIP code |
| `insured_sex` | category | MALE / FEMALE |
| `insured_education_level` | category | Education level |
| `insured_occupation` | category | Occupation |
| `insured_hobbies` | category | Listed hobby (worth scrutiny — some hobbies show suspicious fraud rates) |
| `insured_relationship` | category | Family relationship status |
| `capital-gains` | int | Reported capital gains in $ |
| `capital-loss` | int | Reported capital losses in $ |

### Incident
| Column | Type | Description |
|---|---|---|
| `incident_date` | date | Date of the claim incident |
| `incident_type` | category | Multi-vehicle Collision / Single Vehicle Collision / Vehicle Theft / Parked Car |
| `collision_type` | category | Front / Rear / Side / Unknown |
| `incident_severity` | category | Trivial / Minor / Major / Total Loss |
| `authorities_contacted` | category | Police / Fire / Other / None |
| `incident_state` | category | State where incident occurred |
| `incident_city` | category | City where incident occurred |
| `incident_location` | text | Street address of incident |
| `incident_hour_of_the_day` | int | Hour (0–23) the incident occurred |
| `number_of_vehicles_involved` | int | Number of vehicles in the incident |
| `property_damage` | category | YES / NO / Unknown |
| `bodily_injuries` | int | Number of bodily injuries reported |
| `witnesses` | int | Number of witnesses |
| `police_report_available` | category | YES / NO / Unknown |

### Claim amounts
| Column | Type | Description |
|---|---|---|
| `total_claim_amount` | int | Total claim payout in $ |
| `injury_claim` | int | Injury portion of claim in $ |
| `property_claim` | int | Property portion of claim in $ |
| `vehicle_claim` | int | Vehicle portion of claim in $ |

### Vehicle
| Column | Type | Description |
|---|---|---|
| `auto_make` | category | Vehicle make |
| `auto_model` | category | Vehicle model |
| `auto_year` | int | Vehicle model year |

### Target & derived risk indicators
| Column | Type | Description |
|---|---|---|
| `fraud_reported` | category | Y / N — was this claim flagged as fraudulent |
| `is_fraud` | int | 1 if fraud, 0 if not (derived) |
| `rf_no_police_report` | int | Red flag: no police report (1/0) |
| `rf_no_witnesses` | int | Red flag: zero witnesses (1/0) |
| `rf_unknown_collision` | int | Red flag: collision type is "Unknown" (1/0) |
| `rf_major_damage` | int | Red flag: incident severity is "Major Damage" (1/0) |
| `red_flag_count` | int | Sum of the four red flags (0–4) — the headline risk score |
