view: suivi_fid {

  sql_table_name: `bv-prod.Cheetah_Export_Vue.WelcomeFid_Email` ;;
  #sql_table_name: `bv-prod.CRM_Stats.Suivi_RCU_Looker_Fid` ;;

   dimension: userId_fid {
     primary_key: yes
     type: number
     sql: ${TABLE}.loyalty_id ;;
   }

  dimension: validity_fid {
    type: string
    sql: sql: IF(${TABLE}.validity = '1','Oui','Non') ;;
  }

  dimension: store_fid {
    type: string
    sql: ${TABLE}.store ;;
  }

  dimension: email_fid {
    type: string
    sql: ${TABLE}.email ;;
  }

  #
  dimension_group: dt_creation_carte_fid {
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
    sql: cast(${TABLE}.loyalty_date as DATE) ;;
  }

  measure: count_carte_fid {
    type: count_distinct
    sql: ${userId_fid} ;;
  }

  measure: count_store_fid {
    type: count_distinct
    sql: ${store_fid} ;;
  }

  measure: count_email_fid {
    type: count_distinct
    sql: ${email_fid} ;;
  }
}

# view: suivi_fid {
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
