
view: derived_customer_cmd {
#   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql: SELECT
         distinct customer_id as customer_id,
         nb_article,
         nb_ref_produit,
        cd_magasin,
        Format,
        dte_commande,
        statut,
        type_client,
        methode_livraison,
       Canal_commande,
       FROM `bv-prod.looker_pg.ref_cmd_produit`
       ;;
   }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: nb_article {
    type: number
    sql: ${TABLE}.nb_article ;;

  }

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.cd_magasin ;;
  }


  dimension: canal_commande {
    type: string
    sql: ${TABLE}.Canal_commande ;;
   #drill_fields: [sheet_client*]
  }

  dimension: statut {
    type: string
    sql: ${TABLE}.statut ;;
    #drill_fields: [sheet_client*]
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
    #drill_fields: [sheet_client*]
  }

  dimension: format {
    type: string
    sql: ${TABLE}.Format;;
    #drill_fields: [sheet_client*]
    suggest_persist_for: "2 seconds"
  }


  dimension: methode_livraison {
    type: string
    sql: ${TABLE}.methode_livraison ;;
    #drill_fields: [sheet_client*]
    suggest_persist_for: "2 seconds"
  }


  dimension: nb_ref_produit {
    type: number
    sql: ${TABLE}.nb_ref_produit ;;
    #drill_fields: [sheet_client*]
  }



  dimension: type_client {
    type: string
    sql: ${TABLE}.type_client ;;
    #drill_fields: [sheet_client*]
    suggest_persist_for: "2 seconds"
  }



  measure: moy_reference {
    type: average
    #drill_fields: [sheet_client*, nb_ref_produit]
    sql:  ${TABLE}.nb_ref_produit ;;
  }




  measure: moy_article {
    type: average_distinct
    sql_distinct_key: ${customer_id} ;;
    sql: ${nb_article} ;;
    }







  }
