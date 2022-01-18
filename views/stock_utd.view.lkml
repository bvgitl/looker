view: stock_utd {
  sql_table_name: `bv-prod.Matillion_Perm_Table.Stock_DWH_UTD`
    ;;

  dimension: CodeActeur {
    type: string
    view_label: "Code Acteur"
    sql: ${TABLE}.cd_acteur ;;
  }

  dimension: CodeArticle {
    type: string
    view_label: "Code Article"
    sql: ${TABLE}.cd_article ;;
  }

  dimension: CodeStatut {
    type: string
    view_label: "Code Statut"
    sql: ${TABLE}.cd_statut ;;
  }

  dimension: Stock {
    type: number
    view_label: "Stock"
    sql: ${TABLE}.n_stock ;;
  }

  dimension_group: DateModification {
    type: time
    view_label: "Date Modification"
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
    sql: ${Stock} ;;
    view_label: "Sum Stock"
  }


}
