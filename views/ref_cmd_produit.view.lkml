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

  dimension: date_cmd_periode{
    case: {
      when: {
        sql:  ${dte_commande_year} = 2019;;
        label: "2019"
      }
      when: {
        sql:   ${dte_commande_year} = 2020;;
        label: "2020"
      }
      when: {
        sql:   ${dte_commande_year} = 2021;;
        label: "2021"
      }
      # when: {
      #   sql:  ${date_creation_year} = 2022;;
      #   label: "2022"
      # }

      when: {
        sql: date_diff(current_date(),${dte_commande_month}, month) <= 12 ;;
        label: "12 deniers mois"
      }

      when: {
        sql: date_diff(current_date(),${dte_commande_month}, month) <= 36 ;;
        label: "36 deniers mois"
      }
      when: {
        sql: (extract(month from  ${dte_commande_date}) =  extract(month from date_sub(current_date( ) , interval 1 month) ))
          and (   ${dte_commande_year} = extract(year from current_date() ) );;
        label: "Mois précédent"
      }
    }
    suggest_persist_for: "2 seconds"
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

  measure: somme_article {
   type: sum
   drill_fields: [sheet_client*]
   sql: ${nb_article} ;;
  }

  measure: somme_ref {
    type: sum
    drill_fields: [sheet_client*]
    sql: ${nb_ref_produit} ;;
  }

  measure: moy_article_cmd {
    type: number
    drill_fields: [sheet_client*, nb_article]
    sql:  ${somme_article} / ${cmd_count} ;;
  }

  measure: moy_article_par_client {
    type: number
    drill_fields: [sheet_client*, nb_article]
    sql:  ${somme_article} / ${customer_count} ;;
  }

  measure: moy_reference_cmd {
    type: number
    drill_fields: [sheet_client*, nb_article]
    sql:  ${somme_ref} / ${cmd_count} ;;
  }

  measure: moy_reference_client {
    type: number
    drill_fields: [sheet_client*, nb_article]
    sql:  ${somme_ref} / ${customer_count} ;;
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
