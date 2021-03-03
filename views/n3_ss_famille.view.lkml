view: n3_ss_famille {
  sql_table_name: `ods.n3_ss_famille`
    ;;

  dimension: id_arbo {
    type: number
    sql: ${TABLE}.ID_ARBO ;;
  }

  dimension: id_n2_famille {
    type: number
    sql: ${TABLE}.ID_N2_FAMILLE ;;
  }

  dimension: id_n3_ssfamille {
    type: number
    sql: ${TABLE}.ID_N3_SSFAMILLE ;;
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
