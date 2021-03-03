view: dig_clients_connexions {
  sql_table_name: `ods.dig_clients_connexions`
    ;;

  dimension: code_client {
    type: number
    sql: ${TABLE}.Code_Client ;;
  }

  dimension_group: date_de_connexion {
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
    sql: ${TABLE}.Date_de_connexion ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
