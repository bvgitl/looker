view: derived_ga4 {
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
        case when name = 'Pro2' and camp_type ='Email'
        then 'Email_Pro_2_190122'
        when name = 'fevrier1-part' and camp_type ='Email'
        then 'Email_Cartouches_PART_020222'
        when name = 'fevrier1-pro' and camp_type ='Email'
        then 'Email_Cartouches_PRO_020222'
        when name = 'demenagement-Andrezieux' and camp_type ='Email'
        then 'Email_Local_Andrezieux_déménagement_271021'
        when name = 'trigger_reste_engage_PART' and camp_type ='Email'
        then 'trigger_je-reste_engage_PART_120122'
        when name = 'trigger_reste_engage_PRO' and camp_type ='Email'
        then 'trigger_je-reste_engage_PRO'
        when name = 'trigger_mag_informe' and camp_type ='Email'
        then 'trigger_mon_magasin_m_informe_connecte'
        when name = 'trigger_mag_minforme' and camp_type ='Email'
        then 'trigger_mon_magasin_m_informe_connecte'
        when name = 'trigger_1_decouvre_univers_PRO' and camp_type ='Email'
        then  'trigger_je_découvre_univers_bv_pros_tc'
        when name ='trigger_1_decouvre_univers_PART' and camp_type ='Email'
        then 'trigger_je_découvre_univers_bv_part_tc'
        when name ='Triger8Upsell_cartouche' and camp_type ='Email'
        then 'Trigger_Upsell_cartouche'
        when name ='Trigger_crossell' and camp_type ='Email'
        then 'trigger_cross_sell'
        when name ='trigger_upsell_ink' and camp_type ='Email'
        then 'Trigger_Upsell_cartouche'
        when name = 'novembre_BLACK-GREEN' and camp_type ='Email'
        then 'Email_Novembre_Black Friday_201122_Email_Novembre_Black Friday_201122_Magasin'
        when name = 'decembre_NOEL' and camp_type ='Email'
        then 'Email_Novembre_Noel_281122_Magasin_Email_Novembre_Noel_281122_Magasin_Magasin_Horaire1'
        when name = 'janvier1_TVAofferte' and camp_type ='Email'
        then 'Email_Janvier1_TVA_offerte_020123_V2_Email_Janvier1_TVA_offerte_020123_V2_horaire1'
        when name = 'janvier2_prixcoutant' and camp_type ='Email'
        then 'Email_Janvier_Prix_coutant_160123​_Email_Janvier_Prix_coutant_160123​_Magasin'
        when name = 'fevrier1_prixcoutant' and camp_type ='Email'
        then 'Email_fevrier_prix_coutant_300123'
        when name = 'janvier-2' and camp_type ='SMS'
        then 'SMS_janvier3_PrixCoutant_160123'
        when name = 'mai2_Impression' and camp_type ='Email'
        then '150523_OpeNationale_mai2'
        else name end as name,

        count(distinct session_id) as session,
        sum(nouvelle_session) as nouvelle_session,
        count(distinct case when session_engaged = '1' then session_id end) as engaged_sessions,
        round(sum(purchase_revenue), 2)  as CA,
        count(distinct transaction_id) as nb_conversion,
        concat( round( count(distinct transaction_id) / count(distinct session_id)*100, 2) , ' %') as taux_conversion,
        concat( round(  count(distinct case when session_engaged = '1' then session_id end) / count(distinct session_id)*100, 2) , ' %') as taux_engagement

        from (
        select
        traffic_source.name,
        case when event_name = 'first_visit' then 1 else 0 end as nouvelle_session,
        case when ecommerce.purchase_revenue > 0 then 1 else 0 end as achat,
        case when traffic_source.medium in ('CRM-email', 'email-interne','email', 'CRM_email') then 'Email'
             when traffic_source.medium in ('CRM-sms', 'SMS-interne','SMS', 'CRM_sms','sms') then 'SMS' end as camp_type,
        ecommerce.transaction_id,
        ecommerce.purchase_revenue ,

        (select value.int_value from unnest(event_params) where key = 'ga_session_id') as session_id,
        max((select value.string_value from unnest(event_params) where key = 'session_engaged')) as session_engaged,

        from analytics
        where traffic_source.medium not in ('gevttfe', 'adesrv','beffei')
        group by  session_id, traffic_source.name, ecommerce.purchase_revenue, event_name, ecommerce.transaction_id, traffic_source.medium--, event_date -- event_name,traffic_source.name,, user_pseudo_id, ecommerce.transaction_id, ecommerce.purchase_revenue, event_date
        )

        group by  name -- event_date--,name --, medium, source_

        order by name  --, name

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

    dimension: nb_conversion {
      type: number
      sql: ${TABLE}.nb_conversion ;;
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
        nb_conversion,
        taux_conversion,
        taux_engagement
      ]
    }
  }
