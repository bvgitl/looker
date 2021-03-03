view: n2_famille {
  sql_table_name: `ods.n2_famille`
    ;;

  dimension: id_arbo {
    type: number
    sql: ${TABLE}.ID_ARBO ;;
  }

  dimension: id_n1_division {
    type: number
    sql: ${TABLE}.ID_N1_DIVISION ;;
  }

  dimension: id_n2_famille {
    type: number
    sql: ${TABLE}.ID_N2_FAMILLE ;;
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
