view: stock_utd {
  sql_table_name: `bv-prod.Matillion_Perm_Table.Stock_DWH_UTD`
    ;;

  dimension: CodeActeurCodeArticle {
    type: string
    primary_key: yes
    hidden: yes
    sql: ${TABLE}.cd_acteur || '#' || CAST(${TABLE}.cd_article AS STRING) ;;
  }

  dimension: CodeActeur {
    type: string
    view_label: "Stock (courant)"
    label: "Code Acteur"
    sql: ${TABLE}.cd_acteur ;;
  }

  dimension: CodeArticle {
    type: string
    view_label: "Stock (courant)"
    label: "Code Article"
    sql: CAST(${TABLE}.cd_article AS STRING) ;;
  }

  dimension: CodeStatut {
    type: string
    view_label: "Stock (courant)"
    label: "Code Statut"
    sql: ${TABLE}.cd_statut ;;
  }

  dimension: n_stock {
    type: number
    hidden:  no
    sql: ${TABLE}.n_stock ;;
  }

  dimension: Detention {
    type: number
    hidden:  yes
    sql: CASE WHEN ${n_stock} > 0 THEN 1 ELSE 0 END ;;
  }

  dimension_group: DateModification {
    type: time
    view_label: "Stock (courant)"
    label: "Date Modification"
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
    sql: ${TABLE}.date_modification ;;
  }

  measure : NbMagStock {
    type: count_distinct
    value_format_name: decimal_0
    sql: ${CodeActeur};;
    view_label: "Stock (courant)"
    label: "NbMagasin Stock"
  }

  measure: Stock {
    type: sum
    value_format_name: decimal_0
    sql: ${n_stock} ;;
    view_label: "Stock (courant)"
    label: "Stock"
  }

  measure : StockMax {
    type: max
    value_format_name: decimal_0
    sql: ${n_stock} ;;
    view_label: "Stock (courant)"
    label: "Stock Max"
  }


  measure: StockValeur {
    type: sum
    value_format_name: decimal_0
    sql: ${n_stock} * ${article_dwh.n_prix_achat_net} ;;
    view_label: "Stock (courant)"
    label: "Stock Valeur"
  }

  measure: TauxDetention {
    type: sum_distinct
    sql_distinct_key: ${CodeActeur} ;;
    sql:  ${Detention} ;;

  }

}
