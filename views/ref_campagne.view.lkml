view: ref_campagne {
  sql_table_name: `bv-prod.looker_pg.ref_campagne`
    ;;

  #drill_fields: [bounce_type,camp_id,camp_name,category_id,category_name,customer_id,email_address,type_client]

  dimension: bounce_type {
    type: string
    sql: ${TABLE}.bounce_type ;;
    drill_fields: [sheet_client*]
  }

  dimension: camp_id {
    type: string
    sql: ${TABLE}.camp_id ;;
    drill_fields: [sheet_client*]
  }

  dimension: camp_name {
    type: string
    sql: ${TABLE}.camp_name ;;
    drill_fields: [sheet_client*]
  }

  dimension: category_id {
    type: string
    sql: ${TABLE}.category_id ;;
    drill_fields: [sheet_client*]
  }

  dimension: category_name {
    type: string
    sql: ${TABLE}.category_name ;;
    drill_fields: [sheet_client*]
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_bounce {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: cast(${TABLE}.dt_bounce_time as TIMESTAMP) ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_click {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: cast (${TABLE}.dt_click_time as TIMESTAMP ) ;;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_send {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: cast(${TABLE}.dt_send_time as TIMESTAMP);;
    drill_fields: [sheet_client*]
  }

  dimension_group: dt_unsub {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: cast(${TABLE}.dt_unsub_time as TIMESTAMP);;
    drill_fields: [sheet_client*]
  }

  dimension_group: dte_open {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: cast(${TABLE}.dte_open as TIMESTAMP) ;;
    drill_fields: [sheet_client*]
  }

  dimension: email_address {
    type: string
    sql: ${TABLE}.email_address ;;
    drill_fields: [sheet_client*]
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    drill_fields: [sheet_client*]
  }

  measure: count {
    type: count
    drill_fields: [sheet_client*]
  }

  measure: count_volume_email {
    type: count_distinct
    drill_fields: [sheet_client*]
    sql: ${TABLE}.email_address ;;
  }

  measure: count_volume_bounce {
    type: count_distinct
    drill_fields: [sheet_client*]
    sql: CASE
         WHEN ${dt_bounce_date} is not null
         THEN ${TABLE}.email_address
         END;;
  }




  set: sheet_client {
    fields: [bounce_type,camp_id,camp_name,category_id,category_name,customer_id,email_address,type_client]
  }
}
