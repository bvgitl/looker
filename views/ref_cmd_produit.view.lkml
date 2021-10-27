view: ref_cmd_produit {
  sql_table_name: `bv-prod.looker_pg.ref_cmd_produit`
    ;;

  dimension: ca {
    type: number
    sql: ${TABLE}.ca ;;
    #drill_fields: [sheet_cmd_pdt*]
  }

  dimension: cd_commande {
    type: string
    sql: ${TABLE}.cd_commande ;;
    #drill_fields: [sheet_cmd_pdt*]
  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
    drill_fields: [sheet_cmd_pdt*]
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
    #drill_fields: [sheet_cmd_pdt*]
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
    drill_fields: [sheet_cmd_pdt*]
  }

  dimension: format {
    type: string
    sql: ${TABLE}.Format ;;
    #drill_fields: [sheet_cmd_pdt*]
  }

  dimension: methode_livraison {
    type: string
    sql: ${TABLE}.methode_livraison ;;
    #drill_fields: [sheet_cmd_pdt*]
  }

  dimension: nb_article {
    type: number
    sql: ${TABLE}.nb_article ;;
    #drill_fields: [sheet_cmd_pdt*]
  }

  dimension: nb_ref_produit {
    type: number
    sql: ${TABLE}.nb_ref_produit ;;
    #drill_fields: [sheet_cmd_pdt*]
  }

  dimension: optin_email {
    type: string
    sql: ${TABLE}.optin_email ;;
  }

  dimension: optin_sms {
    type: string
    sql: ${TABLE}.optin_sms ;;
   # drill_fields: [sheet_cmd_pdt*]
  }

  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    drill_fields: [sheet_cmd_pdt*]
  }

  measure: count {
    type: count
    drill_fields: [sheet_cmd_pdt*]
  }
  set :sheet_cmd_pdt {
  fields :  [type_client,cd_commande,cd_magasin,ca,customer_id,dte_commande_date,nb_article,count]
  }
}
