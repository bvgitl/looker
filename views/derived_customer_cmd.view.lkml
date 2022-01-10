
view: derived_customer_cmd {
#   # Or, you could make this view a derived table, like this:
   derived_table: {
     sql: SELECT
         distinct customer_id as customer_id,
         nb_article
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

  measure: moy_article {
      type: average
      sql:  ${TABLE}.nb_article ;;
    }

  }
