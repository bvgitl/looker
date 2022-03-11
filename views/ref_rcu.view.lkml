view: suivi_rcu {
  sql_table_name: `bv-prod.looker_pg.ref_rcu`
    ;;

  dimension: civilite {
    type: string
    sql: ${TABLE}.civilite ;;
    drill_fields: [sheet_client*]
  }

  dimension: Animateur {
    type: string
    sql: ${TABLE}.Animateur ;;
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

  dimension: phone {
    type: string
    sql: ${TABLE}.phone ;;
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

  dimension: code_mag {
    type: string
    sql: ${TABLE}.code_mag  ;;
    suggest_persist_for: "2 seconds"
    drill_fields: [sheet_client*]
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
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


  dimension: ca {
    type: number
    sql: ${TABLE}.ca_ttc ;;
    drill_fields: [sheet_client*]
  }

  measure: count_email {
    type: count_distinct
    sql: ${email_rcu} ;;
    drill_fields: [sheet_client*]
  }

  measure: count_telephone {
    type: count_distinct
    sql: case when ${cell_phone} is not null or ${phone} is not null then ${id_master} end  ;;
    drill_fields: [sheet_client*]
  }


  measure: count_contactable {
    type: count_distinct
    sql: case when ${email_rcu} is not null or ${cell_phone} is not null or ${phone} is not null then ${id_master} end  ;;
    drill_fields: [sheet_client*]
  }

  measure: count_master {
    type: count_distinct
    sql: ${id_master} ;;
    drill_fields: [sheet_client*]
  }

  measure: count_retail_seul{
    type: count_distinct
    sql: case when (${suivi_rcu.dt_creation_web_date} is null AND ${suivi_rcu.dt_creation_retail_date} is not null )
                  OR (${suivi_rcu.dt_creation_web_date} is null AND  ${suivi_rcu.dt_creation_retail_date} is null)
              then ${id_master}
              end ;;
    drill_fields: [sheet_client*]
  }

  measure: count_web_seul{
    type: count_distinct
    sql: case when (${suivi_rcu.dt_creation_web_date} is not null AND ${suivi_rcu.dt_creation_retail_date} is null )
              then ${id_master}
              end ;;
    drill_fields: [sheet_client*]
  }

  measure: count_mixt{
    type: count_distinct
    sql: case when (${suivi_rcu.dt_creation_web_date} is not null AND ${suivi_rcu.dt_creation_retail_date} is not null )
              then ${id_master}
              end ;;
    drill_fields: [sheet_client*]
  }


  measure: count {
    type: count
    drill_fields: [firstname, lastname,type_client,  email_rcu, cell_phone,civilite,dt_creation_retail_date,dt_creation_web_date,dt_last_purchase_date,optin_email,optin_sms,code_mag, Animateur]
  }

  set: sheet_client {
    fields: [firstname, lastname,type_client, email_rcu, cell_phone,civilite,dt_creation_retail_date,dt_creation_web_date,dt_last_purchase_date,optin_email,optin_sms,code_mag, Animateur]
  }

}
