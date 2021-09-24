view: log_bcp {
  sql_table_name: `bv-prod.Matillion_Perm_Table.LOG_BCP`
    ;;

  dimension: datefichier {
    type: string
    sql: ${TABLE}.magasin ;;
  }

  dimension: anneefichier {
    type: string
    sql: substring(${datefichier},1,4) ;;
  }

  dimension: moisfichier {
    type: string
    sql: ${TABLE}.magasin ;;
  }

  dimension: jourfichier {
    type: string
    sql: ${TABLE}.magasin ;;
  }

  dimension: magasin {
    type: string
    sql: ${TABLE}.datefichier ;;
  }

  dimension: nomfichier {
    type: string
    sql: ${TABLE}.nomfichier ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
