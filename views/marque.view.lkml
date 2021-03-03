view: marque {
  sql_table_name: `ods.marque`
    ;;

  dimension: cd_marque {
    type: string
    sql: ${TABLE}.CD_MARQUE ;;
  }

  dimension: id_marque {
    type: number
    sql: ${TABLE}.ID_MARQUE ;;
  }

  dimension: lb_marque {
    type: string
    sql: ${TABLE}.LB_MARQUE ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
