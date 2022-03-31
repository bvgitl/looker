view: derived_ga2 {
  derived_table: {
    sql: with analytics as (
      select
          cast (concat( substring(event_date, 1,4), '-', substring(event_date, 5,2) , '-', substring(event_date, 7,2) )as date) as event_date,
          event_timestamp,
          event_name, event_params, event_previous_timestamp,
          event_value_in_usd, event_bundle_sequence_id, event_server_timestamp_offset,
          user_id, user_pseudo_id, privacy_info, user_properties, user_first_touch_timestamp,
          user_ltv, device, geo, app_info, traffic_source, stream_id,
          platform,event_dimensions, ecommerce, items

      from `bv-prod.analytics_265583599.*`
      order by event_date desc
      )

      select
      name,
      count(distinct session_id) as session,
      sum(nouvelle_session) as nouvelle_session,
      count(distinct case when session_engaged = '1' then session_id end) as engaged_sessions,
      round(sum(purchase_revenue), 2)  as CA,
      concat( round( count(distinct transaction_id) / count(distinct session_id)*100, 2) , ' %') as taux_conversion,
      concat( round(  count(distinct case when session_engaged = '1' then session_id end) / count(distinct session_id)*100, 2) , ' %') as taux_engagement

      from (
      select
      traffic_source.name,
      case when event_name = 'first_visit' then 1 else 0 end as nouvelle_session,
      case when ecommerce.purchase_revenue > 0 then 1 else 0 end as achat,
      ecommerce.transaction_id,
      ecommerce.purchase_revenue ,

      (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
      max((select value.string_value from unnest(event_params) where key = 'session_engaged')) as session_engaged,

      from analytics
      where (traffic_source.medium in ('CRM-email', 'email-interne','email', 'CRM_email')
      and  traffic_source.source not in ('gevttfe', 'adesrv','beffei'))
      group by  session_id, traffic_source.name, ecommerce.purchase_revenue, event_name, ecommerce.transaction_id--, event_date -- event_name,traffic_source.name,, user_pseudo_id, ecommerce.transaction_id, ecommerce.purchase_revenue, event_date
      )

      group by  name -- event_date--,name --, medium, source_

      order by name --, name
      ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: name {
    primary_key: yes
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: session {
    type: number
    sql: ${TABLE}.session ;;
  }

  dimension: nouvelle_session {
    type: number
    sql: ${TABLE}.nouvelle_session ;;
  }

  dimension: engaged_sessions {
    type: number
    sql: ${TABLE}.engaged_sessions ;;
  }

  dimension: ca {
    type: number
    sql: ${TABLE}.CA ;;
  }

  dimension: taux_conversion {
    type: string
    sql: ${TABLE}.taux_conversion ;;
  }

  dimension: taux_engagement {
    type: string
    sql: ${TABLE}.taux_engagement ;;
  }

  set: detail {
    fields: [
      name,
      session,
      nouvelle_session,
      engaged_sessions,
      ca,
      taux_conversion,
      taux_engagement
    ]
  }
}
