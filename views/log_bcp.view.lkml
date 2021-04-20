view: log_bcp {
  sql_table_name: `bv-prod.Matillion_Perm_Table.LOG_BCP`
    ;;

  dimension: nomfichier {
    type: string
    sql: ${TABLE}.nomfichier ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
