view: log_bcp_vue {
  sql_table_name: `bv-prod.Matillion_Perm_Table.LOG_BCP_VUE`
    ;;

  dimension: filedate {
    type: string
    sql: ${TABLE}.filedate ;;
  }

  dimension: filename {
    type: string
    sql: ${TABLE}.filename ;;
  }

  dimension: magasin {
    type: string
    sql: ${TABLE}.magasin ;;
  }

  measure: count {
    type: count
    drill_fields: [filename]
  }
}
