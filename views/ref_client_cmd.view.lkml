view: ref_client_cmd {
  sql_table_name: `bv-prod.looker_pg.ref_client_cmd`
    ;;

  dimension: ca {
    type: number
    sql: ${TABLE}.ca ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: dte_commande {
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
    sql: cast(${TABLE}.dte_commande as TIMESTAMP);;
  }

  dimension: format {
    type: string
    sql: ${TABLE}.Format ;;
  }

  dimension: total_commande {
    type: number
    sql: ${TABLE}.total_commande ;;
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
  }

  dimension: type_client_cmd {
    type: string
    sql: ${TABLE}.type_client_cmd ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
