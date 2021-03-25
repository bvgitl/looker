view: produit_commande {
  sql_table_name: `bv-prod.Matillion_Perm_Table.produit_commande`
    ;;

  dimension: cd_commande {
    type: string
    sql: ${TABLE}.cd_commande ;;
  }

  dimension: cd_produit {
    type: string
    sql: ${TABLE}.cd_produit ;;
  }

  dimension: quantite_commandee {
    type: number
    sql: ${TABLE}.Quantite_commandee ;;
  }

  dimension: tarif_produit_ht {
    type: number
    sql: ${TABLE}.Tarif_Produit_HT ;;
  }

  dimension: tarif_produit_ttc {
    type: number
    sql: ${TABLE}.Tarif_Produit_TTC ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
