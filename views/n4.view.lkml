view: n4 {
  sql_table_name: `bv-prod.Matillion_Perm_Table.N4`
    ;;

  dimension: arbon3 {
    type: number
    sql: ${TABLE}.ARBON3 ;;
  }

  dimension: arbon4 {
    type: number
    sql: ${TABLE}.ARBON4 ;;
  }

  dimension: id_n3_ssfamille {
    type: number
    sql: ${TABLE}.ID_N3_SSFAMILLE ;;
  }

  dimension: id_n4_n4 {
    type: number
    sql: ${TABLE}.ID_N4_N4 ;;
  }

  dimension: niveau4 {
    type: string
    sql: ${TABLE}.Niveau4 ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
