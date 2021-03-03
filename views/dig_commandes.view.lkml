view: dig_commandes {
  sql_table_name: `ods.dig_commandes`
    ;;

  dimension: code_client {
    type: string
    sql: ${TABLE}.Code_client ;;
  }

  dimension: code_commande {
    type: number
    sql: ${TABLE}.Code_commande ;;
  }

  dimension: code_magasin {
    type: string
    sql: ${TABLE}.Code_magasin ;;
  }

  dimension_group: date_de_commande {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.Date_de_commande ;;
  }

  dimension: email_du_client {
    type: string
    sql: ${TABLE}.Email_du_client ;;
  }

  dimension: montant_tv {
    type: number
    sql: ${TABLE}.Montant_TV ;;
  }

  dimension: nom_client {
    type: string
    sql: ${TABLE}.Nom_client ;;
  }

  dimension: prenom_client {
    type: string
    sql: ${TABLE}.Prenom_client ;;
  }

  dimension: statut {
    type: string
    sql: ${TABLE}.Statut ;;
  }

  dimension: tarif_ht_livraison {
    type: number
    sql: ${TABLE}.Tarif_HT_livraison ;;
  }

  dimension: tarif_ttc_livraison {
    type: number
    sql: ${TABLE}.Tarif_TTC_livraison ;;
  }

  dimension: total_ht {
    type: number
    sql: ${TABLE}.Total_HT ;;
  }

  dimension: total_tt {
    type: number
    sql: ${TABLE}.Total_TT ;;
  }

  dimension: type_de_livraison {
    type: string
    sql: ${TABLE}.Type_de_livraison ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
