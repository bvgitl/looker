view: art_arbo_dwh {
  sql_table_name: `bv-prod.Matillion_Perm_Table.ART_ARBO_DWH`
    ;;

  dimension: c_arbre {
    type: number
    sql: ${TABLE}.c_arbre ;;
  }

  dimension: c_article {
    type: string
    sql: ${TABLE}.c_article ;;
  }

  dimension: c_noeud {
    type: number
    sql: ${TABLE}.c_noeud ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
