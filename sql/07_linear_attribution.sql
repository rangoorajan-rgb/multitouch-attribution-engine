WITH touchpoints AS (

SELECT
    customer_id,
    marketing_channel,
    COUNT(*) OVER (PARTITION BY customer_id) AS total_touches

FROM `multitouch-attribution-engine.marketing_attribution.customer_journey`

)

SELECT

    d.customer_id,
    t.marketing_channel,
    d.deal_value,
    ROUND(d.deal_value / t.total_touches,2) AS attributed_revenue

FROM touchpoints t

JOIN `multitouch-attribution-engine.marketing_attribution.deals` d

ON t.customer_id = d.customer_id

ORDER BY
d.customer_id,
t.marketing_channel;