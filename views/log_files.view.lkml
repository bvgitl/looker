view: log_files {
  sql_table_name: `bv-prod.Matillion_Perm_Table.LOG_FILES`
    ;;

  dimension: file_name {
    type: string
    sql: ${TABLE}.FILE_NAME ;;
  }

  measure: count {
    type: count
    drill_fields: [file_name]
  }
}
