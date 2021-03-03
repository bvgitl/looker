view: dataquality_tf_vente2020_donnees_remontees {
  sql_table_name: `ods.dataquality_tf_vente2020_donneesRemontees`
    ;;

  dimension: ca_net {
    type: number
    sql: ${TABLE}.CA_NET ;;
  }

  dimension: ca_net_median {
    type: number
    sql: ${TABLE}.CA_NET_median ;;
  }

  dimension_group: dte_vente {
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
    sql: ${TABLE}.DTE_VENTE ;;
  }

  dimension: flag_ecart_ca_netremonte {
    type: number
    sql: ${TABLE}.Flag_EcartCA_NETremonte ;;
  }

  dimension: flag_ecart_nb_ligne_remonte {
    type: number
    sql: ${TABLE}.Flag_EcartNbLigne_remonte ;;
  }

  dimension: flag_jour_remontee {
    type: number
    sql: ${TABLE}.flag_jour_remontee ;;
  }

  dimension: id_magasin {
    type: number
    sql: ${TABLE}.ID_MAGASIN ;;
  }

  dimension: nb_lignes_article {
    type: number
    sql: ${TABLE}.nb_lignes_article ;;
  }

  dimension: nb_lignes_article_median {
    type: number
    sql: ${TABLE}.nb_lignes_article_median ;;
  }

  dimension: ratio_ca_net {
    type: number
    sql: ${TABLE}.ratio_CA_NET ;;
  }

  dimension: ratio_nb_ligne {
    type: number
    sql: ${TABLE}.ratio_nb_ligne ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
