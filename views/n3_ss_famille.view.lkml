view: n3_ss_famille {
  sql_table_name: `bv-prod.Matillion_Perm_Table.N3_SS_Famille`
    ;;

  dimension: arbon2 {
    type: number
    sql: ${TABLE}.ARBON2 ;;
  }

  dimension: arbon3 {
    type: number
    sql: ${TABLE}.ARBON3 ;;
  }

  dimension: id_n2_famille {
    type: number
    sql: ${TABLE}.ID_N2_FAMILLE ;;
  }

  dimension: id_n3_ssfamille {
    type: number
    sql: ${TABLE}.ID_N3_SSFAMILLE ;;
  }

  dimension: sous_famille {
    type: string
    sql: ${TABLE}.SousFamille ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
