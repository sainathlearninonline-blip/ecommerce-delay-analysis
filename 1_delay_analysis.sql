-- Identify warehouses with the highest average delay and cancellation rates
SELECT 
    warehouse_id,
    COUNT(order_id) AS total_orders,
    ROUND(AVG(DATEDIFF(day, order_date, shipped_date)), 2) AS avg_dispatch_days,
    SUM(CASE WHEN delivery_status = 'Cancelled' THEN 1 ELSE 0 END) AS total_cancellations,
    ROUND((SUM(CASE WHEN delivery_status = 'Cancelled' THEN 1.0 ELSE 0 END) / COUNT(order_id)) * 100, 2) AS cancellation_rate_pct
FROM orders
WHERE order_date >= DATEADD(month, -3, GETDATE())
GROUP BY warehouse_id
HAVING COUNT(order_id) > 100
ORDER BY avg_dispatch_days DESC;