view: ref_cmd_produit {
  sql_table_name: `bv-prod.looker_pg.ref_cmd_produit`
    ;;
  drill_fields: [customer_id,ca,cd_commande,cd_magasin,cd_produit,dte_commande_date,
    type_client,format,methode_livraison,optin_email,quantite_commandee]

  dimension: ca {
    type: number
    sql: ${TABLE}.ca ;;
  }

  dimension: cd_commande {
    type: string
    sql: ${TABLE}.cd_commande ;;
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }

  dimension: cd_produit {
    type: string
    sql: ${TABLE}.cd_produit ;;
  }

  dimension: customer_id {
    type: string
    primary_key: yes
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

  dimension: format {
    type: string
    sql: ${TABLE}.Format ;;
  }

  dimension: methode_livraison {
    type: string
    sql: ${TABLE}.methode_livraison ;;
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
  }

  dimension: optin_sms {
    type: string
    sql: ${TABLE}.optin_sms ;;
  }

  dimension: quantite_commandee {
    type: number
    sql: ${TABLE}.Quantite_commandee ;;
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
  }

  measure: count {
    type: count
    drill_fields: []
  }
}
