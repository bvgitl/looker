view: suivi_rcu {
  sql_table_name: `bv-prod.CRM_Stats.Suivi_RCU_Looker`
    ;;

  #dimension: civilite {
  #  type: string
  #  sql: case when ${TABLE}.civilite = 'MS' then 'Mme'
  #            when ${TABLE}.civilite = 'anonymousf30bd9e04a' then null
  #            else ${TABLE}.civilite end ;;
  #  drill_fields: [sheet_client*]
  #}


  dimension: Animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
    suggest_persist_for: "2 seconds"
    drill_fields: [sheet_client*]
  }

  dimension: Animateur_Fid {
    type: string
    sql: ${TABLE}.Fid_Animateur ;;
    suggest_persist_for: "2 seconds"
    drill_fields: [sheet_client*]
  }

  dimension: Carte_Fid {
    type: string
    sql: ${TABLE}.loyalty_id ;;
    drill_fields: [sheet_client*]
  }


  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
    drill_fields: [sheet_client*]
  }

  dimension: cell_phone {
    type: string
    sql: ${TABLE}.cell_phone ;;
    drill_fields: [sheet_client*]
  }

  dimension: validity_Fid {
    type: string
    sql: ${TABLE}.validity ;;
    drill_fields: [sheet_client*]
  }

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_creation_carte_fid {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: cast(${TABLE}.loyalty_date as DATE) ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_creation_retail {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: cast(${TABLE}.dt_creation_retail as DATE) ;;

    #case when ${TABLE}.dt_creation_retail is null
    #then  (if (${dt_creation_web_date}> ${dt_last_purchase_date}, ${dt_creation_web_date}, COALESCE (${dt_last_purchase_date}, ${dt_creation_web_date}) ))
    #else cast(${TABLE}.dt_creation_retail as DATE) end ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_creation_web {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: cast(${TABLE}.dt_creation_web as DATE )  ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_last_purchase {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: cast(${TABLE}.dt_last_purchase as DATE )  ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_optin {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: cast(${TABLE}.dt_optin as DATE )  ;;
    drill_fields: [sheet_client*]
  }


  dimension_group: dt_update_fusion {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: cast(${TABLE}.dt_update_fusion as DATE )  ;;
    drill_fields: [sheet_client*]
  }



  dimension: date_optin_email {
    type: string
    sql:case  when cast(${dt_update_fusion_date} as date) <  cast('2022-06-01' as date) or ${dt_update_fusion_date} is null  then "Avant 01/06/2022"
             when cast(${dt_update_fusion_date} as date)  >=  cast('2022-06-01' as date) then "Après 01/06/2022" end;;
    drill_fields: [sheet_client*]
    }

  dimension: vue_rgpd {
    type: yesno
    sql:  greatest(     coalesce( cast(dt_last_purchase as date), cast('1970-01-01' as date)),
                        coalesce( cast(dt_creation_retail as date), cast('1970-01-01' as date)),
                        coalesce( cast(dt_creation_web as date), cast('1970-01-01' as date)),
                        coalesce( cast(dt_optin as date), cast('1970-01-01' as date))
                          )
          >= DATE_SUB(date_trunc(current_date(),month), INTERVAL 36 month)  ;;

  }

  dimension: email_rcu {
    type: string
    sql: ${TABLE}.email_rcu ;;
    drill_fields: [sheet_client*]
  }

  dimension: firstname {
    type: string
    sql: ${TABLE}.firstname ;;
  }

  dimension: id_master {
    type: string
    primary_key: yes
    sql: ${TABLE}.id_master ;;
  }

  dimension: lastname {
    type: string
    sql: ${TABLE}.lastname ;;
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
    drill_fields: [sheet_client*]
  }

  dimension: optin_sms {
    type: string
    sql: ${TABLE}.optin_sms ;;
    drill_fields: [sheet_client*]
  }

  dimension: store_code{
    type: string
    sql: ${TABLE}.store_code  ;;
    suggest_persist_for: "2 seconds"
    drill_fields: [sheet_client*]
  }

  dimension: store_fid {
    type: string
    sql: ${TABLE}.store  ;;
    suggest_persist_for: "2 seconds"
    drill_fields: [sheet_client*]
  }

  dimension: store_name_fid {
    type: string
    sql: ${TABLE}.store_name  ;;
    suggest_persist_for: "2 seconds"
    drill_fields: [sheet_client*]
  }

  # dimension: CD_Magasin {
  #   type: string
  #   sql: ${TABLE}.CD_Magasin ;;
  #   suggest_persist_for: "2 seconds"
  #   drill_fields: [sheet_client*]
  # }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    drill_fields: [sheet_client*]
  }

  dimension: type_client2 {
    type: string
    sql: ${TABLE}.type_client2 ;;
    drill_fields: [sheet_client*]
  }


  dimension: anciennete_mois_web {
    type: number
    sql: date_diff( current_date(), ${dt_creation_web_date} , month ) ;;
    drill_fields: [sheet_client*]
  }

  dimension: anciennete_mois {
    type: number
    sql: date_diff( current_date(), ${dt_creation_retail_date} , month ) ;;
    drill_fields: [sheet_client*]
  }

  dimension: flag_36_mois_retail {
    type: number
    sql: case when date_diff(current_date(), ${dt_creation_retail_date}, month) <= 36 then 1 else 0 end   ;;
    drill_fields: [sheet_client*]
  }

  dimension: flag_36_mois_achat {
    type: number
    sql: case when date_diff(current_date(), ${dt_last_purchase_date}, month) <= 36 then 1 else 0 end   ;;
    drill_fields: [sheet_client*]
  }

  dimension: type_client_rcu {
    type:  string
    sql: case when (${dt_creation_web_date} is null AND ${dt_creation_retail_date} is not null )
                  OR (${dt_creation_web_date} is null AND  ${dt_creation_retail_date} is null)
              then "Retail seul"
         when (${dt_creation_web_date} is not null AND ${dt_creation_retail_date} is null )
              then "Web seul"
         when (${dt_creation_web_date} is not null AND ${dt_creation_retail_date} is not null )
              then "Mixte"
              end;;
  }


  measure: count_carte_fid {
    type: count_distinct
    sql: ${Carte_Fid} ;;
    drill_fields: [sheet_client*]
  }

  measure: count_store_fid {
    type: count_distinct
    sql: ${store_fid} ;;
    drill_fields: [sheet_client*]
  }

  measure: count_email {
    type: count_distinct
    sql: case when ${email_rcu} is not null  then ${id_master} end ;;
    drill_fields: [sheet_client*]
  }

  measure: count_telephone {
    type: count_distinct
    sql: case when( ${cell_phone} is not null or ${phone} is not null ) then ${id_master} end  ;;
    drill_fields: [sheet_client*]
  }


  measure: count_contactable {
    type: count_distinct
    sql: case when (${email_rcu} is not null or ${cell_phone} is not null or ${phone} is not null ) then ${id_master} end  ;;
    drill_fields: [sheet_client*]
  }


  measure: count_optin_email_avant {
    type: count_distinct
    sql: case when (${email_rcu} is not null and ${optin_email} = 'true' and ${date_optin_email} = "Avant 01/06/2022" ) then ${id_master} end  ;;
    drill_fields: [sheet_client*]

  }

  measure: count_optin_email_apres {
    type: count_distinct
    sql: case when (${email_rcu} is not null and ${optin_email} = 'true' and ${date_optin_email} = "Après 01/06/2022" ) then ${id_master} end  ;;
    drill_fields: [sheet_client*]

  }

  measure: count_optin_email {
    type: count_distinct
    sql: case when ( ${email_rcu} is not null and ${optin_email} = 'true')  then ${id_master} end  ;;
    drill_fields: [sheet_client*]

  }

  measure: count_optin_sms {
    type: count_distinct
    sql: case when( ${cell_phone} is not null or ${phone} is not null ) and ${optin_sms} = 'true'  then ${id_master} end  ;;
    drill_fields: [sheet_client*]

  }

  measure: count_optin_total {
    type: count_distinct
    sql: case when  ( ${email_rcu} is not null and ${optin_email} = 'true') or  ( ( ${cell_phone} is not null or ${phone} is not null ) and ${optin_sms} = 'true' ) then ${id_master} end  ;;
    drill_fields: [sheet_client*]


  }

  measure: count_master {
    type: count_distinct
    sql: ${id_master} ;;
    drill_fields: [sheet_client*]
  }

  measure: count_retail_seul{
    type: count_distinct
    sql: case when ${dt_creation_web_date} is null AND ${dt_creation_retail_date} is not null
              then ${id_master}
              end ;;
    drill_fields: [sheet_client*]
  }
  # measure: count_multi_retail{
  #   type: count_distinct
  #   sql: case when  ((${suivi_rcu.dt_creation_web_date} is null AND ${suivi_rcu.dt_creation_retail_date} is not null )
  #                 OR (${suivi_rcu.dt_creation_web_date} is null AND  ${suivi_rcu.dt_creation_retail_date} is null) )
  #                 and ${code_mag_2} is not null
  #             then ${id_master}
  #             end ;;
  #   drill_fields: [sheet_client*]
  # }

  measure: count_web_seul{
    type: count_distinct
    sql: case when (${dt_creation_web_date} is not null AND ${dt_creation_retail_date} is null )
              then ${id_master}
              end ;;
    drill_fields: [sheet_client*]
  }

  measure: count_mixt{
    type: count_distinct
    sql: case when (${dt_creation_web_date} is not null AND ${dt_creation_retail_date} is not null )
              then ${id_master}
              end ;;
    drill_fields: [sheet_client*]
  }


  measure: count {
    type: count
    #drill_fields: [firstname, lastname,type_client,  email_rcu, cell_phone,civilite,dt_creation_retail_date,dt_creation_web_date,dt_last_purchase_date,optin_email,optin_sms,store_code, Animateur]
    drill_fields: [firstname, lastname,type_client,  email_rcu, cell_phone,dt_creation_retail_date,dt_creation_web_date,dt_last_purchase_date,optin_email,optin_sms,store_code, Animateur]
  }

  set: sheet_client {
    #fields: [firstname, lastname,type_client, email_rcu, cell_phone,civilite,dt_creation_retail_date,dt_creation_web_date,dt_last_purchase_date,optin_email,optin_sms,store_code, Animateur]
    fields: [firstname, lastname,type_client, email_rcu, cell_phone,dt_creation_retail_date,dt_creation_web_date,dt_last_purchase_date,optin_email,optin_sms,store_code, Animateur]
  }

}
