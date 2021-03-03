view: all_emails {
  sql_table_name: `ods.all_emails`
    ;;

  dimension: code {
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: source {
    type: string
    sql: ${TABLE}.source ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
