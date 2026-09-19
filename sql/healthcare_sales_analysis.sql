-- ============================================================
-- Healthcare Device Sales Analytics
-- SQL Analysis using MySQL
-- Dataset: Synthetic Healthcare Device Sales Data
-- ============================================================

USE healthcare_analytics;


-- ============================================================
-- 1. TOTAL REVENUE
-- ============================================================

SELECT 
    SUM(revenue) AS total_revenue
FROM sales_data;


-- ============================================================
-- 2. TOTAL TRANSACTIONS
-- ============================================================

SELECT 
    COUNT(*) AS total_transactions
FROM sales_data;


-- ============================================================
-- 3. REVENUE BY MACHINE
-- ============================================================

SELECT 
    machine,
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY machine
ORDER BY total_revenue DESC;


-- ============================================================
-- 4. REVENUE BY BRANCH
-- ============================================================

SELECT 
    branch,
    SUM(revenue) AS total_revenue
FROM sales_data
GROUP BY branch
ORDER BY total_revenue DESC;


-- ============================================================
-- 5. TRANSACTIONS BY BRANCH
-- ============================================================

SELECT 
    branch,
    COUNT(*) AS total_transactions
FROM sales_data
GROUP BY branch
ORDER BY total_transactions DESC;


-- ============================================================
-- 6. AVERAGE REVENUE PER TRANSACTION BY BRANCH
-- ============================================================

SELECT 
    branch,
    ROUND(AVG(revenue), 2) AS average_revenue
FROM sales_data
GROUP BY branch
ORDER BY average_revenue DESC;


-- ============================================================
-- 7. COMBINED BRANCH PERFORMANCE
-- ============================================================

SELECT 
    branch,
    COUNT(*) AS total_transactions,
    SUM(revenue) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue_per_transaction
FROM sales_data
GROUP BY branch
ORDER BY total_revenue DESC;


-- ============================================================
-- 8. DOCTOR PERFORMANCE
-- ============================================================

SELECT 
    doctor,
    branch,
    COUNT(*) AS total_transactions,
    SUM(revenue) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue_per_transaction
FROM sales_data
GROUP BY doctor, branch
ORDER BY total_revenue DESC;


-- ============================================================
-- 9. DOCTOR REVENUE RANKING
-- ============================================================

SELECT 
    doctor,
    branch,
    SUM(revenue) AS total_revenue,
    RANK() OVER (
        ORDER BY SUM(revenue) DESC
    ) AS revenue_rank
FROM sales_data
GROUP BY doctor, branch
ORDER BY revenue_rank;


-- ============================================================
-- 10. DOCTOR PERFORMANCE USING CTE
-- ============================================================

WITH doctor_performance AS (
    SELECT 
        doctor,
        branch,
        SUM(revenue) AS total_revenue
    FROM sales_data
    GROUP BY doctor, branch
)
SELECT 
    doctor,
    branch,
    total_revenue,
    ROUND(AVG(total_revenue) OVER (), 2) AS average_doctor_revenue
FROM doctor_performance
ORDER BY total_revenue DESC;


-- ============================================================
-- 11. MACHINE REVENUE WITH PURCHASE COST
-- ============================================================

SELECT 
    s.machine,
    SUM(s.revenue) AS total_revenue,
    m.category,
    m.purchase_cost
FROM sales_data s
JOIN machine_data m
    ON s.machine = m.machine
GROUP BY 
    s.machine,
    m.category,
    m.purchase_cost
ORDER BY total_revenue DESC;


-- ============================================================
-- 12. REVENUE VS MACHINE PURCHASE COST
-- NOTE: This is NOT true ROI because operating costs,
-- maintenance, consumables, staffing, etc. are not included.
-- ============================================================

SELECT 
    s.machine,
    SUM(s.revenue) AS total_revenue,
    m.purchase_cost,
    ROUND(
        SUM(s.revenue) / m.purchase_cost * 100,
        2
    ) AS revenue_vs_cost_percent
FROM sales_data s
JOIN machine_data m
    ON s.machine = m.machine
GROUP BY 
    s.machine,
    m.purchase_cost
ORDER BY revenue_vs_cost_percent DESC;
