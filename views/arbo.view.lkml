view: arbo {
  sql_table_name: `ods.arbo`
    ;;

  dimension: id_arbo {
    type: number
    sql: ${TABLE}.ID_ARBO ;;
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
