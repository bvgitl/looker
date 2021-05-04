view: four_dwh {
  sql_table_name: `bv-prod.Matillion_Perm_Table.FOUR_DWH`
    ;;

  dimension: c_fournisseur {
    type: number
    sql: ${TABLE}.c_Fournisseur ;;
  }

  dimension: c_fournisseur_robinson {
    type: string
    sql: ${TABLE}.c_Fournisseur_robinson ;;
  }

  dimension: c_fournisseur_xmag {
    type: string
    sql: ${TABLE}.c_Fournisseur_xmag ;;
  }

  dimension: l_fournisseur {
    type: string
    sql: ${TABLE}.l_Fournisseur ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
