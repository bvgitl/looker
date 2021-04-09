view: commandes {
  sql_table_name: `bv-prod.Matillion_Perm_Table.commandes`
    ;;

  dimension: canal_commande {
    type: string
    sql: ${TABLE}.Canal_commande ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }

  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: dte_cde {
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
    sql: ${TABLE}.dte_cde ;;
  }

  dimension: methode_livraison {
    type: string
    sql: ${TABLE}.methode_livraison ;;
  }

  dimension: numero_commande {
    type: number
    sql: ${TABLE}.numero_commande ;;
  }

  dimension: statut {
    type: string
    sql: ${TABLE}.statut ;;
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

  dimension: total_ttc {
    type: number
    sql: ${TABLE}.Total_TTC ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
