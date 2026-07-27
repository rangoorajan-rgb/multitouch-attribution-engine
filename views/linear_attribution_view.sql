CREATE OR REPLACE VIEW
`multitouch-attribution-engine.marketing_attribution.linear_attribution_view`

AS

WITH touch_counts AS (

SELECT
    customer_id,
    COUNT(*) AS total_touches

FROM `multitouch-attribution-engine.marketing_attribution.customer_journey`

GROUP BY customer_id

)

SELECT

cj.customer_id,
cj.marketing_channel,
d.deal_value,

ROUND(
d.deal_value / tc.total_touches,
2
) AS attributed_revenue

FROM `multitouch-attribution-engine.marketing_attribution.customer_journey` cj

JOIN touch_counts tc
ON cj.customer_id = tc.customer_id

JOIN `multitouch-attribution-engine.marketing_attribution.deals` d
ON cj.customer_id = d.customer_id;