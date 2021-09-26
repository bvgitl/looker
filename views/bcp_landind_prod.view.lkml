view: lob_bcp_landing {
  sql_table_name: `bv-prod.Matillion_Perm_Table.BCP_Landind_Prod`
    ;;

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }

  dimension: datefichier {
    type: string
    sql: ${TABLE}.date_fichier ;;
  }

  dimension: anneefichier {
    type: string
    sql: substring(${datefichier},1,4) ;;
  }

  dimension: moisfichier {
    type: string
    sql: substring(${datefichier},5,2) ;;
  }

  dimension: jourfichier {
    type: string
    sql: substring(${datefichier},7,4) ;;
  }

  dimension: nom_fichier {
    type: string
    sql: ${TABLE}.nom_fichier ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
