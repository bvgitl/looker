view: dig_produits_commandes {
  sql_table_name: `ods.dig_produits_commandes`
    ;;

  dimension: code_commande {
    type: number
    sql: ${TABLE}.Code_commande ;;
  }

  dimension: code_ligne_commande {
    type: number
    sql: ${TABLE}.Code_ligne_commande ;;
  }

  dimension: code_produit {
    type: string
    sql: ${TABLE}.Code_produit ;;
  }

  dimension: montant_tva {
    type: number
    sql: ${TABLE}.Montant_TVA ;;
  }

  dimension: nom_du_produit {
    type: string
    sql: ${TABLE}.Nom_du_produit ;;
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

  dimension: total_ligne_ht {
    type: number
    sql: ${TABLE}.Total_ligne_HT ;;
  }

  dimension: total_ligne_ttc {
    type: number
    sql: ${TABLE}.Total_Ligne_TTC ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
