view: ref_cmd_produit {
  sql_table_name: `bv-prod.looker_pg.ref_cmd_produit`
    ;;

  #drill_fields: [cd_commande,ca,count,customer_id,dte_commande_date,cd_magasin,format,type_client,nb_article,nb_ref_produit]

  dimension: ca {
    type: number
    sql: ${TABLE}.ca ;;
    drill_fields: [sheet_client*]
  }

  dimension: cd_commande {
    type: string
    sql: ${TABLE}.cd_commande ;;
    primary_key: yes
    drill_fields: [sheet_client*]
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
    drill_fields: [sheet_client*]
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
    drill_fields: [sheet_client*]
  }

  dimension: canal_commande {
    type: string
    sql: ${TABLE}.Canal_commande ;;
    drill_fields: [sheet_client*]
  }

  dimension: statut {
    type: string
    sql: ${TABLE}.statut ;;
    drill_fields: [sheet_client*]
    suggest_persist_for: "2 seconds"
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
    sql: cast (${TABLE}.dte_commande as TIMESTAMP);;
    drill_fields: [sheet_client*]
  }

  dimension: format {
    type: string
    sql: ${TABLE}.Format;;
    drill_fields: [sheet_client*]
    suggest_persist_for: "2 seconds"
  }

  dimension: coord {
    type: location
    map_layer_name: my_map
    sql_latitude: ${TABLE}.Latitude ;;
    sql_longitude: ${TABLE}.Longitude ;;
    drill_fields: [sheet_client*]

  }

  dimension: latitude {
    type: string
    sql: ${TABLE}.Latitude ;;
    drill_fields: [sheet_client*]
  }

  dimension: longitude {
    type: string
    sql: ${TABLE}.Longitude ;;
    drill_fields: [sheet_client*]
  }

  dimension: methode_livraison {
    type: string
    sql: ${TABLE}.methode_livraison ;;
    drill_fields: [sheet_client*]
    suggest_persist_for: "2 seconds"
  }

  dimension: nb_article {
    type: number
    sql: ${TABLE}.nb_article ;;
    drill_fields: [sheet_client*]
  }

  dimension: nb_ref_produit {
    type: number
    sql: ${TABLE}.nb_ref_produit ;;
    drill_fields: [sheet_client*]
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
    drill_fields: [sheet_client*]
  }

  dimension: optin_sms {
    type: string
    sql: ${TABLE}.optin_sms ;;
    drill_fields: [sheet_client*]
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    drill_fields: [sheet_client*]
    suggest_persist_for: "2 seconds"
  }

  measure: customer_count {
    type: count_distinct
    drill_fields: [sheet_client*]
    sql:  ${TABLE}.customer_id ;;
  }

  measure: cmd_count {
    type: count_distinct
    drill_fields: [sheet_client*]
    sql:  ${TABLE}.cd_commande ;;
  }

  measure: somme_ca {
    type: sum
    drill_fields: [sheet_client*]
    sql:  ${TABLE}.ca ;;
  }

  measure: ca_client {
    type: number
    drill_fields: [sheet_client*]
    sql:  ${somme_ca} / ${customer_count} ;;
  }

  measure: pm_client {
    type: number
    drill_fields: [sheet_client*]
    sql:  ${somme_ca} / ${cmd_count} ;;
  }

  measure: freq_achat {
    type: number
    drill_fields: [sheet_client*]
    sql:  ${cmd_count} / ${customer_count} ;;
  }

  measure: moy_article {
    type: average
    drill_fields: [sheet_client*, nb_article]
    sql:  ${TABLE}.nb_article ;;
  }

  measure: moy_article_par_client {
      type: average_distinct
      sql_distinct_key: ${customer_id} ;;
      sql: ${nb_article} ;;
  }

  measure: moy_reference {
    type: average
    drill_fields: [sheet_client*, nb_ref_produit]
    sql:  ${TABLE}.nb_ref_produit ;;
  }

  measure: cat_cmd_client {
    type: string
    drill_fields: [sheet_client*]
    sql:
      CASE
        WHEN ${cmd_count} = 1  THEN  "Petit"
        WHEN ${cmd_count} = 2  THEN  "Moyen"
        when ${cmd_count} >= 3 THEN  "Gros"
        END;;
  }


  set :sheet_client {
  fields:  [cd_commande,cd_magasin,customer_id,dte_commande_date,format,
    methode_livraison,type_client,canal_commande, statut]
  }
}
