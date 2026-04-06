# Milestone 1 Grade

| Criterion | Score | Max |
|-----------|------:|----:|
| Data Quality Audit | 3 | 3 |
| Query Depth & Correctness | 2 | 3 |
| Business Reasoning & README | 3 | 3 |
| Git Practices | 3 | 3 |
| Code Walkthrough | 3 | 3 |
| **Total** | **14** | **15** |

## Data Quality Audit (3/3)
`data_quality.sql` is a thorough, well-structured audit using 5 CTEs chained into a unified output: row counts across all 9 tables, primary-key null rates, orphaned FK check (orders without matching customers via LEFT JOIN), date coverage with gap-day calculation, and duplicate detection for both orders and customers. All results are unpivoted into a clean three-column (audit_category, metric_name, metric_value) format. This is systematic and goes well beyond a basic COUNT(*) audit.

## Query Depth & Correctness (2/3)
All 4 analysis files execute cleanly against the instructor's database.

- **Part_Two_SQL_Audit_1.sql** — 4 CTEs (`city_order_counts`, `top_cities`, `city_category_orders`, `ranked_categories`). Uses `RANK()` window function, multiple INNER JOINs, subquery filter via `WHERE IN`. Strong.
- **Part_Two_SQL_Audit_2.sql** — 4 CTEs (`order_revenue`, `delivered_orders_with_state`, `state_summary`, `ranked_states`). Uses `RANK()` window function, multiple JOINs, `COUNT(DISTINCT ...)`, `AVG`, filtering on order status. Strong.
- **Part_Two_SQL_Audit_3.sql** — No CTEs. A flat SELECT with 4 JOINs and a correlated scalar subquery in the WHERE clause for above-average filtering. The approach is valid but there are no CTEs and no window functions; this is a shallow query relative to the others.
- **Part_Two_SQL_Audit_4.sql** — No CTEs. A flat aggregation with `COALESCE` for the LEFT JOIN translation fallback, `COUNT(DISTINCT ...)`, `SUM`, `AVG`, and `ROUND`. Clean and meaningful, but again no CTEs or window functions.

Two of the four analysis queries lack CTEs entirely, so the requirement of "at least 2 files with 3+ CTEs" is only met by 2 files (Audit_1 and Audit_2). The techniques used across the set are solid but the depth is uneven.

## Business Reasoning & README (3/3)
The README is comprehensive and well-organized. Each query has a clearly stated business question, a description of the approach (including why specific design choices were made, e.g., filtering only "delivered" orders to avoid inflating revenue, using LEFT JOIN on category_translation to avoid dropping untranslated categories, computing revenue at the order level before joining to prevent double-counting). Explanations cover join logic, CTE purpose, and output interpretation for every query. This is well above generic — it reads as a coherent analytical narrative.

## Git Practices (3/3)
75 commits with granular, descriptive messages showing clear logical progression: work was built incrementally (e.g., separate commits for each CTE added, for each README section, for bug fixes like integer division and missing parentheses). Evidence of collaborative work (multiple author signatures in messages like "Jake Lotz", "Lincoln"). Merge commits from branch coordination are present. Exemplary commit hygiene.
