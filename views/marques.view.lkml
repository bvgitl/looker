view: marques {
  sql_table_name: `bv-prod.Matillion_Perm_Table.Marques`
    ;;

  dimension: cd_fabricant {
    type: string
    sql: ${TABLE}.CD_MARQUE ;;
  }

  dimension: id_fabricant {
    type: number
    sql: ${TABLE}.ID_MARQUE ;;
  }

  dimension: lb_fabricant {
    type: string
    sql: ${TABLE}.LB_MARQUE ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
