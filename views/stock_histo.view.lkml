view: stock_histo {
  derived_table: {
    sql:
      SELECT
      d.day AS date_stock,
      s.cd_acteur,
      s.cd_statut,
      CAST(s.cd_article AS STRING) AS cd_article,
      s.n_stock
      FROM Matillion_Perm_Table.Stock_DWH_Histo s
      INNER JOIN
      (
        SELECT day FROM UNNEST( GENERATE_DATE_ARRAY(DATE('2018-01-02'), CURRENT_DATE(), INTERVAL 1 DAY) ) AS day
      ) d ON s.ScdDateDebut <= d.day AND s.ScdDateFin > d.day ;;
  }

  dimension: compound_primary_key {
    primary_key: yes
    hidden: yes
    type: string
    sql: CONCAT(${TABLE}.cd_acteur, ' ',${TABLE}.cd_article, ' ', ${TABLE}.date_stock) ;;
  }

  dimension: cd_acteur {
    type: string
    sql: ${TABLE}.cd_acteur ;;
    hidden:  yes
  }

  dimension: cd_article {
    type: string
    sql: ${TABLE}.cd_article ;;
    hidden:  yes
  }

  dimension: cd_statut {
    type: string
    sql: ${TABLE}.cd_statut ;;
  }

  dimension: n_stock {
    type: number
    sql: ${TABLE}.n_stock ;;
    hidden:  yes
  }

  dimension_group: date_stock {
    type: time
    timeframes: [
      raw,
      date
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.date_stock ;;
  }

  measure: Stock {
    type: sum
    value_format_name: decimal_0
    sql: ${n_stock} ;;
    label: "Stock"
  }

  measure: StockValeur {
    type: sum
    value_format_name: decimal_2
    sql: ${n_stock} * ${article_dwh.n_prix_achat_net} ;;
    label: "Stock Valeur"
  }

  filter: date_filter {                 ### Choisir la période qu'on souhaite obtenir les résultats###
    label: "Période"
    type: date
    view_label: "Période"
  }

  dimension: is_start_date_filter  {
    type: yesno
    hidden: yes
    sql: ${TABLE}.date_stock = CAST({% date_start date_filter %} AS DATETIME) ;;
  }

  dimension: is_end_date_filter  {
    type: yesno
    hidden: yes
    sql: ${TABLE}.date_stock = CAST({% date_end date_filter %} AS DATETIME) ;;
  }

  measure: stock_start_date_filter {
    type: sum
    label: "Stock Début Période"
    sql: ${TABLE}.n_stock ;;
    filters: [is_start_date_filter: "yes"]
    view_label: "Période"
  }

  measure: stock_end_date_filter {
    type: sum
    label: "Stock Fin Période"
    sql: ${TABLE}.n_stock ;;
    filters: [is_end_date_filter: "yes"]
    view_label: "Période"
  }

  measure: ratio_ecoulement_stock_periode {
    type: number
    value_format_name: percent_2
    label: "Ecoulement Stock durant Période"
    sql:  (${stock_start_date_filter}-${stock_end_date_filter}) / nullif(${stock_start_date_filter}, 0) ;;
    view_label: "Période"
  }

}
