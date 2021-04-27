view: log_bcp {
  sql_table_name: `bv-prod.Matillion_Perm_Table.LOG_BCP`
    ;;

  dimension: datefichier {
    type: string
    sql: ${TABLE}.datefichier ;;
  }

  dimension: magasin {
    type: string
    sql: ${TABLE}.magasin ;;
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
