view: matrice_ticket {

  derived_table: {
    sql:
WITH AnalysisAxes AS
(
  SELECT DISTINCT
    t.c_magasin AS CD_Magasin,
    t.doc_date AS Ticket_Date,
    t.sales_channel AS Sales_Channel,
    arbo.N1_Division
  FROM `bv-prod.Matillion_Perm_Table.Tickets` t
  LEFT JOIN `bv-prod.Matillion_Perm_Table.ARTICLE_ARBORESCENCE` arbo ON arbo.CodeArticle = t.CD_Article
  WHERE t.sales_type = 0
/*and t.doc_date = '2024-10-22'*/
),
CrossAnalysisAxes AS
(
  SELECT
    a.Ticket_Date,
    a.CD_Magasin,
    a.Sales_Channel,
    a.N1_Division AS N1_Division_A,
    b.N1_Division AS N1_Division_B
  FROM AnalysisAxes a
  INNER JOIN AnalysisAxes b
    ON  a.Ticket_Date = b.Ticket_Date
    AND a.CD_Magasin = b.CD_Magasin
    AND a.Sales_Channel = b.Sales_Channel
),
TicketsAggregated AS
(
  SELECT DISTINCT
    t.doc_no,
    t.c_magasin AS CD_Magasin,
    t.doc_date AS Ticket_Date,
    t.sales_channel AS Sales_Channel,
    arbo.N1_Division
  FROM `bv-prod.Matillion_Perm_Table.Tickets` t
  LEFT JOIN `bv-prod.Matillion_Perm_Table.ARTICLE_ARBORESCENCE` arbo ON arbo.CodeArticle = t.CD_Article
  WHERE t.sales_type = 0
/*and t.doc_date = '2024-10-22'*/
)
SELECT
  axes.CD_Magasin,
  axes.Ticket_Date,
  axes.Sales_Channel,
  axes.N1_Division_A,
  axes.N1_Division_B,
  COUNT(DISTINCT Tickets_A.doc_no) AS Nb_Tickets_A,
  COUNT(DISTINCT Tickets_B.doc_no) AS Nb_Tickets_B,
  IF(
    COUNT(DISTINCT Tickets_A.doc_no) > COUNT(DISTINCT Tickets_B.doc_no),
    COUNT(DISTINCT Tickets_A.doc_no),
    COUNT(DISTINCT Tickets_B.doc_no)
    ) AS Nb_Tickets_AB,
  COUNT(DISTINCT IF(Tickets_A.doc_no = Tickets_B.doc_no, Tickets_A.doc_no, NULL)) AS Nb_Tickets_Common
FROM CrossAnalysisAxes axes
LEFT JOIN TicketsAggregated Tickets_A
  ON  Tickets_A.CD_Magasin = axes.CD_Magasin
  AND Tickets_A.Ticket_Date = axes.Ticket_Date
  AND Tickets_A.Sales_Channel = axes.Sales_Channel
  AND Tickets_A.N1_Division = axes.N1_Division_A
LEFT JOIN TicketsAggregated Tickets_B
  ON  Tickets_B.CD_Magasin = axes.CD_Magasin
  AND Tickets_B.Ticket_Date = axes.Ticket_Date
  AND Tickets_B.Sales_Channel = axes.Sales_Channel
  AND Tickets_B.N1_Division = axes.N1_Division_B
GROUP BY
  axes.CD_Magasin,
  axes.Ticket_Date,
  axes.Sales_Channel,
  axes.N1_Division_A,
  axes.N1_Division_B

      ;;

    persist_for: "1 hours"
  }

  dimension: primary_key {
    primary_key: yes
    sql: CONCAT(${TABLE}.CD_Magasin, '~', ${TABLE}.Ticket_Date, '~', ${TABLE}.Sales_Channel, '~', ${TABLE}.N1_Division_A, '~', ${TABLE}.N1_Division_B) ;;
  }

  dimension: CD_Magasin {
    type: string
    sql: ${TABLE}.CD_Magasin ;;
  }

  dimension: Sales_Channel {
    type: string
    sql: ${TABLE}.Sales_Channel ;;
  }

  dimension: N1_Division_A {
    type: string
    sql: ${TABLE}.N1_Division_A ;;
  }

  dimension: N1_Division_B {
    type: string
    sql: ${TABLE}.N1_Division_B ;;
  }

  dimension_group: Ticket_Date {
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
    sql: ${TABLE}.Ticket_Date ;;
  }

  dimension: Nb_Tickets_A {
    type: number
    sql: ${TABLE}.Nb_Tickets_A ;;
  }

  dimension: Nb_Tickets_B {
    type: number
    sql: ${TABLE}.Nb_Tickets_B ;;
  }

  dimension: Nb_Tickets_AB {
    type: number
    sql: ${TABLE}.Nb_Tickets_AB ;;
  }

  dimension: Nb_Tickets_Common {
    type: number
    sql: ${TABLE}.Nb_Tickets_Common ;;
  }

  measure: Correlation_Numerator {
    type: sum
    sql: ${Nb_Tickets_Common} ;;
  }

  measure: Correlation_Denominator {
    type: sum
    sql: ${Nb_Tickets_AB} ;;
  }

  measure: Correlation {
    type: number
    sql: ${Correlation_Numerator} / NULLIF(${Correlation_Denominator}, 0) ;;
    value_format_name: percent_2
  }

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
