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
    sql: substring(${datefichier},5,2) ;;
    }

  dimension: jourfichier {
    type: string
    sql: substring(${datefichier},7,4) ;;
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
