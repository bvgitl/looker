view: suivi_rcu {
  sql_table_name: `bv-prod.looker_pg.suivi_rcu`
    ;;

  dimension: civilite {
    type: string
    sql: ${TABLE}.civilite ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
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
    sql: cast(${TABLE}.dt_creation_retail as TIMESTAMP )  ;;
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
    sql: cast(${TABLE}.dt_creation_web as TIMESTAMP )  ;;
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
    sql: cast(${TABLE}.dt_last_purchase as TIMESTAMP )  ;;
  }

  dimension: email_rcu {
    type: string
    sql: ${TABLE}.email_rcu ;;
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
  }

  dimension: optin_sms {
    type: number
    sql: ${TABLE}.optin_sms ;;
  }

  dimension: store_code {
    type: string
    sql: case when ${TABLE}.store_code is not null ;;
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
  }

  dimension: anciennete_mois {
    type: number
    sql:  date_diff( current_date(), ${dt_creation_retail_date} , month )  ;;
  }


  measure: count {
    type: count
    drill_fields: [firstname, lastname]
  }
}
