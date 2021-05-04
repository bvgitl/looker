view: n1_division {
  sql_table_name: `bv-prod.Matillion_Perm_Table.N1_Division`
    ;;

  dimension: arbon1 {
    type: number
    sql: ${TABLE}.ARBON1 ;;
  }

  dimension: division {
    type: string
    sql: ${TABLE}.Division ;;
  }

  dimension: id_n1_division {
    type: number
    sql: ${TABLE}.ID_N1_DIVISION ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
