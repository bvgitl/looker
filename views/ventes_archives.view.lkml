view: ventes_archives {
  sql_table_name: `bv-prod.Matillion_Perm_Table.TF_VENTE_ARCHIVES`;;

  dimension: cd_magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
    view_label: "Magasins (actuel)"
    label: "Code Magasin"
  }

  dimension: pays {
    type: string
    sql: ${TABLE}.CD_Pays ;;
    label : "Pays"
    view_label: "Magasins (actuel)"
  }

  dimension: code_article {
    type:  string
    sql:  ${TABLE}.CD_Article ;;
    label: "Code Article"
  }

  dimension_group: dte_vte {
    type: time
    timeframes: [
      raw, date, week, month, month_name, quarter, year,
      fiscal_month_num, fiscal_quarter, fiscal_quarter_of_year, fiscal_year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.Dte_Vte ;;
    view_label: "Ventes"
  }

  dimension: typ_vente {
    type: number
    sql: ${TABLE}.Typ_Vente ;;
    view_label: "Ventes"
  }

  dimension: val_achat_gbl {
    type: number
    sql: ${TABLE}.Val_Achat_Gbl ;;
    view_label: "Ventes"
  }

  dimension: qtite {
    type: number
    sql: ${TABLE}.Qtite ;;
    view_label: "Ventes"
  }

  dimension: ca_ht {
    type: number
    sql: ${TABLE}.ca_ht ;;
    view_label: "Ventes"
  }

  dimension: marge_brute {
    type: number
    sql: ${TABLE}.marge_brute ;;
    view_label: "Ventes"
  }

  dimension: nb_ticket {
    type: number
    sql: ${TABLE}.nb_ticket ;;
    view_label: "Ventes"
  }

  filter: cd_mag {
    label: "CD Magasin"
    type: string
    view_label: "CD_magasin"
  }

  dimension: Type_retrocession {
    sql: CASE
            WHEN ${typ_vente} = 0 THEN "Hors rétrocession"
            ELSE "Rétrocession"
          END ;;
    view_label: "Ventes"
  }


########################## Calcul global des KPIs ################################

  measure: sum_ca_ht {
    type: sum
    value_format_name: eur
    sql: ${ca_ht} ;;
    view_label: "Ventes"
  }

  measure: count_dte_vente {
    hidden: yes
    value_format_name: decimal_0
    type: count_distinct
    sql: ${TABLE}.dte_vente ;;
    view_label: "Ventes"
  }

  measure: sum_marge_brute {
    hidden: yes
    value_format_name: eur
    type: sum
    sql: ${marge_brute} ;;
    view_label: "Ventes"
  }

  measure: sum_nb_ticket {
    hidden: yes
    value_format_name: decimal_0
    type: sum
    sql: ${nb_ticket} ;;
    view_label: "Ventes"
  }

  measure: sum_qtite {
    hidden: yes
    value_format_name: decimal_0
    type: sum
    sql: ${qtite};;
    view_label: "Ventes"
  }

  measure: sum_val_achat_gbl {
    hidden: yes
    value_format_name: eur
    type: sum
    sql: ${val_achat_gbl} ;;
    view_label: "Ventes"
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

# view: ventes_archives {
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
