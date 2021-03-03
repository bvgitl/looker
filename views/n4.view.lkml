view: n4 {
  sql_table_name: `ods.n4`
    ;;

  dimension: id_arbo {
    type: number
    sql: ${TABLE}.ID_ARBO ;;
  }

  dimension: id_n3_ssfamille {
    type: number
    sql: ${TABLE}.ID_N3_SSFAMILLE ;;
  }

  dimension: id_n4_n4 {
    type: number
    sql: ${TABLE}.ID_N4_N4 ;;
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
