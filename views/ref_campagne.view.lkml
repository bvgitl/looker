view: ref_campagne {
  sql_table_name: `bv-prod.looker_pg.ref_campagne`
    ;;

  drill_fields: [bounce_type,camp_id,camp_name,category_id,category_name,customer_id,email_address,type_client]

  dimension: bounce_type {
    type: string
    sql: ${TABLE}.bounce_type ;;
  }

  dimension: camp_id {
    type: string
    sql: ${TABLE}.camp_id ;;
  }

  dimension: camp_name {
    type: string
    sql: ${TABLE}.camp_name ;;
  }

  dimension: category_id {
    type: string
    sql: ${TABLE}.category_id ;;
  }

  dimension: category_name {
    type: string
    sql: ${TABLE}.category_name ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
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
    sql: ${TABLE}.dt_bounce_time ;;
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
    sql: ${TABLE}.dt_click_time ;;
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
    sql: ${TABLE}.dt_send_time ;;
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
    sql: ${TABLE}.dt_unsub_time ;;
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
    sql: ${TABLE}.dte_open ;;
  }

  dimension: email_address {
    type: string
    sql: ${TABLE}.email_address ;;
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
  }

  measure: count {
    type: count
    drill_fields: [category_name, camp_name]
  }
}
