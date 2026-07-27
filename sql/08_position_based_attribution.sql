CREATE OR REPLACE VIEW
`multitouch-attribution-engine.marketing_attribution.position_based_view`

AS

WITH journey AS (

SELECT
    customer_id,
    marketing_channel,
    touch_position,
    COUNT(*) OVER(PARTITION BY customer_id) AS total_touches

FROM `multitouch-attribution-engine.marketing_attribution.customer_journey`

)

SELECT

    j.customer_id,
    j.marketing_channel,
    d.deal_value,

    ROUND(

    CASE

        WHEN total_touches = 1 THEN
            d.deal_value

        WHEN total_touches = 2 THEN
            d.deal_value * 0.5

        WHEN touch_position = 1 THEN
            d.deal_value * 0.4

        WHEN touch_position = total_touches THEN
            d.deal_value * 0.4

        ELSE
            (d.deal_value * 0.2) / (total_touches - 2)

    END

    ,2) AS attributed_revenue

FROM journey j

JOIN
`multitouch-attribution-engine.marketing_attribution.deals` d

ON j.customer_id = d.customer_id;