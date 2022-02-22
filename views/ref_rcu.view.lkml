view: suivi_rcu {
  sql_table_name: `bv-prod.looker_pg.ref_rcu`
    ;;

  dimension: civilite {
    type: string
    sql: ${TABLE}.civilite ;;
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
    sql: case when ${TABLE}.dt_creation_retail is null
        then  (if (${dt_creation_web_date}> ${dt_last_purchase_date}, ${dt_creation_web_date}, COALESCE (${dt_last_purchase_date}, ${dt_creation_web_date}) ))
        else cast(${TABLE}.dt_creation_retail as DATE) end ;;
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
    type: number
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


  measure: count {
    type: count
    drill_fields: [firstname, lastname,type_client,  email_rcu, cell_phone,civilite,dt_creation_retail_date,dt_creation_web_date,dt_last_purchase_date,optin_email,optin_sms,code_mag]
  }

  set: sheet_client {
    fields: [firstname, lastname,type_client, email_rcu, cell_phone,civilite,dt_creation_retail_date,dt_creation_web_date,dt_last_purchase_date,optin_email,optin_sms,code_mag]
  }

}
