view: suivi_ticket {

  sql_table_name: `bv-prod.Matillion_Perm_Table.Tickets` ;;

  dimension: ticket_id {
    type: string
    sql: ${TABLE}.doc_no ;;
  }

  dimension: client_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: magasin_id {
    type: string
    sql: ${TABLE}.c_magasin ;;
  }

  dimension: code_article {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension_group: dt_ticket {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: cast(${TABLE}.doc_date as DATE) ;;
  }

  dimension: canal_vente {
    type: string
    sql: IF(${TABLE}.sales_channel = 'S','Mag','Web');;
  }

  dimension: prix_vente_TTC {
    type: number
    sql:  ${TABLE}.app_sales_price_TTC ;;
  }

  dimension: prix_vente_HT {
    type: number
    sql:  ${TABLE}.app_sales_price_HT ;;
  }

  dimension: statut {
    type:  string
    sql:  ${TABLE}.item_status ;;
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  measure: count_client_id {
    type: count_distinct
    sql: ${client_id} ;;
  }

  measure: count_code_article {
    type: count_distinct
    sql: ${code_article} ;;
  }

  measure: count_ticket {
    type: count_distinct
    sql: ${ticket_id} ;;
  }

  measure: count_magasin {
    type: count_distinct
    sql: ${magasin_id} ;;
  }

  measure: avg_qtite_par_ticket {
    label: "Moyenne articles/ticket"
    type:  number
    sql: ROUND(SUM(${qtite})/NULLIF(${count_ticket},0),1) ;;
  }

  measure: avg_panier_TTC {
    label: "Panier moyen TTC"
    sql: ROUND(SUM(${prix_vente_TTC})/${count_ticket},1);;
  }

  measure: avg_panier_HT {
    label: "Panier moyen HT"
    sql: ROUND(SUM(${prix_vente_HT})/${count_ticket},1);;
  }

  measure: avg_ca_TTC {
    label: "CA moyen TTC"
    type: number
    sql: ROUND(SUM(${prix_vente_TTC})/${count_client_id},1);;
  }

  measure: avg_ca_HT {
    label: "CA moyen HT"
    type: number
    sql: ROUND(SUM(${prix_vente_HT})/${count_client_id},1);;
  }

  measure: sum_ca_TTC {
    label: "CA Total TTC"
    type:  number
    sql: ROUND(SUM(${prix_vente_TTC}),0) ;;
  }

  measure: sum_ca_HT {
    label: "CA Total HT"
    type:  number
    sql: ROUND(SUM(${prix_vente_HT}),0) ;;
  }

  measure: frequence_client {
    label : "Frequence même client"
    sql:  ROUND(${count_ticket}/${count_client_id},2) ;;
  }

  # # You can specify the table name if it's different from the view name:
  # sql_table_name: my_schema_name.tester ;;
  #
  # # Define your dimensions and measures here, like this:
  # dimension: user_id {
  #   description: "Unique ID for each user that has ordered"
  #   type: number
  #   sql: ${TABLE}.user_id ;;
  # }
  #
  # dimension: lifetime_orders {
  #   description: "The total number of orders for each user"
  #   type: number
  #   sql: ${TABLE}.lifetime_orders ;;
  # }
  #
  # dimension_group: most_recent_purchase {
  #   description: "The date when each user last ordered"
  #   type: time
  #   timeframes: [date, week, month, year]
  #   sql: ${TABLE}.most_recent_purchase_at ;;
  # }
  #
  # measure: total_lifetime_orders {
  #   description: "Use this for counting lifetime orders across many users"
  #   type: sum
  #   sql: ${lifetime_orders} ;;
  # }
}

# view: suivi_ticket {
#   # Or, you could make this view a derived table, like this:
#   derived_table: {
#     sql: SELECT
#         user_id as user_id
#         , COUNT(*) as lifetime_orders
#         , MAX(orders.created_at) as most_recent_purchase_at
#       FROM orders
#       GROUP BY user_id
#       ;;
#   }
#
#   # Define your dimensions and measures here, like this:
#   dimension: user_id {
#     description: "Unique ID for each user that has ordered"
#     type: number
#     sql: ${TABLE}.user_id ;;
#   }
#
#   dimension: lifetime_orders {
#     description: "The total number of orders for each user"
#     type: number
#     sql: ${TABLE}.lifetime_orders ;;
#   }
#
#   dimension_group: most_recent_purchase {
#     description: "The date when each user last ordered"
#     type: time
#     timeframes: [date, week, month, year]
#     sql: ${TABLE}.most_recent_purchase_at ;;
#   }
#
#   measure: total_lifetime_orders {
#     description: "Use this for counting lifetime orders across many users"
#     type: sum
#     sql: ${lifetime_orders} ;;
#   }
# }
