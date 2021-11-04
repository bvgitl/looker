view: factu_campagne {
  sql_table_name: `bv-prod.looker_pg.factu_campagne`
    ;;

  dimension: camp_name {
    type: string
    sql: ${TABLE}.camp_name ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: dte_camp {
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
    sql: ${TABLE}.dte_camp ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
  }

  dimension: store_code {
    type: string
    sql: ${TABLE}.store_code ;;
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
  }

  measure: count {
    type: count
    drill_fields: [camp_name]
  }
}
