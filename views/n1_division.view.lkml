view: n1_division {
  sql_table_name: `ods.n1_division`
    ;;

  dimension: id_arbo {
    type: number
    sql: ${TABLE}.ID_ARBO ;;
  }

  dimension: id_n1_division {
    type: number
    sql: ${TABLE}.ID_N1_DIVISION ;;
  }

  dimension: libelle {
    type: string
    sql: ${TABLE}.LIBELLE ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
