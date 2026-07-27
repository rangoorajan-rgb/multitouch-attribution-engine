CREATE OR REPLACE VIEW
`multitouch-attribution-engine.marketing_attribution.last_touch_view`

AS

SELECT
    d.customer_id,
    cj.marketing_channel AS last_touch_channel,
    d.deal_stage,
    d.deal_value

FROM `multitouch-attribution-engine.marketing_attribution.deals` d

JOIN (

SELECT
    customer_id,
    marketing_channel,

    ROW_NUMBER() OVER(
        PARTITION BY customer_id
        ORDER BY touch_date DESC
    ) AS rn

FROM `multitouch-attribution-engine.marketing_attribution.customer_journey`

) cj

ON d.customer_id = cj.customer_id

WHERE rn = 1;