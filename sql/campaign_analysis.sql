-- 1. Basic campaign performance overview
SELECT 
    c.campaign_id,
    c.campaign_name,
    c.channel,
    COUNT(ua.acquisition_id) AS total_acquisitions,
    SUM(ua.cost) AS total_cost,
    ROUND(SUM(ua.cost) / COUNT(ua.acquisition_id), 2) AS cost_per_acquisition
FROM 
    campaigns c
LEFT JOIN 
    user_acquisitions ua ON c.campaign_id = ua.campaign_id
GROUP BY 
    c.campaign_id, c.campaign_name, c.channel
ORDER BY 
    total_acquisitions DESC;

-- 2. Conversion rate analysis
WITH acquisition_signups AS (
    SELECT 
        c.campaign_id,
        c.campaign_name,
        COUNT(ua.acquisition_id) AS total_acquisitions,
        COUNT(DISTINCT act.user_id) AS users_with_activity
    FROM 
        campaigns c
    LEFT JOIN 
        user_acquisitions ua ON c.campaign_id = ua.campaign_id
    LEFT JOIN 
        user_activities act ON ua.user_id = act.user_id
    WHERE 
        act.activity_type = 'signup'
    GROUP BY 
        c.campaign_id, c.campaign_name
),
purchases AS (
    SELECT 
        c.campaign_id,
        COUNT(DISTINCT act.user_id) AS users_with_purchase
    FROM 
        campaigns c
    LEFT JOIN 
        user_acquisitions ua ON c.campaign_id = ua.campaign_id
    LEFT JOIN 
        user_activities act ON ua.user_id = act.user_id
    WHERE 
        act.activity_type = 'purchase'
    GROUP BY 
        c.campaign_id
)
SELECT 
    a.campaign_id,
    a.campaign_name,
    a.total_acquisitions,
    a.users_with_activity AS signups,
    p.users_with_purchase AS purchases,
    ROUND(CAST(a.users_with_activity AS DECIMAL) / a.total_acquisitions * 100, 2) AS signup_rate,
    ROUND(CAST(p.users_with_purchase AS DECIMAL) / a.users_with_activity * 100, 2) AS purchase_conversion_rate
FROM 
    acquisition_signups a
JOIN 
    purchases p ON a.campaign_id = p.campaign_id
ORDER BY 
    purchase_conversion_rate DESC;

-- 3. ROI calculation by campaign
SELECT 
    c.campaign_id,
    c.campaign_name,
    c.budget,
    SUM(ua.cost) AS actual_spend,
    SUM(act.revenue) AS total_revenue,
    ROUND(SUM(act.revenue) / SUM(ua.cost), 2) AS roi,
    CASE 
        WHEN SUM(act.revenue) > SUM(ua.cost) THEN 'Profitable'
        ELSE 'Not Profitable'
    END AS profitability_status
FROM 
    campaigns c
LEFT JOIN 
    user_acquisitions ua ON c.campaign_id = ua.campaign_id
LEFT JOIN 
    user_activities act ON ua.user_id = act.user_id AND act.activity_type = 'purchase'
GROUP BY 
    c.campaign_id, c.campaign_name, c.budget
ORDER BY 
    roi DESC;

-- 4. Time-based analysis: Average time to conversion
WITH first_acquisitions AS (
    SELECT 
        user_id,
        MIN(acquisition_date) AS first_acquisition_date
    FROM 
        user_acquisitions
    GROUP BY 
        user_id
),
first_purchases AS (
    SELECT 
        user_id,
        MIN(activity_date) AS first_purchase_date
    FROM 
        user_activities
    WHERE 
        activity_type = 'purchase'
    GROUP BY 
        user_id
)
SELECT 
    c.campaign_name,
    ROUND(AVG(EXTRACT(EPOCH FROM (fp.first_purchase_date - fa.first_acquisition_date))/86400), 2) AS avg_days_to_purchase
FROM 
    first_acquisitions fa
JOIN 
    first_purchases fp ON fa.user_id = fp.user_id
JOIN 
    user_acquisitions ua ON fa.user_id = ua.user_id
JOIN 
    campaigns c ON ua.campaign_id = c.campaign_id
GROUP BY 
    c.campaign_name
ORDER BY 
    avg_days_to_purchase;

-- 5. Channel effectiveness using window functions
WITH channel_metrics AS (
    SELECT 
        c.channel,
        COUNT(ua.acquisition_id) AS acquisitions,
        SUM(ua.cost) AS total_cost,
        SUM(CASE WHEN act.activity_type = 'purchase' THEN act.revenue ELSE 0 END) AS revenue,
        ROW_NUMBER() OVER (ORDER BY SUM(CASE WHEN act.activity_type = 'purchase' THEN act.revenue ELSE 0 END) / SUM(ua.cost) DESC) AS roi_rank
    FROM 
        campaigns c
    LEFT JOIN 
        user_acquisitions ua ON c.campaign_id = ua.campaign_id
    LEFT JOIN 
        user_activities act ON ua.user_id = act.user_id
    GROUP BY 
        c.channel
)
SELECT 
    channel,
    acquisitions,
    total_cost,
    revenue,
    ROUND(revenue / total_cost, 2) AS roi,
    roi_rank,
    ROUND(acquisitions * 100.0 / (SELECT SUM(acquisitions) FROM channel_metrics), 2) AS acquisition_percentage
FROM 
    channel_metrics
ORDER BY 
    roi_rank;

-- 6. Cohort analysis by acquisition month
WITH user_cohorts AS (
    SELECT 
        TO_CHAR(DATE_TRUNC('month', ua.acquisition_date), 'YYYY-MM') AS cohort_month,
        ua.user_id,
        MIN(ua.acquisition_date) AS first_acquisition,
        MIN(CASE WHEN act.activity_type = 'purchase' THEN act.activity_date ELSE NULL END) AS first_purchase,
        SUM(CASE WHEN act.activity_type = 'purchase' THEN act.revenue ELSE 0 END) AS total_revenue
    FROM 
        user_acquisitions ua
    LEFT JOIN 
        user_activities act ON ua.user_id = act.user_id
    GROUP BY 
        TO_CHAR(DATE_TRUNC('month', ua.acquisition_date), 'YYYY-MM'), ua.user_id
)
SELECT 
    cohort_month,
    COUNT(user_id) AS cohort_size,
    COUNT(first_purchase) AS users_with_purchase,
    ROUND(COUNT(first_purchase) * 100.0 / COUNT(user_id), 2) AS conversion_rate,
    ROUND(SUM(total_revenue) / COUNT(user_id), 2) AS revenue_per_user,
    ROUND(AVG(EXTRACT(EPOCH FROM (first_purchase - first_acquisition))/86400), 2) AS avg_days_to_purchase
FROM 
    user_cohorts
GROUP BY 
    cohort_month
ORDER BY 
    cohort_month;
