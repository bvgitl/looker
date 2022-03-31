view: test_ga2 {
  sql_table_name: `bv-prod.looker_pg.test_GA2`
    ;;

  dimension: ca {
    type: number
    sql: ${TABLE}.CA ;;
  }

  dimension: name {
    primary_key: yes
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: session {
    type: number
    sql: ${TABLE}.session ;;
  }

  measure: count {
    type: count
    drill_fields: [name]
  }
}
