view: n2_famille {
  sql_table_name: `bv-prod.Matillion_Perm_Table.N2_Famille`
    ;;

  dimension: arbon1 {
    type: number
    sql: ${TABLE}.ARBON1 ;;
  }

  dimension: arbon2 {
    type: number
    sql: ${TABLE}.ARBON2 ;;
  }

  dimension: famille {
    type: string
    sql: ${TABLE}.Famille ;;
  }

  dimension: id_n1_division {
    type: number
    sql: ${TABLE}.ID_N1_DIVISION ;;
  }

  dimension: id_n2_famille {
    type: number
    sql: ${TABLE}.ID_N2_FAMILLE ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
