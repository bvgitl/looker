view: pdt_commandes_union {
  derived_table: {
    persist_for: "24 hours"
    sql:
      SELECT
        dig_produits_commandes.Code_produit AS cd_article
        , CAST(TIMESTAMP_TRUNC(dig_commandes.Date_de_commande, DAY) AS DATE) AS dte_vente
        , dig_produits_commandes.Quantite_commandee AS quantite
        , dig_produits_commandes.Total_ligne_HT AS total_ligne_ht
        , 'web' AS commande_origine

      FROM `bv-prod.ods.dig_produits_commandes` AS dig_produits_commandes

      LEFT JOIN `bv-prod.ods.dig_commandes` AS dig_commandes
        ON dig_produits_commandes.Code_commande = dig_commandes.Code_commande

      UNION ALL

      SELECT
        article.cd_article AS cd_article
        , tf_vente.DTE_VENTE AS dte_vente
        , tf_vente.QTITE AS quantite
        , tf_vente.CA_HT AS total_ligne_ht
        , 'total' AS commande_origine

      FROM `bv-prod.ods.tf_vente` AS tf_vente

      LEFT JOIN `bv-prod.ods.article` AS article ON tf_vente.id_article = article.id_article
      WHERE article.cd_article IS NOT NULL
   ;;
  }

  dimension: cd_article {
    type: string
    sql: ${TABLE}.cd_article ;;
  }

  dimension_group: dte_vente {
    type: time
    datatype: date
    timeframes: [
      date
      , week
      , month
      , quarter
      , year
    ]
    sql: ${TABLE}.dte_vente ;;
  }

  dimension: quantite {
    type: number
    sql: ${TABLE}.quantite ;;
  }

  dimension: total_ligne_ht {
    type: number
    sql: ${TABLE}.total_ligne_ht ;;
  }

  dimension: commande_origine {
    type: string
    sql: ${TABLE}.commande_origine ;;
  }

  measure: total_quantite {
    type: sum
    sql: ${quantite} ;;
  }

  measure: total_ca_ht {
    label: "Total CA HT (total)"
    type: sum
    value_format_name: eur_0
    sql: ${total_ligne_ht} ;;
    filters: [
      commande_origine: "total"
    ]
  }

  measure: total_ca_ht_web {
    label: "Total CA HT (Web)"
    type: sum
    value_format_name: eur_0
    sql: ${total_ligne_ht} ;;
    filters: [
      commande_origine: "web"
    ]
  }

  measure: ratio_ca_ht_web {
    label: "Ratio CA HT Web"
    type: number
    value_format_name: percent_2
    sql: 1.0*${total_ca_ht_web}/NULLIF(${total_ca_ht},0) ;;
  }

}
