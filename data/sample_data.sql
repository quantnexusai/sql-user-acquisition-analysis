-- Create tables for user acquisition analysis
CREATE TABLE campaigns (
    campaign_id INTEGER PRIMARY KEY,
    campaign_name VARCHAR(100),
    channel VARCHAR(50),
    start_date DATE,
    end_date DATE,
    budget DECIMAL(10,2)
);

CREATE TABLE user_acquisitions (
    acquisition_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    campaign_id INTEGER,
    acquisition_date TIMESTAMP,
    source VARCHAR(50),
    medium VARCHAR(50),
    landing_page VARCHAR(100),
    cost DECIMAL(8,2),
    FOREIGN KEY (campaign_id) REFERENCES campaigns(campaign_id)
);

CREATE TABLE user_activities (
    activity_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    activity_type VARCHAR(50),
    activity_date TIMESTAMP,
    revenue DECIMAL(10,2)
);

-- Insert sample data for campaigns
INSERT INTO campaigns VALUES
(1, 'Summer Promo', 'Social Media', '2023-06-01', '2023-07-31', 5000.00),
(2, 'Back to School', 'Search', '2023-08-01', '2023-09-15', 7500.00),
(3, 'Holiday Sale', 'Email', '2023-11-20', '2023-12-31', 10000.00),
(4, 'Spring Launch', 'Display', '2024-03-01', '2024-04-15', 6000.00),
(5, 'Referral Program', 'Organic', '2023-01-01', '2024-12-31', 2000.00);

-- Insert sample data for user acquisitions
INSERT INTO user_acquisitions VALUES
(1, 101, 1, '2023-06-05 14:30:00', 'instagram', 'cpc', '/landing/summer', 5.25),
(2, 102, 1, '2023-06-08 09:15:00', 'facebook', 'cpm', '/landing/summer', 3.80),
(3, 103, 2, '2023-08-12 11:45:00', 'google', 'cpc', '/landing/education', 4.20),
(4, 104, 2, '2023-08-15 16:22:00', 'bing', 'cpc', '/landing/education', 3.10),
(5, 105, 3, '2023-11-25 08:10:00', 'newsletter', 'email', '/landing/holiday', 0.50),
(6, 106, 3, '2023-12-01 19:05:00', 'newsletter', 'email', '/landing/holiday', 0.50),
(7, 107, 4, '2024-03-05 10:30:00', 'youtube', 'cpm', '/landing/newproduct', 6.75),
(8, 108, 5, '2023-05-20 13:40:00', 'referral', 'organic', '/landing/refer', 1.00),
(9, 109, 5, '2023-07-14 09:25:00', 'referral', 'organic', '/landing/refer', 1.00),
(10, 110, 2, '2023-09-01 15:35:00', 'google', 'cpc', '/landing/education', 5.30);

-- Insert sample data for user activities
INSERT INTO user_activities VALUES
(1, 101, 'signup', '2023-06-05 14:45:00', 0.00),
(2, 101, 'purchase', '2023-06-10 11:30:00', 75.99),
(3, 102, 'signup', '2023-06-08 09:30:00', 0.00),
(4, 103, 'signup', '2023-08-12 12:00:00', 0.00),
(5, 103, 'purchase', '2023-08-20 14:15:00', 120.50),
(6, 104, 'signup', '2023-08-15 16:45:00', 0.00),
(7, 105, 'signup', '2023-11-25 08:20:00', 0.00),
(8, 106, 'signup', '2023-12-01 19:10:00', 0.00),
(9, 106, 'purchase', '2023-12-05 10:25:00', 89.99),
(10, 107, 'signup', '2024-03-05 10:45:00', 0.00),
(11, 107, 'purchase', '2024-03-10 16:30:00', 150.00),
(12, 108, 'signup', '2023-05-20 14:00:00', 0.00),
(13, 109, 'signup', '2023-07-14 09:40:00', 0.00),
(14, 109, 'purchase', '2023-08-01 13:15:00', 65.50),
(15, 110, 'signup', '2023-09-01 16:00:00', 0.00),
(16, 110, 'purchase', '2023-09-15 11:20:00', 45.99),
(17, 108, 'purchase', '2023-06-15 09:10:00', 110.75);