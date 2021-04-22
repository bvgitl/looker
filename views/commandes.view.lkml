view: commandes {
  sql_table_name: `bv-prod.Matillion_Perm_Table.COMMANDES`
    ;;

  dimension: canal_commande {
    type: string
    sql: ${TABLE}.Canal_commande ;;
  }

  dimension: cd_commande {
    type: string
    sql: ${TABLE}.cd_commande ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: dte_commande {
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
    sql: ${TABLE}.dte_commande ;;
  }

  dimension: methode_livraison {
    type: string
    sql: ${TABLE}.methode_livraison ;;
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
