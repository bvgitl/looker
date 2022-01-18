view: stock_utd {
  sql_table_name: `bv-prod.Matillion_Perm_Table.Stock_DWH_UTD`
    ;;

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

  dimension: Stock {
    type: number
    view_label: "Stock (courant)"
    label: "Stock"
    sql: ${TABLE}.n_stock ;;
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
    sql: ${TABLE}.Dte_creat ;;
  }

  measure: SumStock {
    type: sum
    value_format_name: decimal_0
    sql: ${Stock} ;;
    view_label: "Stock (courant)"
    label: "Sum Stock"
  }


}
