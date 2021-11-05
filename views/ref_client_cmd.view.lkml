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
    drill_fields: [sheet_client_cmd*]
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
    drill_fields: [sheet_client_cmd*]
  }

  dimension: type_client_cmd {
    type: string
    sql: ${TABLE}.type_client_cmd ;;
    drill_fields: [sheet_client_cmd*]
  }

  measure: Volume {
    drill_fields: [sheet_client_cmd*]
    type: count_distinct
    sql: ${TABLE}.customer_id ;;

  }

  set :sheet_client_cmd {
    fields:  [customer_id, ref_client_mag.civilite, ca,format,total_commande,type_client]
  }
}
